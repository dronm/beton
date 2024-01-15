--select * from car_tracking where car_id='351457'
select
	point,
	point->>'client',
	to_timestamp((point->>'navigation_unix_time')::int),
	to_timestamp((point->>'received_unix_time')::int),
	(point->>'longitude')::numeric,
	(point->>'latitude')::numeric,
	(point->>'speed')::numeric
from egts_data
--where point->>'client'='351457'
order by to_timestamp((point->>'received_unix_time')::int) DESC
limit 100
