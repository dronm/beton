-- VIEW: production_bases_list

--DROP VIEW production_bases_list;

CREATE OR REPLACE VIEW production_bases_list AS
	SELECT
		b.id ,
		b.name,
		destinations_ref(d) AS destinations_ref
	FROM production_bases AS b
	LEFT JOIN destinations AS d ON d.id = b.destination_id
	ORDER BY b.name
	;
	
ALTER VIEW production_bases_list OWNER TO ;
