import Anthropic from "@anthropic-ai/sdk";
import { LLMProvider, ConversationTurn } from "../types";
import {
  buildSystemPrompt,
  buildExplorationPrompt,
  buildRefinePrompt,
  buildHintRefinePrompt,
  buildSummaryPrompt,
  formatHistory,
} from "./llm.interface";

const MODEL = "claude-sonnet-4-5-20250929";

export class AnthropicProvider implements LLMProvider {
  private client: Anthropic;

  constructor() {
    this.client = new Anthropic();
  }

  private async ask(system: string, userMsg: string): Promise<string> {
    const msg = await this.client.messages.create({
      model: MODEL,
      max_tokens: 1024,
      system,
      messages: [{ role: "user", content: userMsg }],
    });
    const block = msg.content[0];
    return (block.type === "text" ? block.text : "").trim();
  }

  async generateSQL(
    schema: string,
    question: string,
    history: ConversationTurn[]
  ): Promise<string> {
    const messages = [
      ...formatHistory(history),
      { role: "user" as const, content: question },
    ];
    const msg = await this.client.messages.create({
      model: MODEL,
      max_tokens: 1024,
      system: buildSystemPrompt(schema),
      messages,
    });
    const block = msg.content[0];
    return (block.type === "text" ? block.text : "").trim();
  }

  async generateExplorationQueries(
    schema: string,
    question: string,
    failedSQL: string
  ): Promise<string> {
    return this.ask(
      "You are a PostgreSQL expert helping debug a query that returned 0 rows.",
      buildExplorationPrompt(schema, question, failedSQL)
    );
  }

  async refineSQL(
    schema: string,
    question: string,
    failedSQL: string,
    discoveredData: Record<string, unknown[]>
  ): Promise<string> {
    return this.ask(
      "You are a PostgreSQL expert rewriting a failed query with real DB values.",
      buildRefinePrompt(schema, question, failedSQL, discoveredData)
    );
  }

  async refineWithHint(
    schema: string,
    question: string,
    failedSQL: string,
    userHint: string,
    discoveredData: Record<string, unknown[]>
  ): Promise<string> {
    return this.ask(
      "You are a PostgreSQL expert. Use the user's hint to fix a failed query.",
      buildHintRefinePrompt(schema, question, failedSQL, userHint, discoveredData)
    );
  }

  async summarizeResults(
    question: string,
    sql: string,
    rows: Record<string, unknown>[],
    history: ConversationTurn[]
  ): Promise<string> {
    const messages = [
      ...formatHistory(history),
      { role: "user" as const, content: buildSummaryPrompt(question, sql, rows) },
    ];
    const msg = await this.client.messages.create({
      model: MODEL,
      max_tokens: 1024,
      messages,
    });
    const block = msg.content[0];
    return (block.type === "text" ? block.text : "").trim();
  }
}
