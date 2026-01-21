SELECT
    cast(raceid AS integer) AS race_id,
    cast(year AS integer) AS season_year,
    cast(round AS integer) AS round,
    cast(circuitid AS integer) AS circuit_id,
    cast(name AS varchar) AS race_name,

    cast(date AS date) AS race_date,
    -- cast(nullif(time, '') as time) as race_time_utc,
    cast(url AS varchar) AS race_url
    /*
  cast(fp1_date as date) as fp1_date,
  cast(nullif(fp1_time, '') as time) as fp1_time_utc,
  cast(fp2_date as date) as fp2_date,
  cast(nullif(fp2_time, '') as time) as fp2_time_utc,
  cast(fp3_date as date) as fp3_date,
  cast(nullif(fp3_time, '') as time) as fp3_time_utc,

  cast(quali_date as date) as qualifying_date,
  cast(nullif(quali_time, '') as time) as qualifying_time_utc,

  cast(sprint_date as date) as sprint_date,
  cast(nullif(sprint_time, '') as time) as sprint_time_utc
  */
FROM {{ source('f1', 'races') }}
