SELECT
    CAST(qualifyid AS integer) AS qualify_id,
    CAST(raceid AS integer) AS race_id,
    CAST(driverid AS integer) AS driver_id,
    CAST(constructorid AS integer) AS constructor_id,
    CAST(number AS integer) AS car_number,
    CAST(position AS integer) AS qualifying_position,
    CAST(NULLIF(q1, '\N') AS varchar) AS q1_time,
    CAST(NULLIF(q2, '\N') AS varchar) AS q2_time,
    CAST(NULLIF(q3, '\N') AS varchar) AS q3_time
FROM {{ source('f1', 'qualifying') }}
