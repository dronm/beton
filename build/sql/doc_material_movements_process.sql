--process function
CREATE OR REPLACE FUNCTION public.doc_material_movements_process()
  RETURNS trigger AS
$BODY$
DECLARE
	reg_act ra_materials%ROWTYPE;
	reg_material_facts ra_material_facts%ROWTYPE;
BEGIN
	IF (TG_WHEN='BEFORE' AND TG_OP='INSERT') THEN
		SELECT coalesce(MAX(d.number::int),0)+1 INTO NEW.number FROM public.doc_material_movements AS d;

		RETURN NEW;

	ELSIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		IF NEW.date_time<>OLD.date_time THEN
			PERFORM doc_log_update('material_movement'::doc_types,NEW.id,NEW.date_time);
		END IF;

		PERFORM ra_materials_remove_acts('material_movement'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('material_movement'::doc_types,OLD.id);

		RETURN NEW;

	ELSIF (TG_WHEN='AFTER') AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN					
		IF (TG_OP='INSERT') THEN						
			--log
			PERFORM doc_log_insert('material_movement'::doc_types,NEW.id,NEW.date_time);
		END IF;

		--kredit
		reg_act.date_time				= NEW.date_time;
		reg_act.deb						= false;
		reg_act.doc_type				= 'material_movement'::doc_types;
		reg_act.doc_id					= NEW.id;
		reg_act.production_base_id		= NEW.production_base_from_id;
		reg_act.material_id				= NEW.material_id;
		reg_act.quant					= NEW.quant;
		PERFORM ra_materials_add_act(reg_act);	
--raise exception 'id=%', NEW.id;
		reg_material_facts.date_time			= NEW.date_time;
		reg_material_facts.deb					= false;
		reg_material_facts.doc_type				= 'material_movement'::doc_types;
		reg_material_facts.doc_id				= NEW.id;
		reg_material_facts.material_id			= NEW.material_id;
		reg_material_facts.production_base_id	= NEW.production_base_from_id;
		reg_material_facts.quant				= NEW.quant;
		PERFORM ra_material_facts_add_act(reg_material_facts);	

		-- debet
		reg_act.date_time				= NEW.date_time;
		reg_act.deb						= true;
		reg_act.doc_type				= 'material_movement'::doc_types;
		reg_act.doc_id					= NEW.id;
		reg_act.production_base_id		= NEW.production_base_to_id;
		reg_act.material_id				= NEW.material_id;
		reg_act.quant					= NEW.quant;
		PERFORM ra_materials_add_act(reg_act);	

		reg_material_facts.date_time			= NEW.date_time;
		reg_material_facts.deb					= true;
		reg_material_facts.doc_type				= 'material_movement'::doc_types;
		reg_material_facts.doc_id				= NEW.id;
		reg_material_facts.material_id			= NEW.material_id;
		reg_material_facts.production_base_id	= NEW.production_base_to_id;
		reg_material_facts.quant				= NEW.quant;
		PERFORM ra_material_facts_add_act(reg_material_facts);	

		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',NOW()::date
				)
			)::text
		);

		RETURN NEW;

	ELSIF (TG_WHEN='BEFORE' AND TG_OP='DELETE') THEN
		--detail tables
		--log
		PERFORM doc_log_delete('material_movement'::doc_types,OLD.id);
		PERFORM ra_materials_remove_acts('material_movement'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('material_movement'::doc_types,OLD.id);

		RETURN OLD;

	ELSIF (TG_WHEN='AFTER' AND TG_OP='DELETE') THEN
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',NOW()::date
				)
			)::text
		);

		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE COST 100;

