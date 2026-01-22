SELECT
    CAST(raceid AS integer) AS race_id,
    CAST(driverid AS integer) AS driver_id,
    CAST(lap AS integer) AS lap_number,
    CAST(position AS integer) AS position,
    CAST(time AS varchar) AS lap_time_text,
    CAST(milliseconds AS integer) AS lap_time_ms
FROM {{ source('f1', 'lap_times') }}
