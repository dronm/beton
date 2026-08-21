-- FUNCTION: public.ra_fuel_flow_add_act(ra_fuel_flow)

-- DROP FUNCTION public.ra_fuel_flow_add_act(ra_fuel_flow);

CREATE OR REPLACE FUNCTION public.ra_fuel_flow_add_act(
	reg_act ra_fuel_flow)
    RETURNS void
    LANGUAGE 'sql'

    COST 100
    VOLATILE STRICT 
AS $BODY$
	INSERT INTO ra_fuel_flow
		(date_time,doc_type,doc_id
		,deb
		,vehicle_id
		,quant				
		)
		VALUES (
		$1.date_time,$1.doc_type,$1.doc_id
		,$1.deb
		,$1.vehicle_id
		,$1.quant				
		);
$BODY$;
