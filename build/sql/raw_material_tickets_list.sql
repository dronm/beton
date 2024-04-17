-- VIEW: raw_material_tickets_list

--DROP VIEW raw_material_tickets_list;

CREATE OR REPLACE VIEW raw_material_tickets_list AS
	SELECT
		t.id 
		,t.carrier_id
		,suppliers_ref(cr) AS carriers_ref
		,t.raw_material_id
		,materials_ref(m) AS raw_materials_ref
		,t.barcode
		,t.quant
		,t.issue_date_time
		,t.close_date_time
		,t.issue_user_id
		,users_ref(i_u) AS issue_users_ref
		,t.close_user_id
		,users_ref(c_u) AS close_users_ref
		,t.expire_date
		
	FROM raw_material_tickets AS t
	LEFT JOIN suppliers AS cr ON cr.id = t.carrier_id
	LEFT JOIN raw_materials AS m ON m.id = t.raw_material_id
	LEFT JOIN users AS i_u ON i_u.id = t.issue_user_id
	LEFT JOIN users AS c_u ON c_u.id = t.close_user_id
	ORDER BY t.issue_date_time DESC
	;
	
ALTER VIEW raw_material_tickets_list OWNER TO ;
