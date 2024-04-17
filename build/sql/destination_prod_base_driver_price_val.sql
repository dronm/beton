-- Function: destination_prod_base_driver_price_val(in_production_base_id int, in_destination_id int, in_date_time timestamp)

-- DROP FUNCTION destination_prod_base_driver_price_val(in_production_base_id int, in_destination_id int, in_date_time timestamp);

CREATE OR REPLACE FUNCTION destination_prod_base_driver_price_val(in_production_base_id int, in_destination_id int, in_date_time timestamp)
  RETURNS numeric(15, 2) AS
$$
	SELECT
		t.price
	FROM destination_prod_base_driver_prices AS t
	WHERE
		t.production_base_id = in_production_base_id
		AND t.destination_id = in_destination_id
		AND t.date_time <= in_date_time
	ORDER BY t.date_time DESC
	LIMIT 1;
$$
  LANGUAGE sql STABLE
  COST 100;
ALTER FUNCTION destination_prod_base_driver_price_val(in_production_base_id int, in_destination_id int, in_date_time timestamp) OWNER TO ;
