-- FUNCTION: public.sms_tm_invite_contact_new(integer, text)

-- DROP FUNCTION IF EXISTS public.sms_tm_invite_contact_new(integer, text);

CREATE OR REPLACE FUNCTION public.sms_tm_invite_contact_new(
	in_contact_id integer,
	in_code text)
    RETURNS TABLE(phone_cel text, message text, ext_obj json) 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
 
	SELECT
		ct.tel,
		sms_templates_text(
			ARRAY[
				format('("code","%s")'::text, in_code)::template_value
			],
			( SELECT t.pattern
			FROM sms_patterns t
			WHERE t.sms_type = 'tm_invite'::sms_types AND t.lang_id = 1
			)
		) AS message,
		contacts_ref(ct) AS ext_obj
		
	FROM contacts AS ct
	WHERE ct.id = in_contact_id;
$BODY$;

ALTER FUNCTION public.sms_tm_invite_contact_new(integer, text)
    OWNER TO beton;

