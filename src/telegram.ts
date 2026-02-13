import TelegramBot from "node-telegram-bot-api";
import { LLMProvider, ConversationTurn, AgentResult } from "./types";
import { runAgent } from "./agent";

// ── Plain-text formatter for Telegram (no chalk) ────────────────────
function formatTelegramResult(result: AgentResult): string {
  const lines: string[] = [];

  lines.push("--- DB AGENT RESULT ---");
  if (result.retried) lines.push("(smart-retried)");
  lines.push("");

  lines.push("Answer:");
  lines.push(result.answer_summary);
  lines.push("");

  lines.push("SQL:");
  lines.push(`\`${result.generated_sql}\``);
  lines.push("");

  lines.push("Stats:");
  lines.push(`  Rows: ${result.row_count}`);
  lines.push(`  Est. cost: ${result.query_cost.estimated_cost}`);
  lines.push(`  Plan: ${result.query_cost.plan_summary}`);

  if (result.raw_data_preview.length > 0) {
    lines.push("");
    lines.push(
      `Data Preview (${result.raw_data_preview.length} of ${result.row_count}):`
    );
    const rows = result.raw_data_preview.slice(0, 5);
    const cols = Object.keys(rows[0]);

    // header
    lines.push(cols.join(" | "));
    lines.push(cols.map((c) => "-".repeat(c.length)).join(" | "));

    // rows
    for (const row of rows) {
      lines.push(cols.map((c) => String(row[c] ?? "")).join(" | "));
    }

    if (result.raw_data_preview.length > 5) {
      lines.push(`  ... and ${result.raw_data_preview.length - 5} more rows`);
    }
  }

  return lines.join("\n");
}

// ── Telegram bot ────────────────────────────────────────────────────
export function startTelegramBot(llm: LLMProvider, schema: string): void {
  const token = process.env.TELEGRAM_BOT_TOKEN;
  if (!token) {
    console.error(
      "[error] TELEGRAM_BOT_TOKEN not set in .env — cannot start bot."
    );
    process.exit(1);
  }

  const bot = new TelegramBot(token, { polling: true });

  // Per-chat conversation history
  const chatHistories = new Map<number, ConversationTurn[]>();

  console.log("[telegram] Bot is running. Waiting for messages...");

  bot.onText(/\/start/, (msg) => {
    bot.sendMessage(
      msg.chat.id,
      "Hi! I'm your DB Agent bot.\n\n" +
        "Ask me anything about your database in plain English.\n" +
        "I'll generate SQL, run it, and give you a summary.\n\n" +
        "Commands:\n" +
        "/start - Show this message\n" +
        "/clear - Clear conversation history"
    );
  });

  bot.onText(/\/clear/, (msg) => {
    chatHistories.delete(msg.chat.id);
    bot.sendMessage(msg.chat.id, "Conversation history cleared.");
  });

  bot.on("message", async (msg) => {
    const chatId = msg.chat.id;
    const text = msg.text?.trim();

    // Skip commands and empty messages
    if (!text || text.startsWith("/")) return;

    // Get or create history for this chat
    if (!chatHistories.has(chatId)) {
      chatHistories.set(chatId, []);
    }
    const history = chatHistories.get(chatId)!;

    // Send "typing" indicator
    bot.sendChatAction(chatId, "typing");

    // Keep typing indicator alive during processing
    const typingInterval = setInterval(() => {
      bot.sendChatAction(chatId, "typing");
    }, 4000);

    try {
      const result = await runAgent(text, llm, schema, history, null);

      // Update conversation memory
      history.push({ role: "user", content: text });
      history.push({
        role: "assistant",
        content: `SQL: ${result.generated_sql}\nAnswer: ${result.answer_summary}`,
      });

      // Keep memory bounded — last 20 turns (10 Q&A pairs)
      while (history.length > 20) history.splice(0, 2);

      const response = formatTelegramResult(result);

      // Telegram has a 4096 char limit per message
      if (response.length <= 4096) {
        await bot.sendMessage(chatId, response);
      } else {
        // Split into chunks
        const chunks: string[] = [];
        let remaining = response;
        while (remaining.length > 0) {
          chunks.push(remaining.slice(0, 4096));
          remaining = remaining.slice(4096);
        }
        for (const chunk of chunks) {
          await bot.sendMessage(chatId, chunk);
        }
      }
    } catch (err: unknown) {
      const message = err instanceof Error ? err.message : String(err);
      await bot.sendMessage(chatId, `Error: ${message}`);
    } finally {
      clearInterval(typingInterval);
    }
  });
}
