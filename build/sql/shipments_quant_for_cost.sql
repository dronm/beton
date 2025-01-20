-- Function: shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric)

-- DROP FUNCTION shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric);

-- from december 2024 client specific values, not a fixed 10

CREATE OR REPLACE FUNCTION shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric, in_client_min_quant numeric)
  RETURNS numeric AS
$$
	with
	client_quant AS (
		select
			case
				when coalesce(in_client_min_quant, 0)=0 then 
					period_value('min_quant_for_ship_cost', 0, in_date)::numeric
				else in_client_min_quant
			end AS v
		)
	SELECT
		CASE 
			WHEN in_date >= '2025-01-01' THEN
				CASE
					WHEN in_quant >= (select v from client_quant) THEN in_quant
					WHEN in_distance<=60 THEN greatest((select v from client_quant), in_quant)
					ELSE (select v from client_quant)
				END
		
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
