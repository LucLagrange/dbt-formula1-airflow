SELECT
    CAST(raceid AS integer) AS race_id,
    CAST(driverid AS integer) AS driver_id,
    CAST(stop AS integer) AS stop_number,
    CAST(lap AS integer) AS lap_number,
    CAST(time AS varchar) AS pit_time,
    CAST(duration AS varchar) AS duration_text,
    CAST(milliseconds AS integer) AS duration_ms
FROM {{ source('f1', 'pit_stops') }}
