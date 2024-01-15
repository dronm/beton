-- FUNCTION: public.ra_materials_add_act(ra_materials)

-- DROP FUNCTION public.ra_materials_add_act(ra_materials);

CREATE OR REPLACE FUNCTION public.ra_materials_add_act(
	reg_act ra_materials)
    RETURNS void
    LANGUAGE 'sql'

    COST 100
    VOLATILE STRICT 
AS $BODY$
INSERT INTO ra_materials
	(date_time,doc_type,doc_id
	,deb
	,production_base_id
	,material_id
	,quant				
	)
	VALUES (
	reg_act.date_time,reg_act.doc_type,reg_act.doc_id
	,reg_act.deb
	,reg_act.production_base_id
	,reg_act.material_id
	,reg_act.quant				
	);
$BODY$;

ALTER FUNCTION public.ra_materials_add_act(ra_materials)
    OWNER TO ;

