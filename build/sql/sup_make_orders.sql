-- FUNCTION: public.sup_make_orders()

-- DROP FUNCTION public.sup_make_orders();

CREATE OR REPLACE FUNCTION public.sup_make_orders(
	)
    RETURNS void
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
AS $BODY$
	DELETE FROM supplier_orders WHERE date=now()::date+'1 day'::interval;
	
	INSERT INTO supplier_orders
	(date,supplier_id,material_id,quant,vehicles)
	(
		SELECT
			pp.shift::date AS shift,
			pp.supplier_id,
			pp.material_id,
			greatest(pp.quant_to_order,0),
			greatest(pp.vehicles_to_order,0)
		FROM supplier_orders_list(
			--начало месяца
			date_trunc('month', current_date)::timestamp+const_first_shift_start_time_val(),
			--дата заказа - завтра конец смены
			get_shift_end(current_date::date+'1 day'::interval),
			--все материалы
			NULL
		) pp
		WHERE pp.shift::date=(current_date::date+'1 day'::interval)
	);
$BODY$;

ALTER FUNCTION public.sup_make_orders()
    OWNER TO ;

