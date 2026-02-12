export interface AgentResult {
  generated_sql: string;
  row_count: number;
  answer_summary: string;
  raw_data_preview: Record<string, unknown>[];
}

export interface LLMProvider {
  generateSQL(schema: string, question: string): Promise<string>;
  summarizeResults(
    question: string,
    sql: string,
    rows: Record<string, unknown>[]
  ): Promise<string>;
}
