SELECT
    ride_id,
    started_at,
    ended_at,
    trip_date,
    trip_hour,
    trip_duration_min,

    start_station_name,
    end_station_name,

    member_casual

FROM {{ ref('stg_divvy_trips') }}
WHERE trip_duration_min > 0