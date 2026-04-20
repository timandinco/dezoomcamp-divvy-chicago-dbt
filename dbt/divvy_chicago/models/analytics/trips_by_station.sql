SELECT
    start_station_name,
    COUNT(*) AS trip_count
FROM {{ ref('fct_trips') }}
GROUP BY start_station_name
ORDER BY trip_count DESC
LIMIT 20