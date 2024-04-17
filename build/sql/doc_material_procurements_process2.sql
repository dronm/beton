-- Function: public.doc_material_procurements_process2()

-- DROP FUNCTION public.doc_material_procurements_process2();

/**
 * Таблица принимает данные от горного, триггер переносит в рабочую таблицу
 *
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
		store)
	SELECT
		date_time,
		user_id,
		supplier_id,
		carrier_id,
		driver,
		vehicle_plate,
		material_id,
		quant_gross/1000,
		quant_net/1000,
		NULL,
		doc_quant_gross/1000,
		doc_quant_net/1000,
		doc_ref,
		'БАЗА'
		
	FROM public.doc_material_procurements2
	where (quant_gross>0 OR quant_net>0)
	AND doc_material_procurements2_material_check(material_name)
	AND date_time::date=now()::date
	ORDER BY date_time DESC 
 
 */

CREATE OR REPLACE FUNCTION public.doc_material_procurements2_process()
  RETURNS trigger AS
$BODY$
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
				store)
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
				'БАЗА';
		END IF;
						
		RETURN NEW;

	ELSIF TG_WHEN='AFTER' AND TG_OP='UPDATE' THEN	
					
		IF NEW.date_time::date>='2021-06-24' AND doc_material_procurements2_material_check(NEW.material_name) THEN
			IF NEW.quant_gross=0 AND NEW.quant_net=0 THEN
				DELETE FROM doc_material_procurements WHERE doc_ref_gornyi = NEW.doc_ref;
			ELSE
				UPDATE doc_material_procurements
				SET
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
					
				WHERE doc_ref_gornyi = NEW.doc_ref;			
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.doc_material_procurements2_process()
  OWNER TO beton;

