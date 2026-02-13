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
  retried: boolean;
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
  generateExplorationQueries(
    schema: string,
    question: string,
    failedSQL: string
  ): Promise<string>;
  refineSQL(
    schema: string,
    question: string,
    failedSQL: string,
    discoveredData: Record<string, unknown[]>
  ): Promise<string>;
  refineWithHint(
    schema: string,
    question: string,
    failedSQL: string,
    userHint: string,
    discoveredData: Record<string, unknown[]>
  ): Promise<string>;
  summarizeResults(
    question: string,
    sql: string,
    rows: Record<string, unknown>[],
    history: ConversationTurn[]
  ): Promise<string>;
}
