# ADR 0001: One Postgres 16 instance with pgvector for relational data and embeddings

- Status: Accepted
- Date: 2026-10-24

## Context

The copilot needs two kinds of storage:

1. Relational storage for the Olist e-commerce dataset, queried by the text-to-SQL tool.
2. Vector storage for embedded policy document chunks, queried by the RAG tool.

It must run locally with Docker Compose and later on Azure Container Apps. This is a
portfolio project, so operational simplicity and explainability matter more than
scale. The policy corpus is small (tens to hundreds of chunks).

## Decision

Run a single PostgreSQL 16 instance with the `pgvector` extension, using the official
`pgvector/pgvector:0.8.0-pg16` image (tag pinned). On first start, an init script
creates the `vector` extension and the `raw`, `staging`, and `analytics` schemas.

## Alternatives considered

- **Azure AI Search for vectors.** Managed hybrid search, but it adds a paid cloud
  dependency, cannot run offline in Compose, and splits data across two systems.
- **Dedicated vector DB (Qdrant, Chroma, Weaviate).** Adds a second service to run,
  secure, and back up, for a corpus small enough that pgvector handles it easily.
- **Stock `postgres:16` image and compiling pgvector ourselves.** More control, but it
  means maintaining a custom Dockerfile for no practical gain.

## Consequences

- One connection string, one backup, and one set of roles and grants for both SQL and RAG.
- Retrieval can join chunk metadata with relational data in plain SQL.
- If the corpus grows large or we need managed hybrid search, retrieval can move to
  another store behind the retriever interface without touching the SQL tool.
- Init scripts run only when the data volume is empty. Schema changes after that need
  migrations or `docker compose down -v` (which deletes local data).
- On Azure, this maps to Azure Database for PostgreSQL Flexible Server, which supports
  the `vector` extension.
