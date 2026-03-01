
--DROP FUNCTION rg_calc_interval(in_reg_type reg_types);

--********** Calc interval for a reginster ***************************************** 
CREATE OR REPLACE FUNCTION rg_calc_interval(in_reg_type reg_types)
  RETURNS interval AS
$BODY$
	SELECT
		CASE $1
		WHEN 'material'::reg_types THEN '1 month'::interval
		WHEN 'cement'::reg_types THEN '1 month'::interval
		WHEN 'material_fact'::reg_types THEN '1 month'::interval
		WHEN 'fuel_flow'::reg_types THEN '1 month'::interval
		END;
$BODY$
  LANGUAGE sql IMMUTABLE COST 100;

