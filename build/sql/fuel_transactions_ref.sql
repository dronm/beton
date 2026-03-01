-- Function: public.fuel_transactions_ref(fuel_transactions)

-- DROP FUNCTION public.fuel_transactions_ref(fuel_transactions);

CREATE OR REPLACE FUNCTION public.fuel_transactions_ref(fuel_transactions)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
		),	
		'descr','Транзакция по топливной карте №' ||$1.transaction_id::text||' от ' || to_char($1.date_time, 'DD/MM/YY'),
		'dataType','fuel_transactions'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;



