import Anthropic from "@anthropic-ai/sdk";
import { LLMProvider } from "../types";
import { buildSystemPrompt, buildSummaryPrompt } from "./llm.interface";

const MODEL = "claude-sonnet-4-5-20250929";

export class AnthropicProvider implements LLMProvider {
  private client: Anthropic;

  constructor() {
    this.client = new Anthropic();
  }

  async generateSQL(schema: string, question: string): Promise<string> {
    const msg = await this.client.messages.create({
      model: MODEL,
      max_tokens: 1024,
      system: buildSystemPrompt(schema),
      messages: [{ role: "user", content: question }],
    });
    const block = msg.content[0];
    return (block.type === "text" ? block.text : "").trim();
  }

  async summarizeResults(
    question: string,
    sql: string,
    rows: Record<string, unknown>[]
  ): Promise<string> {
    const msg = await this.client.messages.create({
      model: MODEL,
      max_tokens: 1024,
      messages: [{ role: "user", content: buildSummaryPrompt(question, sql, rows) }],
    });
    const block = msg.content[0];
    return (block.type === "text" ? block.text : "").trim();
  }
}
