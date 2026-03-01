CREATE OR REPLACE FUNCTION rg_fuel_flow_balance(in_date_time timestamp,
	IN in_vehicle_id_ar int[]
	)
  RETURNS TABLE(
	vehicle_id int
	,
	quant int				
	) AS
$BODY$
	WITH
	cur_per AS (SELECT rg_period('fuel_flow'::reg_types, in_date_time) AS v ),
	act_forward AS (
		SELECT
			rg_period_balance('fuel_flow'::reg_types,in_date_time) - in_date_time >
			(SELECT t.v FROM cur_per t) - in_date_time
			AS v
	),
	act_sg AS (SELECT CASE WHEN t.v THEN 1 ELSE -1 END AS v FROM act_forward t)
	SELECT 
	sub.vehicle_id
	,SUM(sub.quant) AS quant				
	FROM(
		(SELECT
		b.vehicle_id
		,b.quant				
		FROM rg_fuel_flow AS b
		WHERE
		(
			--date bigger than last calc period
			(in_date_time > rg_period_balance('fuel_flow'::reg_types,rg_calc_period('fuel_flow'::reg_types)) AND b.date_time = (SELECT rg_current_balance_time()))
			OR (
			--forward from previous period
			( (SELECT t.v FROM act_forward t) AND b.date_time = (SELECT t.v FROM cur_per t)-rg_calc_interval('fuel_flow'::reg_types)
			)
			--backward from current
			OR			
			( NOT (SELECT t.v FROM act_forward t) AND b.date_time = (SELECT t.v FROM cur_per t)
			)
			)
		)	
		AND ( (in_vehicle_id_ar IS NULL OR ARRAY_LENGTH(in_vehicle_id_ar,1) IS NULL) OR (b.vehicle_id=ANY(in_vehicle_id_ar)))
		AND (
		b.quant<>0
		)
		)
		UNION ALL
		(SELECT
		act.vehicle_id
		,CASE act.deb
			WHEN TRUE THEN act.quant * (SELECT t.v FROM act_sg t)
			ELSE -act.quant * (SELECT t.v FROM act_sg t)
		END AS quant
		FROM doc_log
		LEFT JOIN ra_fuel_flow AS act ON act.doc_type=doc_log.doc_type AND act.doc_id=doc_log.doc_id
		WHERE
		(
			--forward from previous period
			( (SELECT t.v FROM act_forward t) AND
					act.date_time >= (SELECT t.v FROM cur_per t)
					AND act.date_time <= 
						(SELECT l.date_time FROM doc_log l
						WHERE date_trunc('second',l.date_time)<=date_trunc('second',in_date_time)
						ORDER BY l.date_time DESC LIMIT 1
						)
			)
			--backward from current
			OR			
			( NOT (SELECT t.v FROM act_forward t) AND
					act.date_time >= 
						(SELECT l.date_time FROM doc_log l
						WHERE date_trunc('second',l.date_time)>=date_trunc('second',in_date_time)
						ORDER BY l.date_time ASC LIMIT 1
						)			
					AND act.date_time <= (SELECT t.v FROM cur_per t)
			)
		)
		AND (in_vehicle_id_ar IS NULL OR ARRAY_LENGTH(in_vehicle_id_ar,1) IS NULL OR (act.vehicle_id=ANY(in_vehicle_id_ar)))
		AND (
		act.quant<>0
		)
		ORDER BY doc_log.date_time,doc_log.id)
	) AS sub
	WHERE
	 (ARRAY_LENGTH(in_vehicle_id_ar,1) IS NULL OR (sub.vehicle_id=ANY(in_vehicle_id_ar)))
	GROUP BY
		sub.vehicle_id
	HAVING
		SUM(sub.quant)<>0
	ORDER BY
		sub.vehicle_id;
$BODY$
  LANGUAGE sql VOLATILE CALLED ON NULL INPUT
  COST 100;

