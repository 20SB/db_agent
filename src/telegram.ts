import * as http from "http";
import TelegramBot from "node-telegram-bot-api";
import { LLMProvider, ConversationTurn, AgentResult } from "./types";
import { runAgent } from "./agent";
import { validateSQL } from "./sqlValidator";
import { executeQuery } from "./db";
import { estimateQueryCost } from "./costEstimator";
import { addLearning, getLearningsSummary, removeLearning } from "./learnings";

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

// ── Pending hint state per chat ─────────────────────────────────────
interface PendingHint {
  question: string;
  failedSQL: string;
  schema: string;
  llm: LLMProvider;
  history: ConversationTurn[];
  attempts: number;
}

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

// ── Send result to chat ─────────────────────────────────────────────
async function sendResult(bot: TelegramBot, chatId: number, result: AgentResult): Promise<void> {
  const response = formatTelegramResult(result);
  const chunks = splitMessage(response, 4096);
  for (const chunk of chunks) {
    try {
      await bot.sendMessage(chatId, chunk);
    } catch (sendErr) {
      console.error("[telegram] Failed to send result chunk:", sendErr);
    }
  }
}

// ── Telegram bot ────────────────────────────────────────────────────
export function startTelegramBot(llm: LLMProvider, schema: string): void {
  const token = process.env.TELEGRAM_BOT_TOKEN;
  if (!token) {
    console.error("[error] TELEGRAM_BOT_TOKEN not set in .env — cannot start bot.");
    process.exit(1);
  }

  // ── Health check server for Cloud Run ───────────────────────────
  const port = parseInt(process.env.PORT || "8080", 10);
  http
    .createServer((_req, res) => {
      res.writeHead(200, { "Content-Type": "application/json" });
      res.end(JSON.stringify({ status: "ok", service: "db-agent-telegram" }));
    })
    .listen(port, () => {
      console.log(`[health] Listening on port ${port}`);
    });

  const bot = new TelegramBot(token, { polling: true });

  // Per-chat state
  const chatHistories = new Map<number, ConversationTurn[]>();
  const activeChatRequests = new Set<number>();
  const pendingHints = new Map<number, PendingHint>();

  console.log("[telegram] Bot is running. Waiting for messages...");

  // ── Register bot commands in Telegram's menu ────────────────────
  bot.setMyCommands([
    { command: "start", description: "Welcome message & getting started" },
    { command: "help", description: "Show all commands & how to use the bot" },
    { command: "clear", description: "Clear conversation history" },
    { command: "learnings", description: "View all saved learnings" },
    { command: "forget", description: "Remove a learning (e.g. /forget 2)" },
  ]).catch(() => {});

  // ── /start command ──────────────────────────────────────────────
  bot.onText(/\/start/, (msg) => {
    bot.sendMessage(
      msg.chat.id,
      "🤖 DB Agent Bot\n" +
        "━━━━━━━━━━━━━━━━━━━━━━━━━\n\n" +
        "I'm your database assistant. Ask me anything about your database in plain English — " +
        "I'll generate SQL, run it safely, and give you a human-readable answer.\n\n" +
        "🔒 Safety: I only run read-only SELECT queries. No data is ever modified.\n\n" +
        "━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
        "🚀 Quick Start\n" +
        "━━━━━━━━━━━━━━━━━━━━━━━━━\n\n" +
        "Just type a question like:\n" +
        '  • "How many active shops are there?"\n' +
        '  • "Show me the top 10 products by sales"\n' +
        '  • "List all users created this month"\n\n' +
        "I understand follow-ups too:\n" +
        '  • "Group that by city"\n' +
        '  • "Show only the top 5"\n\n' +
        "Type /help for all commands and features.",
    );
  });

  // ── /help command ───────────────────────────────────────────────
  bot.onText(/\/help/, (msg) => {
    bot.sendMessage(
      msg.chat.id,
      "📖 Help — DB Agent Bot\n" +
        "━━━━━━━━━━━━━━━━━━━━━━━━━\n\n" +

        "💬 ASKING QUESTIONS\n" +
        "━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
        "Just type any question in plain English.\n" +
        "I'll generate SQL, validate it, run it, and summarize the results.\n\n" +
        "Examples:\n" +
        '  • "How many shops are there?"\n' +
        '  • "Show revenue by month for 2024"\n' +
        '  • "Which products have zero stock?"\n' +
        '  • "Count users grouped by status"\n\n' +
        "Follow-up questions work too — I remember context:\n" +
        '  • "Now group that by region"\n' +
        '  • "Only show the top 5"\n' +
        '  • "Filter that for active users only"\n\n' +

        "🧠 LEARNING FROM YOU\n" +
        "━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
        "When a query returns 0 results, I'll show you the\n" +
        "failed SQL and ask for a hint. You can teach me:\n\n" +
        '  • "use zone_name column instead of region"\n' +
        '  • "status values are active/inactive, not 1/0"\n' +
        '  • "join with stores table, not shops"\n\n' +
        "I'll retry with your hint. If it works, I save the\n" +
        "correction and apply it to all future queries.\n" +
        'Type "skip" to cancel the hint flow.\n\n' +

        "📊 WHAT YOU GET\n" +
        "━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
        "Each response includes:\n" +
        "  • 💬 Human-readable answer\n" +
        "  • 🔧 The exact SQL that was executed\n" +
        "  • 📊 Row count, cost estimate, query plan\n" +
        "  • 📋 Data preview table (up to 5 rows)\n\n" +

        "⚡ PIPELINE STEPS\n" +
        "━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
        "While processing, you'll see live progress:\n" +
        "  🧠 Generating SQL\n" +
        "  🔍 Validating (read-only check)\n" +
        "  📊 Estimating query cost\n" +
        "  ⚡ Executing on database\n" +
        "  🔄 Smart retry (if 0 rows)\n" +
        "  ✍️ Summarizing results\n\n" +

        "🛠 COMMANDS\n" +
        "━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
        "/start — Welcome message & getting started\n" +
        "/help — This help page\n" +
        "/clear — Clear conversation history & pending hints\n" +
        "/learnings — View all saved learnings\n" +
        "/forget <n> — Remove a learning by its number\n" +
        '                  e.g. /forget 2\n\n' +

        "💡 TIPS\n" +
        "━━━━━━━━━━━━━━━━━━━━━━━━━\n" +
        "  • Be specific — \"sales last 7 days\" beats \"recent sales\"\n" +
        "  • Use follow-ups — I keep last 10 Q&A pairs as context\n" +
        "  • Teach me once — learnings apply to ALL future queries\n" +
        "  • One question at a time — wait for the answer before asking the next",
    );
  });

  // ── /clear command ──────────────────────────────────────────────
  bot.onText(/\/clear/, (msg) => {
    chatHistories.delete(msg.chat.id);
    pendingHints.delete(msg.chat.id);
    bot.sendMessage(msg.chat.id, "🗑 Conversation history and pending hints cleared.");
  });

  // ── /learnings command ──────────────────────────────────────────
  bot.onText(/\/learnings/, (msg) => {
    const summary = getLearningsSummary();
    bot.sendMessage(msg.chat.id, `🧠 Learnings:\n\n${summary}`);
  });

  // ── /forget command ─────────────────────────────────────────────
  bot.onText(/\/forget\s+(\d+)/, (msg, match) => {
    const index = parseInt(match![1], 10);
    if (removeLearning(index)) {
      bot.sendMessage(msg.chat.id, `🗑 Learning #${index} removed.`);
    } else {
      bot.sendMessage(msg.chat.id, `❌ Invalid learning number. Use /learnings to see the list.`);
    }
  });

  // ── Main message handler ────────────────────────────────────────
  bot.on("message", async (msg) => {
    const chatId = msg.chat.id;
    const text = msg.text?.trim();

    // Skip commands and empty messages
    if (!text || text.startsWith("/")) return;

    // ── Handle pending hint (user is teaching the bot) ────────────
    if (pendingHints.has(chatId)) {
      const pending = pendingHints.get(chatId)!;

      // "skip" cancels the hint flow
      if (text.toLowerCase() === "skip") {
        pendingHints.delete(chatId);
        await bot.sendMessage(chatId, "👍 Skipped. Ask me another question anytime.");
        return;
      }

      activeChatRequests.add(chatId);
      const hint = text;

      try {
        await bot.sendMessage(chatId, "🔧 Applying your hint...");

        console.log(`[telegram] Chat ${chatId} hint: "${hint}"`);
        const rawSQL = await pending.llm.refineWithHint(
          pending.schema,
          pending.question,
          pending.failedSQL,
          hint,
          {},
        );

        const sql = validateSQL(rawSQL);
        console.log(`[telegram] hint-sql: ${sql}`);

        const rows = await executeQuery(sql);
        console.log(`[telegram] hint-rows: ${rows.length}`);

        if (rows.length > 0) {
          // Success! Save the learning
          addLearning({
            hint,
            question: pending.question,
            failedSQL: pending.failedSQL,
            fixedSQL: sql,
          });

          // Summarize and send result
          const cost = await estimateQueryCost(sql);
          const summary = await pending.llm.summarizeResults(
            pending.question,
            sql,
            rows,
            pending.history,
          );

          const result: AgentResult = {
            generated_sql: sql,
            query_cost: cost,
            row_count: rows.length,
            answer_summary: summary,
            raw_data_preview: rows.slice(0, 10),
            retried: true,
          };

          await bot.sendMessage(chatId, "🧠 Got it! I've learned this correction and will remember it for next time.");
          await sendResult(bot, chatId, result);

          // Update conversation memory
          const history = chatHistories.get(chatId) || [];
          history.push({ role: "user", content: pending.question });
          history.push({
            role: "assistant",
            content: `SQL: ${sql}\nAnswer: ${summary}`,
          });
          while (history.length > 20) history.splice(0, 2);

          pendingHints.delete(chatId);
        } else {
          // Still 0 rows
          pending.failedSQL = sql;
          pending.attempts++;

          if (pending.attempts >= 3) {
            pendingHints.delete(chatId);
            await bot.sendMessage(
              chatId,
              "😔 Still 0 results after 3 hints. Let's move on — try rephrasing your question.",
            );
          } else {
            await bot.sendMessage(
              chatId,
              `🔍 Still 0 results (attempt ${pending.attempts}/3).\n\nFailed SQL:\n${sql}\n\nSend another hint or type "skip" to move on.`,
            );
          }
        }
      } catch (err: unknown) {
        console.error(`[telegram] Chat ${chatId} hint error:`, err);
        const errorMsg = formatError(err);
        await bot.sendMessage(chatId, errorMsg);
        pendingHints.delete(chatId);
      } finally {
        activeChatRequests.delete(chatId);
      }
      return;
    }

    // ── Normal question flow ──────────────────────────────────────
    if (activeChatRequests.has(chatId)) {
      await bot.sendMessage(chatId, "⏳ I'm still working on your previous question. Please wait...");
      return;
    }
    activeChatRequests.add(chatId);

    if (!chatHistories.has(chatId)) {
      chatHistories.set(chatId, []);
    }
    const history = chatHistories.get(chatId)!;

    // Send initial status message
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

    const onProgress = (step: string, detail?: string) => {
      const label = (detail && STEP_ICONS[detail]) || step;
      stepTrail.push(label);
      const newText = buildStatusText(stepTrail);
      bot.editMessageText(newText, { chat_id: chatId, message_id: statusMsgId }).catch(() => {});
    };

    try {
      console.log(`[telegram] Chat ${chatId}: "${text}"`);
      const result = await runAgent(text, llm, schema, history, null, onProgress);
      console.log(`[telegram] Chat ${chatId}: got ${result.row_count} rows`);

      // Delete the status message
      try {
        await bot.deleteMessage(chatId, statusMsgId);
      } catch {
        // Ignore
      }

      if (result.row_count === 0) {
        // ── 0 rows: enter hint mode ─────────────────────────────
        pendingHints.set(chatId, {
          question: text,
          failedSQL: result.generated_sql,
          schema,
          llm,
          history: [...history],
          attempts: 1,
        });

        await bot.sendMessage(
          chatId,
          "🔍 Got 0 results. I might be using wrong columns or values.\n\n" +
            `Failed SQL:\n${result.generated_sql}\n\n` +
            "💡 Send me a hint to fix this (e.g., \"use zone_name instead of region\", \"status is stored as is_active boolean\").\n" +
            "Or type \"skip\" to move on.",
        );
      } else {
        // ── Got results: send normally ──────────────────────────
        history.push({ role: "user", content: text });
        history.push({
          role: "assistant",
          content: `SQL: ${result.generated_sql}\nAnswer: ${result.answer_summary}`,
        });
        while (history.length > 20) history.splice(0, 2);

        await sendResult(bot, chatId, result);
      }
    } catch (err: unknown) {
      console.error(`[telegram] Chat ${chatId} error:`, err);
      try {
        await bot.deleteMessage(chatId, statusMsgId);
      } catch {
        // Ignore
      }
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

  // Handle polling errors
  bot.on("polling_error", (err) => {
    console.error(`[telegram] Polling error: ${err.message}`);
  });
}
