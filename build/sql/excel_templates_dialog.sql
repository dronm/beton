-- VIEW: excel_templates_dialog

--DROP VIEW excel_templates_dialog;

CREATE OR REPLACE VIEW excel_templates_dialog AS
	SELECT
		id,
		name,
		file_info,
		sql_query,
		cell_matching
		
	FROM excel_templates
	;
	
ALTER VIEW excel_templates_dialog OWNER TO ;
