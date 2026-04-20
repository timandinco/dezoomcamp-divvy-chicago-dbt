SELECT DISTINCT
    start_station_name AS station_name,
    start_lat AS lat,
    start_lng AS lng
FROM {{ ref('stg_divvy_trips') }}
WHERE start_station_name IS NOT NULL