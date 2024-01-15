-- Function: vehicle_tot_rep_item_exec_query(in_query text, in_vehicle_id int, in_date_time_from timestampTZ, in_date_time_to timestampTZ)

--DROP FUNCTION vehicle_tot_rep_item_exec_query(in_query text, in_vehicle_id int, in_date_time_from timestampTZ, in_date_time_to timestampTZ);

CREATE OR REPLACE FUNCTION vehicle_tot_rep_item_exec_query(in_query text, in_vehicle_id int, in_date_time_from timestampTZ, in_date_time_to timestampTZ)
  RETURNS numeric(15,2) AS
$$
DECLARE
	v_query text;
	v_val numeric(15, 2);
BEGIN
	v_query = REPLACE(in_query, '{{VEHICLE_ID}}', in_vehicle_id::text );
	v_query = REPLACE(v_query, '{{DATE_FROM}}', in_date_time_from::text);
	v_query = REPLACE(v_query, '{{DATE_TO}}', in_date_time_to::text);
	EXECUTE v_query INTO v_val;
	RETURN coalesce(v_val, 0.00);
END;
$$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION vehicle_tot_rep_item_exec_query(in_query text, in_vehicle_id int, in_date_time_from timestampTZ, in_date_time_to timestampTZ) OWNER TO ;

