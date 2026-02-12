# db-agent

CLI-based Database Question Answering Agent — converts natural language questions into safe SQL queries, executes them against PostgreSQL, and returns structured JSON answers.

## Setup

```bash
npm install
cp .env.example .env   # fill in your values
```

## Configuration

| Variable | Description | Default |
|---|---|---|
| `DB_HOST` | PostgreSQL host | `localhost` |
| `DB_PORT` | PostgreSQL port | `5432` |
| `DB_USER` | Database user | `postgres` |
| `DB_PASSWORD` | Database password | |
| `DB_NAME` | Database name | `postgres` |
| `LLM_PROVIDER` | `gemini` or `anthropic` | `gemini` |
| `GCP_PROJECT_ID` | Google Cloud project (Gemini) | |
| `GCP_LOCATION` | Vertex AI region | `us-central1` |
| `ANTHROPIC_API_KEY` | Anthropic key (Claude) | |
| `SCHEMA_PATH` | Path to `.sql` schema file | |

## Usage

```bash
# Build and run
npm run build
npm start "How many users signed up last month?"

# Development mode
npm run dev "Show top 10 products by revenue"

# Interactive prompt
npm run dev
```

## Output

```json
{
  "generated_sql": "SELECT COUNT(*) FROM users WHERE created_at >= ...",
  "row_count": 1,
  "answer_summary": "42 users signed up last month.",
  "raw_data_preview": [{ "count": 42 }]
}
```

## Security

- Only `SELECT` queries are permitted.
- `INSERT`, `UPDATE`, `DELETE`, `DROP`, `ALTER`, `TRUNCATE` are rejected.
- `LIMIT 50` is auto-appended when missing.
- All generated SQL is logged before execution.
