SELECT
    CAST(driverid AS integer) AS driver_id,
    CAST(driverref AS varchar(255)) AS driver_ref,
    CAST(NULLIF(number, '\N') AS integer) AS driver_number,
    CAST(NULLIF(code, '\N') AS varchar) AS driver_code,
    CAST(forename AS varchar) AS first_name,
    CAST(surname AS varchar) AS last_name,
    CAST(dob AS date) AS date_of_birth,
    CAST(nationality AS varchar) AS nationality,
    CAST(url AS varchar) AS driver_url
FROM {{ source('f1', 'drivers') }}
