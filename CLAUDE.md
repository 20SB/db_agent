# DB Agent

CLI-based Database Question Answering Agent built with Node.js + TypeScript.
Converts natural language questions into safe SQL queries, executes them against PostgreSQL, and returns beautified structured answers.

## What This Agent Does

1. Accepts a natural language question (CLI arg or interactive REPL)
2. Sends the question + DB schema to an LLM to generate a SQL SELECT query
3. Validates the query is READ-ONLY (rejects INSERT/UPDATE/DELETE/DROP/ALTER/TRUNCATE)
4. Auto-appends `LIMIT 50` if missing
5. Runs `EXPLAIN` to estimate query cost before execution
6. Executes the query against PostgreSQL
7. Sends results back to the LLM for a human-readable summary
8. Prints a color-formatted output with answer, SQL, stats, and data preview

## Project Structure

```
db-agent/
├── src/
│   ├── agent.ts              # CLI entrypoint, provider factory, REPL loop, pipeline orchestration
│   ├── db.ts                 # PostgreSQL connection pool (pg), executeQuery(), closePool()
│   ├── sqlValidator.ts       # READ-ONLY enforcement, forbidden keyword detection, auto LIMIT
│   ├── costEstimator.ts      # Runs EXPLAIN (FORMAT JSON) to estimate query cost/rows
│   ├── formatter.ts          # Chalk-based beautified console output with table rendering
│   ├── types.ts              # Shared interfaces: AgentResult, QueryCost, LLMProvider, ConversationTurn
│   └── providers/
│       ├── llm.interface.ts  # Shared prompt builders (system prompt, summary prompt, history formatter)
│       ├── gemini.provider.ts    # Google Generative AI SDK — gemini-2.0-flash
│       └── anthropic.provider.ts # Anthropic SDK — claude-sonnet-4-5-20250929
├── .env                      # Local config (git-ignored)
├── .env.example              # Template for environment variables
├── .gitignore
├── package.json
├── tsconfig.json
└── README.md
```

## Key Architecture Decisions

- **Provider-agnostic LLM layer**: `LLMProvider` interface in `types.ts` with `generateSQL()` and `summarizeResults()`. Switch providers via `LLM_PROVIDER` env var without touching agent logic.
- **Conversation memory**: Interactive REPL maintains last 10 Q&A pairs as context. Both providers pass history (Gemini via `startChat`, Anthropic via `messages` array) enabling follow-up questions like "group that by city".
- **Security-first SQL validation**: Whitelist approach (must start with SELECT) + blacklist (forbidden keywords matched as whole words to avoid false positives on column names like `deleted_at`).
- **Cost estimation before execution**: `EXPLAIN (FORMAT JSON)` returns PostgreSQL planner's estimated cost/rows — useful for spotting expensive queries. Cost is in PostgreSQL's internal units (roughly disk page fetches), not monetary.

## Tech Stack

- **Runtime**: Node.js + TypeScript
- **Database**: PostgreSQL via `pg`
- **LLM Providers**: `@google/generative-ai` (Gemini), `@anthropic-ai/sdk` (Claude)
- **Config**: `dotenv`
- **Output**: `chalk` v4 (CommonJS)

## Environment Variables

| Variable | Required | Description |
|---|---|---|
| `DB_HOST` | yes | PostgreSQL host |
| `DB_PORT` | yes | PostgreSQL port (default: 5432) |
| `DB_USER` | yes | Database user |
| `DB_PASSWORD` | yes | Database password |
| `DB_NAME` | yes | Database name |
| `LLM_PROVIDER` | no | `gemini` (default) or `anthropic` |
| `GEMINI_API_KEY` | if gemini | Google AI Studio API key |
| `ANTHROPIC_API_KEY` | if anthropic | Anthropic API key |
| `SCHEMA_PATH` | no | Path to .sql file with DB schema for LLM context |

## Commands

```bash
npm run build          # Compile TypeScript to dist/
npm start "question"   # Single-shot mode
npm start              # Interactive REPL mode
npm run dev            # Dev mode via ts-node
```
