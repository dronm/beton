-- View: workplace_schedules_list;

-- DROP VIEW workplace_schedules_list;

CREATE OR REPLACE VIEW workplace_schedules_list AS 
	SELECT
		t.id,
		t.for_date,
		workplaces_ref(wp) AS workplaces_ref,
		users_ref(u) AS users_ref
	FROM workplace_schedules t
	LEFT JOIN users u ON u.id = t.user_id
	LEFT JOIN workplaces wp ON wp.id = t.workplace_id
	
	ORDER BY t.for_date DESC, wp.name;




