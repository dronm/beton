/*
Function: material_fact_consumptions_find_vehicle(
	in_production_site_id int,
	in_production_vehicle_descr text,
	in_production_dt_start timestamp,
	in_production_concrete_type_id int,
	in_production_concrete_quant numeric(19,4)
)
*/

/*
DROP FUNCTION material_fact_consumptions_find_vehicle(
	in_production_site_id int,
	in_production_vehicle_descr text,
	in_production_dt_start timestamp,
	in_production_concrete_type_id int,
	in_production_concrete_quant numeric(19,4)
 );
*/

CREATE OR REPLACE FUNCTION material_fact_consumptions_find_vehicle(
	in_production_site_id int,
	in_production_vehicle_descr text,
	in_production_dt_start timestamp,
	in_production_concrete_type_id int,
	in_production_concrete_quant numeric(19,4)
)
  RETURNS record AS
$$
	-- пытаемся определить авто по описанию элкон
	-- выбираем из production_descr только числа
	-- находим авто с маской %in_production_descr% и назначенное в диапазоне получаса

	SELECT
		vsch.vehicle_id AS vehicle_id,
		vschs.id AS vehicle_schedule_state_id,
		sh.id AS shipment_id
	FROM shipments AS sh
	LEFT JOIN vehicle_schedule_states AS vschs ON vschs.schedule_id = sh.vehicle_schedule_id AND vschs.state='assigned' AND vschs.shipment_id=sh.id
	LEFT JOIN vehicle_schedules AS vsch ON vsch.id = sh.vehicle_schedule_id
	LEFT JOIN vehicles AS vh ON vh.id=vsch.vehicle_id
	LEFT JOIN orders AS o ON o.id=sh.order_id
	
	WHERE
		sh.date_time BETWEEN in_production_dt_start-'240 minutes'::interval AND in_production_dt_start+'240 minutes'::interval
		AND vh.plate LIKE '%'||regexp_replace(in_production_vehicle_descr, '\D','','g')||'%'
		AND sh.production_site_id = in_production_site_id
		
		/*AND sh.quant-coalesce(
			(SELECT sum(t.concrete_quant)
			FROM productions t
			WHERE t.shipment_id=sh.id
			)
		,0)>0
		*/
	ORDER BY
		(o.concrete_type_id=in_production_concrete_type_id AND sh.quant::numeric(19,4)=in_production_concrete_quant) DESC
		-- the nearest shipment
		,CASE
			WHEN in_production_dt_start>sh.date_time THEN in_production_dt_start - sh.date_time
			ELSE sh.date_time-in_production_dt_start
		END
	LIMIT 1;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION material_fact_consumptions_find_vehicle(
	in_production_site_id int,
	in_production_vehicle_descr text,
	in_production_dt_start timestamp,
	in_production_concrete_type_id int,
	in_production_concrete_quant numeric(19,4)
) OWNER TO ;

