SELECT
    CAST(constructorresultsid AS integer) AS constructor_result_id,
    CAST(raceid AS integer) AS race_id,
    CAST(constructorid AS integer) AS constructor_id,
    CAST(points AS integer) AS points,
    CASE
        WHEN status = '\N' THEN NULL 
        WHEN status = 'D' THEN 'Disqualified'
    ELSE status END AS status
FROM {{ source('f1', 'constructor_results') }}
