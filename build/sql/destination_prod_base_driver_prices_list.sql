-- VIEW: destination_prod_base_driver_prices_list

--DROP VIEW destination_prod_base_driver_prices_list;

CREATE OR REPLACE VIEW destination_prod_base_driver_prices_list AS
	SELECT
		t.id
		,t.destination_id
		,t.production_base_id
		,production_bases_ref(production_bases_ref_t) AS production_bases_ref
		,t.date_time
		,t.price
		
	FROM destination_prod_base_driver_prices AS t
	LEFT JOIN production_bases AS production_bases_ref_t ON production_bases_ref_t.id = t.production_base_id
	ORDER BY production_bases_ref_t.name, t.date_time DESC
	;
	
ALTER VIEW destination_prod_base_driver_prices_list OWNER TO ;
