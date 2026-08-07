-- View: vehicle_mileages_list

-- DROP VIEW vehicle_mileages_list;
CREATE OR REPLACE VIEW vehicle_mileages_list AS
SELECT
	ml.id,
	ml.vehicle_id,
	ml.for_date,
	ml.mileage,
	ml.timing,
	ml.mileage - LAG(ml.mileage) OVER (
		PARTITION BY ml.vehicle_id
		ORDER BY
			ml.for_date,
			ml.id
	) AS distance,
	users_ref(users) AS users_ref
FROM vehicle_mileages AS ml
LEFT JOIN users
	ON users.id = ml.user_id
ORDER BY
	ml.vehicle_id,
	ml.for_date DESC,
	ml.id DESC;
