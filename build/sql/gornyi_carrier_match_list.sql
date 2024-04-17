-- VIEW: gornyi_carrier_match_list

--DROP VIEW gornyi_carrier_match_list;

CREATE OR REPLACE VIEW gornyi_carrier_match_list AS
	SELECT
		t.id 
		,suppliers_ref(cr) AS carriers_ref
		,t.plate
		
	FROM gornyi_carrier_match AS t
	LEFT JOIN suppliers AS cr ON cr.id = t.carrier_id
	ORDER BY t.plate
	;
	
ALTER VIEW gornyi_carrier_match_list OWNER TO ;
