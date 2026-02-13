import { ConversationTurn } from "../types";

export function buildSystemPrompt(schema: string): string {
  return [
    "You are a PostgreSQL expert. Given a database schema and a natural language question,",
    "generate a single safe READ-ONLY SQL SELECT query that answers the question.",
    "Rules:",
    "- Output ONLY the raw SQL. No markdown, no explanation, no code fences.",
    "- Never use INSERT, UPDATE, DELETE, DROP, ALTER, or TRUNCATE.",
    "- Always include a LIMIT clause (max 50) unless the user explicitly specifies one.",
    "- Use conversation history to resolve references like 'those', 'that table', 'group it by', etc.",
    "",
    "Database schema:",
    schema,
  ].join("\n");
}

export function buildExplorationPrompt(
  schema: string,
  question: string,
  failedSQL: string
): string {
  return [
    "You are a PostgreSQL expert. A query returned 0 rows. The user's question likely uses",
    "general/geographic/conceptual terms that don't match exact DB values.",
    "",
    "Original question:", question,
    "Failed SQL:", failedSQL,
    "",
    "Database schema:", schema,
    "",
    "Generate 1-3 short SELECT DISTINCT queries to discover what values actually exist",
    "in the columns that were filtered. For example, if the query filtered on region or city,",
    "list the distinct values in those columns.",
    "",
    "Rules:",
    "- Output ONLY raw SQL queries, one per line.",
    "- Each query must be a SELECT statement with LIMIT 100.",
    "- No markdown, no explanation, no code fences, no numbering.",
  ].join("\n");
}

export function buildRefinePrompt(
  schema: string,
  question: string,
  failedSQL: string,
  discoveredData: Record<string, unknown[]>
): string {
  return [
    "You are a PostgreSQL expert. A previous query returned 0 rows because the filter values",
    "didn't match the actual data. Here are the real values from the database:",
    "",
    JSON.stringify(discoveredData, null, 2),
    "",
    "Original question:", question,
    "Failed SQL:", failedSQL,
    "",
    "Database schema:", schema,
    "",
    "Using your general knowledge (e.g., which cities belong to North India, which categories",
    "map to a concept, etc.), rewrite the query using the ACTUAL values from the database above.",
    "Use IN (...) clauses with the matching values.",
    "",
    "Rules:",
    "- Output ONLY the raw SQL. No markdown, no explanation, no code fences.",
    "- Must be a SELECT statement with LIMIT 50 unless user specified otherwise.",
  ].join("\n");
}

export function buildHintRefinePrompt(
  schema: string,
  question: string,
  failedSQL: string,
  userHint: string,
  discoveredData: Record<string, unknown[]>
): string {
  const hasData = Object.keys(discoveredData).length > 0;
  return [
    "You are a PostgreSQL expert. A query returned 0 rows even after auto-retry.",
    "The user has provided a hint to help you fix the query.",
    "",
    "Original question:", question,
    "Failed SQL:", failedSQL,
    "",
    "User's hint:", userHint,
    "",
    ...(hasData
      ? ["Discovered DB values:", JSON.stringify(discoveredData, null, 2), ""]
      : []),
    "Database schema:", schema,
    "",
    "Using the user's hint and your general knowledge, rewrite the SQL query so it",
    "returns the correct results. The hint may clarify column names, actual values,",
    "table relationships, or business logic the schema alone doesn't reveal.",
    "",
    "Rules:",
    "- Output ONLY the raw SQL. No markdown, no explanation, no code fences.",
    "- Must be a SELECT statement with LIMIT 50 unless user specified otherwise.",
  ].join("\n");
}

export function buildSummaryPrompt(
  question: string,
  sql: string,
  rows: Record<string, unknown>[]
): string {
  return [
    "The user asked:", question,
    "",
    "The following SQL was executed:", sql,
    "",
    "Results (JSON):", JSON.stringify(rows, null, 2),
    "",
    "Provide a concise, human-readable summary answering the original question.",
    "Output ONLY the summary text, nothing else.",
  ].join("\n");
}

export function formatHistory(
  history: ConversationTurn[]
): { role: "user" | "assistant"; content: string }[] {
  return history.map((t) => ({ role: t.role, content: t.content }));
}

export type { ConversationTurn };
