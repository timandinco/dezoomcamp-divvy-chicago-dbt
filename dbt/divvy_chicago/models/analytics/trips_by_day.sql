SELECT
    trip_date,
    COUNT(*) AS total_trips,
    AVG(trip_duration_min) AS avg_duration
FROM {{ ref('fct_trips') }}
GROUP BY trip_date
ORDER BY trip_date