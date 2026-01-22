SELECT
    location,
    country,
    url AS circuit_url,
    CAST(circuitid AS integer) AS circuit_id,
    CAST(circuitref AS string) AS circuit_short_name,
    CAST(name AS string) AS circuit_long_name,
    CAST(lat AS float) AS latitude,
    CAST(lng AS float) AS longitude,
    CAST(alt AS int) AS altitude
FROM {{ source('f1', 'circuits') }}
