--Refrerece type
CREATE OR REPLACE FUNCTION vehicle_tot_rep_items_ref(vehicle_tot_rep_items)
  RETURNS json AS
$$
	SELECT json_build_object(
		'keys',json_build_object(
			),	
		'descr',$1.name,
		'dataType','vehicle_tot_rep_items'
	);
$$
  LANGUAGE sql VOLATILE COST 100;
ALTER FUNCTION vehicle_tot_rep_items_ref(vehicle_tot_rep_items) OWNER TO beton;	

