-- VIEW: concrete_types_for_site_list

--DROP VIEW concrete_types_for_site_list;

CREATE OR REPLACE VIEW concrete_types_for_site_list AS
	SELECT
		ctp.id,
		ctp.name
		
	FROM concrete_types AS ctp	
	WHERE ctp.show_on_site
	ORDER BY ctp.name
	;
	
ALTER VIEW concrete_types_for_site_list OWNER TO ;
