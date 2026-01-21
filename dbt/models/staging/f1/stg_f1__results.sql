SELECT
    cast(RESULTID AS integer) AS RESULT_ID,
    cast(RACEID AS integer) AS RACE_ID,
    cast(DRIVERID AS integer) AS DRIVER_ID,
    cast(CONSTRUCTORID AS integer) AS CONSTRUCTOR_ID,

    -- cast(nullif(number, '') as integer) as car_number,
    -- cast(nullif(grid, '') as integer) as grid_position,

    -- cast(nullif(position, '') as integer) as finish_position,
    cast(POSITIONTEXT AS varchar) AS FINISH_POSITION_TEXT,
    cast(POSITIONORDER AS integer) AS FINISH_POSITION_ORDER,

    cast(POINTS AS double) AS POINTS,
    cast(LAPS AS integer) AS LAPS_COMPLETED,

    cast(nullif(TIME, '') AS varchar) AS RACE_TIME_TEXT,
    -- cast(nullif(milliseconds, '') as bigint) as race_time_ms,

    -- cast(nullif(fastestLap, '') as integer) as fastest_lap_number,
    -- cast(nullif(rank, '') as integer) as fastest_lap_rank,
    -- cast(nullif(fastestLapTime, '') as varchar) as fastest_lap_time_text,
    -- cast(nullif(fastestLapSpeed, '') as double) as fastest_lap_speed,

    cast(STATUSID AS integer) AS STATUS_ID
FROM {{ source('f1', 'results') }}
