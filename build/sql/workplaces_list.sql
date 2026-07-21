-- View: workplaces_list;

-- DROP VIEW workplaces_list;

CREATE OR REPLACE VIEW workplaces_list AS 
	SELECT
		t.id,
		t.name,
		t.tel_ext,
		t.mac_addresses,
		t.user_id,
		users_ref(u) AS users_ref
	FROM workplaces t
	LEFT JOIN users u ON u.id = t.user_id
	
	ORDER BY t.name;

