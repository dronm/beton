-- View: public.vehicles_dialog

DROP VIEW public.vehicles_dialog;
 
CREATE OR REPLACE VIEW public.vehicles_dialog AS 
	SELECT
		v.id,
		v.plate,
		v.plate_region,
		v.load_capacity,
		v.make,
		v.owner,
		v.feature,
		v.tracker_id,
		--v.sim_id,
		gps_tr.sim_id AS sim_id,
		--v.sim_number,
		gps_tr.sim_number AS sim_number,
		
		NULL::text AS tracker_last_data_descr,
		CASE
			WHEN v.tracker_id IS NULL OR v.tracker_id::text = ''::text THEN NULL
			ELSE (
				SELECT tr.recieved_dt + (now() - timezone('utc'::text, now())::timestamp with time zone)
				FROM car_tracking tr
				WHERE tr.car_id::text = v.tracker_id::text
				ORDER BY tr.period DESC
				LIMIT 1
			)
		END AS tracker_last_dt,
		CASE
			WHEN v.tracker_id IS NULL OR v.tracker_id::text = ''::text THEN NULL
			ELSE (
				SELECT
					coalesce(tr.sat_num,0)
				FROM car_tracking tr
				WHERE tr.car_id::text = v.tracker_id::text
				ORDER BY tr.period DESC
				LIMIT 1
			)
		END AS tracker_sat_num,
		
		--tr_data.recieved_dt + (now() - timezone('utc'::text, now())::timestamp with time zone)  AS tracker_last_dt,
		--tr_data.sat_num  AS tracker_sat_num,
		
		drivers_ref(dr.*) AS drivers_ref,
		v.vehicle_owners,
		
		vehicle_owners_ref(v_own) AS vehicle_owners_ref,
		
		v.vehicle_owner_id,
		
		v.vehicle_owners_ar,
		
		v.ord_num,
		v.weight_t,

		v.vin,
		v.leasor,
		v.leasing_contract_date,
		v.leasing_contract_num,
		v.insurance_osago,
		v.insurance_kasko,
		
		vehicle_owners_ref(of_v_own) AS official_vehicle_owners_ref
		
	FROM vehicles v
	LEFT JOIN drivers dr ON dr.id = v.driver_id
	LEFT JOIN vehicle_owners v_own ON v_own.id = v.vehicle_owner_id
	LEFT JOIN vehicle_owners of_v_own ON of_v_own.id = v.official_vehicle_owner_id
	LEFT JOIN gps_trackers AS gps_tr ON gps_tr.id = v.tracker_id
	/*
	LEFT JOIN (
		SELECT
			tr.car_id,
			max(tr.period) AS period
		FROM car_tracking tr
		GROUP BY tr.car_id
	) AS tr_d ON tr_d.car_id = v.tracker_id
	LEFT JOIN car_tracking AS tr_data ON tr_data.car_id = tr_d.car_id AND tr_data.period = tr_d.period
	*/
	ORDER BY v.plate
	;


