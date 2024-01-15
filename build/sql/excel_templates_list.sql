-- VIEW: excel_templates_list

--DROP VIEW excel_templates_list;

CREATE OR REPLACE VIEW excel_templates_list AS
	SELECT
		id,
		name,
		file_info
	FROM excel_templates
	ORDER BY name
	;
	
ALTER VIEW excel_templates_list OWNER TO ;
