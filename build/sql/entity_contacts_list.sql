-- VIEW: entity_contacts_list

--DROP VIEW entity_contacts_list;

CREATE OR REPLACE VIEW entity_contacts_list AS
	SELECT
		e_ct.id ,
		e_ct.entity_type,
		e_ct.entity_id,
		CASE
			WHEN e_ct.entity_type = 'clients' THEN clients_ref(cl)
			WHEN e_ct.entity_type = 'users' THEN users_ref(u)
			WHEN e_ct.entity_type = 'suppliers' THEN suppliers_ref(spl)
			WHEN e_ct.entity_type = 'drivers' THEN drivers_ref(drv)
			WHEN e_ct.entity_type = 'pump_vehicles' THEN pump_vehicles_ref(
				pvh,
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
			)
			ELSE NULL
		END AS entities_ref,
		e_ct.contact_id,
		contacts_ref(ct) AS contacts_ref,
		json_build_object(
			'name', ct.name,
			'tel', ct.tel,
			'email', ct.email,
			'tel_ext', ct.tel_ext,
			'post', p.name
		) AS contact_attrs,
		
		(e_user.id IS NOT NULL) AS tm_exists,
		(e_user.tm_id IS NOT NULL) AS tm_activated
		
		
	FROM entity_contacts AS e_ct
	LEFT JOIN clients AS cl ON e_ct.entity_type = 'clients' AND cl.id = e_ct.entity_id
	LEFT JOIN users AS u ON e_ct.entity_type = 'users' AND u.id = e_ct.entity_id
	LEFT JOIN suppliers AS spl ON e_ct.entity_type = 'suppliers' AND spl.id = e_ct.entity_id
	LEFT JOIN pump_vehicles AS pvh ON e_ct.entity_type = 'pump_vehicles' AND pvh.id = e_ct.entity_id
	LEFT JOIN vehicles AS v ON v.id = pvh.vehicle_id
	LEFT JOIN drivers AS drv ON e_ct.entity_type = 'drivers' AND drv.id = e_ct.entity_id
	LEFT JOIN contacts AS ct ON ct.id = e_ct.contact_id
	LEFT JOIN posts AS p ON p.id = ct.post_id
	
	LEFT JOIN notifications.ext_users_list AS e_user ON e_user.app_id = 1 AND e_user.ext_contact_id = e_ct.entity_id
	/*LEFT JOIN notifications.ext_users_list AS e_user ON e_user.ext_obj->>'dataType'='contacts'
		AND (e_user.ext_obj->'keys'->>'id')::int = e_ct.contact_id
		AND e_user.app_id=1
	*/	
	
	ORDER BY e_ct.entity_type,
		CASE
			WHEN e_ct.entity_type = 'clients' THEN clients_ref(cl)->>'descr'
			WHEN e_ct.entity_type = 'users' THEN users_ref(u)->>'descr'
			WHEN e_ct.entity_type = 'suppliers' THEN suppliers_ref(spl)->>'descr'
			WHEN e_ct.entity_type = 'drivers' THEN drivers_ref(drv)->>'descr'
			WHEN e_ct.entity_type = 'pump_vehicles' THEN pump_vehicles_ref(
				pvh,
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
			)->>'descr'
			ELSE NULL
		END
	;
	
ALTER VIEW entity_contacts_list OWNER TO ;
