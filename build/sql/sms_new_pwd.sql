-- Function: sms_new_pwd(in_user_id int, in_pwd text)

 DROP FUNCTION sms_new_pwd(in_user_id int, in_pwd text);

/**
 * Используется именно функция
 * из User_Controller
 */
CREATE OR REPLACE FUNCTION sms_new_pwd(in_user_id int, in_pwd text)
  RETURNS TABLE(
  	phone_cel text,
  	message text,
  	ext_contact_id int
  ) AS
$$
	SELECT
		format_cel_standart(ct.tel) AS tel,
		sms_templates_text(
			ARRAY[
				format('("pwd","%s")'::text, in_pwd)::template_value,
				format('("name","%s")'::text, u.name::text)::template_value
			],
			( SELECT t.pattern
			FROM sms_patterns t
			WHERE t.sms_type = 'new_pwd'::sms_types AND t.lang_id = ((const_def_lang_val())->'keys'->>'id')::int
			)
		) AS message,
		ct.id AS ext_contact_id
	
	FROM users AS u
	LEFT JOIN entity_contacts AS e_ct ON e_ct.entity_type = 'users' AND e_ct.entity_id = in_user_id
	LEFT JOIN contacts AS ct ON ct.id = e_ct.contact_id
	WHERE u.id = in_user_id;	
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION sms_new_pwd(in_user_id int, in_pwd text) OWNER TO ;
