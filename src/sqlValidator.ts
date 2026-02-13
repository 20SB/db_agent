const FORBIDDEN_KEYWORDS = [
  "INSERT",
  "UPDATE",
  "DELETE",
  "DROP",
  "ALTER",
  "TRUNCATE",
];

export function validateSQL(raw: string): string {
  let sql: string;

  // If the LLM wrapped SQL in code fences, extract ONLY the content between them
  const fenceMatch = raw.match(/```(?:sql)?\s*\n?([\s\S]*?)```/i);
  if (fenceMatch) {
    sql = fenceMatch[1].trim();
  } else {
    sql = raw.trim();
  }

  // Strip common LLM prefixes like "SQL:", "Query:", "Here is the query:", etc.
  sql = sql.replace(/^(?:SQL|Query|Here(?:'s| is)(?: the)?(?: SQL)?(?: query)?)\s*:\s*/i, "").trim();

  // If the LLM added explanation text before the SELECT, extract from the first SELECT
  if (!sql.toUpperCase().startsWith("SELECT")) {
    const selectIndex = sql.toUpperCase().indexOf("SELECT");
    if (selectIndex > 0) {
      sql = sql.slice(selectIndex);
    }
  }

  // Strip trailing LLM commentary/explanation that appears after the SQL.
  // The LLM often appends "Answer: ...", "Based on ...", "This query ..." etc.
  // These patterns would never appear at the start of a line in valid SQL.
  sql = sql.replace(
    /\n\s*(?:Answer\s*:|Based on\b|Note\s*:|Explanation\s*:|This (?:query|will|returns?|selects?|gets?|counts?|finds?|shows?|retrieves?)\b|Here(?:'s| is)\b|The (?:above|query|result|output)\b|Output\s*:|Result\s*:|Returns?\s*:|I (?:used|wrote|created)\b|- \*\*|\*\*|#{1,3}\s)[\s\S]*/i,
    "",
  ).trim();

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
