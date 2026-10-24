-- Runs once on first container start (empty data volume), against POSTGRES_DB.
-- Creates the pgvector extension and the three-layer schema layout:
--   raw       untouched Olist CSV loads
--   staging   cleaned and typed tables
--   analytics business views and ML features (the only layer the agent queries)

CREATE EXTENSION IF NOT EXISTS vector;

CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS analytics;
