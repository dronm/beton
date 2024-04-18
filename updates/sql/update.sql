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