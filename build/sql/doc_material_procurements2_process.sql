-- FUNCTION: public.doc_material_procurements2_process()

-- DROP FUNCTION public.doc_material_procurements2_process();

CREATE OR REPLACE FUNCTION public.doc_material_procurements2_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
	
		IF (NEW.quant_gross>0 OR NEW.quant_net>0)
		AND doc_material_procurements2_material_check(NEW.material_name)
		AND NEW.date_time::date>='2021-06-24' THEN					

			INSERT INTO doc_material_procurements
				(date_time,
				user_id,
				supplier_id,
				carrier_id,
				driver,
				vehicle_plate,
				material_id,
				quant_gross,
				quant_net,
				doc_ref,
				doc_quant_gross,
				doc_quant_net,
				doc_ref_gornyi,
				store,
				production_base_id)
			SELECT
				NEW.date_time,
				NEW.user_id,
				NEW.supplier_id,
				NEW.carrier_id,
				NEW.driver,
				NEW.vehicle_plate,
				NEW.material_id,
				NEW.quant_gross/1000,
				NEW.quant_net/1000,
				NULL,
				NEW.doc_quant_gross/1000,
				NEW.doc_quant_net/1000,
				NEW.doc_ref,
				'БАЗА',
				1 --Утяшево
				;
		END IF;
						
		RETURN NEW;

	ELSIF TG_WHEN='AFTER' AND TG_OP='UPDATE' THEN	
					
		IF NEW.date_time::date>='2021-06-24' AND doc_material_procurements2_material_check(NEW.material_name) THEN
			IF NEW.quant_gross=0 AND NEW.quant_net=0 THEN
				DELETE FROM doc_material_procurements WHERE doc_ref_gornyi = NEW.doc_ref;
			ELSE
				INSERT INTO doc_material_procurements
					(date_time,
					user_id,
					supplier_id,
					carrier_id,
					driver,
					vehicle_plate,
					material_id,
					quant_gross,
					quant_net,
					doc_ref,
					doc_quant_gross,
					doc_quant_net,
					doc_ref_gornyi,
					store,
					production_base_id)
				SELECT
					NEW.date_time,
					NEW.user_id,
					NEW.supplier_id,
					NEW.carrier_id,
					NEW.driver,
					NEW.vehicle_plate,
					NEW.material_id,
					NEW.quant_gross/1000,
					NEW.quant_net/1000,
					NULL,
					NEW.doc_quant_gross/1000,
					NEW.doc_quant_net/1000,
					NEW.doc_ref,
					'БАЗА',
					1 --Утяшево
				ON CONFLICT (doc_ref_gornyi) DO UPDATE SET
					--UPDATE doc_material_procurements
					--SET
						date_time = NEW.date_time,
						user_id = NEW.user_id,
						supplier_id = NEW.supplier_id,
						carrier_id = NEW.carrier_id,
						driver = NEW.driver,
						vehicle_plate = NEW.vehicle_plate,
						material_id = NEW.material_id,
						quant_gross = NEW.quant_gross/1000,
						quant_net = NEW.quant_net/1000,
						doc_quant_gross = NEW.doc_quant_gross/1000,
						doc_quant_net = NEW.doc_quant_net/1000,
						doc_ref = NEW.doc_ref_1c,
						number = NEW.number
					--WHERE doc_ref_gornyi = NEW.doc_ref;			
					;
			END IF;
		END IF;
						
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='DELETE' THEN
	
		IF OLD.date_time::date>='2021-06-24' AND doc_material_procurements2_material_check(OLD.material_name) THEN
			DELETE FROM doc_material_procurements WHERE doc_ref_gornyi = OLD.doc_ref;
		END IF;	
	
		RETURN OLD;
	END IF;
END;
$BODY$;

ALTER FUNCTION public.doc_material_procurements2_process()
    OWNER TO beton;

