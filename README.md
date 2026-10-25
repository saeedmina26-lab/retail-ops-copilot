# Retail Ops Copilot

An agentic assistant that answers retail business questions by combining text-to-SQL over the
Olist e-commerce dataset, RAG over policy documents, and (in phase 2) an ML delivery-delay model.

## Run locally

Prerequisites: Docker with Compose v2.

1. Copy the env template and set a real password:

   ```sh
   cp .env.example .env
   ```

2. Start Postgres 16 with pgvector:

   ```sh
   docker compose up -d
   docker compose ps   # db should show "healthy"
   ```

   On first start this creates the `vector` extension and the `raw`, `staging`, and
   `analytics` schemas (see `docker/postgres/init/`). Init scripts run only when the data
   volume is empty; to start over, run `docker compose down -v` (this deletes local data).

   Postgres is published on `127.0.0.1:5433` only (not on your network). The host port
   is 5433 rather than 5432 so it doesn't clash with a natively installed Postgres;
   change it with `POSTGRES_PORT` in `.env`.

3. Place the 9 Olist CSVs in `data/raw/` (gitignored).

## Architecture decisions

See [`docs/adr/`](docs/adr/).
