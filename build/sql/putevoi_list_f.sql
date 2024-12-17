--one document for a shift

-- Function: putevoi_list_f(in_vehicle_id int, in_date date)

DROP FUNCTION putevoi_list_f(in_vehicle_id int, in_date date);

CREATE OR REPLACE FUNCTION putevoi_list_f(in_vehicle_id int, in_date date)
  RETURNS table(
	nomer text,
	data_den text,
	data_mes text,
	data_god text,

	avto_nomer text,
	avto_marka text,

	voditel_fio text,
	voditel_udost text,
	voditel_udost_class text,
	
	date_day_n text,
	date_mon_n text,
	date_hour_n text,
	date_min_n text,	
	spidom text,
	vrem_fakt text,
	
	vz_date_day_n text,
	vz_date_mon_n text,
	vz_date_hour_n text,
	vz_date_min_n text,
	vz_spidom text,
	vz_vrem_fakt text,
	
	zad1_client text,
	zad1_vrem text,
	zad1_object text,
	zad1_kol text,
	zad1_km text,
	zad1_nomen_naim text,
	zad1_ezd text,
	zad1_baza text,
	
	zad2_client text,
	zad2_vrem text,
	zad2_object text,
	zad2_kol text,
	zad2_km text,
	zad2_nomen_naim text,
	zad2_ezd text,
	zad2_baza text,

	zad3_client text,
	zad3_vrem text,
	zad3_object text,
	zad3_kol text,
	zad3_km text,
	zad3_nomen_naim text,
	zad3_ezd text,
	zad3_baza text,
	
	zad4_client text,
	zad4_vrem text,
	zad4_object text,
	zad4_kol text,
	zad4_km text,
	zad4_nomen_naim text,
	zad4_ezd text,
	zad4_baza text,
	
	zad5_client text,
	zad5_vrem text,
	zad5_object text,
	zad5_kol text,
	zad5_km text,
	zad5_nomen_naim text,
	zad5_ezd text,
	zad5_baza text,
	
	vrem_rab text 
  ) AS
$BODY$
	WITH
	shift AS (
		SELECT d1, d2 FROM get_shift_bounds(in_date) AS (d1 timestamp, d2 timestamp)
	),
	tasks AS (
		SELECT
			sub.client_name,
			sub.dest_name,
			sub.ct_name,
			sub.base_address,
			sub.quant,
			sub.runs,
			sub.mileage,
			sub.first_ship_arrive		
		FROM (
			SELECT
				cl.name AS client_name,
				dest.name AS dest_name,
				ct.official_name AS ct_name,
				pb.address AS base_address,
				sum(sh.quant) AS quant,
				count(sh.*) AS runs,
				SUM(coalesce(
					round(vehicle_mileage(
						vh.tracker_id,
						sh.ship_date_time,
						(SELECT
							st.date_time
						FROM vehicle_schedule_states AS st
						WHERE st.shipment_id = sh.id AND st.date_time>sh.ship_date_time
						ORDER BY st.date_time DESC
						LIMIT 1
						))
					), 0)
				) AS mileage,
				MIN((SELECT
					st.date_time
				FROM vehicle_schedule_states AS st
				WHERE st.shipment_id = sh.id AND st.date_time>sh.ship_date_time AND st.state='at_dest'
				ORDER BY st.date_time ASC
				LIMIT 1				
				)) AS first_ship_arrive
			FROM shipments AS sh
			LEFT JOIN orders AS o ON o.id = sh.order_id
			LEFT JOIN concrete_types AS ct ON ct.id = o.concrete_type_id
			LEFT JOIN clients AS cl ON cl.id = o.client_id
			LEFT JOIN destinations AS dest ON dest.id = o.destination_id
			LEFT JOIN vehicle_schedules AS sched ON sched.id = sh.vehicle_schedule_id
			LEFT JOIN vehicles AS vh ON vh.id = sched.vehicle_id
			LEFT JOIN production_bases AS pb ON pb.id = sched.production_base_id
			WHERE sched.vehicle_id = in_vehicle_id AND sh.date_time::date >= (SELECT d1 FROM shift) AND sh.date_time::date <= (SELECT d2 FROM shift)
			GROUP BY
				cl.name,
				pb.address,
				dest.name,
				ct.official_name
		) AS sub
		ORDER BY sub.first_ship_arrive
	),
	schedule AS (
		SELECT
			sch.id,
			sch.schedule_date,
			sch.vehicle_id,
			sch.driver_id
		FROM vehicle_schedules AS sch
		WHERE
			sch.vehicle_id = in_vehicle_id
			AND sch.schedule_date = in_date		
	),
	--firtst shipment
	depart AS (
		SELECT
			sh.ship_date_time
		FROM shipments AS sh
		WHERE
			sh.vehicle_schedule_id = (SELECT id FROM schedule)
			AND sh.date_time::date >= (SELECT d1 FROM shift) AND sh.date_time::date <= (SELECT d2 FROM shift)
		ORDER BY sh.date_time ASC
		LIMIT 1
	),
	--last shipment, at base state
	ret_to_base AS (
		SELECT
			st.date_time
		FROM vehicle_schedule_states AS st
		WHERE st.shipment_id = (
			--last shipment
			SELECT
				sh.id
			FROM shipments AS sh
			WHERE
				sh.vehicle_schedule_id = (SELECT id FROM schedule)
				AND sh.date_time::date >= (SELECT d1 FROM shift) AND sh.date_time::date <= (SELECT d2 FROM shift)
			ORDER BY sh.date_time DESC
			LIMIT 1
		)
		ORDER BY st.date_time DESC
		LIMIT 1
	)
	
	SELECT
		sch.id AS nomer,
		to_char(sch.schedule_date::date,'DD') AS data_den,
		to_char(sch.schedule_date::date,'TMMonth') AS data_mes,
		to_char(sch.schedule_date::date,'YYYY') AS data_god,
		
		coalesce(vh.plate,'') AS avto_nomer,
		coalesce(vh.make,'') AS avto_marka,

		CASE
			WHEN dr.employed THEN person_init(dr.name)
			ELSE person_init(dr_vh.name)
		END AS voditel_fio,
		CASE
			WHEN dr.employed THEN coalesce(dr.driver_licence,'')
			ELSE coalesce(dr_vh.driver_licence,'')
		END AS voditel_udost,
		CASE
			WHEN dr.employed THEN coalesce(dr.driver_licence_class,'')
			ELSE coalesce(dr_vh.driver_licence_class,'')
		END AS voditel_udost_class,
		
		-- departure: first ship
		to_char((SELECT ship_date_time FROM depart),'DD') AS date_day_n,
		to_char((SELECT ship_date_time FROM depart),'MM') AS date_mon_n,
		to_char((SELECT ship_date_time FROM depart),'HH24') AS date_hour_n,
		to_char((SELECT ship_date_time FROM depart),'MI') AS date_min_n,
		coalesce((SELECT
			ml.mileage::text
		FROM vehicle_mileages AS ml
		WHERE ml.vehicle_id = in_vehicle_id AND ml.for_date <= (SELECT d1 FROM shift)
		ORDER BY ml.for_date DESC
		LIMIT 1
		),'') AS spidom,
		to_char((SELECT ship_date_time FROM depart),'DD/MM HH24:MI') AS vrem_fakt,

		-- return: last ship
		to_char((SELECT date_time FROM ret_to_base),'DD') AS vz_date_day_n,
		to_char((SELECT date_time FROM ret_to_base),'MM') AS vz_date_mon_n,
		to_char((SELECT date_time FROM ret_to_base),'HH24') AS vz_date_hour_n,
		to_char((SELECT date_time FROM ret_to_base),'MI') AS vz_date_min_n,
		(coalesce((SELECT
			ml.mileage
		FROM vehicle_mileages AS ml
		WHERE ml.vehicle_id = in_vehicle_id AND ml.for_date <= (SELECT d1 FROM shift)
		ORDER BY ml.for_date DESC
		LIMIT 1
		),0) + coalesce(round(vehicle_mileage(vh.tracker_id, (SELECT d1 FROM shift), (SELECT d2 FROM shift))), 0)
		)::text
		AS vz_spidom,
		to_char((SELECT date_time FROM ret_to_base),'DD/MM HH24:MI') AS vz_vrem_fakt,
		
		coalesce((SELECT client_name::text FROM tasks OFFSET 0 LIMIT 1), '') AS zad1_client,
		coalesce((SELECT to_char(first_ship_arrive,'HH24:MI') FROM tasks OFFSET 0 LIMIT 1), '') AS zad1_vrem,
		coalesce((SELECT dest_name::text FROM tasks OFFSET 0 LIMIT 1), '') AS zad1_object,
		coalesce((SELECT quant::text FROM tasks OFFSET 0 LIMIT 1), '') AS zad1_kol,
		coalesce((SELECT mileage::text FROM tasks OFFSET 0 LIMIT 1), '') zad1_km,
		coalesce((SELECT ct_name::text FROM tasks OFFSET 0 LIMIT 1), '') zad1_nomen_naim,
		coalesce((SELECT runs::text FROM tasks OFFSET 0 LIMIT 1), '') zad1_ezd,
		coalesce((SELECT base_address::text FROM tasks OFFSET 0 LIMIT 1), '') zad1_baza,

		coalesce((SELECT client_name::text FROM tasks OFFSET 1 LIMIT 1), '') AS zad2_client,
		coalesce((SELECT to_char(first_ship_arrive,'HH24:MI') FROM tasks OFFSET 1 LIMIT 1), '') AS zad2_vrem,
		coalesce((SELECT dest_name::text FROM tasks OFFSET 1 LIMIT 1), '') AS zad2_object,
		coalesce((SELECT quant::text FROM tasks OFFSET 1 LIMIT 1), '') AS zad2_kol,
		coalesce((SELECT mileage::text FROM tasks OFFSET 1 LIMIT 1), '') zad2_km,
		coalesce((SELECT ct_name::text FROM tasks OFFSET 1 LIMIT 1), '') zad2_nomen_naim,
		coalesce((SELECT runs::text FROM tasks OFFSET 1 LIMIT 1), '') zad2_ezd,
		coalesce((SELECT base_address::text FROM tasks OFFSET 1 LIMIT 1), '') zad2_baza,

		coalesce((SELECT client_name::text FROM tasks OFFSET 2 LIMIT 1), '') AS zad3_client,
		coalesce((SELECT to_char(first_ship_arrive,'HH24:MI') FROM tasks OFFSET 2 LIMIT 1), '') AS zad3_vrem,
		coalesce((SELECT dest_name::text FROM tasks OFFSET 2 LIMIT 1), '') AS zad3_object,
		coalesce((SELECT quant::text FROM tasks OFFSET 2 LIMIT 1), '') AS zad3_kol,
		coalesce((SELECT mileage::text FROM tasks OFFSET 2 LIMIT 1), '') zad3_km,
		coalesce((SELECT ct_name::text FROM tasks OFFSET 2 LIMIT 1), '') zad3_nomen_naim,
		coalesce((SELECT runs::text FROM tasks OFFSET 2 LIMIT 1), '') zad3_ezd,
		coalesce((SELECT base_address::text FROM tasks OFFSET 2 LIMIT 1), '') zad3_baza,
		
		coalesce((SELECT client_name::text FROM tasks OFFSET 3 LIMIT 1), '') AS zad4_client,
		coalesce((SELECT to_char(first_ship_arrive,'HH24:MI') FROM tasks OFFSET 3 LIMIT 1), '') AS zad4_vrem,
		coalesce((SELECT dest_name::text FROM tasks OFFSET 3 LIMIT 1), '') AS zad4_object,
		coalesce((SELECT quant::text FROM tasks OFFSET 3 LIMIT 1), '') AS zad4_kol,
		coalesce((SELECT mileage::text FROM tasks OFFSET 3 LIMIT 1), '') zad4_km,
		coalesce((SELECT ct_name::text FROM tasks OFFSET 3 LIMIT 1), '') zad4_nomen_naim,
		coalesce((SELECT runs::text FROM tasks OFFSET 3 LIMIT 1), '') zad4_ezd,
		coalesce((SELECT base_address::text FROM tasks OFFSET 3 LIMIT 1), '') zad4_baza,

		coalesce((SELECT client_name::text FROM tasks OFFSET 4 LIMIT 1), '') AS zad5_client,
		coalesce((SELECT to_char(first_ship_arrive,'HH24:MI') FROM tasks OFFSET 4 LIMIT 1), '') AS zad5_vrem,
		coalesce((SELECT dest_name::text FROM tasks OFFSET 4 LIMIT 1), '') AS zad5_object,
		coalesce((SELECT quant::text FROM tasks OFFSET 4 LIMIT 1), '') AS zad5_kol,
		coalesce((SELECT mileage::text FROM tasks OFFSET 4 LIMIT 1), '') zad5_km,
		coalesce((SELECT ct_name::text FROM tasks OFFSET 4 LIMIT 1), '') zad5_nomen_naim,
		coalesce((SELECT runs::text FROM tasks OFFSET 4 LIMIT 1), '') zad5_ezd,
		coalesce((SELECT base_address::text FROM tasks OFFSET 4 LIMIT 1), '') zad5_baza,
		
		coalesce(
			to_char((SELECT date_time FROM ret_to_base) - (SELECT ship_date_time FROM depart), 'HH24:MI')
		, '') AS vrem_rab
		
	FROM schedule AS sch
	LEFT JOIN vehicles AS vh ON vh.id = sch.vehicle_id
	LEFT JOIN drivers AS dr ON dr.id = sch.driver_id
	LEFT JOIN drivers AS dr_vh ON dr_vh.id = vh.driver_id
	; 
$BODY$
LANGUAGE sql IMMUTABLE COST 100;
ALTER FUNCTION putevoi_list_f(in_vehicle_id int, in_date date) OWNER TO ;
