WITH source AS (

    SELECT *
    FROM {{ source_parquet('/workspace/data/raw/*.parquet') }}

),

ranked AS (

    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY ride_id
            ORDER BY 
              (start_station_name IS NOT NULL) DESC,
              (end_station_name IS NOT NULL) DESC,
              started_at
        ) AS rn

    FROM source

),

deduped AS (

    SELECT *
    FROM ranked
    WHERE rn = 1

)

SELECT
    ride_id,
    rideable_type,

    started_at::timestamp AS started_at,
    ended_at::timestamp   AS ended_at,

    start_station_name,
    end_station_name,

    start_lat,
    start_lng,
    end_lat,
    end_lng,

    member_casual,

    date_trunc('day', started_at::timestamp) AS trip_date,
    EXTRACT(hour FROM started_at::timestamp) AS trip_hour,

    datediff('minute', started_at::timestamp, ended_at::timestamp) AS trip_duration_min

FROM deduped
WHERE ride_id IS NOT NULL




