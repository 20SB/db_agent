import { GoogleGenerativeAI, Content } from "@google/generative-ai";
import { LLMProvider, ConversationTurn } from "../types";
import { buildSystemPrompt, buildSummaryPrompt } from "./llm.interface";

const MODEL = "gemini-2.0-flash";

export class GeminiProvider implements LLMProvider {
  private client: GoogleGenerativeAI;

  constructor() {
    const apiKey = process.env.GEMINI_API_KEY;
    if (!apiKey) throw new Error("GEMINI_API_KEY is required for Gemini provider");
    this.client = new GoogleGenerativeAI(apiKey);
  }

  private toGeminiHistory(history: ConversationTurn[]): Content[] {
    return history.map((t) => ({
      role: t.role === "assistant" ? "model" : "user",
      parts: [{ text: t.content }],
    }));
  }

  async generateSQL(
    schema: string,
    question: string,
    history: ConversationTurn[]
  ): Promise<string> {
    const model = this.client.getGenerativeModel({
      model: MODEL,
      systemInstruction: buildSystemPrompt(schema),
    });
    const chat = model.startChat({ history: this.toGeminiHistory(history) });
    const result = await chat.sendMessage(question);
    return result.response.text().trim();
  }

  async summarizeResults(
    question: string,
    sql: string,
    rows: Record<string, unknown>[],
    history: ConversationTurn[]
  ): Promise<string> {
    const model = this.client.getGenerativeModel({ model: MODEL });
    const chat = model.startChat({ history: this.toGeminiHistory(history) });
    const result = await chat.sendMessage(buildSummaryPrompt(question, sql, rows));
    return result.response.text().trim();
  }
}
