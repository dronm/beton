-- ******************* update 17/04/2024 09:58:32 ******************
ALTER TABLE public.pump_vehicles ADD COLUMN driver_ship_inform bool;



-- ******************* update 17/04/2024 10:00:25 ******************
-- View: public.pump_vehicles_list

-- DROP VIEW public.pump_vehicles_list;

CREATE OR REPLACE VIEW public.pump_vehicles_list
 AS
 SELECT pv.id,
    pv.vehicle_id,
    pv.phone_cel,
    pv.pump_price_id,
    ppr.name AS pump_price_descr,
    v.plate,
    (((v.plate::text || ' '::text) || v.make::text) || ' '::text) || v.owner::text AS vehicle_descr,
    pv.driver_ship_inform
    
   FROM pump_vehicles pv
     LEFT JOIN vehicles v ON v.id = pv.vehicle_id
     LEFT JOIN pump_prices ppr ON ppr.id = pv.pump_price_id
  ORDER BY v.plate;

ALTER TABLE public.pump_vehicles_list
    OWNER TO concrete1;



-- ******************* update 17/04/2024 10:08:18 ******************
-- View: public.pump_vehicles_list

-- DROP VIEW public.pump_vehicles_list;

CREATE OR REPLACE VIEW public.pump_vehicles_list
 AS
 SELECT pv.id,
    pv.vehicle_id,
    pv.phone_cel,
    pv.pump_price_id,
    ppr.name AS pump_price_descr,
    v.plate,
    (((v.plate::text || ' '::text) || v.make::text) || ' '::text) || v.owner::text AS vehicle_descr,
    pv.driver_ship_inform
    
   FROM pump_vehicles pv
     LEFT JOIN vehicles v ON v.id = pv.vehicle_id
     LEFT JOIN pump_prices ppr ON ppr.id = pv.pump_price_id
  ORDER BY v.plate;

ALTER TABLE public.pump_vehicles_list
    OWNER TO concrete1;



-- ******************* update 17/04/2024 10:12:57 ******************
-- View: public.pump_veh_list

-- DROP VIEW public.pump_veh_list CASCADE;

CREATE OR REPLACE VIEW public.pump_veh_list AS 
	SELECT
		pv.id,
		pv.phone_cel,
		vehicles_ref(v) AS pump_vehicles_ref,
		pump_prices_ref(ppr) AS pump_prices_ref,
		
		v.make,
		v.owner,
		v.feature,
		v.plate,
		pv.deleted,
		pv.pump_length,
		--vehicle_owners_ref(v_own) AS vehicle_owners_ref,
		
		(SELECT
			owners.r->'fields'->'owner'
		FROM
		(
			SELECT jsonb_array_elements(v.vehicle_owners->'rows') AS r
		) AS owners
		ORDER BY owners.r->'fields'->'dt_from' DESC
		LIMIT 1
		) AS vehicle_owners_ref,
		
		pv.comment_text,
		
		--v.vehicle_owner_id,
		(SELECT
			CASE WHEN owners.r->'fields'->'owner'->'keys'->>'id'='null' THEN NULL
				ELSE (owners.r->'fields'->'owner'->'keys'->>'id')::int
			END	
		FROM
		(
			SELECT jsonb_array_elements(v.vehicle_owners->'rows') AS r
		) AS owners
		ORDER BY owners.r->'fields'->'dt_from' DESC
		LIMIT 1
		) AS vehicle_owner_id,
		
		
		pv.phone_cels,
		pv.pump_prices,
		
		v.vehicle_owners_ar,
		pump_vehicles_ref(
			pv,
			v,
			(SELECT vh_o FROM vehicle_owners AS vh_o
			WHERE vh_o.id = 
				(SELECT
					CASE WHEN owners.r->'fields'->'owner'->'keys'->>'id'='null' THEN NULL
						ELSE (owners.r->'fields'->'owner'->'keys'->>'id')::int
					END	
				FROM
				(
					SELECT jsonb_array_elements(v.vehicle_owners->'rows') AS r
				) AS owners
				ORDER BY owners.r->'fields'->'dt_from' DESC
				LIMIT 1
				)			
			)
		) AS self_ref,
		
		pv.specialist_inform,
		
		(SELECT
			json_agg(
				json_build_object(
					'name', ct.name,
					'tel', ct.tel,
					'tel_ext', ct.tel_ext,
					'email', ct.email,
					'post', p.name
				)
			)
		FROM entity_contacts AS en
		LEFT JOIN contacts AS ct ON ct.id = en.contact_id
		LEFT JOIN posts AS p ON p.id = ct.post_id
		WHERE en.entity_type = 'pump_vehicles' AND en.entity_id = pv.id
		) AS contact_list,	
		
		pv.driver_ship_inform
		
	FROM pump_vehicles pv
	LEFT JOIN vehicles v ON v.id = pv.vehicle_id
	LEFT JOIN pump_prices ppr ON ppr.id = pv.pump_price_id
	--LEFT JOIN vehicle_owners v_own ON v_own.id = v.vehicle_owner_id
	ORDER BY v.plate;

ALTER TABLE public.pump_veh_list
  OWNER TO concrete1;



-- ******************* update 17/04/2024 10:19:39 ******************
﻿-- Function: sms_pump_order_ship_ct(in_order_id int)

-- DROP FUNCTION sms_pump_order_ship_ct(in_order_id int);

CREATE OR REPLACE FUNCTION sms_pump_order_ship_ct(in_order_id int)
  RETURNS TABLE(
  	phone_cel text,
  	message text,
  	ext_contact_id int
  ) AS
$$
	SELECT
		tel,
		sms_templates_text(
			template_params
			,(SELECT t.pattern
			FROM sms_patterns t
			WHERE t.sms_type = 'order_for_pump_ship'::sms_types AND t.lang_id = (SELECT (const_def_lang_val()->'keys'->>'id')::int)
			)
		),
		contact_id
	FROM sms_pump_order_templates_params
	WHERE
		id = in_order_id
		-- add check for inform checkbox
		AND
		coalesce(
			(SELECT
				TRUE
			FROM pump_vehicles AS p
			WHERE p.id = (SELECT pump_vehicle_id FROM orders AS o WHERE o.id = in_order_id) AND p.driver_ship_inform
			)
		, FALSE)
		;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION sms_pump_order_ship_ct(in_order_id int) OWNER TO concrete1;


-- ******************* update 17/04/2024 10:22:32 ******************
﻿-- Function: sms_pump_order_ship_ct(in_order_id int)

-- DROP FUNCTION sms_pump_order_ship_ct(in_order_id int);

CREATE OR REPLACE FUNCTION sms_pump_order_ship_ct(in_order_id int)
  RETURNS TABLE(
  	phone_cel text,
  	message text,
  	ext_contact_id int
  ) AS
$$
	SELECT
		tel,
		sms_templates_text(
			template_params
			,(SELECT t.pattern
			FROM sms_patterns t
			WHERE t.sms_type = 'order_for_pump_ship'::sms_types AND t.lang_id = (SELECT (const_def_lang_val()->'keys'->>'id')::int)
			)
		),
		contact_id
	FROM sms_pump_order_templates_params
	WHERE
		id = in_order_id
		-- add check for inform checkbox
		/*AND
		coalesce(
			(SELECT
				TRUE
			FROM pump_vehicles AS p
			WHERE p.id = (SELECT pump_vehicle_id FROM orders AS o WHERE o.id = in_order_id) AND p.driver_ship_inform
			)
		, FALSE)*/
		;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION sms_pump_order_ship_ct(in_order_id int) OWNER TO concrete1;


-- ******************* update 17/04/2024 10:23:34 ******************
﻿-- Function: sms_pump_order_ship_ct(in_order_id int)

-- DROP FUNCTION sms_pump_order_ship_ct(in_order_id int);

CREATE OR REPLACE FUNCTION sms_pump_order_ship_ct(in_order_id int)
  RETURNS TABLE(
  	phone_cel text,
  	message text,
  	ext_contact_id int
  ) AS
$$
	SELECT
		tel,
		sms_templates_text(
			template_params
			,(SELECT t.pattern
			FROM sms_patterns t
			WHERE t.sms_type = 'order_for_pump_ship'::sms_types AND t.lang_id = (SELECT (const_def_lang_val()->'keys'->>'id')::int)
			)
		),
		contact_id
	FROM sms_pump_order_templates_params
	WHERE
		id = in_order_id
		-- add check for inform checkbox
		/*AND
		coalesce(
			(SELECT
				TRUE
			FROM pump_vehicles AS p
			WHERE p.id = (SELECT pump_vehicle_id FROM orders AS o WHERE o.id = in_order_id) AND p.driver_ship_inform
			)
		, FALSE)*/
		;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION sms_pump_order_ship_ct(in_order_id int) OWNER TO concrete1;


-- ******************* update 17/04/2024 10:24:21 ******************
﻿-- Function: sms_pump_order_ship_ct(in_order_id int)

-- DROP FUNCTION sms_pump_order_ship_ct(in_order_id int);

CREATE OR REPLACE FUNCTION sms_pump_order_ship_ct(in_order_id int)
  RETURNS TABLE(
  	phone_cel text,
  	message text,
  	ext_contact_id int
  ) AS
$$
	SELECT
		tel,
		sms_templates_text(
			template_params
			,(SELECT t.pattern
			FROM sms_patterns t
			WHERE t.sms_type = 'order_for_pump_ship'::sms_types AND t.lang_id = (SELECT (const_def_lang_val()->'keys'->>'id')::int)
			)
		),
		contact_id
	FROM sms_pump_order_templates_params
	WHERE
		id = in_order_id
		-- add check for inform checkbox
		AND
		coalesce(
			(SELECT
				TRUE
			FROM pump_vehicles AS p
			WHERE p.id = (SELECT pump_vehicle_id FROM orders AS o WHERE o.id = in_order_id) AND p.driver_ship_inform
			)
		, FALSE)
		;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION sms_pump_order_ship_ct(in_order_id int) OWNER TO concrete1;


-- ******************* update 17/04/2024 10:37:18 ******************
﻿-- Function: sms_pump_order_ship_ct(in_order_id int)

-- DROP FUNCTION sms_pump_order_ship_ct(in_order_id int);

CREATE OR REPLACE FUNCTION sms_pump_order_ship_ct(in_order_id int)
  RETURNS TABLE(
  	phone_cel text,
  	message text,
  	ext_contact_id int
  ) AS
$$
	SELECT
		tel,
		sms_templates_text(
			template_params
			,(SELECT t.pattern
			FROM sms_patterns t
			WHERE t.sms_type = 'order_for_pump_ship'::sms_types AND t.lang_id = (SELECT (const_def_lang_val()->'keys'->>'id')::int)
			)
		),
		contact_id
	FROM sms_pump_order_templates_params
	WHERE
		id = in_order_id
		-- add check for inform checkbox
		AND
		coalesce(
			(SELECT
				TRUE
			FROM pump_vehicles AS p
			WHERE p.id = (SELECT pump_vehicle_id FROM orders AS o WHERE o.id = in_order_id) AND p.driver_ship_inform
			)
		, FALSE)
		;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION sms_pump_order_ship_ct(in_order_id int) OWNER TO beton;


-- ******************* update 17/04/2024 10:37:27 ******************
-- View: public.pump_veh_list

-- DROP VIEW public.pump_veh_list CASCADE;

CREATE OR REPLACE VIEW public.pump_veh_list AS 
	SELECT
		pv.id,
		pv.phone_cel,
		vehicles_ref(v) AS pump_vehicles_ref,
		pump_prices_ref(ppr) AS pump_prices_ref,
		
		v.make,
		v.owner,
		v.feature,
		v.plate,
		pv.deleted,
		pv.pump_length,
		--vehicle_owners_ref(v_own) AS vehicle_owners_ref,
		
		(SELECT
			owners.r->'fields'->'owner'
		FROM
		(
			SELECT jsonb_array_elements(v.vehicle_owners->'rows') AS r
		) AS owners
		ORDER BY owners.r->'fields'->'dt_from' DESC
		LIMIT 1
		) AS vehicle_owners_ref,
		
		pv.comment_text,
		
		--v.vehicle_owner_id,
		(SELECT
			CASE WHEN owners.r->'fields'->'owner'->'keys'->>'id'='null' THEN NULL
				ELSE (owners.r->'fields'->'owner'->'keys'->>'id')::int
			END	
		FROM
		(
			SELECT jsonb_array_elements(v.vehicle_owners->'rows') AS r
		) AS owners
		ORDER BY owners.r->'fields'->'dt_from' DESC
		LIMIT 1
		) AS vehicle_owner_id,
		
		
		pv.phone_cels,
		pv.pump_prices,
		
		v.vehicle_owners_ar,
		pump_vehicles_ref(
			pv,
			v,
			(SELECT vh_o FROM vehicle_owners AS vh_o
			WHERE vh_o.id = 
				(SELECT
					CASE WHEN owners.r->'fields'->'owner'->'keys'->>'id'='null' THEN NULL
						ELSE (owners.r->'fields'->'owner'->'keys'->>'id')::int
					END	
				FROM
				(
					SELECT jsonb_array_elements(v.vehicle_owners->'rows') AS r
				) AS owners
				ORDER BY owners.r->'fields'->'dt_from' DESC
				LIMIT 1
				)			
			)
		) AS self_ref,
		
		pv.specialist_inform,
		
		(SELECT
			json_agg(
				json_build_object(
					'name', ct.name,
					'tel', ct.tel,
					'tel_ext', ct.tel_ext,
					'email', ct.email,
					'post', p.name
				)
			)
		FROM entity_contacts AS en
		LEFT JOIN contacts AS ct ON ct.id = en.contact_id
		LEFT JOIN posts AS p ON p.id = ct.post_id
		WHERE en.entity_type = 'pump_vehicles' AND en.entity_id = pv.id
		) AS contact_list,	
		
		pv.driver_ship_inform
		
	FROM pump_vehicles pv
	LEFT JOIN vehicles v ON v.id = pv.vehicle_id
	LEFT JOIN pump_prices ppr ON ppr.id = pv.pump_price_id
	--LEFT JOIN vehicle_owners v_own ON v_own.id = v.vehicle_owner_id
	ORDER BY v.plate;

ALTER TABLE public.pump_veh_list
  OWNER TO beton;



-- ******************* update 17/04/2024 10:37:34 ******************
-- View: public.pump_vehicles_list

-- DROP VIEW public.pump_vehicles_list;

CREATE OR REPLACE VIEW public.pump_vehicles_list
 AS
 SELECT pv.id,
    pv.vehicle_id,
    pv.phone_cel,
    pv.pump_price_id,
    ppr.name AS pump_price_descr,
    v.plate,
    (((v.plate::text || ' '::text) || v.make::text) || ' '::text) || v.owner::text AS vehicle_descr,
    pv.driver_ship_inform
    
   FROM pump_vehicles pv
     LEFT JOIN vehicles v ON v.id = pv.vehicle_id
     LEFT JOIN pump_prices ppr ON ppr.id = pv.pump_price_id
  ORDER BY v.plate;

ALTER TABLE public.pump_vehicles_list
    OWNER TO beton;



-- ******************* update 17/04/2024 11:12:32 ******************
UPDATE pump_vehicles set driver_ship_inform= true;


-- ******************* update 17/04/2024 13:13:33 ******************
-- View: public.car_tracking_malfunctions_list

-- DROP VIEW public.car_tracking_malfunctions_list;

CREATE OR REPLACE VIEW public.car_tracking_malfunctions_list AS
	SELECT
		vh.plate,
		vh.tracker_id
	FROM vehicle_schedules vs
	LEFT JOIN vehicles vh ON vh.id = vs.vehicle_id
	WHERE
		vs.schedule_date = now()::date		
		AND (SELECT
			vss.state
			FROM vehicle_schedule_states vss
		WHERE vss.schedule_id = vs.id
		ORDER BY vss.date_time DESC
		LIMIT 1) = 'busy'::vehicle_states
		
		AND coalesce(vh.tracker_id::text,'')<>''
		
		AND (now() - (
			(SELECT
				tr.period
			FROM car_tracking tr
			WHERE tr.car_id = vh.tracker_id
			ORDER BY tr.period DESC
			LIMIT 1) + (now() - timezone('utc'::text, now())::timestamp with time zone)
		)
		)>='1 hour'::interval
	;
	
ALTER TABLE public.car_tracking_malfunctions_list
    OWNER TO concrete1;



-- ******************* update 17/04/2024 13:13:37 ******************
-- View: public.car_tracking_malfunctions_list

-- DROP VIEW public.car_tracking_malfunctions_list;

CREATE OR REPLACE VIEW public.car_tracking_malfunctions_list
 AS
 SELECT vh.plate,
    vh.tracker_id
   FROM vehicle_schedules vs
     LEFT JOIN vehicles vh ON vh.id = vs.vehicle_id
  WHERE vs.schedule_date = now()::date AND (( SELECT vss.state
           FROM vehicle_schedule_states vss
          WHERE vss.schedule_id = vs.id
          ORDER BY vss.date_time DESC
         LIMIT 1)) = 'busy'::vehicle_states AND COALESCE(vh.tracker_id::text, ''::text) <> ''::text AND (now() - ((( SELECT tr.period
           FROM car_tracking tr
          WHERE tr.car_id::text = vh.tracker_id::text
          ORDER BY tr.period DESC
         LIMIT 1)) + (now() - timezone('utc'::text, now())::timestamp with time zone))::timestamp with time zone) >= '01:00:00'::interval;

ALTER TABLE public.car_tracking_malfunctions_list
    OWNER TO concrete1;




-- ******************* update 17/04/2024 13:13:41 ******************
-- View: public.broken_trackers_list_view

-- DROP VIEW public.broken_trackers_list_view;

CREATE OR REPLACE VIEW public.broken_trackers_list_view
 AS
 SELECT sub.plate,
    sub.tracker_id,
    sub.last_data
   FROM ( SELECT DISTINCT ON (v.id) v.plate,
            v.tracker_id,
            ( SELECT car_tracking.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
                   FROM car_tracking
                  WHERE car_tracking.car_id::text = v.tracker_id::text
                  ORDER BY car_tracking.period DESC
                 LIMIT 1) AS last_data
           FROM vehicle_schedule_states st
             LEFT JOIN vehicle_schedules vs ON vs.id = st.schedule_id
             LEFT JOIN vehicles v ON v.id = vs.vehicle_id
          WHERE st.date_time >= (now() - '1 day'::interval) AND st.date_time <= now() AND st.state = 'free'::vehicle_states AND v.tracker_id IS NOT NULL AND v.tracker_id::text <> ''::text
          ORDER BY v.id) sub
  WHERE (now() - sub.last_data::timestamp with time zone) > '1 day'::interval;

ALTER TABLE public.broken_trackers_list_view
    OWNER TO concrete1;



-- ******************* update 17/04/2024 13:13:55 ******************
-- View: public.vehicles_dialog

-- DROP VIEW public.vehicles_dialog;
 
CREATE OR REPLACE VIEW public.vehicles_dialog AS 
	SELECT
		v.id,
		v.plate,
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
		v.weight_t
		
	FROM vehicles v
	LEFT JOIN drivers dr ON dr.id = v.driver_id
	LEFT JOIN vehicle_owners v_own ON v_own.id = v.vehicle_owner_id
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

ALTER TABLE public.vehicles_dialog
  OWNER TO concrete1;



-- ******************* update 17/04/2024 13:14:01 ******************
-- View: public.vehicle_dialog_view

-- DROP VIEW public.vehicle_dialog_view;

CREATE OR REPLACE VIEW public.vehicle_dialog_view AS 
	SELECT
		v.id,
		v.plate,
		v.load_capacity,
		v.driver_id,
		dr.name AS driver_descr,		
		v.make,
		v.owner,
		v.feature,
		v.tracker_id,
		v.sim_id,
		v.sim_number,
		NULL AS tracker_last_data_descr,
		CASE
		WHEN v.tracker_id IS NULL OR v.tracker_id::text = ''::text THEN NULL
		ELSE (
			SELECT
				tr.recieved_dt + (now() - timezone('utc'::text, now())::timestamp with time zone)
			FROM car_tracking tr
			WHERE tr.car_id::text = v.tracker_id::text
			ORDER BY tr.period DESC
			LIMIT 1
		)
		END AS tracker_last_dt,
		
		drivers_ref(dr) AS drivers_ref
		
	FROM vehicles v
	LEFT JOIN drivers dr ON dr.id = v.driver_id;

ALTER TABLE public.vehicle_dialog_view
  OWNER TO concrete1;



-- ******************* update 17/04/2024 13:14:08 ******************
--DROP VIEW public.vehicle_states_all;
CREATE OR REPLACE VIEW public.vehicle_states_all AS 
	SELECT 
		st.date_time,
		vs.id,
		CASE
		    WHEN st.state <> 'out'::vehicle_states AND st.state <> 'out_from_shift'::vehicle_states AND st.state <> 'shift'::vehicle_states AND st.state <> 'shift_added'::vehicle_states 

			THEN 1
			ELSE 0
		END AS vehicles_count,
		
		vehicles_ref(v) AS vehicles_ref,
		
		/*
		CASE
			WHEN v.vehicle_owner_id IS NULL THEN v.owner
			ELSE v_own.name
		END
		*/
		v_own.name::text AS owner,
		
		drivers_ref(d) AS drivers_ref,
		--d.phone_cel::text AS driver_phone_cel,
		ct.tel::text AS driver_phone_cel,
		
		st.state, 

		CASE 
			--WHEN st.state = 'busy'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+constant_vehicle_unload_time())::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				--THEN true
			WHEN st.state = 'busy'::vehicle_states AND (st.date_time + coalesce(dest.time_route::interval,'00:00'::interval))::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			
			WHEN st.state = 'left_for_base'::vehicle_states AND (st.date_time +  coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			ELSE false
		END AS is_late,

		CASE
			WHEN st.state = 'at_dest'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*1 + constant_vehicle_unload_time())::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			ELSE false
		END AS is_late_at_dest,
		
		CASE
			--shift - no inf
			WHEN st.state = 'shift'::vehicle_states OR st.state = 'shift_added'::vehicle_states
				THEN ''

			-- out_from_shift && out inf=out time
			WHEN st.state = 'out_from_shift'::vehicle_states OR st.state = 'out'::vehicle_states
				THEN time5_descr(st.date_time::time)::text

			--free && assigned inf= time elapsed
			WHEN st.state = 'free'::vehicle_states OR st.state = 'assigned'::vehicle_states
				THEN to_char(CURRENT_TIMESTAMP-st.date_time,'HH24:MI')

			--busy && late inf = -
			--WHEN st.state = 'busy'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+constant_vehicle_unload_time())::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				--THEN '-'::text || time5_descr((CURRENT_TIMESTAMP - (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+constant_vehicle_unload_time())::interval)::timestamp with time zone)::time without time zone)::text
			WHEN st.state = 'busy'::vehicle_states AND (st.date_time + coalesce(dest.time_route,'00:00'::time)+constant_vehicle_unload_time()::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN time5_descr((coalesce(dest.time_route,'00:00'::time)+constant_vehicle_unload_time()::interval )::time without time zone)::text
				
			-- busy not late
			WHEN st.state = 'busy'::vehicle_states
				--THEN time5_descr(((st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+constant_vehicle_unload_time())::interval)::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text
				THEN time5_descr((coalesce(dest.time_route,'00:00'::time)+constant_vehicle_unload_time()::interval )::time without time zone)::text

			--at dest && late inf=route_time
			WHEN st.state = 'at_dest'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*1+constant_vehicle_unload_time())::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN time5_descr(coalesce(dest.time_route,'00:00'::time))::text

			--at dest NOT late
			WHEN st.state = 'at_dest'::vehicle_states
				THEN time5_descr( ((st.date_time + (coalesce(dest.time_route::interval,'00:00'::interval)+constant_vehicle_unload_time()::interval))::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text

			--left_for_base && LATE
			WHEN st.state = 'left_for_base'::vehicle_states AND (st.date_time + coalesce(dest.time_route,'00:00'::time)::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN '-'::text || time5_descr((CURRENT_TIMESTAMP - (st.date_time + coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone)::time without time zone)::text

			--left_for_base NOT late
			WHEN st.state = 'left_for_base'::vehicle_states
				THEN time5_descr( ((st.date_time + coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text
		    
			ELSE ''
		    
		END AS inf_on_return, 
		
		v.load_capacity,
		(SELECT COUNT(*)
		FROM shipments
		WHERE (shipments.vehicle_schedule_id = vs.id AND shipments.shipped)
		) AS runs,

		coalesce(
			(SELECT 
				(now()-(tr.period+AGE(now(),now() AT TIME ZONE 'UTC')) )>constant_no_tracker_signal_warn_interval()
				FROM car_tracking AS tr
				WHERE tr.car_id=v.tracker_id
				ORDER BY tr.period DESC LIMIT 1
			)
		,TRUE) AS tracker_no_data,
		
		(v.tracker_id IS NULL OR v.tracker_id='') AS no_tracker,
		
		vs.schedule_date,
		
		vehicle_schedules_ref(vs,v,d) AS vehicle_schedules_ref,
		
		--d.phone_cel AS driver_tel
		ct.tel::varchar(15) AS driver_tel
		,v.tracker_id
		,production_bases_ref(production_bases_ref_t) AS production_bases_ref,
		production_bases_ref_t.name AS production_base_name, -- for sorting
		dest.name AS destination_name
		
	FROM vehicle_schedules vs
	
	LEFT JOIN drivers d ON d.id = vs.driver_id
	LEFT JOIN vehicles v ON v.id = vs.vehicle_id
	LEFT JOIN vehicle_schedule_states st ON
		st.id = (SELECT vehicle_schedule_states.id 
			FROM vehicle_schedule_states
			WHERE vehicle_schedule_states.schedule_id = vs.id
			ORDER BY vehicle_schedule_states.date_time DESC NULLS LAST
			LIMIT 1
		)
	--LEFT JOIN production_bases AS production_bases_ref_t ON production_bases_ref_t.id = vs.production_base_id
	LEFT JOIN production_bases AS production_bases_ref_t ON production_bases_ref_t.id = st.production_base_id
	
	LEFT JOIN shipments AS sh ON sh.id=st.shipment_id
	LEFT JOIN orders AS o ON o.id=sh.order_id		
	LEFT JOIN destinations AS dest ON dest.id=o.destination_id
	LEFT JOIN vehicle_owners AS v_own ON v_own.id=v.vehicle_owner_id
	LEFT JOIN entity_contacts AS e_ct ON e_ct.entity_type = 'drivers' AND e_ct.entity_id = d.id
	LEFT JOIN contacts AS ct ON ct.id = e_ct.contact_id
	;		
	--WHERE vs.schedule_date=in_date


ALTER TABLE public.vehicle_states_all OWNER TO concrete1;



-- ******************* update 17/04/2024 13:14:14 ******************
-- View: public.vehicle_current_pos_all

-- DROP VIEW public.vehicle_current_pos_all;

CREATE OR REPLACE VIEW public.vehicle_current_pos_all
 AS
 SELECT v.id,
    v.plate,
    v.feature,
    v.owner,
    v.make,
    ( SELECT car_tracking.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS period,
    ( SELECT date5_time5_descr(car_tracking.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone)) AS date5_time5_descr
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS period_str,
    ( SELECT car_tracking.longitude
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS lon_str,
    ( SELECT car_tracking.latitude
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS lat_str,
    ( SELECT round(car_tracking.speed, 0) AS round
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS speed,
    ( SELECT car_tracking.ns
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS ns,
    ( SELECT car_tracking.ew
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS ew,
    ( SELECT car_tracking.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS recieved_dt,
    ( SELECT date5_time5_descr(car_tracking.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)) AS date5_time5_descr
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS recieved_dt_str,
    ( SELECT car_tracking.odometer
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS odometer,
    ( SELECT engine_descr(car_tracking.engine_on) AS engine_descr
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS engine_on_str,
    ( SELECT car_tracking.voltage
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS voltage,
    ( SELECT heading_descr(car_tracking.heading) AS heading_descr
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS heading_str,
    ( SELECT car_tracking.heading
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS heading,
    ( SELECT car_tracking.lon
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS lon,
    ( SELECT car_tracking.lat
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS lat
     ,v.tracker_id::text AS tracker_id
   FROM vehicles v
  WHERE v.tracker_id IS NOT NULL AND v.tracker_id::text <> ''::text
  ORDER BY v.plate;

ALTER TABLE public.vehicle_current_pos_all OWNER TO concrete1;



-- ******************* update 17/04/2024 13:14:20 ******************
-- View: public.vehicles_last_pos

-- DROP VIEW public.vehicles_last_pos;

CREATE OR REPLACE VIEW public.vehicles_last_pos
AS
SELECT
	v.id
	,v.plate
	,v.feature
	,v.owner
	,v.make
	,v.tracker_id::text AS tracker_id
	,(SELECT
		json_build_object(
			'period',car_tracking.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
			,'speed',round(car_tracking.speed, 0)
			,'ns',car_tracking.ns
			,'ew',car_tracking.ew
			,'recieved_dt',car_tracking.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
			,'odometer',car_tracking.odometer
			,'voltage',round(car_tracking.voltage,0)
			,'heading',car_tracking.heading
			,'lon',car_tracking.lon
			,'lat',car_tracking.lat			
			/*
			,'heading_descr',heading_descr(car_tracking.heading)
			,'pt_geom',ST_BUFFER(
				ST_GeomFromText('POINT('||car_tracking.lon::text||' '||car_tracking.lat::text||')', 4326)
				,(SELECT (const_deviation_for_reroute_val()->>'distance_m')::int)
			)
			*/
		)
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1
	) AS pos_data
	
	/*
	( SELECT car_tracking.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS period,
	( SELECT round(car_tracking.speed, 0) AS round
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS speed,
	( SELECT car_tracking.ns
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS ns,
	( SELECT car_tracking.ew
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS ew,
	( SELECT car_tracking.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS recieved_dt,
	( SELECT car_tracking.odometer
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS odometer,
	( SELECT car_tracking.voltage
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS voltage,
	( SELECT heading_descr(car_tracking.heading) AS heading_descr
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS heading_str,
	( SELECT car_tracking.heading
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS heading,
	( SELECT car_tracking.lon
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS lon,
	( SELECT car_tracking.lat
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS lat
	*/	
FROM vehicles v
WHERE v.tracker_id IS NOT NULL AND v.tracker_id::text <> ''::text
ORDER BY v.plate_n;

ALTER TABLE public.vehicles_last_pos OWNER TO concrete1;



-- ******************* update 17/04/2024 16:39:55 ******************
--DROP VIEW public.vehicle_states_all;
CREATE OR REPLACE VIEW public.vehicle_states_all AS 
	SELECT 
		st.date_time,
		vs.id,
		CASE
		    WHEN st.state <> 'out'::vehicle_states AND st.state <> 'out_from_shift'::vehicle_states AND st.state <> 'shift'::vehicle_states AND st.state <> 'shift_added'::vehicle_states 

			THEN 1
			ELSE 0
		END AS vehicles_count,
		
		vehicles_ref(v) AS vehicles_ref,
		
		/*
		CASE
			WHEN v.vehicle_owner_id IS NULL THEN v.owner
			ELSE v_own.name
		END
		*/
		v_own.name::text AS owner,
		
		drivers_ref(d) AS drivers_ref,
		--d.phone_cel::text AS driver_phone_cel,
		ct.tel::text AS driver_phone_cel,
		
		st.state, 

		CASE 
			--WHEN st.state = 'busy'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+constant_vehicle_unload_time())::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				--THEN true
			WHEN st.state = 'busy'::vehicle_states AND (st.date_time + coalesce(dest.time_route::interval,'00:00'::interval))::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			
			WHEN st.state = 'left_for_base'::vehicle_states AND (st.date_time +  coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			ELSE false
		END AS is_late,

		CASE
			WHEN st.state = 'at_dest'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*1 + constant_vehicle_unload_time())::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			ELSE false
		END AS is_late_at_dest,
		
		CASE
			--shift - no inf
			WHEN st.state = 'shift'::vehicle_states OR st.state = 'shift_added'::vehicle_states
				THEN ''

			-- out_from_shift && out inf=out time
			WHEN st.state = 'out_from_shift'::vehicle_states OR st.state = 'out'::vehicle_states
				THEN time5_descr(st.date_time::time)::text

			--free && assigned inf= time elapsed
			WHEN st.state = 'free'::vehicle_states OR st.state = 'assigned'::vehicle_states
				THEN to_char(CURRENT_TIMESTAMP-st.date_time,'HH24:MI')

			--busy && late inf = -
			--WHEN st.state = 'busy'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+constant_vehicle_unload_time())::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				--THEN '-'::text || time5_descr((CURRENT_TIMESTAMP - (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+constant_vehicle_unload_time())::interval)::timestamp with time zone)::time without time zone)::text
			WHEN st.state = 'busy'::vehicle_states AND (st.date_time + coalesce(dest.time_route,'00:00'::time)+constant_vehicle_unload_time()::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN time5_descr((coalesce(dest.time_route,'00:00'::time)+constant_vehicle_unload_time()::interval )::time without time zone)::text
				
			-- busy not late
			WHEN st.state = 'busy'::vehicle_states
				--THEN time5_descr(((st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+constant_vehicle_unload_time())::interval)::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text
				THEN time5_descr((coalesce(dest.time_route,'00:00'::time)+constant_vehicle_unload_time()::interval )::time without time zone)::text

			--at dest && late inf=route_time
			WHEN st.state = 'at_dest'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*1+constant_vehicle_unload_time())::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN time5_descr(coalesce(dest.time_route,'00:00'::time))::text

			--at dest NOT late
			WHEN st.state = 'at_dest'::vehicle_states
				THEN time5_descr( ((st.date_time + (coalesce(dest.time_route::interval,'00:00'::interval)+constant_vehicle_unload_time()::interval))::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text

			--left_for_base && LATE
			WHEN st.state = 'left_for_base'::vehicle_states AND (st.date_time + coalesce(dest.time_route,'00:00'::time)::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN '-'::text || time5_descr((CURRENT_TIMESTAMP - (st.date_time + coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone)::time without time zone)::text

			--left_for_base NOT late
			WHEN st.state = 'left_for_base'::vehicle_states
				THEN time5_descr( ((st.date_time + coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text
		    
			ELSE ''
		    
		END AS inf_on_return, 
		
		v.load_capacity,
		(SELECT COUNT(*)
		FROM shipments
		WHERE (shipments.vehicle_schedule_id = vs.id AND shipments.shipped)
		) AS runs,

		coalesce(
			(SELECT 
				(now()-(tr.period+AGE(now(),now() AT TIME ZONE 'UTC')) ) > (const_no_tracker_signal_warn_interval_val())::interval
				FROM car_tracking AS tr
				WHERE tr.car_id=v.tracker_id
				ORDER BY tr.period DESC LIMIT 1
			)
		,TRUE) AS tracker_no_data,
		
		(v.tracker_id IS NULL OR v.tracker_id='') AS no_tracker,
		
		vs.schedule_date,
		
		vehicle_schedules_ref(vs,v,d) AS vehicle_schedules_ref,
		
		--d.phone_cel AS driver_tel
		ct.tel::varchar(15) AS driver_tel
		,v.tracker_id
		,production_bases_ref(production_bases_ref_t) AS production_bases_ref,
		production_bases_ref_t.name AS production_base_name, -- for sorting
		dest.name AS destination_name
		
	FROM vehicle_schedules vs
	
	LEFT JOIN drivers d ON d.id = vs.driver_id
	LEFT JOIN vehicles v ON v.id = vs.vehicle_id
	LEFT JOIN vehicle_schedule_states st ON
		st.id = (SELECT vehicle_schedule_states.id 
			FROM vehicle_schedule_states
			WHERE vehicle_schedule_states.schedule_id = vs.id
			ORDER BY vehicle_schedule_states.date_time DESC NULLS LAST
			LIMIT 1
		)
	--LEFT JOIN production_bases AS production_bases_ref_t ON production_bases_ref_t.id = vs.production_base_id
	LEFT JOIN production_bases AS production_bases_ref_t ON production_bases_ref_t.id = st.production_base_id
	
	LEFT JOIN shipments AS sh ON sh.id=st.shipment_id
	LEFT JOIN orders AS o ON o.id=sh.order_id		
	LEFT JOIN destinations AS dest ON dest.id=o.destination_id
	LEFT JOIN vehicle_owners AS v_own ON v_own.id=v.vehicle_owner_id
	LEFT JOIN entity_contacts AS e_ct ON e_ct.entity_type = 'drivers' AND e_ct.entity_id = d.id
	LEFT JOIN contacts AS ct ON ct.id = e_ct.contact_id
	;		
	--WHERE vs.schedule_date=in_date


ALTER TABLE public.vehicle_states_all OWNER TO concrete1;



-- ******************* update 17/04/2024 16:42:29 ******************
--DROP VIEW public.vehicle_states_all;
CREATE OR REPLACE VIEW public.vehicle_states_all AS 
	SELECT 
		st.date_time,
		vs.id,
		CASE
		    WHEN st.state <> 'out'::vehicle_states AND st.state <> 'out_from_shift'::vehicle_states AND st.state <> 'shift'::vehicle_states AND st.state <> 'shift_added'::vehicle_states 

			THEN 1
			ELSE 0
		END AS vehicles_count,
		
		vehicles_ref(v) AS vehicles_ref,
		
		/*
		CASE
			WHEN v.vehicle_owner_id IS NULL THEN v.owner
			ELSE v_own.name
		END
		*/
		v_own.name::text AS owner,
		
		drivers_ref(d) AS drivers_ref,
		--d.phone_cel::text AS driver_phone_cel,
		ct.tel::text AS driver_phone_cel,
		
		st.state, 

		CASE 
			--WHEN st.state = 'busy'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+const_vehicle_unload_time_val())::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				--THEN true
			WHEN st.state = 'busy'::vehicle_states AND (st.date_time + coalesce(dest.time_route::interval,'00:00'::interval))::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			
			WHEN st.state = 'left_for_base'::vehicle_states AND (st.date_time +  coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			ELSE false
		END AS is_late,

		CASE
			WHEN st.state = 'at_dest'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*1 + const_vehicle_unload_time_val())::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			ELSE false
		END AS is_late_at_dest,
		
		CASE
			--shift - no inf
			WHEN st.state = 'shift'::vehicle_states OR st.state = 'shift_added'::vehicle_states
				THEN ''

			-- out_from_shift && out inf=out time
			WHEN st.state = 'out_from_shift'::vehicle_states OR st.state = 'out'::vehicle_states
				THEN time5_descr(st.date_time::time)::text

			--free && assigned inf= time elapsed
			WHEN st.state = 'free'::vehicle_states OR st.state = 'assigned'::vehicle_states
				THEN to_char(CURRENT_TIMESTAMP-st.date_time,'HH24:MI')

			--busy && late inf = -
			--WHEN st.state = 'busy'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+const_vehicle_unload_time_val())::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				--THEN '-'::text || time5_descr((CURRENT_TIMESTAMP - (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+const_vehicle_unload_time_val())::interval)::timestamp with time zone)::time without time zone)::text
			WHEN st.state = 'busy'::vehicle_states AND (st.date_time + coalesce(dest.time_route,'00:00'::time)+const_vehicle_unload_time_val()::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN time5_descr((coalesce(dest.time_route,'00:00'::time)+const_vehicle_unload_time_val()::interval )::time without time zone)::text
				
			-- busy not late
			WHEN st.state = 'busy'::vehicle_states
				--THEN time5_descr(((st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+const_vehicle_unload_time_val())::interval)::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text
				THEN time5_descr((coalesce(dest.time_route,'00:00'::time)+const_vehicle_unload_time_val()::interval )::time without time zone)::text

			--at dest && late inf=route_time
			WHEN st.state = 'at_dest'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*1+const_vehicle_unload_time_val())::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN time5_descr(coalesce(dest.time_route,'00:00'::time))::text

			--at dest NOT late
			WHEN st.state = 'at_dest'::vehicle_states
				THEN time5_descr( ((st.date_time + (coalesce(dest.time_route::interval,'00:00'::interval)+const_vehicle_unload_time_val()::interval))::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text

			--left_for_base && LATE
			WHEN st.state = 'left_for_base'::vehicle_states AND (st.date_time + coalesce(dest.time_route,'00:00'::time)::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN '-'::text || time5_descr((CURRENT_TIMESTAMP - (st.date_time + coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone)::time without time zone)::text

			--left_for_base NOT late
			WHEN st.state = 'left_for_base'::vehicle_states
				THEN time5_descr( ((st.date_time + coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text
		    
			ELSE ''
		    
		END AS inf_on_return, 
		
		v.load_capacity,
		(SELECT COUNT(*)
		FROM shipments
		WHERE (shipments.vehicle_schedule_id = vs.id AND shipments.shipped)
		) AS runs,

		coalesce(
			(SELECT 
				(now()-(tr.period+AGE(now(),now() AT TIME ZONE 'UTC')) ) > (const_no_tracker_signal_warn_interval_val())::interval
				FROM car_tracking AS tr
				WHERE tr.car_id=v.tracker_id
				ORDER BY tr.period DESC LIMIT 1
			)
		,TRUE) AS tracker_no_data,
		
		(v.tracker_id IS NULL OR v.tracker_id='') AS no_tracker,
		
		vs.schedule_date,
		
		vehicle_schedules_ref(vs,v,d) AS vehicle_schedules_ref,
		
		--d.phone_cel AS driver_tel
		ct.tel::varchar(15) AS driver_tel
		,v.tracker_id
		,production_bases_ref(production_bases_ref_t) AS production_bases_ref,
		production_bases_ref_t.name AS production_base_name, -- for sorting
		dest.name AS destination_name
		
	FROM vehicle_schedules vs
	
	LEFT JOIN drivers d ON d.id = vs.driver_id
	LEFT JOIN vehicles v ON v.id = vs.vehicle_id
	LEFT JOIN vehicle_schedule_states st ON
		st.id = (SELECT vehicle_schedule_states.id 
			FROM vehicle_schedule_states
			WHERE vehicle_schedule_states.schedule_id = vs.id
			ORDER BY vehicle_schedule_states.date_time DESC NULLS LAST
			LIMIT 1
		)
	--LEFT JOIN production_bases AS production_bases_ref_t ON production_bases_ref_t.id = vs.production_base_id
	LEFT JOIN production_bases AS production_bases_ref_t ON production_bases_ref_t.id = st.production_base_id
	
	LEFT JOIN shipments AS sh ON sh.id=st.shipment_id
	LEFT JOIN orders AS o ON o.id=sh.order_id		
	LEFT JOIN destinations AS dest ON dest.id=o.destination_id
	LEFT JOIN vehicle_owners AS v_own ON v_own.id=v.vehicle_owner_id
	LEFT JOIN entity_contacts AS e_ct ON e_ct.entity_type = 'drivers' AND e_ct.entity_id = d.id
	LEFT JOIN contacts AS ct ON ct.id = e_ct.contact_id
	;		
	--WHERE vs.schedule_date=in_date


ALTER TABLE public.vehicle_states_all OWNER TO concrete1;



-- ******************* update 17/04/2024 16:47:54 ******************
-- View: public.car_tracking_malfunctions_list

-- DROP VIEW public.car_tracking_malfunctions_list;

CREATE OR REPLACE VIEW public.car_tracking_malfunctions_list
 AS
 SELECT vh.plate,
    vh.tracker_id
   FROM vehicle_schedules vs
     LEFT JOIN vehicles vh ON vh.id = vs.vehicle_id
  WHERE vs.schedule_date = now()::date AND (( SELECT vss.state
           FROM vehicle_schedule_states vss
          WHERE vss.schedule_id = vs.id
          ORDER BY vss.date_time DESC
         LIMIT 1)) = 'busy'::vehicle_states AND COALESCE(vh.tracker_id::text, ''::text) <> ''::text AND (now() - ((( SELECT tr.period
           FROM car_tracking tr
          WHERE tr.car_id::text = vh.tracker_id::text
          ORDER BY tr.period DESC
         LIMIT 1)) + (now() - timezone('utc'::text, now())::timestamp with time zone))::timestamp with time zone) >= '01:00:00'::interval;

ALTER TABLE public.car_tracking_malfunctions_list
    OWNER TO concrete1;




-- ******************* update 17/04/2024 16:47:56 ******************
-- View: public.broken_trackers_list_view

-- DROP VIEW public.broken_trackers_list_view;

CREATE OR REPLACE VIEW public.broken_trackers_list_view
 AS
 SELECT sub.plate,
    sub.tracker_id,
    sub.last_data
   FROM ( SELECT DISTINCT ON (v.id) v.plate,
            v.tracker_id,
            ( SELECT car_tracking.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
                   FROM car_tracking
                  WHERE car_tracking.car_id::text = v.tracker_id::text
                  ORDER BY car_tracking.period DESC
                 LIMIT 1) AS last_data
           FROM vehicle_schedule_states st
             LEFT JOIN vehicle_schedules vs ON vs.id = st.schedule_id
             LEFT JOIN vehicles v ON v.id = vs.vehicle_id
          WHERE st.date_time >= (now() - '1 day'::interval) AND st.date_time <= now() AND st.state = 'free'::vehicle_states AND v.tracker_id IS NOT NULL AND v.tracker_id::text <> ''::text
          ORDER BY v.id) sub
  WHERE (now() - sub.last_data::timestamp with time zone) > '1 day'::interval;

ALTER TABLE public.broken_trackers_list_view
    OWNER TO concrete1;



-- ******************* update 17/04/2024 16:47:59 ******************
-- View: public.vehicles_dialog

-- DROP VIEW public.vehicles_dialog;
 
CREATE OR REPLACE VIEW public.vehicles_dialog AS 
	SELECT
		v.id,
		v.plate,
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
		v.weight_t
		
	FROM vehicles v
	LEFT JOIN drivers dr ON dr.id = v.driver_id
	LEFT JOIN vehicle_owners v_own ON v_own.id = v.vehicle_owner_id
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

ALTER TABLE public.vehicles_dialog
  OWNER TO concrete1;



-- ******************* update 17/04/2024 16:48:01 ******************
-- View: public.vehicle_dialog_view

-- DROP VIEW public.vehicle_dialog_view;

CREATE OR REPLACE VIEW public.vehicle_dialog_view AS 
	SELECT
		v.id,
		v.plate,
		v.load_capacity,
		v.driver_id,
		dr.name AS driver_descr,		
		v.make,
		v.owner,
		v.feature,
		v.tracker_id,
		v.sim_id,
		v.sim_number,
		NULL AS tracker_last_data_descr,
		CASE
		WHEN v.tracker_id IS NULL OR v.tracker_id::text = ''::text THEN NULL
		ELSE (
			SELECT
				tr.recieved_dt + (now() - timezone('utc'::text, now())::timestamp with time zone)
			FROM car_tracking tr
			WHERE tr.car_id::text = v.tracker_id::text
			ORDER BY tr.period DESC
			LIMIT 1
		)
		END AS tracker_last_dt,
		
		drivers_ref(dr) AS drivers_ref
		
	FROM vehicles v
	LEFT JOIN drivers dr ON dr.id = v.driver_id;

ALTER TABLE public.vehicle_dialog_view
  OWNER TO concrete1;



-- ******************* update 17/04/2024 16:48:04 ******************
--DROP VIEW public.vehicle_states_all;
CREATE OR REPLACE VIEW public.vehicle_states_all AS 
	SELECT 
		st.date_time,
		vs.id,
		CASE
		    WHEN st.state <> 'out'::vehicle_states AND st.state <> 'out_from_shift'::vehicle_states AND st.state <> 'shift'::vehicle_states AND st.state <> 'shift_added'::vehicle_states 

			THEN 1
			ELSE 0
		END AS vehicles_count,
		
		vehicles_ref(v) AS vehicles_ref,
		
		/*
		CASE
			WHEN v.vehicle_owner_id IS NULL THEN v.owner
			ELSE v_own.name
		END
		*/
		v_own.name::text AS owner,
		
		drivers_ref(d) AS drivers_ref,
		--d.phone_cel::text AS driver_phone_cel,
		ct.tel::text AS driver_phone_cel,
		
		st.state, 

		CASE 
			--WHEN st.state = 'busy'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+const_vehicle_unload_time_val())::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				--THEN true
			WHEN st.state = 'busy'::vehicle_states AND (st.date_time + coalesce(dest.time_route::interval,'00:00'::interval))::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			
			WHEN st.state = 'left_for_base'::vehicle_states AND (st.date_time +  coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			ELSE false
		END AS is_late,

		CASE
			WHEN st.state = 'at_dest'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*1 + const_vehicle_unload_time_val())::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			ELSE false
		END AS is_late_at_dest,
		
		CASE
			--shift - no inf
			WHEN st.state = 'shift'::vehicle_states OR st.state = 'shift_added'::vehicle_states
				THEN ''

			-- out_from_shift && out inf=out time
			WHEN st.state = 'out_from_shift'::vehicle_states OR st.state = 'out'::vehicle_states
				THEN time5_descr(st.date_time::time)::text

			--free && assigned inf= time elapsed
			WHEN st.state = 'free'::vehicle_states OR st.state = 'assigned'::vehicle_states
				THEN to_char(CURRENT_TIMESTAMP-st.date_time,'HH24:MI')

			--busy && late inf = -
			--WHEN st.state = 'busy'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+const_vehicle_unload_time_val())::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				--THEN '-'::text || time5_descr((CURRENT_TIMESTAMP - (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+const_vehicle_unload_time_val())::interval)::timestamp with time zone)::time without time zone)::text
			WHEN st.state = 'busy'::vehicle_states AND (st.date_time + coalesce(dest.time_route,'00:00'::time)+const_vehicle_unload_time_val()::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN time5_descr((coalesce(dest.time_route,'00:00'::time)+const_vehicle_unload_time_val()::interval )::time without time zone)::text
				
			-- busy not late
			WHEN st.state = 'busy'::vehicle_states
				--THEN time5_descr(((st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+const_vehicle_unload_time_val())::interval)::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text
				THEN time5_descr((coalesce(dest.time_route,'00:00'::time)+const_vehicle_unload_time_val()::interval )::time without time zone)::text

			--at dest && late inf=route_time
			WHEN st.state = 'at_dest'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*1+const_vehicle_unload_time_val())::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN time5_descr(coalesce(dest.time_route,'00:00'::time))::text

			--at dest NOT late
			WHEN st.state = 'at_dest'::vehicle_states
				THEN time5_descr( ((st.date_time + (coalesce(dest.time_route::interval,'00:00'::interval)+const_vehicle_unload_time_val()::interval))::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text

			--left_for_base && LATE
			WHEN st.state = 'left_for_base'::vehicle_states AND (st.date_time + coalesce(dest.time_route,'00:00'::time)::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN '-'::text || time5_descr((CURRENT_TIMESTAMP - (st.date_time + coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone)::time without time zone)::text

			--left_for_base NOT late
			WHEN st.state = 'left_for_base'::vehicle_states
				THEN time5_descr( ((st.date_time + coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text
		    
			ELSE ''
		    
		END AS inf_on_return, 
		
		v.load_capacity,
		(SELECT COUNT(*)
		FROM shipments
		WHERE (shipments.vehicle_schedule_id = vs.id AND shipments.shipped)
		) AS runs,

		coalesce(
			(SELECT 
				(now()-(tr.period+AGE(now(),now() AT TIME ZONE 'UTC')) ) > (const_no_tracker_signal_warn_interval_val())::interval
				FROM car_tracking AS tr
				WHERE tr.car_id=v.tracker_id
				ORDER BY tr.period DESC LIMIT 1
			)
		,TRUE) AS tracker_no_data,
		
		(v.tracker_id IS NULL OR v.tracker_id='') AS no_tracker,
		
		vs.schedule_date,
		
		vehicle_schedules_ref(vs,v,d) AS vehicle_schedules_ref,
		
		--d.phone_cel AS driver_tel
		ct.tel::varchar(15) AS driver_tel
		,v.tracker_id
		,production_bases_ref(production_bases_ref_t) AS production_bases_ref,
		production_bases_ref_t.name AS production_base_name, -- for sorting
		dest.name AS destination_name
		
	FROM vehicle_schedules vs
	
	LEFT JOIN drivers d ON d.id = vs.driver_id
	LEFT JOIN vehicles v ON v.id = vs.vehicle_id
	LEFT JOIN vehicle_schedule_states st ON
		st.id = (SELECT vehicle_schedule_states.id 
			FROM vehicle_schedule_states
			WHERE vehicle_schedule_states.schedule_id = vs.id
			ORDER BY vehicle_schedule_states.date_time DESC NULLS LAST
			LIMIT 1
		)
	--LEFT JOIN production_bases AS production_bases_ref_t ON production_bases_ref_t.id = vs.production_base_id
	LEFT JOIN production_bases AS production_bases_ref_t ON production_bases_ref_t.id = st.production_base_id
	
	LEFT JOIN shipments AS sh ON sh.id=st.shipment_id
	LEFT JOIN orders AS o ON o.id=sh.order_id		
	LEFT JOIN destinations AS dest ON dest.id=o.destination_id
	LEFT JOIN vehicle_owners AS v_own ON v_own.id=v.vehicle_owner_id
	LEFT JOIN entity_contacts AS e_ct ON e_ct.entity_type = 'drivers' AND e_ct.entity_id = d.id
	LEFT JOIN contacts AS ct ON ct.id = e_ct.contact_id
	;		
	--WHERE vs.schedule_date=in_date


ALTER TABLE public.vehicle_states_all OWNER TO concrete1;



-- ******************* update 17/04/2024 16:48:06 ******************
-- View: public.vehicle_current_pos_all

-- DROP VIEW public.vehicle_current_pos_all;

CREATE OR REPLACE VIEW public.vehicle_current_pos_all
 AS
 SELECT v.id,
    v.plate,
    v.feature,
    v.owner,
    v.make,
    ( SELECT car_tracking.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS period,
    ( SELECT date5_time5_descr(car_tracking.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone)) AS date5_time5_descr
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS period_str,
    ( SELECT car_tracking.longitude
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS lon_str,
    ( SELECT car_tracking.latitude
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS lat_str,
    ( SELECT round(car_tracking.speed, 0) AS round
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS speed,
    ( SELECT car_tracking.ns
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS ns,
    ( SELECT car_tracking.ew
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS ew,
    ( SELECT car_tracking.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS recieved_dt,
    ( SELECT date5_time5_descr(car_tracking.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)) AS date5_time5_descr
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS recieved_dt_str,
    ( SELECT car_tracking.odometer
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS odometer,
    ( SELECT engine_descr(car_tracking.engine_on) AS engine_descr
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS engine_on_str,
    ( SELECT car_tracking.voltage
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS voltage,
    ( SELECT heading_descr(car_tracking.heading) AS heading_descr
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS heading_str,
    ( SELECT car_tracking.heading
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS heading,
    ( SELECT car_tracking.lon
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS lon,
    ( SELECT car_tracking.lat
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS lat
     ,v.tracker_id::text AS tracker_id
   FROM vehicles v
  WHERE v.tracker_id IS NOT NULL AND v.tracker_id::text <> ''::text
  ORDER BY v.plate;

ALTER TABLE public.vehicle_current_pos_all OWNER TO concrete1;



-- ******************* update 17/04/2024 16:48:09 ******************
-- View: public.vehicles_last_pos

-- DROP VIEW public.vehicles_last_pos;

CREATE OR REPLACE VIEW public.vehicles_last_pos
AS
SELECT
	v.id
	,v.plate
	,v.feature
	,v.owner
	,v.make
	,v.tracker_id::text AS tracker_id
	,(SELECT
		json_build_object(
			'period',car_tracking.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
			,'speed',round(car_tracking.speed, 0)
			,'ns',car_tracking.ns
			,'ew',car_tracking.ew
			,'recieved_dt',car_tracking.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
			,'odometer',car_tracking.odometer
			,'voltage',round(car_tracking.voltage,0)
			,'heading',car_tracking.heading
			,'lon',car_tracking.lon
			,'lat',car_tracking.lat			
			/*
			,'heading_descr',heading_descr(car_tracking.heading)
			,'pt_geom',ST_BUFFER(
				ST_GeomFromText('POINT('||car_tracking.lon::text||' '||car_tracking.lat::text||')', 4326)
				,(SELECT (const_deviation_for_reroute_val()->>'distance_m')::int)
			)
			*/
		)
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1
	) AS pos_data
	
	/*
	( SELECT car_tracking.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS period,
	( SELECT round(car_tracking.speed, 0) AS round
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS speed,
	( SELECT car_tracking.ns
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS ns,
	( SELECT car_tracking.ew
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS ew,
	( SELECT car_tracking.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS recieved_dt,
	( SELECT car_tracking.odometer
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS odometer,
	( SELECT car_tracking.voltage
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS voltage,
	( SELECT heading_descr(car_tracking.heading) AS heading_descr
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS heading_str,
	( SELECT car_tracking.heading
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS heading,
	( SELECT car_tracking.lon
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS lon,
	( SELECT car_tracking.lat
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS lat
	*/	
FROM vehicles v
WHERE v.tracker_id IS NOT NULL AND v.tracker_id::text <> ''::text
ORDER BY v.plate_n;

ALTER TABLE public.vehicles_last_pos OWNER TO concrete1;



-- ******************* update 18/04/2024 05:24:15 ******************
--DROP VIEW public.vehicle_states_all;
CREATE OR REPLACE VIEW public.vehicle_states_all AS 
	SELECT 
		st.date_time,
		vs.id,
		CASE
		    WHEN st.state <> 'out'::vehicle_states AND st.state <> 'out_from_shift'::vehicle_states AND st.state <> 'shift'::vehicle_states AND st.state <> 'shift_added'::vehicle_states 

			THEN 1
			ELSE 0
		END AS vehicles_count,
		
		vehicles_ref(v) AS vehicles_ref,
		
		/*
		CASE
			WHEN v.vehicle_owner_id IS NULL THEN v.owner
			ELSE v_own.name
		END
		*/
		v_own.name::text AS owner,
		
		drivers_ref(d) AS drivers_ref,
		--d.phone_cel::text AS driver_phone_cel,
		ct.tel::text AS driver_phone_cel,
		
		st.state, 

		CASE 
			--WHEN st.state = 'busy'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+const_vehicle_unload_time_val())::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				--THEN true
			WHEN st.state = 'busy'::vehicle_states AND (st.date_time + coalesce(dest.time_route::interval,'00:00'::interval))::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			
			WHEN st.state = 'left_for_base'::vehicle_states AND (st.date_time +  coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			ELSE false
		END AS is_late,

		CASE
			WHEN st.state = 'at_dest'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*1 + const_vehicle_unload_time_val())::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			ELSE false
		END AS is_late_at_dest,
		
		CASE
			--shift - no inf
			WHEN st.state = 'shift'::vehicle_states OR st.state = 'shift_added'::vehicle_states
				THEN ''

			-- out_from_shift && out inf=out time
			WHEN st.state = 'out_from_shift'::vehicle_states OR st.state = 'out'::vehicle_states
				THEN time5_descr(st.date_time::time)::text

			--free && assigned inf= time elapsed
			WHEN st.state = 'free'::vehicle_states OR st.state = 'assigned'::vehicle_states
				THEN to_char(CURRENT_TIMESTAMP-st.date_time,'HH24:MI')

			--busy && late inf = -
			--WHEN st.state = 'busy'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+const_vehicle_unload_time_val())::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				--THEN '-'::text || time5_descr((CURRENT_TIMESTAMP - (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+const_vehicle_unload_time_val())::interval)::timestamp with time zone)::time without time zone)::text
			WHEN st.state = 'busy'::vehicle_states AND (st.date_time + coalesce(dest.time_route,'00:00'::time)+const_vehicle_unload_time_val()::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN time5_descr((coalesce(dest.time_route,'00:00'::time)+const_vehicle_unload_time_val()::interval )::time without time zone)::text
				
			-- busy not late
			WHEN st.state = 'busy'::vehicle_states
				--THEN time5_descr(((st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+const_vehicle_unload_time_val())::interval)::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text
				THEN time5_descr((coalesce(dest.time_route,'00:00'::time)+const_vehicle_unload_time_val()::interval )::time without time zone)::text

			--at dest && late inf=route_time
			WHEN st.state = 'at_dest'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*1+const_vehicle_unload_time_val())::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN time5_descr(coalesce(dest.time_route,'00:00'::time))::text

			--at dest NOT late
			WHEN st.state = 'at_dest'::vehicle_states
				THEN time5_descr( ((st.date_time + (coalesce(dest.time_route::interval,'00:00'::interval)+const_vehicle_unload_time_val()::interval))::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text

			--left_for_base && LATE
			WHEN st.state = 'left_for_base'::vehicle_states AND (st.date_time + coalesce(dest.time_route,'00:00'::time)::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN '-'::text || time5_descr((CURRENT_TIMESTAMP - (st.date_time + coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone)::time without time zone)::text

			--left_for_base NOT late
			WHEN st.state = 'left_for_base'::vehicle_states
				THEN time5_descr( ((st.date_time + coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text
		    
			ELSE ''
		    
		END AS inf_on_return, 
		
		v.load_capacity,
		(SELECT COUNT(*)
		FROM shipments
		WHERE (shipments.vehicle_schedule_id = vs.id AND shipments.shipped)
		) AS runs,

		coalesce(
			(SELECT 
				(now()-(tr.period+AGE(now(),now() AT TIME ZONE 'UTC')) ) > (const_no_tracker_signal_warn_interval_val())::interval
				FROM car_tracking AS tr
				WHERE tr.car_id=v.tracker_id
				ORDER BY tr.period DESC LIMIT 1
			)
		,TRUE) AS tracker_no_data,
		
		(v.tracker_id IS NULL OR v.tracker_id='') AS no_tracker,
		
		vs.schedule_date,
		
		vehicle_schedules_ref(vs,v,d) AS vehicle_schedules_ref,
		
		--d.phone_cel AS driver_tel
		ct.tel::varchar(15) AS driver_tel
		,v.tracker_id
		,production_bases_ref(production_bases_ref_t) AS production_bases_ref,
		production_bases_ref_t.name AS production_base_name, -- for sorting
		dest.name AS destination_name
		
	FROM vehicle_schedules vs
	
	LEFT JOIN drivers d ON d.id = vs.driver_id
	LEFT JOIN vehicles v ON v.id = vs.vehicle_id
	LEFT JOIN vehicle_schedule_states st ON
		st.id = (SELECT vehicle_schedule_states.id 
			FROM vehicle_schedule_states
			WHERE vehicle_schedule_states.schedule_id = vs.id
			ORDER BY vehicle_schedule_states.date_time DESC NULLS LAST
			LIMIT 1
		)
	--LEFT JOIN production_bases AS production_bases_ref_t ON production_bases_ref_t.id = vs.production_base_id
	LEFT JOIN production_bases AS production_bases_ref_t ON production_bases_ref_t.id = st.production_base_id
	
	LEFT JOIN shipments AS sh ON sh.id=st.shipment_id
	LEFT JOIN orders AS o ON o.id=sh.order_id		
	LEFT JOIN destinations AS dest ON dest.id=o.destination_id
	LEFT JOIN vehicle_owners AS v_own ON v_own.id=v.vehicle_owner_id
	LEFT JOIN entity_contacts AS e_ct ON e_ct.entity_type = 'drivers' AND e_ct.entity_id = d.id
	LEFT JOIN contacts AS ct ON ct.id = e_ct.contact_id
	;		
	--WHERE vs.schedule_date=in_date


ALTER TABLE public.vehicle_states_all OWNER TO beton;



-- ******************* update 18/04/2024 05:24:23 ******************
-- View: public.vehicles_last_pos

-- DROP VIEW public.vehicles_last_pos;

CREATE OR REPLACE VIEW public.vehicles_last_pos
AS
SELECT
	v.id
	,v.plate
	,v.feature
	,v.owner
	,v.make
	,v.tracker_id::text AS tracker_id
	,(SELECT
		json_build_object(
			'period',car_tracking.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
			,'speed',round(car_tracking.speed, 0)
			,'ns',car_tracking.ns
			,'ew',car_tracking.ew
			,'recieved_dt',car_tracking.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
			,'odometer',car_tracking.odometer
			,'voltage',round(car_tracking.voltage,0)
			,'heading',car_tracking.heading
			,'lon',car_tracking.lon
			,'lat',car_tracking.lat			
			/*
			,'heading_descr',heading_descr(car_tracking.heading)
			,'pt_geom',ST_BUFFER(
				ST_GeomFromText('POINT('||car_tracking.lon::text||' '||car_tracking.lat::text||')', 4326)
				,(SELECT (const_deviation_for_reroute_val()->>'distance_m')::int)
			)
			*/
		)
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1
	) AS pos_data
	
	/*
	( SELECT car_tracking.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS period,
	( SELECT round(car_tracking.speed, 0) AS round
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS speed,
	( SELECT car_tracking.ns
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS ns,
	( SELECT car_tracking.ew
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS ew,
	( SELECT car_tracking.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS recieved_dt,
	( SELECT car_tracking.odometer
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS odometer,
	( SELECT car_tracking.voltage
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS voltage,
	( SELECT heading_descr(car_tracking.heading) AS heading_descr
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS heading_str,
	( SELECT car_tracking.heading
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS heading,
	( SELECT car_tracking.lon
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS lon,
	( SELECT car_tracking.lat
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1) AS lat
	*/	
FROM vehicles v
WHERE v.tracker_id IS NOT NULL AND v.tracker_id::text <> ''::text
ORDER BY v.plate_n;

ALTER TABLE public.vehicles_last_pos OWNER TO beton;



-- ******************* update 18/04/2024 05:24:28 ******************
-- View: public.vehicle_current_pos_all

-- DROP VIEW public.vehicle_current_pos_all;

CREATE OR REPLACE VIEW public.vehicle_current_pos_all
 AS
 SELECT v.id,
    v.plate,
    v.feature,
    v.owner,
    v.make,
    ( SELECT car_tracking.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS period,
    ( SELECT date5_time5_descr(car_tracking.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone)) AS date5_time5_descr
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS period_str,
    ( SELECT car_tracking.longitude
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS lon_str,
    ( SELECT car_tracking.latitude
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS lat_str,
    ( SELECT round(car_tracking.speed, 0) AS round
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS speed,
    ( SELECT car_tracking.ns
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS ns,
    ( SELECT car_tracking.ew
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS ew,
    ( SELECT car_tracking.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS recieved_dt,
    ( SELECT date5_time5_descr(car_tracking.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)) AS date5_time5_descr
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS recieved_dt_str,
    ( SELECT car_tracking.odometer
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS odometer,
    ( SELECT engine_descr(car_tracking.engine_on) AS engine_descr
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS engine_on_str,
    ( SELECT car_tracking.voltage
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS voltage,
    ( SELECT heading_descr(car_tracking.heading) AS heading_descr
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS heading_str,
    ( SELECT car_tracking.heading
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS heading,
    ( SELECT car_tracking.lon
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS lon,
    ( SELECT car_tracking.lat
           FROM car_tracking
          WHERE car_tracking.car_id::text = v.tracker_id::text
          ORDER BY car_tracking.period DESC
         LIMIT 1) AS lat
     ,v.tracker_id::text AS tracker_id
   FROM vehicles v
  WHERE v.tracker_id IS NOT NULL AND v.tracker_id::text <> ''::text
  ORDER BY v.plate;

ALTER TABLE public.vehicle_current_pos_all OWNER TO beton;



-- ******************* update 18/04/2024 05:24:42 ******************
﻿-- Function: sms_pump_order_ship_ct(in_order_id int)

-- DROP FUNCTION sms_pump_order_ship_ct(in_order_id int);

CREATE OR REPLACE FUNCTION sms_pump_order_ship_ct(in_order_id int)
  RETURNS TABLE(
  	phone_cel text,
  	message text,
  	ext_contact_id int
  ) AS
$$
	SELECT
		tel,
		sms_templates_text(
			template_params
			,(SELECT t.pattern
			FROM sms_patterns t
			WHERE t.sms_type = 'order_for_pump_ship'::sms_types AND t.lang_id = (SELECT (const_def_lang_val()->'keys'->>'id')::int)
			)
		),
		contact_id
	FROM sms_pump_order_templates_params
	WHERE
		id = in_order_id
		-- add check for inform checkbox
		AND
		coalesce(
			(SELECT
				TRUE
			FROM pump_vehicles AS p
			WHERE p.id = (SELECT pump_vehicle_id FROM orders AS o WHERE o.id = in_order_id) AND p.driver_ship_inform
			)
		, FALSE)
		;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION sms_pump_order_ship_ct(in_order_id int) OWNER TO beton;


-- ******************* update 18/04/2024 05:24:47 ******************
-- View: public.pump_veh_list

-- DROP VIEW public.pump_veh_list CASCADE;

CREATE OR REPLACE VIEW public.pump_veh_list AS 
	SELECT
		pv.id,
		pv.phone_cel,
		vehicles_ref(v) AS pump_vehicles_ref,
		pump_prices_ref(ppr) AS pump_prices_ref,
		
		v.make,
		v.owner,
		v.feature,
		v.plate,
		pv.deleted,
		pv.pump_length,
		--vehicle_owners_ref(v_own) AS vehicle_owners_ref,
		
		(SELECT
			owners.r->'fields'->'owner'
		FROM
		(
			SELECT jsonb_array_elements(v.vehicle_owners->'rows') AS r
		) AS owners
		ORDER BY owners.r->'fields'->'dt_from' DESC
		LIMIT 1
		) AS vehicle_owners_ref,
		
		pv.comment_text,
		
		--v.vehicle_owner_id,
		(SELECT
			CASE WHEN owners.r->'fields'->'owner'->'keys'->>'id'='null' THEN NULL
				ELSE (owners.r->'fields'->'owner'->'keys'->>'id')::int
			END	
		FROM
		(
			SELECT jsonb_array_elements(v.vehicle_owners->'rows') AS r
		) AS owners
		ORDER BY owners.r->'fields'->'dt_from' DESC
		LIMIT 1
		) AS vehicle_owner_id,
		
		
		pv.phone_cels,
		pv.pump_prices,
		
		v.vehicle_owners_ar,
		pump_vehicles_ref(
			pv,
			v,
			(SELECT vh_o FROM vehicle_owners AS vh_o
			WHERE vh_o.id = 
				(SELECT
					CASE WHEN owners.r->'fields'->'owner'->'keys'->>'id'='null' THEN NULL
						ELSE (owners.r->'fields'->'owner'->'keys'->>'id')::int
					END	
				FROM
				(
					SELECT jsonb_array_elements(v.vehicle_owners->'rows') AS r
				) AS owners
				ORDER BY owners.r->'fields'->'dt_from' DESC
				LIMIT 1
				)			
			)
		) AS self_ref,
		
		pv.specialist_inform,
		
		(SELECT
			json_agg(
				json_build_object(
					'name', ct.name,
					'tel', ct.tel,
					'tel_ext', ct.tel_ext,
					'email', ct.email,
					'post', p.name
				)
			)
		FROM entity_contacts AS en
		LEFT JOIN contacts AS ct ON ct.id = en.contact_id
		LEFT JOIN posts AS p ON p.id = ct.post_id
		WHERE en.entity_type = 'pump_vehicles' AND en.entity_id = pv.id
		) AS contact_list,	
		
		pv.driver_ship_inform
		
	FROM pump_vehicles pv
	LEFT JOIN vehicles v ON v.id = pv.vehicle_id
	LEFT JOIN pump_prices ppr ON ppr.id = pv.pump_price_id
	--LEFT JOIN vehicle_owners v_own ON v_own.id = v.vehicle_owner_id
	ORDER BY v.plate;

ALTER TABLE public.pump_veh_list
  OWNER TO beton;



-- ******************* update 18/04/2024 05:24:57 ******************
-- View: public.pump_vehicles_list

-- DROP VIEW public.pump_vehicles_list;

CREATE OR REPLACE VIEW public.pump_vehicles_list
 AS
 SELECT pv.id,
    pv.vehicle_id,
    pv.phone_cel,
    pv.pump_price_id,
    ppr.name AS pump_price_descr,
    v.plate,
    (((v.plate::text || ' '::text) || v.make::text) || ' '::text) || v.owner::text AS vehicle_descr,
    pv.driver_ship_inform
    
   FROM pump_vehicles pv
     LEFT JOIN vehicles v ON v.id = pv.vehicle_id
     LEFT JOIN pump_prices ppr ON ppr.id = pv.pump_price_id
  ORDER BY v.plate;

ALTER TABLE public.pump_vehicles_list
    OWNER TO beton;



-- ******************* update 18/04/2024 05:25:07 ******************
-- View: public.sms_pump_order_templates_params

-- DROP VIEW public.sms_pump_order_templates_params;

CREATE OR REPLACE VIEW public.sms_pump_order_templates_params
AS
	SELECT
		o.id,
		ct.tel,
		ARRAY[
			format('("quant","%s")'::text, o.quant::text)::template_value,
			format('("date","%s")'::text, date5_descr(o.date_time::date)::text)::template_value,
			format('("time","%s")'::text, time5_descr(o.date_time::time without time zone)::text)::template_value,
			format('("date","%s")'::text, date8_descr(o.date_time::date)::text)::template_value,
			format('("dest","%s")'::text, dest.name::text)::template_value,
			format('("concrete","%s")'::text, ctp.name::text)::template_value,
			format('("client","%s")'::text, cl.name::text)::template_value,
			format('("name","%s")'::text, o.descr)::template_value,
			format('("tel","%s")'::text,'+7'||format_cel_standart(o.phone_cel::text))::template_value,
			format('("car","%s")'::text, vh.plate::text)::template_value
		] AS template_params,
		ent_ct.contact_id
	
	FROM orders o
	LEFT JOIN concrete_types ctp ON ctp.id = o.concrete_type_id
	LEFT JOIN destinations dest ON dest.id = o.destination_id
	LEFT JOIN pump_vehicles pvh ON pvh.id = o.pump_vehicle_id
	LEFT JOIN vehicles vh ON vh.id = pvh.vehicle_id
	LEFT JOIN clients cl ON cl.id = o.client_id		
	LEFT JOIN entity_contacts AS ent_ct ON ent_ct.entity_type = 'pump_vehicles' AND ent_ct.entity_id = pvh.id
	LEFT JOIN contacts ct ON ct.id = ent_ct.contact_id		
	WHERE ent_ct.contact_id IS NOT NULL
	;
	
ALTER TABLE public.sms_pump_order_templates_params
    OWNER TO beton;



-- ******************* update 18/04/2024 05:25:15 ******************
﻿-- Function: sms_pump_order_upd_ct(in_order_id int)

-- DROP FUNCTION sms_pump_order_upd_ct(in_order_id int);

CREATE OR REPLACE FUNCTION sms_pump_order_upd_ct(in_order_id int)
  RETURNS TABLE(
  	phone_cel text,
  	message text,
  	ext_contact_id int
  ) AS
$$
	SELECT
		tel,
		sms_templates_text(
			template_params
			,(SELECT t.pattern
			FROM sms_patterns t
			WHERE t.sms_type = 'order_for_pump_upd'::sms_types AND t.lang_id = (SELECT (const_def_lang_val()->'keys'->>'id')::int)
			)
		),
		contact_id
	FROM sms_pump_order_templates_params
	WHERE id = in_order_id;

$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION sms_pump_order_upd_ct(in_order_id int) OWNER TO beton;


-- ******************* update 18/04/2024 05:25:20 ******************
﻿-- Function: sms_pump_order_del(in_order_id int)

-- DROP FUNCTION sms_pump_order_del(in_order_id int);

/**
 * Используется именно функция
 * из Order_Controller
 */
CREATE OR REPLACE FUNCTION sms_pump_order_del_ct(in_order_id int)
  RETURNS TABLE(
  	phone_cel text,
  	message text,
  	ext_contact_id int
  ) AS
$$
	SELECT
		tel,
		sms_templates_text(
			template_params
			,(SELECT t.pattern
			FROM sms_patterns t
			WHERE t.sms_type = 'order_for_pump_del'::sms_types AND t.lang_id = (SELECT (const_def_lang_val()->'keys'->>'id')::int)
			)
		),
		contact_id
	FROM sms_pump_order_templates_params
	WHERE id = in_order_id;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION sms_pump_order_del_ct(in_order_id int) OWNER TO beton;


-- ******************* update 18/04/2024 05:25:26 ******************
﻿-- Function: sms_pump_order_ins_ct(in_order_id int)

-- DROP FUNCTION sms_pump_order_ins_ct(in_order_id int);

CREATE OR REPLACE FUNCTION sms_pump_order_ins_ct(in_order_id int)
  RETURNS TABLE(
  	phone_cel text,
  	message text,
  	ext_contact_id int
  ) AS
$$
	SELECT
		tel,
		sms_templates_text(
			template_params
			,(SELECT t.pattern
			FROM sms_patterns t
			WHERE t.sms_type = 'order_for_pump_ins'::sms_types AND t.lang_id = (SELECT (const_def_lang_val()->'keys'->>'id')::int)
			)
		),
		contact_id
	FROM sms_pump_order_templates_params
	WHERE id = in_order_id;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION sms_pump_order_ins_ct(in_order_id int) OWNER TO beton;


-- ******************* update 18/04/2024 11:37:10 ******************
-- Function: public.doc_material_procurements_process()

-- DROP FUNCTION public.doc_material_procurements_process();

CREATE OR REPLACE FUNCTION public.doc_material_procurements_process()
  RETURNS trigger AS
$BODY$
DECLARE
	reg_act ra_materials%ROWTYPE;
	reg_material_facts ra_material_facts%ROWTYPE;
	reg_cement ra_cement%ROWTYPE;
	v_dif_store bool;
	v_production_site_id int;
BEGIN
	IF (TG_WHEN='BEFORE' AND TG_OP='INSERT') THEN
		-- Временно!
		--NEW.production_base_id = 1;
		--Обнудение материал = БЕТОН
		IF NEW.material_id = 1240 THEN
			NEW.quant_net = 0;
			NEW.quant_gross = 0;
		END IF;
		
		--Если это из горного - обнулить по документам
		IF coalesce(NEW.doc_ref_gornyi, '') <> ''
		THEN
			NEW.doc_quant_gross = 0;
			NEW.doc_quant_net = 0;
		END IF;
		
		RETURN NEW;
		
	ELSIF (TG_WHEN='AFTER') AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN					
		IF (TG_OP='INSERT') THEN						
			--log
			PERFORM doc_log_insert('material_procurement'::doc_types,NEW.id,NEW.date_time);
		END IF;

		--register actions ra_materials
		reg_act.date_time		= NEW.date_time;
		reg_act.deb			= true;
		reg_act.doc_type  		= 'material_procurement'::doc_types;
		reg_act.doc_id  		= NEW.id;
		reg_act.production_base_id	= NEW.production_base_id;
		reg_act.material_id		= NEW.material_id;
		reg_act.quant			= NEW.quant_net;
		PERFORM ra_materials_add_act(reg_act);	
		
		SELECT dif_store INTO v_dif_store FROM raw_materials WHERE id=NEW.material_id;
		--По материалам делаем всегда движения, а если есть учет по силосам и есть силос - то и по силосам
		--Если учет по заводам (v_dif_store==TRUE)- то по заводам
		--register actions ra_material_facts
		reg_material_facts.date_time		= NEW.date_time;
		reg_material_facts.deb			= true;
		reg_material_facts.doc_type  		= 'material_procurement'::doc_types;
		reg_material_facts.doc_id  		= NEW.id;
		reg_material_facts.material_id		= NEW.material_id;
		reg_material_facts.production_base_id	= NEW.production_base_id;
		
		IF coalesce(v_dif_store,FALSE) AND coalesce(NEW.store,'')<>'' THEN
			--Определить завод по приходу
			SELECT production_site_id INTO v_production_site_id FROM store_map_to_production_sites WHERE store = NEW.store;
			--RAISE EXCEPTION 'v_production_site_id=%',v_production_site_id;
			IF v_production_site_id IS NULL THEN
				-- no match!
				INSERT INTO store_map_to_production_sites (store) VALUES (NEW.store);
			END IF;
			reg_material_facts.production_site_id = v_production_site_id;
		END IF;
		reg_material_facts.quant		= NEW.quant_net;
		PERFORM ra_material_facts_add_act(reg_material_facts);	
		
		IF coalesce( (SELECT is_cement FROM raw_materials WHERE id = NEW.material_id),FALSE)
		AND NEW.cement_silos_id IS NOT NULL THEN
			--register actions ra_cement
			reg_cement.date_time		= NEW.date_time;
			reg_cement.deb			= true;
			reg_cement.doc_type  		= 'material_procurement'::doc_types;
			reg_cement.doc_id  		= NEW.id;
			reg_cement.cement_silos_id	= NEW.cement_silos_id;
			reg_cement.quant		= NEW.quant_net;
			PERFORM ra_cement_add_act(reg_cement);	
			
		END IF;
			
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',NEW.date_time::date
				)
			)::text
		);
				
		RETURN NEW;
		
	ELSIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		PERFORM ra_materials_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_cement_remove_acts('material_procurement'::doc_types,OLD.id);

		-- Временно!
		IF NEW.production_base_id IS NULL THEN
			NEW.production_base_id = 1;
		END IF;	

		--Если это из горного - обнулить по документам
		IF coalesce(NEW.doc_ref_gornyi, '') <> ''
		AND (coalesce(NEW.doc_quant_gross,0)<>0 OR coalesce(NEW.doc_quant_net,0)<>0)
		THEN
			NEW.doc_quant_gross = 0;
			NEW.doc_quant_net = 0;
		END IF;


		IF NEW.date_time<>OLD.date_time THEN
			PERFORM doc_log_update('material_procurement'::doc_types,NEW.id,NEW.date_time);
		END IF;
						
		RETURN NEW;
		
	ELSIF (TG_WHEN='AFTER' AND TG_OP='DELETE') THEN
	
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',OLD.date_time::date
				)
			)::text
		);
	
		RETURN OLD;
	ELSIF (TG_WHEN='BEFORE' AND TG_OP='DELETE') THEN
		--detail tables
		
		--register actions										
		PERFORM ra_materials_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_cement_remove_acts('material_procurement'::doc_types,OLD.id);
		
		--log
		PERFORM doc_log_delete('material_procurement'::doc_types,OLD.id);
		
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.doc_material_procurements_process()
  OWNER TO beton;



-- ******************* update 18/04/2024 11:37:43 ******************
-- Function: public.doc_material_procurements_process()

-- DROP FUNCTION public.doc_material_procurements_process();

CREATE OR REPLACE FUNCTION public.doc_material_procurements_process()
  RETURNS trigger AS
$BODY$
DECLARE
	reg_act ra_materials%ROWTYPE;
	reg_material_facts ra_material_facts%ROWTYPE;
	reg_cement ra_cement%ROWTYPE;
	v_dif_store bool;
	v_production_site_id int;
BEGIN
	IF (TG_WHEN='BEFORE' AND TG_OP='INSERT') THEN
		-- Временно!
		--NEW.production_base_id = 1;
		--Обнудение материал = БЕТОН
		IF NEW.material_id = 1240 THEN
			NEW.quant_net = 0;
			NEW.quant_gross = 0;
		END IF;
		
		--Если это из горного - обнулить по документам
		IF coalesce(NEW.doc_ref_gornyi, '') <> ''
		THEN
			NEW.doc_quant_gross = 0;
			NEW.doc_quant_net = 0;
		END IF;
		
		RETURN NEW;
		
	ELSIF (TG_WHEN='AFTER') AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN					
		IF (TG_OP='INSERT') THEN						
			--log
			PERFORM doc_log_insert('material_procurement'::doc_types,NEW.id,NEW.date_time);
		END IF;

		--register actions ra_materials
		reg_act.date_time		= NEW.date_time;
		reg_act.deb			= true;
		reg_act.doc_type  		= 'material_procurement'::doc_types;
		reg_act.doc_id  		= NEW.id;
		reg_act.production_base_id	= NEW.production_base_id;
		reg_act.material_id		= NEW.material_id;
		reg_act.quant			= NEW.quant_net;
		PERFORM ra_materials_add_act(reg_act);	
		
		SELECT dif_store INTO v_dif_store FROM raw_materials WHERE id=NEW.material_id;
		--По материалам делаем всегда движения, а если есть учет по силосам и есть силос - то и по силосам
		--Если учет по заводам (v_dif_store==TRUE)- то по заводам
		--register actions ra_material_facts
		reg_material_facts.date_time		= NEW.date_time;
		reg_material_facts.deb			= true;
		reg_material_facts.doc_type  		= 'material_procurement'::doc_types;
		reg_material_facts.doc_id  		= NEW.id;
		reg_material_facts.material_id		= NEW.material_id;
		reg_material_facts.production_base_id	= NEW.production_base_id;
		
		IF coalesce(v_dif_store,FALSE) AND coalesce(NEW.store,'')<>'' THEN
			--Определить завод по приходу
			SELECT production_site_id INTO v_production_site_id FROM store_map_to_production_sites WHERE store = NEW.store;
			--RAISE EXCEPTION 'v_production_site_id=%',v_production_site_id;
			IF v_production_site_id IS NULL THEN
				-- no match!
				INSERT INTO store_map_to_production_sites (store) VALUES (NEW.store);
			END IF;
			reg_material_facts.production_site_id = v_production_site_id;
		END IF;
		reg_material_facts.quant		= NEW.quant_net;
		PERFORM ra_material_facts_add_act(reg_material_facts);	
		
		IF coalesce( (SELECT is_cement FROM raw_materials WHERE id = NEW.material_id),FALSE)
		AND NEW.cement_silos_id IS NOT NULL THEN
			--register actions ra_cement
			reg_cement.date_time		= NEW.date_time;
			reg_cement.deb			= true;
			reg_cement.doc_type  		= 'material_procurement'::doc_types;
			reg_cement.doc_id  		= NEW.id;
			reg_cement.cement_silos_id	= NEW.cement_silos_id;
			reg_cement.quant		= NEW.quant_net;
			PERFORM ra_cement_add_act(reg_cement);	
			
		END IF;
			
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',NEW.date_time::date
				)
			)::text
		);
				
		RETURN NEW;
		
	ELSIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		PERFORM ra_materials_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_cement_remove_acts('material_procurement'::doc_types,OLD.id);

		-- Временно!
		IF NEW.production_base_id IS NULL THEN
			NEW.production_base_id = 1;
		END IF;	

		--Если это из горного - обнулить по документам
		IF coalesce(NEW.doc_ref_gornyi, '') <> ''
		AND (coalesce(NEW.doc_quant_gross,0)<>0 OR coalesce(NEW.doc_quant_net,0)<>0)
		THEN
			NEW.doc_quant_gross = 0;
			NEW.doc_quant_net = 0;
		END IF;


		IF NEW.date_time<>OLD.date_time THEN
			PERFORM doc_log_update('material_procurement'::doc_types,NEW.id,NEW.date_time);
		END IF;
						
		RETURN NEW;
		
	ELSIF (TG_WHEN='AFTER' AND TG_OP='DELETE') THEN
	
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',OLD.date_time::date
				)
			)::text
		);
	
		RETURN OLD;
	ELSIF (TG_WHEN='BEFORE' AND TG_OP='DELETE') THEN
		--detail tables
		
		--register actions										
		PERFORM ra_materials_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_cement_remove_acts('material_procurement'::doc_types,OLD.id);
		
		--log
		PERFORM doc_log_delete('material_procurement'::doc_types,OLD.id);
		
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.doc_material_procurements_process()
  OWNER TO concrete1;



-- ******************* update 18/04/2024 12:33:22 ******************
-- FUNCTION: public.geo_zone_check()

-- DROP FUNCTION IF EXISTS public.geo_zone_check();

CREATE OR REPLACE FUNCTION public.geo_zone_check()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	v_cur_state vehicle_states;
	v_production_base_id int;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	
	v_zone geometry;
	
	v_st_date_time timestamp without time zone;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;
	v_long_route_rest bool;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;

	--get last state
	WITH
	shift AS (
		SELECT
			d_from,
			d_to
		FROM get_shift_bounds(NEW.recieved_dt + age(now(), now() at time zone 'UTC')) AS (d_from timestamp, d_to timestamp)
	)
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE
		st.tracker_id = NEW.car_id
		AND st.date_time BETWEEN (SELECT d_from FROM shift) AND (SELECT d_to FROM shift)
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF v_cur_state = 'busy'::vehicle_states THEN
			--clients zone on shipment
			SELECT				
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id = shipments.order_id
			LEFT JOIN destinations ON destinations.id = orders.destination_id
			WHERE
				shipments.id = v_shipment_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
			
		ELSIF  v_cur_state = 'at_dest'::vehicle_states THEN
			-- client zone from state
			SELECT
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM destinations
			WHERE
				destinations.id = v_destination_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
		ELSE
			--
			-- base zone
			-- ALL possible zones, NOT constant_base_geo_zone_id()
			-- returns one zone only
			SELECT
				b.id,
				b.destination_id,
				destinations.zone
			INTO
				v_production_base_id,
				v_destination_id,
				v_zone
			FROM production_bases AS b
			LEFT JOIN destinations ON destinations.id = b.destination_id
			WHERE
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			LIMIT 1			
			;
					
		END IF;		
		
		--if at least the last point inside zone
		IF v_zone IS NOT NULL THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat
					FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid = 1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count() - 1
					OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					-- v_production_base_id = previous state value
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					-- v_production_base_id = previous state value OR some other logic!!! Куда назначили
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
					--v_production_base_id = Фактическая зона, зона производственной площадки
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id, destination_id, shipment_id, production_base_id)
					VALUES (CURRENT_TIMESTAMP,
						v_schedule_id,
						v_new_state,
						NEW.car_id,
						v_destination_id,
						v_shipment_id,
						v_production_base_id
					);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						--v_cur_state='at_dest' OR 
						WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		/*IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%, v_cur_state=%',v_shipment_id,v_cur_state;
		END IF;*/
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						/*v_point_in_zone = FALSE;
						SELECT
							st_contains(
								st_transform(
									st_buffer(
										st_transform(
											ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
											,3857
										)
										,30
									)
								,4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
						END IF;
						*/
						
						IF v_destination_id IS NOT NULL AND v_client_id IS NOT NULL THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT (client_id,destination_id) DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;						
						--route done
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										--v_cur_state='at_dest' OR 
										WHEN v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		SELECT (length(v_hypothetical_route_rest_t)>7500) INTO v_long_route_rest;
		IF v_long_route_rest THEN
			INSERT INTO route_rests VALUES(NEW.car_id,v_hypothetical_route_rest_t)
			ON CONFLICT (tracker_id) DO UPDATE SET
			route_rest = v_hypothetical_route_rest_t;
		END IF;
		
		--returns vehicles_last_pos struc + route
		BEGIN
			PERFORM pg_notify(
				'Vehicle.position.'||NEW.car_id
				,json_build_object(
					'params',json_build_object(
						'tracker_id',NEW.car_id
						,'lon',NEW.lon
						,'lat',NEW.lat
						,'heading',NEW.heading
						,'speed',NEW.speed
						,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'ns',NEW.ns
						,'ew',NEW.ew
						,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'odometer',NEW.odometer::text
						,'voltage',round(NEW.voltage,0)
						,'route_rest',CASE WHEN v_long_route_rest THEN NULL ELSE v_hypothetical_route_rest_t END
						,'long_route_rest',v_long_route_rest
						,'route_rest_len',v_hypothetical_route_rest_len
					)
				)::text
			);
		EXCEPTION WHEN OTHERS THEN
		END;
	END IF;

	--from beton to konkrid
	IF current_database() = 'bereg' THEN
		--whose car?
		--konkrid ownerID=286
		IF
			coalesce(
				(SELECT
						(owners.f->'owner'->'keys'->>'id')::int = 286 AS konkrid_owned
				FROM (
					SELECT
							jsonb_array_elements(vehicle_owners->'rows')->'fields' AS f
					FROM vehicles AS v
					WHERE v.tracker_id = NEW.car_id
				) AS owners
				ORDER BY (owners.f->>'dt_from')::timestamp DESC
				LIMIT 1)
			, FALSE
			) THEN
			
			PERFORM pg_notify(
				'Tracking.insert'
				,json_build_object(
					'params',json_build_object(
						'period', NEW.period,
						'car_id', NEW.car_id
					)
				)::text
			);
		END IF;
	END IF;
		
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.geo_zone_check()
    OWNER TO beton;



-- ******************* update 18/04/2024 12:41:10 ******************
-- FUNCTION: public.geo_zone_check()

-- DROP FUNCTION IF EXISTS public.geo_zone_check();

CREATE OR REPLACE FUNCTION public.geo_zone_check()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	v_cur_state vehicle_states;
	v_production_base_id int;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	
	v_zone geometry;
	
	v_st_date_time timestamp without time zone;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;
	v_long_route_rest bool;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;

	--get last state
	WITH
	shift AS (
		SELECT
			d_from,
			d_to
		FROM get_shift_bounds(NEW.recieved_dt + age(now(), now() at time zone 'UTC')) AS (d_from timestamp, d_to timestamp)
	)
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE
		st.tracker_id = NEW.car_id
		AND st.date_time BETWEEN (SELECT d_from FROM shift) AND (SELECT d_to FROM shift)
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF v_cur_state = 'busy'::vehicle_states THEN
			--clients zone on shipment
			SELECT				
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id = shipments.order_id
			LEFT JOIN destinations ON destinations.id = orders.destination_id
			WHERE
				shipments.id = v_shipment_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
			
		ELSIF  v_cur_state = 'at_dest'::vehicle_states THEN
			-- client zone from state
			SELECT
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM destinations
			WHERE
				destinations.id = v_destination_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
		ELSE
			--
			-- base zone
			-- ALL possible zones, NOT constant_base_geo_zone_id()
			-- returns one zone only
			SELECT
				b.id,
				b.destination_id,
				destinations.zone
			INTO
				v_production_base_id,
				v_destination_id,
				v_zone
			FROM production_bases AS b
			LEFT JOIN destinations ON destinations.id = b.destination_id
			WHERE
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			LIMIT 1			
			;
					
		END IF;		
		
		--if at least the last point inside zone
		IF v_zone IS NOT NULL THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat
					FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid = 1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count() - 1
					OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					-- v_production_base_id = previous state value
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					-- v_production_base_id = previous state value OR some other logic!!! Куда назначили
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
					--v_production_base_id = Фактическая зона, зона производственной площадки
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id, destination_id, shipment_id, production_base_id)
					VALUES (CURRENT_TIMESTAMP,
						v_schedule_id,
						v_new_state,
						NEW.car_id,
						v_destination_id,
						v_shipment_id,
						v_production_base_id
					);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						--v_cur_state='at_dest' OR 
						WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		/*IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%, v_cur_state=%',v_shipment_id,v_cur_state;
		END IF;*/
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						/*v_point_in_zone = FALSE;
						SELECT
							st_contains(
								st_transform(
									st_buffer(
										st_transform(
											ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
											,3857
										)
										,30
									)
								,4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
						END IF;
						*/
						
						IF v_destination_id IS NOT NULL AND v_client_id IS NOT NULL THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT (client_id,destination_id) DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;						
						--route done
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										--v_cur_state='at_dest' OR 
										WHEN v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		SELECT (length(v_hypothetical_route_rest_t)>7500) INTO v_long_route_rest;
		IF v_long_route_rest THEN
			INSERT INTO route_rests VALUES(NEW.car_id,v_hypothetical_route_rest_t)
			ON CONFLICT (tracker_id) DO UPDATE SET
			route_rest = v_hypothetical_route_rest_t;
		END IF;
		
		--returns vehicles_last_pos struc + route
		BEGIN
			PERFORM pg_notify(
				'Vehicle.position.'||NEW.car_id
				,json_build_object(
					'params',json_build_object(
						'tracker_id',NEW.car_id
						,'lon',NEW.lon
						,'lat',NEW.lat
						,'heading',NEW.heading
						,'speed',NEW.speed
						,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'ns',NEW.ns
						,'ew',NEW.ew
						,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'odometer',NEW.odometer::text
						,'voltage',round(NEW.voltage,0)
						,'route_rest',CASE WHEN v_long_route_rest THEN NULL ELSE v_hypothetical_route_rest_t END
						,'long_route_rest',v_long_route_rest
						,'route_rest_len',v_hypothetical_route_rest_len
					)
				)::text
			);
		EXCEPTION WHEN OTHERS THEN
		END;
	END IF;

	--from beton to konkrid
	IF current_database() = 'bereg' THEN
		--whose car?
		--konkrid ownerID=286
		IF
			coalesce(
				(SELECT
						(owners.f->'owner'->'keys'->>'id')::int = 286 AS konkrid_owned
				FROM (
					SELECT
							jsonb_array_elements(vehicle_owners->'rows')->'fields' AS f
					FROM vehicles AS v
					WHERE v.tracker_id = NEW.car_id
				) AS owners
				ORDER BY (owners.f->>'dt_from')::timestamp DESC
				LIMIT 1)
			, FALSE
			) THEN
			
			PERFORM pg_notify(
				'CarTracking.konkrid'
				,json_build_object(
					'params',json_build_object(
						'period', NEW.period,
						'car_id', NEW.car_id
					)
				)::text
			);
		END IF;
	END IF;
		
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.geo_zone_check()
    OWNER TO beton;



-- ******************* update 18/04/2024 12:46:58 ******************
-- Function: public.doc_material_procurements_process()

-- DROP FUNCTION public.doc_material_procurements_process();

CREATE OR REPLACE FUNCTION public.doc_material_procurements_process()
  RETURNS trigger AS
$BODY$
DECLARE
	reg_act ra_materials%ROWTYPE;
	reg_material_facts ra_material_facts%ROWTYPE;
	reg_cement ra_cement%ROWTYPE;
	v_dif_store bool;
	v_production_site_id int;
BEGIN
	IF (TG_WHEN='BEFORE' AND TG_OP='INSERT') THEN
		IF NEW.date_time <= '2024-01-01T00:00:00'::timestamp THEN
			RAISE EXCEPTION 'Дата запрета редактирования: %', '2024-01-01T00:00:00'::timestamp;
		END IF;
		
		-- Временно!
		--NEW.production_base_id = 1;
		--Обнудение материал = БЕТОН
		IF NEW.material_id = 1240 THEN
			NEW.quant_net = 0;
			NEW.quant_gross = 0;
		END IF;
		
		--Если это из горного - обнулить по документам
		IF coalesce(NEW.doc_ref_gornyi, '') <> ''
		THEN
			NEW.doc_quant_gross = 0;
			NEW.doc_quant_net = 0;
		END IF;
		
		RETURN NEW;
		
	ELSIF (TG_WHEN='AFTER') AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN					
		IF (TG_OP='INSERT') THEN						
			--log
			PERFORM doc_log_insert('material_procurement'::doc_types,NEW.id,NEW.date_time);
		END IF;

		--register actions ra_materials
		reg_act.date_time		= NEW.date_time;
		reg_act.deb			= true;
		reg_act.doc_type  		= 'material_procurement'::doc_types;
		reg_act.doc_id  		= NEW.id;
		reg_act.production_base_id	= NEW.production_base_id;
		reg_act.material_id		= NEW.material_id;
		reg_act.quant			= NEW.quant_net;
		PERFORM ra_materials_add_act(reg_act);	
		
		SELECT dif_store INTO v_dif_store FROM raw_materials WHERE id=NEW.material_id;
		--По материалам делаем всегда движения, а если есть учет по силосам и есть силос - то и по силосам
		--Если учет по заводам (v_dif_store==TRUE)- то по заводам
		--register actions ra_material_facts
		reg_material_facts.date_time		= NEW.date_time;
		reg_material_facts.deb			= true;
		reg_material_facts.doc_type  		= 'material_procurement'::doc_types;
		reg_material_facts.doc_id  		= NEW.id;
		reg_material_facts.material_id		= NEW.material_id;
		reg_material_facts.production_base_id	= NEW.production_base_id;
		
		IF coalesce(v_dif_store,FALSE) AND coalesce(NEW.store,'')<>'' THEN
			--Определить завод по приходу
			SELECT production_site_id INTO v_production_site_id FROM store_map_to_production_sites WHERE store = NEW.store;
			--RAISE EXCEPTION 'v_production_site_id=%',v_production_site_id;
			IF v_production_site_id IS NULL THEN
				-- no match!
				INSERT INTO store_map_to_production_sites (store) VALUES (NEW.store);
			END IF;
			reg_material_facts.production_site_id = v_production_site_id;
		END IF;
		reg_material_facts.quant		= NEW.quant_net;
		PERFORM ra_material_facts_add_act(reg_material_facts);	
		
		IF coalesce( (SELECT is_cement FROM raw_materials WHERE id = NEW.material_id),FALSE)
		AND NEW.cement_silos_id IS NOT NULL THEN
			--register actions ra_cement
			reg_cement.date_time		= NEW.date_time;
			reg_cement.deb			= true;
			reg_cement.doc_type  		= 'material_procurement'::doc_types;
			reg_cement.doc_id  		= NEW.id;
			reg_cement.cement_silos_id	= NEW.cement_silos_id;
			reg_cement.quant		= NEW.quant_net;
			PERFORM ra_cement_add_act(reg_cement);	
			
		END IF;
			
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',NEW.date_time::date
				)
			)::text
		);
				
		RETURN NEW;
		
	ELSIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		IF NEW.date_time <= '2024-01-01T00:00:00'::timestamp THEN
			RAISE EXCEPTION 'Дата запрета редактирования: %', '2024-01-01T00:00:00'::timestamp;
		END IF;
	
		PERFORM ra_materials_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_cement_remove_acts('material_procurement'::doc_types,OLD.id);

		-- Временно!
		IF NEW.production_base_id IS NULL THEN
			NEW.production_base_id = 1;
		END IF;	

		--Если это из горного - обнулить по документам
		IF coalesce(NEW.doc_ref_gornyi, '') <> ''
		AND (coalesce(NEW.doc_quant_gross,0)<>0 OR coalesce(NEW.doc_quant_net,0)<>0)
		THEN
			NEW.doc_quant_gross = 0;
			NEW.doc_quant_net = 0;
		END IF;


		IF NEW.date_time<>OLD.date_time THEN
			PERFORM doc_log_update('material_procurement'::doc_types,NEW.id,NEW.date_time);
		END IF;
						
		RETURN NEW;
		
	ELSIF (TG_WHEN='AFTER' AND TG_OP='DELETE') THEN
	
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',OLD.date_time::date
				)
			)::text
		);
	
		RETURN OLD;
	ELSIF (TG_WHEN='BEFORE' AND TG_OP='DELETE') THEN
		IF OLD.date_time <= '2024-01-01T00:00:00'::timestamp THEN
			RAISE EXCEPTION 'Дата запрета редактирования: %', '2024-01-01T00:00:00'::timestamp;
		END IF;
	
		--detail tables
		
		--register actions										
		PERFORM ra_materials_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_cement_remove_acts('material_procurement'::doc_types,OLD.id);
		
		--log
		PERFORM doc_log_delete('material_procurement'::doc_types,OLD.id);
		
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.doc_material_procurements_process()
  OWNER TO beton;



-- ******************* update 18/04/2024 12:47:24 ******************
-- Function: public.doc_material_procurements_process()

-- DROP FUNCTION public.doc_material_procurements_process();

CREATE OR REPLACE FUNCTION public.doc_material_procurements_process()
  RETURNS trigger AS
$BODY$
DECLARE
	reg_act ra_materials%ROWTYPE;
	reg_material_facts ra_material_facts%ROWTYPE;
	reg_cement ra_cement%ROWTYPE;
	v_dif_store bool;
	v_production_site_id int;
BEGIN
	IF (TG_WHEN='BEFORE' AND TG_OP='INSERT') THEN
		IF NEW.date_time < '2024-01-01T00:00:00'::timestamp THEN
			RAISE EXCEPTION 'Дата запрета редактирования: %', '2024-01-01T00:00:00'::timestamp;
		END IF;
		
		-- Временно!
		--NEW.production_base_id = 1;
		--Обнудение материал = БЕТОН
		IF NEW.material_id = 1240 THEN
			NEW.quant_net = 0;
			NEW.quant_gross = 0;
		END IF;
		
		--Если это из горного - обнулить по документам
		IF coalesce(NEW.doc_ref_gornyi, '') <> ''
		THEN
			NEW.doc_quant_gross = 0;
			NEW.doc_quant_net = 0;
		END IF;
		
		RETURN NEW;
		
	ELSIF (TG_WHEN='AFTER') AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN					
		IF (TG_OP='INSERT') THEN						
			--log
			PERFORM doc_log_insert('material_procurement'::doc_types,NEW.id,NEW.date_time);
		END IF;

		--register actions ra_materials
		reg_act.date_time		= NEW.date_time;
		reg_act.deb			= true;
		reg_act.doc_type  		= 'material_procurement'::doc_types;
		reg_act.doc_id  		= NEW.id;
		reg_act.production_base_id	= NEW.production_base_id;
		reg_act.material_id		= NEW.material_id;
		reg_act.quant			= NEW.quant_net;
		PERFORM ra_materials_add_act(reg_act);	
		
		SELECT dif_store INTO v_dif_store FROM raw_materials WHERE id=NEW.material_id;
		--По материалам делаем всегда движения, а если есть учет по силосам и есть силос - то и по силосам
		--Если учет по заводам (v_dif_store==TRUE)- то по заводам
		--register actions ra_material_facts
		reg_material_facts.date_time		= NEW.date_time;
		reg_material_facts.deb			= true;
		reg_material_facts.doc_type  		= 'material_procurement'::doc_types;
		reg_material_facts.doc_id  		= NEW.id;
		reg_material_facts.material_id		= NEW.material_id;
		reg_material_facts.production_base_id	= NEW.production_base_id;
		
		IF coalesce(v_dif_store,FALSE) AND coalesce(NEW.store,'')<>'' THEN
			--Определить завод по приходу
			SELECT production_site_id INTO v_production_site_id FROM store_map_to_production_sites WHERE store = NEW.store;
			--RAISE EXCEPTION 'v_production_site_id=%',v_production_site_id;
			IF v_production_site_id IS NULL THEN
				-- no match!
				INSERT INTO store_map_to_production_sites (store) VALUES (NEW.store);
			END IF;
			reg_material_facts.production_site_id = v_production_site_id;
		END IF;
		reg_material_facts.quant		= NEW.quant_net;
		PERFORM ra_material_facts_add_act(reg_material_facts);	
		
		IF coalesce( (SELECT is_cement FROM raw_materials WHERE id = NEW.material_id),FALSE)
		AND NEW.cement_silos_id IS NOT NULL THEN
			--register actions ra_cement
			reg_cement.date_time		= NEW.date_time;
			reg_cement.deb			= true;
			reg_cement.doc_type  		= 'material_procurement'::doc_types;
			reg_cement.doc_id  		= NEW.id;
			reg_cement.cement_silos_id	= NEW.cement_silos_id;
			reg_cement.quant		= NEW.quant_net;
			PERFORM ra_cement_add_act(reg_cement);	
			
		END IF;
			
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',NEW.date_time::date
				)
			)::text
		);
				
		RETURN NEW;
		
	ELSIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		IF NEW.date_time < '2024-01-01T00:00:00'::timestamp THEN
			RAISE EXCEPTION 'Дата запрета редактирования: %', '2024-01-01T00:00:00'::timestamp;
		END IF;
	
		PERFORM ra_materials_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_cement_remove_acts('material_procurement'::doc_types,OLD.id);

		-- Временно!
		IF NEW.production_base_id IS NULL THEN
			NEW.production_base_id = 1;
		END IF;	

		--Если это из горного - обнулить по документам
		IF coalesce(NEW.doc_ref_gornyi, '') <> ''
		AND (coalesce(NEW.doc_quant_gross,0)<>0 OR coalesce(NEW.doc_quant_net,0)<>0)
		THEN
			NEW.doc_quant_gross = 0;
			NEW.doc_quant_net = 0;
		END IF;


		IF NEW.date_time<>OLD.date_time THEN
			PERFORM doc_log_update('material_procurement'::doc_types,NEW.id,NEW.date_time);
		END IF;
						
		RETURN NEW;
		
	ELSIF (TG_WHEN='AFTER' AND TG_OP='DELETE') THEN
	
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',OLD.date_time::date
				)
			)::text
		);
	
		RETURN OLD;
	ELSIF (TG_WHEN='BEFORE' AND TG_OP='DELETE') THEN
		IF OLD.date_time < '2024-01-01T00:00:00'::timestamp THEN
			RAISE EXCEPTION 'Дата запрета редактирования: %', '2024-01-01T00:00:00'::timestamp;
		END IF;
	
		--detail tables
		
		--register actions										
		PERFORM ra_materials_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_cement_remove_acts('material_procurement'::doc_types,OLD.id);
		
		--log
		PERFORM doc_log_delete('material_procurement'::doc_types,OLD.id);
		
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.doc_material_procurements_process()
  OWNER TO beton;



-- ******************* update 18/04/2024 13:08:37 ******************
-- FUNCTION: public.geo_zone_check()

-- DROP FUNCTION IF EXISTS public.geo_zone_check();

CREATE OR REPLACE FUNCTION public.geo_zone_check()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	v_cur_state vehicle_states;
	v_production_base_id int;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	
	v_zone geometry;
	
	v_st_date_time timestamp without time zone;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;
	v_long_route_rest bool;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;

	--get last state
	WITH
	shift AS (
		SELECT
			d_from,
			d_to
		FROM get_shift_bounds(NEW.recieved_dt + age(now(), now() at time zone 'UTC')) AS (d_from timestamp, d_to timestamp)
	)
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE
		st.tracker_id = NEW.car_id
		AND st.date_time BETWEEN (SELECT d_from FROM shift) AND (SELECT d_to FROM shift)
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF v_cur_state = 'busy'::vehicle_states THEN
			--clients zone on shipment
			SELECT				
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id = shipments.order_id
			LEFT JOIN destinations ON destinations.id = orders.destination_id
			WHERE
				shipments.id = v_shipment_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
			
		ELSIF  v_cur_state = 'at_dest'::vehicle_states THEN
			-- client zone from state
			SELECT
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM destinations
			WHERE
				destinations.id = v_destination_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
		ELSE
			--
			-- base zone
			-- ALL possible zones, NOT constant_base_geo_zone_id()
			-- returns one zone only
			SELECT
				b.id,
				b.destination_id,
				destinations.zone
			INTO
				v_production_base_id,
				v_destination_id,
				v_zone
			FROM production_bases AS b
			LEFT JOIN destinations ON destinations.id = b.destination_id
			WHERE
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			LIMIT 1			
			;
					
		END IF;		
		
		--if at least the last point inside zone
		IF v_zone IS NOT NULL THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat
					FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid = 1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count() - 1
					OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					-- v_production_base_id = previous state value
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					-- v_production_base_id = previous state value OR some other logic!!! Куда назначили
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
					--v_production_base_id = Фактическая зона, зона производственной площадки
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id, destination_id, shipment_id, production_base_id)
					VALUES (CURRENT_TIMESTAMP,
						v_schedule_id,
						v_new_state,
						NEW.car_id,
						v_destination_id,
						v_shipment_id,
						v_production_base_id
					);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						--v_cur_state='at_dest' OR 
						WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		/*IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%, v_cur_state=%',v_shipment_id,v_cur_state;
		END IF;*/
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						/*v_point_in_zone = FALSE;
						SELECT
							st_contains(
								st_transform(
									st_buffer(
										st_transform(
											ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
											,3857
										)
										,30
									)
								,4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
						END IF;
						*/
						
						IF v_destination_id IS NOT NULL AND v_client_id IS NOT NULL THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT (client_id,destination_id) DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;						
						--route done
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										--v_cur_state='at_dest' OR 
										WHEN v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		SELECT (length(v_hypothetical_route_rest_t)>7500) INTO v_long_route_rest;
		IF v_long_route_rest THEN
			INSERT INTO route_rests VALUES(NEW.car_id,v_hypothetical_route_rest_t)
			ON CONFLICT (tracker_id) DO UPDATE SET
			route_rest = v_hypothetical_route_rest_t;
		END IF;
		
		--returns vehicles_last_pos struc + route
		BEGIN
			PERFORM pg_notify(
				'Vehicle.position.'||NEW.car_id
				,json_build_object(
					'params',json_build_object(
						'tracker_id',NEW.car_id
						,'lon',NEW.lon
						,'lat',NEW.lat
						,'heading',NEW.heading
						,'speed',NEW.speed
						,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'ns',NEW.ns
						,'ew',NEW.ew
						,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'odometer',NEW.odometer::text
						,'voltage',round(NEW.voltage,0)
						,'route_rest',CASE WHEN v_long_route_rest THEN NULL ELSE v_hypothetical_route_rest_t END
						,'long_route_rest',v_long_route_rest
						,'route_rest_len',v_hypothetical_route_rest_len
					)
				)::text
			);
		EXCEPTION WHEN OTHERS THEN
		END;
	END IF;

	--from beton to konkrid
	/*
	IF current_database() = 'bereg' THEN
		--whose car?
		--konkrid ownerID=286
		IF
			coalesce(
				(SELECT
						(owners.f->'owner'->'keys'->>'id')::int = 286 AS konkrid_owned
				FROM (
					SELECT
							jsonb_array_elements(vehicle_owners->'rows')->'fields' AS f
					FROM vehicles AS v
					WHERE v.tracker_id = NEW.car_id
				) AS owners
				ORDER BY (owners.f->>'dt_from')::timestamp DESC
				LIMIT 1)
			, FALSE
			) THEN
			
			PERFORM pg_notify(
				'CarTracking.konkrid'
				,json_build_object(
					'params',json_build_object(
						'period', NEW.period,
						'car_id', NEW.car_id
					)
				)::text
			);
		END IF;
	END IF;
	*/	
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.geo_zone_check()
    OWNER TO beton;



-- ******************* update 18/04/2024 13:16:26 ******************
-- FUNCTION: public.geo_zone_check()

-- DROP FUNCTION IF EXISTS public.geo_zone_check();

CREATE OR REPLACE FUNCTION public.geo_zone_check()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	v_cur_state vehicle_states;
	v_production_base_id int;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	
	v_zone geometry;
	
	v_st_date_time timestamp without time zone;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;
	v_long_route_rest bool;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;

	--get last state
	WITH
	shift AS (
		SELECT
			d_from,
			d_to
		FROM get_shift_bounds(NEW.recieved_dt + age(now(), now() at time zone 'UTC')) AS (d_from timestamp, d_to timestamp)
	)
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE
		st.tracker_id = NEW.car_id
		AND st.date_time BETWEEN (SELECT d_from FROM shift) AND (SELECT d_to FROM shift)
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF v_cur_state = 'busy'::vehicle_states THEN
			--clients zone on shipment
			SELECT				
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id = shipments.order_id
			LEFT JOIN destinations ON destinations.id = orders.destination_id
			WHERE
				shipments.id = v_shipment_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
			
		ELSIF  v_cur_state = 'at_dest'::vehicle_states THEN
			-- client zone from state
			SELECT
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM destinations
			WHERE
				destinations.id = v_destination_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
		ELSE
			--
			-- base zone
			-- ALL possible zones, NOT constant_base_geo_zone_id()
			-- returns one zone only
			SELECT
				b.id,
				b.destination_id,
				destinations.zone
			INTO
				v_production_base_id,
				v_destination_id,
				v_zone
			FROM production_bases AS b
			LEFT JOIN destinations ON destinations.id = b.destination_id
			WHERE
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			LIMIT 1			
			;
					
		END IF;		
		
		--if at least the last point inside zone
		IF v_zone IS NOT NULL THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat
					FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid = 1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count() - 1
					OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					-- v_production_base_id = previous state value
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					-- v_production_base_id = previous state value OR some other logic!!! Куда назначили
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
					--v_production_base_id = Фактическая зона, зона производственной площадки
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id, destination_id, shipment_id, production_base_id)
					VALUES (CURRENT_TIMESTAMP,
						v_schedule_id,
						v_new_state,
						NEW.car_id,
						v_destination_id,
						v_shipment_id,
						v_production_base_id
					);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						--v_cur_state='at_dest' OR 
						WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		/*IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%, v_cur_state=%',v_shipment_id,v_cur_state;
		END IF;*/
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						/*v_point_in_zone = FALSE;
						SELECT
							st_contains(
								st_transform(
									st_buffer(
										st_transform(
											ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
											,3857
										)
										,30
									)
								,4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
						END IF;
						*/
						
						IF v_destination_id IS NOT NULL AND v_client_id IS NOT NULL THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT (client_id,destination_id) DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;						
						--route done
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										--v_cur_state='at_dest' OR 
										WHEN v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		SELECT (length(v_hypothetical_route_rest_t)>7500) INTO v_long_route_rest;
		IF v_long_route_rest THEN
			INSERT INTO route_rests VALUES(NEW.car_id,v_hypothetical_route_rest_t)
			ON CONFLICT (tracker_id) DO UPDATE SET
			route_rest = v_hypothetical_route_rest_t;
		END IF;
		
		--returns vehicles_last_pos struc + route
		BEGIN
			PERFORM pg_notify(
				'Vehicle.position.'||NEW.car_id
				,json_build_object(
					'params',json_build_object(
						'tracker_id',NEW.car_id
						,'lon',NEW.lon
						,'lat',NEW.lat
						,'heading',NEW.heading
						,'speed',NEW.speed
						,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'ns',NEW.ns
						,'ew',NEW.ew
						,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'odometer',NEW.odometer::text
						,'voltage',round(NEW.voltage,0)
						,'route_rest',CASE WHEN v_long_route_rest THEN NULL ELSE v_hypothetical_route_rest_t END
						,'long_route_rest',v_long_route_rest
						,'route_rest_len',v_hypothetical_route_rest_len
					)
				)::text
			);
		EXCEPTION WHEN OTHERS THEN
		END;
	END IF;

	--from beton to konkrid
	
	IF current_database() = 'bereg' THEN
		--whose car?
		--konkrid ownerID=286
		IF
			coalesce(
				(SELECT
						(owners.f->'owner'->'keys'->>'id')::int = 286 AS konkrid_owned
				FROM (
					SELECT
							jsonb_array_elements(vehicle_owners->'rows')->'fields' AS f
					FROM vehicles AS v
					WHERE v.tracker_id = NEW.car_id
				) AS owners
				ORDER BY (owners.f->>'dt_from')::timestamp DESC
				LIMIT 1)
			, FALSE
			) THEN
			
			PERFORM pg_notify(
				'CarTracking.konkrid'
				,json_build_object(
					'params',json_build_object(
						'period', NEW.period,
						'car_id', NEW.car_id
					)
				)::text
			);
		END IF;
	END IF;
		
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.geo_zone_check()
    OWNER TO beton;



-- ******************* update 18/04/2024 13:43:30 ******************
-- FUNCTION: public.geo_zone_check()

-- DROP FUNCTION IF EXISTS public.geo_zone_check();

CREATE OR REPLACE FUNCTION public.geo_zone_check()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	v_cur_state vehicle_states;
	v_production_base_id int;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	
	v_zone geometry;
	
	v_st_date_time timestamp without time zone;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;
	v_long_route_rest bool;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;

	--get last state
	WITH
	shift AS (
		SELECT
			d_from,
			d_to
		FROM get_shift_bounds(NEW.recieved_dt + age(now(), now() at time zone 'UTC')) AS (d_from timestamp, d_to timestamp)
	)
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE
		st.tracker_id = NEW.car_id
		AND st.date_time BETWEEN (SELECT d_from FROM shift) AND (SELECT d_to FROM shift)
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF v_cur_state = 'busy'::vehicle_states THEN
			--clients zone on shipment
			SELECT				
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id = shipments.order_id
			LEFT JOIN destinations ON destinations.id = orders.destination_id
			WHERE
				shipments.id = v_shipment_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
			
		ELSIF  v_cur_state = 'at_dest'::vehicle_states THEN
			-- client zone from state
			SELECT
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM destinations
			WHERE
				destinations.id = v_destination_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
		ELSE
			--
			-- base zone
			-- ALL possible zones, NOT constant_base_geo_zone_id()
			-- returns one zone only
			SELECT
				b.id,
				b.destination_id,
				destinations.zone
			INTO
				v_production_base_id,
				v_destination_id,
				v_zone
			FROM production_bases AS b
			LEFT JOIN destinations ON destinations.id = b.destination_id
			WHERE
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			LIMIT 1			
			;
					
		END IF;		
		
		--if at least the last point inside zone
		IF v_zone IS NOT NULL THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat
					FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid = 1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count() - 1
					OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					-- v_production_base_id = previous state value
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					-- v_production_base_id = previous state value OR some other logic!!! Куда назначили
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
					--v_production_base_id = Фактическая зона, зона производственной площадки
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id, destination_id, shipment_id, production_base_id)
					VALUES (CURRENT_TIMESTAMP,
						v_schedule_id,
						v_new_state,
						NEW.car_id,
						v_destination_id,
						v_shipment_id,
						v_production_base_id
					);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						--v_cur_state='at_dest' OR 
						WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		/*IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%, v_cur_state=%',v_shipment_id,v_cur_state;
		END IF;*/
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						/*v_point_in_zone = FALSE;
						SELECT
							st_contains(
								st_transform(
									st_buffer(
										st_transform(
											ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
											,3857
										)
										,30
									)
								,4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
						END IF;
						*/
						
						IF v_destination_id IS NOT NULL AND v_client_id IS NOT NULL THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT (client_id,destination_id) DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;						
						--route done
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										--v_cur_state='at_dest' OR 
										WHEN v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		SELECT (length(v_hypothetical_route_rest_t)>7500) INTO v_long_route_rest;
		IF v_long_route_rest THEN
			INSERT INTO route_rests VALUES(NEW.car_id,v_hypothetical_route_rest_t)
			ON CONFLICT (tracker_id) DO UPDATE SET
			route_rest = v_hypothetical_route_rest_t;
		END IF;
		
		--returns vehicles_last_pos struc + route
		BEGIN
			PERFORM pg_notify(
				'Vehicle.position.'||NEW.car_id
				,json_build_object(
					'params',json_build_object(
						'tracker_id',NEW.car_id
						,'lon',NEW.lon
						,'lat',NEW.lat
						,'heading',NEW.heading
						,'speed',NEW.speed
						,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'ns',NEW.ns
						,'ew',NEW.ew
						,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'odometer',NEW.odometer::text
						,'voltage',round(NEW.voltage,0)
						,'route_rest',CASE WHEN v_long_route_rest THEN NULL ELSE v_hypothetical_route_rest_t END
						,'long_route_rest',v_long_route_rest
						,'route_rest_len',v_hypothetical_route_rest_len
					)
				)::text
			);
		EXCEPTION WHEN OTHERS THEN
		END;
	END IF;

	--from beton to konkrid
	
	IF current_database() = 'bereg' THEN
		--whose car?
		--konkrid ownerID=286
		IF
			coalesce(
				(SELECT
						(owners.f->'owner'->'keys'->>'id')::int = 286 AS konkrid_owned
				FROM (
					SELECT
							jsonb_array_elements(vehicle_owners->'rows')->'fields' AS f
					FROM vehicles AS v
					WHERE v.tracker_id = NEW.car_id
				) AS owners
				ORDER BY (owners.f->>'dt_from')::timestamp DESC
				LIMIT 1)
			, FALSE
			) THEN
			
			PERFORM pg_notify(
				'CarTracking.to_konkrid'
				,json_build_object(
					'params',json_build_object(
						'period', NEW.period,
						'car_id', NEW.car_id
					)
				)::text
			);
		END IF;
	END IF;
		
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.geo_zone_check()
    OWNER TO beton;



-- ******************* update 18/04/2024 15:35:01 ******************
-- Function: public.car_tracking_queue_process()

-- DROP FUNCTION public.car_tracking_queue_process();

CREATE OR REPLACE FUNCTION public.car_tracking_queue_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='BEFORE' AND TG_OP='INSERT' ) THEN
		INSERT INTO public.car_tracking
			SELECT * FROM beton.car_tracking WHERE car_id = NEW.car_id AND period = NEW.period;
			
		RETURN NEW;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.car_tracking_queue_process()
  OWNER TO beton;



-- ******************* update 18/04/2024 15:40:10 ******************
-- Function: public.car_tracking_queue_process()

-- DROP FUNCTION public.car_tracking_queue_process();

CREATE OR REPLACE FUNCTION public.car_tracking_queue_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='BEFORE' AND TG_OP='INSERT' ) THEN
		INSERT INTO public.car_tracking
			SELECT * FROM beton.car_tracking WHERE car_id = NEW.car_id AND period = NEW.period;
			
		RETURN NEW;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.car_tracking_queue_process()
  OWNER TO concrete1;



-- ******************* update 18/04/2024 15:40:57 ******************
-- Function: public.car_tracking_queue_process()

-- DROP FUNCTION public.car_tracking_queue_process();

CREATE OR REPLACE FUNCTION public.car_tracking_queue_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='BEFORE' AND TG_OP='INSERT' ) THEN
		INSERT INTO public.car_tracking
			SELECT * FROM beton.car_tracking WHERE car_id = NEW.car_id AND period = NEW.period;
			
		RETURN NEW;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.car_tracking_queue_process()
  OWNER TO concrete1;



-- ******************* update 18/04/2024 15:49:04 ******************
-- Function: public.car_tracking_queue_process()

-- DROP FUNCTION public.car_tracking_queue_process();

CREATE OR REPLACE FUNCTION public.car_tracking_queue_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='BEFORE' AND TG_OP='INSERT' ) THEN
		INSERT INTO public.car_tracking
			SELECT * FROM beton.car_tracking WHERE car_id = NEW.car_id AND period = NEW.period
		ON CONFLICT (car_id, period) DO NOTHING;
			
		RETURN NEW;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.car_tracking_queue_process()
  OWNER TO concrete1;



-- ******************* update 18/04/2024 15:49:19 ******************
-- Function: public.car_tracking_queue_process()

-- DROP FUNCTION public.car_tracking_queue_process();

CREATE OR REPLACE FUNCTION public.car_tracking_queue_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='BEFORE' AND TG_OP='INSERT' ) THEN
		INSERT INTO public.car_tracking
			SELECT * FROM beton.car_tracking WHERE car_id = NEW.car_id AND period = NEW.period
		ON CONFLICT (car_id, period) DO NOTHING;
			
		RETURN NEW;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.car_tracking_queue_process()
  OWNER TO concrete1;



-- ******************* update 18/04/2024 15:50:44 ******************
-- Function: public.car_tracking_queue_process()

-- DROP FUNCTION public.car_tracking_queue_process();

CREATE OR REPLACE FUNCTION public.car_tracking_queue_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='BEFORE' AND TG_OP='INSERT' ) THEN
	RAISE EXCEPTION 'NEW.car_id=%', NEW.car_id;
		INSERT INTO public.car_tracking
			SELECT * FROM beton.car_tracking WHERE car_id = NEW.car_id AND period = NEW.period
		ON CONFLICT (car_id, period) DO NOTHING;
			
		RETURN NEW;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.car_tracking_queue_process()
  OWNER TO concrete1;



-- ******************* update 18/04/2024 15:52:08 ******************
-- Function: public.car_tracking_queue_process()

-- DROP FUNCTION public.car_tracking_queue_process();

CREATE OR REPLACE FUNCTION public.car_tracking_queue_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='BEFORE' AND TG_OP='INSERT' ) THEN
	RAISE EXCEPTION 'NEW.car_id=%', NEW.car_id;
		INSERT INTO public.car_tracking
			SELECT * FROM beton.car_tracking WHERE car_id = NEW.car_id AND period = NEW.period
		ON CONFLICT (car_id, period) DO NOTHING;
			
		RETURN NEW;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.car_tracking_queue_process()
  OWNER TO concrete1;



-- ******************* update 18/04/2024 15:52:38 ******************
-- Trigger: car_tracking_queue_before_insert

DROP TRIGGER car_tracking_queue_before_insert ON public.car_tracking_queue;

CREATE TRIGGER car_tracking_queue_before_insert
    BEFORE INSERT
    ON public.car_tracking_queue
    FOR EACH ROW
    EXECUTE PROCEDURE public.car_tracking_queue_process();



-- ******************* update 18/04/2024 15:52:52 ******************
-- Function: public.car_tracking_queue_process()

-- DROP FUNCTION public.car_tracking_queue_process();

CREATE OR REPLACE FUNCTION public.car_tracking_queue_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='BEFORE' AND TG_OP='INSERT' ) THEN
	RAISE EXCEPTION 'NEW.car_id=%', NEW.car_id;
		INSERT INTO public.car_tracking
			SELECT * FROM beton.car_tracking WHERE car_id = NEW.car_id AND period = NEW.period
		ON CONFLICT (car_id, period) DO NOTHING;
			
		RETURN NEW;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.car_tracking_queue_process()
  OWNER TO concrete1;



-- ******************* update 18/04/2024 15:53:02 ******************
-- Function: public.car_tracking_queue_process()

-- DROP FUNCTION public.car_tracking_queue_process();

CREATE OR REPLACE FUNCTION public.car_tracking_queue_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='BEFORE' AND TG_OP='INSERT' ) THEN
	RAISE EXCEPTION 'NEW.car_id=%', NEW.car_id;
		INSERT INTO public.car_tracking
			SELECT * FROM beton.car_tracking WHERE car_id = NEW.car_id AND period = NEW.period
		ON CONFLICT (car_id, period) DO NOTHING;
			
		RETURN NEW;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.car_tracking_queue_process()
  OWNER TO concrete1;



-- ******************* update 18/04/2024 15:53:18 ******************
-- Function: public.car_tracking_queue_process()

-- DROP FUNCTION public.car_tracking_queue_process();

CREATE OR REPLACE FUNCTION public.car_tracking_queue_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='BEFORE' AND TG_OP='INSERT' ) THEN
	--RAISE EXCEPTION 'NEW.car_id=%', NEW.car_id;
		INSERT INTO public.car_tracking
			SELECT * FROM beton.car_tracking WHERE car_id = NEW.car_id AND period = NEW.period
		ON CONFLICT (car_id, period) DO NOTHING;
			
		RETURN NEW;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.car_tracking_queue_process()
  OWNER TO concrete1;



-- ******************* update 18/04/2024 16:02:49 ******************
-- Trigger: car_tracking_queue_before_insert

DROP TRIGGER car_tracking_queue_before_insert ON public.car_tracking_queue;
/*
CREATE TRIGGER car_tracking_queue_before_insert
    BEFORE INSERT
    ON public.car_tracking_queue
    FOR EACH ROW
    EXECUTE PROCEDURE public.car_tracking_queue_process();
*/


-- ******************* update 18/04/2024 16:03:08 ******************
-- Trigger: car_tracking_queue_before_insert

--DROP TRIGGER car_tracking_queue_before_insert ON public.car_tracking_queue;

CREATE TRIGGER car_tracking_queue_after_insert
    AFTER INSERT
    ON public.car_tracking_queue
    FOR EACH ROW
    EXECUTE PROCEDURE public.car_tracking_queue_process();



-- ******************* update 18/04/2024 16:03:15 ******************
-- Function: public.car_tracking_queue_process()

-- DROP FUNCTION public.car_tracking_queue_process();

CREATE OR REPLACE FUNCTION public.car_tracking_queue_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='INSERT' ) THEN
	--RAISE EXCEPTION 'NEW.car_id=%', NEW.car_id;
		INSERT INTO public.car_tracking
			SELECT * FROM beton.car_tracking WHERE car_id = NEW.car_id AND period = NEW.period
		ON CONFLICT (car_id, period) DO NOTHING;
			
		RETURN NEW;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.car_tracking_queue_process()
  OWNER TO concrete1;



-- ******************* update 18/04/2024 16:09:14 ******************
-- Trigger: car_tracking_queue_before_insert

DROP TRIGGER car_tracking_queue_after_insert ON public.car_tracking_queue;
/*
CREATE TRIGGER car_tracking_queue_after_insert
    AFTER INSERT
    ON public.car_tracking_queue
    FOR EACH ROW
    EXECUTE PROCEDURE public.car_tracking_queue_process();
*/


-- ******************* update 18/04/2024 16:13:31 ******************
-- Trigger: car_tracking_queue_before_insert

--DROP TRIGGER car_tracking_queue_after_insert ON public.car_tracking_queue;

CREATE TRIGGER car_tracking_queue_after_insert
    AFTER INSERT
    ON public.car_tracking_queue
    FOR EACH ROW
    EXECUTE PROCEDURE public.car_tracking_queue_process();



-- ******************* update 18/04/2024 16:14:09 ******************
-- Function: public.car_tracking_queue_process()

-- DROP FUNCTION public.car_tracking_queue_process();

CREATE OR REPLACE FUNCTION public.car_tracking_queue_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='INSERT' ) THEN
	--RAISE EXCEPTION 'NEW.car_id=%', NEW.car_id;
		/*
		INSERT INTO public.car_tracking
			SELECT * FROM beton.car_tracking WHERE car_id = NEW.car_id AND period = NEW.period
		ON CONFLICT (car_id, period) DO NOTHING;
		*/
		PERFORM pg_notify(
			'CarTracking.to_konkrid'
			,json_build_object(
				'params',json_build_object(
					'car_id', NEW.car_id,
					'period', NEW.period
				)
			)::text
		);
		
			
		RETURN NEW;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.car_tracking_queue_process()
  OWNER TO concrete1;



-- ******************* update 18/04/2024 16:14:47 ******************
-- Function: public.car_tracking_queue_process()

-- DROP FUNCTION public.car_tracking_queue_process();

CREATE OR REPLACE FUNCTION public.car_tracking_queue_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='INSERT' ) THEN
	--RAISE EXCEPTION 'NEW.car_id=%', NEW.car_id;
		/*
		INSERT INTO public.car_tracking
			SELECT * FROM beton.car_tracking WHERE car_id = NEW.car_id AND period = NEW.period
		ON CONFLICT (car_id, period) DO NOTHING;
		*/
		PERFORM pg_notify(
			'CarTracking.to_konkrid1'
			,json_build_object(
				'params',json_build_object(
					'car_id', NEW.car_id,
					'period', NEW.period
				)
			)::text
		);
		
			
		RETURN NEW;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.car_tracking_queue_process()
  OWNER TO concrete1;



-- ******************* update 18/04/2024 16:17:26 ******************
-- Function: public.car_tracking_queue_process()

-- DROP FUNCTION public.car_tracking_queue_process();

CREATE OR REPLACE FUNCTION public.car_tracking_queue_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='INSERT' ) THEN
	--RAISE EXCEPTION 'NEW.car_id=%', NEW.car_id;
		/*
		INSERT INTO public.car_tracking
			SELECT * FROM beton.car_tracking WHERE car_id = NEW.car_id AND period = NEW.period
		ON CONFLICT (car_id, period) DO NOTHING;
		*/
		PERFORM pg_notify(
			'CarTracking.to_konkrid'
			,json_build_object(
				'params',json_build_object(
					'car_id', NEW.car_id,
					'period', NEW.period
				)
			)::text
		);
		
			
		RETURN NEW;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.car_tracking_queue_process()
  OWNER TO concrete1;



-- ******************* update 18/04/2024 16:34:36 ******************
-- FUNCTION: public.geo_zone_check()

-- DROP FUNCTION IF EXISTS public.geo_zone_check();

CREATE OR REPLACE FUNCTION public.geo_zone_check()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	v_cur_state vehicle_states;
	v_production_base_id int;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	
	v_zone geometry;
	
	v_st_date_time timestamp without time zone;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;
	v_long_route_rest bool;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;

	--get last state
	WITH
	shift AS (
		SELECT
			d_from,
			d_to
		FROM get_shift_bounds(NEW.recieved_dt + age(now(), now() at time zone 'UTC')) AS (d_from timestamp, d_to timestamp)
	)
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE
		st.tracker_id = NEW.car_id
		AND st.date_time BETWEEN (SELECT d_from FROM shift) AND (SELECT d_to FROM shift)
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF v_cur_state = 'busy'::vehicle_states THEN
			--clients zone on shipment
			SELECT				
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id = shipments.order_id
			LEFT JOIN destinations ON destinations.id = orders.destination_id
			WHERE
				shipments.id = v_shipment_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
			
		ELSIF  v_cur_state = 'at_dest'::vehicle_states THEN
			-- client zone from state
			SELECT
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM destinations
			WHERE
				destinations.id = v_destination_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
		ELSE
			--
			-- base zone
			-- ALL possible zones, NOT constant_base_geo_zone_id()
			-- returns one zone only
			SELECT
				b.id,
				b.destination_id,
				destinations.zone
			INTO
				v_production_base_id,
				v_destination_id,
				v_zone
			FROM production_bases AS b
			LEFT JOIN destinations ON destinations.id = b.destination_id
			WHERE
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			LIMIT 1			
			;
					
		END IF;		
		
		--if at least the last point inside zone
		IF v_zone IS NOT NULL THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat
					FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid = 1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count() - 1
					OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					-- v_production_base_id = previous state value
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					-- v_production_base_id = previous state value OR some other logic!!! Куда назначили
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
					--v_production_base_id = Фактическая зона, зона производственной площадки
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id, destination_id, shipment_id, production_base_id)
					VALUES (CURRENT_TIMESTAMP,
						v_schedule_id,
						v_new_state,
						NEW.car_id,
						v_destination_id,
						v_shipment_id,
						v_production_base_id
					);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						--v_cur_state='at_dest' OR 
						WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		/*IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%, v_cur_state=%',v_shipment_id,v_cur_state;
		END IF;*/
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						/*v_point_in_zone = FALSE;
						SELECT
							st_contains(
								st_transform(
									st_buffer(
										st_transform(
											ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
											,3857
										)
										,30
									)
								,4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
						END IF;
						*/
						
						IF v_destination_id IS NOT NULL AND v_client_id IS NOT NULL THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT (client_id,destination_id) DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;						
						--route done
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										--v_cur_state='at_dest' OR 
										WHEN v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		SELECT (length(v_hypothetical_route_rest_t)>7500) INTO v_long_route_rest;
		IF v_long_route_rest THEN
			INSERT INTO route_rests VALUES(NEW.car_id,v_hypothetical_route_rest_t)
			ON CONFLICT (tracker_id) DO UPDATE SET
			route_rest = v_hypothetical_route_rest_t;
		END IF;
		
		--returns vehicles_last_pos struc + route
		BEGIN
			PERFORM pg_notify(
				'Vehicle.position.'||NEW.car_id
				,json_build_object(
					'params',json_build_object(
						'tracker_id',NEW.car_id
						,'lon',NEW.lon
						,'lat',NEW.lat
						,'heading',NEW.heading
						,'speed',NEW.speed
						,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'ns',NEW.ns
						,'ew',NEW.ew
						,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'odometer',NEW.odometer::text
						,'voltage',round(NEW.voltage,0)
						,'route_rest',CASE WHEN v_long_route_rest THEN NULL ELSE v_hypothetical_route_rest_t END
						,'long_route_rest',v_long_route_rest
						,'route_rest_len',v_hypothetical_route_rest_len
					)
				)::text
			);
		EXCEPTION WHEN OTHERS THEN
		END;
	END IF;

	--from beton to konkrid
	
	IF current_database() = 'bereg' THEN
		--whose car?
		--konkrid ownerID=286
		IF
			coalesce(
				(SELECT
						(owners.f->'owner'->'keys'->>'id')::int = 286 AS konkrid_owned
				FROM (
					SELECT
							jsonb_array_elements(vehicle_owners->'rows')->'fields' AS f
					FROM vehicles AS v
					WHERE v.tracker_id = NEW.car_id
				) AS owners
				ORDER BY (owners.f->>'dt_from')::timestamp DESC
				LIMIT 1)
			, FALSE
			) THEN
			
			INSERT INTO konkrid.car_tracking_queue (car_id, period) VALUES (NEW.car_id, NEW.period);
			/*
			PERFORM pg_notify(
				'CarTracking.to_konkrid'
				,json_build_object(
					'params',json_build_object(
						'car_id', NEW.car_id,
						'period', NEW.period
					)
				)::text
			);
			*/
		END IF;
	END IF;
		
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.geo_zone_check()
    OWNER TO concrete1;



-- ******************* update 18/04/2024 16:34:45 ******************
-- FUNCTION: public.geo_zone_check()

-- DROP FUNCTION IF EXISTS public.geo_zone_check();

CREATE OR REPLACE FUNCTION public.geo_zone_check()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	v_cur_state vehicle_states;
	v_production_base_id int;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	
	v_zone geometry;
	
	v_st_date_time timestamp without time zone;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;
	v_long_route_rest bool;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;

	--get last state
	WITH
	shift AS (
		SELECT
			d_from,
			d_to
		FROM get_shift_bounds(NEW.recieved_dt + age(now(), now() at time zone 'UTC')) AS (d_from timestamp, d_to timestamp)
	)
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE
		st.tracker_id = NEW.car_id
		AND st.date_time BETWEEN (SELECT d_from FROM shift) AND (SELECT d_to FROM shift)
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF v_cur_state = 'busy'::vehicle_states THEN
			--clients zone on shipment
			SELECT				
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id = shipments.order_id
			LEFT JOIN destinations ON destinations.id = orders.destination_id
			WHERE
				shipments.id = v_shipment_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
			
		ELSIF  v_cur_state = 'at_dest'::vehicle_states THEN
			-- client zone from state
			SELECT
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM destinations
			WHERE
				destinations.id = v_destination_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
		ELSE
			--
			-- base zone
			-- ALL possible zones, NOT constant_base_geo_zone_id()
			-- returns one zone only
			SELECT
				b.id,
				b.destination_id,
				destinations.zone
			INTO
				v_production_base_id,
				v_destination_id,
				v_zone
			FROM production_bases AS b
			LEFT JOIN destinations ON destinations.id = b.destination_id
			WHERE
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			LIMIT 1			
			;
					
		END IF;		
		
		--if at least the last point inside zone
		IF v_zone IS NOT NULL THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat
					FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid = 1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count() - 1
					OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					-- v_production_base_id = previous state value
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					-- v_production_base_id = previous state value OR some other logic!!! Куда назначили
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
					--v_production_base_id = Фактическая зона, зона производственной площадки
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id, destination_id, shipment_id, production_base_id)
					VALUES (CURRENT_TIMESTAMP,
						v_schedule_id,
						v_new_state,
						NEW.car_id,
						v_destination_id,
						v_shipment_id,
						v_production_base_id
					);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						--v_cur_state='at_dest' OR 
						WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		/*IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%, v_cur_state=%',v_shipment_id,v_cur_state;
		END IF;*/
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						/*v_point_in_zone = FALSE;
						SELECT
							st_contains(
								st_transform(
									st_buffer(
										st_transform(
											ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
											,3857
										)
										,30
									)
								,4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
						END IF;
						*/
						
						IF v_destination_id IS NOT NULL AND v_client_id IS NOT NULL THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT (client_id,destination_id) DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;						
						--route done
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										--v_cur_state='at_dest' OR 
										WHEN v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		SELECT (length(v_hypothetical_route_rest_t)>7500) INTO v_long_route_rest;
		IF v_long_route_rest THEN
			INSERT INTO route_rests VALUES(NEW.car_id,v_hypothetical_route_rest_t)
			ON CONFLICT (tracker_id) DO UPDATE SET
			route_rest = v_hypothetical_route_rest_t;
		END IF;
		
		--returns vehicles_last_pos struc + route
		BEGIN
			PERFORM pg_notify(
				'Vehicle.position.'||NEW.car_id
				,json_build_object(
					'params',json_build_object(
						'tracker_id',NEW.car_id
						,'lon',NEW.lon
						,'lat',NEW.lat
						,'heading',NEW.heading
						,'speed',NEW.speed
						,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'ns',NEW.ns
						,'ew',NEW.ew
						,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'odometer',NEW.odometer::text
						,'voltage',round(NEW.voltage,0)
						,'route_rest',CASE WHEN v_long_route_rest THEN NULL ELSE v_hypothetical_route_rest_t END
						,'long_route_rest',v_long_route_rest
						,'route_rest_len',v_hypothetical_route_rest_len
					)
				)::text
			);
		EXCEPTION WHEN OTHERS THEN
		END;
	END IF;

	--from beton to konkrid
	
	IF current_database() = 'bereg' THEN
		--whose car?
		--konkrid ownerID=286
		IF
			coalesce(
				(SELECT
						(owners.f->'owner'->'keys'->>'id')::int = 286 AS konkrid_owned
				FROM (
					SELECT
							jsonb_array_elements(vehicle_owners->'rows')->'fields' AS f
					FROM vehicles AS v
					WHERE v.tracker_id = NEW.car_id
				) AS owners
				ORDER BY (owners.f->>'dt_from')::timestamp DESC
				LIMIT 1)
			, FALSE
			) THEN
			
			--INSERT INTO konkrid.car_tracking_queue (car_id, period) VALUES (NEW.car_id, NEW.period);
			/*
			PERFORM pg_notify(
				'CarTracking.to_konkrid'
				,json_build_object(
					'params',json_build_object(
						'car_id', NEW.car_id,
						'period', NEW.period
					)
				)::text
			);
			*/
		END IF;
	END IF;
		
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.geo_zone_check()
    OWNER TO concrete1;



-- ******************* update 18/04/2024 16:45:12 ******************
-- FUNCTION: public.geo_zone_check()

-- DROP FUNCTION IF EXISTS public.geo_zone_check();

CREATE OR REPLACE FUNCTION public.geo_zone_check()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	v_cur_state vehicle_states;
	v_production_base_id int;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	
	v_zone geometry;
	
	v_st_date_time timestamp without time zone;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;
	v_long_route_rest bool;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;

	--get last state
	WITH
	shift AS (
		SELECT
			d_from,
			d_to
		FROM get_shift_bounds(NEW.recieved_dt + age(now(), now() at time zone 'UTC')) AS (d_from timestamp, d_to timestamp)
	)
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE
		st.tracker_id = NEW.car_id
		AND st.date_time BETWEEN (SELECT d_from FROM shift) AND (SELECT d_to FROM shift)
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF v_cur_state = 'busy'::vehicle_states THEN
			--clients zone on shipment
			SELECT				
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id = shipments.order_id
			LEFT JOIN destinations ON destinations.id = orders.destination_id
			WHERE
				shipments.id = v_shipment_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
			
		ELSIF  v_cur_state = 'at_dest'::vehicle_states THEN
			-- client zone from state
			SELECT
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM destinations
			WHERE
				destinations.id = v_destination_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
		ELSE
			--
			-- base zone
			-- ALL possible zones, NOT constant_base_geo_zone_id()
			-- returns one zone only
			SELECT
				b.id,
				b.destination_id,
				destinations.zone
			INTO
				v_production_base_id,
				v_destination_id,
				v_zone
			FROM production_bases AS b
			LEFT JOIN destinations ON destinations.id = b.destination_id
			WHERE
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			LIMIT 1			
			;
					
		END IF;		
		
		--if at least the last point inside zone
		IF v_zone IS NOT NULL THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat
					FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid = 1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count() - 1
					OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					-- v_production_base_id = previous state value
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					-- v_production_base_id = previous state value OR some other logic!!! Куда назначили
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
					--v_production_base_id = Фактическая зона, зона производственной площадки
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id, destination_id, shipment_id, production_base_id)
					VALUES (CURRENT_TIMESTAMP,
						v_schedule_id,
						v_new_state,
						NEW.car_id,
						v_destination_id,
						v_shipment_id,
						v_production_base_id
					);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						--v_cur_state='at_dest' OR 
						WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		/*IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%, v_cur_state=%',v_shipment_id,v_cur_state;
		END IF;*/
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						/*v_point_in_zone = FALSE;
						SELECT
							st_contains(
								st_transform(
									st_buffer(
										st_transform(
											ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
											,3857
										)
										,30
									)
								,4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
						END IF;
						*/
						
						IF v_destination_id IS NOT NULL AND v_client_id IS NOT NULL THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT (client_id,destination_id) DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;						
						--route done
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										--v_cur_state='at_dest' OR 
										WHEN v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		SELECT (length(v_hypothetical_route_rest_t)>7500) INTO v_long_route_rest;
		IF v_long_route_rest THEN
			INSERT INTO route_rests VALUES(NEW.car_id,v_hypothetical_route_rest_t)
			ON CONFLICT (tracker_id) DO UPDATE SET
			route_rest = v_hypothetical_route_rest_t;
		END IF;
		
		--returns vehicles_last_pos struc + route
		BEGIN
			PERFORM pg_notify(
				'Vehicle.position.'||NEW.car_id
				,json_build_object(
					'params',json_build_object(
						'tracker_id',NEW.car_id
						,'lon',NEW.lon
						,'lat',NEW.lat
						,'heading',NEW.heading
						,'speed',NEW.speed
						,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'ns',NEW.ns
						,'ew',NEW.ew
						,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'odometer',NEW.odometer::text
						,'voltage',round(NEW.voltage,0)
						,'route_rest',CASE WHEN v_long_route_rest THEN NULL ELSE v_hypothetical_route_rest_t END
						,'long_route_rest',v_long_route_rest
						,'route_rest_len',v_hypothetical_route_rest_len
					)
				)::text
			);
		EXCEPTION WHEN OTHERS THEN
		END;
	END IF;

	--from beton to konkrid
	
	IF current_database() = 'bereg' THEN
		--whose car?
		--konkrid ownerID=286
		IF
			coalesce(
				(SELECT
						(owners.f->'owner'->'keys'->>'id')::int = 286 AS konkrid_owned
				FROM (
					SELECT
							jsonb_array_elements(vehicle_owners->'rows')->'fields' AS f
					FROM vehicles AS v
					WHERE v.tracker_id = NEW.car_id
				) AS owners
				ORDER BY (owners.f->>'dt_from')::timestamp DESC
				LIMIT 1)
			, FALSE
			) THEN
			
			INSERT INTO konkrid.car_tracking_queue (car_id, period) VALUES (NEW.car_id, NEW.period);
			/*
			PERFORM pg_notify(
				'CarTracking.to_konkrid'
				,json_build_object(
					'params',json_build_object(
						'car_id', NEW.car_id,
						'period', NEW.period
					)
				)::text
			);
			*/
		END IF;
	END IF;
		
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.geo_zone_check()
    OWNER TO concrete1;



-- ******************* update 18/04/2024 16:45:35 ******************
-- Function: public.car_tracking_queue_process()

-- DROP FUNCTION public.car_tracking_queue_process();

CREATE OR REPLACE FUNCTION public.car_tracking_queue_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='INSERT' ) THEN
	--RAISE EXCEPTION 'NEW.car_id=%', NEW.car_id;
		/*
		INSERT INTO public.car_tracking
			SELECT * FROM beton.car_tracking WHERE car_id = NEW.car_id AND period = NEW.period
		ON CONFLICT (car_id, period) DO NOTHING;
		*/
		PERFORM pg_notify(
			'CarTracking.from_beton'
			,json_build_object(
				'params',json_build_object(
					'car_id', NEW.car_id,
					'period', NEW.period
				)
			)::text
		);
		
			
		RETURN NEW;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.car_tracking_queue_process()
  OWNER TO concrete1;



-- ******************* update 18/04/2024 16:50:12 ******************
-- Function: public.car_tracking_queue_process()

-- DROP FUNCTION public.car_tracking_queue_process();

CREATE OR REPLACE FUNCTION public.car_tracking_queue_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='INSERT' ) THEN
		IF current_database() = 'concrete1' THEN
			PERFORM pg_notify(
				'CarTracking.from_beton'
				,json_build_object(
					'params',json_build_object(
						'car_id', NEW.car_id,
						'period', NEW.period
					)
				)::text
			);
		END IF;
			
		RETURN NEW;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.car_tracking_queue_process()
  OWNER TO concrete1;



-- ******************* update 18/04/2024 17:02:08 ******************
CREATE UNLOGGED TABLE bereg_to_konkrid
(
	event_id text,
	params text
);

ALTER TABLE bereg_to_konkrid OWNER TO concrete1;


-- ******************* update 18/04/2024 17:05:03 ******************
/*
CREATE UNLOGGED TABLE bereg_to_konkrid
(
	event_id text,
	params text
);

ALTER TABLE bereg_to_konkrid OWNER TO concrete1;

*/

--DROP TRIGGER car_tracking_queue_after_insert ON public.car_tracking_queue;
/*
CREATE TRIGGER car_tracking_queue_after_insert
    AFTER INSERT
    ON public.car_tracking_queue
    FOR EACH ROW
    EXECUTE PROCEDURE public.car_tracking_queue_process();
*/

CREATE OR REPLACE FUNCTION public.bereg_to_konkrid_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='INSERT' ) THEN
		IF current_database() = 'concrete1' THEN
			PERFORM pg_notify(
				NEW.event_id,
				NEW.params
			);
		END IF;
			
		RETURN NEW;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.bereg_to_konkrid_process()
  OWNER TO concrete1;



-- ******************* update 18/04/2024 17:08:14 ******************
/*
CREATE UNLOGGED TABLE bereg_to_konkrid
(
	event_id text,
	params text
);

ALTER TABLE bereg_to_konkrid OWNER TO concrete1;

*/

--DROP TRIGGER car_tracking_queue_after_insert ON public.car_tracking_queue;

CREATE TRIGGER bereg_to_konkrid_after_insert
    AFTER INSERT
    ON public.bereg_to_konkrid
    FOR EACH ROW
    EXECUTE PROCEDURE public.bereg_to_konkrid_process();


/*
CREATE OR REPLACE FUNCTION public.bereg_to_konkrid_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='INSERT' ) THEN
		IF current_database() = 'concrete1' THEN
			PERFORM pg_notify(
				NEW.event_id,
				NEW.params
			);
		END IF;
			
		RETURN NEW;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.bereg_to_konkrid_process()
  OWNER TO concrete1;
*/


-- ******************* update 18/04/2024 17:12:55 ******************
/*
CREATE UNLOGGED TABLE bereg_to_konkrid
(
	event_id text,
	params text
);

ALTER TABLE bereg_to_konkrid OWNER TO concrete1;

*/

--DROP TRIGGER car_tracking_queue_after_insert ON public.car_tracking_queue;
/*
CREATE TRIGGER bereg_to_konkrid_after_insert
    AFTER INSERT
    ON public.bereg_to_konkrid
    FOR EACH ROW
    EXECUTE PROCEDURE public.bereg_to_konkrid_process();
*/


CREATE OR REPLACE FUNCTION public.bereg_to_konkrid_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='INSERT' ) THEN
		--IF current_database() = 'concrete1' THEN
			PERFORM pg_notify(
				NEW.event_id,
				NEW.params
			);
		--END IF;
			
		RETURN NEW;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.bereg_to_konkrid_process()
  OWNER TO concrete1;



-- ******************* update 18/04/2024 17:19:06 ******************
-- FUNCTION: public.geo_zone_check()

-- DROP FUNCTION IF EXISTS public.geo_zone_check();

CREATE OR REPLACE FUNCTION public.geo_zone_check()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	v_cur_state vehicle_states;
	v_production_base_id int;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	
	v_zone geometry;
	
	v_st_date_time timestamp without time zone;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;
	v_long_route_rest bool;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;

	--get last state
	WITH
	shift AS (
		SELECT
			d_from,
			d_to
		FROM get_shift_bounds(NEW.recieved_dt + age(now(), now() at time zone 'UTC')) AS (d_from timestamp, d_to timestamp)
	)
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE
		st.tracker_id = NEW.car_id
		AND st.date_time BETWEEN (SELECT d_from FROM shift) AND (SELECT d_to FROM shift)
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF v_cur_state = 'busy'::vehicle_states THEN
			--clients zone on shipment
			SELECT				
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id = shipments.order_id
			LEFT JOIN destinations ON destinations.id = orders.destination_id
			WHERE
				shipments.id = v_shipment_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
			
		ELSIF  v_cur_state = 'at_dest'::vehicle_states THEN
			-- client zone from state
			SELECT
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM destinations
			WHERE
				destinations.id = v_destination_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
		ELSE
			--
			-- base zone
			-- ALL possible zones, NOT constant_base_geo_zone_id()
			-- returns one zone only
			SELECT
				b.id,
				b.destination_id,
				destinations.zone
			INTO
				v_production_base_id,
				v_destination_id,
				v_zone
			FROM production_bases AS b
			LEFT JOIN destinations ON destinations.id = b.destination_id
			WHERE
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			LIMIT 1			
			;
					
		END IF;		
		
		--if at least the last point inside zone
		IF v_zone IS NOT NULL THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat
					FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid = 1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count() - 1
					OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					-- v_production_base_id = previous state value
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					-- v_production_base_id = previous state value OR some other logic!!! Куда назначили
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
					--v_production_base_id = Фактическая зона, зона производственной площадки
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id, destination_id, shipment_id, production_base_id)
					VALUES (CURRENT_TIMESTAMP,
						v_schedule_id,
						v_new_state,
						NEW.car_id,
						v_destination_id,
						v_shipment_id,
						v_production_base_id
					);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						--v_cur_state='at_dest' OR 
						WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		/*IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%, v_cur_state=%',v_shipment_id,v_cur_state;
		END IF;*/
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						/*v_point_in_zone = FALSE;
						SELECT
							st_contains(
								st_transform(
									st_buffer(
										st_transform(
											ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
											,3857
										)
										,30
									)
								,4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
						END IF;
						*/
						
						IF v_destination_id IS NOT NULL AND v_client_id IS NOT NULL THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT (client_id,destination_id) DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;						
						--route done
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										--v_cur_state='at_dest' OR 
										WHEN v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		SELECT (length(v_hypothetical_route_rest_t)>7500) INTO v_long_route_rest;
		IF v_long_route_rest THEN
			INSERT INTO route_rests VALUES(NEW.car_id,v_hypothetical_route_rest_t)
			ON CONFLICT (tracker_id) DO UPDATE SET
			route_rest = v_hypothetical_route_rest_t;
		END IF;
		
		--returns vehicles_last_pos struc + route
		BEGIN
			PERFORM pg_notify(
				'Vehicle.position.'||NEW.car_id
				,json_build_object(
					'params',json_build_object(
						'tracker_id',NEW.car_id
						,'lon',NEW.lon
						,'lat',NEW.lat
						,'heading',NEW.heading
						,'speed',NEW.speed
						,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'ns',NEW.ns
						,'ew',NEW.ew
						,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'odometer',NEW.odometer::text
						,'voltage',round(NEW.voltage,0)
						,'route_rest',CASE WHEN v_long_route_rest THEN NULL ELSE v_hypothetical_route_rest_t END
						,'long_route_rest',v_long_route_rest
						,'route_rest_len',v_hypothetical_route_rest_len
					)
				)::text
			);
		EXCEPTION WHEN OTHERS THEN
		END;
	END IF;

	--from beton to konkrid
	
	IF current_database() = 'bereg' THEN
		--whose car?
		--konkrid ownerID=286
		IF
			coalesce(
				(SELECT
						(owners.f->'owner'->'keys'->>'id')::int = 286 AS konkrid_owned
				FROM (
					SELECT
							jsonb_array_elements(vehicle_owners->'rows')->'fields' AS f
					FROM vehicles AS v
					WHERE v.tracker_id = NEW.car_id
				) AS owners
				ORDER BY (owners.f->>'dt_from')::timestamp DESC
				LIMIT 1)
			, FALSE
			) THEN
			
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('CarTracking.to_konkrid',
					json_build_object('params',
						json_build_object('car_id', NEW.car_id, 'period', NEW.period)
					)::text
			);
		END IF;
	END IF;
		
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.geo_zone_check()
    OWNER TO concrete1;



-- ******************* update 18/04/2024 17:19:47 ******************
-- Function: public.car_tracking_queue_process()

 DROP FUNCTION public.car_tracking_queue_process() CASCADE;
/*
CREATE OR REPLACE FUNCTION public.car_tracking_queue_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='INSERT' ) THEN
		IF current_database() = 'concrete1' THEN
			PERFORM pg_notify(
				'CarTracking.from_beton'
				,json_build_object(
					'params',json_build_object(
						'car_id', NEW.car_id,
						'period', NEW.period
					)
				)::text
			);
		END IF;
			
		RETURN NEW;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.car_tracking_queue_process()
  OWNER TO concrete1;
*/


-- ******************* update 18/04/2024 17:20:10 ******************
-- Function: public.car_tracking_queue_process()

DROP TABLE car_tracking_queue;
-- DROP FUNCTION public.car_tracking_queue_process() CASCADE;
/*
CREATE OR REPLACE FUNCTION public.car_tracking_queue_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='INSERT' ) THEN
		IF current_database() = 'concrete1' THEN
			PERFORM pg_notify(
				'CarTracking.from_beton'
				,json_build_object(
					'params',json_build_object(
						'car_id', NEW.car_id,
						'period', NEW.period
					)
				)::text
			);
		END IF;
			
		RETURN NEW;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.car_tracking_queue_process()
  OWNER TO concrete1;
*/


-- ******************* update 18/04/2024 17:26:49 ******************
-- FUNCTION: public.order_after_process()

-- DROP FUNCTION IF EXISTS public.order_after_process();

CREATE OR REPLACE FUNCTION public.order_after_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

DECLARE
	v_f boolean;
BEGIN	
	IF TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
		IF TG_OP = 'INSERT' OR (TG_OP='UPDATE'
			AND NEW.phone_cel<>''
			AND (
				(NEW.client_id<>OLD.client_id)
				OR (NEW.phone_cel<>OLD.phone_cel)
			)
			)
		THEN		
			SELECT
				TRUE
			INTO v_f FROM client_tels
			WHERE client_id = NEW.client_id
				AND tel=NEW.phone_cel;
			
			IF v_f IS NULL THEN
				
				BEGIN
					INSERT INTO client_tels
						(client_id,tel,name)
					VALUES (NEW.client_id,NEW.phone_cel,NEW.descr);
				EXCEPTION WHEN OTHERS THEN
				END;
			END IF;
			
		END IF;
		
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='DELETE' THEN
		RETURN OLD;
	END IF;	
	
END;
$BODY$;

ALTER FUNCTION public.order_after_process()
    OWNER TO concrete1;



-- ******************* update 18/04/2024 17:26:55 ******************
-- Trigger: order_trigger_after

 DROP TRIGGER IF EXISTS order_trigger_after ON public.orders;

CREATE OR REPLACE TRIGGER order_trigger_after
    AFTER INSERT OR UPDATE OR DELETE
    ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION public.order_after_process();


-- ******************* update 18/04/2024 17:27:19 ******************
-- FUNCTION: public.order_after_process()

-- DROP FUNCTION IF EXISTS public.order_after_process();

CREATE OR REPLACE FUNCTION public.order_after_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

DECLARE
	v_f boolean;
BEGIN	
	IF TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
		IF TG_OP = 'INSERT' OR (TG_OP='UPDATE'
			AND NEW.phone_cel<>''
			AND (
				(NEW.client_id<>OLD.client_id)
				OR (NEW.phone_cel<>OLD.phone_cel)
			)
			)
		THEN		
			SELECT
				TRUE
			INTO v_f FROM client_tels
			WHERE client_id = NEW.client_id
				AND tel=NEW.phone_cel;
			
			IF v_f IS NULL THEN
				
				BEGIN
					INSERT INTO client_tels
						(client_id,tel,name)
					VALUES (NEW.client_id,NEW.phone_cel,NEW.descr);
				EXCEPTION WHEN OTHERS THEN
				END;
			END IF;
			
		END IF;
		
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='DELETE' THEN
		RETURN OLD;
	END IF;	
	
END;
$BODY$;

ALTER FUNCTION public.order_after_process()
    OWNER TO beton;



-- ******************* update 18/04/2024 17:27:26 ******************
-- Trigger: order_trigger_after

 DROP TRIGGER IF EXISTS order_trigger_after ON public.orders;

CREATE OR REPLACE TRIGGER order_trigger_after
    AFTER INSERT OR UPDATE OR DELETE
    ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION public.order_after_process();


-- ******************* update 18/04/2024 17:32:00 ******************

	-- ********** constant value table  konkrid_client *************
	CREATE TABLE IF NOT EXISTS const_konkrid_client
	(name text, descr text, val json,
		val_type text,ctrl_class text,ctrl_options json, view_class text,view_options json);
	ALTER TABLE const_konkrid_client OWNER TO beton;
	INSERT INTO const_konkrid_client (name,descr,val,val_type,ctrl_class,ctrl_options,view_class,view_options) VALUES (
		'Конкрид'
		,'Конкрид'
		,NULL
		,'JSON'
		,NULL
		,NULL
		,NULL
		,NULL
	);
		--constant get value
	CREATE OR REPLACE FUNCTION const_konkrid_client_val()
	RETURNS json AS
	$BODY$
		SELECT val::json AS val FROM const_konkrid_client LIMIT 1;
	$BODY$
	LANGUAGE sql STABLE COST 100;
	ALTER FUNCTION const_konkrid_client_val() OWNER TO beton;
	--constant set value
	CREATE OR REPLACE FUNCTION const_konkrid_client_set_val(JSON)
	RETURNS void AS
	$BODY$
		UPDATE const_konkrid_client SET val=$1;
	$BODY$
	LANGUAGE sql VOLATILE COST 100;
	ALTER FUNCTION const_konkrid_client_set_val(JSON) OWNER TO beton;
	--edit view: all keys and descr
	CREATE OR REPLACE VIEW const_konkrid_client_view AS
	SELECT
		'konkrid_client'::text AS id
		,t.name
		,t.descr
	,
	t.val::text AS val
	,t.val_type::text AS val_type
	,t.ctrl_class::text
	,t.ctrl_options::json
	,t.view_class::text
	,t.view_options::json
	FROM const_konkrid_client AS t
	;
	ALTER VIEW const_konkrid_client_view OWNER TO beton;
	CREATE OR REPLACE VIEW constants_list_view AS
	SELECT *
	FROM const_doc_per_page_count_view
	UNION ALL
	SELECT *
	FROM const_grid_refresh_interval_view
	UNION ALL
	SELECT *
	FROM const_order_grid_refresh_interval_view
	UNION ALL
	SELECT *
	FROM const_backup_vehicles_feature_view
	UNION ALL
	SELECT *
	FROM const_base_geo_zone_id_view
	UNION ALL
	SELECT *
	FROM const_base_geo_zone_view
	UNION ALL
	SELECT *
	FROM const_chart_step_min_view
	UNION ALL
	SELECT *
	FROM const_day_shift_length_view
	UNION ALL
	SELECT *
	FROM const_days_allowed_with_broken_tracker_view
	UNION ALL
	SELECT *
	FROM const_def_order_unload_speed_view
	UNION ALL
	SELECT *
	FROM const_demurrage_coast_per_hour_view
	UNION ALL
	SELECT *
	FROM const_first_shift_start_time_view
	UNION ALL
	SELECT *
	FROM const_geo_zone_check_points_count_view
	UNION ALL
	SELECT *
	FROM const_map_default_lat_view
	UNION ALL
	SELECT *
	FROM const_map_default_lon_view
	UNION ALL
	SELECT *
	FROM const_max_hour_load_view
	UNION ALL
	SELECT *
	FROM const_max_vehicle_at_work_view
	UNION ALL
	SELECT *
	FROM const_min_demurrage_time_view
	UNION ALL
	SELECT *
	FROM const_min_quant_for_ship_cost_view
	UNION ALL
	SELECT *
	FROM const_no_tracker_signal_warn_interval_view
	UNION ALL
	SELECT *
	FROM const_ord_mark_if_no_ship_time_view
	UNION ALL
	SELECT *
	FROM const_order_auto_place_tolerance_view
	UNION ALL
	SELECT *
	FROM const_order_step_min_view
	UNION ALL
	SELECT *
	FROM const_own_vehicles_feature_view
	UNION ALL
	SELECT *
	FROM const_raw_mater_plcons_rep_def_days_view
	UNION ALL
	SELECT *
	FROM const_self_ship_dest_id_view
	UNION ALL
	SELECT *
	FROM const_self_ship_dest_view
	UNION ALL
	SELECT *
	FROM const_shift_for_orders_length_time_view
	UNION ALL
	SELECT *
	FROM const_shift_length_time_view
	UNION ALL
	SELECT *
	FROM const_ship_coast_for_self_ship_destination_view
	UNION ALL
	SELECT *
	FROM const_speed_change_for_order_autolocate_view
	UNION ALL
	SELECT *
	FROM const_vehicle_unload_time_view
	UNION ALL
	SELECT *
	FROM const_avg_mat_cons_dev_day_count_view
	UNION ALL
	SELECT *
	FROM const_days_for_plan_procur_view
	UNION ALL
	SELECT *
	FROM const_lab_min_sample_count_view
	UNION ALL
	SELECT *
	FROM const_lab_days_for_avg_view
	UNION ALL
	SELECT *
	FROM const_city_ext_view
	UNION ALL
	SELECT *
	FROM const_def_lang_view
	UNION ALL
	SELECT *
	FROM const_efficiency_warn_k_view
	UNION ALL
	SELECT *
	FROM const_zone_violation_alarm_interval_view
	UNION ALL
	SELECT *
	FROM const_weather_update_interval_sec_view
	UNION ALL
	SELECT *
	FROM const_call_history_count_view
	UNION ALL
	SELECT *
	FROM const_water_ship_cost_view
	UNION ALL
	SELECT *
	FROM const_vehicle_owner_accord_from_day_view
	UNION ALL
	SELECT *
	FROM const_vehicle_owner_accord_to_day_view
	UNION ALL
	SELECT *
	FROM const_show_time_for_shipped_vehicles_view
	UNION ALL
	SELECT *
	FROM const_tracker_malfunction_tel_list_view
	UNION ALL
	SELECT *
	FROM const_low_efficiency_tel_list_view
	UNION ALL
	SELECT *
	FROM const_material_closed_balance_date_view
	UNION ALL
	SELECT *
	FROM const_cement_material_view
	UNION ALL
	SELECT *
	FROM const_deviation_for_reroute_view
	UNION ALL
	SELECT *
	FROM const_arnavi_telemat_server_view
	UNION ALL
	SELECT *
	FROM const_chart_step_quant_view
	UNION ALL
	SELECT *
	FROM const_chart_max_quant_view
	UNION ALL
	SELECT *
	FROM const_konkrid_client_view
	ORDER BY name;
	ALTER VIEW constants_list_view OWNER TO beton;
	


-- ******************* update 18/04/2024 17:35:45 ******************
-- FUNCTION: public.order_after_process()

-- DROP FUNCTION IF EXISTS public.order_after_process();

CREATE OR REPLACE FUNCTION public.order_after_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

DECLARE
	v_f boolean;
BEGIN	
	IF TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
		IF TG_OP = 'INSERT' OR (TG_OP='UPDATE'
			AND NEW.phone_cel<>''
			AND (
				(NEW.client_id<>OLD.client_id)
				OR (NEW.phone_cel<>OLD.phone_cel)
			)
			)
		THEN		
			SELECT
				TRUE
			INTO v_f FROM client_tels
			WHERE client_id = NEW.client_id
				AND tel=NEW.phone_cel;
			
			IF v_f IS NULL THEN
				
				BEGIN
					INSERT INTO client_tels
						(client_id,tel,name)
					VALUES (NEW.client_id,NEW.phone_cel,NEW.descr);
				EXCEPTION WHEN OTHERS THEN
				END;
			END IF;
			
		END IF;
		
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='DELETE' THEN
		IF current_database() = 'bereg' AND OLD.client_id = (const_konkrid_client_val()->'keys'->>'id')::int THEN
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('Order.to_konkrid_delete',
					json_build_object('params',
						json_build_object('id', OLD.id)
					)::text
			);
		END IF;
	
		RETURN OLD;
	END IF;	
	
END;
$BODY$;

ALTER FUNCTION public.order_after_process()
    OWNER TO beton;



-- ******************* update 18/04/2024 17:40:08 ******************
-- FUNCTION: public.order_after_process()

-- DROP FUNCTION IF EXISTS public.order_after_process();

CREATE OR REPLACE FUNCTION public.order_after_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

DECLARE
	v_f boolean;
BEGIN	
	IF TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
	
		IF current_database() = 'bereg' AND NEW.client_id = (const_konkrid_client_val()->'keys'->>'id')::int THEN
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('Order.to_konkrid_' || LOWER(TG_OP),
					json_build_object('params',
						json_build_object('id', NEW.id)
					)::text
			);
			
		ELSIF current_database() = 'concrete1' THEN
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('Order.to_bereg_' || LOWER(TG_OP),
					json_build_object('params',
						json_build_object('id', NEW.id)
					)::text
			);
		
		END IF;
	
	
		IF TG_OP = 'INSERT' OR (TG_OP='UPDATE'
			AND NEW.phone_cel<>''
			AND (
				(NEW.client_id<>OLD.client_id)
				OR (NEW.phone_cel<>OLD.phone_cel)
			)
			)
		THEN		
			SELECT
				TRUE
			INTO v_f FROM client_tels
			WHERE client_id = NEW.client_id
				AND tel=NEW.phone_cel;
			
			IF v_f IS NULL THEN
				
				BEGIN
					INSERT INTO client_tels
						(client_id,tel,name)
					VALUES (NEW.client_id,NEW.phone_cel,NEW.descr);
				EXCEPTION WHEN OTHERS THEN
				END;
			END IF;
			
		END IF;
		
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='DELETE' THEN
		IF current_database() = 'bereg' AND OLD.client_id = (const_konkrid_client_val()->'keys'->>'id')::int THEN
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('Order.to_konkrid_delete',
					json_build_object('params',
						json_build_object('id', OLD.id)
					)::text
			);
			
		ELSIF current_database() = 'concrete1' THEN
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('Order.to_bereg_delete',
					json_build_object('params',
						json_build_object('id', OLD.id)
					)::text
			);
		
		END IF;
	
		RETURN OLD;
	END IF;	
	
END;
$BODY$;

ALTER FUNCTION public.order_after_process()
    OWNER TO beton;



-- ******************* update 19/04/2024 08:32:22 ******************
-- FUNCTION: public.geo_zone_check()

-- DROP FUNCTION IF EXISTS public.geo_zone_check();

CREATE OR REPLACE FUNCTION public.geo_zone_check()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	v_cur_state vehicle_states;
	v_production_base_id int;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	
	v_zone geometry;
	
	v_st_date_time timestamp without time zone;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;
	v_long_route_rest bool;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;

	--get last state
	WITH
	shift AS (
		SELECT
			d_from,
			d_to
		FROM get_shift_bounds(NEW.recieved_dt + age(now(), now() at time zone 'UTC')) AS (d_from timestamp, d_to timestamp)
	)
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE
		st.tracker_id = NEW.car_id
		AND st.date_time BETWEEN (SELECT d_from FROM shift) AND (SELECT d_to FROM shift)
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF v_cur_state = 'busy'::vehicle_states THEN
			--clients zone on shipment
			SELECT				
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id = shipments.order_id
			LEFT JOIN destinations ON destinations.id = orders.destination_id
			WHERE
				shipments.id = v_shipment_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
			
		ELSIF  v_cur_state = 'at_dest'::vehicle_states THEN
			-- client zone from state
			SELECT
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM destinations
			WHERE
				destinations.id = v_destination_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
		ELSE
			--
			-- base zone
			-- ALL possible zones, NOT constant_base_geo_zone_id()
			-- returns one zone only
			SELECT
				b.id,
				b.destination_id,
				destinations.zone
			INTO
				v_production_base_id,
				v_destination_id,
				v_zone
			FROM production_bases AS b
			LEFT JOIN destinations ON destinations.id = b.destination_id
			WHERE
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			LIMIT 1			
			;
					
		END IF;		
		
		--if at least the last point inside zone
		IF v_zone IS NOT NULL THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat
					FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid = 1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count() - 1
					OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					-- v_production_base_id = previous state value
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					-- v_production_base_id = previous state value OR some other logic!!! Куда назначили
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
					--v_production_base_id = Фактическая зона, зона производственной площадки
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id, destination_id, shipment_id, production_base_id)
					VALUES (CURRENT_TIMESTAMP,
						v_schedule_id,
						v_new_state,
						NEW.car_id,
						v_destination_id,
						v_shipment_id,
						v_production_base_id
					);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						--v_cur_state='at_dest' OR 
						WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		/*IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%, v_cur_state=%',v_shipment_id,v_cur_state;
		END IF;*/
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						/*v_point_in_zone = FALSE;
						SELECT
							st_contains(
								st_transform(
									st_buffer(
										st_transform(
											ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
											,3857
										)
										,30
									)
								,4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
						END IF;
						*/
						
						IF v_destination_id IS NOT NULL AND v_client_id IS NOT NULL THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT (client_id,destination_id) DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;						
						--route done
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										--v_cur_state='at_dest' OR 
										WHEN v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		SELECT (length(v_hypothetical_route_rest_t)>7500) INTO v_long_route_rest;
		IF v_long_route_rest THEN
			INSERT INTO route_rests VALUES(NEW.car_id,v_hypothetical_route_rest_t)
			ON CONFLICT (tracker_id) DO UPDATE SET
			route_rest = v_hypothetical_route_rest_t;
		END IF;
		
		--returns vehicles_last_pos struc + route
		BEGIN
			PERFORM pg_notify(
				'Vehicle.position.'||NEW.car_id
				,json_build_object(
					'params',json_build_object(
						'tracker_id',NEW.car_id
						,'lon',NEW.lon
						,'lat',NEW.lat
						,'heading',NEW.heading
						,'speed',NEW.speed
						,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'ns',NEW.ns
						,'ew',NEW.ew
						,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'odometer',NEW.odometer::text
						,'voltage',round(NEW.voltage,0)
						,'route_rest',CASE WHEN v_long_route_rest THEN NULL ELSE v_hypothetical_route_rest_t END
						,'long_route_rest',v_long_route_rest
						,'route_rest_len',v_hypothetical_route_rest_len
					)
				)::text
			);
		EXCEPTION WHEN OTHERS THEN
		END;
	END IF;

	--from beton to konkrid
	
	IF current_database() = 'beton' THEN
		--whose car?
		--konkrid ownerID=286
		IF
			coalesce(
				(SELECT
						(owners.f->'owner'->'keys'->>'id')::int = 286 AS konkrid_owned
				FROM (
					SELECT
							jsonb_array_elements(vehicle_owners->'rows')->'fields' AS f
					FROM vehicles AS v
					WHERE v.tracker_id = NEW.car_id
				) AS owners
				ORDER BY (owners.f->>'dt_from')::timestamp DESC
				LIMIT 1)
			, FALSE
			) THEN
			
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('CarTracking.to_konkrid',
					json_build_object('params',
						json_build_object('car_id', NEW.car_id, 'period', NEW.period)
					)::text
			);
		END IF;
	END IF;
		
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.geo_zone_check()
    OWNER TO beton;



-- ******************* update 19/04/2024 09:44:58 ******************
-- FUNCTION: public.geo_zone_check()

-- DROP FUNCTION IF EXISTS public.geo_zone_check();

CREATE OR REPLACE FUNCTION public.geo_zone_check()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	v_cur_state vehicle_states;
	v_production_base_id int;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	
	v_zone geometry;
	
	v_st_date_time timestamp without time zone;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;
	v_long_route_rest bool;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;

	--get last state
	WITH
	shift AS (
		SELECT
			d_from,
			d_to
		FROM get_shift_bounds(NEW.recieved_dt + age(now(), now() at time zone 'UTC')) AS (d_from timestamp, d_to timestamp)
	)
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE
		st.tracker_id = NEW.car_id
		AND st.date_time BETWEEN (SELECT d_from FROM shift) AND (SELECT d_to FROM shift)
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF v_cur_state = 'busy'::vehicle_states THEN
			--clients zone on shipment
			SELECT				
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id = shipments.order_id
			LEFT JOIN destinations ON destinations.id = orders.destination_id
			WHERE
				shipments.id = v_shipment_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
			
		ELSIF  v_cur_state = 'at_dest'::vehicle_states THEN
			-- client zone from state
			SELECT
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM destinations
			WHERE
				destinations.id = v_destination_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
		ELSE
			--
			-- base zone
			-- ALL possible zones, NOT const_base_geo_zone_id_val()
			-- returns one zone only
			SELECT
				b.id,
				b.destination_id,
				destinations.zone
			INTO
				v_production_base_id,
				v_destination_id,
				v_zone
			FROM production_bases AS b
			LEFT JOIN destinations ON destinations.id = b.destination_id
			WHERE
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			LIMIT 1			
			;
					
		END IF;		
		
		--if at least the last point inside zone
		IF v_zone IS NOT NULL THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat
					FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid = 1
					ORDER BY t.period DESC
					LIMIT const_geo_zone_check_points_count_val() - 1
					OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					-- v_production_base_id = previous state value
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					-- v_production_base_id = previous state value OR some other logic!!! Куда назначили
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
					--v_production_base_id = Фактическая зона, зона производственной площадки
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id, destination_id, shipment_id, production_base_id)
					VALUES (CURRENT_TIMESTAMP,
						v_schedule_id,
						v_new_state,
						NEW.car_id,
						v_destination_id,
						v_shipment_id,
						v_production_base_id
					);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						--v_cur_state='at_dest' OR 
						WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		/*IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%, v_cur_state=%',v_shipment_id,v_cur_state;
		END IF;*/
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = const_base_geo_zone_id_val()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						/*v_point_in_zone = FALSE;
						SELECT
							st_contains(
								st_transform(
									st_buffer(
										st_transform(
											ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
											,3857
										)
										,30
									)
								,4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
						END IF;
						*/
						
						IF v_destination_id IS NOT NULL AND v_client_id IS NOT NULL THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT (client_id,destination_id) DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;						
						--route done
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										--v_cur_state='at_dest' OR 
										WHEN v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		SELECT (length(v_hypothetical_route_rest_t)>7500) INTO v_long_route_rest;
		IF v_long_route_rest THEN
			INSERT INTO route_rests VALUES(NEW.car_id,v_hypothetical_route_rest_t)
			ON CONFLICT (tracker_id) DO UPDATE SET
			route_rest = v_hypothetical_route_rest_t;
		END IF;
		
		--returns vehicles_last_pos struc + route
		BEGIN
			PERFORM pg_notify(
				'Vehicle.position.'||NEW.car_id
				,json_build_object(
					'params',json_build_object(
						'tracker_id',NEW.car_id
						,'lon',NEW.lon
						,'lat',NEW.lat
						,'heading',NEW.heading
						,'speed',NEW.speed
						,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'ns',NEW.ns
						,'ew',NEW.ew
						,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'odometer',NEW.odometer::text
						,'voltage',round(NEW.voltage,0)
						,'route_rest',CASE WHEN v_long_route_rest THEN NULL ELSE v_hypothetical_route_rest_t END
						,'long_route_rest',v_long_route_rest
						,'route_rest_len',v_hypothetical_route_rest_len
					)
				)::text
			);
		EXCEPTION WHEN OTHERS THEN
		END;
	END IF;

	--from beton to konkrid
	
	IF current_database() = 'beton' THEN
		--whose car?
		--konkrid ownerID=286
		IF
			coalesce(
				(SELECT
						(owners.f->'owner'->'keys'->>'id')::int = 286 AS konkrid_owned
				FROM (
					SELECT
							jsonb_array_elements(vehicle_owners->'rows')->'fields' AS f
					FROM vehicles AS v
					WHERE v.tracker_id = NEW.car_id
				) AS owners
				ORDER BY (owners.f->>'dt_from')::timestamp DESC
				LIMIT 1)
			, FALSE
			) THEN
			
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('CarTracking.to_konkrid',
					json_build_object('params',
						json_build_object('car_id', NEW.car_id, 'period', NEW.period)
					)::text
			);
		END IF;
	END IF;
		
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.geo_zone_check()
    OWNER TO beton;



-- ******************* update 19/04/2024 10:07:49 ******************
-- FUNCTION: public.geo_zone_check()

-- DROP FUNCTION IF EXISTS public.geo_zone_check();

CREATE OR REPLACE FUNCTION public.geo_zone_check()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	v_cur_state vehicle_states;
	v_production_base_id int;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	
	v_zone geometry;
	
	v_st_date_time timestamp without time zone;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;
	v_long_route_rest bool;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;

	--get last state
	WITH
	shift AS (
		SELECT
			d_from,
			d_to
		FROM get_shift_bounds(NEW.recieved_dt + age(now(), now() at time zone 'UTC')) AS (d_from timestamp, d_to timestamp)
	)
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE
		st.tracker_id = NEW.car_id
		AND st.date_time BETWEEN (SELECT d_from FROM shift) AND (SELECT d_to FROM shift)
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF v_cur_state = 'busy'::vehicle_states THEN
			--clients zone on shipment
			SELECT				
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id = shipments.order_id
			LEFT JOIN destinations ON destinations.id = orders.destination_id
			WHERE
				shipments.id = v_shipment_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
			
		ELSIF  v_cur_state = 'at_dest'::vehicle_states THEN
			-- client zone from state
			SELECT
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM destinations
			WHERE
				destinations.id = v_destination_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
		ELSE
			--
			-- base zone
			-- ALL possible zones, NOT const_base_geo_zone_id_val()
			-- returns one zone only
			SELECT
				b.id,
				b.destination_id,
				destinations.zone
			INTO
				v_production_base_id,
				v_destination_id,
				v_zone
			FROM production_bases AS b
			LEFT JOIN destinations ON destinations.id = b.destination_id
			WHERE
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			LIMIT 1			
			;
					
		END IF;		
		
		--if at least the last point inside zone
		IF v_zone IS NOT NULL THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat
					FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid = 1
					ORDER BY t.period DESC
					LIMIT const_geo_zone_check_points_count_val() - 1
					OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					-- v_production_base_id = previous state value
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					-- v_production_base_id = previous state value OR some other logic!!! Куда назначили
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
					--v_production_base_id = Фактическая зона, зона производственной площадки
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id, destination_id, shipment_id, production_base_id)
					VALUES (CURRENT_TIMESTAMP,
						v_schedule_id,
						v_new_state,
						NEW.car_id,
						v_destination_id,
						v_shipment_id,
						v_production_base_id
					);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						--v_cur_state='at_dest' OR 
						WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		/*IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%, v_cur_state=%',v_shipment_id,v_cur_state;
		END IF;*/
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = const_base_geo_zone_id_val()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						/*v_point_in_zone = FALSE;
						SELECT
							st_contains(
								st_transform(
									st_buffer(
										st_transform(
											ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
											,3857
										)
										,30
									)
								,4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
						END IF;
						*/
						
						IF v_destination_id IS NOT NULL AND v_client_id IS NOT NULL THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT (client_id,destination_id) DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;						
						--route done
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										--v_cur_state='at_dest' OR 
										WHEN v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		SELECT (length(v_hypothetical_route_rest_t)>7500) INTO v_long_route_rest;
		IF v_long_route_rest THEN
			INSERT INTO route_rests VALUES(NEW.car_id,v_hypothetical_route_rest_t)
			ON CONFLICT (tracker_id) DO UPDATE SET
			route_rest = v_hypothetical_route_rest_t;
		END IF;
		
		--returns vehicles_last_pos struc + route
		BEGIN
			PERFORM pg_notify(
				'Vehicle.position.'||NEW.car_id
				,json_build_object(
					'params',json_build_object(
						'tracker_id',NEW.car_id
						,'lon',NEW.lon
						,'lat',NEW.lat
						,'heading',NEW.heading
						,'speed',NEW.speed
						,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'ns',NEW.ns
						,'ew',NEW.ew
						,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'odometer',NEW.odometer::text
						,'voltage',round(NEW.voltage,0)
						,'route_rest',CASE WHEN v_long_route_rest THEN NULL ELSE v_hypothetical_route_rest_t END
						,'long_route_rest',v_long_route_rest
						,'route_rest_len',v_hypothetical_route_rest_len
					)
				)::text
			);
		EXCEPTION WHEN OTHERS THEN
		END;
	END IF;

	--from beton to konkrid
	
	IF current_database() = 'beton' THEN
		--whose car?
		--konkrid ownerID=286
		IF
			coalesce(
				(SELECT
						(owners.f->'owner'->'keys'->>'id')::int = 286 AS konkrid_owned
				FROM (
					SELECT
							jsonb_array_elements(vehicle_owners->'rows')->'fields' AS f
					FROM vehicles AS v
					WHERE v.tracker_id = NEW.car_id
				) AS owners
				ORDER BY (owners.f->>'dt_from')::timestamp DESC
				LIMIT 1)
			, FALSE
			) THEN
			
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('CarTracking.to_konkrid',
					json_build_object('params',
						json_build_object('car_id', NEW.car_id, 'period', NEW.period)
					)::text
			);
		END IF;
	END IF;
		
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.geo_zone_check()
    OWNER TO concrete1;



-- ******************* update 19/04/2024 10:20:56 ******************
-- FUNCTION: public.get_shift_bounds(timestamp without time zone)

-- DROP FUNCTION IF EXISTS public.get_shift_bounds(timestamp without time zone);

CREATE OR REPLACE FUNCTION public.get_shift_bounds(
	timestamp without time zone)
    RETURNS record
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE shift_start_time time without time zone;
	shift_start_date date;
	ret RECORD;
BEGIN
	shift_start_time = const_first_shift_start_time_val();
	
	IF $1::time<shift_start_time THEN
		shift_start_date = $1::date - 1;
	ELSE
		shift_start_date = $1::date;
	END IF;
	
	ret = (shift_start_date + shift_start_time,
		shift_start_date + shift_start_time + const_shift_length_time_val() - '00:00:01'::time);
	RETURN ret;
END;
$BODY$;

ALTER FUNCTION public.get_shift_bounds(timestamp without time zone)
    OWNER TO concrete1;



-- ******************* update 22/04/2024 14:37:34 ******************
-- Function: public.doc_material_procurements_process()

-- DROP FUNCTION public.doc_material_procurements_process();

CREATE OR REPLACE FUNCTION public.doc_material_procurements_process()
  RETURNS trigger AS
$BODY$
DECLARE
	reg_act ra_materials%ROWTYPE;
	reg_material_facts ra_material_facts%ROWTYPE;
	reg_cement ra_cement%ROWTYPE;
	v_dif_store bool;
	v_production_site_id int;
BEGIN
	IF (TG_WHEN='BEFORE' AND TG_OP='INSERT') THEN
		IF NEW.date_time < '2024-01-01T00:00:00'::timestamp THEN
			RAISE EXCEPTION 'Дата запрета редактирования: %', '2024-01-01T00:00:00'::timestamp;
		END IF;
		
		-- Временно!
		--NEW.production_base_id = 1;
		--Обнудение материал = БЕТОН
		IF NEW.material_id = 1240 THEN
			NEW.quant_net = 0;
			NEW.quant_gross = 0;
		END IF;
		
		--Если это из горного - обнулить по документам
		IF coalesce(NEW.doc_ref_gornyi, '') <> ''
		THEN
			NEW.doc_quant_gross = 0;
			NEW.doc_quant_net = 0;
		END IF;
		
		RETURN NEW;
		
	ELSIF (TG_WHEN='AFTER') AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN					
		IF (TG_OP='INSERT') THEN						
			--log
			PERFORM doc_log_insert('material_procurement'::doc_types,NEW.id,NEW.date_time);
		END IF;

		--register actions ra_materials
		reg_act.date_time		= NEW.date_time;
		reg_act.deb			= true;
		reg_act.doc_type  		= 'material_procurement'::doc_types;
		reg_act.doc_id  		= NEW.id;
		reg_act.production_base_id	= NEW.production_base_id;
		reg_act.material_id		= NEW.material_id;
		reg_act.quant			= NEW.quant_net;
		PERFORM ra_materials_add_act(reg_act);	
		
		SELECT dif_store INTO v_dif_store FROM raw_materials WHERE id=NEW.material_id;
		--По материалам делаем всегда движения, а если есть учет по силосам и есть силос - то и по силосам
		--Если учет по заводам (v_dif_store==TRUE)- то по заводам
		--register actions ra_material_facts
		reg_material_facts.date_time		= NEW.date_time;
		reg_material_facts.deb			= true;
		reg_material_facts.doc_type  		= 'material_procurement'::doc_types;
		reg_material_facts.doc_id  		= NEW.id;
		reg_material_facts.material_id		= NEW.material_id;
		reg_material_facts.production_base_id	= NEW.production_base_id;
		
		IF coalesce(v_dif_store,FALSE) AND coalesce(NEW.store,'')<>'' THEN
			--Определить завод по приходу
			SELECT production_site_id INTO v_production_site_id FROM store_map_to_production_sites WHERE store = NEW.store;
			--RAISE EXCEPTION 'v_production_site_id=%',v_production_site_id;
			IF v_production_site_id IS NULL THEN
				-- no match!
				INSERT INTO store_map_to_production_sites (store) VALUES (NEW.store);
			END IF;
			reg_material_facts.production_site_id = v_production_site_id;
		END IF;
		reg_material_facts.quant		= NEW.quant_net;
		PERFORM ra_material_facts_add_act(reg_material_facts);	
		
		IF coalesce( (SELECT is_cement FROM raw_materials WHERE id = NEW.material_id),FALSE)
		AND NEW.cement_silos_id IS NOT NULL THEN
			--register actions ra_cement
			reg_cement.date_time		= NEW.date_time;
			reg_cement.deb			= true;
			reg_cement.doc_type  		= 'material_procurement'::doc_types;
			reg_cement.doc_id  		= NEW.id;
			reg_cement.cement_silos_id	= NEW.cement_silos_id;
			reg_cement.quant		= NEW.quant_net;
			PERFORM ra_cement_add_act(reg_cement);	
			
		END IF;
			
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',NEW.date_time::date
				)
			)::text
		);
				
		RETURN NEW;
		
	ELSIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		IF NEW.date_time < '2024-01-01T00:00:00'::timestamp THEN
			RAISE EXCEPTION 'Дата запрета редактирования: %', '2024-01-01T00:00:00'::timestamp;
		END IF;
	
		PERFORM ra_materials_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_cement_remove_acts('material_procurement'::doc_types,OLD.id);

		--Если это из горного - обнулить по документам
		IF coalesce(NEW.doc_ref_gornyi, '') <> ''
		AND (coalesce(NEW.doc_quant_gross,0)<>0 OR coalesce(NEW.doc_quant_net,0)<>0)
		THEN
			NEW.doc_quant_gross = 0;
			NEW.doc_quant_net = 0;
		END IF;


		IF NEW.date_time<>OLD.date_time THEN
			PERFORM doc_log_update('material_procurement'::doc_types,NEW.id,NEW.date_time);
		END IF;
						
		RETURN NEW;
		
	ELSIF (TG_WHEN='AFTER' AND TG_OP='DELETE') THEN
	
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',OLD.date_time::date
				)
			)::text
		);
	
		RETURN OLD;
	ELSIF (TG_WHEN='BEFORE' AND TG_OP='DELETE') THEN
		IF OLD.date_time < '2024-01-01T00:00:00'::timestamp THEN
			RAISE EXCEPTION 'Дата запрета редактирования: %', '2024-01-01T00:00:00'::timestamp;
		END IF;
	
		--detail tables
		
		--register actions										
		PERFORM ra_materials_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_cement_remove_acts('material_procurement'::doc_types,OLD.id);
		
		--log
		PERFORM doc_log_delete('material_procurement'::doc_types,OLD.id);
		
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.doc_material_procurements_process()
  OWNER TO beton;



-- ******************* update 22/04/2024 14:37:56 ******************
-- Function: public.doc_material_procurements_process()

-- DROP FUNCTION public.doc_material_procurements_process();

CREATE OR REPLACE FUNCTION public.doc_material_procurements_process()
  RETURNS trigger AS
$BODY$
DECLARE
	reg_act ra_materials%ROWTYPE;
	reg_material_facts ra_material_facts%ROWTYPE;
	reg_cement ra_cement%ROWTYPE;
	v_dif_store bool;
	v_production_site_id int;
BEGIN
	IF (TG_WHEN='BEFORE' AND TG_OP='INSERT') THEN
		IF NEW.date_time < '2024-01-01T00:00:00'::timestamp THEN
			RAISE EXCEPTION 'Дата запрета редактирования: %', '2024-01-01T00:00:00'::timestamp;
		END IF;
		
		-- Временно!
		--NEW.production_base_id = 1;
		--Обнудение материал = БЕТОН
		IF NEW.material_id = 1240 THEN
			NEW.quant_net = 0;
			NEW.quant_gross = 0;
		END IF;
		
		--Если это из горного - обнулить по документам
		IF coalesce(NEW.doc_ref_gornyi, '') <> ''
		THEN
			NEW.doc_quant_gross = 0;
			NEW.doc_quant_net = 0;
		END IF;
		
		RETURN NEW;
		
	ELSIF (TG_WHEN='AFTER') AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN					
		IF (TG_OP='INSERT') THEN						
			--log
			PERFORM doc_log_insert('material_procurement'::doc_types,NEW.id,NEW.date_time);
		END IF;

		--register actions ra_materials
		reg_act.date_time		= NEW.date_time;
		reg_act.deb			= true;
		reg_act.doc_type  		= 'material_procurement'::doc_types;
		reg_act.doc_id  		= NEW.id;
		reg_act.production_base_id	= NEW.production_base_id;
		reg_act.material_id		= NEW.material_id;
		reg_act.quant			= NEW.quant_net;
		PERFORM ra_materials_add_act(reg_act);	
		
		SELECT dif_store INTO v_dif_store FROM raw_materials WHERE id=NEW.material_id;
		--По материалам делаем всегда движения, а если есть учет по силосам и есть силос - то и по силосам
		--Если учет по заводам (v_dif_store==TRUE)- то по заводам
		--register actions ra_material_facts
		reg_material_facts.date_time		= NEW.date_time;
		reg_material_facts.deb			= true;
		reg_material_facts.doc_type  		= 'material_procurement'::doc_types;
		reg_material_facts.doc_id  		= NEW.id;
		reg_material_facts.material_id		= NEW.material_id;
		reg_material_facts.production_base_id	= NEW.production_base_id;
		
		IF coalesce(v_dif_store,FALSE) AND coalesce(NEW.store,'')<>'' THEN
			--Определить завод по приходу
			SELECT production_site_id INTO v_production_site_id FROM store_map_to_production_sites WHERE store = NEW.store;
			--RAISE EXCEPTION 'v_production_site_id=%',v_production_site_id;
			IF v_production_site_id IS NULL THEN
				-- no match!
				INSERT INTO store_map_to_production_sites (store) VALUES (NEW.store);
			END IF;
			reg_material_facts.production_site_id = v_production_site_id;
		END IF;
		reg_material_facts.quant		= NEW.quant_net;
		PERFORM ra_material_facts_add_act(reg_material_facts);	
		
		IF coalesce( (SELECT is_cement FROM raw_materials WHERE id = NEW.material_id),FALSE)
		AND NEW.cement_silos_id IS NOT NULL THEN
			--register actions ra_cement
			reg_cement.date_time		= NEW.date_time;
			reg_cement.deb			= true;
			reg_cement.doc_type  		= 'material_procurement'::doc_types;
			reg_cement.doc_id  		= NEW.id;
			reg_cement.cement_silos_id	= NEW.cement_silos_id;
			reg_cement.quant		= NEW.quant_net;
			PERFORM ra_cement_add_act(reg_cement);	
			
		END IF;
			
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',NEW.date_time::date
				)
			)::text
		);
				
		RETURN NEW;
		
	ELSIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		IF NEW.date_time < '2024-01-01T00:00:00'::timestamp THEN
			RAISE EXCEPTION 'Дата запрета редактирования: %', '2024-01-01T00:00:00'::timestamp;
		END IF;
	
		PERFORM ra_materials_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_cement_remove_acts('material_procurement'::doc_types,OLD.id);

		--Если это из горного - обнулить по документам
		IF coalesce(NEW.doc_ref_gornyi, '') <> ''
		AND (coalesce(NEW.doc_quant_gross,0)<>0 OR coalesce(NEW.doc_quant_net,0)<>0)
		THEN
			NEW.doc_quant_gross = 0;
			NEW.doc_quant_net = 0;
		END IF;


		IF NEW.date_time<>OLD.date_time THEN
			PERFORM doc_log_update('material_procurement'::doc_types,NEW.id,NEW.date_time);
		END IF;
						
		RETURN NEW;
		
	ELSIF (TG_WHEN='AFTER' AND TG_OP='DELETE') THEN
	
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',OLD.date_time::date
				)
			)::text
		);
	
		RETURN OLD;
	ELSIF (TG_WHEN='BEFORE' AND TG_OP='DELETE') THEN
		IF OLD.date_time < '2024-01-01T00:00:00'::timestamp THEN
			RAISE EXCEPTION 'Дата запрета редактирования: %', '2024-01-01T00:00:00'::timestamp;
		END IF;
	
		--detail tables
		
		--register actions										
		PERFORM ra_materials_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_cement_remove_acts('material_procurement'::doc_types,OLD.id);
		
		--log
		PERFORM doc_log_delete('material_procurement'::doc_types,OLD.id);
		
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.doc_material_procurements_process()
  OWNER TO concrete1;



-- ******************* update 23/04/2024 09:36:32 ******************
﻿-- Function: silo_with_material_list(in_material_id int, in_date_time timestamp)

-- DROP FUNCTION silo_with_material_list(in_material_id int, in_date_time timestamp);

CREATE OR REPLACE FUNCTION silo_with_material_list(in_material_id int, in_date_time timestamp)
  RETURNS table(
  	silo_id int,
  	production_site_id int,
  	silo_name text  	
  ) AS
$$
	select
			sl.silo_id,
			sl.production_site_id,
			sl.name as silo_name
	from (	
		select
			sl.id as silo_id,
			sl.production_site_id,
			sl.name,
			sl.production_descr,
			(select
				mpr.raw_material_id
			from raw_material_map_to_production as mpr
			where (mpr.production_site_id is null or mpr.production_site_id = sl.production_site_id)
				and mpr.production_descr = sl.production_descr
				and mpr.date_time <= in_date_time
			order by date_time desc
			limit 1) as raw_material_id
		from cement_silos as sl
	) AS sl
	where sl.production_descr is not null AND raw_material_id = in_material_id
	;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION silo_with_material_list(in_material_id int, in_date_time timestamp) OWNER TO beton;


-- ******************* update 23/04/2024 09:37:25 ******************
﻿-- Function: silo_with_material_list(in_material_id int, in_date_time timestamp)

-- DROP FUNCTION silo_with_material_list(in_material_id int, in_date_time timestamp);

CREATE OR REPLACE FUNCTION silo_with_material_list(in_material_id int, in_date_time timestamp)
  RETURNS table(
  	silo_id int,
  	production_site_id int,
  	silo_name text  	
  ) AS
$$
	select
			sl.silo_id,
			sl.production_site_id,
			sl.name as silo_name
	from (	
		select
			sl.id as silo_id,
			sl.production_site_id,
			sl.name,
			sl.production_descr,
			(select
				mpr.raw_material_id
			from raw_material_map_to_production as mpr
			where (mpr.production_site_id is null or mpr.production_site_id = sl.production_site_id)
				and mpr.production_descr = sl.production_descr
				and mpr.date_time <= in_date_time
			order by date_time desc
			limit 1) as raw_material_id
		from cement_silos as sl
	) AS sl
	where sl.production_descr is not null AND raw_material_id = in_material_id
	;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION silo_with_material_list(in_material_id int, in_date_time timestamp) OWNER TO beton;


-- ******************* update 23/04/2024 09:39:40 ******************
﻿-- Function: silo_with_material_list(in_material_id int, in_date_time timestamp)

 DROP FUNCTION silo_with_material_list(in_material_id int, in_date_time timestamp);

CREATE OR REPLACE FUNCTION silo_with_material_list(in_material_id int, in_date_time timestamp with time zone)
  RETURNS table(
  	silo_id int,
  	production_site_id int,
  	silo_name text  	
  ) AS
$$
	select
			sl.silo_id,
			sl.production_site_id,
			sl.name as silo_name
	from (	
		select
			sl.id as silo_id,
			sl.production_site_id,
			sl.name,
			sl.production_descr,
			(select
				mpr.raw_material_id
			from raw_material_map_to_production as mpr
			where (mpr.production_site_id is null or mpr.production_site_id = sl.production_site_id)
				and mpr.production_descr = sl.production_descr
				and mpr.date_time <= in_date_time
			order by date_time desc
			limit 1) as raw_material_id
		from cement_silos as sl
	) AS sl
	where sl.production_descr is not null AND raw_material_id = in_material_id
	;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION silo_with_material_list(in_material_id int, in_date_time timestamp with time zone) OWNER TO beton;


-- ******************* update 23/04/2024 10:45:31 ******************
﻿-- Function: material_in_silo_on_date(in_silo_id int, in_date_time timestamp with time zone)

-- DROP FUNCTION material_in_silo_on_date(in_silo_id int, in_date_time timestamp with time zone);

/*
 * returns material id which is in silo at the given date time.
 */

CREATE OR REPLACE FUNCTION material_in_silo_on_date(in_silo_id int, in_date_time timestamp with time zone)
  RETURNS int AS
$$
	with
	silo as (select production_descr, production_site_id from cement_silos where id = in_silo_id)
	select
		mpr.raw_material_id
	from raw_material_map_to_production as mpr
	where
		(mpr.production_site_id is null or mpr.production_site_id = (select silo.production_site_id from silo))
		and mpr.production_descr = (select silo.production_descr from silo)
		and mpr.date_time <= in_date_time
	order by mpr.date_time desc
	limit 1;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION material_in_silo_on_date(in_silo_id int, in_date_time timestamp with time zone) OWNER TO beton;


-- ******************* update 23/04/2024 13:19:51 ******************
-- Function: public.cement_silo_balance_resets_process()

-- DROP FUNCTION public.cement_silo_balance_resets_process();

CREATE OR REPLACE FUNCTION public.cement_silo_balance_resets_process()
  RETURNS trigger AS
$BODY$
DECLARE
	reg_cement ra_cement%ROWTYPE;
	reg_material_facts ra_material_facts%ROWTYPE;
	v_quant numeric(19,4);
	v_material_id int;
BEGIN
	IF (TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') ) THEN
		IF (TG_OP='INSERT') THEN						
			--log
			PERFORM doc_log_insert('cement_silo_balance_reset'::doc_types,NEW.id,NEW.date_time);
		END IF;
	
		SELECT rg.quant INTO v_quant FROM rg_cement_balance(NEW.date_time,ARRAY[NEW.cement_silo_id]) AS rg;		
		v_quant = NEW.quant_required - coalesce(v_quant,0);
		IF v_quant<>0 THEN
			--register actions ra_cement
			reg_cement.date_time		= NEW.date_time;
			reg_cement.deb			= (v_quant>0);
			reg_cement.doc_type  		= 'cement_silo_balance_reset'::doc_types;
			reg_cement.doc_id  		= NEW.id;
			reg_cement.cement_silos_id	= NEW.cement_silo_id;
			reg_cement.quant		= abs(v_quant);
			PERFORM ra_cement_add_act(reg_cement);				
		END IF;
		
		--Остатки материалов, материал определить по последнему приходу в силос
		/*
		SELECT material_id
		INTO v_material_id
		FROM doc_material_procurements
		WHERE cement_silos_id = NEW.cement_silo_id
		ORDER BY date_time DESC
		LIMIT 1;
		*/
		
		v_material_id = material_in_silo_on_date(NEW.cement_silo_id, NEW.date_time);
		
		IF coalesce(v_material_id,0)>0 AND v_quant<>0 THEN		
			--здесь определяем свое количество по регистру материалов
			--SELECT rg.quant INTO v_quant FROM rg_material_facts_balance(NEW.date_time,ARRAY[v_material_id]) AS rg;					
			--v_quant = NEW.quant_required - coalesce(v_quant,0);
			
			--RAISE EXCEPTION 'v_quant=%',v_quant;
			IF v_quant<>0 THEN			
				reg_material_facts.date_time		= NEW.date_time;
				reg_material_facts.deb			= (v_quant>0);
				reg_material_facts.doc_type  		= 'cement_silo_balance_reset'::doc_types;
				reg_material_facts.doc_id  		= NEW.id;
				reg_material_facts.material_id		= v_material_id;
				reg_material_facts.production_base_id	= (
						SELECT production_base_id
						FROM production_sites
						WHERE id = (SELECT production_site_id FROM cement_silos WHERE id=NEW.cement_silo_id)
				);
				reg_material_facts.quant		= abs(v_quant);
				PERFORM ra_material_facts_add_act(reg_material_facts);	
			END IF;
		END IF;			
		
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',NEW.date_time::date
				)
			)::text
		);
		
		RETURN NEW;
		
	ELSEIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		IF NEW.date_time<>OLD.date_time THEN
			PERFORM doc_log_update('cement_silo_balance_reset'::doc_types,NEW.id,NEW.date_time);
		END IF;

		PERFORM ra_cement_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		
		RETURN NEW;
		
	ELSEIF TG_OP='DELETE' THEN
		IF TG_WHEN='BEFORE' THEN		
			--log
			PERFORM doc_log_delete('cement_silo_balance_reset'::doc_types,OLD.id);

			PERFORM ra_cement_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
			PERFORM ra_material_facts_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		ELSE
			--Event support
			PERFORM pg_notify(
					'RAMaterialFact.change'
				,json_build_object(
					'params',json_build_object(
						'cond_date',OLD.date_time::date
					)
				)::text
			);
		END IF;
	
		RETURN OLD;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.cement_silo_balance_resets_process()
  OWNER TO beton;



-- ******************* update 23/04/2024 13:59:59 ******************
-- Function: public.rg_total_recalc_cement()

-- DROP FUNCTION public.rg_total_recalc_cement();

CREATE OR REPLACE FUNCTION public.rg_total_recalc_cement()
  RETURNS void AS
$BODY$  
DECLARE
	period_row RECORD;
	v_act_date_time timestamp without time zone;
	v_cur_period timestamp without time zone;
BEGIN	
	v_act_date_time = reg_current_balance_time();
	SELECT date_time INTO v_cur_period FROM rg_calc_periods where reg_type='cement';
	
	FOR period_row IN
		WITH
		periods AS (
			(SELECT
				DISTINCT date_trunc('month', date_time) AS d,
				cement_silos_id
			FROM ra_cement)
			UNION		
			(SELECT
				date_time AS d,
				cement_silos_id
			FROM rg_cement WHERE date_time<=v_cur_period
			)
			ORDER BY d			
		)
		SELECT sub.d,sub.cement_silos_id,sub.balance_fact,sub.balance_paper
		FROM
		(
		SELECT
			periods.d,
			periods.cement_silos_id,
			COALESCE((
				SELECT SUM(CASE WHEN deb THEN quant ELSE 0 END)-SUM(CASE WHEN NOT deb THEN quant ELSE 0 END)
				FROM ra_cement AS ra WHERE ra.date_time <= last_month_day(periods.d::date)+'23:59:59'::interval AND ra.cement_silos_id=periods.cement_silos_id
			),0) AS balance_fact,
			
			(
			SELECT SUM(quant) FROM rg_cement WHERE date_time=periods.d AND cement_silos_id=periods.cement_silos_id
			) AS balance_paper
			
		FROM periods
		) AS sub
		WHERE sub.balance_fact<>sub.balance_paper ORDER BY sub.d	
	LOOP
		
		UPDATE rg_cement AS rg
		SET quant = period_row.balance_fact
		WHERE rg.date_time=period_row.d AND rg.cement_silos_id=period_row.cement_silos_id;
		
		IF NOT FOUND THEN
			INSERT INTO rg_cement (date_time,cement_silos_id,quant)
			VALUES (period_row.d,period_row.cement_silos_id,period_row.balance_fact);
		END IF;
	END LOOP;

	--АКТУАЛЬНЫЕ ИТОГИ
	DELETE FROM rg_cement WHERE date_time>v_cur_period;
	
	INSERT INTO rg_cement (date_time,cement_silos_id,quant)
	(
	SELECT
		v_act_date_time,
		rg.cement_silos_id,
		COALESCE(rg.quant,0) +
		COALESCE((
		SELECT sum(ra.quant) FROM
		ra_cement AS ra
		WHERE ra.date_time BETWEEN v_cur_period AND last_month_day(v_cur_period::date)+'23:59:59'::interval
			AND ra.cement_silos_id=rg.cement_silos_id
			AND ra.deb=TRUE
		),0) - 
		COALESCE((
		SELECT sum(ra.quant) FROM
		ra_cement AS ra
		WHERE ra.date_time BETWEEN v_cur_period AND last_month_day(v_cur_period::date)+'23:59:59'::interval
			AND ra.cement_silos_id=rg.cement_silos_id
			AND ra.deb=FALSE
		),0)
		
	FROM rg_cement AS rg
	WHERE date_time=(v_cur_period-'1 month'::interval)
	);	
END;	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.rg_total_recalc_cement()
  OWNER TO beton;



-- ******************* update 23/04/2024 14:14:16 ******************
-- Function: public.rg_total_recalc_material_facts_mat(in_material_id integer)

-- DROP FUNCTION public.rg_total_recalc_material_facts_mat(in_material_id integer);

CREATE OR REPLACE FUNCTION public.rg_total_recalc_material_facts_mat(in_material_id integer)
  RETURNS void AS
$BODY$  
DECLARE
	period_row RECORD;
	v_act_date_time timestamp without time zone;
	v_cur_period timestamp without time zone;
BEGIN	
	v_act_date_time = reg_current_balance_time();
	SELECT date_time INTO v_cur_period FROM rg_calc_periods where reg_type = 'material_fact';
	
	FOR period_row IN
		WITH
		periods AS (
			(SELECT
				DISTINCT date_trunc('month', date_time) AS d,
				material_id,production_site_id
			FROM ra_material_facts WHERE material_id=in_material_id)
			UNION		
			(SELECT
				date_time AS d,
				material_id,production_site_id
			FROM rg_material_facts WHERE date_time<=v_cur_period AND material_id=in_material_id
			)
			ORDER BY d			
		)
		SELECT sub.d,sub.material_id,sub.production_site_id,sub.balance_fact,sub.balance_paper
		FROM
		(
		SELECT
			periods.d,
			periods.material_id,
			periods.production_site_id,
			COALESCE((
				SELECT SUM(CASE WHEN deb THEN quant ELSE 0 END)-SUM(CASE WHEN NOT deb THEN quant ELSE 0 END)
				FROM ra_material_facts AS ra WHERE ra.date_time <= last_month_day(periods.d::date)+'23:59:59'::interval
					AND ra.material_id=periods.material_id
					AND coalesce(ra.production_site_id,0)=coalesce(periods.production_site_id,0)
			),0) AS balance_fact,
			
			(
			SELECT SUM(quant) FROM rg_material_facts WHERE date_time=periods.d
				AND material_id=periods.material_id
				AND coalesce(production_site_id,0)=coalesce(periods.production_site_id,0)
			) AS balance_paper
			
		FROM periods
		) AS sub
		WHERE sub.balance_fact<>sub.balance_paper ORDER BY sub.d	
	LOOP
		
		UPDATE rg_material_facts AS rg
		SET quant = period_row.balance_fact
		WHERE rg.date_time=period_row.d
			AND rg.material_id=period_row.material_id
			AND coalesce(rg.production_site_id,0)=coalesce(period_row.production_site_id,0)
		;
		
		IF NOT FOUND THEN
			INSERT INTO rg_material_facts (date_time,material_id,production_site_id,quant)
			VALUES (period_row.d,period_row.material_id,period_row.production_site_id,period_row.balance_fact);
		END IF;
	END LOOP;

	--АКТУАЛЬНЫЕ ИТОГИ
	DELETE FROM rg_material_facts WHERE date_time>v_cur_period AND material_id=in_material_id;
	
	INSERT INTO rg_material_facts (date_time,material_id,production_site_id,quant)
	(
	SELECT
		v_act_date_time,
		rg.material_id,
		rg.production_site_id,
		COALESCE(rg.quant,0) +
		COALESCE((
		SELECT sum(ra.quant) FROM
		ra_material_facts AS ra
		WHERE ra.date_time BETWEEN v_cur_period AND last_month_day(v_cur_period::date)+'23:59:59'::interval
			AND ra.material_id=rg.material_id
			AND coalesce(ra.production_site_id,0)=coalesce(rg.production_site_id,0)
			AND ra.deb=TRUE
		),0) - 
		COALESCE((
		SELECT sum(ra.quant) FROM
		ra_material_facts AS ra
		WHERE ra.date_time BETWEEN v_cur_period AND last_month_day(v_cur_period::date)+'23:59:59'::interval
			AND ra.material_id=rg.material_id
			AND coalesce(ra.production_site_id,0)=coalesce(rg.production_site_id,0)
			AND ra.deb=FALSE
		),0)
		
	FROM rg_material_facts AS rg
	WHERE date_time=(v_cur_period-'1 month'::interval) AND material_id=in_material_id
	);	
END;	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.rg_total_recalc_material_facts_mat(in_material_id integer)
  OWNER TO beton;



-- ******************* update 23/04/2024 14:38:46 ******************
-- Function: public.cement_silo_balance_resets_process()

-- DROP FUNCTION public.cement_silo_balance_resets_process();

CREATE OR REPLACE FUNCTION public.cement_silo_balance_resets_process()
  RETURNS trigger AS
$BODY$
DECLARE
	reg_cement ra_cement%ROWTYPE;
	reg_material_facts ra_material_facts%ROWTYPE;
	v_quant numeric(19,4);
	v_material_id int;
BEGIN
	IF (TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') ) THEN
		IF (TG_OP='INSERT') THEN						
			--log
			PERFORM doc_log_insert('cement_silo_balance_reset'::doc_types,NEW.id,NEW.date_time);
		END IF;
	
		SELECT rg.quant INTO v_quant FROM rg_cement_balance(NEW.date_time,ARRAY[NEW.cement_silo_id]) AS rg;		
		v_quant = NEW.quant_required - coalesce(v_quant,0);
		IF v_quant<>0 THEN
			--register actions ra_cement
			reg_cement.date_time		= NEW.date_time;
			reg_cement.deb			= (v_quant>0);
			reg_cement.doc_type  		= 'cement_silo_balance_reset'::doc_types;
			reg_cement.doc_id  		= NEW.id;
			reg_cement.cement_silos_id	= NEW.cement_silo_id;
			reg_cement.quant		= abs(v_quant);
			PERFORM ra_cement_add_act(reg_cement);				
		END IF;
		
		--Остатки материалов, материал определить по последнему приходу в силос
		
		SELECT material_id
		INTO v_material_id
		FROM doc_material_procurements
		WHERE cement_silos_id = NEW.cement_silo_id
		ORDER BY date_time DESC
		LIMIT 1;
		
		
		--v_material_id = material_in_silo_on_date(NEW.cement_silo_id, NEW.date_time);
		
		IF coalesce(v_material_id,0)>0 AND v_quant<>0 THEN		
			--здесь определяем свое количество по регистру материалов
			--SELECT rg.quant INTO v_quant FROM rg_material_facts_balance(NEW.date_time,ARRAY[v_material_id]) AS rg;					
			--v_quant = NEW.quant_required - coalesce(v_quant,0);
			
			--RAISE EXCEPTION 'v_quant=%',v_quant;
			IF v_quant<>0 THEN			
				reg_material_facts.date_time		= NEW.date_time;
				reg_material_facts.deb			= (v_quant>0);
				reg_material_facts.doc_type  		= 'cement_silo_balance_reset'::doc_types;
				reg_material_facts.doc_id  		= NEW.id;
				reg_material_facts.material_id		= v_material_id;
				reg_material_facts.production_base_id	= (
						SELECT production_base_id
						FROM production_sites
						WHERE id = (SELECT production_site_id FROM cement_silos WHERE id=NEW.cement_silo_id)
				);
				reg_material_facts.quant		= abs(v_quant);
				PERFORM ra_material_facts_add_act(reg_material_facts);	
			END IF;
		END IF;			
		
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',NEW.date_time::date
				)
			)::text
		);
		
		RETURN NEW;
		
	ELSEIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		IF NEW.date_time<>OLD.date_time THEN
			PERFORM doc_log_update('cement_silo_balance_reset'::doc_types,NEW.id,NEW.date_time);
		END IF;

		PERFORM ra_cement_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		
		RETURN NEW;
		
	ELSEIF TG_OP='DELETE' THEN
		IF TG_WHEN='BEFORE' THEN		
			--log
			PERFORM doc_log_delete('cement_silo_balance_reset'::doc_types,OLD.id);

			PERFORM ra_cement_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
			PERFORM ra_material_facts_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		ELSE
			--Event support
			PERFORM pg_notify(
					'RAMaterialFact.change'
				,json_build_object(
					'params',json_build_object(
						'cond_date',OLD.date_time::date
					)
				)::text
			);
		END IF;
	
		RETURN OLD;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.cement_silo_balance_resets_process()
  OWNER TO beton;



-- ******************* update 23/04/2024 14:39:33 ******************
-- Function: public.cement_silo_balance_resets_process()

-- DROP FUNCTION public.cement_silo_balance_resets_process();

CREATE OR REPLACE FUNCTION public.cement_silo_balance_resets_process()
  RETURNS trigger AS
$BODY$
DECLARE
	reg_cement ra_cement%ROWTYPE;
	reg_material_facts ra_material_facts%ROWTYPE;
	v_quant numeric(19,4);
	v_material_id int;
BEGIN
	IF (TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') ) THEN
		IF (TG_OP='INSERT') THEN						
			--log
			PERFORM doc_log_insert('cement_silo_balance_reset'::doc_types,NEW.id,NEW.date_time);
		END IF;
	
		SELECT rg.quant INTO v_quant FROM rg_cement_balance(NEW.date_time,ARRAY[NEW.cement_silo_id]) AS rg;		
		v_quant = NEW.quant_required - coalesce(v_quant,0);
		IF v_quant<>0 THEN
			--register actions ra_cement
			reg_cement.date_time		= NEW.date_time;
			reg_cement.deb			= (v_quant>0);
			reg_cement.doc_type  		= 'cement_silo_balance_reset'::doc_types;
			reg_cement.doc_id  		= NEW.id;
			reg_cement.cement_silos_id	= NEW.cement_silo_id;
			reg_cement.quant		= abs(v_quant);
			PERFORM ra_cement_add_act(reg_cement);				
		END IF;
		
		--Остатки материалов, материал определить по последнему приходу в силос
		
		SELECT material_id
		INTO v_material_id
		FROM doc_material_procurements
		WHERE cement_silos_id = NEW.cement_silo_id
		ORDER BY date_time DESC
		LIMIT 1;
		
		
		--v_material_id = material_in_silo_on_date(NEW.cement_silo_id, NEW.date_time);
		
		IF coalesce(v_material_id,0)>0 AND v_quant<>0 THEN		
			--здесь определяем свое количество по регистру материалов
			--SELECT rg.quant INTO v_quant FROM rg_material_facts_balance(NEW.date_time,ARRAY[v_material_id]) AS rg;					
			--v_quant = NEW.quant_required - coalesce(v_quant,0);
			
			--RAISE EXCEPTION 'v_quant=%',v_quant;
			IF v_quant<>0 THEN			
				reg_material_facts.date_time		= NEW.date_time;
				reg_material_facts.deb			= (v_quant>0);
				reg_material_facts.doc_type  		= 'cement_silo_balance_reset'::doc_types;
				reg_material_facts.doc_id  		= NEW.id;
				reg_material_facts.material_id		= v_material_id;
				reg_material_facts.production_base_id	= (
						SELECT production_base_id
						FROM production_sites
						WHERE id = (SELECT production_site_id FROM cement_silos WHERE id=NEW.cement_silo_id)
				);
				reg_material_facts.quant		= abs(v_quant);
				PERFORM ra_material_facts_add_act(reg_material_facts);	
			END IF;
		END IF;			
		
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',NEW.date_time::date
				)
			)::text
		);
		
		RETURN NEW;
		
	ELSEIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		IF NEW.date_time<>OLD.date_time THEN
			PERFORM doc_log_update('cement_silo_balance_reset'::doc_types,NEW.id,NEW.date_time);
		END IF;

		PERFORM ra_cement_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		
		RETURN NEW;
		
	ELSEIF TG_OP='DELETE' THEN
		IF TG_WHEN='BEFORE' THEN		
			--log
			PERFORM doc_log_delete('cement_silo_balance_reset'::doc_types,OLD.id);

			PERFORM ra_cement_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
			PERFORM ra_material_facts_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		ELSE
			--Event support
			PERFORM pg_notify(
					'RAMaterialFact.change'
				,json_build_object(
					'params',json_build_object(
						'cond_date',OLD.date_time::date
					)
				)::text
			);
		END IF;
	
		RETURN OLD;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.cement_silo_balance_resets_process()
  OWNER TO beton;



-- ******************* update 23/04/2024 14:42:29 ******************
-- Function: public.doc_material_procurements_process()

-- DROP FUNCTION public.doc_material_procurements_process();

CREATE OR REPLACE FUNCTION public.doc_material_procurements_process()
  RETURNS trigger AS
$BODY$
DECLARE
	reg_act ra_materials%ROWTYPE;
	reg_material_facts ra_material_facts%ROWTYPE;
	reg_cement ra_cement%ROWTYPE;
	v_dif_store bool;
	v_production_site_id int;
BEGIN
	IF (TG_WHEN='BEFORE' AND TG_OP='INSERT') THEN
		IF NEW.date_time < '2024-01-01T00:00:00'::timestamp THEN
			RAISE EXCEPTION 'Дата запрета редактирования: %', '2024-01-01T00:00:00'::timestamp;
		END IF;
		
		-- Временно ОТ ВЕСОВ!!!
		IF NEW.production_base_id IS NULL THEN
			NEW.production_base_id = 1;
		END IF;	
		
		--Обнудение материал = БЕТОН
		IF NEW.material_id = 1240 THEN
			NEW.quant_net = 0;
			NEW.quant_gross = 0;
		END IF;
		
		--Если это из горного - обнулить по документам
		IF coalesce(NEW.doc_ref_gornyi, '') <> ''
		THEN
			NEW.doc_quant_gross = 0;
			NEW.doc_quant_net = 0;
		END IF;
		
		RETURN NEW;
		
	ELSIF (TG_WHEN='AFTER') AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN					
		IF (TG_OP='INSERT') THEN						
			--log
			PERFORM doc_log_insert('material_procurement'::doc_types,NEW.id,NEW.date_time);
		END IF;

		--register actions ra_materials
		reg_act.date_time		= NEW.date_time;
		reg_act.deb			= true;
		reg_act.doc_type  		= 'material_procurement'::doc_types;
		reg_act.doc_id  		= NEW.id;
		reg_act.production_base_id	= NEW.production_base_id;
		reg_act.material_id		= NEW.material_id;
		reg_act.quant			= NEW.quant_net;
		PERFORM ra_materials_add_act(reg_act);	
		
		SELECT dif_store INTO v_dif_store FROM raw_materials WHERE id=NEW.material_id;
		--По материалам делаем всегда движения, а если есть учет по силосам и есть силос - то и по силосам
		--Если учет по заводам (v_dif_store==TRUE)- то по заводам
		--register actions ra_material_facts
		reg_material_facts.date_time		= NEW.date_time;
		reg_material_facts.deb			= true;
		reg_material_facts.doc_type  		= 'material_procurement'::doc_types;
		reg_material_facts.doc_id  		= NEW.id;
		reg_material_facts.material_id		= NEW.material_id;
		reg_material_facts.production_base_id	= NEW.production_base_id;
		
		IF coalesce(v_dif_store,FALSE) AND coalesce(NEW.store,'')<>'' THEN
			--Определить завод по приходу
			SELECT production_site_id INTO v_production_site_id FROM store_map_to_production_sites WHERE store = NEW.store;
			--RAISE EXCEPTION 'v_production_site_id=%',v_production_site_id;
			IF v_production_site_id IS NULL THEN
				-- no match!
				INSERT INTO store_map_to_production_sites (store) VALUES (NEW.store);
			END IF;
			reg_material_facts.production_site_id = v_production_site_id;
		END IF;
		reg_material_facts.quant		= NEW.quant_net;
		PERFORM ra_material_facts_add_act(reg_material_facts);	
		
		IF coalesce( (SELECT is_cement FROM raw_materials WHERE id = NEW.material_id),FALSE)
		AND NEW.cement_silos_id IS NOT NULL THEN
			--register actions ra_cement
			reg_cement.date_time		= NEW.date_time;
			reg_cement.deb			= true;
			reg_cement.doc_type  		= 'material_procurement'::doc_types;
			reg_cement.doc_id  		= NEW.id;
			reg_cement.cement_silos_id	= NEW.cement_silos_id;
			reg_cement.quant		= NEW.quant_net;
			PERFORM ra_cement_add_act(reg_cement);	
			
		END IF;
			
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',NEW.date_time::date
				)
			)::text
		);
				
		RETURN NEW;
		
	ELSIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		IF NEW.date_time < '2024-01-01T00:00:00'::timestamp THEN
			RAISE EXCEPTION 'Дата запрета редактирования: %', '2024-01-01T00:00:00'::timestamp;
		END IF;
	
		-- Временно ОТ ВЕСОВ!!!
		IF NEW.production_base_id IS NULL THEN
			NEW.production_base_id = 1;
		END IF;	
	
		PERFORM ra_materials_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_cement_remove_acts('material_procurement'::doc_types,OLD.id);

		--Если это из горного - обнулить по документам
		IF coalesce(NEW.doc_ref_gornyi, '') <> ''
		AND (coalesce(NEW.doc_quant_gross,0)<>0 OR coalesce(NEW.doc_quant_net,0)<>0)
		THEN
			NEW.doc_quant_gross = 0;
			NEW.doc_quant_net = 0;
		END IF;


		IF NEW.date_time<>OLD.date_time THEN
			PERFORM doc_log_update('material_procurement'::doc_types,NEW.id,NEW.date_time);
		END IF;
						
		RETURN NEW;
		
	ELSIF (TG_WHEN='AFTER' AND TG_OP='DELETE') THEN
	
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',OLD.date_time::date
				)
			)::text
		);
	
		RETURN OLD;
	ELSIF (TG_WHEN='BEFORE' AND TG_OP='DELETE') THEN
		IF OLD.date_time < '2024-01-01T00:00:00'::timestamp THEN
			RAISE EXCEPTION 'Дата запрета редактирования: %', '2024-01-01T00:00:00'::timestamp;
		END IF;
	
		--detail tables
		
		--register actions										
		PERFORM ra_materials_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_cement_remove_acts('material_procurement'::doc_types,OLD.id);
		
		--log
		PERFORM doc_log_delete('material_procurement'::doc_types,OLD.id);
		
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.doc_material_procurements_process()
  OWNER TO beton;



-- ******************* update 23/04/2024 16:11:07 ******************
-- Function: public.cement_silo_balance_resets_process()

-- DROP FUNCTION public.cement_silo_balance_resets_process();

CREATE OR REPLACE FUNCTION public.cement_silo_balance_resets_process()
  RETURNS trigger AS
$BODY$
DECLARE
	reg_cement ra_cement%ROWTYPE;
	reg_material_facts ra_material_facts%ROWTYPE;
	v_quant numeric(19,4);
	v_material_id int;
BEGIN
	IF (TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') ) THEN
		IF (TG_OP='INSERT') THEN						
			--log
			PERFORM doc_log_insert('cement_silo_balance_reset'::doc_types,NEW.id,NEW.date_time);
		END IF;
	
		SELECT rg.quant INTO v_quant FROM rg_cement_balance(NEW.date_time,ARRAY[NEW.cement_silo_id]) AS rg;		
		v_quant = NEW.quant_required - coalesce(v_quant,0);
		RAISE EXCEPTION 'v_quant=%', v_quant;
		IF v_quant<>0 THEN
			--register actions ra_cement
			reg_cement.date_time		= NEW.date_time;
			reg_cement.deb			= (v_quant>0);
			reg_cement.doc_type  		= 'cement_silo_balance_reset'::doc_types;
			reg_cement.doc_id  		= NEW.id;
			reg_cement.cement_silos_id	= NEW.cement_silo_id;
			reg_cement.quant		= abs(v_quant);
			PERFORM ra_cement_add_act(reg_cement);				
		END IF;
		
		--Остатки материалов, материал определить по последнему приходу в силос
		
		SELECT material_id
		INTO v_material_id
		FROM doc_material_procurements
		WHERE cement_silos_id = NEW.cement_silo_id
		ORDER BY date_time DESC
		LIMIT 1;
		
		
		--v_material_id = material_in_silo_on_date(NEW.cement_silo_id, NEW.date_time);
		
		IF coalesce(v_material_id,0)>0 AND v_quant<>0 THEN		
			--здесь определяем свое количество по регистру материалов
			--SELECT rg.quant INTO v_quant FROM rg_material_facts_balance(NEW.date_time,ARRAY[v_material_id]) AS rg;					
			--v_quant = NEW.quant_required - coalesce(v_quant,0);
			
			--RAISE EXCEPTION 'v_quant=%',v_quant;
			IF v_quant<>0 THEN			
				reg_material_facts.date_time		= NEW.date_time;
				reg_material_facts.deb			= (v_quant>0);
				reg_material_facts.doc_type  		= 'cement_silo_balance_reset'::doc_types;
				reg_material_facts.doc_id  		= NEW.id;
				reg_material_facts.material_id		= v_material_id;
				reg_material_facts.production_base_id	= (
						SELECT production_base_id
						FROM production_sites
						WHERE id = (SELECT production_site_id FROM cement_silos WHERE id=NEW.cement_silo_id)
				);
				reg_material_facts.quant		= abs(v_quant);
				PERFORM ra_material_facts_add_act(reg_material_facts);	
			END IF;
		END IF;			
		
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',NEW.date_time::date
				)
			)::text
		);
		
		RETURN NEW;
		
	ELSEIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		IF NEW.date_time<>OLD.date_time THEN
			PERFORM doc_log_update('cement_silo_balance_reset'::doc_types,NEW.id,NEW.date_time);
		END IF;

		PERFORM ra_cement_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		
		RETURN NEW;
		
	ELSEIF TG_OP='DELETE' THEN
		IF TG_WHEN='BEFORE' THEN		
			--log
			PERFORM doc_log_delete('cement_silo_balance_reset'::doc_types,OLD.id);

			PERFORM ra_cement_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
			PERFORM ra_material_facts_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		ELSE
			--Event support
			PERFORM pg_notify(
					'RAMaterialFact.change'
				,json_build_object(
					'params',json_build_object(
						'cond_date',OLD.date_time::date
					)
				)::text
			);
		END IF;
	
		RETURN OLD;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.cement_silo_balance_resets_process()
  OWNER TO beton;



-- ******************* update 23/04/2024 16:11:23 ******************
-- Function: public.cement_silo_balance_resets_process()

-- DROP FUNCTION public.cement_silo_balance_resets_process();

CREATE OR REPLACE FUNCTION public.cement_silo_balance_resets_process()
  RETURNS trigger AS
$BODY$
DECLARE
	reg_cement ra_cement%ROWTYPE;
	reg_material_facts ra_material_facts%ROWTYPE;
	v_quant numeric(19,4);
	v_material_id int;
BEGIN
	IF (TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') ) THEN
		IF (TG_OP='INSERT') THEN						
			--log
			PERFORM doc_log_insert('cement_silo_balance_reset'::doc_types,NEW.id,NEW.date_time);
		END IF;
	
		SELECT rg.quant INTO v_quant FROM rg_cement_balance(NEW.date_time,ARRAY[NEW.cement_silo_id]) AS rg;		
		v_quant = NEW.quant_required - coalesce(v_quant,0);
		--RAISE EXCEPTION 'v_quant=%', v_quant;
		IF v_quant<>0 THEN
			--register actions ra_cement
			reg_cement.date_time		= NEW.date_time;
			reg_cement.deb			= (v_quant>0);
			reg_cement.doc_type  		= 'cement_silo_balance_reset'::doc_types;
			reg_cement.doc_id  		= NEW.id;
			reg_cement.cement_silos_id	= NEW.cement_silo_id;
			reg_cement.quant		= abs(v_quant);
			PERFORM ra_cement_add_act(reg_cement);				
		END IF;
		
		--Остатки материалов, материал определить по последнему приходу в силос
		
		SELECT material_id
		INTO v_material_id
		FROM doc_material_procurements
		WHERE cement_silos_id = NEW.cement_silo_id
		ORDER BY date_time DESC
		LIMIT 1;
		
		
		--v_material_id = material_in_silo_on_date(NEW.cement_silo_id, NEW.date_time);
		
		IF coalesce(v_material_id,0)>0 AND v_quant<>0 THEN		
			--здесь определяем свое количество по регистру материалов
			--SELECT rg.quant INTO v_quant FROM rg_material_facts_balance(NEW.date_time,ARRAY[v_material_id]) AS rg;					
			--v_quant = NEW.quant_required - coalesce(v_quant,0);
			
			--RAISE EXCEPTION 'v_quant=%',v_quant;
			IF v_quant<>0 THEN			
				reg_material_facts.date_time		= NEW.date_time;
				reg_material_facts.deb			= (v_quant>0);
				reg_material_facts.doc_type  		= 'cement_silo_balance_reset'::doc_types;
				reg_material_facts.doc_id  		= NEW.id;
				reg_material_facts.material_id		= v_material_id;
				reg_material_facts.production_base_id	= (
						SELECT production_base_id
						FROM production_sites
						WHERE id = (SELECT production_site_id FROM cement_silos WHERE id=NEW.cement_silo_id)
				);
				reg_material_facts.quant		= abs(v_quant);
				PERFORM ra_material_facts_add_act(reg_material_facts);	
			END IF;
		END IF;			
		
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',NEW.date_time::date
				)
			)::text
		);
		
		RETURN NEW;
		
	ELSEIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		IF NEW.date_time<>OLD.date_time THEN
			PERFORM doc_log_update('cement_silo_balance_reset'::doc_types,NEW.id,NEW.date_time);
		END IF;

		PERFORM ra_cement_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		
		RETURN NEW;
		
	ELSEIF TG_OP='DELETE' THEN
		IF TG_WHEN='BEFORE' THEN		
			--log
			PERFORM doc_log_delete('cement_silo_balance_reset'::doc_types,OLD.id);

			PERFORM ra_cement_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
			PERFORM ra_material_facts_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		ELSE
			--Event support
			PERFORM pg_notify(
					'RAMaterialFact.change'
				,json_build_object(
					'params',json_build_object(
						'cond_date',OLD.date_time::date
					)
				)::text
			);
		END IF;
	
		RETURN OLD;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.cement_silo_balance_resets_process()
  OWNER TO beton;



-- ******************* update 23/04/2024 16:19:04 ******************
-- Function: public.cement_silo_balance_resets_process()

-- DROP FUNCTION public.cement_silo_balance_resets_process();

CREATE OR REPLACE FUNCTION public.cement_silo_balance_resets_process()
  RETURNS trigger AS
$BODY$
DECLARE
	reg_cement ra_cement%ROWTYPE;
	reg_material_facts ra_material_facts%ROWTYPE;
	v_quant numeric(19,4);
	v_material_id int;
BEGIN
	IF (TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') ) THEN
		IF (TG_OP='INSERT') THEN						
			--log
			PERFORM doc_log_insert('cement_silo_balance_reset'::doc_types,NEW.id,NEW.date_time);
		END IF;
	
		SELECT rg.quant INTO v_quant FROM rg_cement_balance(NEW.date_time, ARRAY[NEW.cement_silo_id]) AS rg;		
		
		RAISE EXCEPTION 'v_quant=%, cement_silo_id=%', v_quant, NEW.cement_silo_id;
		v_quant = NEW.quant_required - coalesce(v_quant,0);
		--RAISE EXCEPTION 'v_quant=%', v_quant;
		IF v_quant<>0 THEN
			--register actions ra_cement
			reg_cement.date_time		= NEW.date_time;
			reg_cement.deb			= (v_quant>0);
			reg_cement.doc_type  		= 'cement_silo_balance_reset'::doc_types;
			reg_cement.doc_id  		= NEW.id;
			reg_cement.cement_silos_id	= NEW.cement_silo_id;
			reg_cement.quant		= abs(v_quant);
			PERFORM ra_cement_add_act(reg_cement);				
		END IF;
		
		--Остатки материалов, материал определить по последнему приходу в силос
		
		SELECT material_id
		INTO v_material_id
		FROM doc_material_procurements
		WHERE cement_silos_id = NEW.cement_silo_id
		ORDER BY date_time DESC
		LIMIT 1;
		
		
		--v_material_id = material_in_silo_on_date(NEW.cement_silo_id, NEW.date_time);
		
		IF coalesce(v_material_id,0)>0 AND v_quant<>0 THEN		
			--здесь определяем свое количество по регистру материалов
			--SELECT rg.quant INTO v_quant FROM rg_material_facts_balance(NEW.date_time,ARRAY[v_material_id]) AS rg;					
			--v_quant = NEW.quant_required - coalesce(v_quant,0);
			
			--RAISE EXCEPTION 'v_quant=%',v_quant;
			IF v_quant<>0 THEN			
				reg_material_facts.date_time		= NEW.date_time;
				reg_material_facts.deb			= (v_quant>0);
				reg_material_facts.doc_type  		= 'cement_silo_balance_reset'::doc_types;
				reg_material_facts.doc_id  		= NEW.id;
				reg_material_facts.material_id		= v_material_id;
				reg_material_facts.production_base_id	= (
						SELECT production_base_id
						FROM production_sites
						WHERE id = (SELECT production_site_id FROM cement_silos WHERE id=NEW.cement_silo_id)
				);
				reg_material_facts.quant		= abs(v_quant);
				PERFORM ra_material_facts_add_act(reg_material_facts);	
			END IF;
		END IF;			
		
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',NEW.date_time::date
				)
			)::text
		);
		
		RETURN NEW;
		
	ELSEIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		IF NEW.date_time<>OLD.date_time THEN
			PERFORM doc_log_update('cement_silo_balance_reset'::doc_types,NEW.id,NEW.date_time);
		END IF;

		PERFORM ra_cement_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		
		RETURN NEW;
		
	ELSEIF TG_OP='DELETE' THEN
		IF TG_WHEN='BEFORE' THEN		
			--log
			PERFORM doc_log_delete('cement_silo_balance_reset'::doc_types,OLD.id);

			PERFORM ra_cement_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
			PERFORM ra_material_facts_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		ELSE
			--Event support
			PERFORM pg_notify(
					'RAMaterialFact.change'
				,json_build_object(
					'params',json_build_object(
						'cond_date',OLD.date_time::date
					)
				)::text
			);
		END IF;
	
		RETURN OLD;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.cement_silo_balance_resets_process()
  OWNER TO beton;



-- ******************* update 23/04/2024 16:20:16 ******************
-- Function: public.cement_silo_balance_resets_process()

-- DROP FUNCTION public.cement_silo_balance_resets_process();

CREATE OR REPLACE FUNCTION public.cement_silo_balance_resets_process()
  RETURNS trigger AS
$BODY$
DECLARE
	reg_cement ra_cement%ROWTYPE;
	reg_material_facts ra_material_facts%ROWTYPE;
	v_quant numeric(19,4);
	v_material_id int;
BEGIN
	IF (TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') ) THEN
		IF (TG_OP='INSERT') THEN						
			--log
			PERFORM doc_log_insert('cement_silo_balance_reset'::doc_types,NEW.id,NEW.date_time);
		END IF;
	
		SELECT rg.quant INTO v_quant FROM rg_cement_balance(NEW.date_time, ARRAY[NEW.cement_silo_id]) AS rg;		
		
		RAISE EXCEPTION 'v_quant=%, cement_silo_id=%', v_quant, NEW.cement_silo_id;
		v_quant = NEW.quant_required - coalesce(v_quant,0);
		--RAISE EXCEPTION 'v_quant=%', v_quant;
		IF v_quant<>0 THEN
			--register actions ra_cement
			reg_cement.date_time		= NEW.date_time;
			reg_cement.deb			= (v_quant>0);
			reg_cement.doc_type  		= 'cement_silo_balance_reset'::doc_types;
			reg_cement.doc_id  		= NEW.id;
			reg_cement.cement_silos_id	= NEW.cement_silo_id;
			reg_cement.quant		= abs(v_quant);
			PERFORM ra_cement_add_act(reg_cement);				
		END IF;
		
		--Остатки материалов, материал определить по последнему приходу в силос
		
		SELECT material_id
		INTO v_material_id
		FROM doc_material_procurements
		WHERE cement_silos_id = NEW.cement_silo_id
		ORDER BY date_time DESC
		LIMIT 1;
		
		
		--v_material_id = material_in_silo_on_date(NEW.cement_silo_id, NEW.date_time);
		
		IF coalesce(v_material_id,0)>0 AND v_quant<>0 THEN		
			--здесь определяем свое количество по регистру материалов
			--SELECT rg.quant INTO v_quant FROM rg_material_facts_balance(NEW.date_time,ARRAY[v_material_id]) AS rg;					
			--v_quant = NEW.quant_required - coalesce(v_quant,0);
			
			--RAISE EXCEPTION 'v_quant=%',v_quant;
			IF v_quant<>0 THEN			
				reg_material_facts.date_time		= NEW.date_time;
				reg_material_facts.deb			= (v_quant>0);
				reg_material_facts.doc_type  		= 'cement_silo_balance_reset'::doc_types;
				reg_material_facts.doc_id  		= NEW.id;
				reg_material_facts.material_id		= v_material_id;
				reg_material_facts.production_base_id	= (
						SELECT production_base_id
						FROM production_sites
						WHERE id = (SELECT production_site_id FROM cement_silos WHERE id=NEW.cement_silo_id)
				);
				reg_material_facts.quant		= abs(v_quant);
				PERFORM ra_material_facts_add_act(reg_material_facts);	
			END IF;
		END IF;			
		
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',NEW.date_time::date
				)
			)::text
		);
		
		RETURN NEW;
		
	ELSEIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		IF NEW.date_time<>OLD.date_time THEN
			PERFORM doc_log_update('cement_silo_balance_reset'::doc_types,NEW.id,NEW.date_time);
		END IF;

		PERFORM ra_cement_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		
		RETURN NEW;
		
	ELSEIF TG_OP='DELETE' THEN
		IF TG_WHEN='BEFORE' THEN		
			--log
			PERFORM doc_log_delete('cement_silo_balance_reset'::doc_types,OLD.id);

			PERFORM ra_cement_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
			PERFORM ra_material_facts_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		ELSE
			--Event support
			PERFORM pg_notify(
					'RAMaterialFact.change'
				,json_build_object(
					'params',json_build_object(
						'cond_date',OLD.date_time::date
					)
				)::text
			);
		END IF;
	
		RETURN OLD;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.cement_silo_balance_resets_process()
  OWNER TO beton;



-- ******************* update 23/04/2024 16:20:34 ******************
-- Function: public.cement_silo_balance_resets_process()

-- DROP FUNCTION public.cement_silo_balance_resets_process();

CREATE OR REPLACE FUNCTION public.cement_silo_balance_resets_process()
  RETURNS trigger AS
$BODY$
DECLARE
	reg_cement ra_cement%ROWTYPE;
	reg_material_facts ra_material_facts%ROWTYPE;
	v_quant numeric(19,4);
	v_material_id int;
BEGIN
	IF (TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') ) THEN
		IF (TG_OP='INSERT') THEN						
			--log
			PERFORM doc_log_insert('cement_silo_balance_reset'::doc_types,NEW.id,NEW.date_time);
		END IF;
	
		SELECT rg.quant INTO v_quant FROM rg_cement_balance(NEW.date_time, ARRAY[NEW.cement_silo_id]) AS rg;		
		
		--RAISE EXCEPTION 'v_quant=%, cement_silo_id=%', v_quant, NEW.cement_silo_id;
		v_quant = NEW.quant_required - coalesce(v_quant,0);
		--RAISE EXCEPTION 'v_quant=%', v_quant;
		IF v_quant<>0 THEN
			--register actions ra_cement
			reg_cement.date_time		= NEW.date_time;
			reg_cement.deb			= (v_quant>0);
			reg_cement.doc_type  		= 'cement_silo_balance_reset'::doc_types;
			reg_cement.doc_id  		= NEW.id;
			reg_cement.cement_silos_id	= NEW.cement_silo_id;
			reg_cement.quant		= abs(v_quant);
			PERFORM ra_cement_add_act(reg_cement);				
		END IF;
		
		--Остатки материалов, материал определить по последнему приходу в силос
		
		SELECT material_id
		INTO v_material_id
		FROM doc_material_procurements
		WHERE cement_silos_id = NEW.cement_silo_id
		ORDER BY date_time DESC
		LIMIT 1;
		
		
		--v_material_id = material_in_silo_on_date(NEW.cement_silo_id, NEW.date_time);
		
		IF coalesce(v_material_id,0)>0 AND v_quant<>0 THEN		
			--здесь определяем свое количество по регистру материалов
			--SELECT rg.quant INTO v_quant FROM rg_material_facts_balance(NEW.date_time,ARRAY[v_material_id]) AS rg;					
			--v_quant = NEW.quant_required - coalesce(v_quant,0);
			
			--RAISE EXCEPTION 'v_quant=%',v_quant;
			IF v_quant<>0 THEN			
				reg_material_facts.date_time		= NEW.date_time;
				reg_material_facts.deb			= (v_quant>0);
				reg_material_facts.doc_type  		= 'cement_silo_balance_reset'::doc_types;
				reg_material_facts.doc_id  		= NEW.id;
				reg_material_facts.material_id		= v_material_id;
				reg_material_facts.production_base_id	= (
						SELECT production_base_id
						FROM production_sites
						WHERE id = (SELECT production_site_id FROM cement_silos WHERE id=NEW.cement_silo_id)
				);
				reg_material_facts.quant		= abs(v_quant);
				PERFORM ra_material_facts_add_act(reg_material_facts);	
			END IF;
		END IF;			
		
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',NEW.date_time::date
				)
			)::text
		);
		
		RETURN NEW;
		
	ELSEIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		IF NEW.date_time<>OLD.date_time THEN
			PERFORM doc_log_update('cement_silo_balance_reset'::doc_types,NEW.id,NEW.date_time);
		END IF;

		PERFORM ra_cement_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		
		RETURN NEW;
		
	ELSEIF TG_OP='DELETE' THEN
		IF TG_WHEN='BEFORE' THEN		
			--log
			PERFORM doc_log_delete('cement_silo_balance_reset'::doc_types,OLD.id);

			PERFORM ra_cement_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
			PERFORM ra_material_facts_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		ELSE
			--Event support
			PERFORM pg_notify(
					'RAMaterialFact.change'
				,json_build_object(
					'params',json_build_object(
						'cond_date',OLD.date_time::date
					)
				)::text
			);
		END IF;
	
		RETURN OLD;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.cement_silo_balance_resets_process()
  OWNER TO beton;



-- ******************* update 23/04/2024 17:41:33 ******************
-- Function: public.cement_silo_balance_resets_process()

-- DROP FUNCTION public.cement_silo_balance_resets_process();

CREATE OR REPLACE FUNCTION public.cement_silo_balance_resets_process()
  RETURNS trigger AS
$BODY$
DECLARE
	reg_cement ra_cement%ROWTYPE;
	reg_material_facts ra_material_facts%ROWTYPE;
	v_quant numeric(19,4);
	v_material_id int;
BEGIN
	IF (TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') ) THEN
		IF (TG_OP='INSERT') THEN						
			--log
			PERFORM doc_log_insert('cement_silo_balance_reset'::doc_types,NEW.id,NEW.date_time);
		END IF;
	
		SELECT rg.quant INTO v_quant FROM rg_cement_balance(NEW.date_time, ARRAY[NEW.cement_silo_id]) AS rg;		
		
		RAISE EXCEPTION 'v_quant=%, cement_silo_id=%', v_quant, NEW.cement_silo_id;
		v_quant = NEW.quant_required - coalesce(v_quant,0);
		--RAISE EXCEPTION 'v_quant=%', v_quant;
		IF v_quant<>0 THEN
			--register actions ra_cement
			reg_cement.date_time		= NEW.date_time;
			reg_cement.deb			= (v_quant>0);
			reg_cement.doc_type  		= 'cement_silo_balance_reset'::doc_types;
			reg_cement.doc_id  		= NEW.id;
			reg_cement.cement_silos_id	= NEW.cement_silo_id;
			reg_cement.quant		= abs(v_quant);
			PERFORM ra_cement_add_act(reg_cement);				
		END IF;
		
		--Остатки материалов, материал определить по последнему приходу в силос
		
		SELECT material_id
		INTO v_material_id
		FROM doc_material_procurements
		WHERE cement_silos_id = NEW.cement_silo_id
		ORDER BY date_time DESC
		LIMIT 1;
		
		
		--v_material_id = material_in_silo_on_date(NEW.cement_silo_id, NEW.date_time);
		
		IF coalesce(v_material_id,0)>0 AND v_quant<>0 THEN		
			--здесь определяем свое количество по регистру материалов
			--SELECT rg.quant INTO v_quant FROM rg_material_facts_balance(NEW.date_time,ARRAY[v_material_id]) AS rg;					
			--v_quant = NEW.quant_required - coalesce(v_quant,0);
			
			--RAISE EXCEPTION 'v_quant=%',v_quant;
			IF v_quant<>0 THEN			
				reg_material_facts.date_time		= NEW.date_time;
				reg_material_facts.deb			= (v_quant>0);
				reg_material_facts.doc_type  		= 'cement_silo_balance_reset'::doc_types;
				reg_material_facts.doc_id  		= NEW.id;
				reg_material_facts.material_id		= v_material_id;
				reg_material_facts.production_base_id	= (
						SELECT production_base_id
						FROM production_sites
						WHERE id = (SELECT production_site_id FROM cement_silos WHERE id=NEW.cement_silo_id)
				);
				reg_material_facts.quant		= abs(v_quant);
				PERFORM ra_material_facts_add_act(reg_material_facts);	
			END IF;
		END IF;			
		
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',NEW.date_time::date
				)
			)::text
		);
		
		RETURN NEW;
		
	ELSEIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		IF NEW.date_time<>OLD.date_time THEN
			PERFORM doc_log_update('cement_silo_balance_reset'::doc_types,NEW.id,NEW.date_time);
		END IF;

		PERFORM ra_cement_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		
		RETURN NEW;
		
	ELSEIF TG_OP='DELETE' THEN
		IF TG_WHEN='BEFORE' THEN		
			--log
			PERFORM doc_log_delete('cement_silo_balance_reset'::doc_types,OLD.id);

			PERFORM ra_cement_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
			PERFORM ra_material_facts_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		ELSE
			--Event support
			PERFORM pg_notify(
					'RAMaterialFact.change'
				,json_build_object(
					'params',json_build_object(
						'cond_date',OLD.date_time::date
					)
				)::text
			);
		END IF;
	
		RETURN OLD;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.cement_silo_balance_resets_process()
  OWNER TO beton;



-- ******************* update 23/04/2024 17:41:48 ******************
-- Function: public.cement_silo_balance_resets_process()

-- DROP FUNCTION public.cement_silo_balance_resets_process();

CREATE OR REPLACE FUNCTION public.cement_silo_balance_resets_process()
  RETURNS trigger AS
$BODY$
DECLARE
	reg_cement ra_cement%ROWTYPE;
	reg_material_facts ra_material_facts%ROWTYPE;
	v_quant numeric(19,4);
	v_material_id int;
BEGIN
	IF (TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') ) THEN
		IF (TG_OP='INSERT') THEN						
			--log
			PERFORM doc_log_insert('cement_silo_balance_reset'::doc_types,NEW.id,NEW.date_time);
		END IF;
	
		SELECT rg.quant INTO v_quant FROM rg_cement_balance(NEW.date_time, ARRAY[NEW.cement_silo_id]) AS rg;		
		
		--RAISE EXCEPTION 'v_quant=%, cement_silo_id=%', v_quant, NEW.cement_silo_id;
		v_quant = NEW.quant_required - coalesce(v_quant,0);
		--RAISE EXCEPTION 'v_quant=%', v_quant;
		IF v_quant<>0 THEN
			--register actions ra_cement
			reg_cement.date_time		= NEW.date_time;
			reg_cement.deb			= (v_quant>0);
			reg_cement.doc_type  		= 'cement_silo_balance_reset'::doc_types;
			reg_cement.doc_id  		= NEW.id;
			reg_cement.cement_silos_id	= NEW.cement_silo_id;
			reg_cement.quant		= abs(v_quant);
			PERFORM ra_cement_add_act(reg_cement);				
		END IF;
		
		--Остатки материалов, материал определить по последнему приходу в силос
		
		SELECT material_id
		INTO v_material_id
		FROM doc_material_procurements
		WHERE cement_silos_id = NEW.cement_silo_id
		ORDER BY date_time DESC
		LIMIT 1;
		
		
		--v_material_id = material_in_silo_on_date(NEW.cement_silo_id, NEW.date_time);
		
		IF coalesce(v_material_id,0)>0 AND v_quant<>0 THEN		
			--здесь определяем свое количество по регистру материалов
			--SELECT rg.quant INTO v_quant FROM rg_material_facts_balance(NEW.date_time,ARRAY[v_material_id]) AS rg;					
			--v_quant = NEW.quant_required - coalesce(v_quant,0);
			
			--RAISE EXCEPTION 'v_quant=%',v_quant;
			IF v_quant<>0 THEN			
				reg_material_facts.date_time		= NEW.date_time;
				reg_material_facts.deb			= (v_quant>0);
				reg_material_facts.doc_type  		= 'cement_silo_balance_reset'::doc_types;
				reg_material_facts.doc_id  		= NEW.id;
				reg_material_facts.material_id		= v_material_id;
				reg_material_facts.production_base_id	= (
						SELECT production_base_id
						FROM production_sites
						WHERE id = (SELECT production_site_id FROM cement_silos WHERE id=NEW.cement_silo_id)
				);
				reg_material_facts.quant		= abs(v_quant);
				PERFORM ra_material_facts_add_act(reg_material_facts);	
			END IF;
		END IF;			
		
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',NEW.date_time::date
				)
			)::text
		);
		
		RETURN NEW;
		
	ELSEIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		IF NEW.date_time<>OLD.date_time THEN
			PERFORM doc_log_update('cement_silo_balance_reset'::doc_types,NEW.id,NEW.date_time);
		END IF;

		PERFORM ra_cement_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		
		RETURN NEW;
		
	ELSEIF TG_OP='DELETE' THEN
		IF TG_WHEN='BEFORE' THEN		
			--log
			PERFORM doc_log_delete('cement_silo_balance_reset'::doc_types,OLD.id);

			PERFORM ra_cement_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
			PERFORM ra_material_facts_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		ELSE
			--Event support
			PERFORM pg_notify(
					'RAMaterialFact.change'
				,json_build_object(
					'params',json_build_object(
						'cond_date',OLD.date_time::date
					)
				)::text
			);
		END IF;
	
		RETURN OLD;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.cement_silo_balance_resets_process()
  OWNER TO beton;



-- ******************* update 23/04/2024 18:35:48 ******************
-- Function: public.cement_silo_balance_resets_process()

-- DROP FUNCTION public.cement_silo_balance_resets_process();

CREATE OR REPLACE FUNCTION public.cement_silo_balance_resets_process()
  RETURNS trigger AS
$BODY$
DECLARE
	reg_cement ra_cement%ROWTYPE;
	reg_material_facts ra_material_facts%ROWTYPE;
	v_quant numeric(19,4);
	v_material_id int;
BEGIN
	IF (TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') ) THEN
		IF (TG_OP='INSERT') THEN						
			--log
			PERFORM doc_log_insert('cement_silo_balance_reset'::doc_types,NEW.id,NEW.date_time);
		END IF;
	
		SELECT rg.quant INTO v_quant FROM rg_cement_balance(NEW.date_time, ARRAY[NEW.cement_silo_id]) AS rg;		
		
		--RAISE EXCEPTION 'v_quant=%, cement_silo_id=%', v_quant, NEW.cement_silo_id;
		v_quant = NEW.quant_required - coalesce(v_quant,0);
		--RAISE EXCEPTION 'v_quant=%', v_quant;
		IF v_quant<>0 THEN
			--register actions ra_cement
			reg_cement.date_time		= NEW.date_time;
			reg_cement.deb			= (v_quant>0);
			reg_cement.doc_type  		= 'cement_silo_balance_reset'::doc_types;
			reg_cement.doc_id  		= NEW.id;
			reg_cement.cement_silos_id	= NEW.cement_silo_id;
			reg_cement.quant		= abs(v_quant);
			PERFORM ra_cement_add_act(reg_cement);				
		END IF;
		
		--Остатки материалов, материал определить по последнему приходу в силос
		
		/*
		SELECT material_id
		INTO v_material_id
		FROM doc_material_procurements
		WHERE cement_silos_id = NEW.cement_silo_id
		ORDER BY date_time DESC
		LIMIT 1;
		*/
		
		v_material_id = material_in_silo_on_date(NEW.cement_silo_id, NEW.date_time);
		
		IF coalesce(v_material_id,0)>0 AND v_quant<>0 THEN		
			--здесь определяем свое количество по регистру материалов
			--SELECT rg.quant INTO v_quant FROM rg_material_facts_balance(NEW.date_time,ARRAY[v_material_id]) AS rg;					
			--v_quant = NEW.quant_required - coalesce(v_quant,0);
			
			--RAISE EXCEPTION 'v_quant=%',v_quant;
			IF v_quant<>0 THEN			
				reg_material_facts.date_time		= NEW.date_time;
				reg_material_facts.deb			= (v_quant>0);
				reg_material_facts.doc_type  		= 'cement_silo_balance_reset'::doc_types;
				reg_material_facts.doc_id  		= NEW.id;
				reg_material_facts.material_id		= v_material_id;
				reg_material_facts.production_base_id	= (
						SELECT production_base_id
						FROM production_sites
						WHERE id = (SELECT production_site_id FROM cement_silos WHERE id=NEW.cement_silo_id)
				);
				reg_material_facts.quant		= abs(v_quant);
				PERFORM ra_material_facts_add_act(reg_material_facts);	
			END IF;
		END IF;			
		
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',NEW.date_time::date
				)
			)::text
		);
		
		RETURN NEW;
		
	ELSEIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		IF NEW.date_time<>OLD.date_time THEN
			PERFORM doc_log_update('cement_silo_balance_reset'::doc_types,NEW.id,NEW.date_time);
		END IF;

		PERFORM ra_cement_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		
		RETURN NEW;
		
	ELSEIF TG_OP='DELETE' THEN
		IF TG_WHEN='BEFORE' THEN		
			--log
			PERFORM doc_log_delete('cement_silo_balance_reset'::doc_types,OLD.id);

			PERFORM ra_cement_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
			PERFORM ra_material_facts_remove_acts('cement_silo_balance_reset'::doc_types,OLD.id);
		ELSE
			--Event support
			PERFORM pg_notify(
					'RAMaterialFact.change'
				,json_build_object(
					'params',json_build_object(
						'cond_date',OLD.date_time::date
					)
				)::text
			);
		END IF;
	
		RETURN OLD;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.cement_silo_balance_resets_process()
  OWNER TO beton;



-- ******************* update 24/04/2024 11:27:11 ******************
-- Function: logins_process()

-- DROP FUNCTION logins_process();

CREATE OR REPLACE FUNCTION logins_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='UPDATE') THEN
		IF OLD.date_time_out IS NULL AND NEW.date_time_out IS NOT NULL
		AND coalesce(NEW.pub_key,'')<>'' THEN
			--event
			--RAISE EXCEPTION 'pub_key=%',trim(NEW.pub_key);
			-- deprecated event
			PERFORM pg_notify(
				'User.logout'
				,json_build_object(
					'params',json_build_object(
						'pub_key',trim(NEW.pub_key)
					)
				)::text
			);
			
			-- new event trapped by browsers
			PERFORM pg_notify(
				'User.logout.' || md5(trim(NEW.session_id)), NULL
			);			
			
		END IF;
		
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION logins_process()
  OWNER TO beton;



-- ******************* update 24/04/2024 11:32:19 ******************
-- Function: logins_process()

-- DROP FUNCTION logins_process();

CREATE OR REPLACE FUNCTION logins_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='UPDATE') THEN
		IF OLD.date_time_out IS NULL AND NEW.date_time_out IS NOT NULL
		AND coalesce(NEW.pub_key,'')<>'' THEN
			--event
			--RAISE EXCEPTION 'pub_key=%',trim(NEW.pub_key);
			-- deprecated event
			PERFORM pg_notify(
				'User.logout'
				,json_build_object(
					'params',json_build_object(
						'pub_key',trim(NEW.pub_key)
					)
				)::text
			);
			
			-- new event trapped by browsers
			PERFORM pg_notify(
				'User.logout.' || trim(NEW.pub_key), NULL
			);			
			
		END IF;
		
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION logins_process()
  OWNER TO beton;



-- ******************* update 27/04/2024 08:24:46 ******************
-- FUNCTION: public.geo_zone_check()

-- DROP FUNCTION IF EXISTS public.geo_zone_check();

CREATE OR REPLACE FUNCTION public.geo_zone_check()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	v_cur_state vehicle_states;
	v_production_base_id int;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	
	v_zone geometry;
	
	v_st_date_time timestamp without time zone;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;
	v_long_route_rest bool;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;

	--get last state
	WITH
	shift AS (
		SELECT
			d_from,
			d_to
		FROM get_shift_bounds(NEW.recieved_dt + age(now(), now() at time zone 'UTC')) AS (d_from timestamp, d_to timestamp)
	)
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE
		st.tracker_id = NEW.car_id
		AND st.date_time BETWEEN (SELECT d_from FROM shift) AND (SELECT d_to FROM shift)
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF v_cur_state = 'busy'::vehicle_states THEN
			--clients zone on shipment
			SELECT				
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id = shipments.order_id
			LEFT JOIN destinations ON destinations.id = orders.destination_id
			WHERE
				shipments.id = v_shipment_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
			
		ELSIF  v_cur_state = 'at_dest'::vehicle_states THEN
			-- client zone from state
			SELECT
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM destinations
			WHERE
				destinations.id = v_destination_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
		ELSE
			--
			-- base zone
			-- ALL possible zones, NOT const_base_geo_zone_id_val()
			-- returns one zone only
			SELECT
				b.id,
				b.destination_id,
				destinations.zone
			INTO
				v_production_base_id,
				v_destination_id,
				v_zone
			FROM production_bases AS b
			LEFT JOIN destinations ON destinations.id = b.destination_id
			WHERE
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			LIMIT 1			
			;
					
		END IF;		
		
		--if at least the last point inside zone
		IF v_zone IS NOT NULL THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat
					FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid = 1
					ORDER BY t.period DESC
					LIMIT const_geo_zone_check_points_count_val() - 1
					OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					-- v_production_base_id = previous state value
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					-- v_production_base_id = previous state value OR some other logic!!! Куда назначили
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
					--v_production_base_id = Фактическая зона, зона производственной площадки
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id, destination_id, shipment_id, production_base_id)
					VALUES (CURRENT_TIMESTAMP,
						v_schedule_id,
						v_new_state,
						NEW.car_id,
						v_destination_id,
						v_shipment_id,
						v_production_base_id
					);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						--v_cur_state='at_dest' OR 
						WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		/*IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%, v_cur_state=%',v_shipment_id,v_cur_state;
		END IF;*/
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = const_base_geo_zone_id_val()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						/*v_point_in_zone = FALSE;
						SELECT
							st_contains(
								st_transform(
									st_buffer(
										st_transform(
											ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
											,3857
										)
										,30
									)
								,4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
						END IF;
						*/
						
						IF v_destination_id IS NOT NULL AND v_client_id IS NOT NULL THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT (client_id,destination_id) DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;						
						--route done
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										--v_cur_state='at_dest' OR 
										WHEN v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		SELECT (length(v_hypothetical_route_rest_t)>7500) INTO v_long_route_rest;
		IF v_long_route_rest THEN
			INSERT INTO route_rests VALUES(NEW.car_id,v_hypothetical_route_rest_t)
			ON CONFLICT (tracker_id) DO UPDATE SET
			route_rest = v_hypothetical_route_rest_t;
		END IF;
		
		--returns vehicles_last_pos struc + route
		BEGIN
			PERFORM pg_notify(
				'Vehicle.position.'||NEW.car_id
				,json_build_object(
					'params',json_build_object(
						'tracker_id',NEW.car_id
						,'lon',NEW.lon
						,'lat',NEW.lat
						,'heading',NEW.heading
						,'speed',NEW.speed
						,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'ns',NEW.ns
						,'ew',NEW.ew
						,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'odometer',NEW.odometer::text
						,'voltage',round(NEW.voltage,0)
						,'route_rest',CASE WHEN v_long_route_rest THEN NULL ELSE v_hypothetical_route_rest_t END
						,'long_route_rest',v_long_route_rest
						,'route_rest_len',v_hypothetical_route_rest_len
					)
				)::text
			);
		EXCEPTION WHEN OTHERS THEN
		END;
	END IF;

	--from beton to konkrid
	
	IF current_database() = 'beton' THEN
		--all vehicles to konkrid
		INSERT INTO konkrid.bereg_to_konkrid
			VALUES ('CarTracking.to_konkrid',
				json_build_object('params',
					json_build_object('car_id', NEW.car_id, 'period', NEW.period)
				)::text
		);
		
		--whose car?
		--konkrid ownerID=286
		/*		
		IF
			coalesce(
				(SELECT
						(owners.f->'owner'->'keys'->>'id')::int = 286 AS konkrid_owned
				FROM (
					SELECT
							jsonb_array_elements(vehicle_owners->'rows')->'fields' AS f
					FROM vehicles AS v
					WHERE v.tracker_id = NEW.car_id
				) AS owners
				ORDER BY (owners.f->>'dt_from')::timestamp DESC
				LIMIT 1)
			, FALSE
			) THEN
			
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('CarTracking.to_konkrid',
					json_build_object('params',
						json_build_object('car_id', NEW.car_id, 'period', NEW.period)
					)::text
			);
		END IF;
		*/
	END IF;
		
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.geo_zone_check()
    OWNER TO beton;



-- ******************* update 27/04/2024 08:42:16 ******************
-- Function: public.vehicles_process()

-- DROP FUNCTION public.vehicles_process();

CREATE OR REPLACE FUNCTION public.vehicles_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
	
		IF TG_OP='INSERT' OR (OLD.vehicle_owners IS NULL AND NEW.vehicle_owners IS NOT NULL) OR NEW.vehicle_owners<>OLD.vehicle_owners THEN
			SELECT
				array_agg(
					CASE WHEN sub.obj->'fields'->'owner'->'keys'->>'id'='null' THEN NULL
					ELSE (sub.obj->'fields'->'owner'->'keys'->>'id')::int
					END
				)
			INTO NEW.vehicle_owners_ar
			FROM (
				SELECT jsonb_array_elements(NEW.vehicle_owners->'rows') AS obj
			) AS sub		
			;
			
			--last owner
			SELECT
				CASE WHEN owners.row->'fields'->'owner'->'keys'->>'id'='null' THEN NULL 
					ELSE (owners.row->'fields'->'owner'->'keys'->>'id')::int
				END
			INTO NEW.vehicle_owner_id
			FROM
			(
				SELECT jsonb_array_elements(NEW.vehicle_owners->'rows') AS row
			) AS owners
			ORDER BY (owners.row->'fields'->>'dt_from')::timestamp DESC
			LIMIT 1;
		END IF;
		
		--plate number for sorting
		IF TG_OP='INSERT' OR NEW.plate<>OLD.plate THEN
			NEW.plate_n = CASE WHEN regexp_replace(NEW.plate, '\D','','g')='' THEN 0 ELSE regexp_replace(NEW.plate, '\D','','g')::int END;
		END IF;
		
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
		INSERT INTO konkrid.bereg_to_konkrid
			VALUES ('Vehicle.to_konkrid',
				json_build_object('params',
					json_build_object('id', NEW.id, 'old_id', OLD.id)
				)::text
		);
	
	
		RETURN NEW;
		
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.vehicles_process()
  OWNER TO beton;



-- ******************* update 27/04/2024 08:46:00 ******************
-- Function: public.vehicles_process()

-- DROP FUNCTION public.vehicles_process();

CREATE OR REPLACE FUNCTION public.vehicles_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
	
		IF TG_OP='INSERT' OR (OLD.vehicle_owners IS NULL AND NEW.vehicle_owners IS NOT NULL) OR NEW.vehicle_owners<>OLD.vehicle_owners THEN
			SELECT
				array_agg(
					CASE WHEN sub.obj->'fields'->'owner'->'keys'->>'id'='null' THEN NULL
					ELSE (sub.obj->'fields'->'owner'->'keys'->>'id')::int
					END
				)
			INTO NEW.vehicle_owners_ar
			FROM (
				SELECT jsonb_array_elements(NEW.vehicle_owners->'rows') AS obj
			) AS sub		
			;
			
			--last owner
			SELECT
				CASE WHEN owners.row->'fields'->'owner'->'keys'->>'id'='null' THEN NULL 
					ELSE (owners.row->'fields'->'owner'->'keys'->>'id')::int
				END
			INTO NEW.vehicle_owner_id
			FROM
			(
				SELECT jsonb_array_elements(NEW.vehicle_owners->'rows') AS row
			) AS owners
			ORDER BY (owners.row->'fields'->>'dt_from')::timestamp DESC
			LIMIT 1;
		END IF;
		
		--plate number for sorting
		IF TG_OP='INSERT' OR NEW.plate<>OLD.plate THEN
			NEW.plate_n = CASE WHEN regexp_replace(NEW.plate, '\D','','g')='' THEN 0 ELSE regexp_replace(NEW.plate, '\D','','g')::int END;
		END IF;
		
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='UPDATE' THEN
		IF coalesce(NEW.tracker_id,'') <> coalesce(OLD.tracker_id,'') THEN
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('Vehicle.to_konkrid',
					json_build_object('params',
						json_build_object('id', NEW.id)
					)::text
			);
		END IF;
	
		RETURN NEW;

	ELSIF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
		IF coalesce(NEW.tracker_id,'') <> '' THEN
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('Vehicle.to_konkrid',
					json_build_object('params',
						json_build_object('id', NEW.id)
					)::text
			);
		END IF;
	
		RETURN NEW;
		
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.vehicles_process()
  OWNER TO beton;



-- ******************* update 27/04/2024 08:46:59 ******************
-- Trigger: vehicles_before_trigger on vehicles

-- DROP TRIGGER vehicles_before_trigger ON vehicles;

/*
 CREATE TRIGGER vehicles_before_trigger
  BEFORE INSERT OR UPDATE
  ON vehicles
  FOR EACH ROW
  EXECUTE PROCEDURE vehicles_process();
*/

-- Trigger: vehicles_after_trigger on vehicles

-- DROP TRIGGER vehicles_after_trigger ON vehicles;


 CREATE TRIGGER vehicles_after_trigger
  AFTER INSERT OR UPDATE
  ON vehicles
  FOR EACH ROW
  EXECUTE PROCEDURE vehicles_process();



-- ******************* update 27/04/2024 08:52:45 ******************
-- Function: public.vehicles_process()

-- DROP FUNCTION public.vehicles_process();

CREATE OR REPLACE FUNCTION public.vehicles_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
	
		IF TG_OP='INSERT' OR (OLD.vehicle_owners IS NULL AND NEW.vehicle_owners IS NOT NULL) OR NEW.vehicle_owners<>OLD.vehicle_owners THEN
			SELECT
				array_agg(
					CASE WHEN sub.obj->'fields'->'owner'->'keys'->>'id'='null' THEN NULL
					ELSE (sub.obj->'fields'->'owner'->'keys'->>'id')::int
					END
				)
			INTO NEW.vehicle_owners_ar
			FROM (
				SELECT jsonb_array_elements(NEW.vehicle_owners->'rows') AS obj
			) AS sub		
			;
			
			--last owner
			SELECT
				CASE WHEN owners.row->'fields'->'owner'->'keys'->>'id'='null' THEN NULL 
					ELSE (owners.row->'fields'->'owner'->'keys'->>'id')::int
				END
			INTO NEW.vehicle_owner_id
			FROM
			(
				SELECT jsonb_array_elements(NEW.vehicle_owners->'rows') AS row
			) AS owners
			ORDER BY (owners.row->'fields'->>'dt_from')::timestamp DESC
			LIMIT 1;
		END IF;
		
		--plate number for sorting
		IF TG_OP='INSERT' OR NEW.plate<>OLD.plate THEN
			NEW.plate_n = CASE WHEN regexp_replace(NEW.plate, '\D','','g')='' THEN 0 ELSE regexp_replace(NEW.plate, '\D','','g')::int END;
		END IF;
		
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='UPDATE' THEN
		IF coalesce(NEW.tracker_id,'') <> coalesce(OLD.tracker_id,'')
		OR coalesce(NEW.plate,'') <> coalesce(OLD.plate,'') THEN
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('Vehicle.to_konkrid',
					json_build_object('params',
						json_build_object('id', NEW.id)
					)::text
			);
		END IF;
	
		RETURN NEW;

	ELSIF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
		IF coalesce(NEW.tracker_id,'') <> '' THEN
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('Vehicle.to_konkrid',
					json_build_object('params',
						json_build_object('id', NEW.id)
					)::text
			);
		END IF;
	
		RETURN NEW;
		
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.vehicles_process()
  OWNER TO beton;



-- ******************* update 27/04/2024 09:10:58 ******************
-- Trigger: vehicles_before_trigger on vehicles

-- DROP TRIGGER vehicles_before_trigger ON vehicles;

/*
 CREATE TRIGGER vehicles_before_trigger
  BEFORE INSERT OR UPDATE
  ON vehicles
  FOR EACH ROW
  EXECUTE PROCEDURE vehicles_process();
*/

-- Trigger: vehicles_after_trigger on vehicles

 DROP TRIGGER vehicles_after_trigger ON vehicles;

/*
 CREATE TRIGGER vehicles_after_trigger
  AFTER INSERT OR UPDATE
  ON vehicles
  FOR EACH ROW
  EXECUTE PROCEDURE vehicles_process();
*/


-- ******************* update 27/04/2024 09:11:48 ******************
-- Function: public.vehicles_process()

-- DROP FUNCTION public.vehicles_process();

CREATE OR REPLACE FUNCTION public.vehicles_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
	
		IF TG_OP='INSERT' OR (OLD.vehicle_owners IS NULL AND NEW.vehicle_owners IS NOT NULL) OR NEW.vehicle_owners<>OLD.vehicle_owners THEN
			SELECT
				array_agg(
					CASE WHEN sub.obj->'fields'->'owner'->'keys'->>'id'='null' THEN NULL
					ELSE (sub.obj->'fields'->'owner'->'keys'->>'id')::int
					END
				)
			INTO NEW.vehicle_owners_ar
			FROM (
				SELECT jsonb_array_elements(NEW.vehicle_owners->'rows') AS obj
			) AS sub		
			;
			
			--last owner
			SELECT
				CASE WHEN owners.row->'fields'->'owner'->'keys'->>'id'='null' THEN NULL 
					ELSE (owners.row->'fields'->'owner'->'keys'->>'id')::int
				END
			INTO NEW.vehicle_owner_id
			FROM
			(
				SELECT jsonb_array_elements(NEW.vehicle_owners->'rows') AS row
			) AS owners
			ORDER BY (owners.row->'fields'->>'dt_from')::timestamp DESC
			LIMIT 1;
		END IF;
		
		--plate number for sorting
		IF TG_OP='INSERT' OR NEW.plate<>OLD.plate THEN
			NEW.plate_n = CASE WHEN regexp_replace(NEW.plate, '\D','','g')='' THEN 0 ELSE regexp_replace(NEW.plate, '\D','','g')::int END;
		END IF;
		
		RETURN NEW;
	
	--not used as there is no uniquness on plate field	
	/*ELSIF TG_WHEN='AFTER' AND TG_OP='UPDATE' THEN
		IF coalesce(NEW.tracker_id,'') <> coalesce(OLD.tracker_id,'')
		OR coalesce(NEW.plate,'') <> coalesce(OLD.plate,'') THEN
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('Vehicle.to_konkrid',
					json_build_object('params',
						json_build_object('id', NEW.id)
					)::text
			);
		END IF;
	
		RETURN NEW;

	ELSIF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
		IF coalesce(NEW.tracker_id,'') <> '' THEN
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('Vehicle.to_konkrid',
					json_build_object('params',
						json_build_object('id', NEW.id)
					)::text
			);
		END IF;
	
		RETURN NEW;
	*/	
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.vehicles_process()
  OWNER TO beton;



-- ******************* update 27/04/2024 11:37:47 ******************
-- Function: public.set_vehicle_busy()

-- DROP FUNCTION public.set_vehicle_busy();

CREATE OR REPLACE FUNCTION public.set_vehicle_busy()
  RETURNS trigger AS
$BODY$
DECLARE
	dest_id int;
	spec_id int;
	new_state vehicle_states;
	v_feature vehicles.feature%TYPE;
	reg_act ra_material_consumption%ROWTYPE;
	reg_act_mat ra_materials%ROWTYPE;
	v_concrete_type_id int;
	v_vehicle_id int;
	v_driver_id int;
	rate_row RECORD;
	v_avg_dev numeric;
	v_production_base_id int;
	v_tracker_id varchar(15);
BEGIN
	--change state only if 1) insert
	--		       2) update && shipped false==>true
	IF (TG_OP='INSERT') OR (TG_OP='UPDATE' AND OLD.shipped=false AND NEW.shipped) THEN
		IF NEW.shipped THEN
			new_state = 'busy'::vehicle_states;
			
			--if self-shipment && empty feature - set state out
			SELECT
				o.destination_id,
				coalesce(o.client_specification_id, 0)
			INTO
				dest_id,
				spec_id
			FROM orders AS o
			WHERE o.id=NEW.order_id;
			
			IF dest_id = constant_self_ship_dest_id() THEN
				SELECT v.feature INTO v_feature FROM vehicle_schedules AS vs
				LEFT JOIN vehicles AS v ON v.id=vs.vehicle_id
				WHERE vs.id=NEW.vehicle_schedule_id;
				
				IF (v_feature IS NULL) OR (v_feature='') THEN
					new_state = 'out'::vehicle_states;
				END IF;
			END IF;
			
			--specification
			/*IF spec_id > 0 THEN
				INSERT INTO client_specification_flows
				(client_specification_id, shipment_id, quant)
				VALUES (
					spec_id,
					NEW.id,
					NEW.quant
				)
				ON CONFLICT (client_specification_id, shipment_id) DO UPDATE
				SET quant = NEW.quant;
			END IF;*/
		END IF;
		
		v_tracker_id = get_vehicle_tracker_id_on_schedule_id(NEW.vehicle_schedule_id);
		INSERT INTO vehicle_schedule_states
		(date_time, state, shipment_id, schedule_id, tracker_id, destination_id, production_base_id)
		VALUES(
			current_timestamp,
			CASE
			WHEN NEW.shipped THEN
				new_state
			ELSE
				'assigned'::vehicle_states
			END,
			NEW.id,NEW.vehicle_schedule_id,
			v_tracker_id,
			dest_id,
			veh_cur_production_base_id(v_tracker_id)
		);

	END IF;

	IF (TG_OP='INSERT') THEN
		--log
		PERFORM doc_log_insert('shipment'::doc_types,NEW.id,NEW.date_time);
	ELSE
		--IF NEW.ship_date_time<>OLD.ship_date_time THEN
			PERFORM doc_log_update('shipment'::doc_types,NEW.id,NEW.ship_date_time);
		--END IF;			
	END IF;

	IF (TG_OP='INSERT' OR TG_OP='UPDATE') AND (NEW.shipped) THEN	
		SELECT o.concrete_type_id INTO v_concrete_type_id FROM orders AS o WHERE o.id=NEW.order_id;
		SELECT sch.vehicle_id,sch.driver_id INTO v_vehicle_id,v_driver_id FROM vehicle_schedules As sch WHERE sch.id=NEW.vehicle_schedule_id;
		
		--concrete
		--reg acts				
		reg_act.date_time		= NEW.ship_date_time;
		reg_act.doc_type  		= 'shipment'::doc_types;
		reg_act.doc_id  		= NEW.id;
		reg_act.concrete_type_id 	= v_concrete_type_id;
		reg_act.vehicle_id 		= v_vehicle_id;
		reg_act.driver_id 		= v_driver_id;
		reg_act.concrete_quant		= NEW.quant;
		reg_act.material_quant		= 0;
		reg_act.material_quant_norm	= 0;
		PERFORM ra_material_consumption_add_act(reg_act);	


		SELECT production_base_id INTO v_production_base_id
		FROM production_sites
		WHERE id = NEW.production_site_id;
		
		--materials		
		FOR rate_row IN
			SELECT * FROM raw_material_cons_rates(NEW.production_site_id, v_concrete_type_id, NEW.ship_date_time)
		LOOP
			v_avg_dev = 0;--raw_mat_cons_avg_dev(NEW.ship_date_time::date,rate_row.material_id)*NEW.quant;
			
			--reg acts				
			reg_act.date_time		= NEW.ship_date_time;
			reg_act.doc_type  		= 'shipment'::doc_types;
			reg_act.doc_id  		= NEW.id;
			reg_act.concrete_type_id 	= v_concrete_type_id;
			reg_act.vehicle_id 		= v_vehicle_id;
			reg_act.driver_id 		= v_driver_id;			
			reg_act.material_id 		= rate_row.material_id;
			reg_act.material_quant		= (rate_row.rate * NEW.quant) + v_avg_dev;
			reg_act.material_quant_norm	= rate_row.rate * NEW.quant;
			reg_act.material_quant_corrected= (rate_row.rate * NEW.quant) + v_avg_dev;
			reg_act.concrete_quant		= 0;
			PERFORM ra_material_consumption_add_act(reg_act);	

			--reg materials
			reg_act_mat.date_time		= NEW.ship_date_time;
			reg_act_mat.deb			= false;
			reg_act_mat.doc_type  		= 'shipment'::doc_types;
			reg_act_mat.doc_id  		= NEW.id;
			reg_act_mat.production_base_id	= v_production_base_id;
			reg_act_mat.material_id		= rate_row.material_id;
			reg_act_mat.quant		= rate_row.rate*NEW.quant;
			PERFORM ra_materials_add_act(reg_act_mat);	
			
		END LOOP;
		
		--пересчет нарушения норма/факт по производству
		UPDATE productions
		SET
			material_tolerance_violated = productions_get_mat_tolerance_violated(
				production_site_id,
				production_id
			)
		WHERE shipment_id = NEW.id;
		
		--specification
		SELECT
			coalesce(o.client_specification_id, 0)
		INTO
			spec_id
		FROM orders AS o
		WHERE o.id=NEW.order_id;
		
		IF spec_id > 0 THEN
			INSERT INTO client_specification_flows
			(client_specification_id, shipment_id, quant)
			VALUES (
				spec_id,
				NEW.id,
				NEW.quant
			)
			ON CONFLICT (client_specification_id, shipment_id) DO UPDATE
			SET quant = NEW.quant;
		END IF;
		
	END IF;
	
	IF current_database() = 'beton' THEN
		--check if client id Konkrid
		IF
			coalesce(
				(SELECT
					o.client_id = (const_konkrid_client_val()->'keys'->>'id')::int
				FROM orders as o
				WHERE o.id = NEW.order_id)
			, FALSE)
		THEN
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('Shipment.to_konkrid',
					json_build_object('params',
						json_build_object('id', NEW.id)
					)::text
			);
		END IF;
	END IF;
	
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.set_vehicle_busy()
  OWNER TO beton;



-- ******************* update 27/04/2024 12:38:45 ******************

	-- ********** constant value table  reglament_user *************
	CREATE TABLE IF NOT EXISTS const_reglament_user
	(name text, descr text, val json,
		val_type text,ctrl_class text,ctrl_options json, view_class text,view_options json);
	ALTER TABLE const_reglament_user OWNER TO beton;
	INSERT INTO const_reglament_user (name,descr,val,val_type,ctrl_class,ctrl_options,view_class,view_options) VALUES (
		'Пользователь регламент'
		,'Пользователь регламент'
		,NULL
		,'JSON'
		,NULL
		,NULL
		,NULL
		,NULL
	);
		--constant get value
	CREATE OR REPLACE FUNCTION const_reglament_user_val()
	RETURNS json AS
	$BODY$
		SELECT val::json AS val FROM const_reglament_user LIMIT 1;
	$BODY$
	LANGUAGE sql STABLE COST 100;
	ALTER FUNCTION const_reglament_user_val() OWNER TO beton;
	--constant set value
	CREATE OR REPLACE FUNCTION const_reglament_user_set_val(JSON)
	RETURNS void AS
	$BODY$
		UPDATE const_reglament_user SET val=$1;
	$BODY$
	LANGUAGE sql VOLATILE COST 100;
	ALTER FUNCTION const_reglament_user_set_val(JSON) OWNER TO beton;
	--edit view: all keys and descr
	CREATE OR REPLACE VIEW const_reglament_user_view AS
	SELECT
		'reglament_user'::text AS id
		,t.name
		,t.descr
	,
	t.val::text AS val
	,t.val_type::text AS val_type
	,t.ctrl_class::text
	,t.ctrl_options::json
	,t.view_class::text
	,t.view_options::json
	FROM const_reglament_user AS t
	;
	ALTER VIEW const_reglament_user_view OWNER TO beton;
	CREATE OR REPLACE VIEW constants_list_view AS
	SELECT *
	FROM const_doc_per_page_count_view
	UNION ALL
	SELECT *
	FROM const_grid_refresh_interval_view
	UNION ALL
	SELECT *
	FROM const_order_grid_refresh_interval_view
	UNION ALL
	SELECT *
	FROM const_backup_vehicles_feature_view
	UNION ALL
	SELECT *
	FROM const_base_geo_zone_id_view
	UNION ALL
	SELECT *
	FROM const_base_geo_zone_view
	UNION ALL
	SELECT *
	FROM const_chart_step_min_view
	UNION ALL
	SELECT *
	FROM const_day_shift_length_view
	UNION ALL
	SELECT *
	FROM const_days_allowed_with_broken_tracker_view
	UNION ALL
	SELECT *
	FROM const_def_order_unload_speed_view
	UNION ALL
	SELECT *
	FROM const_demurrage_coast_per_hour_view
	UNION ALL
	SELECT *
	FROM const_first_shift_start_time_view
	UNION ALL
	SELECT *
	FROM const_geo_zone_check_points_count_view
	UNION ALL
	SELECT *
	FROM const_map_default_lat_view
	UNION ALL
	SELECT *
	FROM const_map_default_lon_view
	UNION ALL
	SELECT *
	FROM const_max_hour_load_view
	UNION ALL
	SELECT *
	FROM const_max_vehicle_at_work_view
	UNION ALL
	SELECT *
	FROM const_min_demurrage_time_view
	UNION ALL
	SELECT *
	FROM const_min_quant_for_ship_cost_view
	UNION ALL
	SELECT *
	FROM const_no_tracker_signal_warn_interval_view
	UNION ALL
	SELECT *
	FROM const_ord_mark_if_no_ship_time_view
	UNION ALL
	SELECT *
	FROM const_order_auto_place_tolerance_view
	UNION ALL
	SELECT *
	FROM const_order_step_min_view
	UNION ALL
	SELECT *
	FROM const_own_vehicles_feature_view
	UNION ALL
	SELECT *
	FROM const_raw_mater_plcons_rep_def_days_view
	UNION ALL
	SELECT *
	FROM const_self_ship_dest_id_view
	UNION ALL
	SELECT *
	FROM const_self_ship_dest_view
	UNION ALL
	SELECT *
	FROM const_shift_for_orders_length_time_view
	UNION ALL
	SELECT *
	FROM const_shift_length_time_view
	UNION ALL
	SELECT *
	FROM const_ship_coast_for_self_ship_destination_view
	UNION ALL
	SELECT *
	FROM const_speed_change_for_order_autolocate_view
	UNION ALL
	SELECT *
	FROM const_vehicle_unload_time_view
	UNION ALL
	SELECT *
	FROM const_avg_mat_cons_dev_day_count_view
	UNION ALL
	SELECT *
	FROM const_days_for_plan_procur_view
	UNION ALL
	SELECT *
	FROM const_lab_min_sample_count_view
	UNION ALL
	SELECT *
	FROM const_lab_days_for_avg_view
	UNION ALL
	SELECT *
	FROM const_city_ext_view
	UNION ALL
	SELECT *
	FROM const_def_lang_view
	UNION ALL
	SELECT *
	FROM const_efficiency_warn_k_view
	UNION ALL
	SELECT *
	FROM const_zone_violation_alarm_interval_view
	UNION ALL
	SELECT *
	FROM const_weather_update_interval_sec_view
	UNION ALL
	SELECT *
	FROM const_call_history_count_view
	UNION ALL
	SELECT *
	FROM const_water_ship_cost_view
	UNION ALL
	SELECT *
	FROM const_vehicle_owner_accord_from_day_view
	UNION ALL
	SELECT *
	FROM const_vehicle_owner_accord_to_day_view
	UNION ALL
	SELECT *
	FROM const_show_time_for_shipped_vehicles_view
	UNION ALL
	SELECT *
	FROM const_tracker_malfunction_tel_list_view
	UNION ALL
	SELECT *
	FROM const_low_efficiency_tel_list_view
	UNION ALL
	SELECT *
	FROM const_material_closed_balance_date_view
	UNION ALL
	SELECT *
	FROM const_cement_material_view
	UNION ALL
	SELECT *
	FROM const_deviation_for_reroute_view
	UNION ALL
	SELECT *
	FROM const_arnavi_telemat_server_view
	UNION ALL
	SELECT *
	FROM const_chart_step_quant_view
	UNION ALL
	SELECT *
	FROM const_chart_max_quant_view
	UNION ALL
	SELECT *
	FROM const_konkrid_client_view
	UNION ALL
	SELECT *
	FROM const_reglament_user_view
	ORDER BY name;
	ALTER VIEW constants_list_view OWNER TO beton;
	

-- ******************* update 27/04/2024 12:38:54 ******************

	-- ********** constant value table  reglament_user *************
	CREATE TABLE IF NOT EXISTS const_reglament_user
	(name text, descr text, val json,
		val_type text,ctrl_class text,ctrl_options json, view_class text,view_options json);
	ALTER TABLE const_reglament_user OWNER TO beton;
	INSERT INTO const_reglament_user (name,descr,val,val_type,ctrl_class,ctrl_options,view_class,view_options) VALUES (
		'Пользователь регламент'
		,'Пользователь регламент'
		,NULL
		,'JSON'
		,NULL
		,NULL
		,NULL
		,NULL
	);
		--constant get value
	CREATE OR REPLACE FUNCTION const_reglament_user_val()
	RETURNS json AS
	$BODY$
		SELECT val::json AS val FROM const_reglament_user LIMIT 1;
	$BODY$
	LANGUAGE sql STABLE COST 100;
	ALTER FUNCTION const_reglament_user_val() OWNER TO beton;
	--constant set value
	CREATE OR REPLACE FUNCTION const_reglament_user_set_val(JSON)
	RETURNS void AS
	$BODY$
		UPDATE const_reglament_user SET val=$1;
	$BODY$
	LANGUAGE sql VOLATILE COST 100;
	ALTER FUNCTION const_reglament_user_set_val(JSON) OWNER TO beton;
	--edit view: all keys and descr
	CREATE OR REPLACE VIEW const_reglament_user_view AS
	SELECT
		'reglament_user'::text AS id
		,t.name
		,t.descr
	,
	t.val::text AS val
	,t.val_type::text AS val_type
	,t.ctrl_class::text
	,t.ctrl_options::json
	,t.view_class::text
	,t.view_options::json
	FROM const_reglament_user AS t
	;
	ALTER VIEW const_reglament_user_view OWNER TO beton;
	CREATE OR REPLACE VIEW constants_list_view AS
	SELECT *
	FROM const_doc_per_page_count_view
	UNION ALL
	SELECT *
	FROM const_grid_refresh_interval_view
	UNION ALL
	SELECT *
	FROM const_order_grid_refresh_interval_view
	UNION ALL
	SELECT *
	FROM const_backup_vehicles_feature_view
	UNION ALL
	SELECT *
	FROM const_base_geo_zone_id_view
	UNION ALL
	SELECT *
	FROM const_base_geo_zone_view
	UNION ALL
	SELECT *
	FROM const_chart_step_min_view
	UNION ALL
	SELECT *
	FROM const_day_shift_length_view
	UNION ALL
	SELECT *
	FROM const_days_allowed_with_broken_tracker_view
	UNION ALL
	SELECT *
	FROM const_def_order_unload_speed_view
	UNION ALL
	SELECT *
	FROM const_demurrage_coast_per_hour_view
	UNION ALL
	SELECT *
	FROM const_first_shift_start_time_view
	UNION ALL
	SELECT *
	FROM const_geo_zone_check_points_count_view
	UNION ALL
	SELECT *
	FROM const_map_default_lat_view
	UNION ALL
	SELECT *
	FROM const_map_default_lon_view
	UNION ALL
	SELECT *
	FROM const_max_hour_load_view
	UNION ALL
	SELECT *
	FROM const_max_vehicle_at_work_view
	UNION ALL
	SELECT *
	FROM const_min_demurrage_time_view
	UNION ALL
	SELECT *
	FROM const_min_quant_for_ship_cost_view
	UNION ALL
	SELECT *
	FROM const_no_tracker_signal_warn_interval_view
	UNION ALL
	SELECT *
	FROM const_ord_mark_if_no_ship_time_view
	UNION ALL
	SELECT *
	FROM const_order_auto_place_tolerance_view
	UNION ALL
	SELECT *
	FROM const_order_step_min_view
	UNION ALL
	SELECT *
	FROM const_own_vehicles_feature_view
	UNION ALL
	SELECT *
	FROM const_raw_mater_plcons_rep_def_days_view
	UNION ALL
	SELECT *
	FROM const_self_ship_dest_id_view
	UNION ALL
	SELECT *
	FROM const_self_ship_dest_view
	UNION ALL
	SELECT *
	FROM const_shift_for_orders_length_time_view
	UNION ALL
	SELECT *
	FROM const_shift_length_time_view
	UNION ALL
	SELECT *
	FROM const_ship_coast_for_self_ship_destination_view
	UNION ALL
	SELECT *
	FROM const_speed_change_for_order_autolocate_view
	UNION ALL
	SELECT *
	FROM const_vehicle_unload_time_view
	UNION ALL
	SELECT *
	FROM const_avg_mat_cons_dev_day_count_view
	UNION ALL
	SELECT *
	FROM const_days_for_plan_procur_view
	UNION ALL
	SELECT *
	FROM const_lab_min_sample_count_view
	UNION ALL
	SELECT *
	FROM const_lab_days_for_avg_view
	UNION ALL
	SELECT *
	FROM const_city_ext_view
	UNION ALL
	SELECT *
	FROM const_def_lang_view
	UNION ALL
	SELECT *
	FROM const_efficiency_warn_k_view
	UNION ALL
	SELECT *
	FROM const_zone_violation_alarm_interval_view
	UNION ALL
	SELECT *
	FROM const_weather_update_interval_sec_view
	UNION ALL
	SELECT *
	FROM const_call_history_count_view
	UNION ALL
	SELECT *
	FROM const_water_ship_cost_view
	UNION ALL
	SELECT *
	FROM const_vehicle_owner_accord_from_day_view
	UNION ALL
	SELECT *
	FROM const_vehicle_owner_accord_to_day_view
	UNION ALL
	SELECT *
	FROM const_show_time_for_shipped_vehicles_view
	UNION ALL
	SELECT *
	FROM const_tracker_malfunction_tel_list_view
	UNION ALL
	SELECT *
	FROM const_low_efficiency_tel_list_view
	UNION ALL
	SELECT *
	FROM const_material_closed_balance_date_view
	UNION ALL
	SELECT *
	FROM const_cement_material_view
	UNION ALL
	SELECT *
	FROM const_deviation_for_reroute_view
	UNION ALL
	SELECT *
	FROM const_arnavi_telemat_server_view
	UNION ALL
	SELECT *
	FROM const_chart_step_quant_view
	UNION ALL
	SELECT *
	FROM const_chart_max_quant_view
	UNION ALL
	SELECT *
	FROM const_konkrid_client_view
	UNION ALL
	SELECT *
	FROM const_reglament_user_view
	ORDER BY name;
	ALTER VIEW constants_list_view OWNER TO beton;
	

-- ******************* update 27/04/2024 12:43:41 ******************

	ALTER TABLE const_konkrid_client OWNER TO concrete1;
	--edit view: all keys and descr
	CREATE OR REPLACE VIEW const_konkrid_client_view AS
	SELECT
		'konkrid_client'::text AS id
		,t.name
		,t.descr
	,
	t.val::text AS val
	,t.val_type::text AS val_type
	,t.ctrl_class::text
	,t.ctrl_options::json
	,t.view_class::text
	,t.view_options::json
	FROM const_konkrid_client AS t
	;
	ALTER VIEW const_konkrid_client_view OWNER TO concrete1;
	
	CREATE OR REPLACE VIEW constants_list_view AS
	SELECT *
	FROM const_doc_per_page_count_view
	UNION ALL
	SELECT *
	FROM const_grid_refresh_interval_view
	UNION ALL
	SELECT *
	FROM const_order_grid_refresh_interval_view
	UNION ALL
	SELECT *
	FROM const_backup_vehicles_feature_view
	UNION ALL
	SELECT *
	FROM const_base_geo_zone_id_view
	UNION ALL
	SELECT *
	FROM const_base_geo_zone_view
	UNION ALL
	SELECT *
	FROM const_chart_step_min_view
	UNION ALL
	SELECT *
	FROM const_day_shift_length_view
	UNION ALL
	SELECT *
	FROM const_days_allowed_with_broken_tracker_view
	UNION ALL
	SELECT *
	FROM const_def_order_unload_speed_view
	UNION ALL
	SELECT *
	FROM const_demurrage_coast_per_hour_view
	UNION ALL
	SELECT *
	FROM const_first_shift_start_time_view
	UNION ALL
	SELECT *
	FROM const_geo_zone_check_points_count_view
	UNION ALL
	SELECT *
	FROM const_map_default_lat_view
	UNION ALL
	SELECT *
	FROM const_map_default_lon_view
	UNION ALL
	SELECT *
	FROM const_max_hour_load_view
	UNION ALL
	SELECT *
	FROM const_max_vehicle_at_work_view
	UNION ALL
	SELECT *
	FROM const_min_demurrage_time_view
	UNION ALL
	SELECT *
	FROM const_min_quant_for_ship_cost_view
	UNION ALL
	SELECT *
	FROM const_no_tracker_signal_warn_interval_view
	UNION ALL
	SELECT *
	FROM const_ord_mark_if_no_ship_time_view
	UNION ALL
	SELECT *
	FROM const_order_auto_place_tolerance_view
	UNION ALL
	SELECT *
	FROM const_order_step_min_view
	UNION ALL
	SELECT *
	FROM const_own_vehicles_feature_view
	UNION ALL
	SELECT *
	FROM const_raw_mater_plcons_rep_def_days_view
	UNION ALL
	SELECT *
	FROM const_self_ship_dest_id_view
	UNION ALL
	SELECT *
	FROM const_self_ship_dest_view
	UNION ALL
	SELECT *
	FROM const_shift_for_orders_length_time_view
	UNION ALL
	SELECT *
	FROM const_shift_length_time_view
	UNION ALL
	SELECT *
	FROM const_ship_coast_for_self_ship_destination_view
	UNION ALL
	SELECT *
	FROM const_speed_change_for_order_autolocate_view
	UNION ALL
	SELECT *
	FROM const_vehicle_unload_time_view
	UNION ALL
	SELECT *
	FROM const_avg_mat_cons_dev_day_count_view
	UNION ALL
	SELECT *
	FROM const_days_for_plan_procur_view
	UNION ALL
	SELECT *
	FROM const_lab_min_sample_count_view
	UNION ALL
	SELECT *
	FROM const_lab_days_for_avg_view
	UNION ALL
	SELECT *
	FROM const_city_ext_view
	UNION ALL
	SELECT *
	FROM const_def_lang_view
	UNION ALL
	SELECT *
	FROM const_efficiency_warn_k_view
	UNION ALL
	SELECT *
	FROM const_zone_violation_alarm_interval_view
	UNION ALL
	SELECT *
	FROM const_weather_update_interval_sec_view
	UNION ALL
	SELECT *
	FROM const_call_history_count_view
	UNION ALL
	SELECT *
	FROM const_water_ship_cost_view
	UNION ALL
	SELECT *
	FROM const_vehicle_owner_accord_from_day_view
	UNION ALL
	SELECT *
	FROM const_vehicle_owner_accord_to_day_view
	UNION ALL
	SELECT *
	FROM const_show_time_for_shipped_vehicles_view
	UNION ALL
	SELECT *
	FROM const_tracker_malfunction_tel_list_view
	UNION ALL
	SELECT *
	FROM const_low_efficiency_tel_list_view
	UNION ALL
	SELECT *
	FROM const_material_closed_balance_date_view
	UNION ALL
	SELECT *
	FROM const_cement_material_view
	UNION ALL
	SELECT *
	FROM const_deviation_for_reroute_view
	UNION ALL
	SELECT *
	FROM const_arnavi_telemat_server_view
	UNION ALL
	SELECT *
	FROM const_chart_step_quant_view
	UNION ALL
	SELECT *
	FROM const_chart_max_quant_view
	UNION ALL
	SELECT *
	FROM const_konkrid_client_view
	UNION ALL
	SELECT *
	FROM const_reglament_user_view
	ORDER BY name;
	ALTER VIEW constants_list_view OWNER TO concrete1;
	


-- ******************* update 03/05/2024 09:08:11 ******************
﻿-- Function: konkrid_ship_get_schedule(in_beton_order_date_time timestamp without time zone, in_beton_order_concrete_name text, in_beton_order_quant double precision)

-- DROP FUNCTION konkrid_ship_get_schedule(in_beton_order_date_time timestamp without time zone, in_beton_order_concrete_name text, in_beton_order_quant double precision);

CREATE OR REPLACE FUNCTION konkrid_ship_get_schedule(in_beton_order_date_time timestamp without time zone, in_beton_order_concrete_name text, in_beton_order_quant double precision)
  RETURNS int AS
$$
	SELECT
		kd_o.id
	FROM public.orders as kd_o
	WHERE
		kd_o.date_time = in_beton_order_date_time
		AND kd_o.concrete_type_id = 
			(SELECT
				ct.id
			FROM concrete_types as ct
			WHERE ct.name = in_beton_order_concrete_name
			LIMIT 1
			)
		AND kd_o.quant = in_beton_order_quant
	LIMIT 1;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION konkrid_ship_get_schedule(in_beton_order_date_time timestamp without time zone, in_beton_order_concrete_name text, in_beton_order_quant double precision) OWNER TO beton;


-- ******************* update 03/05/2024 09:10:29 ******************
﻿-- Function: konkrid_ship_get_schedule(in_beton_order_date_time timestamp without time zone, in_beton_order_concrete_name text, in_beton_order_quant double precision)

 DROP FUNCTION konkrid_ship_get_schedule(in_beton_order_date_time timestamp without time zone, in_beton_order_concrete_name text, in_beton_order_quant double precision);

CREATE OR REPLACE FUNCTION konkrid_ship_get_order(in_beton_order_date_time timestamp without time zone, in_beton_order_concrete_name text, in_beton_order_quant double precision)
  RETURNS int AS
$$
	SELECT
		kd_o.id
	FROM public.orders as kd_o
	WHERE
		kd_o.date_time = in_beton_order_date_time
		AND kd_o.concrete_type_id = 
			(SELECT
				ct.id
			FROM concrete_types as ct
			WHERE ct.name = in_beton_order_concrete_name
			LIMIT 1
			)
		AND kd_o.quant = in_beton_order_quant
	LIMIT 1;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION konkrid_ship_get_order(in_beton_order_date_time timestamp without time zone, in_beton_order_concrete_name text, in_beton_order_quant double precision) OWNER TO beton;


-- ******************* update 03/05/2024 09:19:18 ******************
﻿-- Function: konkrid_ship_get_schedule(in_ship_date date, in_ship_veh_plate text)

-- DROP FUNCTION konkrid_ship_get_schedule(in_ship_date date, in_ship_veh_plate text);

CREATE OR REPLACE FUNCTION konkrid_ship_get_schedule(in_ship_date date, in_ship_veh_plate text)
  RETURNS int AS
$$
	SELECT
		sched.id
	FROM public.vehicle_schedules as sched
	WHERE
		sched.schedule_date = in_ship_date
		and sched.vehicle_id = 
			(SELECT	
				v.id
			FROM vehicles as v
			WHERE
				v.plate = in_ship_veh_plate
			LIMIT 1
			) 
	LIMIT 1;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION konkrid_ship_get_schedule(in_ship_date date, in_ship_veh_plate text) OWNER TO beton;


-- ******************* update 04/05/2024 05:46:39 ******************
-- Table: public.replicate_events

-- DROP TABLE IF EXISTS public.replicate_events;

CREATE UNLOGGED TABLE IF NOT EXISTS public.replicate_events
(
    event_id text COLLATE pg_catalog."default",
    params text COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.replicate_events
    OWNER TO concrete1;



-- ******************* update 04/05/2024 05:48:45 ******************
-- FUNCTION: public.replicate_events_process()

-- DROP FUNCTION IF EXISTS public.replicate_events_process();

CREATE OR REPLACE FUNCTION public.replicate_events_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='INSERT' ) THEN
		--IF current_database() = 'concrete1' THEN
			PERFORM pg_notify(
				NEW.event_id,
				NEW.params
			);
		--END IF;
			
		RETURN NEW;
	END IF;
	
END;
$BODY$;

ALTER FUNCTION public.replicate_events_process()
    OWNER TO concrete1;



-- ******************* update 04/05/2024 05:48:59 ******************
-- FUNCTION: public.replicate_events_process()

-- DROP FUNCTION IF EXISTS public.replicate_events_process();

CREATE OR REPLACE FUNCTION public.replicate_events_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='INSERT' ) THEN
		PERFORM pg_notify(
			NEW.event_id,
			NEW.params
		);
			
		RETURN NEW;
	END IF;
	
END;
$BODY$;

ALTER FUNCTION public.replicate_events_process()
    OWNER TO concrete1;



-- ******************* update 04/05/2024 05:52:09 ******************
-- FUNCTION: public.replicate_events_process()

-- DROP FUNCTION IF EXISTS public.replicate_events_process();

CREATE OR REPLACE FUNCTION public.replicate_events_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='INSERT' ) THEN
		PERFORM pg_notify(
			NEW.event_id,
			NEW.params
		);
			
		RETURN NEW;
	END IF;
	
END;
$BODY$;

ALTER FUNCTION public.replicate_events_process()
    OWNER TO concrete1;



-- ******************* update 04/05/2024 05:58:01 ******************
-- Table: public.replicate_events

-- DROP TABLE IF EXISTS public.replicate_events;

CREATE UNLOGGED TABLE IF NOT EXISTS public.replicate_events
(
    event_id text COLLATE pg_catalog."default",
    params text COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.replicate_events
    OWNER TO beton;



-- ******************* update 04/05/2024 05:58:07 ******************
-- FUNCTION: public.replicate_events_process()

-- DROP FUNCTION IF EXISTS public.replicate_events_process();

CREATE OR REPLACE FUNCTION public.replicate_events_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='INSERT' ) THEN
		PERFORM pg_notify(
			NEW.event_id,
			NEW.params
		);
			
		RETURN NEW;
	END IF;
	
END;
$BODY$;

ALTER FUNCTION public.replicate_events_process()
    OWNER TO beton;



-- ******************* update 04/05/2024 05:59:40 ******************
-- Trigger: replicate_events_after_insert

-- DROP TRIGGER IF EXISTS replicate_events_after_insert ON public.replicate_events;

CREATE OR REPLACE TRIGGER replicate_events_after_insert
    AFTER INSERT
    ON public.replicate_events
    FOR EACH ROW
    EXECUTE FUNCTION public.replicate_events_process();


-- ******************* update 04/05/2024 06:06:12 ******************
-- FUNCTION: public.geo_zone_check()

-- DROP FUNCTION IF EXISTS public.geo_zone_check();

CREATE OR REPLACE FUNCTION public.geo_zone_check()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	v_cur_state vehicle_states;
	v_production_base_id int;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	
	v_zone geometry;
	
	v_st_date_time timestamp without time zone;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;
	v_long_route_rest bool;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;

	--get last state
	WITH
	shift AS (
		SELECT
			d_from,
			d_to
		FROM get_shift_bounds(NEW.recieved_dt + age(now(), now() at time zone 'UTC')) AS (d_from timestamp, d_to timestamp)
	)
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE
		st.tracker_id = NEW.car_id
		AND st.date_time BETWEEN (SELECT d_from FROM shift) AND (SELECT d_to FROM shift)
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF v_cur_state = 'busy'::vehicle_states THEN
			--clients zone on shipment
			SELECT				
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id = shipments.order_id
			LEFT JOIN destinations ON destinations.id = orders.destination_id
			WHERE
				shipments.id = v_shipment_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
			
		ELSIF  v_cur_state = 'at_dest'::vehicle_states THEN
			-- client zone from state
			SELECT
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM destinations
			WHERE
				destinations.id = v_destination_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
		ELSE
			--
			-- base zone
			-- ALL possible zones, NOT const_base_geo_zone_id_val()
			-- returns one zone only
			SELECT
				b.id,
				b.destination_id,
				destinations.zone
			INTO
				v_production_base_id,
				v_destination_id,
				v_zone
			FROM production_bases AS b
			LEFT JOIN destinations ON destinations.id = b.destination_id
			WHERE
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			LIMIT 1			
			;
					
		END IF;		
		
		--if at least the last point inside zone
		IF v_zone IS NOT NULL THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat
					FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid = 1
					ORDER BY t.period DESC
					LIMIT const_geo_zone_check_points_count_val() - 1
					OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					-- v_production_base_id = previous state value
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					-- v_production_base_id = previous state value OR some other logic!!! Куда назначили
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
					--v_production_base_id = Фактическая зона, зона производственной площадки
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id, destination_id, shipment_id, production_base_id)
					VALUES (CURRENT_TIMESTAMP,
						v_schedule_id,
						v_new_state,
						NEW.car_id,
						v_destination_id,
						v_shipment_id,
						v_production_base_id
					);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						--v_cur_state='at_dest' OR 
						WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		/*IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%, v_cur_state=%',v_shipment_id,v_cur_state;
		END IF;*/
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = const_base_geo_zone_id_val()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						/*v_point_in_zone = FALSE;
						SELECT
							st_contains(
								st_transform(
									st_buffer(
										st_transform(
											ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
											,3857
										)
										,30
									)
								,4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
						END IF;
						*/
						
						IF v_destination_id IS NOT NULL AND v_client_id IS NOT NULL THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT (client_id,destination_id) DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;						
						--route done
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										--v_cur_state='at_dest' OR 
										WHEN v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		SELECT (length(v_hypothetical_route_rest_t)>7500) INTO v_long_route_rest;
		IF v_long_route_rest THEN
			INSERT INTO route_rests VALUES(NEW.car_id,v_hypothetical_route_rest_t)
			ON CONFLICT (tracker_id) DO UPDATE SET
			route_rest = v_hypothetical_route_rest_t;
		END IF;
		
		--returns vehicles_last_pos struc + route
		BEGIN
			PERFORM pg_notify(
				'Vehicle.position.'||NEW.car_id
				,json_build_object(
					'params',json_build_object(
						'tracker_id',NEW.car_id
						,'lon',NEW.lon
						,'lat',NEW.lat
						,'heading',NEW.heading
						,'speed',NEW.speed
						,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'ns',NEW.ns
						,'ew',NEW.ew
						,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'odometer',NEW.odometer::text
						,'voltage',round(NEW.voltage,0)
						,'route_rest',CASE WHEN v_long_route_rest THEN NULL ELSE v_hypothetical_route_rest_t END
						,'long_route_rest',v_long_route_rest
						,'route_rest_len',v_hypothetical_route_rest_len
					)
				)::text
			);
		EXCEPTION WHEN OTHERS THEN
		END;
	END IF;

	--from beton to konkrid
	
	IF current_database() = 'beton' THEN
		--all vehicles to konkrid
		INSERT INTO konkrid.replicate_events
			VALUES ('CarTracking.to_konkrid',
				json_build_object('params',
					json_build_object('car_id', NEW.car_id, 'period', NEW.period)
				)::text
		);
		
		--whose car?
		--konkrid ownerID=286
		/*		
		IF
			coalesce(
				(SELECT
						(owners.f->'owner'->'keys'->>'id')::int = 286 AS konkrid_owned
				FROM (
					SELECT
							jsonb_array_elements(vehicle_owners->'rows')->'fields' AS f
					FROM vehicles AS v
					WHERE v.tracker_id = NEW.car_id
				) AS owners
				ORDER BY (owners.f->>'dt_from')::timestamp DESC
				LIMIT 1)
			, FALSE
			) THEN
			
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('CarTracking.to_konkrid',
					json_build_object('params',
						json_build_object('car_id', NEW.car_id, 'period', NEW.period)
					)::text
			);
		END IF;
		*/
	END IF;
		
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.geo_zone_check()
    OWNER TO beton;



-- ******************* update 04/05/2024 06:07:16 ******************
-- FUNCTION: public.order_after_process()

-- DROP FUNCTION IF EXISTS public.order_after_process();

CREATE OR REPLACE FUNCTION public.order_after_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

DECLARE
	v_f boolean;
BEGIN	
	IF TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
	
		IF current_database() = 'bereg' AND NEW.client_id = (const_konkrid_client_val()->'keys'->>'id')::int THEN
			INSERT INTO konkrid.replicate_events
				VALUES ('Order.to_konkrid_' || LOWER(TG_OP),
					json_build_object('params',
						json_build_object('id', NEW.id)
					)::text
			);
			
		ELSIF current_database() = 'concrete1' THEN
			INSERT INTO bereg.replicate_events
				VALUES ('Order.to_bereg_' || LOWER(TG_OP),
					json_build_object('params',
						json_build_object('id', NEW.id)
					)::text
			);
		
		END IF;
	
	
		IF TG_OP = 'INSERT' OR (TG_OP='UPDATE'
			AND NEW.phone_cel<>''
			AND (
				(NEW.client_id<>OLD.client_id)
				OR (NEW.phone_cel<>OLD.phone_cel)
			)
			)
		THEN		
			SELECT
				TRUE
			INTO v_f FROM client_tels
			WHERE client_id = NEW.client_id
				AND tel=NEW.phone_cel;
			
			IF v_f IS NULL THEN
				
				BEGIN
					INSERT INTO client_tels
						(client_id,tel,name)
					VALUES (NEW.client_id,NEW.phone_cel,NEW.descr);
				EXCEPTION WHEN OTHERS THEN
				END;
			END IF;
			
		END IF;
		
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='DELETE' THEN
		IF current_database() = 'bereg' AND OLD.client_id = (const_konkrid_client_val()->'keys'->>'id')::int THEN
			INSERT INTO konkrid.replicate_events
				VALUES ('Order.to_konkrid_delete',
					json_build_object('params',
						json_build_object('id', OLD.id)
					)::text
			);
			
		ELSIF current_database() = 'concrete1' THEN
			INSERT INTO bereg.replicate_events
				VALUES ('Order.to_bereg_delete',
					json_build_object('params',
						json_build_object('id', OLD.id)
					)::text
			);
		
		END IF;
	
		RETURN OLD;
	END IF;	
	
END;
$BODY$;

ALTER FUNCTION public.order_after_process()
    OWNER TO beton;



-- ******************* update 04/05/2024 06:07:43 ******************
-- FUNCTION: public.order_after_process()

-- DROP FUNCTION IF EXISTS public.order_after_process();

CREATE OR REPLACE FUNCTION public.order_after_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

DECLARE
	v_f boolean;
BEGIN	
	IF TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
	
		IF current_database() = 'bereg' AND NEW.client_id = (const_konkrid_client_val()->'keys'->>'id')::int THEN
			INSERT INTO konkrid.replicate_events
				VALUES ('Order.to_konkrid_' || LOWER(TG_OP),
					json_build_object('params',
						json_build_object('id', NEW.id)
					)::text
			);
			
		ELSIF current_database() = 'concrete1' THEN
			INSERT INTO bereg.replicate_events
				VALUES ('Order.to_bereg_' || LOWER(TG_OP),
					json_build_object('params',
						json_build_object('id', NEW.id)
					)::text
			);
		
		END IF;
	
	
		IF TG_OP = 'INSERT' OR (TG_OP='UPDATE'
			AND NEW.phone_cel<>''
			AND (
				(NEW.client_id<>OLD.client_id)
				OR (NEW.phone_cel<>OLD.phone_cel)
			)
			)
		THEN		
			SELECT
				TRUE
			INTO v_f FROM client_tels
			WHERE client_id = NEW.client_id
				AND tel=NEW.phone_cel;
			
			IF v_f IS NULL THEN
				
				BEGIN
					INSERT INTO client_tels
						(client_id,tel,name)
					VALUES (NEW.client_id,NEW.phone_cel,NEW.descr);
				EXCEPTION WHEN OTHERS THEN
				END;
			END IF;
			
		END IF;
		
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='DELETE' THEN
		IF current_database() = 'bereg' AND OLD.client_id = (const_konkrid_client_val()->'keys'->>'id')::int THEN
			INSERT INTO konkrid.replicate_events
				VALUES ('Order.to_konkrid_delete',
					json_build_object('params',
						json_build_object('id', OLD.id)
					)::text
			);
			
		ELSIF current_database() = 'concrete1' THEN
			INSERT INTO bereg.replicate_events
				VALUES ('Order.to_bereg_delete',
					json_build_object('params',
						json_build_object('id', OLD.id)
					)::text
			);
		
		END IF;
	
		RETURN OLD;
	END IF;	
	
END;
$BODY$;

ALTER FUNCTION public.order_after_process()
    OWNER TO concrete1;



-- ******************* update 04/05/2024 06:08:40 ******************
-- Function: public.set_vehicle_busy()

-- DROP FUNCTION public.set_vehicle_busy();

CREATE OR REPLACE FUNCTION public.set_vehicle_busy()
  RETURNS trigger AS
$BODY$
DECLARE
	dest_id int;
	spec_id int;
	new_state vehicle_states;
	v_feature vehicles.feature%TYPE;
	reg_act ra_material_consumption%ROWTYPE;
	reg_act_mat ra_materials%ROWTYPE;
	v_concrete_type_id int;
	v_vehicle_id int;
	v_driver_id int;
	rate_row RECORD;
	v_avg_dev numeric;
	v_production_base_id int;
	v_tracker_id varchar(15);
BEGIN
	--change state only if 1) insert
	--		       2) update && shipped false==>true
	IF (TG_OP='INSERT') OR (TG_OP='UPDATE' AND OLD.shipped=false AND NEW.shipped) THEN
		IF NEW.shipped THEN
			new_state = 'busy'::vehicle_states;
			
			--if self-shipment && empty feature - set state out
			SELECT
				o.destination_id,
				coalesce(o.client_specification_id, 0)
			INTO
				dest_id,
				spec_id
			FROM orders AS o
			WHERE o.id=NEW.order_id;
			
			IF dest_id = constant_self_ship_dest_id() THEN
				SELECT v.feature INTO v_feature FROM vehicle_schedules AS vs
				LEFT JOIN vehicles AS v ON v.id=vs.vehicle_id
				WHERE vs.id=NEW.vehicle_schedule_id;
				
				IF (v_feature IS NULL) OR (v_feature='') THEN
					new_state = 'out'::vehicle_states;
				END IF;
			END IF;
			
			--specification
			/*IF spec_id > 0 THEN
				INSERT INTO client_specification_flows
				(client_specification_id, shipment_id, quant)
				VALUES (
					spec_id,
					NEW.id,
					NEW.quant
				)
				ON CONFLICT (client_specification_id, shipment_id) DO UPDATE
				SET quant = NEW.quant;
			END IF;*/
		END IF;
		
		v_tracker_id = get_vehicle_tracker_id_on_schedule_id(NEW.vehicle_schedule_id);
		INSERT INTO vehicle_schedule_states
		(date_time, state, shipment_id, schedule_id, tracker_id, destination_id, production_base_id)
		VALUES(
			current_timestamp,
			CASE
			WHEN NEW.shipped THEN
				new_state
			ELSE
				'assigned'::vehicle_states
			END,
			NEW.id,NEW.vehicle_schedule_id,
			v_tracker_id,
			dest_id,
			veh_cur_production_base_id(v_tracker_id)
		);

	END IF;

	IF (TG_OP='INSERT') THEN
		--log
		PERFORM doc_log_insert('shipment'::doc_types,NEW.id,NEW.date_time);
	ELSE
		--IF NEW.ship_date_time<>OLD.ship_date_time THEN
			PERFORM doc_log_update('shipment'::doc_types,NEW.id,NEW.ship_date_time);
		--END IF;			
	END IF;

	IF (TG_OP='INSERT' OR TG_OP='UPDATE') AND (NEW.shipped) THEN	
		SELECT o.concrete_type_id INTO v_concrete_type_id FROM orders AS o WHERE o.id=NEW.order_id;
		SELECT sch.vehicle_id,sch.driver_id INTO v_vehicle_id,v_driver_id FROM vehicle_schedules As sch WHERE sch.id=NEW.vehicle_schedule_id;
		
		--concrete
		--reg acts				
		reg_act.date_time		= NEW.ship_date_time;
		reg_act.doc_type  		= 'shipment'::doc_types;
		reg_act.doc_id  		= NEW.id;
		reg_act.concrete_type_id 	= v_concrete_type_id;
		reg_act.vehicle_id 		= v_vehicle_id;
		reg_act.driver_id 		= v_driver_id;
		reg_act.concrete_quant		= NEW.quant;
		reg_act.material_quant		= 0;
		reg_act.material_quant_norm	= 0;
		PERFORM ra_material_consumption_add_act(reg_act);	


		SELECT production_base_id INTO v_production_base_id
		FROM production_sites
		WHERE id = NEW.production_site_id;
		
		--materials		
		FOR rate_row IN
			SELECT * FROM raw_material_cons_rates(NEW.production_site_id, v_concrete_type_id, NEW.ship_date_time)
		LOOP
			v_avg_dev = 0;--raw_mat_cons_avg_dev(NEW.ship_date_time::date,rate_row.material_id)*NEW.quant;
			
			--reg acts				
			reg_act.date_time		= NEW.ship_date_time;
			reg_act.doc_type  		= 'shipment'::doc_types;
			reg_act.doc_id  		= NEW.id;
			reg_act.concrete_type_id 	= v_concrete_type_id;
			reg_act.vehicle_id 		= v_vehicle_id;
			reg_act.driver_id 		= v_driver_id;			
			reg_act.material_id 		= rate_row.material_id;
			reg_act.material_quant		= (rate_row.rate * NEW.quant) + v_avg_dev;
			reg_act.material_quant_norm	= rate_row.rate * NEW.quant;
			reg_act.material_quant_corrected= (rate_row.rate * NEW.quant) + v_avg_dev;
			reg_act.concrete_quant		= 0;
			PERFORM ra_material_consumption_add_act(reg_act);	

			--reg materials
			reg_act_mat.date_time		= NEW.ship_date_time;
			reg_act_mat.deb			= false;
			reg_act_mat.doc_type  		= 'shipment'::doc_types;
			reg_act_mat.doc_id  		= NEW.id;
			reg_act_mat.production_base_id	= v_production_base_id;
			reg_act_mat.material_id		= rate_row.material_id;
			reg_act_mat.quant		= rate_row.rate*NEW.quant;
			PERFORM ra_materials_add_act(reg_act_mat);	
			
		END LOOP;
		
		--пересчет нарушения норма/факт по производству
		UPDATE productions
		SET
			material_tolerance_violated = productions_get_mat_tolerance_violated(
				production_site_id,
				production_id
			)
		WHERE shipment_id = NEW.id;
		
		--specification
		SELECT
			coalesce(o.client_specification_id, 0)
		INTO
			spec_id
		FROM orders AS o
		WHERE o.id=NEW.order_id;
		
		IF spec_id > 0 THEN
			INSERT INTO client_specification_flows
			(client_specification_id, shipment_id, quant)
			VALUES (
				spec_id,
				NEW.id,
				NEW.quant
			)
			ON CONFLICT (client_specification_id, shipment_id) DO UPDATE
			SET quant = NEW.quant;
		END IF;
		
	END IF;
	
	IF current_database() = 'beton' THEN
		--check if client id Konkrid
		IF
			coalesce(
				(SELECT
					o.client_id = (const_konkrid_client_val()->'keys'->>'id')::int
				FROM orders as o
				WHERE o.id = NEW.order_id)
			, FALSE)
		THEN
			INSERT INTO konkrid.replicate_events
				VALUES ('Shipment.to_konkrid',
					json_build_object('params',
						json_build_object('id', NEW.id)
					)::text
			);
		END IF;
	END IF;
	
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.set_vehicle_busy()
  OWNER TO concrete1;



-- ******************* update 04/05/2024 06:08:51 ******************
-- Function: public.set_vehicle_busy()

-- DROP FUNCTION public.set_vehicle_busy();

CREATE OR REPLACE FUNCTION public.set_vehicle_busy()
  RETURNS trigger AS
$BODY$
DECLARE
	dest_id int;
	spec_id int;
	new_state vehicle_states;
	v_feature vehicles.feature%TYPE;
	reg_act ra_material_consumption%ROWTYPE;
	reg_act_mat ra_materials%ROWTYPE;
	v_concrete_type_id int;
	v_vehicle_id int;
	v_driver_id int;
	rate_row RECORD;
	v_avg_dev numeric;
	v_production_base_id int;
	v_tracker_id varchar(15);
BEGIN
	--change state only if 1) insert
	--		       2) update && shipped false==>true
	IF (TG_OP='INSERT') OR (TG_OP='UPDATE' AND OLD.shipped=false AND NEW.shipped) THEN
		IF NEW.shipped THEN
			new_state = 'busy'::vehicle_states;
			
			--if self-shipment && empty feature - set state out
			SELECT
				o.destination_id,
				coalesce(o.client_specification_id, 0)
			INTO
				dest_id,
				spec_id
			FROM orders AS o
			WHERE o.id=NEW.order_id;
			
			IF dest_id = constant_self_ship_dest_id() THEN
				SELECT v.feature INTO v_feature FROM vehicle_schedules AS vs
				LEFT JOIN vehicles AS v ON v.id=vs.vehicle_id
				WHERE vs.id=NEW.vehicle_schedule_id;
				
				IF (v_feature IS NULL) OR (v_feature='') THEN
					new_state = 'out'::vehicle_states;
				END IF;
			END IF;
			
			--specification
			/*IF spec_id > 0 THEN
				INSERT INTO client_specification_flows
				(client_specification_id, shipment_id, quant)
				VALUES (
					spec_id,
					NEW.id,
					NEW.quant
				)
				ON CONFLICT (client_specification_id, shipment_id) DO UPDATE
				SET quant = NEW.quant;
			END IF;*/
		END IF;
		
		v_tracker_id = get_vehicle_tracker_id_on_schedule_id(NEW.vehicle_schedule_id);
		INSERT INTO vehicle_schedule_states
		(date_time, state, shipment_id, schedule_id, tracker_id, destination_id, production_base_id)
		VALUES(
			current_timestamp,
			CASE
			WHEN NEW.shipped THEN
				new_state
			ELSE
				'assigned'::vehicle_states
			END,
			NEW.id,NEW.vehicle_schedule_id,
			v_tracker_id,
			dest_id,
			veh_cur_production_base_id(v_tracker_id)
		);

	END IF;

	IF (TG_OP='INSERT') THEN
		--log
		PERFORM doc_log_insert('shipment'::doc_types,NEW.id,NEW.date_time);
	ELSE
		--IF NEW.ship_date_time<>OLD.ship_date_time THEN
			PERFORM doc_log_update('shipment'::doc_types,NEW.id,NEW.ship_date_time);
		--END IF;			
	END IF;

	IF (TG_OP='INSERT' OR TG_OP='UPDATE') AND (NEW.shipped) THEN	
		SELECT o.concrete_type_id INTO v_concrete_type_id FROM orders AS o WHERE o.id=NEW.order_id;
		SELECT sch.vehicle_id,sch.driver_id INTO v_vehicle_id,v_driver_id FROM vehicle_schedules As sch WHERE sch.id=NEW.vehicle_schedule_id;
		
		--concrete
		--reg acts				
		reg_act.date_time		= NEW.ship_date_time;
		reg_act.doc_type  		= 'shipment'::doc_types;
		reg_act.doc_id  		= NEW.id;
		reg_act.concrete_type_id 	= v_concrete_type_id;
		reg_act.vehicle_id 		= v_vehicle_id;
		reg_act.driver_id 		= v_driver_id;
		reg_act.concrete_quant		= NEW.quant;
		reg_act.material_quant		= 0;
		reg_act.material_quant_norm	= 0;
		PERFORM ra_material_consumption_add_act(reg_act);	


		SELECT production_base_id INTO v_production_base_id
		FROM production_sites
		WHERE id = NEW.production_site_id;
		
		--materials		
		FOR rate_row IN
			SELECT * FROM raw_material_cons_rates(NEW.production_site_id, v_concrete_type_id, NEW.ship_date_time)
		LOOP
			v_avg_dev = 0;--raw_mat_cons_avg_dev(NEW.ship_date_time::date,rate_row.material_id)*NEW.quant;
			
			--reg acts				
			reg_act.date_time		= NEW.ship_date_time;
			reg_act.doc_type  		= 'shipment'::doc_types;
			reg_act.doc_id  		= NEW.id;
			reg_act.concrete_type_id 	= v_concrete_type_id;
			reg_act.vehicle_id 		= v_vehicle_id;
			reg_act.driver_id 		= v_driver_id;			
			reg_act.material_id 		= rate_row.material_id;
			reg_act.material_quant		= (rate_row.rate * NEW.quant) + v_avg_dev;
			reg_act.material_quant_norm	= rate_row.rate * NEW.quant;
			reg_act.material_quant_corrected= (rate_row.rate * NEW.quant) + v_avg_dev;
			reg_act.concrete_quant		= 0;
			PERFORM ra_material_consumption_add_act(reg_act);	

			--reg materials
			reg_act_mat.date_time		= NEW.ship_date_time;
			reg_act_mat.deb			= false;
			reg_act_mat.doc_type  		= 'shipment'::doc_types;
			reg_act_mat.doc_id  		= NEW.id;
			reg_act_mat.production_base_id	= v_production_base_id;
			reg_act_mat.material_id		= rate_row.material_id;
			reg_act_mat.quant		= rate_row.rate*NEW.quant;
			PERFORM ra_materials_add_act(reg_act_mat);	
			
		END LOOP;
		
		--пересчет нарушения норма/факт по производству
		UPDATE productions
		SET
			material_tolerance_violated = productions_get_mat_tolerance_violated(
				production_site_id,
				production_id
			)
		WHERE shipment_id = NEW.id;
		
		--specification
		SELECT
			coalesce(o.client_specification_id, 0)
		INTO
			spec_id
		FROM orders AS o
		WHERE o.id=NEW.order_id;
		
		IF spec_id > 0 THEN
			INSERT INTO client_specification_flows
			(client_specification_id, shipment_id, quant)
			VALUES (
				spec_id,
				NEW.id,
				NEW.quant
			)
			ON CONFLICT (client_specification_id, shipment_id) DO UPDATE
			SET quant = NEW.quant;
		END IF;
		
	END IF;
	
	IF current_database() = 'beton' THEN
		--check if client id Konkrid
		IF
			coalesce(
				(SELECT
					o.client_id = (const_konkrid_client_val()->'keys'->>'id')::int
				FROM orders as o
				WHERE o.id = NEW.order_id)
			, FALSE)
		THEN
			INSERT INTO konkrid.replicate_events
				VALUES ('Shipment.to_konkrid',
					json_build_object('params',
						json_build_object('id', NEW.id)
					)::text
			);
		END IF;
	END IF;
	
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.set_vehicle_busy()
  OWNER TO beton;



-- ******************* update 04/05/2024 07:21:46 ******************
﻿-- Function: konkrid_get_pump_veh_id(in_pump_vehicle_plate text)

-- DROP FUNCTION konkrid_get_pump_veh_id(in_pump_vehicle_plate text);

-- actually this function id used for all events: konkrid && beton

CREATE OR REPLACE FUNCTION konkrid_get_pump_veh_id(in_pump_vehicle_plate text)
  RETURNS int AS
$$
	SELECT
		pvh.id
	FROM public.pump_vehicles as pvh
	WHERE
		pvh.vehicle_id = 
			(SELECT
				v.id
			FROM vehicles as v
			WHERE v.plate = in_pump_vehicle_plate
			LIMIT 1
			)
	LIMIT 1;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION konkrid_get_pump_veh_id(in_pump_vehicle_plate text) OWNER TO beton;


-- ******************* update 04/05/2024 07:21:58 ******************
﻿-- Function: konkrid_get_pump_veh_id(in_pump_vehicle_plate text)

-- DROP FUNCTION konkrid_get_pump_veh_id(in_pump_vehicle_plate text);

-- actually this function id used for all events: konkrid && beton

CREATE OR REPLACE FUNCTION konkrid_get_pump_veh_id(in_pump_vehicle_plate text)
  RETURNS int AS
$$
	SELECT
		pvh.id
	FROM public.pump_vehicles as pvh
	WHERE
		pvh.vehicle_id = 
			(SELECT
				v.id
			FROM vehicles as v
			WHERE v.plate = in_pump_vehicle_plate
			LIMIT 1
			)
	LIMIT 1;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION konkrid_get_pump_veh_id(in_pump_vehicle_plate text) OWNER TO concrete1;


-- ******************* update 04/05/2024 08:14:59 ******************
-- Trigger: order_trigger_after

 DROP TRIGGER IF EXISTS order_trigger_after ON public.orders;
/*
CREATE OR REPLACE TRIGGER order_trigger_after
    AFTER INSERT OR UPDATE OR DELETE
    ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION public.order_after_process();

*/    
 DROP TRIGGER IF EXISTS order_trigger_before_delete ON public.orders;
/*
CREATE OR REPLACE TRIGGER order_trigger_before_delete
    BEFORE DELETE
    ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION public.order_delete();
  */  
 DROP TRIGGER IF EXISTS order_process_before_insert ON public.orders;
/*
CREATE OR REPLACE TRIGGER order_process_before_insert
    BEFORE INSERT
    ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION public.order_process();
*/    
 DROP TRIGGER IF EXISTS order_process_before_update ON public.orders;
/*
CREATE OR REPLACE TRIGGER order_process_before_update
    BEFORE UPDATE 
    ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION public.order_process();            
*/    


-- ******************* update 04/05/2024 08:15:31 ******************
-- Trigger: order_trigger_after

-- DROP TRIGGER IF EXISTS order_trigger_after ON public.orders;

CREATE OR REPLACE TRIGGER order_trigger_after
    AFTER INSERT OR UPDATE OR DELETE
    ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION public.order_after_process();

    
-- DROP TRIGGER IF EXISTS order_trigger_before_delete ON public.orders;

CREATE OR REPLACE TRIGGER order_trigger_before_delete
    BEFORE DELETE
    ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION public.order_delete();
    
-- DROP TRIGGER IF EXISTS order_process_before_insert ON public.orders;

CREATE OR REPLACE TRIGGER order_process_before_insert
    BEFORE INSERT
    ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION public.order_process();
    
-- DROP TRIGGER IF EXISTS order_process_before_update ON public.orders;

CREATE OR REPLACE TRIGGER order_process_before_update
    BEFORE UPDATE 
    ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION public.order_process();            



-- ******************* update 06/05/2024 06:50:20 ******************
﻿-- Function: replicate_original_order(in_orig_order_create_date_time timestamp without time zone, in_orig_order_concrete_name text, in_orig_order_quant double precision)

-- DROP FUNCTION replicate_original_order(in_orig_order_create_date_time timestamp without time zone, in_orig_order_concrete_name text, in_orig_order_quant double precision);

-- actually this function id used for all events: konkrid && beton

CREATE OR REPLACE FUNCTION replicate_original_order(in_orig_order_create_date_time timestamp without time zone, in_orig_order_concrete_name text, in_orig_order_quant double precision)
  RETURNS int AS
$$
	SELECT
		kd_o.id
	FROM public.orders as kd_o
	WHERE
		kd_o.create_date_time = in_orig_order_create_date_time
		AND kd_o.concrete_type_id = 
			(SELECT
				ct.id
			FROM concrete_types as ct
			WHERE ct.name = in_orig_order_concrete_name
			LIMIT 1
			)
		AND kd_o.quant = in_orig_order_quant
	LIMIT 1;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION replicate_original_order(in_orig_order_create_date_time timestamp without time zone, in_orig_order_concrete_name text, in_orig_order_quant double precision) OWNER TO beton;


-- ******************* update 06/05/2024 06:50:40 ******************
﻿-- Function: replicate_original_order(in_orig_order_create_date_time timestamp without time zone, in_orig_order_concrete_name text, in_orig_order_quant double precision)

-- DROP FUNCTION replicate_original_order(in_orig_order_create_date_time timestamp without time zone, in_orig_order_concrete_name text, in_orig_order_quant double precision);

-- actually this function id used for all events: konkrid && beton

CREATE OR REPLACE FUNCTION replicate_original_order(in_orig_order_create_date_time timestamp without time zone, in_orig_order_concrete_name text, in_orig_order_quant double precision)
  RETURNS int AS
$$
	SELECT
		kd_o.id
	FROM public.orders as kd_o
	WHERE
		kd_o.create_date_time = in_orig_order_create_date_time
		AND kd_o.concrete_type_id = 
			(SELECT
				ct.id
			FROM concrete_types as ct
			WHERE ct.name = in_orig_order_concrete_name
			LIMIT 1
			)
		AND kd_o.quant = in_orig_order_quant
	LIMIT 1;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION replicate_original_order(in_orig_order_create_date_time timestamp without time zone, in_orig_order_concrete_name text, in_orig_order_quant double precision) OWNER TO concrete1;


-- ******************* update 06/05/2024 09:04:01 ******************
-- FUNCTION: public.order_after_process()

-- DROP FUNCTION IF EXISTS public.order_after_process();

CREATE OR REPLACE FUNCTION public.order_after_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

DECLARE
	v_f boolean;
BEGIN	
	IF TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
	
		IF current_database() = 'bereg' AND NEW.client_id = (const_konkrid_client_val()->'keys'->>'id')::int THEN
			INSERT INTO konkrid.replicate_events
				VALUES ('Order.to_konkrid_' || LOWER(TG_OP),
					json_build_object('params',
						json_build_object('id', NEW.id)
					)::text
			);
			
		ELSIF current_database() = 'concrete1' THEN
			INSERT INTO beton.replicate_events
				VALUES ('Order.to_bereg_' || LOWER(TG_OP),
					json_build_object('params',
						json_build_object('id', NEW.id)
					)::text
			);
		
		END IF;
	
	
		IF TG_OP = 'INSERT' OR (TG_OP='UPDATE'
			AND NEW.phone_cel<>''
			AND (
				(NEW.client_id<>OLD.client_id)
				OR (NEW.phone_cel<>OLD.phone_cel)
			)
			)
		THEN		
			SELECT
				TRUE
			INTO v_f FROM client_tels
			WHERE client_id = NEW.client_id
				AND tel=NEW.phone_cel;
			
			IF v_f IS NULL THEN
				
				BEGIN
					INSERT INTO client_tels
						(client_id,tel,name)
					VALUES (NEW.client_id,NEW.phone_cel,NEW.descr);
				EXCEPTION WHEN OTHERS THEN
				END;
			END IF;
			
		END IF;
		
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='DELETE' THEN
		IF current_database() = 'bereg' AND OLD.client_id = (const_konkrid_client_val()->'keys'->>'id')::int THEN
			INSERT INTO konkrid.replicate_events
				VALUES ('Order.to_konkrid_delete',
					json_build_object('params',
						json_build_object('id', OLD.id)
					)::text
			);
			
		ELSIF current_database() = 'concrete1' THEN
			INSERT INTO beton.replicate_events
				VALUES ('Order.to_bereg_delete',
					json_build_object('params',
						json_build_object('id', OLD.id)
					)::text
			);
		
		END IF;
	
		RETURN OLD;
	END IF;	
	
END;
$BODY$;

ALTER FUNCTION public.order_after_process()
    OWNER TO concrete1;



-- ******************* update 06/05/2024 09:04:15 ******************
-- FUNCTION: public.order_after_process()

-- DROP FUNCTION IF EXISTS public.order_after_process();

CREATE OR REPLACE FUNCTION public.order_after_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

DECLARE
	v_f boolean;
BEGIN	
	IF TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
	
		IF current_database() = 'bereg' AND NEW.client_id = (const_konkrid_client_val()->'keys'->>'id')::int THEN
			INSERT INTO konkrid.replicate_events
				VALUES ('Order.to_konkrid_' || LOWER(TG_OP),
					json_build_object('params',
						json_build_object('id', NEW.id)
					)::text
			);
			
		ELSIF current_database() = 'concrete1' THEN
			INSERT INTO beton.replicate_events
				VALUES ('Order.to_bereg_' || LOWER(TG_OP),
					json_build_object('params',
						json_build_object('id', NEW.id)
					)::text
			);
		
		END IF;
	
	
		IF TG_OP = 'INSERT' OR (TG_OP='UPDATE'
			AND NEW.phone_cel<>''
			AND (
				(NEW.client_id<>OLD.client_id)
				OR (NEW.phone_cel<>OLD.phone_cel)
			)
			)
		THEN		
			SELECT
				TRUE
			INTO v_f FROM client_tels
			WHERE client_id = NEW.client_id
				AND tel=NEW.phone_cel;
			
			IF v_f IS NULL THEN
				
				BEGIN
					INSERT INTO client_tels
						(client_id,tel,name)
					VALUES (NEW.client_id,NEW.phone_cel,NEW.descr);
				EXCEPTION WHEN OTHERS THEN
				END;
			END IF;
			
		END IF;
		
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='DELETE' THEN
		IF current_database() = 'bereg' AND OLD.client_id = (const_konkrid_client_val()->'keys'->>'id')::int THEN
			INSERT INTO konkrid.replicate_events
				VALUES ('Order.to_konkrid_delete',
					json_build_object('params',
						json_build_object('id', OLD.id)
					)::text
			);
			
		ELSIF current_database() = 'concrete1' THEN
			INSERT INTO beton.replicate_events
				VALUES ('Order.to_bereg_delete',
					json_build_object('params',
						json_build_object('id', OLD.id)
					)::text
			);
		
		END IF;
	
		RETURN OLD;
	END IF;	
	
END;
$BODY$;

ALTER FUNCTION public.order_after_process()
    OWNER TO beton;



-- ******************* update 06/05/2024 11:56:16 ******************
-- FUNCTION: public.order_after_process()

-- DROP FUNCTION IF EXISTS public.order_after_process();

CREATE OR REPLACE FUNCTION public.order_after_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

DECLARE
	v_f boolean;
BEGIN	
	IF TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
	
		IF NEW.date_time::date >= '2024-05-07' THEN
			IF current_database() = 'bereg' AND NEW.client_id = (const_konkrid_client_val()->'keys'->>'id')::int THEN
				INSERT INTO konkrid.replicate_events
					VALUES ('Order.to_konkrid_' || LOWER(TG_OP),
						json_build_object('params',
							json_build_object('id', NEW.id)
						)::text
				);
				
			ELSIF current_database() = 'concrete1' THEN
				INSERT INTO beton.replicate_events
					VALUES ('Order.to_bereg_' || LOWER(TG_OP),
						json_build_object('params',
							json_build_object('id', NEW.id)
						)::text
				);
			
			END IF;
		END IF;
	
		IF TG_OP = 'INSERT' OR (TG_OP='UPDATE'
			AND NEW.phone_cel<>''
			AND (
				(NEW.client_id<>OLD.client_id)
				OR (NEW.phone_cel<>OLD.phone_cel)
			)
			)
		THEN		
			SELECT
				TRUE
			INTO v_f FROM client_tels
			WHERE client_id = NEW.client_id
				AND tel=NEW.phone_cel;
			
			IF v_f IS NULL THEN
				
				BEGIN
					INSERT INTO client_tels
						(client_id,tel,name)
					VALUES (NEW.client_id,NEW.phone_cel,NEW.descr);
				EXCEPTION WHEN OTHERS THEN
				END;
			END IF;
			
		END IF;
		
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='DELETE' THEN
		IF NEW.date_time::date >= '2024-05-07' THEN
			IF current_database() = 'bereg' AND OLD.client_id = (const_konkrid_client_val()->'keys'->>'id')::int THEN
				INSERT INTO konkrid.replicate_events
					VALUES ('Order.to_konkrid_delete',
						json_build_object('params',
							json_build_object('id', OLD.id)
						)::text
				);
				
			ELSIF current_database() = 'concrete1' THEN
				INSERT INTO beton.replicate_events
					VALUES ('Order.to_bereg_delete',
						json_build_object('params',
							json_build_object('id', OLD.id)
						)::text
				);
			
			END IF;
		END IF;	
	
		RETURN OLD;
	END IF;	
	
END;
$BODY$;

ALTER FUNCTION public.order_after_process()
    OWNER TO beton;



-- ******************* update 06/05/2024 11:56:33 ******************
-- FUNCTION: public.order_after_process()

-- DROP FUNCTION IF EXISTS public.order_after_process();

CREATE OR REPLACE FUNCTION public.order_after_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

DECLARE
	v_f boolean;
BEGIN	
	IF TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
	
		IF NEW.date_time::date >= '2024-05-07' THEN
			IF current_database() = 'bereg' AND NEW.client_id = (const_konkrid_client_val()->'keys'->>'id')::int THEN
				INSERT INTO konkrid.replicate_events
					VALUES ('Order.to_konkrid_' || LOWER(TG_OP),
						json_build_object('params',
							json_build_object('id', NEW.id)
						)::text
				);
				
			ELSIF current_database() = 'concrete1' THEN
				INSERT INTO beton.replicate_events
					VALUES ('Order.to_bereg_' || LOWER(TG_OP),
						json_build_object('params',
							json_build_object('id', NEW.id)
						)::text
				);
			
			END IF;
		END IF;
	
		IF TG_OP = 'INSERT' OR (TG_OP='UPDATE'
			AND NEW.phone_cel<>''
			AND (
				(NEW.client_id<>OLD.client_id)
				OR (NEW.phone_cel<>OLD.phone_cel)
			)
			)
		THEN		
			SELECT
				TRUE
			INTO v_f FROM client_tels
			WHERE client_id = NEW.client_id
				AND tel=NEW.phone_cel;
			
			IF v_f IS NULL THEN
				
				BEGIN
					INSERT INTO client_tels
						(client_id,tel,name)
					VALUES (NEW.client_id,NEW.phone_cel,NEW.descr);
				EXCEPTION WHEN OTHERS THEN
				END;
			END IF;
			
		END IF;
		
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='DELETE' THEN
		IF OLD.date_time::date >= '2024-05-07' THEN
			IF current_database() = 'bereg' AND OLD.client_id = (const_konkrid_client_val()->'keys'->>'id')::int THEN
				INSERT INTO konkrid.replicate_events
					VALUES ('Order.to_konkrid_delete',
						json_build_object('params',
							json_build_object('id', OLD.id)
						)::text
				);
				
			ELSIF current_database() = 'concrete1' THEN
				INSERT INTO beton.replicate_events
					VALUES ('Order.to_bereg_delete',
						json_build_object('params',
							json_build_object('id', OLD.id)
						)::text
				);
			
			END IF;
		END IF;	
	
		RETURN OLD;
	END IF;	
	
END;
$BODY$;

ALTER FUNCTION public.order_after_process()
    OWNER TO beton;



-- ******************* update 06/05/2024 11:57:16 ******************
-- Function: public.set_vehicle_busy()

-- DROP FUNCTION public.set_vehicle_busy();

CREATE OR REPLACE FUNCTION public.set_vehicle_busy()
  RETURNS trigger AS
$BODY$
DECLARE
	dest_id int;
	spec_id int;
	new_state vehicle_states;
	v_feature vehicles.feature%TYPE;
	reg_act ra_material_consumption%ROWTYPE;
	reg_act_mat ra_materials%ROWTYPE;
	v_concrete_type_id int;
	v_vehicle_id int;
	v_driver_id int;
	rate_row RECORD;
	v_avg_dev numeric;
	v_production_base_id int;
	v_tracker_id varchar(15);
BEGIN
	--change state only if 1) insert
	--		       2) update && shipped false==>true
	IF (TG_OP='INSERT') OR (TG_OP='UPDATE' AND OLD.shipped=false AND NEW.shipped) THEN
		IF NEW.shipped THEN
			new_state = 'busy'::vehicle_states;
			
			--if self-shipment && empty feature - set state out
			SELECT
				o.destination_id,
				coalesce(o.client_specification_id, 0)
			INTO
				dest_id,
				spec_id
			FROM orders AS o
			WHERE o.id=NEW.order_id;
			
			IF dest_id = constant_self_ship_dest_id() THEN
				SELECT v.feature INTO v_feature FROM vehicle_schedules AS vs
				LEFT JOIN vehicles AS v ON v.id=vs.vehicle_id
				WHERE vs.id=NEW.vehicle_schedule_id;
				
				IF (v_feature IS NULL) OR (v_feature='') THEN
					new_state = 'out'::vehicle_states;
				END IF;
			END IF;
			
			--specification
			/*IF spec_id > 0 THEN
				INSERT INTO client_specification_flows
				(client_specification_id, shipment_id, quant)
				VALUES (
					spec_id,
					NEW.id,
					NEW.quant
				)
				ON CONFLICT (client_specification_id, shipment_id) DO UPDATE
				SET quant = NEW.quant;
			END IF;*/
		END IF;
		
		v_tracker_id = get_vehicle_tracker_id_on_schedule_id(NEW.vehicle_schedule_id);
		INSERT INTO vehicle_schedule_states
		(date_time, state, shipment_id, schedule_id, tracker_id, destination_id, production_base_id)
		VALUES(
			current_timestamp,
			CASE
			WHEN NEW.shipped THEN
				new_state
			ELSE
				'assigned'::vehicle_states
			END,
			NEW.id,NEW.vehicle_schedule_id,
			v_tracker_id,
			dest_id,
			veh_cur_production_base_id(v_tracker_id)
		);

	END IF;

	IF (TG_OP='INSERT') THEN
		--log
		PERFORM doc_log_insert('shipment'::doc_types,NEW.id,NEW.date_time);
	ELSE
		--IF NEW.ship_date_time<>OLD.ship_date_time THEN
			PERFORM doc_log_update('shipment'::doc_types,NEW.id,NEW.ship_date_time);
		--END IF;			
	END IF;

	IF (TG_OP='INSERT' OR TG_OP='UPDATE') AND (NEW.shipped) THEN	
		SELECT o.concrete_type_id INTO v_concrete_type_id FROM orders AS o WHERE o.id=NEW.order_id;
		SELECT sch.vehicle_id,sch.driver_id INTO v_vehicle_id,v_driver_id FROM vehicle_schedules As sch WHERE sch.id=NEW.vehicle_schedule_id;
		
		--concrete
		--reg acts				
		reg_act.date_time		= NEW.ship_date_time;
		reg_act.doc_type  		= 'shipment'::doc_types;
		reg_act.doc_id  		= NEW.id;
		reg_act.concrete_type_id 	= v_concrete_type_id;
		reg_act.vehicle_id 		= v_vehicle_id;
		reg_act.driver_id 		= v_driver_id;
		reg_act.concrete_quant		= NEW.quant;
		reg_act.material_quant		= 0;
		reg_act.material_quant_norm	= 0;
		PERFORM ra_material_consumption_add_act(reg_act);	


		SELECT production_base_id INTO v_production_base_id
		FROM production_sites
		WHERE id = NEW.production_site_id;
		
		--materials		
		FOR rate_row IN
			SELECT * FROM raw_material_cons_rates(NEW.production_site_id, v_concrete_type_id, NEW.ship_date_time)
		LOOP
			v_avg_dev = 0;--raw_mat_cons_avg_dev(NEW.ship_date_time::date,rate_row.material_id)*NEW.quant;
			
			--reg acts				
			reg_act.date_time		= NEW.ship_date_time;
			reg_act.doc_type  		= 'shipment'::doc_types;
			reg_act.doc_id  		= NEW.id;
			reg_act.concrete_type_id 	= v_concrete_type_id;
			reg_act.vehicle_id 		= v_vehicle_id;
			reg_act.driver_id 		= v_driver_id;			
			reg_act.material_id 		= rate_row.material_id;
			reg_act.material_quant		= (rate_row.rate * NEW.quant) + v_avg_dev;
			reg_act.material_quant_norm	= rate_row.rate * NEW.quant;
			reg_act.material_quant_corrected= (rate_row.rate * NEW.quant) + v_avg_dev;
			reg_act.concrete_quant		= 0;
			PERFORM ra_material_consumption_add_act(reg_act);	

			--reg materials
			reg_act_mat.date_time		= NEW.ship_date_time;
			reg_act_mat.deb			= false;
			reg_act_mat.doc_type  		= 'shipment'::doc_types;
			reg_act_mat.doc_id  		= NEW.id;
			reg_act_mat.production_base_id	= v_production_base_id;
			reg_act_mat.material_id		= rate_row.material_id;
			reg_act_mat.quant		= rate_row.rate*NEW.quant;
			PERFORM ra_materials_add_act(reg_act_mat);	
			
		END LOOP;
		
		--пересчет нарушения норма/факт по производству
		UPDATE productions
		SET
			material_tolerance_violated = productions_get_mat_tolerance_violated(
				production_site_id,
				production_id
			)
		WHERE shipment_id = NEW.id;
		
		--specification
		SELECT
			coalesce(o.client_specification_id, 0)
		INTO
			spec_id
		FROM orders AS o
		WHERE o.id=NEW.order_id;
		
		IF spec_id > 0 THEN
			INSERT INTO client_specification_flows
			(client_specification_id, shipment_id, quant)
			VALUES (
				spec_id,
				NEW.id,
				NEW.quant
			)
			ON CONFLICT (client_specification_id, shipment_id) DO UPDATE
			SET quant = NEW.quant;
		END IF;
		
	END IF;
	
	IF NEW.date_time::date >= '2024-05-07' THEN
		IF current_database() = 'beton' THEN
			--check if client id Konkrid
			IF
				coalesce(
					(SELECT
						o.client_id = (const_konkrid_client_val()->'keys'->>'id')::int
					FROM orders as o
					WHERE o.id = NEW.order_id)
				, FALSE)
			THEN
				INSERT INTO konkrid.replicate_events
					VALUES ('Shipment.to_konkrid',
						json_build_object('params',
							json_build_object('id', NEW.id)
						)::text
				);
			END IF;
		END IF;
	END IF;	
	
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.set_vehicle_busy()
  OWNER TO beton;



-- ******************* update 06/05/2024 11:57:34 ******************
-- FUNCTION: public.order_after_process()

-- DROP FUNCTION IF EXISTS public.order_after_process();

CREATE OR REPLACE FUNCTION public.order_after_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

DECLARE
	v_f boolean;
BEGIN	
	IF TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
	
		IF NEW.date_time::date >= '2024-05-07' THEN
			IF current_database() = 'bereg' AND NEW.client_id = (const_konkrid_client_val()->'keys'->>'id')::int THEN
				INSERT INTO konkrid.replicate_events
					VALUES ('Order.to_konkrid_' || LOWER(TG_OP),
						json_build_object('params',
							json_build_object('id', NEW.id)
						)::text
				);
				
			ELSIF current_database() = 'concrete1' THEN
				INSERT INTO beton.replicate_events
					VALUES ('Order.to_bereg_' || LOWER(TG_OP),
						json_build_object('params',
							json_build_object('id', NEW.id)
						)::text
				);
			
			END IF;
		END IF;
	
		IF TG_OP = 'INSERT' OR (TG_OP='UPDATE'
			AND NEW.phone_cel<>''
			AND (
				(NEW.client_id<>OLD.client_id)
				OR (NEW.phone_cel<>OLD.phone_cel)
			)
			)
		THEN		
			SELECT
				TRUE
			INTO v_f FROM client_tels
			WHERE client_id = NEW.client_id
				AND tel=NEW.phone_cel;
			
			IF v_f IS NULL THEN
				
				BEGIN
					INSERT INTO client_tels
						(client_id,tel,name)
					VALUES (NEW.client_id,NEW.phone_cel,NEW.descr);
				EXCEPTION WHEN OTHERS THEN
				END;
			END IF;
			
		END IF;
		
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='DELETE' THEN
		IF OLD.date_time::date >= '2024-05-07' THEN
			IF current_database() = 'bereg' AND OLD.client_id = (const_konkrid_client_val()->'keys'->>'id')::int THEN
				INSERT INTO konkrid.replicate_events
					VALUES ('Order.to_konkrid_delete',
						json_build_object('params',
							json_build_object('id', OLD.id)
						)::text
				);
				
			ELSIF current_database() = 'concrete1' THEN
				INSERT INTO beton.replicate_events
					VALUES ('Order.to_bereg_delete',
						json_build_object('params',
							json_build_object('id', OLD.id)
						)::text
				);
			
			END IF;
		END IF;	
	
		RETURN OLD;
	END IF;	
	
END;
$BODY$;

ALTER FUNCTION public.order_after_process()
    OWNER TO concrete1;



-- ******************* update 06/05/2024 11:57:35 ******************
-- Function: public.set_vehicle_busy()

-- DROP FUNCTION public.set_vehicle_busy();

CREATE OR REPLACE FUNCTION public.set_vehicle_busy()
  RETURNS trigger AS
$BODY$
DECLARE
	dest_id int;
	spec_id int;
	new_state vehicle_states;
	v_feature vehicles.feature%TYPE;
	reg_act ra_material_consumption%ROWTYPE;
	reg_act_mat ra_materials%ROWTYPE;
	v_concrete_type_id int;
	v_vehicle_id int;
	v_driver_id int;
	rate_row RECORD;
	v_avg_dev numeric;
	v_production_base_id int;
	v_tracker_id varchar(15);
BEGIN
	--change state only if 1) insert
	--		       2) update && shipped false==>true
	IF (TG_OP='INSERT') OR (TG_OP='UPDATE' AND OLD.shipped=false AND NEW.shipped) THEN
		IF NEW.shipped THEN
			new_state = 'busy'::vehicle_states;
			
			--if self-shipment && empty feature - set state out
			SELECT
				o.destination_id,
				coalesce(o.client_specification_id, 0)
			INTO
				dest_id,
				spec_id
			FROM orders AS o
			WHERE o.id=NEW.order_id;
			
			IF dest_id = constant_self_ship_dest_id() THEN
				SELECT v.feature INTO v_feature FROM vehicle_schedules AS vs
				LEFT JOIN vehicles AS v ON v.id=vs.vehicle_id
				WHERE vs.id=NEW.vehicle_schedule_id;
				
				IF (v_feature IS NULL) OR (v_feature='') THEN
					new_state = 'out'::vehicle_states;
				END IF;
			END IF;
			
			--specification
			/*IF spec_id > 0 THEN
				INSERT INTO client_specification_flows
				(client_specification_id, shipment_id, quant)
				VALUES (
					spec_id,
					NEW.id,
					NEW.quant
				)
				ON CONFLICT (client_specification_id, shipment_id) DO UPDATE
				SET quant = NEW.quant;
			END IF;*/
		END IF;
		
		v_tracker_id = get_vehicle_tracker_id_on_schedule_id(NEW.vehicle_schedule_id);
		INSERT INTO vehicle_schedule_states
		(date_time, state, shipment_id, schedule_id, tracker_id, destination_id, production_base_id)
		VALUES(
			current_timestamp,
			CASE
			WHEN NEW.shipped THEN
				new_state
			ELSE
				'assigned'::vehicle_states
			END,
			NEW.id,NEW.vehicle_schedule_id,
			v_tracker_id,
			dest_id,
			veh_cur_production_base_id(v_tracker_id)
		);

	END IF;

	IF (TG_OP='INSERT') THEN
		--log
		PERFORM doc_log_insert('shipment'::doc_types,NEW.id,NEW.date_time);
	ELSE
		--IF NEW.ship_date_time<>OLD.ship_date_time THEN
			PERFORM doc_log_update('shipment'::doc_types,NEW.id,NEW.ship_date_time);
		--END IF;			
	END IF;

	IF (TG_OP='INSERT' OR TG_OP='UPDATE') AND (NEW.shipped) THEN	
		SELECT o.concrete_type_id INTO v_concrete_type_id FROM orders AS o WHERE o.id=NEW.order_id;
		SELECT sch.vehicle_id,sch.driver_id INTO v_vehicle_id,v_driver_id FROM vehicle_schedules As sch WHERE sch.id=NEW.vehicle_schedule_id;
		
		--concrete
		--reg acts				
		reg_act.date_time		= NEW.ship_date_time;
		reg_act.doc_type  		= 'shipment'::doc_types;
		reg_act.doc_id  		= NEW.id;
		reg_act.concrete_type_id 	= v_concrete_type_id;
		reg_act.vehicle_id 		= v_vehicle_id;
		reg_act.driver_id 		= v_driver_id;
		reg_act.concrete_quant		= NEW.quant;
		reg_act.material_quant		= 0;
		reg_act.material_quant_norm	= 0;
		PERFORM ra_material_consumption_add_act(reg_act);	


		SELECT production_base_id INTO v_production_base_id
		FROM production_sites
		WHERE id = NEW.production_site_id;
		
		--materials		
		FOR rate_row IN
			SELECT * FROM raw_material_cons_rates(NEW.production_site_id, v_concrete_type_id, NEW.ship_date_time)
		LOOP
			v_avg_dev = 0;--raw_mat_cons_avg_dev(NEW.ship_date_time::date,rate_row.material_id)*NEW.quant;
			
			--reg acts				
			reg_act.date_time		= NEW.ship_date_time;
			reg_act.doc_type  		= 'shipment'::doc_types;
			reg_act.doc_id  		= NEW.id;
			reg_act.concrete_type_id 	= v_concrete_type_id;
			reg_act.vehicle_id 		= v_vehicle_id;
			reg_act.driver_id 		= v_driver_id;			
			reg_act.material_id 		= rate_row.material_id;
			reg_act.material_quant		= (rate_row.rate * NEW.quant) + v_avg_dev;
			reg_act.material_quant_norm	= rate_row.rate * NEW.quant;
			reg_act.material_quant_corrected= (rate_row.rate * NEW.quant) + v_avg_dev;
			reg_act.concrete_quant		= 0;
			PERFORM ra_material_consumption_add_act(reg_act);	

			--reg materials
			reg_act_mat.date_time		= NEW.ship_date_time;
			reg_act_mat.deb			= false;
			reg_act_mat.doc_type  		= 'shipment'::doc_types;
			reg_act_mat.doc_id  		= NEW.id;
			reg_act_mat.production_base_id	= v_production_base_id;
			reg_act_mat.material_id		= rate_row.material_id;
			reg_act_mat.quant		= rate_row.rate*NEW.quant;
			PERFORM ra_materials_add_act(reg_act_mat);	
			
		END LOOP;
		
		--пересчет нарушения норма/факт по производству
		UPDATE productions
		SET
			material_tolerance_violated = productions_get_mat_tolerance_violated(
				production_site_id,
				production_id
			)
		WHERE shipment_id = NEW.id;
		
		--specification
		SELECT
			coalesce(o.client_specification_id, 0)
		INTO
			spec_id
		FROM orders AS o
		WHERE o.id=NEW.order_id;
		
		IF spec_id > 0 THEN
			INSERT INTO client_specification_flows
			(client_specification_id, shipment_id, quant)
			VALUES (
				spec_id,
				NEW.id,
				NEW.quant
			)
			ON CONFLICT (client_specification_id, shipment_id) DO UPDATE
			SET quant = NEW.quant;
		END IF;
		
	END IF;
	
	IF NEW.date_time::date >= '2024-05-07' THEN
		IF current_database() = 'beton' THEN
			--check if client id Konkrid
			IF
				coalesce(
					(SELECT
						o.client_id = (const_konkrid_client_val()->'keys'->>'id')::int
					FROM orders as o
					WHERE o.id = NEW.order_id)
				, FALSE)
			THEN
				INSERT INTO konkrid.replicate_events
					VALUES ('Shipment.to_konkrid',
						json_build_object('params',
							json_build_object('id', NEW.id)
						)::text
				);
			END IF;
		END IF;
	END IF;	
	
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.set_vehicle_busy()
  OWNER TO concrete1;



-- ******************* update 07/05/2024 16:52:56 ******************
-- Function: public.shipment_process()

-- DROP FUNCTION public.shipment_process();

CREATE OR REPLACE FUNCTION public.shipment_process()
  RETURNS trigger AS
$BODY$
DECLARE quant_rest numeric;
	v_vehicle_load_capacity vehicles.load_capacity%TYPE DEFAULT 0;
	--v_vehicle_feature vehicles.feature%TYPE;
	v_ord_date_time timestamp;
	v_destination_id int;
	--v_tracker_id varchar(15);
	--v_shift_open boolean;
BEGIN
	/*
	IF (TG_OP='UPDATE' AND NEW.shipped AND OLD.shipped) THEN
		--closed shipment, but trying to change smth
		RAISE EXCEPTION 'Для возможности изменения отмените отгрузку!';
	END IF;
	*/

	IF (TG_WHEN='BEFORE' AND TG_OP='UPDATE' AND OLD.shipped=true) THEN
		--register actions
		PERFORM ra_materials_remove_acts('shipment'::doc_types,NEW.id);
		PERFORM ra_material_consumption_remove_acts('shipment'::doc_types,NEW.id);
	END IF;
	
	IF (TG_WHEN='BEFORE' AND TG_OP='UPDATE'
	AND (OLD.vehicle_schedule_id<>NEW.vehicle_schedule_id OR OLD.id<>NEW.id)
	)
	THEN
		--
		DELETE FROM vehicle_schedule_states t WHERE t.shipment_id = OLD.id AND t.schedule_id = OLD.vehicle_schedule_id;	
	END IF;
	
	-- vehicle data
	/*
	IF (TG_OP='INSERT' OR (TG_OP='UPDATE' AND NEW.shipped=false AND OLD.shipped=false)) THEN

		IF (v_vehicle_feature IS NULL)
		OR (
			(v_vehicle_feature<>const_own_vehicles_feature_val())
			AND (v_vehicle_feature<>const_backup_vehicles_feature_val()) 
		) THEN
			SELECT orders.destination_id INTO v_destination_id FROM orders WHERE orders.id=NEW.order_id;
			IF v_destination_id <> const_self_ship_dest_id_val() THEN
				RAISE EXCEPTION 'Данному автомобилю запрещено вывозить на этот объект!';
			END IF;
		END IF;
		
		--IF (TG_OP='INSERT' AND coalesce(v_tracker_id, '') <> '') THEN
			--NEW.production_base_id = veh_cur_production_base_id(v_tracker_id);
		--END IF;
	END IF;
	*/
	
	--checkings for bereg only!
	IF current_database() <> 'concrete1' && (TG_OP='INSERT' OR (TG_OP='UPDATE' AND NEW.shipped=false AND OLD.shipped=false)) THEN
		SELECT
			v.load_capacity
		INTO
			v_vehicle_load_capacity
		FROM vehicle_schedules AS vs
		LEFT JOIN vehicles AS v ON v.id = vs.vehicle_id
		WHERE vs.id = NEW.vehicle_schedule_id;	
	
		-- ********** check balance ****************************************
		SELECT
			o.quant - SUM(COALESCE(s.quant,0)),
			o.date_time
		INTO
			quant_rest,
			v_ord_date_time
		FROM orders AS o
		LEFT JOIN shipments AS s ON s.order_id=o.id	
		WHERE o.id = NEW.order_id
		GROUP BY o.quant,o.date_time;

		--order shift date MUST overlap shipment shift date!		
		--IF get_shift_start(NEW.date_time)<>get_shift_start(v_ord_date_time) THEN
		--	RAISE EXCEPTION 'Заявка из другой смены!';
		--END IF;
		

		IF (TG_OP='UPDATE') THEN
			quant_rest:= quant_rest + OLD.quant;
		END IF;
		
		IF (quant_rest<NEW.quant::numeric) THEN
			RAISE EXCEPTION 'Остаток по данной заявке: %, запрошено: %',quant_descr(quant_rest::numeric),quant_descr(NEW.quant::numeric);
		END IF;
		-- ********** check balance ****************************************

		
		-- *********  check load capacity *************************************		
		IF v_vehicle_load_capacity < NEW.quant THEN
			RAISE EXCEPTION 'Грузоподъемность автомобиля: "%", запрошено: %',quant_descr(v_vehicle_load_capacity::numeric),quant_descr(NEW.quant::numeric);
		END IF;
		-- *********  check load capacity *************************************
	END IF;

	IF TG_OP='UPDATE' THEN
		IF (NEW.shipped AND OLD.shipped=false) THEN
			NEW.ship_date_time = current_timestamp;
			
			--Если есть привязанное производство - пересчитать
			--возможно изменение отклонений при списании материалов по подбору
			UPDATE productions
			SET
				material_tolerance_violated = productions_get_mat_tolerance_violated(
					production_site_id,
					production_id
				)				
			WHERE shipment_id=NEW.id;
			
		ELSEIF (OLD.shipped AND NEW.shipped=false) THEN
			NEW.ship_date_time = null;
		END IF;
		
		IF (NEW.order_id <> OLD.order_id) THEN
			/** смена заявки
			 * 1) Удалить vehicle_schedule_states сданным id отгрузки и статусом at_dest, как будто и не доехал еще
			 * 2) Исправить все оставшиеся vehicle_schedule_states where shipment_id = NEW.id на новый destionation_id из orders
			 */
			DELETE FROM vehicle_schedule_states WHERE shipment_id = NEW.id AND state= 'at_dest'::vehicle_states;
			UPDATE vehicle_schedule_states
			SET
				destination_id = (SELECT orders.destination_id FROM orders WHERE orders.id=NEW.order_id)
			WHERE shipment_id = NEW.id;
		END IF;
	END IF;
	
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.shipment_process()
  OWNER TO concrete1;



-- ******************* update 07/05/2024 16:53:13 ******************
-- Function: public.shipment_process()

-- DROP FUNCTION public.shipment_process();

CREATE OR REPLACE FUNCTION public.shipment_process()
  RETURNS trigger AS
$BODY$
DECLARE quant_rest numeric;
	v_vehicle_load_capacity vehicles.load_capacity%TYPE DEFAULT 0;
	--v_vehicle_feature vehicles.feature%TYPE;
	v_ord_date_time timestamp;
	v_destination_id int;
	--v_tracker_id varchar(15);
	--v_shift_open boolean;
BEGIN
	/*
	IF (TG_OP='UPDATE' AND NEW.shipped AND OLD.shipped) THEN
		--closed shipment, but trying to change smth
		RAISE EXCEPTION 'Для возможности изменения отмените отгрузку!';
	END IF;
	*/

	IF (TG_WHEN='BEFORE' AND TG_OP='UPDATE' AND OLD.shipped=true) THEN
		--register actions
		PERFORM ra_materials_remove_acts('shipment'::doc_types,NEW.id);
		PERFORM ra_material_consumption_remove_acts('shipment'::doc_types,NEW.id);
	END IF;
	
	IF (TG_WHEN='BEFORE' AND TG_OP='UPDATE'
	AND (OLD.vehicle_schedule_id<>NEW.vehicle_schedule_id OR OLD.id<>NEW.id)
	)
	THEN
		--
		DELETE FROM vehicle_schedule_states t WHERE t.shipment_id = OLD.id AND t.schedule_id = OLD.vehicle_schedule_id;	
	END IF;
	
	-- vehicle data
	/*
	IF (TG_OP='INSERT' OR (TG_OP='UPDATE' AND NEW.shipped=false AND OLD.shipped=false)) THEN

		IF (v_vehicle_feature IS NULL)
		OR (
			(v_vehicle_feature<>const_own_vehicles_feature_val())
			AND (v_vehicle_feature<>const_backup_vehicles_feature_val()) 
		) THEN
			SELECT orders.destination_id INTO v_destination_id FROM orders WHERE orders.id=NEW.order_id;
			IF v_destination_id <> const_self_ship_dest_id_val() THEN
				RAISE EXCEPTION 'Данному автомобилю запрещено вывозить на этот объект!';
			END IF;
		END IF;
		
		--IF (TG_OP='INSERT' AND coalesce(v_tracker_id, '') <> '') THEN
			--NEW.production_base_id = veh_cur_production_base_id(v_tracker_id);
		--END IF;
	END IF;
	*/
	
	--checkings for bereg only!
	IF current_database() <> 'concrete1' && (TG_OP='INSERT' OR (TG_OP='UPDATE' AND NEW.shipped=false AND OLD.shipped=false)) THEN
		SELECT
			v.load_capacity
		INTO
			v_vehicle_load_capacity
		FROM vehicle_schedules AS vs
		LEFT JOIN vehicles AS v ON v.id = vs.vehicle_id
		WHERE vs.id = NEW.vehicle_schedule_id;	
	
		-- ********** check balance ****************************************
		SELECT
			o.quant - SUM(COALESCE(s.quant,0)),
			o.date_time
		INTO
			quant_rest,
			v_ord_date_time
		FROM orders AS o
		LEFT JOIN shipments AS s ON s.order_id=o.id	
		WHERE o.id = NEW.order_id
		GROUP BY o.quant,o.date_time;

		--order shift date MUST overlap shipment shift date!		
		--IF get_shift_start(NEW.date_time)<>get_shift_start(v_ord_date_time) THEN
		--	RAISE EXCEPTION 'Заявка из другой смены!';
		--END IF;
		

		IF (TG_OP='UPDATE') THEN
			quant_rest:= quant_rest + OLD.quant;
		END IF;
		
		IF (quant_rest<NEW.quant::numeric) THEN
			RAISE EXCEPTION 'Остаток по данной заявке: %, запрошено: %',quant_descr(quant_rest::numeric),quant_descr(NEW.quant::numeric);
		END IF;
		-- ********** check balance ****************************************

		
		-- *********  check load capacity *************************************		
		IF v_vehicle_load_capacity < NEW.quant THEN
			RAISE EXCEPTION 'Грузоподъемность автомобиля: "%", запрошено: %',quant_descr(v_vehicle_load_capacity::numeric),quant_descr(NEW.quant::numeric);
		END IF;
		-- *********  check load capacity *************************************
	END IF;

	IF TG_OP='UPDATE' THEN
		IF (NEW.shipped AND OLD.shipped=false) THEN
			NEW.ship_date_time = current_timestamp;
			
			--Если есть привязанное производство - пересчитать
			--возможно изменение отклонений при списании материалов по подбору
			UPDATE productions
			SET
				material_tolerance_violated = productions_get_mat_tolerance_violated(
					production_site_id,
					production_id
				)				
			WHERE shipment_id=NEW.id;
			
		ELSEIF (OLD.shipped AND NEW.shipped=false) THEN
			NEW.ship_date_time = null;
		END IF;
		
		IF (NEW.order_id <> OLD.order_id) THEN
			/** смена заявки
			 * 1) Удалить vehicle_schedule_states сданным id отгрузки и статусом at_dest, как будто и не доехал еще
			 * 2) Исправить все оставшиеся vehicle_schedule_states where shipment_id = NEW.id на новый destionation_id из orders
			 */
			DELETE FROM vehicle_schedule_states WHERE shipment_id = NEW.id AND state= 'at_dest'::vehicle_states;
			UPDATE vehicle_schedule_states
			SET
				destination_id = (SELECT orders.destination_id FROM orders WHERE orders.id=NEW.order_id)
			WHERE shipment_id = NEW.id;
		END IF;
	END IF;
	
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.shipment_process()
  OWNER TO concrete1;



-- ******************* update 08/05/2024 09:06:25 ******************
-- Function: public.shipment_process()

-- DROP FUNCTION public.shipment_process();

CREATE OR REPLACE FUNCTION public.shipment_process()
  RETURNS trigger AS
$BODY$
DECLARE quant_rest numeric;
	v_vehicle_load_capacity vehicles.load_capacity%TYPE DEFAULT 0;
	--v_vehicle_feature vehicles.feature%TYPE;
	v_ord_date_time timestamp;
	v_destination_id int;
	--v_tracker_id varchar(15);
	--v_shift_open boolean;
BEGIN
	/*
	IF (TG_OP='UPDATE' AND NEW.shipped AND OLD.shipped) THEN
		--closed shipment, but trying to change smth
		RAISE EXCEPTION 'Для возможности изменения отмените отгрузку!';
	END IF;
	*/

	IF (TG_WHEN='BEFORE' AND TG_OP='UPDATE' AND OLD.shipped=true) THEN
		--register actions
		PERFORM ra_materials_remove_acts('shipment'::doc_types,NEW.id);
		PERFORM ra_material_consumption_remove_acts('shipment'::doc_types,NEW.id);
	END IF;
	
	IF (TG_WHEN='BEFORE' AND TG_OP='UPDATE'
	AND (OLD.vehicle_schedule_id<>NEW.vehicle_schedule_id OR OLD.id<>NEW.id)
	)
	THEN
		--
		DELETE FROM vehicle_schedule_states t WHERE t.shipment_id = OLD.id AND t.schedule_id = OLD.vehicle_schedule_id;	
	END IF;
	
	-- vehicle data
	/*
	IF (TG_OP='INSERT' OR (TG_OP='UPDATE' AND NEW.shipped=false AND OLD.shipped=false)) THEN

		IF (v_vehicle_feature IS NULL)
		OR (
			(v_vehicle_feature<>const_own_vehicles_feature_val())
			AND (v_vehicle_feature<>const_backup_vehicles_feature_val()) 
		) THEN
			SELECT orders.destination_id INTO v_destination_id FROM orders WHERE orders.id=NEW.order_id;
			IF v_destination_id <> const_self_ship_dest_id_val() THEN
				RAISE EXCEPTION 'Данному автомобилю запрещено вывозить на этот объект!';
			END IF;
		END IF;
		
		--IF (TG_OP='INSERT' AND coalesce(v_tracker_id, '') <> '') THEN
			--NEW.production_base_id = veh_cur_production_base_id(v_tracker_id);
		--END IF;
	END IF;
	*/
	
	--checkings for bereg only!
	IF (current_database()::text <> 'concrete1') && (TG_OP='INSERT' OR (TG_OP='UPDATE' AND NEW.shipped=false AND OLD.shipped=false)) THEN
		SELECT
			v.load_capacity
		INTO
			v_vehicle_load_capacity
		FROM vehicle_schedules AS vs
		LEFT JOIN vehicles AS v ON v.id = vs.vehicle_id
		WHERE vs.id = NEW.vehicle_schedule_id;	
	
		-- ********** check balance ****************************************
		SELECT
			o.quant - SUM(COALESCE(s.quant,0)),
			o.date_time
		INTO
			quant_rest,
			v_ord_date_time
		FROM orders AS o
		LEFT JOIN shipments AS s ON s.order_id=o.id	
		WHERE o.id = NEW.order_id
		GROUP BY o.quant,o.date_time;

		--order shift date MUST overlap shipment shift date!		
		--IF get_shift_start(NEW.date_time)<>get_shift_start(v_ord_date_time) THEN
		--	RAISE EXCEPTION 'Заявка из другой смены!';
		--END IF;
		

		IF (TG_OP='UPDATE') THEN
			quant_rest:= quant_rest + OLD.quant;
		END IF;
		
		IF (quant_rest<NEW.quant::numeric) THEN
			RAISE EXCEPTION 'Остаток по данной заявке: %, запрошено: %',quant_descr(quant_rest::numeric),quant_descr(NEW.quant::numeric);
		END IF;
		-- ********** check balance ****************************************

		
		-- *********  check load capacity *************************************		
		IF v_vehicle_load_capacity < NEW.quant THEN
			RAISE EXCEPTION 'Грузоподъемность автомобиля: "%", запрошено: %',quant_descr(v_vehicle_load_capacity::numeric),quant_descr(NEW.quant::numeric);
		END IF;
		-- *********  check load capacity *************************************
	END IF;

	IF TG_OP='UPDATE' THEN
		IF (NEW.shipped AND OLD.shipped=false) THEN
			NEW.ship_date_time = current_timestamp;
			
			--Если есть привязанное производство - пересчитать
			--возможно изменение отклонений при списании материалов по подбору
			UPDATE productions
			SET
				material_tolerance_violated = productions_get_mat_tolerance_violated(
					production_site_id,
					production_id
				)				
			WHERE shipment_id=NEW.id;
			
		ELSEIF (OLD.shipped AND NEW.shipped=false) THEN
			NEW.ship_date_time = null;
		END IF;
		
		IF (NEW.order_id <> OLD.order_id) THEN
			/** смена заявки
			 * 1) Удалить vehicle_schedule_states сданным id отгрузки и статусом at_dest, как будто и не доехал еще
			 * 2) Исправить все оставшиеся vehicle_schedule_states where shipment_id = NEW.id на новый destionation_id из orders
			 */
			DELETE FROM vehicle_schedule_states WHERE shipment_id = NEW.id AND state= 'at_dest'::vehicle_states;
			UPDATE vehicle_schedule_states
			SET
				destination_id = (SELECT orders.destination_id FROM orders WHERE orders.id=NEW.order_id)
			WHERE shipment_id = NEW.id;
		END IF;
	END IF;
	
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.shipment_process()
  OWNER TO concrete1;



-- ******************* update 08/05/2024 09:06:45 ******************
-- Function: public.set_vehicle_busy()

-- DROP FUNCTION public.set_vehicle_busy();

CREATE OR REPLACE FUNCTION public.set_vehicle_busy()
  RETURNS trigger AS
$BODY$
DECLARE
	dest_id int;
	spec_id int;
	new_state vehicle_states;
	v_feature vehicles.feature%TYPE;
	reg_act ra_material_consumption%ROWTYPE;
	reg_act_mat ra_materials%ROWTYPE;
	v_concrete_type_id int;
	v_vehicle_id int;
	v_driver_id int;
	rate_row RECORD;
	v_avg_dev numeric;
	v_production_base_id int;
	v_tracker_id varchar(15);
BEGIN
	--change state only if 1) insert
	--		       2) update && shipped false==>true
	IF (TG_OP='INSERT') OR (TG_OP='UPDATE' AND OLD.shipped=false AND NEW.shipped) THEN
		IF NEW.shipped THEN
			new_state = 'busy'::vehicle_states;
			
			--if self-shipment && empty feature - set state out
			SELECT
				o.destination_id,
				coalesce(o.client_specification_id, 0)
			INTO
				dest_id,
				spec_id
			FROM orders AS o
			WHERE o.id=NEW.order_id;
			
			IF dest_id = constant_self_ship_dest_id() THEN
				SELECT v.feature INTO v_feature FROM vehicle_schedules AS vs
				LEFT JOIN vehicles AS v ON v.id=vs.vehicle_id
				WHERE vs.id=NEW.vehicle_schedule_id;
				
				IF (v_feature IS NULL) OR (v_feature='') THEN
					new_state = 'out'::vehicle_states;
				END IF;
			END IF;
			
			--specification
			/*IF spec_id > 0 THEN
				INSERT INTO client_specification_flows
				(client_specification_id, shipment_id, quant)
				VALUES (
					spec_id,
					NEW.id,
					NEW.quant
				)
				ON CONFLICT (client_specification_id, shipment_id) DO UPDATE
				SET quant = NEW.quant;
			END IF;*/
		END IF;
		
		v_tracker_id = get_vehicle_tracker_id_on_schedule_id(NEW.vehicle_schedule_id);
		INSERT INTO vehicle_schedule_states
		(date_time, state, shipment_id, schedule_id, tracker_id, destination_id, production_base_id)
		VALUES(
			current_timestamp,
			CASE
			WHEN NEW.shipped THEN
				new_state
			ELSE
				'assigned'::vehicle_states
			END,
			NEW.id,NEW.vehicle_schedule_id,
			v_tracker_id,
			dest_id,
			veh_cur_production_base_id(v_tracker_id)
		);

	END IF;

	IF (TG_OP='INSERT') THEN
		--log
		PERFORM doc_log_insert('shipment'::doc_types,NEW.id,NEW.date_time);
	ELSE
		--IF NEW.ship_date_time<>OLD.ship_date_time THEN
			PERFORM doc_log_update('shipment'::doc_types,NEW.id,NEW.ship_date_time);
		--END IF;			
	END IF;

	IF (TG_OP='INSERT' OR TG_OP='UPDATE') AND (NEW.shipped) THEN	
		SELECT o.concrete_type_id INTO v_concrete_type_id FROM orders AS o WHERE o.id=NEW.order_id;
		SELECT sch.vehicle_id,sch.driver_id INTO v_vehicle_id,v_driver_id FROM vehicle_schedules As sch WHERE sch.id=NEW.vehicle_schedule_id;
		
		--concrete
		--reg acts				
		reg_act.date_time		= NEW.ship_date_time;
		reg_act.doc_type  		= 'shipment'::doc_types;
		reg_act.doc_id  		= NEW.id;
		reg_act.concrete_type_id 	= v_concrete_type_id;
		reg_act.vehicle_id 		= v_vehicle_id;
		reg_act.driver_id 		= v_driver_id;
		reg_act.concrete_quant		= NEW.quant;
		reg_act.material_quant		= 0;
		reg_act.material_quant_norm	= 0;
		PERFORM ra_material_consumption_add_act(reg_act);	


		SELECT production_base_id INTO v_production_base_id
		FROM production_sites
		WHERE id = NEW.production_site_id;
		
		--materials		
		FOR rate_row IN
			SELECT * FROM raw_material_cons_rates(NEW.production_site_id, v_concrete_type_id, NEW.ship_date_time)
		LOOP
			v_avg_dev = 0;--raw_mat_cons_avg_dev(NEW.ship_date_time::date,rate_row.material_id)*NEW.quant;
			
			--reg acts				
			reg_act.date_time		= NEW.ship_date_time;
			reg_act.doc_type  		= 'shipment'::doc_types;
			reg_act.doc_id  		= NEW.id;
			reg_act.concrete_type_id 	= v_concrete_type_id;
			reg_act.vehicle_id 		= v_vehicle_id;
			reg_act.driver_id 		= v_driver_id;			
			reg_act.material_id 		= rate_row.material_id;
			reg_act.material_quant		= (rate_row.rate * NEW.quant) + v_avg_dev;
			reg_act.material_quant_norm	= rate_row.rate * NEW.quant;
			reg_act.material_quant_corrected= (rate_row.rate * NEW.quant) + v_avg_dev;
			reg_act.concrete_quant		= 0;
			PERFORM ra_material_consumption_add_act(reg_act);	

			--reg materials
			reg_act_mat.date_time		= NEW.ship_date_time;
			reg_act_mat.deb			= false;
			reg_act_mat.doc_type  		= 'shipment'::doc_types;
			reg_act_mat.doc_id  		= NEW.id;
			reg_act_mat.production_base_id	= v_production_base_id;
			reg_act_mat.material_id		= rate_row.material_id;
			reg_act_mat.quant		= rate_row.rate*NEW.quant;
			PERFORM ra_materials_add_act(reg_act_mat);	
			
		END LOOP;
		
		--пересчет нарушения норма/факт по производству
		UPDATE productions
		SET
			material_tolerance_violated = productions_get_mat_tolerance_violated(
				production_site_id,
				production_id
			)
		WHERE shipment_id = NEW.id;
		
		--specification
		SELECT
			coalesce(o.client_specification_id, 0)
		INTO
			spec_id
		FROM orders AS o
		WHERE o.id=NEW.order_id;
		
		IF spec_id > 0 THEN
			INSERT INTO client_specification_flows
			(client_specification_id, shipment_id, quant)
			VALUES (
				spec_id,
				NEW.id,
				NEW.quant
			)
			ON CONFLICT (client_specification_id, shipment_id) DO UPDATE
			SET quant = NEW.quant;
		END IF;
		
	END IF;
	
	IF NEW.date_time::date >= '2024-05-07' THEN
		IF current_database()::text = 'beton' THEN
			--check if client id Konkrid
			IF
				coalesce(
					(SELECT
						o.client_id = (const_konkrid_client_val()->'keys'->>'id')::int
					FROM orders as o
					WHERE o.id = NEW.order_id)
				, FALSE)
			THEN
				INSERT INTO konkrid.replicate_events
					VALUES ('Shipment.to_konkrid',
						json_build_object('params',
							json_build_object('id', NEW.id)
						)::text
				);
			END IF;
		END IF;
	END IF;	
	
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.set_vehicle_busy()
  OWNER TO concrete1;



-- ******************* update 08/05/2024 09:07:07 ******************
-- Function: public.set_vehicle_busy()

-- DROP FUNCTION public.set_vehicle_busy();

CREATE OR REPLACE FUNCTION public.set_vehicle_busy()
  RETURNS trigger AS
$BODY$
DECLARE
	dest_id int;
	spec_id int;
	new_state vehicle_states;
	v_feature vehicles.feature%TYPE;
	reg_act ra_material_consumption%ROWTYPE;
	reg_act_mat ra_materials%ROWTYPE;
	v_concrete_type_id int;
	v_vehicle_id int;
	v_driver_id int;
	rate_row RECORD;
	v_avg_dev numeric;
	v_production_base_id int;
	v_tracker_id varchar(15);
BEGIN
	--change state only if 1) insert
	--		       2) update && shipped false==>true
	IF (TG_OP='INSERT') OR (TG_OP='UPDATE' AND OLD.shipped=false AND NEW.shipped) THEN
		IF NEW.shipped THEN
			new_state = 'busy'::vehicle_states;
			
			--if self-shipment && empty feature - set state out
			SELECT
				o.destination_id,
				coalesce(o.client_specification_id, 0)
			INTO
				dest_id,
				spec_id
			FROM orders AS o
			WHERE o.id=NEW.order_id;
			
			IF dest_id = constant_self_ship_dest_id() THEN
				SELECT v.feature INTO v_feature FROM vehicle_schedules AS vs
				LEFT JOIN vehicles AS v ON v.id=vs.vehicle_id
				WHERE vs.id=NEW.vehicle_schedule_id;
				
				IF (v_feature IS NULL) OR (v_feature='') THEN
					new_state = 'out'::vehicle_states;
				END IF;
			END IF;
			
			--specification
			/*IF spec_id > 0 THEN
				INSERT INTO client_specification_flows
				(client_specification_id, shipment_id, quant)
				VALUES (
					spec_id,
					NEW.id,
					NEW.quant
				)
				ON CONFLICT (client_specification_id, shipment_id) DO UPDATE
				SET quant = NEW.quant;
			END IF;*/
		END IF;
		
		v_tracker_id = get_vehicle_tracker_id_on_schedule_id(NEW.vehicle_schedule_id);
		INSERT INTO vehicle_schedule_states
		(date_time, state, shipment_id, schedule_id, tracker_id, destination_id, production_base_id)
		VALUES(
			current_timestamp,
			CASE
			WHEN NEW.shipped THEN
				new_state
			ELSE
				'assigned'::vehicle_states
			END,
			NEW.id,NEW.vehicle_schedule_id,
			v_tracker_id,
			dest_id,
			veh_cur_production_base_id(v_tracker_id)
		);

	END IF;

	IF (TG_OP='INSERT') THEN
		--log
		PERFORM doc_log_insert('shipment'::doc_types,NEW.id,NEW.date_time);
	ELSE
		--IF NEW.ship_date_time<>OLD.ship_date_time THEN
			PERFORM doc_log_update('shipment'::doc_types,NEW.id,NEW.ship_date_time);
		--END IF;			
	END IF;

	IF (TG_OP='INSERT' OR TG_OP='UPDATE') AND (NEW.shipped) THEN	
		SELECT o.concrete_type_id INTO v_concrete_type_id FROM orders AS o WHERE o.id=NEW.order_id;
		SELECT sch.vehicle_id,sch.driver_id INTO v_vehicle_id,v_driver_id FROM vehicle_schedules As sch WHERE sch.id=NEW.vehicle_schedule_id;
		
		--concrete
		--reg acts				
		reg_act.date_time		= NEW.ship_date_time;
		reg_act.doc_type  		= 'shipment'::doc_types;
		reg_act.doc_id  		= NEW.id;
		reg_act.concrete_type_id 	= v_concrete_type_id;
		reg_act.vehicle_id 		= v_vehicle_id;
		reg_act.driver_id 		= v_driver_id;
		reg_act.concrete_quant		= NEW.quant;
		reg_act.material_quant		= 0;
		reg_act.material_quant_norm	= 0;
		PERFORM ra_material_consumption_add_act(reg_act);	


		SELECT production_base_id INTO v_production_base_id
		FROM production_sites
		WHERE id = NEW.production_site_id;
		
		--materials		
		FOR rate_row IN
			SELECT * FROM raw_material_cons_rates(NEW.production_site_id, v_concrete_type_id, NEW.ship_date_time)
		LOOP
			v_avg_dev = 0;--raw_mat_cons_avg_dev(NEW.ship_date_time::date,rate_row.material_id)*NEW.quant;
			
			--reg acts				
			reg_act.date_time		= NEW.ship_date_time;
			reg_act.doc_type  		= 'shipment'::doc_types;
			reg_act.doc_id  		= NEW.id;
			reg_act.concrete_type_id 	= v_concrete_type_id;
			reg_act.vehicle_id 		= v_vehicle_id;
			reg_act.driver_id 		= v_driver_id;			
			reg_act.material_id 		= rate_row.material_id;
			reg_act.material_quant		= (rate_row.rate * NEW.quant) + v_avg_dev;
			reg_act.material_quant_norm	= rate_row.rate * NEW.quant;
			reg_act.material_quant_corrected= (rate_row.rate * NEW.quant) + v_avg_dev;
			reg_act.concrete_quant		= 0;
			PERFORM ra_material_consumption_add_act(reg_act);	

			--reg materials
			reg_act_mat.date_time		= NEW.ship_date_time;
			reg_act_mat.deb			= false;
			reg_act_mat.doc_type  		= 'shipment'::doc_types;
			reg_act_mat.doc_id  		= NEW.id;
			reg_act_mat.production_base_id	= v_production_base_id;
			reg_act_mat.material_id		= rate_row.material_id;
			reg_act_mat.quant		= rate_row.rate*NEW.quant;
			PERFORM ra_materials_add_act(reg_act_mat);	
			
		END LOOP;
		
		--пересчет нарушения норма/факт по производству
		UPDATE productions
		SET
			material_tolerance_violated = productions_get_mat_tolerance_violated(
				production_site_id,
				production_id
			)
		WHERE shipment_id = NEW.id;
		
		--specification
		SELECT
			coalesce(o.client_specification_id, 0)
		INTO
			spec_id
		FROM orders AS o
		WHERE o.id=NEW.order_id;
		
		IF spec_id > 0 THEN
			INSERT INTO client_specification_flows
			(client_specification_id, shipment_id, quant)
			VALUES (
				spec_id,
				NEW.id,
				NEW.quant
			)
			ON CONFLICT (client_specification_id, shipment_id) DO UPDATE
			SET quant = NEW.quant;
		END IF;
		
	END IF;
	
	IF NEW.date_time::date >= '2024-05-07' THEN
		IF current_database()::text = 'beton' THEN
			--check if client id Konkrid
			IF
				coalesce(
					(SELECT
						o.client_id = (const_konkrid_client_val()->'keys'->>'id')::int
					FROM orders as o
					WHERE o.id = NEW.order_id)
				, FALSE)
			THEN
				INSERT INTO konkrid.replicate_events
					VALUES ('Shipment.to_konkrid',
						json_build_object('params',
							json_build_object('id', NEW.id)
						)::text
				);
			END IF;
		END IF;
	END IF;	
	
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.set_vehicle_busy()
  OWNER TO beton;



-- ******************* update 08/05/2024 09:10:29 ******************
-- Function: public.shipment_process()

-- DROP FUNCTION public.shipment_process();

CREATE OR REPLACE FUNCTION public.shipment_process()
  RETURNS trigger AS
$BODY$
DECLARE quant_rest numeric;
	v_vehicle_load_capacity vehicles.load_capacity%TYPE DEFAULT 0;
	--v_vehicle_feature vehicles.feature%TYPE;
	v_ord_date_time timestamp;
	v_destination_id int;
	--v_tracker_id varchar(15);
	--v_shift_open boolean;
BEGIN
	/*
	IF (TG_OP='UPDATE' AND NEW.shipped AND OLD.shipped) THEN
		--closed shipment, but trying to change smth
		RAISE EXCEPTION 'Для возможности изменения отмените отгрузку!';
	END IF;
	*/

	IF (TG_WHEN='BEFORE' AND TG_OP='UPDATE' AND OLD.shipped=true) THEN
		--register actions
		PERFORM ra_materials_remove_acts('shipment'::doc_types,NEW.id);
		PERFORM ra_material_consumption_remove_acts('shipment'::doc_types,NEW.id);
	END IF;
	
	IF (TG_WHEN='BEFORE' AND TG_OP='UPDATE'
	AND (OLD.vehicle_schedule_id<>NEW.vehicle_schedule_id OR OLD.id<>NEW.id)
	)
	THEN
		--
		DELETE FROM vehicle_schedule_states t WHERE t.shipment_id = OLD.id AND t.schedule_id = OLD.vehicle_schedule_id;	
	END IF;
	
	-- vehicle data
	/*
	IF (TG_OP='INSERT' OR (TG_OP='UPDATE' AND NEW.shipped=false AND OLD.shipped=false)) THEN

		IF (v_vehicle_feature IS NULL)
		OR (
			(v_vehicle_feature<>const_own_vehicles_feature_val())
			AND (v_vehicle_feature<>const_backup_vehicles_feature_val()) 
		) THEN
			SELECT orders.destination_id INTO v_destination_id FROM orders WHERE orders.id=NEW.order_id;
			IF v_destination_id <> const_self_ship_dest_id_val() THEN
				RAISE EXCEPTION 'Данному автомобилю запрещено вывозить на этот объект!';
			END IF;
		END IF;
		
		--IF (TG_OP='INSERT' AND coalesce(v_tracker_id, '') <> '') THEN
			--NEW.production_base_id = veh_cur_production_base_id(v_tracker_id);
		--END IF;
	END IF;
	*/
	
	--checkings for bereg only!
	IF (current_database()::text <> 'concrete1') AND (TG_OP='INSERT' OR (TG_OP='UPDATE' AND NEW.shipped=false AND OLD.shipped=false)) THEN
		SELECT
			v.load_capacity
		INTO
			v_vehicle_load_capacity
		FROM vehicle_schedules AS vs
		LEFT JOIN vehicles AS v ON v.id = vs.vehicle_id
		WHERE vs.id = NEW.vehicle_schedule_id;	
	
		-- ********** check balance ****************************************
		SELECT
			o.quant - SUM(COALESCE(s.quant,0)),
			o.date_time
		INTO
			quant_rest,
			v_ord_date_time
		FROM orders AS o
		LEFT JOIN shipments AS s ON s.order_id=o.id	
		WHERE o.id = NEW.order_id
		GROUP BY o.quant,o.date_time;

		--order shift date MUST overlap shipment shift date!		
		--IF get_shift_start(NEW.date_time)<>get_shift_start(v_ord_date_time) THEN
		--	RAISE EXCEPTION 'Заявка из другой смены!';
		--END IF;
		

		IF (TG_OP='UPDATE') THEN
			quant_rest:= quant_rest + OLD.quant;
		END IF;
		
		IF (quant_rest<NEW.quant::numeric) THEN
			RAISE EXCEPTION 'Остаток по данной заявке: %, запрошено: %',quant_descr(quant_rest::numeric),quant_descr(NEW.quant::numeric);
		END IF;
		-- ********** check balance ****************************************

		
		-- *********  check load capacity *************************************		
		IF v_vehicle_load_capacity < NEW.quant THEN
			RAISE EXCEPTION 'Грузоподъемность автомобиля: "%", запрошено: %',quant_descr(v_vehicle_load_capacity::numeric),quant_descr(NEW.quant::numeric);
		END IF;
		-- *********  check load capacity *************************************
	END IF;

	IF TG_OP='UPDATE' THEN
		IF (NEW.shipped AND OLD.shipped=false) THEN
			NEW.ship_date_time = current_timestamp;
			
			--Если есть привязанное производство - пересчитать
			--возможно изменение отклонений при списании материалов по подбору
			UPDATE productions
			SET
				material_tolerance_violated = productions_get_mat_tolerance_violated(
					production_site_id,
					production_id
				)				
			WHERE shipment_id=NEW.id;
			
		ELSEIF (OLD.shipped AND NEW.shipped=false) THEN
			NEW.ship_date_time = null;
		END IF;
		
		IF (NEW.order_id <> OLD.order_id) THEN
			/** смена заявки
			 * 1) Удалить vehicle_schedule_states сданным id отгрузки и статусом at_dest, как будто и не доехал еще
			 * 2) Исправить все оставшиеся vehicle_schedule_states where shipment_id = NEW.id на новый destionation_id из orders
			 */
			DELETE FROM vehicle_schedule_states WHERE shipment_id = NEW.id AND state= 'at_dest'::vehicle_states;
			UPDATE vehicle_schedule_states
			SET
				destination_id = (SELECT orders.destination_id FROM orders WHERE orders.id=NEW.order_id)
			WHERE shipment_id = NEW.id;
		END IF;
	END IF;
	
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.shipment_process()
  OWNER TO beton;



-- ******************* update 08/05/2024 09:11:00 ******************
-- Function: public.shipment_process()

-- DROP FUNCTION public.shipment_process();

CREATE OR REPLACE FUNCTION public.shipment_process()
  RETURNS trigger AS
$BODY$
DECLARE quant_rest numeric;
	v_vehicle_load_capacity vehicles.load_capacity%TYPE DEFAULT 0;
	--v_vehicle_feature vehicles.feature%TYPE;
	v_ord_date_time timestamp;
	v_destination_id int;
	--v_tracker_id varchar(15);
	--v_shift_open boolean;
BEGIN
	/*
	IF (TG_OP='UPDATE' AND NEW.shipped AND OLD.shipped) THEN
		--closed shipment, but trying to change smth
		RAISE EXCEPTION 'Для возможности изменения отмените отгрузку!';
	END IF;
	*/

	IF (TG_WHEN='BEFORE' AND TG_OP='UPDATE' AND OLD.shipped=true) THEN
		--register actions
		PERFORM ra_materials_remove_acts('shipment'::doc_types,NEW.id);
		PERFORM ra_material_consumption_remove_acts('shipment'::doc_types,NEW.id);
	END IF;
	
	IF (TG_WHEN='BEFORE' AND TG_OP='UPDATE'
	AND (OLD.vehicle_schedule_id<>NEW.vehicle_schedule_id OR OLD.id<>NEW.id)
	)
	THEN
		--
		DELETE FROM vehicle_schedule_states t WHERE t.shipment_id = OLD.id AND t.schedule_id = OLD.vehicle_schedule_id;	
	END IF;
	
	-- vehicle data
	/*
	IF (TG_OP='INSERT' OR (TG_OP='UPDATE' AND NEW.shipped=false AND OLD.shipped=false)) THEN

		IF (v_vehicle_feature IS NULL)
		OR (
			(v_vehicle_feature<>const_own_vehicles_feature_val())
			AND (v_vehicle_feature<>const_backup_vehicles_feature_val()) 
		) THEN
			SELECT orders.destination_id INTO v_destination_id FROM orders WHERE orders.id=NEW.order_id;
			IF v_destination_id <> const_self_ship_dest_id_val() THEN
				RAISE EXCEPTION 'Данному автомобилю запрещено вывозить на этот объект!';
			END IF;
		END IF;
		
		--IF (TG_OP='INSERT' AND coalesce(v_tracker_id, '') <> '') THEN
			--NEW.production_base_id = veh_cur_production_base_id(v_tracker_id);
		--END IF;
	END IF;
	*/
	
	--checkings for bereg only!
	IF (current_database()::text <> 'concrete1') AND (TG_OP='INSERT' OR (TG_OP='UPDATE' AND NEW.shipped=false AND OLD.shipped=false)) THEN
		SELECT
			v.load_capacity
		INTO
			v_vehicle_load_capacity
		FROM vehicle_schedules AS vs
		LEFT JOIN vehicles AS v ON v.id = vs.vehicle_id
		WHERE vs.id = NEW.vehicle_schedule_id;	
	
		-- ********** check balance ****************************************
		SELECT
			o.quant - SUM(COALESCE(s.quant,0)),
			o.date_time
		INTO
			quant_rest,
			v_ord_date_time
		FROM orders AS o
		LEFT JOIN shipments AS s ON s.order_id=o.id	
		WHERE o.id = NEW.order_id
		GROUP BY o.quant,o.date_time;

		--order shift date MUST overlap shipment shift date!		
		--IF get_shift_start(NEW.date_time)<>get_shift_start(v_ord_date_time) THEN
		--	RAISE EXCEPTION 'Заявка из другой смены!';
		--END IF;
		

		IF (TG_OP='UPDATE') THEN
			quant_rest:= quant_rest + OLD.quant;
		END IF;
		
		IF (quant_rest<NEW.quant::numeric) THEN
			RAISE EXCEPTION 'Остаток по данной заявке: %, запрошено: %',quant_descr(quant_rest::numeric),quant_descr(NEW.quant::numeric);
		END IF;
		-- ********** check balance ****************************************

		
		-- *********  check load capacity *************************************		
		IF v_vehicle_load_capacity < NEW.quant THEN
			RAISE EXCEPTION 'Грузоподъемность автомобиля: "%", запрошено: %',quant_descr(v_vehicle_load_capacity::numeric),quant_descr(NEW.quant::numeric);
		END IF;
		-- *********  check load capacity *************************************
	END IF;

	IF TG_OP='UPDATE' THEN
		IF (NEW.shipped AND OLD.shipped=false) THEN
			NEW.ship_date_time = current_timestamp;
			
			--Если есть привязанное производство - пересчитать
			--возможно изменение отклонений при списании материалов по подбору
			UPDATE productions
			SET
				material_tolerance_violated = productions_get_mat_tolerance_violated(
					production_site_id,
					production_id
				)				
			WHERE shipment_id=NEW.id;
			
		ELSEIF (OLD.shipped AND NEW.shipped=false) THEN
			NEW.ship_date_time = null;
		END IF;
		
		IF (NEW.order_id <> OLD.order_id) THEN
			/** смена заявки
			 * 1) Удалить vehicle_schedule_states сданным id отгрузки и статусом at_dest, как будто и не доехал еще
			 * 2) Исправить все оставшиеся vehicle_schedule_states where shipment_id = NEW.id на новый destionation_id из orders
			 */
			DELETE FROM vehicle_schedule_states WHERE shipment_id = NEW.id AND state= 'at_dest'::vehicle_states;
			UPDATE vehicle_schedule_states
			SET
				destination_id = (SELECT orders.destination_id FROM orders WHERE orders.id=NEW.order_id)
			WHERE shipment_id = NEW.id;
		END IF;
	END IF;
	
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.shipment_process()
  OWNER TO concrete1;



-- ******************* update 08/05/2024 09:11:01 ******************
-- Function: public.set_vehicle_busy()

-- DROP FUNCTION public.set_vehicle_busy();

CREATE OR REPLACE FUNCTION public.set_vehicle_busy()
  RETURNS trigger AS
$BODY$
DECLARE
	dest_id int;
	spec_id int;
	new_state vehicle_states;
	v_feature vehicles.feature%TYPE;
	reg_act ra_material_consumption%ROWTYPE;
	reg_act_mat ra_materials%ROWTYPE;
	v_concrete_type_id int;
	v_vehicle_id int;
	v_driver_id int;
	rate_row RECORD;
	v_avg_dev numeric;
	v_production_base_id int;
	v_tracker_id varchar(15);
BEGIN
	--change state only if 1) insert
	--		       2) update && shipped false==>true
	IF (TG_OP='INSERT') OR (TG_OP='UPDATE' AND OLD.shipped=false AND NEW.shipped) THEN
		IF NEW.shipped THEN
			new_state = 'busy'::vehicle_states;
			
			--if self-shipment && empty feature - set state out
			SELECT
				o.destination_id,
				coalesce(o.client_specification_id, 0)
			INTO
				dest_id,
				spec_id
			FROM orders AS o
			WHERE o.id=NEW.order_id;
			
			IF dest_id = constant_self_ship_dest_id() THEN
				SELECT v.feature INTO v_feature FROM vehicle_schedules AS vs
				LEFT JOIN vehicles AS v ON v.id=vs.vehicle_id
				WHERE vs.id=NEW.vehicle_schedule_id;
				
				IF (v_feature IS NULL) OR (v_feature='') THEN
					new_state = 'out'::vehicle_states;
				END IF;
			END IF;
			
			--specification
			/*IF spec_id > 0 THEN
				INSERT INTO client_specification_flows
				(client_specification_id, shipment_id, quant)
				VALUES (
					spec_id,
					NEW.id,
					NEW.quant
				)
				ON CONFLICT (client_specification_id, shipment_id) DO UPDATE
				SET quant = NEW.quant;
			END IF;*/
		END IF;
		
		v_tracker_id = get_vehicle_tracker_id_on_schedule_id(NEW.vehicle_schedule_id);
		INSERT INTO vehicle_schedule_states
		(date_time, state, shipment_id, schedule_id, tracker_id, destination_id, production_base_id)
		VALUES(
			current_timestamp,
			CASE
			WHEN NEW.shipped THEN
				new_state
			ELSE
				'assigned'::vehicle_states
			END,
			NEW.id,NEW.vehicle_schedule_id,
			v_tracker_id,
			dest_id,
			veh_cur_production_base_id(v_tracker_id)
		);

	END IF;

	IF (TG_OP='INSERT') THEN
		--log
		PERFORM doc_log_insert('shipment'::doc_types,NEW.id,NEW.date_time);
	ELSE
		--IF NEW.ship_date_time<>OLD.ship_date_time THEN
			PERFORM doc_log_update('shipment'::doc_types,NEW.id,NEW.ship_date_time);
		--END IF;			
	END IF;

	IF (TG_OP='INSERT' OR TG_OP='UPDATE') AND (NEW.shipped) THEN	
		SELECT o.concrete_type_id INTO v_concrete_type_id FROM orders AS o WHERE o.id=NEW.order_id;
		SELECT sch.vehicle_id,sch.driver_id INTO v_vehicle_id,v_driver_id FROM vehicle_schedules As sch WHERE sch.id=NEW.vehicle_schedule_id;
		
		--concrete
		--reg acts				
		reg_act.date_time		= NEW.ship_date_time;
		reg_act.doc_type  		= 'shipment'::doc_types;
		reg_act.doc_id  		= NEW.id;
		reg_act.concrete_type_id 	= v_concrete_type_id;
		reg_act.vehicle_id 		= v_vehicle_id;
		reg_act.driver_id 		= v_driver_id;
		reg_act.concrete_quant		= NEW.quant;
		reg_act.material_quant		= 0;
		reg_act.material_quant_norm	= 0;
		PERFORM ra_material_consumption_add_act(reg_act);	


		SELECT production_base_id INTO v_production_base_id
		FROM production_sites
		WHERE id = NEW.production_site_id;
		
		--materials		
		FOR rate_row IN
			SELECT * FROM raw_material_cons_rates(NEW.production_site_id, v_concrete_type_id, NEW.ship_date_time)
		LOOP
			v_avg_dev = 0;--raw_mat_cons_avg_dev(NEW.ship_date_time::date,rate_row.material_id)*NEW.quant;
			
			--reg acts				
			reg_act.date_time		= NEW.ship_date_time;
			reg_act.doc_type  		= 'shipment'::doc_types;
			reg_act.doc_id  		= NEW.id;
			reg_act.concrete_type_id 	= v_concrete_type_id;
			reg_act.vehicle_id 		= v_vehicle_id;
			reg_act.driver_id 		= v_driver_id;			
			reg_act.material_id 		= rate_row.material_id;
			reg_act.material_quant		= (rate_row.rate * NEW.quant) + v_avg_dev;
			reg_act.material_quant_norm	= rate_row.rate * NEW.quant;
			reg_act.material_quant_corrected= (rate_row.rate * NEW.quant) + v_avg_dev;
			reg_act.concrete_quant		= 0;
			PERFORM ra_material_consumption_add_act(reg_act);	

			--reg materials
			reg_act_mat.date_time		= NEW.ship_date_time;
			reg_act_mat.deb			= false;
			reg_act_mat.doc_type  		= 'shipment'::doc_types;
			reg_act_mat.doc_id  		= NEW.id;
			reg_act_mat.production_base_id	= v_production_base_id;
			reg_act_mat.material_id		= rate_row.material_id;
			reg_act_mat.quant		= rate_row.rate*NEW.quant;
			PERFORM ra_materials_add_act(reg_act_mat);	
			
		END LOOP;
		
		--пересчет нарушения норма/факт по производству
		UPDATE productions
		SET
			material_tolerance_violated = productions_get_mat_tolerance_violated(
				production_site_id,
				production_id
			)
		WHERE shipment_id = NEW.id;
		
		--specification
		SELECT
			coalesce(o.client_specification_id, 0)
		INTO
			spec_id
		FROM orders AS o
		WHERE o.id=NEW.order_id;
		
		IF spec_id > 0 THEN
			INSERT INTO client_specification_flows
			(client_specification_id, shipment_id, quant)
			VALUES (
				spec_id,
				NEW.id,
				NEW.quant
			)
			ON CONFLICT (client_specification_id, shipment_id) DO UPDATE
			SET quant = NEW.quant;
		END IF;
		
	END IF;
	
	IF NEW.date_time::date >= '2024-05-07' THEN
		IF current_database()::text = 'beton' THEN
			--check if client id Konkrid
			IF
				coalesce(
					(SELECT
						o.client_id = (const_konkrid_client_val()->'keys'->>'id')::int
					FROM orders as o
					WHERE o.id = NEW.order_id)
				, FALSE)
			THEN
				INSERT INTO konkrid.replicate_events
					VALUES ('Shipment.to_konkrid',
						json_build_object('params',
							json_build_object('id', NEW.id)
						)::text
				);
			END IF;
		END IF;
	END IF;	
	
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.set_vehicle_busy()
  OWNER TO concrete1;



-- ******************* update 13/05/2024 15:44:25 ******************
-- FUNCTION: public.init_vehicle_state()

-- DROP FUNCTION IF EXISTS public.init_vehicle_state();

CREATE OR REPLACE FUNCTION public.init_vehicle_state()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
	INSERT INTO vehicle_schedule_states (date_time,state,schedule_id,tracker_id) VALUES (NEW.schedule_date + constant_first_shift_start_time(),
		CASE			
			WHEN NEW.auto_gen THEN 'shift'::vehicle_states
			WHEN NEW.auto_gen=false
				AND get_shift_start(CURRENT_TIMESTAMP::timestamp without time zone)=get_shift_start(NEW.schedule_date+constant_first_shift_start_time()) THEN
				'free'::vehicle_states
			ELSE 'shift_added'::vehicle_states
		END,
		NEW.id,
		get_vehicle_tracker_id_on_schedule_id(NEW.id));
		
	IF (current_database()::text = 'beton') THEN
		IF
			coalesce(
				(SELECT
						(owners.f->'owner'->'keys'->>'id')::int = 286 AS konkrid_owned
				FROM (
					SELECT
							jsonb_array_elements(vehicle_owners->'rows')->'fields' AS f
					FROM vehicles AS v
					WHERE v.tracker_id = (SELECT vehicles.tracker_id FROM vehicles WHERE vehicles.id = NEW.vehicle_id AND coalesce(vehicles.tracker_id,'')<>'')
				) AS owners
				ORDER BY (owners.f->>'dt_from')::timestamp DESC
				LIMIT 1)
			, FALSE
			) THEN
			
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('VehicleSchedule.to_konkrid',
					json_build_object('params',
						json_build_object('id', NEW.id)
					)::text
			);
		END IF;
	END IF;
		
	RETURN NEW;
EXCEPTION WHEN raise_exception THEN
	RAISE EXCEPTION 'Нет возможности добавить автомобиль!';
END;
$BODY$;

ALTER FUNCTION public.init_vehicle_state()
    OWNER TO beton;



-- ******************* update 13/05/2024 15:53:36 ******************
﻿-- Function: vehicle_schedules_to_konkrid(in_vehicle_schedule_id int, in_vehicle_id int, in_oper text)

-- DROP FUNCTION vehicle_schedules_to_konkrid(in_vehicle_schedule_id int, in_vehicle_id int, in_oper text);

CREATE OR REPLACE FUNCTION vehicle_schedules_to_konkrid(in_vehicle_schedule_id int, in_vehicle_id int, in_oper text)
  RETURNS void AS
$$
BEGIN
	IF
		coalesce(
			(SELECT
					(owners.f->'owner'->'keys'->>'id')::int = 286 AS konkrid_owned
			FROM (
				SELECT
						jsonb_array_elements(vehicle_owners->'rows')->'fields' AS f
				FROM vehicles AS v
				WHERE v.tracker_id = (SELECT vehicles.tracker_id FROM vehicles WHERE vehicles.id = in_vehicle_id AND coalesce(vehicles.tracker_id,'')<>'')
			) AS owners
			ORDER BY (owners.f->>'dt_from')::timestamp DESC
			LIMIT 1)
		, FALSE
		) THEN
		
		INSERT INTO konkrid.bereg_to_konkrid
			VALUES ('VehicleSchedule.to_konkrid_' || in_oper,
				json_build_object('params',
					json_build_object('id', in_vehicle_schedule_id)
				)::text
		);
	END IF;
END	
$$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION vehicle_schedules_to_konkrid(in_vehicle_schedule_id int, in_vehicle_id int, in_oper text) OWNER TO beton;


-- ******************* update 13/05/2024 15:54:50 ******************
-- FUNCTION: public.init_vehicle_state()

-- DROP FUNCTION IF EXISTS public.init_vehicle_state();

CREATE OR REPLACE FUNCTION public.init_vehicle_state()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
	INSERT INTO vehicle_schedule_states (date_time,state,schedule_id,tracker_id) VALUES (NEW.schedule_date + constant_first_shift_start_time(),
		CASE			
			WHEN NEW.auto_gen THEN 'shift'::vehicle_states
			WHEN NEW.auto_gen=false
				AND get_shift_start(CURRENT_TIMESTAMP::timestamp without time zone)=get_shift_start(NEW.schedule_date+constant_first_shift_start_time()) THEN
				'free'::vehicle_states
			ELSE 'shift_added'::vehicle_states
		END,
		NEW.id,
		get_vehicle_tracker_id_on_schedule_id(NEW.id));
		
	IF (current_database()::text = 'beton') THEN
		PERFORM vehicle_schedules_to_konkrid(NEW.id, NEW.vehicle_id, LOWER(TG_OP));
	END IF;
		
	RETURN NEW;
EXCEPTION WHEN raise_exception THEN
	RAISE EXCEPTION 'Нет возможности добавить автомобиль!';
END;
$BODY$;

ALTER FUNCTION public.init_vehicle_state()
    OWNER TO beton;



-- ******************* update 13/05/2024 15:55:42 ******************
﻿-- Function: vehicle_schedules_to_konkrid(in_vehicle_schedule_id int, in_vehicle_id int, in_oper text)

-- DROP FUNCTION vehicle_schedules_to_konkrid(in_vehicle_schedule_id int, in_vehicle_id int, in_oper text);

CREATE OR REPLACE FUNCTION vehicle_schedules_to_konkrid(in_vehicle_schedule_id int, in_vehicle_id int, in_oper text)
  RETURNS void AS
$$
BEGIN
	IF
		coalesce(
			(SELECT
					(owners.f->'owner'->'keys'->>'id')::int = 286 AS konkrid_owned
			FROM (
				SELECT
						jsonb_array_elements(vehicle_owners->'rows')->'fields' AS f
				FROM vehicles AS v
				WHERE v.tracker_id = (SELECT vehicles.tracker_id FROM vehicles WHERE vehicles.id = in_vehicle_id AND coalesce(vehicles.tracker_id,'')<>'')
			) AS owners
			ORDER BY (owners.f->>'dt_from')::timestamp DESC
			LIMIT 1)
		, FALSE
		) THEN
		
		INSERT INTO konkrid.bereg_to_konkrid
			VALUES ('VehicleSchedule.to_konkrid_' || in_oper,
				json_build_object('params',
					json_build_object('id', in_vehicle_schedule_id)
				)::text
		);
	END IF;
END;	
$$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION vehicle_schedules_to_konkrid(in_vehicle_schedule_id int, in_vehicle_id int, in_oper text) OWNER TO beton;


-- ******************* update 13/05/2024 15:56:52 ******************
-- Function: public.vehicle_schedules_process()

-- DROP FUNCTION public.vehicle_schedules_process();

CREATE OR REPLACE FUNCTION public.vehicle_schedules_process()
  RETURNS trigger AS
$BODY$
BEGIN
	--checkings for bereg only!
	IF TG_OP='UPDATE'  THEN
		IF (current_database()::text = 'beton') THEN
			PERFORM vehicle_schedules_to_konkrid(NEW.id, NEW.vehicle_id, LOWER(TG_OP));
		END IF;
	
		RETURN NEW;
		
	ELSIF TG_OP='DELETE' THEN
		IF (current_database()::text = 'beton') THEN
			PERFORM vehicle_schedules_to_konkrid(OLD.id, OLD.vehicle_id, LOWER(TG_OP));
		END IF;
	
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.vehicle_schedules_process()
  OWNER TO beton;



-- ******************* update 13/05/2024 15:58:34 ******************
-- Function: public.vehicle_schedules_process()

 DROP FUNCTION public.vehicle_schedules_process();
/*
CREATE OR REPLACE FUNCTION public.vehicle_schedules_process()
  RETURNS trigger AS
$BODY$
BEGIN
	--checkings for bereg only!
	IF TG_OP='UPDATE'  THEN
		IF (current_database()::text = 'beton') THEN
			PERFORM vehicle_schedules_to_konkrid(NEW.id, NEW.vehicle_id, LOWER(TG_OP));
		END IF;
	
		RETURN NEW;
		
	ELSIF TG_OP='DELETE' THEN
		IF (current_database()::text = 'beton') THEN
			PERFORM vehicle_schedules_to_konkrid(OLD.id, OLD.vehicle_id, LOWER(TG_OP));
		END IF;
	
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.vehicle_schedules_process()
  OWNER TO beton;

*/


-- ******************* update 13/05/2024 15:58:53 ******************
-- Function: public.vehicle_schedules_after_process()

-- DROP FUNCTION public.vehicle_schedules_after_process();

CREATE OR REPLACE FUNCTION public.vehicle_schedules_after_process()
  RETURNS trigger AS
$BODY$
BEGIN
	--checkings for bereg only!
	IF TG_OP='UPDATE'  THEN
		IF (current_database()::text = 'beton') THEN
			PERFORM vehicle_schedules_to_konkrid(NEW.id, NEW.vehicle_id, LOWER(TG_OP));
		END IF;
	
		RETURN NEW;
		
	ELSIF TG_OP='DELETE' THEN
		IF (current_database()::text = 'beton') THEN
			PERFORM vehicle_schedules_to_konkrid(OLD.id, OLD.vehicle_id, LOWER(TG_OP));
		END IF;
	
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.vehicle_schedules_after_process()
  OWNER TO beton;




-- ******************* update 13/05/2024 15:58:59 ******************
-- Trigger: vehicle_schedules_trigger_after

-- DROP TRIGGER IF EXISTS vehicle_schedules_trigger_after ON public.vehicle_schedules;

CREATE OR REPLACE TRIGGER vehicle_schedules_trigger_after
    AFTER UPDATE OR DELETE
    ON public.vehicle_schedules
    FOR EACH ROW
    EXECUTE FUNCTION public.vehicle_schedules_after_process();



-- ******************* update 19/05/2024 09:08:05 ******************
-- FUNCTION: public.geo_zone_check()

-- DROP FUNCTION IF EXISTS public.geo_zone_check();

CREATE OR REPLACE FUNCTION public.geo_zone_check()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	v_cur_state vehicle_states;
	v_production_base_id int;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	
	v_zone geometry;
	
	v_st_date_time timestamp without time zone;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;
	v_long_route_rest bool;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;

	--get last state
	WITH
	shift AS (
		SELECT
			d_from,
			d_to
		FROM get_shift_bounds(NEW.recieved_dt + age(now(), now() at time zone 'UTC')) AS (d_from timestamp, d_to timestamp)
	)
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE
		st.tracker_id = NEW.car_id
		AND st.date_time BETWEEN (SELECT d_from FROM shift) AND (SELECT d_to FROM shift)
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF v_cur_state = 'busy'::vehicle_states THEN
			--clients zone on shipment
			SELECT				
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id = shipments.order_id
			LEFT JOIN destinations ON destinations.id = orders.destination_id
			WHERE
				shipments.id = v_shipment_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
			
		ELSIF  v_cur_state = 'at_dest'::vehicle_states THEN
			-- client zone from state
			SELECT
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM destinations
			WHERE
				destinations.id = v_destination_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
		ELSE
			--
			-- base zone
			-- ALL possible zones, NOT const_base_geo_zone_id_val()
			-- returns one zone only
			SELECT
				b.id,
				b.destination_id,
				destinations.zone
			INTO
				v_production_base_id,
				v_destination_id,
				v_zone
			FROM production_bases AS b
			LEFT JOIN destinations ON destinations.id = b.destination_id
			WHERE
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			LIMIT 1			
			;
					
		END IF;		
		
		--if at least the last point inside zone
		IF v_zone IS NOT NULL THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat
					FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid = 1
					ORDER BY t.period DESC
					LIMIT const_geo_zone_check_points_count_val() - 1
					OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					-- v_production_base_id = previous state value
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					-- v_production_base_id = previous state value OR some other logic!!! Куда назначили
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
					--v_production_base_id = Фактическая зона, зона производственной площадки
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id, destination_id, shipment_id, production_base_id)
					VALUES (CURRENT_TIMESTAMP,
						v_schedule_id,
						v_new_state,
						NEW.car_id,
						v_destination_id,
						v_shipment_id,
						v_production_base_id
					);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						--v_cur_state='at_dest' OR 
						WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		/*IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%, v_cur_state=%',v_shipment_id,v_cur_state;
		END IF;*/
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = const_base_geo_zone_id_val()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						/*v_point_in_zone = FALSE;
						SELECT
							st_contains(
								st_transform(
									st_buffer(
										st_transform(
											ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
											,3857
										)
										,30
									)
								,4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
						END IF;
						*/
						
						IF v_destination_id IS NOT NULL AND v_client_id IS NOT NULL THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT (client_id,destination_id) DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;						
						--route done
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										--v_cur_state='at_dest' OR 
										WHEN v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		SELECT (length(v_hypothetical_route_rest_t)>7500) INTO v_long_route_rest;
		IF v_long_route_rest THEN
			INSERT INTO route_rests VALUES(NEW.car_id,v_hypothetical_route_rest_t)
			ON CONFLICT (tracker_id) DO UPDATE SET
			route_rest = v_hypothetical_route_rest_t;
		END IF;
		
		--returns vehicles_last_pos struc + route
		BEGIN
			PERFORM pg_notify(
				'Vehicle.position.'||NEW.car_id
				,json_build_object(
					'params',json_build_object(
						'tracker_id',NEW.car_id
						,'lon',NEW.lon
						,'lat',NEW.lat
						,'heading',NEW.heading
						,'speed',NEW.speed
						,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'ns',NEW.ns
						,'ew',NEW.ew
						,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'odometer',NEW.odometer::text
						,'voltage',round(NEW.voltage,0)
						,'route_rest',CASE WHEN v_long_route_rest THEN NULL ELSE v_hypothetical_route_rest_t END
						,'long_route_rest',v_long_route_rest
						,'route_rest_len',v_hypothetical_route_rest_len
					)
				)::text
			);
		EXCEPTION WHEN OTHERS THEN
		END;
	END IF;

	--from beton to konkrid
	
	IF current_database() = 'beton' THEN
		--all vehicles to konkrid
		/*INSERT INTO konkrid.replicate_events
			VALUES ('CarTracking.to_konkrid',
				json_build_object('params',
					json_build_object('car_id', NEW.car_id, 'period', NEW.period)
				)::text
		);*/
		
		--whose car?
		--konkrid ownerID=286
		/*		
		IF
			coalesce(
				(SELECT
						(owners.f->'owner'->'keys'->>'id')::int = 286 AS konkrid_owned
				FROM (
					SELECT
							jsonb_array_elements(vehicle_owners->'rows')->'fields' AS f
					FROM vehicles AS v
					WHERE v.tracker_id = NEW.car_id
				) AS owners
				ORDER BY (owners.f->>'dt_from')::timestamp DESC
				LIMIT 1)
			, FALSE
			) THEN
			
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('CarTracking.to_konkrid',
					json_build_object('params',
						json_build_object('car_id', NEW.car_id, 'period', NEW.period)
					)::text
			);
		END IF;
		*/
	END IF;
		
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.geo_zone_check()
    OWNER TO beton;



-- ******************* update 19/05/2024 09:11:37 ******************
-- FUNCTION: public.geo_zone_check()

-- DROP FUNCTION IF EXISTS public.geo_zone_check();

CREATE OR REPLACE FUNCTION public.geo_zone_check()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	v_cur_state vehicle_states;
	v_production_base_id int;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	
	v_zone geometry;
	
	v_st_date_time timestamp without time zone;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;
	v_long_route_rest bool;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;

	--get last state
	WITH
	shift AS (
		SELECT
			d_from,
			d_to
		FROM get_shift_bounds(NEW.recieved_dt + age(now(), now() at time zone 'UTC')) AS (d_from timestamp, d_to timestamp)
	)
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE
		st.tracker_id = NEW.car_id
		AND st.date_time BETWEEN (SELECT d_from FROM shift) AND (SELECT d_to FROM shift)
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF v_cur_state = 'busy'::vehicle_states THEN
			--clients zone on shipment
			SELECT				
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id = shipments.order_id
			LEFT JOIN destinations ON destinations.id = orders.destination_id
			WHERE
				shipments.id = v_shipment_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
			
		ELSIF  v_cur_state = 'at_dest'::vehicle_states THEN
			-- client zone from state
			SELECT
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM destinations
			WHERE
				destinations.id = v_destination_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
		ELSE
			--
			-- base zone
			-- ALL possible zones, NOT const_base_geo_zone_id_val()
			-- returns one zone only
			SELECT
				b.id,
				b.destination_id,
				destinations.zone
			INTO
				v_production_base_id,
				v_destination_id,
				v_zone
			FROM production_bases AS b
			LEFT JOIN destinations ON destinations.id = b.destination_id
			WHERE
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			LIMIT 1			
			;
					
		END IF;		
		
		--if at least the last point inside zone
		IF v_zone IS NOT NULL THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat
					FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid = 1
					ORDER BY t.period DESC
					LIMIT const_geo_zone_check_points_count_val() - 1
					OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					-- v_production_base_id = previous state value
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					-- v_production_base_id = previous state value OR some other logic!!! Куда назначили
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
					--v_production_base_id = Фактическая зона, зона производственной площадки
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id, destination_id, shipment_id, production_base_id)
					VALUES (CURRENT_TIMESTAMP,
						v_schedule_id,
						v_new_state,
						NEW.car_id,
						v_destination_id,
						v_shipment_id,
						v_production_base_id
					);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						--v_cur_state='at_dest' OR 
						WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		/*IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%, v_cur_state=%',v_shipment_id,v_cur_state;
		END IF;*/
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = const_base_geo_zone_id_val()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						/*v_point_in_zone = FALSE;
						SELECT
							st_contains(
								st_transform(
									st_buffer(
										st_transform(
											ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
											,3857
										)
										,30
									)
								,4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
						END IF;
						*/
						
						IF v_destination_id IS NOT NULL AND v_client_id IS NOT NULL THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT (client_id,destination_id) DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;						
						--route done
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										--v_cur_state='at_dest' OR 
										WHEN v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		SELECT (length(v_hypothetical_route_rest_t)>7500) INTO v_long_route_rest;
		IF v_long_route_rest THEN
			INSERT INTO route_rests VALUES(NEW.car_id,v_hypothetical_route_rest_t)
			ON CONFLICT (tracker_id) DO UPDATE SET
			route_rest = v_hypothetical_route_rest_t;
		END IF;
		
		--returns vehicles_last_pos struc + route
		BEGIN
			PERFORM pg_notify(
				'Vehicle.position.'||NEW.car_id
				,json_build_object(
					'params',json_build_object(
						'tracker_id',NEW.car_id
						,'lon',NEW.lon
						,'lat',NEW.lat
						,'heading',NEW.heading
						,'speed',NEW.speed
						,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'ns',NEW.ns
						,'ew',NEW.ew
						,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'odometer',NEW.odometer::text
						,'voltage',round(NEW.voltage,0)
						,'route_rest',CASE WHEN v_long_route_rest THEN NULL ELSE v_hypothetical_route_rest_t END
						,'long_route_rest',v_long_route_rest
						,'route_rest_len',v_hypothetical_route_rest_len
					)
				)::text
			);
		EXCEPTION WHEN OTHERS THEN
		END;
	END IF;

	--from beton to konkrid
	
	IF current_database() = 'beton' THEN
		--all vehicles to konkrid
		INSERT INTO konkrid.replicate_events
			VALUES ('CarTracking.to_konkrid',
				json_build_object('params',
					json_build_object('car_id', NEW.car_id, 'period', NEW.period::text)
				)::text
		);
		
		--whose car?
		--konkrid ownerID=286
		/*		
		IF
			coalesce(
				(SELECT
						(owners.f->'owner'->'keys'->>'id')::int = 286 AS konkrid_owned
				FROM (
					SELECT
							jsonb_array_elements(vehicle_owners->'rows')->'fields' AS f
					FROM vehicles AS v
					WHERE v.tracker_id = NEW.car_id
				) AS owners
				ORDER BY (owners.f->>'dt_from')::timestamp DESC
				LIMIT 1)
			, FALSE
			) THEN
			
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('CarTracking.to_konkrid',
					json_build_object('params',
						json_build_object('car_id', NEW.car_id, 'period', NEW.period)
					)::text
			);
		END IF;
		*/
	END IF;
		
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.geo_zone_check()
    OWNER TO beton;



-- ******************* update 24/05/2024 05:02:40 ******************

		ALTER TABLE public.raw_material_tickets ADD COLUMN quarry_id int REFERENCES quarries(id);



-- ******************* update 24/05/2024 05:03:11 ******************


-- DROP FUNCTION public.quarries_ref(quarries);

CREATE OR REPLACE FUNCTION public.quarries_ref(quarries)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr',$1.name,
		'dataType','quarries'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.quarries_ref(quarries) OWNER TO concrete1;



-- ******************* update 24/05/2024 05:03:24 ******************
-- VIEW: raw_material_ticket_carrier_agg_list

 DROP VIEW raw_material_ticket_carrier_agg_list;

CREATE OR REPLACE VIEW raw_material_ticket_carrier_agg_list AS
	WITH
	sel AS (
		SELECT
			carrier_id,
			raw_material_id,
			quarry_id,
			quant,
			count(*) AS ticket_count,
			count(*) * quant AS quant_tot
		FROM raw_material_tickets		
		WHERE close_date_time IS NULL
		GROUP BY
			carrier_id,
			raw_material_id,
			quarry_id,
			quant				
	)
	SELECT
		suppliers_ref(sp) AS carriers_ref,
		materials_ref(mat) AS raw_materials_ref,
		quarries_ref(qr) AS quarries_ref,
		sel.quant,
		sel.ticket_count,
		sel.quant_tot
	FROM sel
	LEFT JOIN suppliers AS sp ON sp.id = sel.carrier_id
	LEFT JOIN raw_materials AS mat ON mat.id = sel.raw_material_id	
	LEFT JOIN quarries AS qr ON qr.id = sel.quarry_id
	ORDER BY sp.name, mat.name
	;
	
-- ALTER VIEW raw_material_ticket_carrier_agg_list OWNER TO concrete1;



-- ******************* update 24/05/2024 05:03:36 ******************
-- VIEW: raw_material_tickets_list

--DROP VIEW raw_material_tickets_list;

CREATE OR REPLACE VIEW raw_material_tickets_list AS
	SELECT
		t.id 
		,t.carrier_id
		,suppliers_ref(cr) AS carriers_ref
		,t.raw_material_id
		,materials_ref(m) AS raw_materials_ref
		,t.barcode
		,t.quant
		,t.issue_date_time
		,t.close_date_time
		,t.issue_user_id
		,users_ref(i_u) AS issue_users_ref
		,t.close_user_id
		,users_ref(c_u) AS close_users_ref
		,t.expire_date
		
	FROM raw_material_tickets AS t
	LEFT JOIN suppliers AS cr ON cr.id = t.carrier_id
	LEFT JOIN raw_materials AS m ON m.id = t.raw_material_id
	LEFT JOIN users AS i_u ON i_u.id = t.issue_user_id
	LEFT JOIN users AS c_u ON c_u.id = t.close_user_id
	LEFT JOIN quarries AS qr ON qr.id = t.quarry_id
	ORDER BY t.issue_date_time DESC
	;
	
-- ALTER VIEW raw_material_tickets_list OWNER TO concrete1;


-- ******************* update 27/05/2024 14:19:56 ******************
-- FUNCTION: public.vehicle_schedule_states_process()

-- DROP FUNCTION IF EXISTS public.vehicle_schedule_states_process();

CREATE OR REPLACE FUNCTION public.vehicle_schedule_states_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	v_veh_at_work_count int;
	v_old_state vehicle_states;
	v_controled_states vehicle_states[];
	veh_count int;
	v_vehicle_feature vehicles.feature%TYPE;
	--v_do_control_max_count boolean;
BEGIN
	IF TG_WHEN='BEFORE' AND TG_OP='INSERT' THEN
		/*
		IF (NEW.state='free'::vehicle_states)
		AND (now()::date=NEW.date_time::date AND  now()::time<(constant_first_shift_start_time()+constant_day_shift_length()::interval)) THEN
			--ON DAY SHIFT ONLY!!!!

			--check if it is ITS shift
			SELECT true INTO v_do_control_max_count FROM vehicle_schedule_states AS st
			WHERE st.date_time::date=NEW.date_time::date
				AND st.schedule_id=NEW.schedule_id
				AND st.state='shift'::vehicle_states;

			--check vehicle counts
			IF NOT FOUND THEN			
				v_controled_states = ARRAY['free'::vehicle_states,'assigned'::vehicle_states,'busy'::vehicle_states,'at_dest'::vehicle_states,'left_for_base'::vehicle_states];

				--current (old) state
				SELECT
					coalesce(vehicle_schedule_states.state,'out'::vehicle_states) INTO v_old_state
				FROM vehicle_schedule_states
				WHERE vehicle_schedule_states.schedule_id = NEW.schedule_id
				ORDER BY vehicle_schedule_states.date_time DESC
				LIMIT 1;

				IF NOT FOUND THEN
					v_old_state = 'out'::vehicle_states;
				END IF;

				v_do_control_max_count = (NOT v_old_state = ANY(v_controled_states));

				IF v_do_control_max_count THEN
					--need feature
					SELECT v.feature INTO v_vehicle_feature
					FROM vehicle_schedules AS vs
					LEFT JOIN vehicles AS v ON v.id=vs.vehicle_id
					WHERE vs.id=NEW.schedule_id;
				
					v_do_control_max_count = ( (v_vehicle_feature IS NOT NULL) 
					AND (v_vehicle_feature=constant_own_vehicles_feature() OR v_vehicle_feature=constant_backup_vehicles_feature()) );
				END IF;
			
				IF v_do_control_max_count THEN
					SELECT * INTO v_veh_at_work_count FROM get_working_vehicles_count_main(NEW.date_time::date);

					veh_count = constant_max_vehicle_at_work();
					IF v_veh_at_work_count>=veh_count THEN
						RAISE EXCEPTION 'Максимально допустимое количество машин на линии: %. Нет возможности добавить еще.',veh_count;
					END IF;
				END IF;
			END IF;
		END IF;
		*/
		
		IF NEW.state='free'::vehicle_states AND coalesce(NEW.tracker_id,'')<>'' AND NEW.production_base_id IS NULL THEN
			NEW.production_base_id = veh_cur_production_base_id(NEW.tracker_id);
		END IF;
				
		RETURN NEW;
			
	ELSIF TG_WHEN='BEFORE' AND TG_OP='DELETE' THEN
	
		UPDATE productions
		SET
			vehicle_schedule_state_id=NULL,
			shipment_id=NULL
		WHERE shipment_id = OLD.shipment_id;
		
		RETURN OLD;
	
	ELSIF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
	
		PERFORM pg_notify(
				'VehicleScheduleState.insert'
			,json_build_object(
				'params',json_build_object(
					'id',NEW.id,
					'lsn', pg_current_wal_lsn()
				)
			)::text
		);
	
		RETURN NEW;

	ELSIF TG_WHEN='AFTER' AND TG_OP='UPDATE' THEN
	
		PERFORM pg_notify(
				'VehicleScheduleState.update'
			,json_build_object(
				'params',json_build_object(
					'id',NEW.id,
					'lsn', pg_current_wal_lsn()
				)
			)::text
		);
	
		RETURN NEW;

	ELSIF TG_WHEN='AFTER' AND TG_OP='DELETE' THEN
	
		PERFORM pg_notify(
				'VehicleScheduleState.delete'
			,json_build_object(
				'params',json_build_object(
					'id',OLD.id,
					'lsn', pg_current_wal_lsn()
				)
			)::text
		);
	
		RETURN OLD;
	END IF;
	
	
END;
$BODY$;

ALTER FUNCTION public.vehicle_schedule_states_process()
    OWNER TO beton;



-- ******************* update 03/06/2024 17:31:49 ******************

		ALTER TABLE public.excel_templates ADD COLUMN update_dt timestampTZ;
		

-- ******************* update 03/06/2024 17:33:16 ******************

alter table excel_templates alter column update_dt set default now();

		


-- ******************* update 04/06/2024 15:06:38 ******************

	-- ********** Adding new table from model **********
	CREATE TABLE public.order_garbage()
	INHERITS (orders);



-- ******************* update 04/06/2024 15:57:06 ******************
-- View: order_garbage_list

-- DROP VIEW order_garbage_list;

CREATE OR REPLACE VIEW order_garbage_list AS 
	SELECT
		o.id,
		order_num(o.*) AS number,
		clients_ref(cl) AS clients_ref,
		o.client_id,
		destinations_ref(d) AS destinations_ref,
		o.destination_id,
		concrete_types_ref(concr) AS concrete_types_ref,
		o.concrete_type_id,
		o.unload_type AS unload_type,
		o.comment_text AS comment_text,
		
		coalesce(ct.name::text, o.descr::text) AS descr,
		coalesce(ct.tel::text, o.phone_cel::text) AS phone_cel,
		
		o.date_time,
		o.quant,
		users_ref(u) AS users_ref,
		o.user_id,
		orders_ref(o) AS orders_ref,
		contacts_ref(ct) AS contacts_ref		
		
   FROM order_garbage o
   LEFT JOIN clients cl ON cl.id = o.client_id
   LEFT JOIN destinations d ON d.id = o.destination_id
   LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
   LEFT JOIN contacts ct ON ct.id = o.contact_id
   LEFT JOIN users u ON u.id = o.user_id
  ORDER BY o.date_time DESC;

ALTER TABLE order_garbage_list OWNER TO beton;


-- ******************* update 05/06/2024 07:23:41 ******************
-- View: public.order_garbage_dialog

-- DROP VIEW public.order_garbage_dialog;

CREATE OR REPLACE VIEW public.order_garbage_dialog AS 

	SELECT * FROM orders_dialog;
	
ALTER TABLE public.order_garbage_dialog OWNER TO beton;


-- ******************* update 05/06/2024 07:24:50 ******************
-- View: public.order_garbage_dialog

 DROP VIEW public.order_garbage_dialog;

CREATE OR REPLACE VIEW public.order_garbage_dialog AS 

	SELECT
		o.id,
		order_num(o.*) AS number,		
		clients_ref(cl) AS clients_ref,		
		
		destinations_ref(d) AS destinations_ref,
		o.destination_price AS destination_cost,		
		--d.price AS destination_price,		
		CASE
			WHEN coalesce(d.special_price,FALSE) THEN
				--coalesce(d.price,0)
				period_value('destination_price', d.id, o.date_time)::numeric(15,2)
			ELSE
			coalesce(
				(SELECT sh_p.price
				FROM shipment_for_owner_costs sh_p
				WHERE sh_p.date<=o.date_time::date AND sh_p.distance_to>=d.distance
				ORDER BY sh_p.date DESC,sh_p.distance_to ASC
				LIMIT 1
				),			
			coalesce(d.price,0))			
		END  AS destination_price,
		
		d.time_route,
		d.distance,
		
		concrete_types_ref(concr) AS concrete_types_ref,
		o.concrete_price AS concrete_cost,		
		--concr.price AS concrete_price,
		coalesce(
			/*(SELECT
				ct_p.price
			FROM concrete_costs ct_p
			WHERE ct_p.date<=o.date_time::date AND ct_p.concrete_type_id=o.concrete_type_id
			ORDER BY ct_p.date DESC
			LIMIT 1
			),*/
			(SELECT pr.price FROM client_price_list(o.client_id,o.date_time)AS pr WHERE pr.concrete_type_id=o.concrete_type_id),
			coalesce(concr.price,0)
		) AS concrete_price,
		
		o.unload_type,
		o.comment_text,
		
		coalesce(ct.name::text, o.descr::text) AS descr,
		coalesce(ct.tel::text, o.phone_cel::text) AS phone_cel,
		
		o.unload_speed,
		o.date_time,
		o.time_to,		
		o.quant,
		langs_ref(l) AS langs_ref,
		o.total,
		o.total_edit,
		o.pay_cash,
		o.unload_price AS unload_cost,
		o.payed,
		o.under_control,
		
		pv.phone_cel AS pump_vehicle_phone_cel,
		pump_vehicles_ref(pv,v) AS pump_vehicles_ref,
		pump_prices_ref(ppr) AS pump_prices_ref,
		
		users_ref(u) AS users_ref,
		
		d.distance AS destination_distance,
		
		users_ref(lm_u) AS last_modif_users_ref,
		o.last_modif_date_time,
		
		o.create_date_time,
		
		o.ext_production,
		
		(e_user.id IS NOT NULL) tm_exists,
		(e_user.tm_id IS NOT NULL) tm_activated,
		e_user.tm_photo,
		--e_user.id AS ,
		o.contact_id AS contact_id,
		
		client_specifications_ref(spec) AS client_specifications_ref,
		
		o.f_val,
		o.w_val,
		
		debts.debt_total AS client_debt
		
	FROM order_garbage o
	LEFT JOIN clients cl ON cl.id = o.client_id
	LEFT JOIN destinations d ON d.id = o.destination_id
	LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
	LEFT JOIN langs l ON l.id = o.lang_id
	LEFT JOIN pump_vehicles pv ON pv.id = o.pump_vehicle_id
	LEFT JOIN users u ON u.id = o.user_id
	LEFT JOIN pump_prices ppr ON ppr.id = pv.pump_price_id
	LEFT JOIN vehicles v ON v.id = pv.vehicle_id
	LEFT JOIN users lm_u ON lm_u.id = o.last_modif_user_id
	
	LEFT JOIN client_tels AS tl ON tl.client_id=o.client_id AND tl.tel=o.phone_cel	
	--LEFT JOIN notifications.ext_users_list AS e_user ON (e_user.ext_obj->'keys'->>'id')::int=tl.id
	
	LEFT JOIN contacts AS ct ON ct.id = o.contact_id
	LEFT JOIN notifications.ext_users_photo_list AS e_user ON e_user.ext_contact_id = o.contact_id
	LEFT JOIN client_specifications AS spec ON spec.id = o.client_specification_id
	LEFT JOIN (
		SELECT
			d.client_id,
			sum(d.debt_total) AS debt_total
		FROM client_debts AS d		
		GROUP BY d.client_id
	) AS debts ON debts.client_id = o.client_id
	
	ORDER BY o.date_time;

	
ALTER TABLE public.order_garbage_dialog OWNER TO beton;


-- ******************* update 05/06/2024 08:20:45 ******************
-- View: public.orders_dialog

-- DROP VIEW public.orders_dialog;

CREATE OR REPLACE VIEW public.orders_dialog AS 
	SELECT
		o.id,
		order_num(o.*) AS number,		
		clients_ref(cl) AS clients_ref,		
		
		destinations_ref(d) AS destinations_ref,
		o.destination_price AS destination_cost,		
		--d.price AS destination_price,		
		CASE
			WHEN coalesce(d.special_price,FALSE) THEN
				--coalesce(d.price,0)
				period_value('destination_price', d.id, o.date_time)::numeric(15,2)
			ELSE
			coalesce(
				(SELECT sh_p.price
				FROM shipment_for_owner_costs sh_p
				WHERE sh_p.date<=o.date_time::date AND sh_p.distance_to>=d.distance
				ORDER BY sh_p.date DESC,sh_p.distance_to ASC
				LIMIT 1
				),			
			coalesce(d.price,0))			
		END  AS destination_price,
		
		d.time_route,
		d.distance,
		
		concrete_types_ref(concr) AS concrete_types_ref,
		o.concrete_price AS concrete_cost,		
		--concr.price AS concrete_price,
		coalesce(
			/*(SELECT
				ct_p.price
			FROM concrete_costs ct_p
			WHERE ct_p.date<=o.date_time::date AND ct_p.concrete_type_id=o.concrete_type_id
			ORDER BY ct_p.date DESC
			LIMIT 1
			),*/
			(SELECT pr.price FROM client_price_list(o.client_id,o.date_time)AS pr WHERE pr.concrete_type_id=o.concrete_type_id),
			coalesce(concr.price,0)
		) AS concrete_price,
		
		o.unload_type,
		o.comment_text,
		
		coalesce(ct.name::text, o.descr::text) AS descr,
		coalesce(ct.tel::text, o.phone_cel::text) AS phone_cel,
		
		o.unload_speed,
		o.date_time,
		o.time_to,		
		o.quant,
		langs_ref(l) AS langs_ref,
		o.total,
		o.total_edit,
		o.pay_cash,
		o.unload_price AS unload_cost,
		o.payed,
		o.under_control,
		
		pv.phone_cel AS pump_vehicle_phone_cel,
		pump_vehicles_ref(pv,v) AS pump_vehicles_ref,
		pump_prices_ref(ppr) AS pump_prices_ref,
		
		users_ref(u) AS users_ref,
		
		d.distance AS destination_distance,
		
		users_ref(lm_u) AS last_modif_users_ref,
		o.last_modif_date_time,
		
		o.create_date_time,
		
		o.ext_production,
		
		(e_user.id IS NOT NULL) tm_exists,
		(e_user.tm_id IS NOT NULL) tm_activated,
		e_user.tm_photo,
		--e_user.id AS ,
		o.contact_id AS contact_id,
		
		client_specifications_ref(spec) AS client_specifications_ref,
		
		o.f_val,
		o.w_val,
		
		--debts.debt_total AS client_debt
		0.0  AS client_debt
		
	FROM orders o
	LEFT JOIN clients cl ON cl.id = o.client_id
	LEFT JOIN destinations d ON d.id = o.destination_id
	LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
	LEFT JOIN langs l ON l.id = o.lang_id
	LEFT JOIN pump_vehicles pv ON pv.id = o.pump_vehicle_id
	LEFT JOIN users u ON u.id = o.user_id
	LEFT JOIN pump_prices ppr ON ppr.id = pv.pump_price_id
	LEFT JOIN vehicles v ON v.id = pv.vehicle_id
	LEFT JOIN users lm_u ON lm_u.id = o.last_modif_user_id
	
	LEFT JOIN client_tels AS tl ON tl.client_id=o.client_id AND tl.tel=o.phone_cel	
	--LEFT JOIN notifications.ext_users_list AS e_user ON (e_user.ext_obj->'keys'->>'id')::int=tl.id
	
	LEFT JOIN contacts AS ct ON ct.id = o.contact_id
	LEFT JOIN notifications.ext_users_photo_list AS e_user ON e_user.ext_contact_id = o.contact_id
	LEFT JOIN client_specifications AS spec ON spec.id = o.client_specification_id
	/*LEFT JOIN (
		SELECT
			d.client_id,
			sum(d.debt_total) AS debt_total
		FROM client_debts AS d		
		GROUP BY d.client_id
	) AS debts ON debts.client_id = o.client_id*/
	
	ORDER BY o.date_time;

ALTER TABLE public.orders_dialog OWNER TO beton;



-- ******************* update 05/06/2024 08:24:05 ******************
-- View: public.orders_dialog

-- DROP VIEW public.orders_dialog;

CREATE OR REPLACE VIEW public.orders_dialog AS 
	SELECT
		o.id,
		order_num(o.*) AS number,		
		clients_ref(cl) AS clients_ref,		
		
		destinations_ref(d) AS destinations_ref,
		o.destination_price AS destination_cost,		
		--d.price AS destination_price,		
		CASE
			WHEN coalesce(d.special_price,FALSE) THEN
				--coalesce(d.price,0)
				period_value('destination_price', d.id, o.date_time)::numeric(15,2)
			ELSE
			coalesce(
				(SELECT sh_p.price
				FROM shipment_for_owner_costs sh_p
				WHERE sh_p.date<=o.date_time::date AND sh_p.distance_to>=d.distance
				ORDER BY sh_p.date DESC,sh_p.distance_to ASC
				LIMIT 1
				),			
			coalesce(d.price,0))			
		END  AS destination_price,
		
		d.time_route,
		d.distance,
		
		concrete_types_ref(concr) AS concrete_types_ref,
		o.concrete_price AS concrete_cost,		
		--concr.price AS concrete_price,
		coalesce(
			/*(SELECT
				ct_p.price
			FROM concrete_costs ct_p
			WHERE ct_p.date<=o.date_time::date AND ct_p.concrete_type_id=o.concrete_type_id
			ORDER BY ct_p.date DESC
			LIMIT 1
			),*/
			(SELECT pr.price FROM client_price_list(o.client_id,o.date_time)AS pr WHERE pr.concrete_type_id=o.concrete_type_id),
			coalesce(concr.price,0)
		) AS concrete_price,
		
		o.unload_type,
		o.comment_text,
		
		coalesce(ct.name::text, o.descr::text) AS descr,
		coalesce(ct.tel::text, o.phone_cel::text) AS phone_cel,
		
		o.unload_speed,
		o.date_time,
		o.time_to,		
		o.quant,
		langs_ref(l) AS langs_ref,
		o.total,
		o.total_edit,
		o.pay_cash,
		o.unload_price AS unload_cost,
		o.payed,
		o.under_control,
		
		pv.phone_cel AS pump_vehicle_phone_cel,
		pump_vehicles_ref(pv,v) AS pump_vehicles_ref,
		pump_prices_ref(ppr) AS pump_prices_ref,
		
		users_ref(u) AS users_ref,
		
		d.distance AS destination_distance,
		
		users_ref(lm_u) AS last_modif_users_ref,
		o.last_modif_date_time,
		
		o.create_date_time,
		
		o.ext_production,
		
		/*(e_user.id IS NOT NULL) tm_exists,
		(e_user.tm_id IS NOT NULL) tm_activated,
		e_user.tm_photo,*/
		false AS tm_exists,
		false AS  tm_activated,
		NULL AS tm_photo,
		
		o.contact_id AS contact_id,
		
		client_specifications_ref(spec) AS client_specifications_ref,
		
		o.f_val,
		o.w_val,
		
		debts.debt_total AS client_debt
		
	FROM orders o
	LEFT JOIN clients cl ON cl.id = o.client_id
	LEFT JOIN destinations d ON d.id = o.destination_id
	LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
	LEFT JOIN langs l ON l.id = o.lang_id
	LEFT JOIN pump_vehicles pv ON pv.id = o.pump_vehicle_id
	LEFT JOIN users u ON u.id = o.user_id
	LEFT JOIN pump_prices ppr ON ppr.id = pv.pump_price_id
	LEFT JOIN vehicles v ON v.id = pv.vehicle_id
	LEFT JOIN users lm_u ON lm_u.id = o.last_modif_user_id
	
	LEFT JOIN client_tels AS tl ON tl.client_id=o.client_id AND tl.tel=o.phone_cel	
	
	LEFT JOIN contacts AS ct ON ct.id = o.contact_id
	--LEFT JOIN notifications.ext_users_photo_list AS e_user ON e_user.ext_contact_id = o.contact_id
	LEFT JOIN client_specifications AS spec ON spec.id = o.client_specification_id
	LEFT JOIN (
		SELECT
			d.client_id,
			sum(d.debt_total) AS debt_total
		FROM client_debts AS d		
		GROUP BY d.client_id
	) AS debts ON debts.client_id = o.client_id
	
	ORDER BY o.date_time;

ALTER TABLE public.orders_dialog OWNER TO beton;



-- ******************* update 05/06/2024 08:24:22 ******************
-- View: public.orders_dialog

-- DROP VIEW public.orders_dialog;

CREATE OR REPLACE VIEW public.orders_dialog AS 
	SELECT
		o.id,
		order_num(o.*) AS number,		
		clients_ref(cl) AS clients_ref,		
		
		destinations_ref(d) AS destinations_ref,
		o.destination_price AS destination_cost,		
		--d.price AS destination_price,		
		CASE
			WHEN coalesce(d.special_price,FALSE) THEN
				--coalesce(d.price,0)
				period_value('destination_price', d.id, o.date_time)::numeric(15,2)
			ELSE
			coalesce(
				(SELECT sh_p.price
				FROM shipment_for_owner_costs sh_p
				WHERE sh_p.date<=o.date_time::date AND sh_p.distance_to>=d.distance
				ORDER BY sh_p.date DESC,sh_p.distance_to ASC
				LIMIT 1
				),			
			coalesce(d.price,0))			
		END  AS destination_price,
		
		d.time_route,
		d.distance,
		
		concrete_types_ref(concr) AS concrete_types_ref,
		o.concrete_price AS concrete_cost,		
		--concr.price AS concrete_price,
		coalesce(
			/*(SELECT
				ct_p.price
			FROM concrete_costs ct_p
			WHERE ct_p.date<=o.date_time::date AND ct_p.concrete_type_id=o.concrete_type_id
			ORDER BY ct_p.date DESC
			LIMIT 1
			),*/
			(SELECT pr.price FROM client_price_list(o.client_id,o.date_time)AS pr WHERE pr.concrete_type_id=o.concrete_type_id),
			coalesce(concr.price,0)
		) AS concrete_price,
		
		o.unload_type,
		o.comment_text,
		
		coalesce(ct.name::text, o.descr::text) AS descr,
		coalesce(ct.tel::text, o.phone_cel::text) AS phone_cel,
		
		o.unload_speed,
		o.date_time,
		o.time_to,		
		o.quant,
		langs_ref(l) AS langs_ref,
		o.total,
		o.total_edit,
		o.pay_cash,
		o.unload_price AS unload_cost,
		o.payed,
		o.under_control,
		
		pv.phone_cel AS pump_vehicle_phone_cel,
		pump_vehicles_ref(pv,v) AS pump_vehicles_ref,
		pump_prices_ref(ppr) AS pump_prices_ref,
		
		users_ref(u) AS users_ref,
		
		d.distance AS destination_distance,
		
		users_ref(lm_u) AS last_modif_users_ref,
		o.last_modif_date_time,
		
		o.create_date_time,
		
		o.ext_production,
		
		(e_user.id IS NOT NULL) tm_exists,
		(e_user.tm_id IS NOT NULL) tm_activated,
		e_user.tm_photo,
		
		o.contact_id AS contact_id,
		
		client_specifications_ref(spec) AS client_specifications_ref,
		
		o.f_val,
		o.w_val,
		
		debts.debt_total AS client_debt
		
	FROM orders o
	LEFT JOIN clients cl ON cl.id = o.client_id
	LEFT JOIN destinations d ON d.id = o.destination_id
	LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
	LEFT JOIN langs l ON l.id = o.lang_id
	LEFT JOIN pump_vehicles pv ON pv.id = o.pump_vehicle_id
	LEFT JOIN users u ON u.id = o.user_id
	LEFT JOIN pump_prices ppr ON ppr.id = pv.pump_price_id
	LEFT JOIN vehicles v ON v.id = pv.vehicle_id
	LEFT JOIN users lm_u ON lm_u.id = o.last_modif_user_id
	
	LEFT JOIN client_tels AS tl ON tl.client_id=o.client_id AND tl.tel=o.phone_cel	
	
	LEFT JOIN contacts AS ct ON ct.id = o.contact_id
	LEFT JOIN notifications.ext_users_photo_list AS e_user ON e_user.ext_contact_id = o.contact_id
	LEFT JOIN client_specifications AS spec ON spec.id = o.client_specification_id
	LEFT JOIN (
		SELECT
			d.client_id,
			sum(d.debt_total) AS debt_total
		FROM client_debts AS d		
		GROUP BY d.client_id
	) AS debts ON debts.client_id = o.client_id
	
	ORDER BY o.date_time;

ALTER TABLE public.orders_dialog OWNER TO beton;



-- ******************* update 05/06/2024 08:25:17 ******************
-- View: public.orders_dialog

-- DROP VIEW public.orders_dialog;

CREATE OR REPLACE VIEW public.orders_dialog AS 
	SELECT
		o.id,
		order_num(o.*) AS number,		
		clients_ref(cl) AS clients_ref,		
		
		destinations_ref(d) AS destinations_ref,
		o.destination_price AS destination_cost,		
		--d.price AS destination_price,		
		CASE
			WHEN coalesce(d.special_price,FALSE) THEN
				--coalesce(d.price,0)
				period_value('destination_price', d.id, o.date_time)::numeric(15,2)
			ELSE
			coalesce(
				(SELECT sh_p.price
				FROM shipment_for_owner_costs sh_p
				WHERE sh_p.date<=o.date_time::date AND sh_p.distance_to>=d.distance
				ORDER BY sh_p.date DESC,sh_p.distance_to ASC
				LIMIT 1
				),			
			coalesce(d.price,0))			
		END  AS destination_price,
		
		d.time_route,
		d.distance,
		
		concrete_types_ref(concr) AS concrete_types_ref,
		o.concrete_price AS concrete_cost,		
		--concr.price AS concrete_price,
		coalesce(
			/*(SELECT
				ct_p.price
			FROM concrete_costs ct_p
			WHERE ct_p.date<=o.date_time::date AND ct_p.concrete_type_id=o.concrete_type_id
			ORDER BY ct_p.date DESC
			LIMIT 1
			),*/
			(SELECT pr.price FROM client_price_list(o.client_id,o.date_time)AS pr WHERE pr.concrete_type_id=o.concrete_type_id),
			coalesce(concr.price,0)
		) AS concrete_price,
		
		o.unload_type,
		o.comment_text,
		
		coalesce(ct.name::text, o.descr::text) AS descr,
		coalesce(ct.tel::text, o.phone_cel::text) AS phone_cel,
		
		o.unload_speed,
		o.date_time,
		o.time_to,		
		o.quant,
		langs_ref(l) AS langs_ref,
		o.total,
		o.total_edit,
		o.pay_cash,
		o.unload_price AS unload_cost,
		o.payed,
		o.under_control,
		
		pv.phone_cel AS pump_vehicle_phone_cel,
		pump_vehicles_ref(pv,v) AS pump_vehicles_ref,
		pump_prices_ref(ppr) AS pump_prices_ref,
		
		users_ref(u) AS users_ref,
		
		d.distance AS destination_distance,
		
		users_ref(lm_u) AS last_modif_users_ref,
		o.last_modif_date_time,
		
		o.create_date_time,
		
		o.ext_production,
		
		(e_user.id IS NOT NULL) tm_exists,
		(e_user.tm_id IS NOT NULL) tm_activated,
		e_user.tm_photo,
		
		o.contact_id AS contact_id,
		
		client_specifications_ref(spec) AS client_specifications_ref,
		
		o.f_val,
		o.w_val,
		
		debts.debt_total AS client_debt
		
	FROM orders o
	LEFT JOIN clients cl ON cl.id = o.client_id
	LEFT JOIN destinations d ON d.id = o.destination_id
	LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
	LEFT JOIN langs l ON l.id = o.lang_id
	LEFT JOIN pump_vehicles pv ON pv.id = o.pump_vehicle_id
	LEFT JOIN users u ON u.id = o.user_id
	LEFT JOIN pump_prices ppr ON ppr.id = pv.pump_price_id
	LEFT JOIN vehicles v ON v.id = pv.vehicle_id
	LEFT JOIN users lm_u ON lm_u.id = o.last_modif_user_id
	
	--LEFT JOIN client_tels AS tl ON tl.client_id=o.client_id AND tl.tel=o.phone_cel	
	
	LEFT JOIN contacts AS ct ON ct.id = o.contact_id
	LEFT JOIN notifications.ext_users_photo_list AS e_user ON e_user.ext_contact_id = o.contact_id
	LEFT JOIN client_specifications AS spec ON spec.id = o.client_specification_id
	LEFT JOIN (
		SELECT
			d.client_id,
			sum(d.debt_total) AS debt_total
		FROM client_debts AS d		
		GROUP BY d.client_id
	) AS debts ON debts.client_id = o.client_id
	
	ORDER BY o.date_time;

ALTER TABLE public.orders_dialog OWNER TO beton;



-- ******************* update 05/06/2024 08:49:54 ******************

	-- ********** Adding new table from model **********
	CREATE TABLE public.order_garbage
	(id serial NOT NULL,client_id int NOT NULL REFERENCES clients(id),destination_id int NOT NULL REFERENCES destinations(id),concrete_type_id int NOT NULL REFERENCES concrete_types(id),unload_type unload_types,comment_text text,descr text,date_time timestamp NOT NULL,date_time_to timestamp,quant  numeric(19,4),phone_cel  varchar(15),unload_speed  numeric(19,4),user_id int REFERENCES users(id),lang_id int REFERENCES langs(id),total  numeric(15,2),concrete_price  numeric(15,2),destination_price  numeric(15,2),unload_price  numeric(15,2),pump_vehicle_id int REFERENCES pump_vehicles(id),pay_cash bool
			DEFAULT FALSE,total_edit bool
			DEFAULT FALSE,payed bool
			DEFAULT FALSE,under_control bool
			DEFAULT FALSE,last_modif_user_id int REFERENCES users(id),last_modif_date_time timestampTZ,create_date_time timestampTZ
			DEFAULT CURRENT_TIMESTAMP,ext_production bool
			DEFAULT FALSE,contact_id int REFERENCES contacts(id),client_specification_id int REFERENCES client_specifications(id),f_val int,w_val int,CONSTRAINT order_garbage_pkey PRIMARY KEY (id)
	);
	DROP INDEX IF EXISTS date_time_index;
	CREATE INDEX date_time_index
	ON order_garbage(date_time);
	DROP INDEX IF EXISTS client_id_index;
	CREATE INDEX client_id_index
	ON order_garbage(client_id);
	DROP INDEX IF EXISTS concrete_type_id_index;
	CREATE INDEX concrete_type_id_index
	ON order_garbage(concrete_type_id);
	DROP INDEX IF EXISTS destination_id_index;
	CREATE INDEX destination_id_index
	ON order_garbage(destination_id);
	ALTER TABLE public.order_garbage OWNER TO beton;



-- ******************* update 05/06/2024 08:58:30 ******************
alter table order_garbage add column "number" int;



-- ******************* update 05/06/2024 08:58:39 ******************
-- FUNCTION: public.order_garbage_num(order_garbage)

-- DROP FUNCTION IF EXISTS public.order_garbage_num(order_garbage);

CREATE OR REPLACE FUNCTION public.order_garbage_num(
	order_garbage)
    RETURNS character varying
    LANGUAGE 'sql'
    COST 100
    IMMUTABLE
AS $BODY$
	SELECT 
	CASE WHEN EXTRACT(DAY FROM $1.date_time)<10 THEN
		'0' || EXTRACT(DAY FROM $1.date_time)::varchar || '-' || trim(to_char($1.number,'000'))
	ELSE
		EXTRACT(DAY FROM $1.date_time)::varchar || '-' || trim(to_char($1.number,'000'))
	END;
$BODY$;

ALTER FUNCTION public.order_garbage_num(order_garbage)
    OWNER TO beton;



-- ******************* update 05/06/2024 08:59:39 ******************
alter table order_garbage add column time_to time without time zone;



-- ******************* update 05/06/2024 09:02:14 ******************
-- Function: public.order_garbage_ref(order_garbage)

-- DROP FUNCTION public.order_garbage_ref(order_garbage);

CREATE OR REPLACE FUNCTION public.order_garbage_ref(order_garbage)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr','Удаленная заявка №'||order_garbage_num($1)::text||' от '||to_char($1.date_time,'DD/MM/YY HH24:MI'),
		'dataType','order_garbage'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.order_garbage_ref(order_garbage) OWNER TO beton;



-- ******************* update 05/06/2024 09:02:18 ******************
-- View: public.orders_dialog

-- DROP VIEW public.orders_dialog;

CREATE OR REPLACE VIEW public.orders_dialog AS 
	SELECT
		o.id,
		order_num(o.*) AS number,		
		clients_ref(cl) AS clients_ref,		
		
		destinations_ref(d) AS destinations_ref,
		o.destination_price AS destination_cost,		
		--d.price AS destination_price,		
		CASE
			WHEN coalesce(d.special_price,FALSE) THEN
				--coalesce(d.price,0)
				period_value('destination_price', d.id, o.date_time)::numeric(15,2)
			ELSE
			coalesce(
				(SELECT sh_p.price
				FROM shipment_for_owner_costs sh_p
				WHERE sh_p.date<=o.date_time::date AND sh_p.distance_to>=d.distance
				ORDER BY sh_p.date DESC,sh_p.distance_to ASC
				LIMIT 1
				),			
			coalesce(d.price,0))			
		END  AS destination_price,
		
		d.time_route,
		d.distance,
		
		concrete_types_ref(concr) AS concrete_types_ref,
		o.concrete_price AS concrete_cost,		
		--concr.price AS concrete_price,
		coalesce(
			/*(SELECT
				ct_p.price
			FROM concrete_costs ct_p
			WHERE ct_p.date<=o.date_time::date AND ct_p.concrete_type_id=o.concrete_type_id
			ORDER BY ct_p.date DESC
			LIMIT 1
			),*/
			(SELECT pr.price FROM client_price_list(o.client_id,o.date_time)AS pr WHERE pr.concrete_type_id=o.concrete_type_id),
			coalesce(concr.price,0)
		) AS concrete_price,
		
		o.unload_type,
		o.comment_text,
		
		coalesce(ct.name::text, o.descr::text) AS descr,
		coalesce(ct.tel::text, o.phone_cel::text) AS phone_cel,
		
		o.unload_speed,
		o.date_time,
		o.time_to,		
		o.quant,
		langs_ref(l) AS langs_ref,
		o.total,
		o.total_edit,
		o.pay_cash,
		o.unload_price AS unload_cost,
		o.payed,
		o.under_control,
		
		pv.phone_cel AS pump_vehicle_phone_cel,
		pump_vehicles_ref(pv,v) AS pump_vehicles_ref,
		pump_prices_ref(ppr) AS pump_prices_ref,
		
		users_ref(u) AS users_ref,
		
		d.distance AS destination_distance,
		
		users_ref(lm_u) AS last_modif_users_ref,
		o.last_modif_date_time,
		
		o.create_date_time,
		
		o.ext_production,
		
		(e_user.id IS NOT NULL) tm_exists,
		(e_user.tm_id IS NOT NULL) tm_activated,
		e_user.tm_photo,
		
		o.contact_id AS contact_id,
		
		client_specifications_ref(spec) AS client_specifications_ref,
		
		o.f_val,
		o.w_val,
		
		debts.debt_total AS client_debt
		
	FROM orders o
	LEFT JOIN clients cl ON cl.id = o.client_id
	LEFT JOIN destinations d ON d.id = o.destination_id
	LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
	LEFT JOIN langs l ON l.id = o.lang_id
	LEFT JOIN pump_vehicles pv ON pv.id = o.pump_vehicle_id
	LEFT JOIN users u ON u.id = o.user_id
	LEFT JOIN pump_prices ppr ON ppr.id = pv.pump_price_id
	LEFT JOIN vehicles v ON v.id = pv.vehicle_id
	LEFT JOIN users lm_u ON lm_u.id = o.last_modif_user_id
	
	--LEFT JOIN client_tels AS tl ON tl.client_id=o.client_id AND tl.tel=o.phone_cel	
	
	LEFT JOIN contacts AS ct ON ct.id = o.contact_id
	LEFT JOIN notifications.ext_users_photo_list AS e_user ON e_user.ext_contact_id = o.contact_id
	LEFT JOIN client_specifications AS spec ON spec.id = o.client_specification_id
	LEFT JOIN (
		SELECT
			d.client_id,
			sum(d.debt_total) AS debt_total
		FROM client_debts AS d		
		GROUP BY d.client_id
	) AS debts ON debts.client_id = o.client_id
	
	ORDER BY o.date_time;

ALTER TABLE public.orders_dialog OWNER TO beton;



-- ******************* update 05/06/2024 09:02:22 ******************
-- View: order_garbage_list

-- DROP VIEW order_garbage_list;

CREATE OR REPLACE VIEW order_garbage_list AS 
	SELECT
		o.id,
		order_garbage_num(o.*) AS number,
		clients_ref(cl) AS clients_ref,
		o.client_id,
		destinations_ref(d) AS destinations_ref,
		o.destination_id,
		concrete_types_ref(concr) AS concrete_types_ref,
		o.concrete_type_id,
		o.unload_type AS unload_type,
		o.comment_text AS comment_text,
		
		coalesce(ct.name::text, o.descr::text) AS descr,
		coalesce(ct.tel::text, o.phone_cel::text) AS phone_cel,
		
		o.date_time,
		o.quant,
		users_ref(u) AS users_ref,
		o.user_id,
		order_garbage_ref(o) AS orders_ref,
		contacts_ref(ct) AS contacts_ref		
		
   FROM order_garbage o
   LEFT JOIN clients cl ON cl.id = o.client_id
   LEFT JOIN destinations d ON d.id = o.destination_id
   LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
   LEFT JOIN contacts ct ON ct.id = o.contact_id
   LEFT JOIN users u ON u.id = o.user_id
  ORDER BY o.date_time DESC;

ALTER TABLE order_garbage_list OWNER TO beton;


-- ******************* update 05/06/2024 09:35:20 ******************
alter table order_garbage add column client_mark integer;



-- ******************* update 06/06/2024 09:24:12 ******************

	DROP INDEX IF EXISTS vehicle_tot_rep_item_vals_drv_per;
	CREATE UNIQUE INDEX vehicle_tot_rep_item_vals_drv_per
	ON vehicle_tot_rep_item_vals(vehicle_id,period,vehicle_tot_rep_item_id);
	
	DROP INDEX IF EXISTS vehicle_tot_rep_common_item_vals_owner_per;
	CREATE UNIQUE INDEX vehicle_tot_rep_common_item_vals_owner_per
	ON vehicle_tot_rep_common_item_vals(vehicle_owner_id,period,vehicle_tot_rep_common_item_id);



-- ******************* update 06/06/2024 12:03:58 ******************

	-- Adding menu item
	INSERT INTO views
	(id,c,f,t,section,descr,limited)
	VALUES (
	'50022',
	NULL,
	NULL,
	'VehicleOwnerTotIncomeAllRep',
	'Отчеты',
	'Итоговый отчет для владельцев (все)',
	FALSE
	);
	

-- ******************* update 06/06/2024 17:11:54 ******************

	-- Adding menu item
	INSERT INTO views
	(id,c,f,t,section,descr,limited)
	VALUES (
	'30026',
	'PeriodValue_Controller',
	'get_water_ship_cost_list',
	'WaterShipCostPeriodValueList',
	'Формы',
	'Периодические значения стоимости доставки воды',
	FALSE
	);
	

-- ******************* update 06/06/2024 17:14:41 ******************
delete from views where id='30026'



-- ******************* update 07/06/2024 16:50:26 ******************
--DROP VIEW public.vehicle_states_all;
CREATE OR REPLACE VIEW public.vehicle_states_all AS 
	SELECT 
		st.date_time,
		vs.id,
		CASE
		    WHEN st.state <> 'out'::vehicle_states AND st.state <> 'out_from_shift'::vehicle_states AND st.state <> 'shift'::vehicle_states AND st.state <> 'shift_added'::vehicle_states 

			THEN 1
			ELSE 0
		END AS vehicles_count,
		
		vehicles_ref(v) AS vehicles_ref,
		
		/*
		CASE
			WHEN v.vehicle_owner_id IS NULL THEN v.owner
			ELSE v_own.name
		END
		*/
		v_own.name::text AS owner,
		
		drivers_ref(d) AS drivers_ref,
		--d.phone_cel::text AS driver_phone_cel,
		ct.tel::text AS driver_phone_cel,
		
		st.state, 

		CASE 
			--WHEN st.state = 'busy'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+const_vehicle_unload_time_val())::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				--THEN true
			WHEN st.state = 'busy'::vehicle_states AND (st.date_time + coalesce(dest.time_route::interval,'00:00'::interval))::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			
			WHEN st.state = 'left_for_base'::vehicle_states AND (st.date_time +  coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			ELSE false
		END AS is_late,

		CASE
			WHEN st.state = 'at_dest'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*1 + const_vehicle_unload_time_val())::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			ELSE false
		END AS is_late_at_dest,
		
		CASE
			--shift - no inf
			WHEN st.state = 'shift'::vehicle_states OR st.state = 'shift_added'::vehicle_states
				THEN ''

			-- out_from_shift && out inf=out time
			WHEN st.state = 'out_from_shift'::vehicle_states OR st.state = 'out'::vehicle_states
				THEN time5_descr(st.date_time::time)::text

			--free && assigned inf= time elapsed
			WHEN st.state = 'free'::vehicle_states OR st.state = 'assigned'::vehicle_states
				THEN to_char(CURRENT_TIMESTAMP-st.date_time,'HH24:MI')

			--busy && late inf = -
			--WHEN st.state = 'busy'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+const_vehicle_unload_time_val())::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				--THEN '-'::text || time5_descr((CURRENT_TIMESTAMP - (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+const_vehicle_unload_time_val())::interval)::timestamp with time zone)::time without time zone)::text
			WHEN st.state = 'busy'::vehicle_states AND (st.date_time + coalesce(dest.time_route,'00:00'::time)+const_vehicle_unload_time_val()::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN time5_descr((coalesce(dest.time_route,'00:00'::time)+const_vehicle_unload_time_val()::interval )::time without time zone)::text
				
			-- busy not late
			WHEN st.state = 'busy'::vehicle_states
				--THEN time5_descr(((st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+const_vehicle_unload_time_val())::interval)::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text
				THEN time5_descr((coalesce(dest.time_route,'00:00'::time)+const_vehicle_unload_time_val()::interval )::time without time zone)::text

			--at dest && late inf=route_time
			WHEN st.state = 'at_dest'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*1+const_vehicle_unload_time_val())::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN time5_descr(coalesce(dest.time_route,'00:00'::time))::text

			--at dest NOT late
			WHEN st.state = 'at_dest'::vehicle_states
				THEN time5_descr( ((st.date_time + (coalesce(dest.time_route::interval,'00:00'::interval)+const_vehicle_unload_time_val()::interval))::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text

			--left_for_base && LATE
			WHEN st.state = 'left_for_base'::vehicle_states AND (st.date_time + coalesce(dest.time_route,'00:00'::time)::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN '-'::text || time5_descr((CURRENT_TIMESTAMP - (st.date_time + coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone)::time without time zone)::text

			--left_for_base NOT late
			WHEN st.state = 'left_for_base'::vehicle_states
				THEN time5_descr( ((st.date_time + coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text
		    
			ELSE ''
		    
		END AS inf_on_return, 
		
		v.load_capacity,
		(SELECT COUNT(*)
		FROM shipments
		WHERE (shipments.vehicle_schedule_id = vs.id AND shipments.shipped)
		) AS runs,

		coalesce(
			(SELECT 
				(now()-(tr.period+AGE(now(),now() AT TIME ZONE 'UTC')) ) > (const_no_tracker_signal_warn_interval_val())::interval
				FROM car_tracking AS tr
				WHERE tr.car_id=v.tracker_id
				ORDER BY tr.period DESC LIMIT 1
			)
		,TRUE) AS tracker_no_data,
		
		(v.tracker_id IS NULL OR v.tracker_id='') AS no_tracker,
		
		vs.schedule_date,
		
		vehicle_schedules_ref(vs,v,d) AS vehicle_schedules_ref,
		
		--d.phone_cel AS driver_tel
		ct.tel::varchar(15) AS driver_tel
		,v.tracker_id
		
		,case
			when st.state <>'shift' then production_bases_ref(production_bases_ref_t)
			else production_bases_ref(vs_pb)
		end AS production_bases_ref,
		
		case
			when st.state <>'shift' then production_bases_ref_t.name
			else vs_pb.name
		end AS production_base_name, -- for sorting
		
		dest.name AS destination_name
		
	FROM vehicle_schedules vs
	
	LEFT JOIN drivers d ON d.id = vs.driver_id
	LEFT JOIN vehicles v ON v.id = vs.vehicle_id
	LEFT JOIN vehicle_schedule_states st ON
		st.id = (SELECT
				vehicle_schedule_states.id 
			FROM vehicle_schedule_states
			WHERE vehicle_schedule_states.schedule_id = vs.id
			ORDER BY vehicle_schedule_states.date_time DESC NULLS LAST
			LIMIT 1
		)
	LEFT JOIN production_bases AS vs_pb ON vs_pb.id = vs.production_base_id
	LEFT JOIN production_bases AS production_bases_ref_t ON production_bases_ref_t.id = st.production_base_id
	
	LEFT JOIN shipments AS sh ON sh.id=st.shipment_id
	LEFT JOIN orders AS o ON o.id=sh.order_id		
	LEFT JOIN destinations AS dest ON dest.id=o.destination_id
	LEFT JOIN vehicle_owners AS v_own ON v_own.id=v.vehicle_owner_id
	LEFT JOIN entity_contacts AS e_ct ON e_ct.entity_type = 'drivers' AND e_ct.entity_id = d.id
	LEFT JOIN contacts AS ct ON ct.id = e_ct.contact_id
	;		
	--WHERE vs.schedule_date=in_date


ALTER TABLE public.vehicle_states_all OWNER TO beton;



-- ******************* update 12/06/2024 10:28:05 ******************
﻿-- Function: vehicle_tot_rep_common_item_exec_query(in_query text, in_vehicle_owner_id int, in_date_time_from timestampTZ, in_date_time_to timestampTZ)

--DROP FUNCTION vehicle_tot_rep_common_item_exec_query(in_query text, in_vehicle_owner_id int, in_date_time_from timestampTZ, in_date_time_to timestampTZ);

CREATE OR REPLACE FUNCTION vehicle_tot_rep_common_item_exec_query(in_query text, in_vehicle_owner_id int, in_date_time_from timestampTZ, in_date_time_to timestampTZ)
  RETURNS numeric(15,2) AS
$$
DECLARE
	v_query text;
	v_val numeric(15, 2);
BEGIN
	IF coalesce(in_query, '') = '' THEN
		RETURN 0.00;
	END IF;
	
	v_query = REPLACE(in_query, '{{VEHICLE_OWNER_ID}}', in_vehicle_owner_id::text );
	v_query = REPLACE(v_query, '{{DATE_FROM}}', in_date_time_from::text);
	v_query = REPLACE(v_query, '{{DATE_TO}}', in_date_time_to::text);
	EXECUTE v_query INTO v_val;
	RETURN coalesce(v_val, 0.00);
END;
$$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION vehicle_tot_rep_common_item_exec_query(in_query text, in_vehicle_owner_id int, in_date_time_from timestampTZ, in_date_time_to timestampTZ) OWNER TO beton;



-- ******************* update 13/06/2024 07:25:26 ******************
﻿-- Function: vehicle_tot_rep_common_item_exec_query(in_query text, in_vehicle_owner_id int, in_date_time_from timestampTZ, in_date_time_to timestampTZ)

--DROP FUNCTION vehicle_tot_rep_common_item_exec_query(in_query text, in_vehicle_owner_id int, in_date_time_from timestampTZ, in_date_time_to timestampTZ);

CREATE OR REPLACE FUNCTION vehicle_tot_rep_common_item_exec_query(in_query text, in_vehicle_owner_id int, in_date_time_from timestampTZ, in_date_time_to timestampTZ)
  RETURNS numeric(15,2) AS
$$
DECLARE
	v_query text;
	v_val numeric(15, 2);
BEGIN
	IF coalesce(in_query, '') = '' THEN
		RETURN 0.00;
	END IF;
	
	v_query = REPLACE(in_query, '{{VEHICLE_OWNER_ID}}', in_vehicle_owner_id::text );
	v_query = REPLACE(v_query, '{{DATE_FROM}}', in_date_time_from::text);
	v_query = REPLACE(v_query, '{{DATE_TO}}', in_date_time_to::text);
	
	EXECUTE v_query INTO v_val;
	
	RETURN coalesce(v_val, 0.00);
END;
$$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION vehicle_tot_rep_common_item_exec_query(in_query text, in_vehicle_owner_id int, in_date_time_from timestampTZ, in_date_time_to timestampTZ) OWNER TO concrete1;



-- ******************* update 13/06/2024 07:25:34 ******************
--DROP VIEW public.vehicle_states_all;
CREATE OR REPLACE VIEW public.vehicle_states_all AS 
	SELECT 
		st.date_time,
		vs.id,
		CASE
		    WHEN st.state <> 'out'::vehicle_states AND st.state <> 'out_from_shift'::vehicle_states AND st.state <> 'shift'::vehicle_states AND st.state <> 'shift_added'::vehicle_states 

			THEN 1
			ELSE 0
		END AS vehicles_count,
		
		vehicles_ref(v) AS vehicles_ref,
		
		/*
		CASE
			WHEN v.vehicle_owner_id IS NULL THEN v.owner
			ELSE v_own.name
		END
		*/
		v_own.name::text AS owner,
		
		drivers_ref(d) AS drivers_ref,
		--d.phone_cel::text AS driver_phone_cel,
		ct.tel::text AS driver_phone_cel,
		
		st.state, 

		CASE 
			--WHEN st.state = 'busy'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+const_vehicle_unload_time_val())::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				--THEN true
			WHEN st.state = 'busy'::vehicle_states AND (st.date_time + coalesce(dest.time_route::interval,'00:00'::interval))::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			
			WHEN st.state = 'left_for_base'::vehicle_states AND (st.date_time +  coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			ELSE false
		END AS is_late,

		CASE
			WHEN st.state = 'at_dest'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*1 + const_vehicle_unload_time_val())::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			ELSE false
		END AS is_late_at_dest,
		
		CASE
			--shift - no inf
			WHEN st.state = 'shift'::vehicle_states OR st.state = 'shift_added'::vehicle_states
				THEN ''

			-- out_from_shift && out inf=out time
			WHEN st.state = 'out_from_shift'::vehicle_states OR st.state = 'out'::vehicle_states
				THEN time5_descr(st.date_time::time)::text

			--free && assigned inf= time elapsed
			WHEN st.state = 'free'::vehicle_states OR st.state = 'assigned'::vehicle_states
				THEN to_char(CURRENT_TIMESTAMP-st.date_time,'HH24:MI')

			--busy && late inf = -
			--WHEN st.state = 'busy'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+const_vehicle_unload_time_val())::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				--THEN '-'::text || time5_descr((CURRENT_TIMESTAMP - (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+const_vehicle_unload_time_val())::interval)::timestamp with time zone)::time without time zone)::text
			WHEN st.state = 'busy'::vehicle_states AND (st.date_time + coalesce(dest.time_route,'00:00'::time)+const_vehicle_unload_time_val()::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN time5_descr((coalesce(dest.time_route,'00:00'::time)+const_vehicle_unload_time_val()::interval )::time without time zone)::text
				
			-- busy not late
			WHEN st.state = 'busy'::vehicle_states
				--THEN time5_descr(((st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+const_vehicle_unload_time_val())::interval)::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text
				THEN time5_descr((coalesce(dest.time_route,'00:00'::time)+const_vehicle_unload_time_val()::interval )::time without time zone)::text

			--at dest && late inf=route_time
			WHEN st.state = 'at_dest'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*1+const_vehicle_unload_time_val())::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN time5_descr(coalesce(dest.time_route,'00:00'::time))::text

			--at dest NOT late
			WHEN st.state = 'at_dest'::vehicle_states
				THEN time5_descr( ((st.date_time + (coalesce(dest.time_route::interval,'00:00'::interval)+const_vehicle_unload_time_val()::interval))::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text

			--left_for_base && LATE
			WHEN st.state = 'left_for_base'::vehicle_states AND (st.date_time + coalesce(dest.time_route,'00:00'::time)::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN '-'::text || time5_descr((CURRENT_TIMESTAMP - (st.date_time + coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone)::time without time zone)::text

			--left_for_base NOT late
			WHEN st.state = 'left_for_base'::vehicle_states
				THEN time5_descr( ((st.date_time + coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text
		    
			ELSE ''
		    
		END AS inf_on_return, 
		
		v.load_capacity,
		(SELECT COUNT(*)
		FROM shipments
		WHERE (shipments.vehicle_schedule_id = vs.id AND shipments.shipped)
		) AS runs,

		coalesce(
			(SELECT 
				(now()-(tr.period+AGE(now(),now() AT TIME ZONE 'UTC')) ) > (const_no_tracker_signal_warn_interval_val())::interval
				FROM car_tracking AS tr
				WHERE tr.car_id=v.tracker_id
				ORDER BY tr.period DESC LIMIT 1
			)
		,TRUE) AS tracker_no_data,
		
		(v.tracker_id IS NULL OR v.tracker_id='') AS no_tracker,
		
		vs.schedule_date,
		
		vehicle_schedules_ref(vs,v,d) AS vehicle_schedules_ref,
		
		--d.phone_cel AS driver_tel
		ct.tel::varchar(15) AS driver_tel
		,v.tracker_id
		
		,case
			when st.state <>'shift' then production_bases_ref(production_bases_ref_t)
			else production_bases_ref(vs_pb)
		end AS production_bases_ref,
		
		case
			when st.state <>'shift' then production_bases_ref_t.name
			else vs_pb.name
		end AS production_base_name, -- for sorting
		
		dest.name AS destination_name
		
	FROM vehicle_schedules vs
	
	LEFT JOIN drivers d ON d.id = vs.driver_id
	LEFT JOIN vehicles v ON v.id = vs.vehicle_id
	LEFT JOIN vehicle_schedule_states st ON
		st.id = (SELECT
				vehicle_schedule_states.id 
			FROM vehicle_schedule_states
			WHERE vehicle_schedule_states.schedule_id = vs.id
			ORDER BY vehicle_schedule_states.date_time DESC NULLS LAST
			LIMIT 1
		)
	LEFT JOIN production_bases AS vs_pb ON vs_pb.id = vs.production_base_id
	LEFT JOIN production_bases AS production_bases_ref_t ON production_bases_ref_t.id = st.production_base_id
	
	LEFT JOIN shipments AS sh ON sh.id=st.shipment_id
	LEFT JOIN orders AS o ON o.id=sh.order_id		
	LEFT JOIN destinations AS dest ON dest.id=o.destination_id
	LEFT JOIN vehicle_owners AS v_own ON v_own.id=v.vehicle_owner_id
	LEFT JOIN entity_contacts AS e_ct ON e_ct.entity_type = 'drivers' AND e_ct.entity_id = d.id
	LEFT JOIN contacts AS ct ON ct.id = e_ct.contact_id
	;		
	--WHERE vs.schedule_date=in_date


ALTER TABLE public.vehicle_states_all OWNER TO concrete1;



-- ******************* update 13/06/2024 07:26:30 ******************
-- View: public.orders_dialog

-- DROP VIEW public.orders_dialog;

CREATE OR REPLACE VIEW public.orders_dialog AS 
	SELECT
		o.id,
		order_num(o.*) AS number,		
		clients_ref(cl) AS clients_ref,		
		
		destinations_ref(d) AS destinations_ref,
		o.destination_price AS destination_cost,		
		--d.price AS destination_price,		
		CASE
			WHEN coalesce(d.special_price,FALSE) THEN
				--coalesce(d.price,0)
				period_value('destination_price', d.id, o.date_time)::numeric(15,2)
			ELSE
			coalesce(
				(SELECT sh_p.price
				FROM shipment_for_owner_costs sh_p
				WHERE sh_p.date<=o.date_time::date AND sh_p.distance_to>=d.distance
				ORDER BY sh_p.date DESC,sh_p.distance_to ASC
				LIMIT 1
				),			
			coalesce(d.price,0))			
		END  AS destination_price,
		
		d.time_route,
		d.distance,
		
		concrete_types_ref(concr) AS concrete_types_ref,
		o.concrete_price AS concrete_cost,		
		--concr.price AS concrete_price,
		coalesce(
			/*(SELECT
				ct_p.price
			FROM concrete_costs ct_p
			WHERE ct_p.date<=o.date_time::date AND ct_p.concrete_type_id=o.concrete_type_id
			ORDER BY ct_p.date DESC
			LIMIT 1
			),*/
			(SELECT pr.price FROM client_price_list(o.client_id,o.date_time)AS pr WHERE pr.concrete_type_id=o.concrete_type_id),
			coalesce(concr.price,0)
		) AS concrete_price,
		
		o.unload_type,
		o.comment_text,
		
		coalesce(ct.name::text, o.descr::text) AS descr,
		coalesce(ct.tel::text, o.phone_cel::text) AS phone_cel,
		
		o.unload_speed,
		o.date_time,
		o.time_to,		
		o.quant,
		langs_ref(l) AS langs_ref,
		o.total,
		o.total_edit,
		o.pay_cash,
		o.unload_price AS unload_cost,
		o.payed,
		o.under_control,
		
		pv.phone_cel AS pump_vehicle_phone_cel,
		pump_vehicles_ref(pv,v) AS pump_vehicles_ref,
		pump_prices_ref(ppr) AS pump_prices_ref,
		
		users_ref(u) AS users_ref,
		
		d.distance AS destination_distance,
		
		users_ref(lm_u) AS last_modif_users_ref,
		o.last_modif_date_time,
		
		o.create_date_time,
		
		o.ext_production,
		
		(e_user.id IS NOT NULL) tm_exists,
		(e_user.tm_id IS NOT NULL) tm_activated,
		e_user.tm_photo,
		
		o.contact_id AS contact_id,
		
		client_specifications_ref(spec) AS client_specifications_ref,
		
		o.f_val,
		o.w_val,
		
		debts.debt_total AS client_debt
		
	FROM orders o
	LEFT JOIN clients cl ON cl.id = o.client_id
	LEFT JOIN destinations d ON d.id = o.destination_id
	LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
	LEFT JOIN langs l ON l.id = o.lang_id
	LEFT JOIN pump_vehicles pv ON pv.id = o.pump_vehicle_id
	LEFT JOIN users u ON u.id = o.user_id
	LEFT JOIN pump_prices ppr ON ppr.id = pv.pump_price_id
	LEFT JOIN vehicles v ON v.id = pv.vehicle_id
	LEFT JOIN users lm_u ON lm_u.id = o.last_modif_user_id
	
	--LEFT JOIN client_tels AS tl ON tl.client_id=o.client_id AND tl.tel=o.phone_cel	
	
	LEFT JOIN contacts AS ct ON ct.id = o.contact_id
	LEFT JOIN notifications.ext_users_photo_list AS e_user ON e_user.ext_contact_id = o.contact_id
	LEFT JOIN client_specifications AS spec ON spec.id = o.client_specification_id
	LEFT JOIN (
		SELECT
			d.client_id,
			sum(d.debt_total) AS debt_total
		FROM client_debts AS d		
		GROUP BY d.client_id
	) AS debts ON debts.client_id = o.client_id
	
	ORDER BY o.date_time;

ALTER TABLE public.orders_dialog OWNER TO concrete1;



-- ******************* update 13/06/2024 07:28:43 ******************
-- FUNCTION: public.order_garbage_num(order_garbage)

-- DROP FUNCTION IF EXISTS public.order_garbage_num(order_garbage);

CREATE OR REPLACE FUNCTION public.order_garbage_num(
	order_garbage)
    RETURNS character varying
    LANGUAGE 'sql'
    COST 100
    IMMUTABLE
AS $BODY$
	SELECT 
	CASE WHEN EXTRACT(DAY FROM $1.date_time)<10 THEN
		'0' || EXTRACT(DAY FROM $1.date_time)::varchar || '-' || trim(to_char($1.number,'000'))
	ELSE
		EXTRACT(DAY FROM $1.date_time)::varchar || '-' || trim(to_char($1.number,'000'))
	END;
$BODY$;

ALTER FUNCTION public.order_garbage_num(order_garbage)
    OWNER TO concrete1;



-- ******************* update 13/06/2024 07:29:08 ******************
-- Function: public.order_garbage_ref(order_garbage)

-- DROP FUNCTION public.order_garbage_ref(order_garbage);

CREATE OR REPLACE FUNCTION public.order_garbage_ref(order_garbage)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr','Удаленная заявка №'||order_garbage_num($1)::text||' от '||to_char($1.date_time,'DD/MM/YY HH24:MI'),
		'dataType','order_garbage'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.order_garbage_ref(order_garbage) OWNER TO concrete1;



-- ******************* update 13/06/2024 07:29:14 ******************
-- View: order_garbage_list

-- DROP VIEW order_garbage_list;

CREATE OR REPLACE VIEW order_garbage_list AS 
	SELECT
		o.id,
		order_garbage_num(o.*) AS number,
		clients_ref(cl) AS clients_ref,
		o.client_id,
		destinations_ref(d) AS destinations_ref,
		o.destination_id,
		concrete_types_ref(concr) AS concrete_types_ref,
		o.concrete_type_id,
		o.unload_type AS unload_type,
		o.comment_text AS comment_text,
		
		coalesce(ct.name::text, o.descr::text) AS descr,
		coalesce(ct.tel::text, o.phone_cel::text) AS phone_cel,
		
		o.date_time,
		o.quant,
		users_ref(u) AS users_ref,
		o.user_id,
		order_garbage_ref(o) AS orders_ref,
		contacts_ref(ct) AS contacts_ref		
		
   FROM order_garbage o
   LEFT JOIN clients cl ON cl.id = o.client_id
   LEFT JOIN destinations d ON d.id = o.destination_id
   LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
   LEFT JOIN contacts ct ON ct.id = o.contact_id
   LEFT JOIN users u ON u.id = o.user_id
  ORDER BY o.date_time DESC;

ALTER TABLE order_garbage_list OWNER TO concrete1;