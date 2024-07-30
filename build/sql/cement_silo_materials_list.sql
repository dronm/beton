-- VIEW: cement_silo_materials_list

--DROP VIEW cement_silo_materials_list;

CREATE OR REPLACE VIEW cement_silo_materials_list AS
	SELECT
		t.id,
		t.cement_silo_id,
		cement_silos_ref(cs) AS cement_silos_ref,		
		materials_ref(mat) AS materials_ref,
		t.date_time
		
	FROM cement_silo_materials AS t
	LEFT JOIN cement_silos AS cs ON cs.id=t.cement_silo_id
	LEFT JOIN raw_materials AS mat ON mat.id=t.material_id
	ORDER BY cs.name, t.date_time DESC
	;
	
ALTER VIEW cement_silo_materials_list OWNER TO ;
