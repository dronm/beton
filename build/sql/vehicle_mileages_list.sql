-- View: vehicle_mileages_list

-- DROP VIEW vehicle_mileages_list;

CREATE OR REPLACE VIEW vehicle_mileages_list AS 
	SELECT
		ml.id,
	 	ml.vehicle_id,
	 	ml.for_date,
	 	ml.mileage,
	 	users_ref(users) as users_ref
 	FROM vehicle_mileages AS ml
 	left join users on users.id = ml.user_id
	ORDER BY
		ml.vehicle_id,
		ml.for_date desc;

ALTER TABLE vehicle_mileages_list OWNER TO ;

