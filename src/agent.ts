import * as dotenv from "dotenv";
import * as fs from "fs";
import * as path from "path";
import * as readline from "readline";

dotenv.config({ path: path.resolve(__dirname, "../.env") });

import { LLMProvider, AgentResult, ConversationTurn } from "./types";
import { GeminiProvider } from "./providers/gemini.provider";
import { AnthropicProvider } from "./providers/anthropic.provider";
import { validateSQL } from "./sqlValidator";
import { executeQuery, closePool } from "./db";
import { estimateQueryCost } from "./costEstimator";
import { formatResult } from "./formatter";

// ── Provider factory ────────────────────────────────────────────────
function createProvider(): LLMProvider {
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
function loadSchema(): string {
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

// ── Core agent pipeline ─────────────────────────────────────────────
async function runAgent(
  question: string,
  llm: LLMProvider,
  schema: string,
  history: ConversationTurn[]
): Promise<AgentResult> {
  // Step 1 — Generate SQL
  console.log("\n[1/5] Generating SQL…");
  const rawSQL = await llm.generateSQL(schema, question, history);

  // Step 2 — Validate
  console.log("[2/5] Validating SQL…");
  const sql = validateSQL(rawSQL);
  console.log(`[sql]  ${sql}`);

  // Step 3 — Cost estimate
  console.log("[3/5] Estimating query cost…");
  const cost = await estimateQueryCost(sql);
  console.log(`[cost] ${cost.plan_summary}`);

  // Step 4 — Execute
  console.log("[4/5] Executing query…");
  const rows = await executeQuery(sql);
  console.log(`[rows] ${rows.length} row(s) returned`);

  // Step 5 — Summarize
  console.log("[5/5] Summarizing results…");
  const summary = await llm.summarizeResults(question, sql, rows, history);

  return {
    generated_sql: sql,
    query_cost: cost,
    row_count: rows.length,
    answer_summary: summary,
    raw_data_preview: rows.slice(0, 10),
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
        const result = await runAgent(question, llm, schema, history);

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
  const llm = createProvider();
  const schema = loadSchema();
  const question = process.argv.slice(2).join(" ").trim();

  // Single-shot mode: pass question as CLI arg
  if (question) {
    try {
      const result = await runAgent(question, llm, schema, []);
      console.log(formatResult(result));
    } catch (err: unknown) {
      const message = err instanceof Error ? err.message : String(err);
      console.error(`[error] ${message}`);
      process.exit(1);
    } finally {
      await closePool();
    }
    return;
  }

  // Interactive REPL mode: no arg — start conversation loop
  await startREPL(llm, schema);
}

main();
