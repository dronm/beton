-- FUNCTION: public.ast_calls_process()

-- DROP FUNCTION IF EXISTS public.ast_calls_process();

/**
 * Заполняем contact_id
 */

CREATE OR REPLACE FUNCTION public.ast_calls_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	v_search text;
	v_contact_name text;
	v_contact_post text;
	v_entity_name text;
	v_tel_formatted text;
	v_event_id text;
BEGIN
	IF (TG_OP='INSERT') THEN
		NEW.dt = now()::timestamp;
		
		--********* Client ********************
		IF NEW.call_type='in'::call_types THEN			
			IF substring(NEW.caller_id_num from 1 for 2)='+7' THEN
				NEW.caller_id_num = substring(NEW.caller_id_num from 3);
			END IF;
			v_search = NEW.caller_id_num;
		ELSE
			v_search = NEW.ext;
			IF (char_length(v_search)>3 AND char_length(v_search)<10) THEN
				v_search = const_city_ext_val()::text||v_search;
			END IF;
			
		END IF;

		IF (char_length(v_search)>3) THEN
			SELECT
				ct.id,
				v_search,
				ct.name,
				posts.name
			FROM contacts AS ct
			INTO
				NEW.contact_id,
				NEW.client_tel,
				v_contact_name,
				v_contact_post	
			LEFT JOIN posts ON posts.id = ct.post_id			
			WHERE ct.tel = v_search			
			LIMIT 1;
			
			IF NEW.contact_id IS NOT NULL THEN
				-- представление контрагента/юзера/поставщика и т.д.
				SELECT
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
					END,
					CASE
						WHEN e_ct.entity_type = 'clients' THEN e_ct.entity_id
						ELSE NULL
					END
				INTO
					v_entity_name,
					NEW.client_id
				FROM entity_contacts AS e_ct
				LEFT JOIN clients AS cl ON e_ct.entity_type = 'clients' AND cl.id = e_ct.entity_id
				LEFT JOIN users AS u ON e_ct.entity_type = 'users' AND u.id = e_ct.entity_id
				LEFT JOIN suppliers AS spl ON e_ct.entity_type = 'suppliers' AND spl.id = e_ct.entity_id
				LEFT JOIN pump_vehicles AS pvh ON e_ct.entity_type = 'pump_vehicles' AND pvh.id = e_ct.entity_id
				LEFT JOIN vehicles AS v ON v.id = pvh.vehicle_id
				LEFT JOIN drivers AS drv ON e_ct.entity_type = 'drivers' AND drv.id = e_ct.entity_id					
				WHERE e_ct.contact_id = NEW.contact_id
				ORDER BY 
					CASE
						WHEN e_ct.entity_type='clients' THEN 0
						WHEN e_ct.entity_type='users' THEN 1
						ELSE 2
					END
				LIMIT 1;			
			END IF;
				
			--In call for all notification
			IF NEW.call_type='in'::call_types
			AND NEW.end_time IS NULL
			THEN
				IF NEW.ext IS NOT NULL AND LENGTH(NEW.ext)>3 THEN
					v_event_id = 'AstCall.in_call';
				ELSIF NEW.ext IS NOT NULL THEN
					--extension exists!
					v_event_id = 'AstCall.in_call.'||NEW.ext;
				END IF;	
				
				IF v_event_id IS NOT NULL THEN
					PERFORM pg_notify(
						v_event_id
						,json_build_object(
							'params',json_build_object(
								'client_id',NEW.client_id
								,'client_name',v_entity_name
								,'tel', format_cel_phone(RIGHT(v_search,10))
								,'client_repres_name',v_contact_name
								,'client_repres_post',v_contact_post
								,'ext',NEW.ext
								,'unique_id',NEW.unique_id
							)
						)::text
					);
				END IF;
			END IF;			
			
		END IF;
		--********* Client ********************
		
		--grid notification
		PERFORM pg_notify('AstCall.insert', NULL);
		
		
	ELSIF (TG_OP='UPDATE') THEN
		--****** User ****************
		IF NEW.call_type='in'::call_types THEN
			IF substring(NEW.caller_id_num from 1 for 2)='+7' THEN
				NEW.caller_id_num = substring(NEW.caller_id_num from 3);
			END IF;
		
			IF NEW.contact_id IS NULL AND OLD.contact_id IS NULL THEN
				v_search = NEW.caller_id_num;
				
				IF (char_length(v_search)>3) THEN
					SELECT
						ct.id,
						v_search,
						ct.name,
						posts.name
					FROM contacts AS ct
					INTO
						NEW.contact_id,
						NEW.client_tel,
						v_contact_name,
						v_contact_post
					LEFT JOIN posts ON posts.id = ct.post_id
					WHERE ct.tel = v_search					
					;

				IF NEW.contact_id IS NOT NULL THEN
					-- представление контрагента/юзера/поставщика и т.д.
					SELECT
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
						END,
						CASE
							WHEN e_ct.entity_type = 'clients' THEN e_ct.entity_id
							ELSE NULL
						END
					INTO
						v_entity_name,
						NEW.client_id
					FROM entity_contacts AS e_ct
					LEFT JOIN clients AS cl ON e_ct.entity_type = 'clients' AND cl.id = e_ct.entity_id
					LEFT JOIN users AS u ON e_ct.entity_type = 'users' AND u.id = e_ct.entity_id
					LEFT JOIN suppliers AS spl ON e_ct.entity_type = 'suppliers' AND spl.id = e_ct.entity_id
					LEFT JOIN pump_vehicles AS pvh ON e_ct.entity_type = 'pump_vehicles' AND pvh.id = e_ct.entity_id
					LEFT JOIN vehicles AS v ON v.id = pvh.vehicle_id
					LEFT JOIN drivers AS drv ON e_ct.entity_type = 'drivers' AND drv.id = e_ct.entity_id					
					WHERE e_ct.contact_id = NEW.contact_id
					ORDER BY 
						CASE
							WHEN e_ct.entity_type='clients' THEN 0
							WHEN e_ct.entity_type='users' THEN 1
							ELSE 2
						END
					LIMIT 1;			
				END IF;
				
					IF NEW.ext IS NOT NULL AND LENGTH(NEW.ext)>3 THEN
						v_event_id = 'AstCall.in_call';
					ELSIF NEW.ext IS NOT NULL THEN
						--extension exists!
						v_event_id = 'AstCall.in_call.'||NEW.ext;
					END IF;	
					
					IF v_event_id IS NOT NULL THEN
						PERFORM pg_notify(
							v_event_id
							,json_build_object(
								'params',json_build_object(
									'client_id',NEW.client_id
									,'client_name',v_entity_name
									,'tel',format_cel_phone(RIGHT(v_search,10))
									,'client_repres_name',v_contact_name
									,'client_repres_post',v_contact_post
									,'ext',NEW.ext
									,'unique_id',NEW.unique_id
								)
							)::text
						);
					END IF;
					
				END IF;
				
			END IF;
		
			--notifications
			IF NEW.end_time IS NOT NULL AND OLD.end_time IS NULL AND NEW.ext IS NOT NULL AND LENGTH(NEW.ext)=3 THEN
				PERFORM pg_notify(
					'AstCall.hangup.'||NEW.ext
					,NULL
				);
				PERFORM pg_notify(
					'AstCall.hangup.'||NEW.unique_id
					,NULL
				);
				
			ELSIF NEW.end_time IS NULL AND OLD.start_time IS NULL AND NEW.start_time IS NOT NULL
			 AND NEW.ext IS NOT NULL AND LENGTH(NEW.ext)=3 THEN
				PERFORM pg_notify(
					'AstCall.pickup.'||NEW.ext
					,NULL
				);
				PERFORM pg_notify(
					'AstCall.pickup.'||NEW.unique_id
					,NULL
				);
				
			END IF;
			
		
			v_search = NEW.ext;
		ELSE		
			v_search = NEW.caller_id_num;
		END IF;

		--setting user from logged in
		SELECT
			u.id
		INTO
			NEW.user_id
		FROM users_tel_ext_list  AS u
		WHERE u.tel_ext = v_search
		AND (
			SELECT TRUE
			FROM logins
			WHERE user_id = u.id and date_time_out IS NULL
			ORDER BY date_time_in desc LIMIT 1
		)
		LIMIT 1;
		
		
		--************ USER TO ***************
		/*
		IF NEW.call_type='out'::call_types
		AND char_length(NEW.ext)<=3 THEN
			--Внутренний номер
			NEW.user_id_to = (SELECT id
					FROM users
				WHERE tel_ext=NEW.ext
			);
			
		END IF;
		*/
		
		--grid notification
		PERFORM pg_notify('AstCall.update', NULL);
		
	END IF;
	
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.ast_calls_process()
    OWNER TO beton;

