import * as fs from "fs";
import * as path from "path";

// ── Persistent data directory ────────────────────────────────────────
// Uses DATA_DIR env var if set (for Docker volume mounts), otherwise
// falls back to a "data" folder next to package.json.
let _dataDir: string | null = null;

export function getDataDir(): string {
  if (_dataDir) return _dataDir;

  _dataDir = process.env.DATA_DIR || path.resolve(__dirname, "../data");

  if (!fs.existsSync(_dataDir)) {
    fs.mkdirSync(_dataDir, { recursive: true });
  }

  return _dataDir;
}
