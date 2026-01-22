SELECT
    CAST(driverstandingsid AS integer) AS driver_standings_id,
    CAST(raceid AS integer) AS race_id,
    CAST(driverid AS integer) AS driver_id,
    CAST(points AS double) AS points,
    CAST(position AS integer) AS position,
    CAST(positiontext AS varchar) AS position_text,
    CAST(wins AS integer) AS wins
FROM {{ source('f1', 'driver_standings') }}
