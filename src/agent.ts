import * as dotenv from "dotenv";
import * as fs from "fs";
import * as path from "path";
import * as readline from "readline";
import chalk from "chalk";

dotenv.config({ path: path.resolve(__dirname, "../.env") });

import { LLMProvider, AgentResult, ConversationTurn, ProgressCallback } from "./types";
import { GeminiProvider } from "./providers/gemini.provider";
import { AnthropicProvider } from "./providers/anthropic.provider";
import { validateSQL } from "./sqlValidator";
import { executeQuery, closePool } from "./db";
import { estimateQueryCost } from "./costEstimator";
import { formatResult } from "./formatter";
import { smartRetry } from "./smartRetry";
import { getLearningsForPrompt } from "./learnings";

// ── Provider factory ────────────────────────────────────────────────
export function createProvider(): LLMProvider {
  const provider = (process.env.LLM_PROVIDER || "gemini").toLowerCase();
  switch (provider) {
    case "anthropic":
      return new AnthropicProvider();
    case "gemini":
      return new GeminiProvider();
    default:
      throw new Error(`Unknown LLM_PROVIDER: ${provider}`);
  }
}

// ── Schema loader ───────────────────────────────────────────────────
export function loadSchema(): string {
  const schemaPath = process.env.SCHEMA_PATH;
  if (!schemaPath) {
    console.warn("[warn] SCHEMA_PATH not set — using empty schema context.");
    return "-- no schema provided --";
  }
  const resolved = path.resolve(schemaPath);
  if (!fs.existsSync(resolved)) {
    throw new Error(`Schema file not found: ${resolved}`);
  }
  return fs.readFileSync(resolved, "utf-8");
}

// ── Prompt helper ───────────────────────────────────────────────────
function promptUser(rl: readline.Interface, message: string): Promise<string> {
  return new Promise((resolve) => rl.question(message, (ans) => resolve(ans.trim())));
}

// ── Human-in-the-loop: ask user for help, retry up to N times ───────
async function userAssistedRetry(
  llm: LLMProvider,
  schema: string,
  question: string,
  failedSQL: string,
  discoveredData: Record<string, unknown[]>,
  rl: readline.Interface,
): Promise<{ sql: string; rows: Record<string, unknown>[] } | null> {
  const MAX_HINTS = 3;

  for (let attempt = 1; attempt <= MAX_HINTS; attempt++) {
    console.log(
      chalk.yellowBright(
        `\n[help-needed] Still 0 rows. Can you give me a hint? (attempt ${attempt}/${MAX_HINTS})`,
      ),
    );
    console.log(
      chalk.gray(
        '  Examples: "region is stored as zone_name", "use city column with Delhi, Jaipur", "try ILIKE"',
      ),
    );

    const hint = await promptUser(rl, chalk.yellowBright("Your hint (or 'skip'): "));

    if (!hint || hint.toLowerCase() === "skip") {
      console.log(chalk.gray("[help] Skipped by user."));
      return null;
    }

    console.log(chalk.yellow("[help] Processing your hint with AI…"));
    const rawSQL = await llm.refineWithHint(schema, question, failedSQL, hint, discoveredData);

    const sql = validateSQL(rawSQL);
    console.log(chalk.green(`[hint-sql] ${sql}`));

    const rows = await executeQuery(sql);
    console.log(chalk.green(`[rows]     ${rows.length} row(s) returned`));

    if (rows.length > 0) {
      return { sql, rows };
    }

    failedSQL = sql; // carry forward the latest attempt
    console.log(chalk.gray("[help] Still 0 rows. Let's try again…"));
  }

  console.log(chalk.gray("[help] Max hints reached. Proceeding with 0 rows."));
  return null;
}

// ── Core agent pipeline ─────────────────────────────────────────────
export async function runAgent(
  question: string,
  llm: LLMProvider,
  schema: string,
  history: ConversationTurn[],
  rl: readline.Interface | null,
  onProgress?: ProgressCallback,
): Promise<AgentResult> {
  const emit = (step: string, detail?: string) => {
    console.log(step);
    if (onProgress) onProgress(step, detail);
  };

  // Enrich schema with past learnings so LLM avoids known mistakes
  const learningsCtx = getLearningsForPrompt();
  const enrichedSchema = learningsCtx ? schema + learningsCtx : schema;

  // Step 1 — Generate SQL
  emit("[1/5] Generating SQL…", "thinking");
  const rawSQL = await llm.generateSQL(enrichedSchema, question, history);
  console.log("rawSQL", rawSQL);

  // Step 2 — Validate
  emit("[2/5] Validating SQL…", "validating");
  let sql = validateSQL(rawSQL);
  console.log(`[sql]  ${sql}`);

  // Step 3 — Cost estimate
  emit("[3/5] Estimating query cost…", "estimating");
  const cost = await estimateQueryCost(sql);
  console.log(`[cost] ${cost.plan_summary}`);

  // Step 4 — Execute
  emit("[4/5] Executing query…", "executing");
  let rows = await executeQuery(sql);
  console.log(`[rows] ${rows.length} row(s) returned`);

  // Step 4b — Smart retry if 0 rows
  let retried = false;
  let discoveredData: Record<string, unknown[]> = {};

  if (rows.length === 0) {
    emit("[4/5] No results — smart retrying…", "retrying");
    const retryResult = await smartRetry(llm, schema, question, sql);
    if (retryResult) {
      discoveredData = retryResult.discoveredData;
      if (retryResult.rows.length > 0) {
        sql = retryResult.sql;
        rows = retryResult.rows;
        retried = true;
      }
    }

    // Step 4c — Human-in-the-loop if still 0 rows
    if (rows.length === 0 && rl) {
      const hintResult = await userAssistedRetry(llm, schema, question, sql, discoveredData, rl);
      if (hintResult && hintResult.rows.length > 0) {
        sql = hintResult.sql;
        rows = hintResult.rows;
        retried = true;
      }
    }
  }

  // Step 5 — Summarize
  emit("[5/5] Summarizing results…", "summarizing");
  const summary = await llm.summarizeResults(question, sql, rows, history);

  if (onProgress) onProgress("Done!", "done");

  return {
    generated_sql: sql,
    query_cost: retried ? await estimateQueryCost(sql) : cost,
    row_count: rows.length,
    answer_summary: summary,
    raw_data_preview: rows.slice(0, 10),
    retried,
  };
}

// ── Interactive REPL ────────────────────────────────────────────────
async function startREPL(llm: LLMProvider, schema: string): Promise<void> {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });
  const history: ConversationTurn[] = [];

  console.log("DB Agent — interactive mode (type 'exit' or 'quit' to stop)\n");

  const ask = (): void => {
    rl.question("You: ", async (input) => {
      const question = input.trim();
      if (!question || ["exit", "quit"].includes(question.toLowerCase())) {
        console.log("Goodbye!");
        rl.close();
        await closePool();
        return;
      }

      try {
        const result = await runAgent(question, llm, schema, history, rl);

        // Update conversation memory
        history.push({ role: "user", content: question });
        history.push({
          role: "assistant",
          content: `SQL: ${result.generated_sql}\nAnswer: ${result.answer_summary}`,
        });

        // Keep memory bounded — last 20 turns (10 Q&A pairs)
        while (history.length > 20) history.splice(0, 2);

        console.log(formatResult(result));
      } catch (err: unknown) {
        const message = err instanceof Error ? err.message : String(err);
        console.error(`[error] ${message}\n`);
      }

      ask();
    });
  };

  ask();
}

// ── CLI entrypoint ──────────────────────────────────────────────────
async function main(): Promise<void> {
  const args = process.argv.slice(2);
  const telegramFlag = args.includes("--telegram");
  const question = args
    .filter((a) => a !== "--telegram")
    .join(" ")
    .trim();

  const llm = createProvider();
  const schema = loadSchema();

  // Telegram bot mode (dynamic require to avoid circular dependency)
  if (telegramFlag) {
    const { startTelegramBot } = require("./telegram");
    startTelegramBot(llm, schema);
    return;
  }

  // Single-shot mode: pass question as CLI arg
  if (question) {
    // Create a temporary rl for hint prompts even in single-shot mode
    const rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout,
    });
    try {
      const result = await runAgent(question, llm, schema, [], rl);
      console.log(formatResult(result));
    } catch (err: unknown) {
      const message = err instanceof Error ? err.message : String(err);
      console.error(`[error] ${message}`);
      process.exit(1);
    } finally {
      rl.close();
      await closePool();
    }
    return;
  }

  // Interactive REPL mode: no arg — start conversation loop
  await startREPL(llm, schema);
}

main();
