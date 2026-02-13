# ── Build stage ───────────────────────────────────────────────────────
FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci

COPY tsconfig.json ./
COPY src/ ./src/

RUN npm run build

# ── Production stage ──────────────────────────────────────────────────
FROM node:20-alpine

WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci --omit=dev

COPY --from=builder /app/dist ./dist

# Copy schema file(s) if present — mount or set SCHEMA_PATH at runtime
COPY *.sql ./

# Cloud Run provides PORT env var (default 8080)
ENV PORT=8080
EXPOSE 8080

# Start the Telegram bot
CMD ["node", "dist/agent.js", "--telegram"]
