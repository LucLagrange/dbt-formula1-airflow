SELECT
    CAST(statusid AS integer) AS status_id,
    CAST(status AS varchar) AS status_description
FROM {{ source('f1', 'status') }}
