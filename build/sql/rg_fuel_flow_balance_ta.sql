
--DROP FUNCTION rg_fuel_flow_balance( IN in_vehicle_id_ar int[]);

--TA balance
CREATE OR REPLACE FUNCTION rg_fuel_flow_balance( IN in_vehicle_id_ar int[])
  RETURNS TABLE(
	vehicle_id int
	,
	quant int				
	) AS
$BODY$
	SELECT
		b.vehicle_id
		,b.quant AS quant				
	FROM rg_fuel_flow AS b
	WHERE b.date_time=reg_current_balance_time()
		AND (in_vehicle_id_ar IS NULL OR ARRAY_LENGTH(in_vehicle_id_ar,1) IS NULL OR (b.vehicle_id=ANY(in_vehicle_id_ar)))
		AND(
		b.quant<>0
		)
	ORDER BY
		b.vehicle_id;
$BODY$
  LANGUAGE sql VOLATILE CALLED ON NULL INPUT
  COST 100;
ALTER FUNCTION rg_fuel_flow_balance(
	IN in_vehicle_id_ar int[]
	)
 OWNER TO beton;

