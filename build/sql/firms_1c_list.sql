-- VIEW: firms_1c_list

--DROP VIEW firms_1c_list;

CREATE OR REPLACE VIEW firms_1c_list AS
	SELECT
		id,
		ref_1c->>'descr' AS descr,
		inn
	FROM firms_1c
	ORDER BY ref_1c->>'descr'
	;
	
ALTER VIEW firms_1c_list OWNER TO ;
