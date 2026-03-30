begin;

DROP VIEW IF EXISTS lab_entry_list;
DROP VIEW IF EXISTS material_fact_consumptions_rolled_list;
DROP VIEW IF EXISTS material_fact_consumptions_list;
DROP VIEW IF EXISTS material_cons_tolerance_violation_list;
DROP VIEW IF EXISTS production_material_list;
DROP VIEW IF EXISTS production_material_list2;

ALTER TABLE material_fact_consumptions
	ALTER COLUMN material_quant TYPE numeric(19,5),
	ALTER COLUMN material_quant_req TYPE numeric(19,5);

commit;
