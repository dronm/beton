-- Function: quality_passports_object_or_last(in_shipment_id int)

-- DROP FUNCTION quality_passports_object_or_last(in_shipment_id int);

CREATE OR REPLACE FUNCTION quality_passports_object_or_last(in_shipment_id int)
  RETURNS quality_passports AS
$$
DECLARE
	v_quality_passport_id int;
BEGIN
	SELECT id INTO v_quality_passport_id FROM quality_passports WHERE shipment_id = in_shipment_id;
	
	IF v_quality_passport_id IS NOT NULL THEN
		-- passport exists
		RETURN
			(SELECT
				ROW(quality_passports.*)
			FROM quality_passports
			WHERE id = v_quality_passport_id
		);	
	ELSE
		--no passport - defaults
		RETURN
			(
			WITH
			-- f_val, w_val - from order
			-- prochnost - from concrete type
			ord_d AS (SELECT
					o.date_time::date AS vidan,
					coalesce(o.f_val, ctp.f_val) AS f_val,
					coalesce(o.w_val, ctp.w_val) AS w_val,
					ctp.prochnost,
					o.concrete_type_id
				FROM orders AS o
				LEFT JOIN concrete_types AS ctp ON ctp.id = o.concrete_type_id
				WHERE o.id = (SELECT sh.order_id FROM shipments AS sh WHERE sh.id = in_shipment_id)
			),
			--last passport with same concrete type
			last_qp AS (SELECT
					qp.*
				FROM quality_passports AS qp				
				LEFT JOIN shipments AS sh ON sh.id = qp.shipment_id
				LEFT JOIN orders AS o ON o.id = sh.order_id
				WHERE o.concrete_type_id = (SELECT concrete_type_id FROM ord_d)
				ORDER BY qp.vidan DESC
				LIMIT 1
			)	
			SELECT
				ROW(
					0,
					coalesce((SELECT f_val FROM ord_d) , 200),
					coalesce((SELECT w_val FROM ord_d) , 8),
					coalesce((SELECT vid_smesi_gost FROM last_qp), 'ГОСТ 7473-2010'),					
					coalesce((SELECT uklad FROM last_qp), 'П4 ( ОК 16-20 см.)'),
					coalesce((SELECT sohran_udobouklad FROM last_qp), '2 ч 00 мин'),
					coalesce((SELECT kf_prochnosti FROM last_qp), '11,5 (по схеме А)'),
					coalesce(coalesce((SELECT prochnost FROM ord_d), (SELECT prochnost FROM last_qp)), 30),
					coalesce((SELECT naim_dobavki FROM last_qp), 'Противоморозная Криопласт Экстра, 1%'),
					coalesce((SELECT aeff FROM last_qp), '1 Класс до 370 Бк/кг, Цемент - 86 Бк/кг, Песок-16,2 Бк/кг, Щебень - 28,8Бк/кг'),
					coalesce((SELECT krupnost::text FROM last_qp), '20'),
					(SELECT vidan FROM ord_d),
					in_shipment_id,
					coalesce(quality_passports_smes_num((SELECT concrete_type_id FROM ord_d), in_shipment_id), ''::text),
					0,
					0,
					coalesce((SELECT last_qp.reg_nomer_dekl::text FROM last_qp), ''::text),
					(SELECT concrete_type_id FROM ord_d)
				)
			);			
	END IF;
END
$$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION quality_passports_object_or_last(in_shipment_id int) OWNER TO ;
