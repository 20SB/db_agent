import TelegramBot from "node-telegram-bot-api";
import { LLMProvider, ConversationTurn, AgentResult } from "./types";
import { runAgent } from "./agent";

// ── Status icons for each pipeline phase ────────────────────────────
const STEP_ICONS: Record<string, string> = {
  thinking: "🧠 Thinking — generating SQL...",
  validating: "🔍 Validating SQL...",
  estimating: "📊 Estimating query cost...",
  executing: "⚡ Executing query on database...",
  retrying: "🔄 No results — smart retrying...",
  summarizing: "✍️ Summarizing results...",
  done: "✅ Done!",
};

// ── Build the live status message with step trail ───────────────────
function buildStatusText(steps: string[]): string {
  if (steps.length === 0) return "⏳ Processing your question...";

  const lines: string[] = [];
  for (let i = 0; i < steps.length; i++) {
    const icon = i < steps.length - 1 ? "✓" : "▸";
    lines.push(`${icon} ${steps[i]}`);
  }
  return lines.join("\n");
}

// ── Plain-text formatter for Telegram ───────────────────────────────
function formatTelegramResult(result: AgentResult): string {
  const lines: string[] = [];

  lines.push("✅ DB Agent Result");
  if (result.retried) lines.push("(smart-retried)");
  lines.push("");

  lines.push("💬 Answer:");
  lines.push(result.answer_summary);
  lines.push("");

  lines.push("🔧 SQL:");
  lines.push(result.generated_sql);
  lines.push("");

  lines.push("📊 Stats:");
  lines.push(`  Rows: ${result.row_count}`);
  lines.push(`  Est. cost: ${result.query_cost.estimated_cost}`);
  lines.push(`  Plan: ${result.query_cost.plan_summary}`);

  if (result.raw_data_preview.length > 0) {
    lines.push("");
    lines.push(
      `📋 Data Preview (${result.raw_data_preview.length} of ${result.row_count}):`,
    );
    const rows = result.raw_data_preview.slice(0, 5);
    const cols = Object.keys(rows[0]);

    lines.push(cols.join(" | "));
    lines.push(cols.map((c) => "-".repeat(c.length)).join("-+-"));
    for (const row of rows) {
      lines.push(cols.map((c) => String(row[c] ?? "")).join(" | "));
    }

    if (result.raw_data_preview.length > 5) {
      lines.push(`  ... and ${result.raw_data_preview.length - 5} more rows`);
    }
  }

  return lines.join("\n");
}

// ── Categorize errors for user-friendly messages ────────────────────
function formatError(err: unknown): string {
  const msg = err instanceof Error ? err.message : String(err);
  const lower = msg.toLowerCase();

  if (lower.includes("econnrefused") || lower.includes("connection refused")) {
    return "❌ Database Connection Failed\nCannot reach the PostgreSQL server. Check if the database is running.";
  }
  if (lower.includes("authentication") || lower.includes("password")) {
    return "❌ Database Auth Error\nInvalid database credentials. Check DB_USER / DB_PASSWORD in .env";
  }
  if (lower.includes("timeout") || lower.includes("timed out")) {
    return "❌ Query Timeout\nThe query took too long. Try a simpler question.";
  }
  if (lower.includes("relation") && lower.includes("does not exist")) {
    return `❌ Table Not Found\n${msg}`;
  }
  if (lower.includes("column") && lower.includes("does not exist")) {
    return `❌ Column Not Found\n${msg}`;
  }
  if (lower.includes("syntax error")) {
    return "❌ SQL Syntax Error\nThe generated SQL had a syntax issue. Try rephrasing your question.";
  }
  if (lower.includes("rejected") || lower.includes("not a select")) {
    return "❌ Blocked\nOnly read-only SELECT queries are allowed.";
  }
  if (lower.includes("api") || lower.includes("rate limit") || lower.includes("quota")) {
    return "❌ LLM API Error\nFailed to reach the AI service. It may be rate-limited or down.";
  }

  return `❌ Error\n${msg}`;
}

// ── Split long messages at newline boundaries ───────────────────────
function splitMessage(text: string, maxLen: number): string[] {
  if (text.length <= maxLen) return [text];

  const chunks: string[] = [];
  let remaining = text;

  while (remaining.length > maxLen) {
    let splitAt = remaining.lastIndexOf("\n", maxLen);
    if (splitAt <= 0) splitAt = maxLen;
    chunks.push(remaining.slice(0, splitAt));
    remaining = remaining.slice(splitAt).replace(/^\n/, "");
  }
  if (remaining.length > 0) chunks.push(remaining);

  return chunks;
}

// ── Telegram bot ────────────────────────────────────────────────────
export function startTelegramBot(llm: LLMProvider, schema: string): void {
  const token = process.env.TELEGRAM_BOT_TOKEN;
  if (!token) {
    console.error("[error] TELEGRAM_BOT_TOKEN not set in .env — cannot start bot.");
    process.exit(1);
  }

  const bot = new TelegramBot(token, { polling: true });

  // Per-chat conversation history
  const chatHistories = new Map<number, ConversationTurn[]>();
  // Track chats with an active request to prevent overlapping
  const activeChatRequests = new Set<number>();

  console.log("[telegram] Bot is running. Waiting for messages...");

  bot.onText(/\/start/, (msg) => {
    bot.sendMessage(
      msg.chat.id,
      "🤖 DB Agent Bot\n\n" +
        "Ask me anything about your database in plain English.\n" +
        "I'll generate SQL, run it, and give you a summary.\n\n" +
        "Commands:\n" +
        "/start — Show this message\n" +
        "/clear — Clear conversation history",
    );
  });

  bot.onText(/\/clear/, (msg) => {
    chatHistories.delete(msg.chat.id);
    bot.sendMessage(msg.chat.id, "🗑 Conversation history cleared.");
  });

  bot.on("message", async (msg) => {
    const chatId = msg.chat.id;
    const text = msg.text?.trim();

    // Skip commands and empty messages
    if (!text || text.startsWith("/")) return;

    // Prevent overlapping requests per chat
    if (activeChatRequests.has(chatId)) {
      await bot.sendMessage(chatId, "⏳ I'm still working on your previous question. Please wait...");
      return;
    }
    activeChatRequests.add(chatId);

    // Get or create history for this chat
    if (!chatHistories.has(chatId)) {
      chatHistories.set(chatId, []);
    }
    const history = chatHistories.get(chatId)!;

    // Send initial status message that we'll keep editing
    let statusMsgId: number;
    try {
      const statusMsg = await bot.sendMessage(chatId, "⏳ Processing your question...");
      statusMsgId = statusMsg.message_id;
    } catch (err) {
      console.error("[telegram] Failed to send status message:", err);
      activeChatRequests.delete(chatId);
      return;
    }

    const stepTrail: string[] = [];

    // Progress callback: edits the status message live
    const onProgress = (step: string, detail?: string) => {
      const label = (detail && STEP_ICONS[detail]) || step;
      stepTrail.push(label);
      const newText = buildStatusText(stepTrail);

      bot.editMessageText(newText, { chat_id: chatId, message_id: statusMsgId }).catch(() => {
        // Ignore edit errors (rate limit, message not modified, etc.)
      });
    };

    try {
      console.log(`[telegram] Chat ${chatId}: "${text}"`);
      const result = await runAgent(text, llm, schema, history, null, onProgress);
      console.log(`[telegram] Chat ${chatId}: got ${result.row_count} rows`);

      // Update conversation memory
      history.push({ role: "user", content: text });
      history.push({
        role: "assistant",
        content: `SQL: ${result.generated_sql}\nAnswer: ${result.answer_summary}`,
      });
      while (history.length > 20) history.splice(0, 2);

      // Delete the status message
      try {
        await bot.deleteMessage(chatId, statusMsgId);
      } catch {
        // Ignore — might already be deleted
      }

      // Send the final result as plain text (guaranteed to work)
      const response = formatTelegramResult(result);
      const chunks = splitMessage(response, 4096);
      for (const chunk of chunks) {
        try {
          await bot.sendMessage(chatId, chunk);
        } catch (sendErr) {
          console.error("[telegram] Failed to send result chunk:", sendErr);
        }
      }
    } catch (err: unknown) {
      console.error(`[telegram] Chat ${chatId} error:`, err);

      // Delete the status message
      try {
        await bot.deleteMessage(chatId, statusMsgId);
      } catch {
        // Ignore
      }

      // Send error as plain text
      const errorMsg = formatError(err);
      try {
        await bot.sendMessage(chatId, errorMsg);
      } catch (sendErr) {
        console.error("[telegram] Failed to send error message:", sendErr);
      }
    } finally {
      activeChatRequests.delete(chatId);
    }
  });

  // Handle polling errors gracefully
  bot.on("polling_error", (err) => {
    console.error(`[telegram] Polling error: ${err.message}`);
  });
}
