-- VIEW: ext_users_photo_list

--DROP VIEW ext_users_photo_list;

CREATE OR REPLACE VIEW ext_users_photo_list AS
	SELECT
		u.*,
		contacts_ref(ct) AS ext_contacts_ref,
		ct.tel AS ext_contacts_tel
	FROM notifications.ext_users_photo_list AS u
	LEFT JOIN contacts AS ct ON ct.id = u.ext_contact_id
	;
ALTER VIEW ext_users_photo_list OWNER TO ;
