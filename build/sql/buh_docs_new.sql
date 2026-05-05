

--DROP FUNCTION public.buh_docs_new(in_orders int[], in_shipments int[]);

CREATE OR REPLACE FUNCTION public.buh_docs_new(in_orders int[], in_shipments int[])
  RETURNS buh_docs AS
$BODY$

	-- I have to implement this plpgsql function.
/*
need to return record of this row type:
                                   "public.buh_docs"
*/
	-- need to select all distinct shipments, sum up all its data
	-- if order is in in_orders array need to take all shipments of an order,
	-- if shipment is in in_shipments array, need to include it,
	-- clients have to be the same, if not raise exception
	-- contracts have to be the same, but if there are multiple contracts - just take the firsr one,
	-- no exception this time.

	SELECT 
		cl.ref_1c,
		ct.ref_1c AS item_ref_1c,
		o.quant
		--need to sumup all shipments demurrage (interval), demurrage_cost, cost, pump_cost

	FROM orders
	LEFT JOIN clients AS cl ON cl.id = o.client_id
	LEFT JOIN concrete_types AS ct ON ct.id = o.concrete_type_id
	LEFT JOIN destinations AS dst ON dst.id = o.destination_id
	WHERE id = ANY(in_orders)

	SELECT 
		cl.ref_1c
		ct.ref_1c AS item_ref_1c,
		sh.quant,
		sh.cost,
		sh.demurrage,
		sh.demurrage_cost,
		sh.pump_cost
	FROM shipments_list AS sh
	LEFT JOIN orders AS o ON o.id = sh.order_id
	LEFT JOIN clients AS cl ON cl.id = o.client_id
	LEFT JOIN concrete_types AS ct ON ct.id = o.concrete_type_id
	LEFT JOIN destinations AS dst ON dst.id = o.destination_id
	WHERE id = ANY(in_shipments)

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

