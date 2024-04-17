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
  OWNER TO ;

