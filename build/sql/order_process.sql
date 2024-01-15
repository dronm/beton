-- FUNCTION: public.order_process()

-- DROP FUNCTION IF EXISTS public.order_process();

CREATE OR REPLACE FUNCTION public.order_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	v_contact_name text;
BEGIN
	IF (TG_OP='INSERT') OR ((TG_OP='UPDATE') AND (NEW.date_time::date!=OLD.date_time::date)) THEN
		SELECT coalesce(MAX(number),0)+1
		INTO NEW.number
		FROM orders AS o WHERE o.date_time::date=NEW.date_time::date;		
	END IF;
	
	IF TG_OP='INSERT' THEN
		NEW.last_modif_user_id = NEW.user_id;		
	END IF;
	NEW.last_modif_date_time = now();
	
	NEW.date_time_to = get_order_date_time_to(NEW.date_time,NEW.quant::numeric, NEW.unload_speed::numeric, const_order_step_min_val());

	IF NEW.lang_id IS NULL THEN
		NEW.lang_id = 1;
	END IF;
	
	--Проверяем данные контакта
	IF coalesce(NEW.phone_cel, '') <> '' THEN
		--поиск по телефону
		SELECT
			ct.id,
			ct.name::text
		INTO
			NEW.contact_id,
			v_contact_name
		FROM contacts AS ct
		WHERE ct.tel = format_cel_standart(NEW.phone_cel);
		
		IF NEW.contact_id IS NOT NULL THEN
			IF coalesce(NEW.descr,'') <> '' AND v_contact_name <> NEW.descr THEN
				--сменилось имя
				UPDATE contacts
				SET name = NEW.descr
				WHERE id = NEW.contact_id;
			END IF;
		ELSE
			--нет такого телефона в контактах
			v_contact_name = coalesce(NEW.descr, '');
			IF v_contact_name = '' THEN
				SELECT cl.name INTO v_contact_name FROM clients AS cl
				WHERE cl.id = NEW.client_id;
			END IF;
		
			INSERT INTO contacts (name, tel)
			VALUES (v_contact_name, NEW.phone_cel)
			ON CONFLICT (tel) DO UPDATE SET name = v_contact_name
			RETURNING id INTO NEW.contact_id;
		END IF;
	END IF;
	
	-- а есть ли контакт у клиента?
	IF NEW.contact_id IS NOT NULL AND coalesce(
		(SELECT TRUE
		FROM entity_contacts AS e_ct
		WHERE e_ct.contact_id = NEW.contact_id AND e_ct.entity_type = 'clients' AND e_ct.entity_id = NEW.client_id)
		,FALSE) = FALSE THEN
		
		INSERT INTO entity_contacts (entity_type, entity_id, contact_id)
		VALUES ('clients', NEW.client_id, NEW.contact_id)
		ON CONFLICT (entity_type, entity_id, contact_id) DO NOTHING;
	END IF;
	
	/*
	round_minutes(New.date_time +
		to_char( (floor(60* NEW.quant/NEW.unload_speed)::text || ' minutes')::interval, 'HH24:MI')::interval,
		const_order_step_min_val()
		);
	*/
	--RAISE 'v_end_time_min=%',NEW.time_to;
	
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION public.order_process() OWNER TO ;

