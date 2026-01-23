SELECT
    CAST(raceid AS integer) AS race_id,
    CAST(driverid AS integer) AS driver_id,
    CAST(lap AS integer) AS lap_number,
    CAST(position AS integer) AS lap_position,
    CAST(time AS varchar) AS lap_time_text,
    CAST(milliseconds AS double) / 1000 AS lap_time_seconds
FROM {{ source('f1', 'lap_times') }}
