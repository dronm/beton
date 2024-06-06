<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'VehicleOwner'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>

require_once('common/MyDate.php');
require_once(ABSOLUTE_PATH.'functions/Beton.php');

class <xsl:value-of select="@id"/>_Controller extends <xsl:value-of select="@parentId"/>{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);<xsl:apply-templates/>
	}	
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">

	public function get_tot_report($pm){
		$vown_id = 0;
		if($_SESSION['role_id']=='vehicle_owner'){
			$vown_id = intval($_SESSION['global_vehicle_owner_id']);
		}else{
			$vown_id = $pm->getParamValue('vehicle_owner_id');
		}
		
		$dt = (!$pm->getParamValue('date'))? MyDate::StartMonth(time()) : $this->getExtVal($pm,'date');
		$dt+= Beton::shiftStartTime();
		$date_from = Beton::shiftStart($dt);
		$date_to = Beton::shiftEnd(MyDate::EndMonth($dt)-24*60*60+Beton::shiftStartTime());
		$date_from_db = "'".date('Y-m-d H:i:s',$date_from)."'";
		$date_to_db = "'".date('Y-m-d H:i:s',$date_to)."'";
		
		$q = "WITH
			ships AS (
				SELECT
					sum(cost) AS cost,
					sum(cost_for_driver) AS cost_for_driver,
					sum(demurrage_cost) AS demurrage_cost
				FROM shipments_for_veh_owner_list AS t
				WHERE
					".($vown_id? sprintf("t.vehicle_owner_id=%d AND ",$vown_id):"")."
					t.ship_date_time BETWEEN ".$date_from_db." AND ".$date_to_db."
			)
			,pumps AS (
				SELECT
					sum(t.pump_cost) AS cost
				FROM shipments_pump_list t
				WHERE
					".($vown_id? sprintf("t.pump_vehicle_owner_id=%d AND ",$vown_id):"")."
					t.date_time  BETWEEN ".$date_from_db." AND ".$date_to_db."
			)
			,
			client_ships AS (
				SELECT
					sum(t.cost_concrete) AS cost_concrete,
					sum(t.cost_shipment) AS cost_shipment,
					sum(t.cost_other_owner_pump) AS cost_other_owner_pump,
					sum(t.cost_demurrage) AS cost_demurrage
				FROM shipments_for_client_veh_owner_list t
				WHERE	
					".($vown_id? sprintf("t.vehicle_owner_id=%d AND ",$vown_id):"")."
					t.ship_date  BETWEEN ".$date_from_db." AND ".$date_to_db."
			)
		SELECT
			(SELECT coalesce(cost,0.00) FROM ships) AS ship_cost,
			(SELECT coalesce(cost_for_driver,0.00) FROM ships) AS ship_for_driver_cost,
			(SELECT coalesce(demurrage_cost,0.00) FROM ships) AS ship_demurrage_cost,
			(SELECT coalesce(cost,0.00) FROM pumps) AS pumps_cost,
			(SELECT coalesce(cost_concrete,0.00) FROM client_ships) AS client_ships_concrete_cost,
			(SELECT coalesce(cost_other_owner_pump,0.00) FROM client_ships) AS client_ships_other_owner_pump_cost,
			(SELECT coalesce(cost_demurrage,0.00) FROM client_ships) AS demurrage_cost,
			(SELECT coalesce(cost_shipment,0.00) FROM client_ships) AS client_ships_shipment_cost";
		$this->addNewModel($q,'VehicleOwnerTotReport_Model');
	}

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
		
		//контроль начальнорго остатка по владельцу
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
					%s::timestamp AS date_from,
					%s::timestamp AS date_to
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
					WHERE vehicle_owner_id = (SELECT owner_id FROM params) AND period &lt;= (SELECT date_from::date FROM params)
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
				it.is_income AS item_is_income,
				it.is_info AS item_info,
				
				-- значение статьи: ручное или авто
				CASE
					WHEN it.query IS NOT NULL THEN
						vehicle_tot_rep_item_exec_query(
								it.query,
								s.id,
								((s.period_fact->>'fact_from')::date+ const_first_shift_start_time_val()),
								get_shift_end((s.period_fact->>'fact_to')::date + const_first_shift_start_time_val())
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
					AND sh.ship_date_time BETWEEN (s.period_fact->>'fact_from')::date + const_first_shift_start_time_val()
						AND get_shift_end((s.period_fact->>'fact_to')::date + const_first_shift_start_time_val())				
				) AS runs,
				
				-- рейсы самовывоз
				(SELECT
					count(*)
				FROM shipments AS sh
				JOIN vehicle_schedules AS vsch ON vsch.id = sh.vehicle_schedule_id
				JOIN orders AS o ON o.id = sh.order_id
				WHERE vsch.vehicle_id = s.id
					AND sh.shipped
					AND sh.ship_date_time BETWEEN (s.period_fact->>'fact_from')::date + const_first_shift_start_time_val()
						AND get_shift_end((s.period_fact->>'fact_to')::date + const_first_shift_start_time_val())				
					AND o.destination_id = const_self_ship_dest_id_val()
				) AS self_runs,

				-- общий объём
				coalesce((SELECT
					sum(sh.quant)
				FROM shipments AS sh
				JOIN vehicle_schedules AS vsch ON vsch.id = sh.vehicle_schedule_id
				WHERE vsch.vehicle_id = s.id
					AND sh.shipped
					AND sh.ship_date_time BETWEEN (s.period_fact->>'fact_from')::date + const_first_shift_start_time_val()
						AND get_shift_end((s.period_fact->>'fact_to')::date + const_first_shift_start_time_val())				
				),0) AS quant,
				
				-- средний объём
				coalesce((SELECT
					round(sum(sh.quant) / count(*))
				FROM shipments AS sh
				JOIN vehicle_schedules AS vsch ON vsch.id = sh.vehicle_schedule_id
				WHERE vsch.vehicle_id = s.id
					AND sh.shipped
					AND sh.ship_date_time BETWEEN (s.period_fact->>'fact_from')::date + const_first_shift_start_time_val()
						AND get_shift_end((s.period_fact->>'fact_to')::date + const_first_shift_start_time_val())				
				),0) AS avg_quant,
				
				(SELECT
					count(*)
				FROM vehicle_schedules AS t
				WHERE t.vehicle_id = s.id
					AND t.schedule_date BETWEEN (s.period_fact->>'fact_from')::date
						AND (s.period_fact->>'fact_to')::date
					
				) AS work_day_count,
				
				0 AS avg_runs
			FROM (
				SELECT
					d::date AS period,
					vh.id,
					vh.plate,
					CASE
						WHEN coalesce((SELECT veh_owners.owner_id FROM veh_owners
								WHERE veh_owners.id=vh.id AND veh_owners.period &lt; d::date
								ORDER BY veh_owners.period DESC LIMIT 1),0) &lt;> (SELECT owner_id FROM params)
								AND coalesce((SELECT veh_owners.owner_id FROM veh_owners
									WHERE veh_owners.id=vh.id
									 AND veh_owners.period > d::date AND veh_owners.period &lt; d::date+'1 month'::interval
									ORDER BY veh_owners.period DESC LIMIT 1),0) &lt;> (SELECT owner_id FROM params) THEN NULL
							
						WHEN coalesce((SELECT veh_owners.owner_id FROM veh_owners
							WHERE veh_owners.id=vh.id AND veh_owners.period &lt; d::date
							ORDER BY veh_owners.period DESC LIMIT 1),0) = (SELECT owner_id FROM params)
							AND coalesce((SELECT veh_owners.owner_id FROM veh_owners
							WHERE veh_owners.id=vh.id
								 AND veh_owners.period > d::date AND veh_owners.period &lt; d::date+'1 month'::interval
							ORDER BY veh_owners.period DESC LIMIT 1),0) &lt;> (SELECT owner_id FROM params) THEN
									jsonb_build_object(
										'fact_from', d::date,
										'fact_to', coalesce((SELECT (veh_owners.period-'1 day'::interval)::date FROM veh_owners
													WHERE veh_owners.id=vh.id
													AND veh_owners.period > d::date AND veh_owners.period &lt; d::date+'1 month'::interval
													ORDER BY veh_owners.period DESC LIMIT 1),last_month_day(d::date))
									)

						WHEN coalesce((SELECT veh_owners.owner_id FROM veh_owners
							WHERE veh_owners.id=vh.id AND veh_owners.period &lt; d::date
							ORDER BY veh_owners.period DESC LIMIT 1),0) &lt;> (SELECT owner_id FROM params)
							AND coalesce((SELECT veh_owners.owner_id FROM veh_owners
							WHERE veh_owners.id=vh.id
								 AND veh_owners.period > d::date AND veh_owners.period &lt; d::date+'1 month'::interval
							ORDER BY veh_owners.period DESC LIMIT 1),0) = (SELECT owner_id FROM params) THEN
									jsonb_build_object(
										'fact_from', (SELECT veh_owners.period FROM veh_owners
													WHERE veh_owners.id=vh.id
													AND veh_owners.period > d::date AND veh_owners.period &lt; d::date+'1 month'::interval
													ORDER BY veh_owners.period DESC LIMIT 1),
										'fact_to', last_month_day(d::date)
									)

					END AS period_fact
					
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
			WHERE s.period_fact IS NOT NULL
			ORDER BY s.plate,
				coalesce(it.is_income, FALSE) DESC,
				it.code,
				s.period"			
		,$vown_id
		,$date_from_db
		,$date_to_db
		);
		
		$this->addNewModel($q, 'VehicleOwnerTotIncomeReport_Model');
		
		/*
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

	//report for all owners/vehicles
	public function get_tot_income_report_all($pm){
		//period
		$cond = new ConditionParamsSQL($pm, $link);
		$dt_from = $cond->getDbVal('date_time','ge',DT_DATETIME);
		if (!isset($dt_from)){
			throw new Exception('Не задана дата начала!');
		}		
		$dt_to = $cond->getDbVal('date_time','le',DT_DATETIME);
		if (!isset($dt_to)){
			throw new Exception('Не задана дата окончания!');
		}		

		$date_from_db = "'".date('Y-m-d H:i:s', $dt_from)."'";
		$date_to_db = "'".date('Y-m-d H:i:s', $dt_to)."'";

		$q = sprintf("
			with
			per as (
				select
					%s::timestamp as d1,
					%s::timestamp as d2
			),	
			veh_data as (
				select
					det.mon,
					det.vehicle_owner_id,
					det.vehicle_id,		
					sum(det.quant) as quant		
				from (
					select
						date_trunc('month', get_shift_start(sh.date_time))::date as mon,
						sch.vehicle_id,
						sh.quant,
						--add owner
						(vehicle_owner_on_date(vh.vehicle_owners, sh.date_time)->'keys'->>'id')::int as vehicle_owner_id
						
					from shipments as sh
					left join vehicle_schedules as sch on sch.id = sh.vehicle_schedule_id
					left join vehicles as vh on vh.id = sch.vehicle_id
					where sh.date_time between (select d1 from per) and (select d2 from per)
				) AS det
				left join vehicle_owners as own on own.id = det.vehicle_owner_id
				group by
					det.mon,
					det.vehicle_id,
					det.vehicle_owner_id
			),
			owner_data as (
				select
					veh_data.mon,
					veh_data.vehicle_owner_id,		
					sum(veh_data.quant) as quant	
				from veh_data
				group by
					veh_data.mon,
					veh_data.vehicle_owner_id
			),
			owner_it_data as (
				select
					b.mon,
					b.vehicle_owner_id,
					coalesce(bal.value, 0) as balance_start,
					b.quant,	
					it_com.id as it_com_id,
					it_com.name as it_com_name,
					coalesce(it_com.is_income, false) as it_com_is_income,
					coalesce(
						coalesce(
							it_com_v.value,
							CASE
							WHEN it_com.query is null then 0
							ELSE
								vehicle_tot_rep_common_item_exec_query(
									it_com.query,
									b.vehicle_owner_id,
									(select d1 from per),
									(select d2 from per)
								)
							END
						)
					,0) AS it_com_val
					
				from owner_data as b
				CROSS join vehicle_tot_rep_common_items as it_com
				left join vehicle_tot_rep_balances as bal on
					bal.vehicle_owner_id = b.vehicle_owner_id
					and bal.period = b.mon
				left join vehicle_tot_rep_common_item_vals as it_com_v on
					it_com_v.vehicle_owner_id = b.vehicle_owner_id
					and it_com_v.period = b.mon	
					and it_com_v.vehicle_tot_rep_common_item_id = it_com.id
			)
			select
					sub.mon,
					sub.vehicle_owner_id,
					veh_on.name as vehicle_owner_name,
					sub.balance_start,
					sub.quant,	
					sub.it_com_id,
					sub.it_com_name,
					sub.it_com_is_income,
					sub.it_com_val	
			from (
				(select
						owner_it_data.mon,
						owner_it_data.vehicle_owner_id,
						owner_it_data.balance_start,
						owner_it_data.quant,	
						owner_it_data.it_com_id,
						owner_it_data.it_com_name,
						owner_it_data.it_com_is_income,
						owner_it_data.it_com_val	
				from owner_it_data)
				
				union all
				
				(select
						bal.period as mon,
						bal.vehicle_owner_id,
						bal.value,
						0 as quant,	
						NULL as it_com_id,
						NULL as it_com_name,
						NULL as it_com_is_income,
						0 as it_com_val		
				from vehicle_tot_rep_balances as bal
				where
					bal.period between (select d1 from per) and (select d2 from per)
					and bal.vehicle_owner_id not in (select owner_data.vehicle_owner_id from owner_data)
				)
			) as sub	
			left join vehicle_owners as veh_on on veh_on.id = sub.vehicle_owner_id
			order by
				veh_on.name,
				sub.mon,
				sub.it_com_is_income,
				sub.it_com_name
		", $date_from_db, $date_to_db);

		$this->addNewModel($q, 'VehicleOwnerList_Model');
	}

</xsl:template>

</xsl:stylesheet>
