-- Function: additive_mat_exists(in_shipment_id int)

-- DROP FUNCTION additive_mat_exists(in_shipment_id int);

CREATE OR REPLACE FUNCTION additive_mat_exists(in_shipment_id int)
  RETURNS bool AS
$$
	SELECT
		TRUE
	FROM productions AS p
	LEFT JOIN material_fact_consumptions AS cons ON cons.production_site_id = p.production_site_id AND cons.production_id = p.production_id
	LEFT JOIN raw_materials AS m ON m.id = cons.raw_material_id
	WHERE p.shipment_id=in_shipment_id AND m.name ilike '%добавка%' AND cons.material_quant >0
	LIMIT 1;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION additive_mat_exists(in_shipment_id int) OWNER TO ;
