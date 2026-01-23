SELECT
	driver_id,
	driver_ref,
	driver_number,
	driver_code,
	first_name,
	last_name,
    first_name || ' ' || last_name AS driver_full_name,
	date_of_birth,
	nationality,
	driver_url
FROM {{ ref('stg_f1__drivers') }}
