import { getPool } from "./db";
import { QueryCost } from "./types";

export async function estimateQueryCost(sql: string): Promise<QueryCost> {
  const client = await getPool().connect();
  try {
    const result = await client.query(`EXPLAIN (FORMAT JSON) ${sql}`);
    const plan = result.rows[0]["QUERY PLAN"][0]["Plan"];

    return {
      estimated_rows: Math.round(plan["Plan Rows"] ?? 0),
      estimated_cost: Math.round((plan["Total Cost"] ?? 0) * 100) / 100,
      plan_summary: `${plan["Node Type"]}` +
        (plan["Relation Name"] ? ` on ${plan["Relation Name"]}` : "") +
        ` — cost: ${plan["Total Cost"]}, rows: ${plan["Plan Rows"]}`,
    };
  } finally {
    client.release();
  }
}
