-- Function: sms_tm_invite_contact_new(in_contact_id int)

-- Instead of sms_tm_invite_contact()

-- DROP FUNCTION sms_tm_invite_contact_new(in_contact_id int);

CREATE OR REPLACE FUNCTION sms_tm_invite_contact_new(in_contact_id int, in_code text)
  RETURNS TABLE(
  	phone_cel text,
  	message text,
  	ext_obj json
  ) AS
$$ 
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
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION sms_tm_invite_contact_new(in_contact_id int, in_code text) OWNER TO ;

