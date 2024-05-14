SELECT
	car_tracking.period,
	car_tracking.recieved_dt,
	car_tracking.lon,
	car_tracking.lat
FROM
	car_tracking
WHERE car_tracking.period > '2024-05-01'
--BETWEEN '2024-01-01' AND '2024-05-01'
order by period desc limit 10;
