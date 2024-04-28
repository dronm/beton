-- Function: public.doc_material_procurements_process()

-- DROP FUNCTION public.doc_material_procurements_process();

CREATE OR REPLACE FUNCTION public.doc_material_procurements_process()
  RETURNS trigger AS
$BODY$
DECLARE
	reg_act ra_materials%ROWTYPE;
	reg_material_facts ra_material_facts%ROWTYPE;
	reg_cement ra_cement%ROWTYPE;
	v_dif_store bool;
	v_production_site_id int;
BEGIN
	IF (TG_WHEN='BEFORE' AND TG_OP='INSERT') THEN
		IF NEW.date_time < '2024-01-01T00:00:00'::timestamp THEN
			RAISE EXCEPTION 'Дата запрета редактирования: %', '2024-01-01T00:00:00'::timestamp;
		END IF;
		
		-- Временно ОТ ВЕСОВ!!!
		IF NEW.production_base_id IS NULL THEN
			NEW.production_base_id = 1;
		END IF;	
		
		--Обнудение материал = БЕТОН
		IF NEW.material_id = 1240 THEN
			NEW.quant_net = 0;
			NEW.quant_gross = 0;
		END IF;
		
		--Если это из горного - обнулить по документам
		IF coalesce(NEW.doc_ref_gornyi, '') <> ''
		THEN
			NEW.doc_quant_gross = 0;
			NEW.doc_quant_net = 0;
		END IF;
		
		RETURN NEW;
		
	ELSIF (TG_WHEN='AFTER') AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN					
		IF (TG_OP='INSERT') THEN						
			--log
			PERFORM doc_log_insert('material_procurement'::doc_types,NEW.id,NEW.date_time);
		END IF;

		--register actions ra_materials
		reg_act.date_time		= NEW.date_time;
		reg_act.deb			= true;
		reg_act.doc_type  		= 'material_procurement'::doc_types;
		reg_act.doc_id  		= NEW.id;
		reg_act.production_base_id	= NEW.production_base_id;
		reg_act.material_id		= NEW.material_id;
		reg_act.quant			= NEW.quant_net;
		PERFORM ra_materials_add_act(reg_act);	
		
		SELECT dif_store INTO v_dif_store FROM raw_materials WHERE id=NEW.material_id;
		--По материалам делаем всегда движения, а если есть учет по силосам и есть силос - то и по силосам
		--Если учет по заводам (v_dif_store==TRUE)- то по заводам
		--register actions ra_material_facts
		reg_material_facts.date_time		= NEW.date_time;
		reg_material_facts.deb			= true;
		reg_material_facts.doc_type  		= 'material_procurement'::doc_types;
		reg_material_facts.doc_id  		= NEW.id;
		reg_material_facts.material_id		= NEW.material_id;
		reg_material_facts.production_base_id	= NEW.production_base_id;
		
		IF coalesce(v_dif_store,FALSE) AND coalesce(NEW.store,'')<>'' THEN
			--Определить завод по приходу
			SELECT production_site_id INTO v_production_site_id FROM store_map_to_production_sites WHERE store = NEW.store;
			--RAISE EXCEPTION 'v_production_site_id=%',v_production_site_id;
			IF v_production_site_id IS NULL THEN
				-- no match!
				INSERT INTO store_map_to_production_sites (store) VALUES (NEW.store);
			END IF;
			reg_material_facts.production_site_id = v_production_site_id;
		END IF;
		reg_material_facts.quant		= NEW.quant_net;
		PERFORM ra_material_facts_add_act(reg_material_facts);	
		
		IF coalesce( (SELECT is_cement FROM raw_materials WHERE id = NEW.material_id),FALSE)
		AND NEW.cement_silos_id IS NOT NULL THEN
			--register actions ra_cement
			reg_cement.date_time		= NEW.date_time;
			reg_cement.deb			= true;
			reg_cement.doc_type  		= 'material_procurement'::doc_types;
			reg_cement.doc_id  		= NEW.id;
			reg_cement.cement_silos_id	= NEW.cement_silos_id;
			reg_cement.quant		= NEW.quant_net;
			PERFORM ra_cement_add_act(reg_cement);	
			
		END IF;
			
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',NEW.date_time::date
				)
			)::text
		);
				
		RETURN NEW;
		
	ELSIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		IF NEW.date_time < '2024-01-01T00:00:00'::timestamp THEN
			RAISE EXCEPTION 'Дата запрета редактирования: %', '2024-01-01T00:00:00'::timestamp;
		END IF;
	
		-- Временно ОТ ВЕСОВ!!!
		IF NEW.production_base_id IS NULL THEN
			NEW.production_base_id = 1;
		END IF;	
	
		PERFORM ra_materials_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_cement_remove_acts('material_procurement'::doc_types,OLD.id);

		--Если это из горного - обнулить по документам
		IF coalesce(NEW.doc_ref_gornyi, '') <> ''
		AND (coalesce(NEW.doc_quant_gross,0)<>0 OR coalesce(NEW.doc_quant_net,0)<>0)
		THEN
			NEW.doc_quant_gross = 0;
			NEW.doc_quant_net = 0;
		END IF;


		IF NEW.date_time<>OLD.date_time THEN
			PERFORM doc_log_update('material_procurement'::doc_types,NEW.id,NEW.date_time);
		END IF;
						
		RETURN NEW;
		
	ELSIF (TG_WHEN='AFTER' AND TG_OP='DELETE') THEN
	
		--Event support
		PERFORM pg_notify(
				'RAMaterialFact.change'
			,json_build_object(
				'params',json_build_object(
					'cond_date',OLD.date_time::date
				)
			)::text
		);
	
		RETURN OLD;
	ELSIF (TG_WHEN='BEFORE' AND TG_OP='DELETE') THEN
		IF OLD.date_time < '2024-01-01T00:00:00'::timestamp THEN
			RAISE EXCEPTION 'Дата запрета редактирования: %', '2024-01-01T00:00:00'::timestamp;
		END IF;
	
		--detail tables
		
		--register actions										
		PERFORM ra_materials_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_material_facts_remove_acts('material_procurement'::doc_types,OLD.id);
		PERFORM ra_cement_remove_acts('material_procurement'::doc_types,OLD.id);
		
		--log
		PERFORM doc_log_delete('material_procurement'::doc_types,OLD.id);
		
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.doc_material_procurements_process()
  OWNER TO ;

