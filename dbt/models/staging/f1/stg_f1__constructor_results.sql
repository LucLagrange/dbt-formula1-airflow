SELECT
    CAST(constructorresultsid AS integer) AS constructor_result_id,
    CAST(raceid AS integer) AS race_id,
    CAST(constructorid AS integer) AS constructor_id,
    CAST(points AS integer) AS points,
    NULLIF(status, '\N') AS status
FROM {{ source('f1', 'constructor_results') }}
