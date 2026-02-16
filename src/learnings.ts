import * as fs from "fs";
import { getDataDir } from "./dataDir";

const LEARNINGS_PATH = () => `${getDataDir()}/learnings.json`;

export interface Learning {
  hint: string;
  question: string;
  failedSQL: string;
  fixedSQL: string;
  timestamp: string;
}

interface LearningsFile {
  learnings: Learning[];
}

// ── Load all learnings from disk ────────────────────────────────────
export function loadLearnings(): Learning[] {
  if (!fs.existsSync(LEARNINGS_PATH())) return [];
  try {
    const raw = fs.readFileSync(LEARNINGS_PATH(), "utf-8");
    const data: LearningsFile = JSON.parse(raw);
    return data.learnings || [];
  } catch {
    return [];
  }
}

// ── Save a new learning ─────────────────────────────────────────────
export function addLearning(learning: Omit<Learning, "timestamp">): void {
  const all = loadLearnings();
  all.push({ ...learning, timestamp: new Date().toISOString() });
  fs.writeFileSync(LEARNINGS_PATH(), JSON.stringify({ learnings: all }, null, 2), "utf-8");
  console.log(`[learnings] Saved: "${learning.hint}"`);
}

// ── Format learnings as context for the LLM prompt ──────────────────
export function getLearningsForPrompt(): string {
  const all = loadLearnings();
  if (all.length === 0) return "";

  const lines = [
    "",
    "## Past corrections from the database admin (ALWAYS apply these rules when relevant):",
  ];

  for (const l of all) {
    lines.push(`- Hint: "${l.hint}"`);
    lines.push(`  Wrong: ${l.failedSQL}`);
    lines.push(`  Fixed: ${l.fixedSQL}`);
    lines.push("");
  }

  return lines.join("\n");
}

// ── Get learnings as readable text (for /learnings command) ─────────
export function getLearningsSummary(): string {
  const all = loadLearnings();
  if (all.length === 0) return "No learnings saved yet.";

  const lines = [`${all.length} learning(s) stored:\n`];
  for (let i = 0; i < all.length; i++) {
    const l = all[i];
    lines.push(`${i + 1}. "${l.hint}"`);
    lines.push(`   Q: ${l.question}`);
    lines.push(`   Fixed SQL: ${l.fixedSQL}`);
    lines.push("");
  }
  return lines.join("\n");
}

// ── Remove a learning by index (1-based) ────────────────────────────
export function removeLearning(index: number): boolean {
  const all = loadLearnings();
  if (index < 1 || index > all.length) return false;
  all.splice(index - 1, 1);
  fs.writeFileSync(LEARNINGS_PATH(), JSON.stringify({ learnings: all }, null, 2), "utf-8");
  return true;
}
