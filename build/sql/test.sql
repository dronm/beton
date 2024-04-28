SELECT
	car_tracking.voltage,
	car_tracking.lon
FROM
	car_tracking
-- left JOIN vehicles as v on v.tracker_id = t.car_id
order by period desc limit 10;
