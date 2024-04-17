-- VIEW: client_tels_list

--DROP VIEW client_tels_list;

CREATE OR REPLACE VIEW client_tels_list AS
	SELECT
		t.*,
		clients_ref(cl) AS clients_ref,
		(e_user.id IS NOT NULL) AS tm_exists,
		(e_user.tm_id IS NOT NULL) AS tm_activated
		
	FROM client_tels AS t
	LEFT JOIN clients AS cl ON cl.id=t.client_id
	LEFT JOIN notifications.ext_users_list AS e_user ON e_user.ext_obj->>'dataType'='client_tels'
		AND (e_user.ext_obj->'keys'->>'id')::int=t.id
		AND e_user.app_id=1
	ORDER BY t.search
	;
	
ALTER VIEW client_tels_list OWNER TO ;
