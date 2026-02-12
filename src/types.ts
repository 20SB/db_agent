export interface QueryCost {
  estimated_rows: number;
  estimated_cost: number;
  plan_summary: string;
}

export interface AgentResult {
  generated_sql: string;
  query_cost: QueryCost;
  row_count: number;
  answer_summary: string;
  raw_data_preview: Record<string, unknown>[];
}

export interface ConversationTurn {
  role: "user" | "assistant";
  content: string;
}

export interface LLMProvider {
  generateSQL(
    schema: string,
    question: string,
    history: ConversationTurn[]
  ): Promise<string>;
  summarizeResults(
    question: string,
    sql: string,
    rows: Record<string, unknown>[],
    history: ConversationTurn[]
  ): Promise<string>;
}
