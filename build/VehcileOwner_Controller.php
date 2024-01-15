	public function get_tot_income_report($pm){
		$vown_id = 0;
		if($_SESSION['role_id']=='vehicle_owner'){
			$vown_id = intval($_SESSION['global_vehicle_owner_id']);
		}else{
			$vown_id = $pm->getParamValue('vehicle_owner_id');
		}
		
		//period
		$dt = (!$pm->getParamValue('date_from'))? MyDate::StartMonth(time()) : $this->getExtVal($pm, 'date_from');
		$dt+= Beton::shiftStartTime();
		$date_from = Beton::shiftStart($dt);
		
		$dt = $this->getExtVal($pm, 'date_to');
		$date_to = Beton::shiftEnd(MyDate::EndMonth($dt) - 24*60*60 + Beton::shiftStartTime());
		
		$ar = $this->getDbLink()->query_first(sprintf(
			"SELECT		
				period
			FROM vehicle_tot_rep_balances
			WHERE vehicle_owner_id = %d
			ORDER BY period ASC
			LIMIT 1"
			,$vown_id		
		));
		if(!is_array($ar) ||!count($ar) || !isset($ar['period'])){
			throw new Exception("Не задан начальный остаток взаиморасчетов по владельцу!");
		}
		$period = strtotime($ar['period']);
		if($period > $date_from){
			
			throw new Exception(sprintf("Отчет может быть сформирован не раньше, чем с %s %s", MyDate::getRusMonth(date('n', $period)), date('Y', $period)));
		}
		
		$date_from_db = "'".date('Y-m-d H:i:s', $date_from)."'";
		$date_to_db = "'".date('Y-m-d H:i:s', $date_to)."'";
		
		$q = sprintf(
			"WITH
			params AS (
				SELECT
					%d AS owner_id,
					%s AS date_from,
					%s AS date_to,
			),
			veh_owners AS (
				SELECT
					sub.id,
					sub.plate,
					((sub.owner_data->>'dt_from')::timestampTZ)::date AS period,
					(sub.owner_data->'owner'->'keys'->>'id')::int As owner_id
				FROM
					(SELECT
						v.id,
						v.plate,
						jsonb_array_elements(v.vehicle_owners->'rows')->'fields' AS owner_data
					FROM vehicles AS v
					WHERE (SELECT owner_id FROM params)=ANY(v.vehicle_owners_ar)
					) AS sub
				ORDER BY
					sub.plate,
					((sub.owner_data->>'dt_from')::timestampTZ)::date
			),
			bal AS (SELECT coalesce(
					(SELECT
						value
					FROM vehicle_tot_rep_balances
					WHERE vehicle_owner_id = (SELECT owner_id FROM params) AND period <= (SELECT date_from::date FROM params)
					ORDER BY period DESC
					LIMIT 1
					),	
				0) AS v		
			)
			SELECT
				s.period,
				s.id AS veh_id,
				s.plate AS veh_plate,
				s.period_fact,
				(SELECT v FROM bal) AS balance_beg,
				
				it.id AS item_id,
				it.name AS item_name,
				it.query IS NULL AS item_input,
				it.is_income AS item_income,
				it.is_info AS item_info,
				
				-- значение статьи: ручное или авто
				CASE
					WHEN it.query IS NOT NULL THEN
						vehicle_tot_rep_item_exec_query(
								it.query,
								s.id,
								s.period_fact,
								get_shift_end(last_month_day(s.period) + const_first_shift_start_time_val())
						)
					ELSE coalesce(it_vals.value, 0.00)
				END AS val,
				
				--рейсы всего
				(SELECT
					count(*)
				FROM shipments AS sh
				JOIN vehicle_schedules AS vsch ON vsch.id = sh.vehicle_schedule_id
				WHERE vsch.vehicle_id = s.id
					AND sh.shipped
					AND sh.ship_date_time BETWEEN s.period_fact + const_first_shift_start_time_val() AND get_shift_end(s.period_fact + const_first_shift_start_time_val())				
				) AS runs,
				
				-- рейсы самовывоз
				(SELECT
					count(*)
				FROM shipments AS sh
				JOIN vehicle_schedules AS vsch ON vsch.id = sh.vehicle_schedule_id
				JOIN orders AS o ON o.id = sh.order_id
				WHERE vsch.vehicle_id = s.id
					AND sh.shipped
					AND sh.ship_date_time BETWEEN s.period_fact + const_first_shift_start_time_val() AND get_shift_end(s.period_fact + const_first_shift_start_time_val())				
					AND o.destination_id = const_self_ship_dest_id_val()
				) AS self_runs,

				-- общий объём
				coalesce((SELECT
					sum(sh.quant)
				FROM shipments AS sh
				JOIN vehicle_schedules AS vsch ON vsch.id = sh.vehicle_schedule_id
				WHERE vsch.vehicle_id = s.id
					AND sh.shipped
					AND sh.ship_date_time BETWEEN s.period_fact + const_first_shift_start_time_val() AND get_shift_end(s.period_fact + const_first_shift_start_time_val())				
				),0) AS quant,
				
				-- средний объём
				coalesce((SELECT
					round(sum(sh.quant) / count(*))
				FROM shipments AS sh
				JOIN vehicle_schedules AS vsch ON vsch.id = sh.vehicle_schedule_id
				WHERE vsch.vehicle_id = s.id
					AND sh.shipped
					AND sh.ship_date_time BETWEEN s.period_fact + const_first_shift_start_time_val() AND get_shift_end(s.period_fact + const_first_shift_start_time_val())				
				),0) AS avg_quant,
				
				(SELECT
					count(*)
				FROM vehicle_schedules AS t
				WHERE t.vehicle_id = s.id
					AND t.schedule_date BETWEEN s.period_fact AND last_month_day(s.period_fact)
				) AS work_day_count,
				
				0 AS avg_runs
			FROM (
				SELECT
					d::date AS period,
					vh.id,
					vh.plate,
					(SELECT
						s.d
					FROM (
						SELECT
							veh_owners.owner_id,
							greatest(veh_owners.period,d::date) AS d
						FROM veh_owners
						WHERE veh_owners.id=vh.id AND veh_owners.period < d::date+'1 month'::interval
						ORDER BY veh_owners.period DESC
						LIMIT 1
					) AS s
					WHERE s.owner_id = (SELECT owner_id FROM params)
					) AS period_fact
					
				FROM generate_series(
					(SELECT date_from FROM params),
					(SELECT date_to FROM params),
					'1 month'::interval
				) AS d
				CROSS JOIN (
					SELECT DISTINCT id, plate
					FROM veh_owners
				) AS vh
			) AS s
			CROSS JOIN (
				SELECT
					vt.id,
					vt.code,
					vt.name,
					coalesce(vt.is_income, FALSE) AS is_income,
					coalesce(vt.info, FALSE) AS is_info,
					vt.query
				FROM vehicle_tot_rep_items AS vt
				ORDER BY
					coalesce(vt.is_income, FALSE) DESC,
					vt.code
			) AS it
			LEFT JOIN vehicle_tot_rep_item_vals AS it_vals ON
				it_vals.vehicle_tot_rep_item_id = it.id
				AND it_vals.vehicle_id = s.id
				AND it_vals.period = s.period
			WHERE s.period_fact IS NOT NULL"
		,$vown_id
		,$date_from_db
		,$date_to_db
		);
		
		$this->addNewModel($q, 'VehicleOwnerTotIncomeReport_Model');
		
		/*
		 * ОБЩИЕ СТАТЬИ 
		 *
		 * Объединяем результаты двух запросов:
		 * 	- Статьи без query - просто берем ручные значения, если есть
		 * 	- Статьи с query - здесь берем все периоды + все статьи + результаты запросов query + ручные значения.
		 * 		ручные значения в приоритете - если есть, то они, иначе результат запроса query
		 */
		$this->addNewModel(sprintf(
				"(SELECT
					it.id AS item_id,
					it.name AS item_name,
					coalesce(it.is_income, FALSE) AS is_income ,
					coalesce(vals.value, 0.00) AS value ,
					vals.period
				FROM vehicle_tot_rep_common_item_vals AS vals
				LEFT JOIN vehicle_tot_rep_common_items AS it ON it.id = vals.vehicle_tot_rep_common_item_id
				WHERE vals.vehicle_owner_id = %d
					AND vals.period BETWEEN %s AND %s
					AND coalesce(it.query, '') = ''
				ORDER BY it.is_income, it.code)

				UNION ALL

				(SELECT
					it.id,
					it.name AS item_name,
					coalesce(it.is_income, FALSE) AS is_income,	
					coalesce(
						vals.value,
						vehicle_tot_rep_common_item_exec_query(
								it.query,
								%d,
								d,
								get_shift_end(d+'1 month'::interval-'1 day'::interval)									
						)
					) AS value,
					d::date AS period
					
				FROM generate_series(
					%s::timestamp,
					%s::timestamp,
					'1 month'::interval
				) AS d
				CROSS JOIN (
					SELECT
						it.id,
						it.is_income,
						it.code,
						it.query,
						it.name
					FROM vehicle_tot_rep_common_items AS it
					WHERE coalesce(it.query, '') &lt;&gt; ''
				) AS it
				LEFT JOIN vehicle_tot_rep_common_item_vals AS vals ON
					vals.vehicle_tot_rep_common_item_id = it.id
					AND vals.period = d::date
					AND vals.vehicle_owner_id = %d
				ORDER BY d, it.is_income, it.code)"
			,$vown_id
			,$date_from_db
			,$date_to_db
				
			,$vown_id
			,$date_from_db
			,$date_to_db
			
			,$vown_id
		),'VehicleTotRepCommonItemValList_Model');

		$this->addNewModel(
				"SELECT *
				FROM vehicle_tot_rep_common_items_list AS it
				ORDER BY it.is_income, it.code"
			,'VehicleTotRepCommonItemList_Model'		
		);

	}

