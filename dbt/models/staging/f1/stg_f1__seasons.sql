SELECT
    CAST(year AS integer) AS season_year,
    CAST(url AS varchar) AS season_url
FROM {{ source('f1', 'seasons') }}
