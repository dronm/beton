-- Function: doc_material_procurements2_material_check(in_material_name text)

-- DROP FUNCTION doc_material_procurements2_material_check(in_material_name text);

CREATE OR REPLACE FUNCTION doc_material_procurements2_material_check(in_material_name text)
  RETURNS bool AS
$$
	SELECT (POSITION('цемент' in lower(in_material_name))=0 );
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
