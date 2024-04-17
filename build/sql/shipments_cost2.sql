-- FUNCTION: public.shipments_cost(destinations, integer, date, shipments, boolean)

-- DROP FUNCTION IF EXISTS public.shipments_cost(destinations, integer, date, shipments, boolean);

/*
 * Не использовать эту функцию!!!
 * Есть shipments_cost с учетом производственной зоны!!!
 */

CREATE OR REPLACE FUNCTION public.shipments_cost(
	in_destinations destinations,
	in_concrete_type_id integer,
	in_date date,
	in_shipments shipments,
	in_editable boolean)
    RETURNS numeric
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
	SELECT
		coalesce(
		(CASE
			WHEN in_editable AND coalesce(in_shipments.ship_cost_edit,FALSE) THEN in_shipments.ship_cost
			WHEN in_destinations.id=const_self_ship_dest_id_val() THEN 0
			WHEN in_concrete_type_id=12 THEN
				water_ship_cost_on_date(in_shipments.date_time)
				--const_water_ship_cost_val()
			ELSE
				CASE
					WHEN coalesce(in_destinations.special_price,FALSE) THEN coalesce(in_destinations.price,0)
					ELSE
					coalesce(
						(SELECT sh_p.price
						FROM shipment_for_owner_costs sh_p
						WHERE sh_p.date<=in_date AND sh_p.distance_to>=in_destinations.distance
						ORDER BY sh_p.date DESC,sh_p.distance_to ASC
						LIMIT 1
						),			
					coalesce(in_destinations.price,0))			
				END
				*
				shipments_quant_for_cost(in_date, in_shipments.quant::numeric, in_destinations.distance::numeric)
				/*
				CASE WHEN in_date < '2021-07-01' THEN
					CASE
						WHEN in_shipments.quant>=7 THEN in_shipments.quant
						WHEN in_destinations.distance<=60 THEN greatest(5,in_shipments.quant)
						ELSE 7
					END
				ELSE
					CASE
						WHEN in_shipments.quant>=7 THEN in_shipments.quant
						WHEN in_destinations.distance<=60 THEN 7
						ELSE 10
					END
				END
				*/	
		END)::numeric(15,2)
		,0)
	;
$BODY$;

ALTER FUNCTION public.shipments_cost(destinations, integer, date, shipments, boolean)
    OWNER TO beton;

