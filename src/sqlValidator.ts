const FORBIDDEN_KEYWORDS = [
  "INSERT",
  "UPDATE",
  "DELETE",
  "DROP",
  "ALTER",
  "TRUNCATE",
];

export function validateSQL(raw: string): string {
  // Strip markdown code fences if the LLM wraps the output
  let sql = raw.replace(/```sql\s*/gi, "").replace(/```/g, "").trim();

  // Strip common LLM prefixes like "SQL:", "Query:", "Here is the query:", etc.
  sql = sql.replace(/^(?:SQL|Query|Here(?:'s| is)(?: the)?(?: SQL)?(?: query)?)\s*:\s*/i, "").trim();

  // If the LLM added explanation text before the SELECT, extract from the first SELECT
  if (!sql.toUpperCase().startsWith("SELECT")) {
    const selectIndex = sql.toUpperCase().indexOf("SELECT");
    if (selectIndex > 0) {
      sql = sql.slice(selectIndex);
    }
  }

  // Remove trailing semicolons for safety
  sql = sql.replace(/;\s*$/, "").trim();

  const upper = sql.toUpperCase();

  if (!upper.startsWith("SELECT")) {
    throw new Error(`Rejected: query does not start with SELECT.\n→ ${sql}`);
  }

  for (const kw of FORBIDDEN_KEYWORDS) {
    // Match keyword as a whole word to avoid false positives (e.g. "DELETED_AT")
    const regex = new RegExp(`\\b${kw}\\b`, "i");
    if (regex.test(sql)) {
      throw new Error(`Rejected: query contains forbidden keyword "${kw}".\n→ ${sql}`);
    }
  }

  // Auto-append LIMIT 50 when missing
  if (!/\bLIMIT\b/i.test(sql)) {
    sql += " LIMIT 50";
  }

  return sql;
}
