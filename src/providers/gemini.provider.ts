import { GoogleGenerativeAI } from "@google/generative-ai";
import { LLMProvider } from "../types";
import { buildSystemPrompt, buildSummaryPrompt } from "./llm.interface";

const MODEL = "gemini-1.5-flash";

export class GeminiProvider implements LLMProvider {
  private client: GoogleGenerativeAI;

  constructor() {
    const apiKey = process.env.GEMINI_API_KEY;
    if (!apiKey) throw new Error("GEMINI_API_KEY is required for Gemini provider");
    this.client = new GoogleGenerativeAI(apiKey);
  }

  async generateSQL(schema: string, question: string): Promise<string> {
    const model = this.client.getGenerativeModel({
      model: MODEL,
      systemInstruction: buildSystemPrompt(schema),
    });
    const result = await model.generateContent(question);
    return result.response.text().trim();
  }

  async summarizeResults(
    question: string,
    sql: string,
    rows: Record<string, unknown>[]
  ): Promise<string> {
    const model = this.client.getGenerativeModel({ model: MODEL });
    const result = await model.generateContent(buildSummaryPrompt(question, sql, rows));
    return result.response.text().trim();
  }
}
