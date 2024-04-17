-- FUNCTION: public.orders_complete_descr(integer, text)

-- DROP FUNCTION IF EXISTS public.orders_complete_descr(integer, text);

CREATE OR REPLACE FUNCTION public.orders_complete_descr(
	in_client_id integer,
	in_descr text)
    RETURNS TABLE(descr text, phone_cel text, langs_ref json, clients_ref json, client_tels_ref json, tm_exists boolean, tm_activated boolean) 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
	WITH
	contacts AS (
		SELECT
			tl.id,
			tl.name,
			tl.tel,
			clients_ref(cl) AS clients_ref,
			client_tels_ref(tl) AS client_tels_ref,
			(e_user.id IS NOT NULL) tm_exists,
			(e_user.tm_id IS NOT NULL) tm_activated

		FROM client_tels AS tl
		LEFT JOIN notifications.ext_users_list AS e_user ON (e_user.ext_obj->'keys'->>'id')::int=tl.id
		LEFT JOIN clients cl ON cl.id=tl.client_id
		WHERE tl.client_id=in_client_id AND (coalesce(in_descr,'')='' OR lower(tl.name) LIKE lower(in_descr)||'%%')
		ORDER BY tl.name
	),
	o_list AS (
		SELECT DISTINCT ON (o.descr)
				o.descr,
				o.date_time,
				o.phone_cel,
				langs_ref(lg) AS langs_ref,
				ct.id AS contact_id,
				ct.clients_ref,
				ct.client_tels_ref,
				ct.tm_exists,
				ct.tm_activated
			FROM orders AS o
			LEFT JOIN clients cl ON cl.id=o.client_id
			LEFT JOIN langs lg ON lg.id=o.lang_id
			LEFT JOIN contacts AS ct ON ct.tel=o.phone_cel
			WHERE o.client_id=in_client_id AND (coalesce(in_descr,'')='' OR lower(o.descr) LIKE lower(in_descr)||'%%')
			LIMIT 10
	)
	(SELECT
		o_list.descr,
		o_list.phone_cel,
		o_list.langs_ref,
		o_list.clients_ref,
		o_list.client_tels_ref,
		o_list.tm_exists,
		o_list.tm_activated
	FROM o_list
	ORDER BY o_list.date_time DESC)

	UNION ALL

	(SELECT
		contacts.name,
		contacts.tel,
		const_def_lang_val() AS langs_ref,
		contacts.clients_ref,
		contacts.client_tels_ref,
		contacts.tm_exists,
		contacts.tm_activated
	FROM contacts
	WHERE contacts.id NOT IN (SELECT o_list.contact_id FROM o_list)
	ORDER BY contacts.name
	);
$BODY$;

ALTER FUNCTION public.orders_complete_descr(integer, text)
    OWNER TO beton;

