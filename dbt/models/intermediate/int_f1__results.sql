SELECT
    -- IDs
    results.race_id,
    results.driver_id,
    results.constructor_id,
    status.status_id,
    -- Race context
    races.race_date,
    races.season_year,
    races.season_round,
    -- Results
    results.grid_position,
    results.finish_position,
    results.grid_position - results.finish_position AS position_delta,
    results.laps_completed,
    status.status_description AS finish_status,
    CASE
        WHEN results.status_description = 'Finished' THEN true
        WHEN substring(results.status_description, 1, 1) = '+' THEN true
        ELSE false
    END AS has_finished,
    results.points AS points_scored,
    results.fastest_lap_rank
FROM
    {{ ref('stg_f1__results') }} AS results
LEFT JOIN
    {{ ref('stg_f1__status') }} AS status
    ON results.status_id = status.status_id
LEFT JOIN
    {{ ref('stg_f1__races') }} AS races
    ON results.race_id = races.race_id
