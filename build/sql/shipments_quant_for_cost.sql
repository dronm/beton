-- Function: shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric)

-- DROP FUNCTION shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric);

CREATE OR REPLACE FUNCTION shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric)
  RETURNS numeric AS
$$
	SELECT
		CASE 
			WHEN in_date >= '2023-07-10' THEN
				CASE
					WHEN in_quant>=10 THEN in_quant
					WHEN in_distance<=60 THEN greatest(10, in_quant)
					ELSE 10
				END
			WHEN in_date >= '2021-07-01' THEN
				CASE
					WHEN in_quant>=10 THEN in_quant
					WHEN in_distance<=60 THEN greatest(7, in_quant)
					ELSE 10
				END
			ELSE
				CASE
					WHEN in_quant>=7 THEN in_quant
					WHEN in_distance<=60 THEN greatest(5, in_quant)
					ELSE 7
				END
		END
	;
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric) OWNER TO ;
