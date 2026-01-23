SELECT
    races.race_id,
    races.season_year,
    races.season_round,
    races.circuit_id,
    races.race_name,
    races.race_date,
    circuits.circuit_long_name,
    circuits.location AS circuit_location,
    circuits.country AS circuit_country
FROM {{ ref('stg_f1__races') }} AS races
LEFT JOIN {{ ref('stg_f1__circuits') }} AS circuits ON races.circuit_id = circuits.circuit_id
