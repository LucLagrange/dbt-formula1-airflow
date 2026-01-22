SELECT
    CAST(constructorid AS integer) AS constructor_id,
    CAST(constructorref AS varchar) AS constructor_ref,
    CAST(name AS varchar) AS constructor_name,
    CAST(nationality AS varchar) AS nationality,
    CAST(url AS varchar) AS constructor_url
FROM {{ source('f1', 'constructors') }}
