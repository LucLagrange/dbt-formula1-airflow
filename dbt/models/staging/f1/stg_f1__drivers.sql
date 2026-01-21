select
  cast(driverId as integer) as driver_id,
  cast(driverRef as varchar) as driver_ref,
  cast(nullif(number, '') as integer) as driver_number,
  cast(nullif(code, '') as varchar) as driver_code,
  cast(forename as varchar) as first_name,
  cast(surname as varchar) as last_name,
  cast(dob as date) as date_of_birth,
  cast(nationality as varchar) as nationality,
  cast(url as varchar) as driver_url
from {{ source('f1', 'drivers') }}