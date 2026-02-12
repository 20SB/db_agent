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
