-- FUNCTION: public.doc_material_movements_before_write(integer, integer)

-- DROP FUNCTION IF EXISTS public.doc_material_movements_before_write(integer, integer);

CREATE OR REPLACE FUNCTION public.doc_material_movements_before_write(
	in_login_id integer,
	in_doc_id integer)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN 

END;
$BODY$;


