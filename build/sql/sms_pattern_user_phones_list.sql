-- VIEW: sms_pattern_user_phones_list

--DROP VIEW sms_pattern_user_phones_list;

CREATE OR REPLACE VIEW sms_pattern_user_phones_list AS
	SELECT
		ph.*,
		users_ref(u) AS users_ref,
		ct.tel AS user_tel,
		en_ct.contact_id
	FROM sms_pattern_user_phones AS ph
	LEFT JOIN users AS u ON u.id = ph.user_id
	LEFT JOIN entity_contacts AS en_ct ON en_ct.entity_type = 'users' AND en_ct.entity_id = ph.user_id
	LEFT JOIN contacts AS ct ON ct.id = en_ct.contact_id
	;
	
ALTER VIEW sms_pattern_user_phones_list OWNER TO ;
