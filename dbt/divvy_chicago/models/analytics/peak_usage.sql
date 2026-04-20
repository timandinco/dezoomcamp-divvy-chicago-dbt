SELECT
    trip_hour,
    COUNT(*) AS trips
FROM {{ ref('fct_trips') }}
GROUP BY trip_hour
ORDER BY trip_hour