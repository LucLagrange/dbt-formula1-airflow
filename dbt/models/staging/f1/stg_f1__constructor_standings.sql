SELECT
    CAST(constructorstandingsid AS integer) AS constructor_standings_id,
    CAST(raceid AS integer) AS race_id,
    CAST(constructorid AS integer) AS constructor_id,
    CAST(points AS double) AS points,
    CAST(position AS integer) AS position,
    CAST(positiontext AS varchar) AS position_text,
    CAST(wins AS integer) AS wins
FROM {{ source('f1', 'constructor_standings') }}
