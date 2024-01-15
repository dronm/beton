-- Function: owner_price_list(in_client_id int, in_date timestamp)

-- DROP FUNCTION owner_price_list(in_client_id int, in_date timestamp);

CREATE OR REPLACE FUNCTION owner_price_list(in_client_id int, in_date timestamp)
  RETURNS TABLE(
  	concrete_type_id int,
  	price numeric(15,2)
  ) AS
$$
	SELECT
		t.concrete_type_id,
		t.price
	FROM concrete_costs_for_owner AS t
	WHERE t.header_id = (
		SELECT
			h.concrete_costs_for_owner_h_id
		FROM vehicle_owner_concrete_prices AS h
		WHERE in_client_id = h.client_id AND h.date<=in_date
		ORDER BY h.date DESC
		LIMIT 1
	)
	;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION owner_price_list(in_client_id int, in_date timestamp) OWNER TO ;
