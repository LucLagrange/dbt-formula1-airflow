select
  cast(resultId as integer) as result_id,
  cast(raceId as integer) as race_id,
  cast(driverId as integer) as driver_id,
  cast(constructorId as integer) as constructor_id,

  cast(nullif(number, '') as integer) as car_number,
  cast(nullif(grid, '') as integer) as grid_position,

  cast(nullif(position, '') as integer) as finish_position,
  cast(positionText as varchar) as finish_position_text,
  cast(positionOrder as integer) as finish_position_order,

  cast(points as double) as points,
  cast(laps as integer) as laps_completed,

  cast(nullif(time, '') as varchar) as race_time_text,
  cast(nullif(milliseconds, '') as bigint) as race_time_ms,

  cast(nullif(fastestLap, '') as integer) as fastest_lap_number,
  cast(nullif(rank, '') as integer) as fastest_lap_rank,
  cast(nullif(fastestLapTime, '') as varchar) as fastest_lap_time_text,
  cast(nullif(fastestLapSpeed, '') as double) as fastest_lap_speed,

  cast(statusId as integer) as status_id
from {{ source('f1', 'results') }}