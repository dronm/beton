-- VIEW: employees_list

--DROP VIEW employees_list;

CREATE OR REPLACE VIEW employees_list AS
	SELECT
		e.id,
		e.name,
		e.employed,
		users_ref(u) AS users_ref,
		e.inn,
		e.post
	FROM employees AS e
	LEFT JOIN users AS u ON u.id = e.user_id
	;
