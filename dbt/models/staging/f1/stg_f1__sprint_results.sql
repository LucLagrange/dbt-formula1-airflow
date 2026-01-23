SELECT
    CAST(resultid AS integer) AS result_id,
    CAST(raceid AS integer) AS race_id,
    CAST(driverid AS integer) AS driver_id,
    CAST(constructorid AS integer) AS constructor_id,
    CAST(number AS integer) AS car_number,
    CAST(grid AS integer) AS grid_position,
    CAST(NULLIF(position, '\N') AS integer) AS finish_position,
    {{ standardize_position_text('positiontext') }} AS finish_position_text,
    CAST(positionorder AS integer) AS finish_position_order,
    CAST(points AS double) AS points,
    CAST(laps AS integer) AS laps_completed,
    CAST(NULLIF(time, '\N') AS varchar) AS sprint_time_text,
    CAST(NULLIF(milliseconds, '\N') AS bigint) AS sprint_time_ms,
    CAST(NULLIF(fastestlap, '\N') AS integer) AS fastest_lap_number,
    CAST(NULLIF(fastestlaptime, '\N') AS varchar) AS fastest_lap_time_text,
    CAST(statusid AS integer) AS status_id
FROM {{ source('f1', 'sprint_results') }}
