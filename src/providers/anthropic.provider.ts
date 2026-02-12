import Anthropic from "@anthropic-ai/sdk";
import { LLMProvider, ConversationTurn } from "../types";
import { buildSystemPrompt, buildSummaryPrompt, formatHistory } from "./llm.interface";

const MODEL = "claude-sonnet-4-5-20250929";

export class AnthropicProvider implements LLMProvider {
  private client: Anthropic;

  constructor() {
    this.client = new Anthropic();
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
