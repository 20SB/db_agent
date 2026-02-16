import * as fs from "fs";
import { getPool } from "./db";
import { getDataDir } from "./dataDir";

// ── Schema file persistence path ─────────────────────────────────────
const SAVED_SCHEMA_PATH = () => `${getDataDir()}/schema_synced.sql`;

// ── Parse table names and their columns from DDL text ────────────────
export interface TableInfo {
  name: string;
  columns: string[]; // column lines as-is from DDL
}

export function extractTables(ddl: string): Map<string, TableInfo> {
  const tables = new Map<string, TableInfo>();
  const tableRegex = /CREATE TABLE (\S+) \(\n([\s\S]*?)\);/g;
  let match: RegExpExecArray | null;

  while ((match = tableRegex.exec(ddl)) !== null) {
    const name = match[1];
    const colBlock = match[2];
    const columns = colBlock
      .split(",\n")
      .map((c) => c.trim())
      .filter(Boolean);
    tables.set(name, { name, columns });
  }
  return tables;
}

// ── Diff two schemas ─────────────────────────────────────────────────
export interface SchemaDiff {
  oldTableCount: number;
  newTableCount: number;
  addedTables: string[];
  removedTables: string[];
  unchangedTables: string[];
  modifiedTables: { name: string; addedCols: string[]; removedCols: string[] }[];
}

export function diffSchemas(oldDDL: string, newDDL: string): SchemaDiff {
  const oldTables = extractTables(oldDDL);
  const newTables = extractTables(newDDL);

  const addedTables: string[] = [];
  const removedTables: string[] = [];
  const unchangedTables: string[] = [];
  const modifiedTables: { name: string; addedCols: string[]; removedCols: string[] }[] = [];

  // Find added and modified tables
  for (const [name, newInfo] of newTables) {
    if (!oldTables.has(name)) {
      addedTables.push(name);
    } else {
      const oldInfo = oldTables.get(name)!;
      const oldColNames = new Set(oldInfo.columns.map((c) => c.split(/\s+/)[0]));
      const newColNames = new Set(newInfo.columns.map((c) => c.split(/\s+/)[0]));

      const addedCols = newInfo.columns.filter((c) => !oldColNames.has(c.split(/\s+/)[0]));
      const removedCols = oldInfo.columns.filter((c) => !newColNames.has(c.split(/\s+/)[0]));

      if (addedCols.length > 0 || removedCols.length > 0) {
        modifiedTables.push({ name, addedCols, removedCols });
      } else {
        unchangedTables.push(name);
      }
    }
  }

  // Find removed tables
  for (const name of oldTables.keys()) {
    if (!newTables.has(name)) {
      removedTables.push(name);
    }
  }

  return {
    oldTableCount: oldTables.size,
    newTableCount: newTables.size,
    addedTables,
    removedTables,
    unchangedTables,
    modifiedTables,
  };
}

// ── Format diff for display ──────────────────────────────────────────
export function formatDiff(diff: SchemaDiff): string {
  const lines: string[] = [];

  lines.push(`📊 Tables: ${diff.oldTableCount} → ${diff.newTableCount}`);

  if (diff.addedTables.length > 0) {
    lines.push(`\n➕ New tables (${diff.addedTables.length}):`);
    for (const t of diff.addedTables) lines.push(`  • ${t}`);
  }

  if (diff.removedTables.length > 0) {
    lines.push(`\n➖ Removed tables (${diff.removedTables.length}):`);
    for (const t of diff.removedTables) lines.push(`  • ${t}`);
  }

  if (diff.modifiedTables.length > 0) {
    lines.push(`\n✏️ Modified tables (${diff.modifiedTables.length}):`);
    for (const mod of diff.modifiedTables) {
      lines.push(`  • ${mod.name}`);
      for (const c of mod.addedCols) lines.push(`    + ${c}`);
      for (const c of mod.removedCols) lines.push(`    - ${c}`);
    }
  }

  if (diff.unchangedTables.length > 0) {
    lines.push(`\n✅ Unchanged: ${diff.unchangedTables.length} table(s)`);
  }

  if (
    diff.addedTables.length === 0 &&
    diff.removedTables.length === 0 &&
    diff.modifiedTables.length === 0
  ) {
    lines.push("\nNo changes detected — schema is up to date.");
  }

  return lines.join("\n");
}

// ── Save / Load synced schema to file ────────────────────────────────
export function saveSchema(ddl: string): void {
  const p = SAVED_SCHEMA_PATH();
  fs.writeFileSync(p, ddl, "utf-8");
  console.log(`[schema-sync] Saved schema to ${p}`);
}

export function loadSavedSchema(): string | null {
  const p = SAVED_SCHEMA_PATH();
  if (fs.existsSync(p)) {
    return fs.readFileSync(p, "utf-8");
  }
  return null;
}

// ── Pull live schema from PostgreSQL as CREATE TABLE DDL ────────────
export async function syncSchemaFromDB(): Promise<string> {
  const client = await getPool().connect();

  try {
    // 1. Get all user tables (exclude system schemas)
    const tablesRes = await client.query(`
      SELECT table_schema, table_name
      FROM information_schema.tables
      WHERE table_schema NOT IN ('pg_catalog', 'information_schema')
        AND table_type = 'BASE TABLE'
      ORDER BY table_schema, table_name
    `);

    if (tablesRes.rows.length === 0) {
      return "-- No user tables found in database --";
    }

    const ddlParts: string[] = [
      `-- Schema synced from live database: ${process.env.DB_NAME}`,
      `-- Synced at: ${new Date().toISOString()}`,
      `-- Tables: ${tablesRes.rows.length}`,
      "",
    ];

    for (const table of tablesRes.rows) {
      const schema = table.table_schema as string;
      const tableName = table.table_name as string;
      const fullName = schema === "public" ? tableName : `${schema}.${tableName}`;

      // 2. Get columns for each table
      const colsRes = await client.query(
        `
        SELECT
          column_name,
          data_type,
          character_maximum_length,
          is_nullable,
          column_default
        FROM information_schema.columns
        WHERE table_schema = $1 AND table_name = $2
        ORDER BY ordinal_position
        `,
        [schema, tableName],
      );

      // 3. Get primary key columns
      const pkRes = await client.query(
        `
        SELECT kcu.column_name
        FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu
          ON tc.constraint_name = kcu.constraint_name
          AND tc.table_schema = kcu.table_schema
        WHERE tc.table_schema = $1
          AND tc.table_name = $2
          AND tc.constraint_type = 'PRIMARY KEY'
        ORDER BY kcu.ordinal_position
        `,
        [schema, tableName],
      );
      const pkCols = new Set(pkRes.rows.map((r) => r.column_name as string));

      // 4. Get foreign keys
      const fkRes = await client.query(
        `
        SELECT
          kcu.column_name,
          ccu.table_schema AS ref_schema,
          ccu.table_name AS ref_table,
          ccu.column_name AS ref_column
        FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu
          ON tc.constraint_name = kcu.constraint_name
          AND tc.table_schema = kcu.table_schema
        JOIN information_schema.constraint_column_usage ccu
          ON tc.constraint_name = ccu.constraint_name
          AND tc.table_schema = ccu.table_schema
        WHERE tc.table_schema = $1
          AND tc.table_name = $2
          AND tc.constraint_type = 'FOREIGN KEY'
        `,
        [schema, tableName],
      );
      const fkMap = new Map<string, string>();
      for (const fk of fkRes.rows) {
        const refTable =
          fk.ref_schema === "public" ? fk.ref_table : `${fk.ref_schema}.${fk.ref_table}`;
        fkMap.set(fk.column_name as string, `${refTable}(${fk.ref_column})`);
      }

      // Build CREATE TABLE
      const colLines: string[] = [];
      for (const col of colsRes.rows) {
        let type = col.data_type as string;
        if (col.character_maximum_length) {
          type += `(${col.character_maximum_length})`;
        }

        let line = `  ${col.column_name} ${type}`;
        if (pkCols.has(col.column_name as string)) line += " PRIMARY KEY";
        if (col.is_nullable === "NO" && !pkCols.has(col.column_name as string)) line += " NOT NULL";
        if (col.column_default) line += ` DEFAULT ${col.column_default}`;
        if (fkMap.has(col.column_name as string)) {
          line += ` REFERENCES ${fkMap.get(col.column_name as string)}`;
        }
        colLines.push(line);
      }

      ddlParts.push(`CREATE TABLE ${fullName} (`);
      ddlParts.push(colLines.join(",\n"));
      ddlParts.push(");\n");
    }

    // 5. Get enum types (useful context for the LLM)
    const enumRes = await client.query(`
      SELECT t.typname AS enum_name, e.enumlabel AS enum_value
      FROM pg_type t
      JOIN pg_enum e ON t.oid = e.enumtypid
      JOIN pg_namespace n ON t.typnamespace = n.oid
      WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
      ORDER BY t.typname, e.enumsortorder
    `);

    if (enumRes.rows.length > 0) {
      ddlParts.push("-- Enum types:");
      const enums = new Map<string, string[]>();
      for (const row of enumRes.rows) {
        const name = row.enum_name as string;
        if (!enums.has(name)) enums.set(name, []);
        enums.get(name)!.push(`'${row.enum_value}'`);
      }
      for (const [name, values] of enums) {
        ddlParts.push(`-- ${name}: ${values.join(", ")}`);
      }
      ddlParts.push("");
    }

    const result = ddlParts.join("\n");
    console.log(`[schema-sync] Synced ${tablesRes.rows.length} tables from ${process.env.DB_NAME}`);
    return result;
  } finally {
    client.release();
  }
}
