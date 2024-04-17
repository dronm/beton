-- Function: banks.banks_ref(banks.banks)

-- DROP FUNCTION banks.banks_ref(banks.banks);

CREATE OR REPLACE FUNCTION banks.banks_ref(banks.banks)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'bik',$1.bik   
			),	
		'descr',$1.bik||', '||$1.name||', '||$1.korshet,
		'dataType','banks'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION banks.banks_ref(banks.banks)
  OWNER TO ;

