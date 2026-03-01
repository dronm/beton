--DROP FUNCTION rg_fuel_flow_balance(in_doc_type doc_types, in_doc_id int, IN in_vehicle_id_ar int[])

--balance on doc
CREATE OR REPLACE FUNCTION rg_fuel_flow_balance(in_doc_type doc_types, in_doc_id int,
	IN in_vehicle_id_ar int[]
	)
  RETURNS TABLE(
	vehicle_id int
	,
	quant int				
	) AS
$BODY$
	SELECT * FROM rg_fuel_flow_balance(
		(SELECT doc_log.date_time FROM doc_log WHERE doc_log.doc_type=in_doc_type AND doc_log.doc_id=in_doc_id),
		in_vehicle_id_ar 				
		);
$BODY$
  LANGUAGE sql VOLATILE CALLED ON NULL INPUT
  COST 100;

