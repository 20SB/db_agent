import * as dotenv from "dotenv";
import * as fs from "fs";
import * as path from "path";
import * as readline from "readline";

dotenv.config({ path: path.resolve(__dirname, "../.env") });

import { LLMProvider, AgentResult } from "./types";
import { GeminiProvider } from "./providers/gemini.provider";
import { AnthropicProvider } from "./providers/anthropic.provider";
import { validateSQL } from "./sqlValidator";
import { executeQuery, closePool } from "./db";

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
async function runAgent(question: string): Promise<AgentResult> {
  const llm = createProvider();
  const schema = loadSchema();

  // Step 1 — Generate SQL
  console.log("[1/4] Generating SQL…");
  const rawSQL = await llm.generateSQL(schema, question);

  // Step 2 — Validate
  console.log("[2/4] Validating SQL…");
  const sql = validateSQL(rawSQL);
  console.log(`[sql]  ${sql}`);

  // Step 3 — Execute
  console.log("[3/4] Executing query…");
  const rows = await executeQuery(sql);
  console.log(`[rows] ${rows.length} row(s) returned`);

  // Step 4 — Summarize
  console.log("[4/4] Summarizing results…");
  const summary = await llm.summarizeResults(question, sql, rows);

  return {
    generated_sql: sql,
    row_count: rows.length,
    answer_summary: summary,
    raw_data_preview: rows.slice(0, 10),
  };
}

// ── CLI entrypoint ──────────────────────────────────────────────────
async function main(): Promise<void> {
  // Accept question as CLI arg or prompt interactively
  let question = process.argv.slice(2).join(" ").trim();

  if (!question) {
    const rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout,
    });
    question = await new Promise<string>((resolve) =>
      rl.question("Ask a question about your database: ", (ans) => {
        rl.close();
        resolve(ans.trim());
      })
    );
  }

  if (!question) {
    console.error("No question provided. Exiting.");
    process.exit(1);
  }

  try {
    const result = await runAgent(question);
    console.log("\n" + JSON.stringify(result, null, 2));
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : String(err);
    console.error(`[error] ${message}`);
    process.exit(1);
  } finally {
    await closePool();
  }
}

main();
