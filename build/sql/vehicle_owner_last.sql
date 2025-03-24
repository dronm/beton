CREATE OR REPLACE FUNCTION wehicle_owner_last(in_vehicle_id int)
RETURNS int AS
$$
	select
		(r.rows->'fields'->'owner'->'keys'->'id')::int
	FROM	
	(select jsonb_array_elements(vehicle_owners->'rows') AS rows from vehicles where id=in_vehicle_id) AS r
	order by r.rows->'dt_from' asc
	limit 1;
$$
  LANGUAGE sql VOLATILE
  COST 100;
