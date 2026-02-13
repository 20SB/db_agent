import chalk from "chalk";
import { LLMProvider } from "./types";
import { validateSQL } from "./sqlValidator";
import { executeQuery } from "./db";

export interface SmartRetryResult {
  sql: string;
  rows: Record<string, unknown>[];
  discoveredData: Record<string, unknown[]>;
}

/**
 * When a query returns 0 rows, this module:
 * 1. Asks the LLM to generate exploration queries (SELECT DISTINCT on filtered columns)
 * 2. Executes them to discover actual DB values
 * 3. Sends discovered values back to the LLM to rewrite the query with real data
 */
export async function smartRetry(
  llm: LLMProvider,
  schema: string,
  question: string,
  failedSQL: string
): Promise<SmartRetryResult | null> {
  console.log(chalk.yellow("\n[smart-retry] 0 rows returned — exploring DB values…"));

  // Step 1 — Ask LLM for exploration queries
  const rawExploration = await llm.generateExplorationQueries(schema, question, failedSQL);
  const explorationQueries = rawExploration
    .split("\n")
    .map((l) => l.trim())
    .filter((l) => l.toUpperCase().startsWith("SELECT"));

  if (explorationQueries.length === 0) {
    console.log(chalk.gray("[smart-retry] No exploration queries generated. Skipping."));
    return null;
  }

  // Step 2 — Execute exploration queries and collect results
  const discoveredData: Record<string, unknown[]> = {};

  for (const eq of explorationQueries) {
    try {
      const safeEQ = validateSQL(eq);
      console.log(chalk.gray(`[explore] ${safeEQ}`));
      const rows = await executeQuery(safeEQ);
      if (rows.length > 0) {
        const label = safeEQ.replace(/\s+/g, " ").slice(0, 80);
        discoveredData[label] = rows;
      }
    } catch {
      // Skip invalid exploration queries silently
    }
  }

  if (Object.keys(discoveredData).length === 0) {
    console.log(chalk.gray("[smart-retry] No useful data discovered. Skipping."));
    return null;
  }

  console.log(
    chalk.yellow(
      `[smart-retry] Discovered values from ${Object.keys(discoveredData).length} query(ies). Refining…`
    )
  );

  // Step 3 — Ask LLM to rewrite query using discovered real values
  const rawRefined = await llm.refineSQL(schema, question, failedSQL, discoveredData);
  const refinedSQL = validateSQL(rawRefined);
  console.log(chalk.green(`[refined] ${refinedSQL}`));

  // Step 4 — Execute refined query
  const rows = await executeQuery(refinedSQL);
  console.log(chalk.green(`[rows]    ${rows.length} row(s) returned`));

  return { sql: refinedSQL, rows, discoveredData };
}
