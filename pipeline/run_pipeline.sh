#!/usr/bin/env bash
set -e  # fail fast

echo "Starting pipeline..."

MONTHS="$@"

if [ -z "$MONTHS" ]; then
  echo "No months provided"
  exit 1
fi

echo "Ingesting months: $MONTHS"
docker compose run --rm ingest \
  python ingestion/ingest_divvy.py --months $MONTHS

echo "Running dbt models"
docker compose run --rm dbt \
  dbt run --project-dir dbt

echo "✅ Pipeline complete"