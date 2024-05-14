-- Function: konkrid_ship_get_order(in_beton_order_date_time timestamp without time zone, in_beton_order_concrete_name text, in_beton_order_quant double precision)

-- DROP FUNCTION konkrid_ship_get_order(in_beton_order_date_time timestamp without time zone, in_beton_order_concrete_name text, in_beton_order_quant double precision);

-- actually this function id used for all events: konkrid && beton

CREATE OR REPLACE FUNCTION konkrid_ship_get_order(in_beton_order_date_time timestamp without time zone, in_beton_order_concrete_name text, in_beton_order_quant double precision)
  RETURNS int AS
$$
	SELECT
		kd_o.id
	FROM public.orders as kd_o
	WHERE
		kd_o.date_time = in_beton_order_date_time
		AND kd_o.concrete_type_id = 
			(SELECT
				ct.id
			FROM concrete_types as ct
			WHERE ct.name = in_beton_order_concrete_name
			LIMIT 1
			)
		AND kd_o.quant = in_beton_order_quant
	LIMIT 1;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION konkrid_ship_get_order(in_beton_order_date_time timestamp without time zone, in_beton_order_concrete_name text, in_beton_order_quant double precision) OWNER TO ;
