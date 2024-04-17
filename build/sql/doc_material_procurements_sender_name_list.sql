-- VIEW: doc_material_procurements_sender_name_list

--DROP VIEW doc_material_procurements_sender_name_list;

CREATE OR REPLACE VIEW doc_material_procurements_sender_name_list AS
	SELECT
		DISTINCT sender_name
		
	FROM doc_material_procurements
	WHERE coalesce(sender_name,'')<>''
	ORDER BY sender_name
	;
	
ALTER VIEW doc_material_procurements_sender_name_list OWNER TO ;
