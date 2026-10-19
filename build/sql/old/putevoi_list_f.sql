--one document for a shift

-- Function: putevoi_list_f(in_vehicle_id int, in_date date)

--DROP FUNCTION putevoi_list_f(in_vehicle_id int, in_date date);

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
	--zad1_kol text,
	--zad1_km text,
	zad1_nomen_naim text,
	zad1_ezd text,
	zad1_baza text,
	
	zad2_client text,
	zad2_vrem text,
	zad2_object text,
	--zad2_kol text,
	--zad2_km text,
	zad2_nomen_naim text,
	zad2_ezd text,
	zad2_baza text,

	zad3_client text,
	zad3_vrem text,
	zad3_object text,
	--zad3_kol text,
	--zad3_km text,
	zad3_nomen_naim text,
	zad3_ezd text,
	zad3_baza text,
	
	zad4_client text,
	zad4_vrem text,
	zad4_object text,
	--zad4_kol text,
	--zad4_km text,
	zad4_nomen_naim text,
	zad4_ezd text,
	zad4_baza text,
	
	zad5_client text,
	zad5_vrem text,
	zad5_object text,
	--zad5_kol text,
	--zad5_km text,
	zad5_nomen_naim text,
	zad5_ezd text,
	zad5_baza text,
	
	vrem_rab text,
	topl_nach int,
	topl_kon int,
	topl_prih int,

	dispatcher text,

	vs_ezd text,
	--vs_km text,
	--vs_kol text,

	vs_ttn text,
	vs_ttn_prop text,

	punkt1 text,
	punkt1_prib_date text,
	punkt1_prib_h text,
	punkt1_prib_m text,
	punkt1_ubit_h text, 
	punkt1_ubit_m text,
	punkt1_ttn_id text,
	punkt1_gruzopol text,

	punkt2 text,
	punkt2_prib_date text,
	punkt2_prib_h text,
	punkt2_prib_m text,
	punkt2_ubit_h text, 
	punkt2_ubit_m text,
	punkt2_ttn_id text,
	punkt2_gruzopol text,

	punkt3 text,
	punkt3_prib_date text,
	punkt3_prib_h text,
	punkt3_prib_m text,
	punkt3_ubit_h text, 
	punkt3_ubit_m text,
	punkt3_ttn_id text,
	punkt3_gruzopol text,

	punkt4 text,
	punkt4_prib_date text,
	punkt4_prib_h text,
	punkt4_prib_m text,
	punkt4_ubit_h text, 
	punkt4_ubit_m text,
	punkt4_ttn_id text,
	punkt4_gruzopol text,

	punkt5 text,
	punkt5_prib_date text,
	punkt5_prib_h text,
	punkt5_prib_m text,
	punkt5_ubit_h text, 
	punkt5_ubit_m text,
	punkt5_ttn_id text,
	punkt5_gruzopol text,

	punkt6 text,
	punkt6_prib_date text,
	punkt6_prib_h text,
	punkt6_prib_m text,
	punkt6_ubit_h text, 
	punkt6_ubit_m text,
	punkt6_ttn_id text,
	punkt6_gruzopol text,

	punkt7 text,
	punkt7_prib_date text,
	punkt7_prib_h text,
	punkt7_prib_m text,
	punkt7_ubit_h text, 
	punkt7_ubit_m text,
	punkt7_ttn_id text,
	punkt7_gruzopol text,

	punkt8 text,
	punkt8_prib_date text,
	punkt8_prib_h text,
	punkt8_prib_m text,
	punkt8_ubit_h text, 
	punkt8_ubit_m text,
	punkt8_ttn_id text,
	punkt8_gruzopol text
  ) AS
$BODY$
	WITH
	shift AS (
		SELECT d1, d2 FROM get_shift_bounds(in_date+'06:00:00'::time) AS (d1 timestamp, d2 timestamp)
	),
	fuel_beg AS (
		SELECT quant FROM rg_fuel_flow_balance( (SELECT d1 FROM shift), ARRAY[in_vehicle_id])
	),
	fuel_act AS (
		SELECT 
			sum(CASE WHEN f.deb THEN f.quant ELSE 0 END) AS deb,
			sum(CASE WHEN NOT f.deb THEN f.quant ELSE 0 END) AS kred
		FROM ra_fuel_flow AS f
		WHERE f.vehicle_id = in_vehicle_id
			AND f.date_time BETWEEN (SELECT d1 from shift) AND (SELECT d2 from shift)
	),
	fuel_end AS (
		SELECT
			coalesce( (SELECT quant FROM fuel_beg), 0) +
			coalesce( (SELECT deb FROM fuel_act), 0) -
			coalesce( (SELECT kred FROM fuel_act), 0)
		AS val
	),
	-- Individual shipments for punkt1 ... punkt8: no grouping.
	point_times AS (
		SELECT
			row_number() OVER (ORDER BY sh.date_time ASC, sh.id ASC) AS run_no,
			sh.id AS ship_id,
			cl.name AS client_name,
			dest.name AS dest_name,
			coalesce(
				(
					SELECT st.date_time
					FROM vehicle_schedule_states AS st
					WHERE st.shipment_id = sh.id
						AND st.date_time > sh.ship_date_time
						AND st.state = 'at_dest'
					ORDER BY st.date_time ASC
					LIMIT 1
				),
				(
					SELECT st.date_time
					FROM vehicle_schedule_states AS st
					WHERE st.shipment_id = sh.id
						AND st.state = 'busy'
					ORDER BY st.date_time ASC
					LIMIT 1
				) + dest.time_route::interval
			) AS ship_arrive,
			(
				SELECT st.date_time
				FROM vehicle_schedule_states AS st
				WHERE st.shipment_id = sh.id
					AND st.date_time > sh.ship_date_time
					AND st.state = 'left_for_base'
				ORDER BY st.date_time ASC
				LIMIT 1
			) AS ship_left
		FROM shipments AS sh
		LEFT JOIN orders AS o ON o.id = sh.order_id
		LEFT JOIN clients AS cl ON cl.id = o.client_id
		LEFT JOIN destinations AS dest ON dest.id = o.destination_id
		LEFT JOIN vehicle_schedules AS sched ON sched.id = sh.vehicle_schedule_id
		WHERE sched.vehicle_id = in_vehicle_id
			AND sh.date_time::date = in_date
	),
	points AS (
		SELECT
			run_no,
			ship_id,
			client_name,
			dest_name,
			ship_arrive,
			coalesce(ship_left, ship_arrive + interval '30 minutes') AS ship_left
		FROM point_times
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
			sub.first_ship_arrive,
			sub.ship_left,
			sub.ship_id
		FROM (
			SELECT
				cl.name AS client_name,
				dest.name AS dest_name,
				ct.official_name AS ct_name,
				pb.address AS base_address,
				sum(sh.quant) AS quant,
				count(sh.*) AS runs,

				SUM(
					coalesce(
						round(
							vehicle_mileage(
								vh.tracker_id,
								sh.ship_date_time,
								(
									SELECT
										st.date_time
									FROM vehicle_schedule_states AS st
									WHERE
										st.shipment_id = sh.id
										AND st.date_time > sh.ship_date_time
									ORDER BY st.date_time DESC
									LIMIT 1
								)
							)
						),
						0
					)
				) AS mileage,

				MIN(pt.ship_arrive) AS first_ship_arrive,

				/*
				 * Departure time of the first shipment in this task.
				 * Shipment order is determined by shipments.date_time.
				 */
				(
					array_agg(
						pt.ship_left
						ORDER BY
							sh.date_time ASC,
							sh.id ASC
					)
				)[1] AS ship_left,

				/*
				 * ID of the same first shipment.
				 */
				(
					array_agg(
						sh.id
						ORDER BY
							sh.date_time ASC,
							sh.id ASC
					)
				)[1] AS ship_id

			FROM shipments AS sh

			LEFT JOIN points AS pt ON pt.ship_id = sh.id

			LEFT JOIN orders AS o
				ON o.id = sh.order_id

			LEFT JOIN concrete_types AS ct
				ON ct.id = o.concrete_type_id

			LEFT JOIN clients AS cl
				ON cl.id = o.client_id

			LEFT JOIN destinations AS dest
				ON dest.id = o.destination_id

			LEFT JOIN vehicle_schedules AS sched
				ON sched.id = sh.vehicle_schedule_id

			LEFT JOIN vehicles AS vh
				ON vh.id = sched.vehicle_id

			LEFT JOIN production_bases AS pb
				ON pb.id = sched.production_base_id

			WHERE
				sched.vehicle_id = in_vehicle_id
				AND sh.date_time::date = in_date
				--AND sh.date_time::date >= (SELECT d1 FROM shift)
				--AND sh.date_time::date <= (SELECT d2 FROM shift)

			GROUP BY
				cl.name,
				pb.address,
				dest.name,
				ct.official_name
		) AS sub

		ORDER BY
			sub.first_ship_arrive
	),schedule AS (
	SELECT
		sch.id,
		coalesce(sch.schedule_date, in_date) AS schedule_date,
		vh.id AS vehicle_id,
		coalesce(sch.driver_id, vh.driver_id) AS driver_id
	FROM vehicles AS vh
	LEFT JOIN LATERAL (
		SELECT
			s.id,
			s.schedule_date,
			s.driver_id
		FROM vehicle_schedules AS s
		WHERE s.vehicle_id = vh.id
			AND s.schedule_date = in_date
		ORDER BY s.id
		LIMIT 1
	) AS sch ON TRUE
	WHERE vh.id = in_vehicle_id
),
	--dispatcher without any shipment, just date
	first_dispatcher AS (
		SELECT
			person_init(oper_u.name) AS name
		FROM operators_for_transp_nakl_schedules AS opers
		LEFT JOIN users AS oper_u ON oper_u.id  = opers.user_id
		WHERE opers.for_date = in_date
		ORDER BY opers.production_site_id
		LIMIT 1
	),

	--firtst shipment
	depart AS (
		SELECT
			sh.ship_date_time,
			person_init(oper_u.name) AS dispatcher_name
		FROM shipments AS sh
		--LEFT JOIN production_sites AS ps ON ps.id = sh.production_site_id
		--LEFT JOIN production_bases AS pb ON pb.id = ps.production_base_id
		--LEFT JOIN employees AS disp_emp ON disp_emp.id = ps.dispatcher_id
		LEFT JOIN operators_for_transp_nakl_schedules AS opers ON 
			opers.production_site_id  = sh.production_site_id AND opers.for_date = in_date
		LEFT JOIN users AS oper_u ON oper_u.id  = opers.user_id
		-- LEFT JOIN entity_contacts AS ent_ct ON ent_ct.entity_id  = oper_u.id AND ent_ct.entity_type = 'users'
		-- LEFT JOIN contacts AS ct ON ct.id  = ent_ct.contact_id
		WHERE
			sh.vehicle_schedule_id = (SELECT id FROM schedule)
			AND sh.date_time::date = in_date
			--AND sh.date_time::date >= (SELECT d1 FROM shift) 
			--AND sh.date_time::date <= (SELECT d2 FROM shift)
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
				AND sh.date_time::date = in_date
				--AND sh.date_time::date >= (SELECT d1 FROM shift) 
				--AND sh.date_time::date <= (SELECT d2 FROM shift)
			ORDER BY sh.date_time DESC
			LIMIT 1
		)
		ORDER BY st.date_time DESC
		LIMIT 1
	)
	
	SELECT
		coalesce(sch.id::text, '') AS nomer,
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
		WHERE ml.vehicle_id = in_vehicle_id AND ml.for_date <= in_date--(SELECT d1 FROM shift)
		ORDER BY ml.for_date DESC
		LIMIT 1
		),'') AS spidom,
		to_char((SELECT ship_date_time FROM depart),'DD/MM HH24:MI') AS vrem_fakt,

		-- return: last ship
		to_char((SELECT date_time FROM ret_to_base),'DD') AS vz_date_day_n,
		to_char((SELECT date_time FROM ret_to_base),'MM') AS vz_date_mon_n,
		to_char((SELECT date_time FROM ret_to_base),'HH24') AS vz_date_hour_n,
		to_char((SELECT date_time FROM ret_to_base),'MI') AS vz_date_min_n,

		coalesce((SELECT
			ml.mileage +
			(SELECT coalesce(sum(mileage), 0) FROM tasks)
		FROM vehicle_mileages AS ml
		WHERE ml.vehicle_id = in_vehicle_id AND ml.for_date <= in_date --(SELECT d1 FROM shift)
		ORDER BY ml.for_date DESC
		LIMIT 1
		)::text,'')
		AS vz_spidom,

		to_char((SELECT date_time FROM ret_to_base),'DD/MM HH24:MI') AS vz_vrem_fakt,
		
		coalesce((SELECT client_name::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 0 LIMIT 1), '') AS zad1_client,
		coalesce((SELECT to_char(first_ship_arrive,'HH24:MI') FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 0 LIMIT 1), '') AS zad1_vrem,
		coalesce((SELECT dest_name::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 0 LIMIT 1), '') AS zad1_object,
		--coalesce((SELECT (quant*2.4)::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 0 LIMIT 1), '') AS zad1_kol,
		--coalesce((SELECT mileage::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 0 LIMIT 1), '') zad1_km,
		coalesce((SELECT ct_name::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 0 LIMIT 1), '') zad1_nomen_naim,
		coalesce((SELECT runs::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 0 LIMIT 1), '') zad1_ezd,
		coalesce((SELECT base_address::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 0 LIMIT 1), '') zad1_baza,

		coalesce((SELECT client_name::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 1 LIMIT 1), '') AS zad2_client,
		coalesce((SELECT to_char(first_ship_arrive,'HH24:MI') FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 1 LIMIT 1), '') AS zad2_vrem,
		coalesce((SELECT dest_name::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 1 LIMIT 1), '') AS zad2_object,
		--coalesce((SELECT (quant*2.4)::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 1 LIMIT 1), '') AS zad2_kol,
		--coalesce((SELECT mileage::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 1 LIMIT 1), '') zad2_km,
		coalesce((SELECT ct_name::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 1 LIMIT 1), '') zad2_nomen_naim,
		coalesce((SELECT runs::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 1 LIMIT 1), '') zad2_ezd,
		coalesce((SELECT base_address::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 1 LIMIT 1), '') zad2_baza,

		coalesce((SELECT client_name::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 2 LIMIT 1), '') AS zad3_client,
		coalesce((SELECT to_char(first_ship_arrive,'HH24:MI') FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 2 LIMIT 1), '') AS zad3_vrem,
		coalesce((SELECT dest_name::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 2 LIMIT 1), '') AS zad3_object,
		--coalesce((SELECT (quant*2.4)::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 2 LIMIT 1), '') AS zad3_kol,
		--coalesce((SELECT mileage::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 2 LIMIT 1), '') zad3_km,
		coalesce((SELECT ct_name::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 2 LIMIT 1), '') zad3_nomen_naim,
		coalesce((SELECT runs::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 2 LIMIT 1), '') zad3_ezd,
		coalesce((SELECT base_address::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 2 LIMIT 1), '') zad3_baza,
		
		coalesce((SELECT client_name::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 3 LIMIT 1), '') AS zad4_client,
		coalesce((SELECT to_char(first_ship_arrive,'HH24:MI') FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 3 LIMIT 1), '') AS zad4_vrem,
		coalesce((SELECT dest_name::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 3 LIMIT 1), '') AS zad4_object,
		--coalesce((SELECT (quant*2.4)::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 3 LIMIT 1), '') AS zad4_kol,
		--coalesce((SELECT mileage::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 3 LIMIT 1), '') zad4_km,
		coalesce((SELECT ct_name::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 3 LIMIT 1), '') zad4_nomen_naim,
		coalesce((SELECT runs::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 3 LIMIT 1), '') zad4_ezd,
		coalesce((SELECT base_address::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 3 LIMIT 1), '') zad4_baza,

		coalesce((SELECT client_name::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 4 LIMIT 1), '') AS zad5_client,
		coalesce((SELECT to_char(first_ship_arrive,'HH24:MI') FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 4 LIMIT 1), '') AS zad5_vrem,
		coalesce((SELECT dest_name::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 4 LIMIT 1), '') AS zad5_object,
		--coalesce((SELECT (quant*2.4)::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 4 LIMIT 1), '') AS zad5_kol,
		--coalesce((SELECT mileage::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 4 LIMIT 1), '') zad5_km,
		coalesce((SELECT ct_name::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 4 LIMIT 1), '') zad5_nomen_naim,
		coalesce((SELECT runs::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 4 LIMIT 1), '') zad5_ezd,
		coalesce((SELECT base_address::text FROM tasks ORDER BY first_ship_arrive NULLS LAST, ship_id OFFSET 4 LIMIT 1), '') zad5_baza,
		
		coalesce(
			to_char((SELECT date_time FROM ret_to_base) - (SELECT ship_date_time FROM depart), 'HH24:MI')
		, '') AS vrem_rab, 
		
		coalesce((SELECT quant FROM fuel_beg), 0) AS topl_nach,
		coalesce((SELECT val FROM fuel_end), 0) AS topl_kon,
		coalesce((SELECT deb FROM fuel_act), 0) AS topl_prih,

		coalesce(
			(SELECT dispatcher_name FROM depart),
			(SELECT name FROM first_dispatcher)
		) AS dispatcher,

		coalesce(
			(
			(SELECT coalesce(sum(runs), 0) FROM tasks)
			)::text
			, 
		'') vs_ezd,
		/*	
		coalesce(
			(
			(SELECT coalesce(sum(mileage), 0) FROM tasks)
			)::text
			, 
		'') vs_km,*/
		/*coalesce(
			((
			(SELECT coalesce(sum(quant), 0) FROM tasks)
			)*2.4)::text
			, 
		'') vs_kol,*/

		coalesce(
			(
			(SELECT coalesce(sum(runs), 0) FROM tasks)
			)::text
			, 
		'') vs_ttn,
		number_to_russian_1_8(
			(SELECT coalesce(sum(runs), 0)::bigint FROM tasks)
		) AS vs_ttn_prop,

		coalesce((SELECT dest_name::text FROM points WHERE run_no = 1), '') AS punkt1,
		coalesce((SELECT to_char(ship_arrive,'DD/MM') FROM points WHERE run_no = 1), '') AS punkt1_prib_date,
		coalesce((SELECT to_char(ship_arrive,'HH24') FROM points WHERE run_no = 1), '') AS punkt1_prib_h,
		coalesce((SELECT to_char(ship_arrive,'MI') FROM points WHERE run_no = 1), '') AS punkt1_prib_m,
		coalesce((SELECT to_char(ship_left,'HH24') FROM points WHERE run_no = 1), '') AS punkt1_ubit_h,
		coalesce((SELECT to_char(ship_left,'MI') FROM points WHERE run_no = 1), '') AS punkt1_ubit_m,
		coalesce((SELECT ship_id::text FROM points WHERE run_no = 1), '') AS punkt1_ttn_id,
		coalesce((SELECT client_name::text FROM points WHERE run_no = 1), '') AS punkt1_gruzopol,

		coalesce((SELECT dest_name::text FROM points WHERE run_no = 2), '') AS punkt2,
		coalesce((SELECT to_char(ship_arrive,'DD/MM') FROM points WHERE run_no = 2), '') AS punkt2_prib_date,
		coalesce((SELECT to_char(ship_arrive,'HH24') FROM points WHERE run_no = 2), '') AS punkt2_prib_h,
		coalesce((SELECT to_char(ship_arrive,'MI') FROM points WHERE run_no = 2), '') AS punkt2_prib_m,
		coalesce((SELECT to_char(ship_left,'HH24') FROM points WHERE run_no = 2), '') AS punkt2_ubit_h,
		coalesce((SELECT to_char(ship_left,'MI') FROM points WHERE run_no = 2), '') AS punkt2_ubit_m,
		coalesce((SELECT ship_id::text FROM points WHERE run_no = 2), '') AS punkt2_ttn_id,
		coalesce((SELECT client_name::text FROM points WHERE run_no = 2), '') AS punkt2_gruzopol,

		coalesce((SELECT dest_name::text FROM points WHERE run_no = 3), '') AS punkt3,
		coalesce((SELECT to_char(ship_arrive,'DD/MM') FROM points WHERE run_no = 3), '') AS punkt3_prib_date,
		coalesce((SELECT to_char(ship_arrive,'HH24') FROM points WHERE run_no = 3), '') AS punkt3_prib_h,
		coalesce((SELECT to_char(ship_arrive,'MI') FROM points WHERE run_no = 3), '') AS punkt3_prib_m,
		coalesce((SELECT to_char(ship_left,'HH24') FROM points WHERE run_no = 3), '') AS punkt3_ubit_h,
		coalesce((SELECT to_char(ship_left,'MI') FROM points WHERE run_no = 3), '') AS punkt3_ubit_m,
		coalesce((SELECT ship_id::text FROM points WHERE run_no = 3), '') AS punkt3_ttn_id,
		coalesce((SELECT client_name::text FROM points WHERE run_no = 3), '') AS punkt3_gruzopol,

		coalesce((SELECT dest_name::text FROM points WHERE run_no = 4), '') AS punkt4,
		coalesce((SELECT to_char(ship_arrive,'DD/MM') FROM points WHERE run_no = 4), '') AS punkt4_prib_date,
		coalesce((SELECT to_char(ship_arrive,'HH24') FROM points WHERE run_no = 4), '') AS punkt4_prib_h,
		coalesce((SELECT to_char(ship_arrive,'MI') FROM points WHERE run_no = 4), '') AS punkt4_prib_m,
		coalesce((SELECT to_char(ship_left,'HH24') FROM points WHERE run_no = 4), '') AS punkt4_ubit_h,
		coalesce((SELECT to_char(ship_left,'MI') FROM points WHERE run_no = 4), '') AS punkt4_ubit_m,
		coalesce((SELECT ship_id::text FROM points WHERE run_no = 4), '') AS punkt4_ttn_id,
		coalesce((SELECT client_name::text FROM points WHERE run_no = 4), '') AS punkt4_gruzopol,

		coalesce((SELECT dest_name::text FROM points WHERE run_no = 5), '') AS punkt5,
		coalesce((SELECT to_char(ship_arrive,'DD/MM') FROM points WHERE run_no = 5), '') AS punkt5_prib_date,
		coalesce((SELECT to_char(ship_arrive,'HH24') FROM points WHERE run_no = 5), '') AS punkt5_prib_h,
		coalesce((SELECT to_char(ship_arrive,'MI') FROM points WHERE run_no = 5), '') AS punkt5_prib_m,
		coalesce((SELECT to_char(ship_left,'HH24') FROM points WHERE run_no = 5), '') AS punkt5_ubit_h,
		coalesce((SELECT to_char(ship_left,'MI') FROM points WHERE run_no = 5), '') AS punkt5_ubit_m,
		coalesce((SELECT ship_id::text FROM points WHERE run_no = 5), '') AS punkt5_ttn_id,
		coalesce((SELECT client_name::text FROM points WHERE run_no = 5), '') AS punkt5_gruzopol,

		coalesce((SELECT dest_name::text FROM points WHERE run_no = 6), '') AS punkt6,
		coalesce((SELECT to_char(ship_arrive,'DD/MM') FROM points WHERE run_no = 6), '') AS punkt6_prib_date,
		coalesce((SELECT to_char(ship_arrive,'HH24') FROM points WHERE run_no = 6), '') AS punkt6_prib_h,
		coalesce((SELECT to_char(ship_arrive,'MI') FROM points WHERE run_no = 6), '') AS punkt6_prib_m,
		coalesce((SELECT to_char(ship_left,'HH24') FROM points WHERE run_no = 6), '') AS punkt6_ubit_h,
		coalesce((SELECT to_char(ship_left,'MI') FROM points WHERE run_no = 6), '') AS punkt6_ubit_m,
		coalesce((SELECT ship_id::text FROM points WHERE run_no = 6), '') AS punkt6_ttn_id,
		coalesce((SELECT client_name::text FROM points WHERE run_no = 6), '') AS punkt6_gruzopol,

		coalesce((SELECT dest_name::text FROM points WHERE run_no = 7), '') AS punkt7,
		coalesce((SELECT to_char(ship_arrive,'DD/MM') FROM points WHERE run_no = 7), '') AS punkt7_prib_date,
		coalesce((SELECT to_char(ship_arrive,'HH24') FROM points WHERE run_no = 7), '') AS punkt7_prib_h,
		coalesce((SELECT to_char(ship_arrive,'MI') FROM points WHERE run_no = 7), '') AS punkt7_prib_m,
		coalesce((SELECT to_char(ship_left,'HH24') FROM points WHERE run_no = 7), '') AS punkt7_ubit_h,
		coalesce((SELECT to_char(ship_left,'MI') FROM points WHERE run_no = 7), '') AS punkt7_ubit_m,
		coalesce((SELECT ship_id::text FROM points WHERE run_no = 7), '') AS punkt7_ttn_id,
		coalesce((SELECT client_name::text FROM points WHERE run_no = 7), '') AS punkt7_gruzopol,

		coalesce((SELECT dest_name::text FROM points WHERE run_no = 8), '') AS punkt8,
		coalesce((SELECT to_char(ship_arrive,'DD/MM') FROM points WHERE run_no = 8), '') AS punkt8_prib_date,
		coalesce((SELECT to_char(ship_arrive,'HH24') FROM points WHERE run_no = 8), '') AS punkt8_prib_h,
		coalesce((SELECT to_char(ship_arrive,'MI') FROM points WHERE run_no = 8), '') AS punkt8_prib_m,
		coalesce((SELECT to_char(ship_left,'HH24') FROM points WHERE run_no = 8), '') AS punkt8_ubit_h,
		coalesce((SELECT to_char(ship_left,'MI') FROM points WHERE run_no = 8), '') AS punkt8_ubit_m,
		coalesce((SELECT ship_id::text FROM points WHERE run_no = 8), '') AS punkt8_ttn_id,
		coalesce((SELECT client_name::text FROM points WHERE run_no = 8), '') AS punkt8_gruzopol

	FROM schedule AS sch
	LEFT JOIN vehicles AS vh ON vh.id = sch.vehicle_id
	LEFT JOIN drivers AS dr ON dr.id = sch.driver_id
	LEFT JOIN drivers AS dr_vh ON dr_vh.id = vh.driver_id
	; 
$BODY$
LANGUAGE sql STABLE COST 100;
