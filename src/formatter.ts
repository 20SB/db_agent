import chalk from "chalk";
import { AgentResult } from "./types";

const LINE = chalk.gray("─".repeat(60));
const DLINE = chalk.gray("═".repeat(60));

function padCell(value: string, width: number): string {
  return value.length > width
    ? value.slice(0, width - 1) + "…"
    : value + " ".repeat(width - value.length);
}

function renderTable(rows: Record<string, unknown>[]): string {
  if (rows.length === 0) return chalk.yellow("  (no rows)");

  const cols = Object.keys(rows[0]);
  const widths = cols.map((c) =>
    Math.min(
      25,
      Math.max(c.length, ...rows.map((r) => String(r[c] ?? "").length))
    )
  );

  const header =
    chalk.cyan("  ") +
    cols.map((c, i) => chalk.cyan.bold(padCell(c, widths[i]))).join(chalk.gray(" │ "));
  const sep =
    "  " + widths.map((w) => chalk.gray("─".repeat(w))).join(chalk.gray("─┼─"));
  const body = rows.map(
    (r) =>
      "  " +
      cols
        .map((c, i) => padCell(String(r[c] ?? ""), widths[i]))
        .join(chalk.gray(" │ "))
  );

  return [header, sep, ...body].join("\n");
}

export function formatResult(result: AgentResult): string {
  const { generated_sql, query_cost, row_count, answer_summary, raw_data_preview } = result;

  const sections = [
    "",
    DLINE,
    chalk.bold.green("  DB AGENT — RESULT"),
    DLINE,
    "",
    chalk.bold.white("  Answer"),
    LINE,
    `  ${chalk.whiteBright(answer_summary)}`,
    "",
    chalk.bold.white("  SQL Query"),
    LINE,
    `  ${chalk.yellowBright(generated_sql)}`,
    "",
    chalk.bold.white("  Stats"),
    LINE,
    `  ${chalk.gray("Rows returned:")}  ${chalk.cyanBright(row_count)}`,
    `  ${chalk.gray("Est. cost:")}      ${chalk.cyanBright(query_cost.estimated_cost)}`,
    `  ${chalk.gray("Est. rows:")}      ${chalk.cyanBright(query_cost.estimated_rows)}`,
    `  ${chalk.gray("Plan:")}           ${chalk.gray(query_cost.plan_summary)}`,
  ];

  if (raw_data_preview.length > 0) {
    sections.push(
      "",
      chalk.bold.white(`  Data Preview (${raw_data_preview.length} of ${row_count})`),
      LINE,
      renderTable(raw_data_preview)
    );
  }

  sections.push("", DLINE, "");
  return sections.join("\n");
}
