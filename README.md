
# 🚴 Explore Chicago Divvy - Data Engineering Pipeline

A reproducible data pipeline to ingest, transform, and analyze Chicago Divvy bike trips using a modern, local analytics stack.

## Overview

This project is part of my work through the [Data Engineering Zoomcamp](https://datatalks.club/blog/data-engineering-zoomcamp.html). Rather than just follow tutorials, I built an end-to-end pipeline around real-world bike share data from Chicago’s Divvy system.

The goal is simple:

Take raw trip data → turn it into clean, reliable datasets → generate insights and visualizations.

The dataset is conceptually similar to the NYC Taxi dataset used in the course, but introduces interesting spatial and behavioral patterns.

**Data source:**

Chicago Data Portal: https://data.cityofchicago.org/Transportation/Divvy-Trips/fg6s-gzvg/about_data

Raw files: https://divvy-tripdata.s3.amazonaws.com/


## Architecture
```
        ┌──────────────┐
        │  Raw Data    │  (Divvy ZIP files)
        └──────┬───────┘
               ↓
        ┌──────────────┐
        │ Ingestion    │  (Python)
        │ → Parquet    │
        └──────┬───────┘
               ↓
        ┌──────────────┐
        │  DuckDB      │  (warehouse.duckdb)
        └──────┬───────┘
               ↓
        ┌──────────────┐
        │     dbt      │  (transformations)
        └──────┬───────┘
               ↓
        ┌──────────────┐
        │  Jupyter     │  (analysis + maps)
        └──────────────┘
```

## Tech Stack
- Python – ingestion + data processing
- DuckDB – local analytical warehouse
- dbt – transformations, testing, modeling
- Docker / Docker Compose – reproducible environment
- Jupyter Lab – exploration & visualization
- Parquet – efficient columnar storage


## Project Structure
```
.
├── data/
│   ├── raw/                  # Parquet files (ingested data)
│   └── warehouse.duckdb      # DuckDB database
│
├── ingestion/
│   └── ingest_divvy.py       # Download + convert pipeline
│
├── dbt/
│   ├── models/
│   │   ├── staging/          # Cleaned raw data
│   │   ├── marts/            # Business logic (facts/dims)
│   │   └── analytics/        # Reporting tables
│   ├── dbt_project.yml
│   └── profiles.yml
│
├── docker/
│   ├── base/
│   ├── ingest/
│   ├── dbt/
│   └── jupyter/
│
├── pipeline/
│   └── run_pipeline.sh       # End-to-end pipeline
│
└── docker-compose.yml
```

## Running the Pipeline
<div>

**Build containers**

--------------------------------------
```
docker compose build
```

**Run the full pipeline**

--------------------------------------
```
./pipeline/run_pipeline.sh 202401 202402 202403 202404 202405 202406 202407 202408 202409 202410 202411 202412
```

This will:
  <ol>
    <li>Download Divvy trip data</li>
    <li>Convert to Parquet</li>
    <li>Run dbt models</li>
    <li>Produce analytics tables</li>
  </ol>


**Launch Jupyter**

--------------------------------------
```
docker compose up jupyter
```
Open in browser:

http://localhost:8888
</div>

## Data Modeling (dbt)
### Staging
- Cleans raw data
- Standardizes schema
- Deduplicates records using ROW_NUMBER()

### Marts
- fct_trips → core trip events
- dim_stations → station reference

### Analytics
- Trips by day
- Trips by station
- Peak usage patterns


## Data Quality
- not_null and unique tests enforced on ride_id
- Duplicate records handled in staging layer
- dbt tests ensure downstream reliability

## Example Analysis

Using Jupyter + DuckDB:

- Station usage heatmaps
- Peak riding hours
- Member vs casual rider behavior
- High-traffic station identification

Example query:
```sql
SELECT
    trip_hour,
    COUNT(*) AS trips
FROM fct_trips
GROUP BY trip_hour
ORDER BY trip_hour;
```

## Key Learnings
- DuckDB + Parquet is extremely powerful for local analytics
- dbt enforces structure and data quality early
- Real-world data is messy (duplicates, inconsistencies)
- Iterating in Jupyter accelerates pipeline development
- Docker setup and implementation

## Future Improvements
- Incremental ingestion (only new months)
- Partitioned Parquet storage
- Geospatial clustering & routing analysis
- Tile-based map outputs for web visualization
- Integration with a POI-based discovery app

## Why this project?

This is my project to help me cement some of the course material in [Data Engineering Zoomcamp](https://datatalks.club/blog/data-engineering-zoomcamp.html). 

This project helped bridge the gap between:

“following tutorials” → “building a real data pipeline”

It demonstrates:

- end-to-end data engineering
- reproducibility with Docker
- modern analytics patterns

## Author

Tim Anderson
(Web developer with a growing focus on data engineering, geospatial analysis, and sustainability-driven tech)