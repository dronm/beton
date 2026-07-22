-- Function: public.workplaces_process()

-- DROP FUNCTION public.workplaces_process();

CREATE OR REPLACE FUNCTION public.workplaces_process()
RETURNS trigger
LANGUAGE plpgsql
VOLATILE
AS $BODY$
BEGIN
	/*
	 * Remove workplace-derived information from the previous user when:
	 * - the workplace is assigned to another user;
	 * - the workplace becomes unassigned.
	 */
	IF TG_OP = 'UPDATE'
		AND OLD.user_id IS NOT NULL
		AND OLD.user_id IS DISTINCT FROM NEW.user_id
	THEN
		DELETE FROM user_mac_addresses
		WHERE user_id = OLD.user_id;

		UPDATE users
		SET tel_ext = NULL
		WHERE id = OLD.user_id;

		UPDATE contacts AS c
		SET tel_ext = NULL
		FROM entity_contacts AS ec
		WHERE ec.contact_id = c.id
			AND ec.entity_id = OLD.user_id
			AND ec.entity_type = 'users';
	END IF;

	/*
	 * Rebuild MAC addresses whenever the assigned user or MAC address list
	 * changes.
	 */
	IF TG_OP = 'INSERT'
		OR NEW.user_id IS DISTINCT FROM OLD.user_id
		OR NEW.mac_addresses IS DISTINCT FROM OLD.mac_addresses
	THEN
		IF NEW.user_id IS NOT NULL THEN
			DELETE FROM user_mac_addresses
			WHERE user_id = NEW.user_id;

			INSERT INTO user_mac_addresses (
				user_id,
				mac_address
			)
			SELECT
				NEW.user_id,
				BTRIM(row_item->'fields'->>'mac_address')
			FROM jsonb_array_elements(
				COALESCE(NEW.mac_addresses->'rows', '[]'::jsonb)
			) AS rows(row_item)
			WHERE NULLIF(
				BTRIM(row_item->'fields'->>'mac_address'),
				''
			) IS NOT NULL;
		END IF;
	END IF;

	/*
	 * Synchronize the extension when the workplace is assigned to a user.
	 */
	IF NEW.user_id IS NOT NULL THEN
		UPDATE users
		SET tel_ext = NEW.tel_ext
		WHERE id = NEW.user_id;

		UPDATE contacts AS c
		SET tel_ext = NEW.tel_ext
		FROM entity_contacts AS ec
		WHERE ec.contact_id = c.id
			AND ec.entity_id = NEW.user_id
			AND ec.entity_type = 'users';
	END IF;

	RETURN NEW;
END;
$BODY$;
