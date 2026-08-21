-- FUNCTION: public.ra_fuel_flow_remove_acts(doc_types, integer)

-- DROP FUNCTION IF EXISTS public.ra_fuel_flow_remove_acts(doc_types, integer);

CREATE OR REPLACE FUNCTION public.ra_fuel_flow_remove_acts(
	in_doc_type doc_types,
	in_doc_id bigint)
    RETURNS void
    LANGUAGE 'sql'
    COST 100
    VOLATILE STRICT PARALLEL UNSAFE
AS $BODY$
	DELETE FROM ra_fuel_flow WHERE doc_type=in_doc_type AND doc_id=in_doc_id;
$BODY$;

