import { Pool, PoolConfig } from "pg";

let pool: Pool;

export function getPool(): Pool {
  if (!pool) {
    const config: PoolConfig = {
      host: process.env.DB_HOST || "localhost",
      port: Number(process.env.DB_PORT) || 5432,
      user: process.env.DB_USER || "postgres",
      password: process.env.DB_PASSWORD || "",
      database: process.env.DB_NAME || "postgres",
      max: 5,
      idleTimeoutMillis: 30_000,
    };
    pool = new Pool(config);
  }
  return pool;
}

export async function executeQuery(
  sql: string
): Promise<Record<string, unknown>[]> {
  const client = await getPool().connect();
  try {
    const result = await client.query(sql);
    return result.rows;
  } finally {
    client.release();
  }
}

export async function closePool(): Promise<void> {
  if (pool) await pool.end();
}
