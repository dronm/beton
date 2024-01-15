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
			"SELECT
				sub4.veh_id,	
				v.plate AS veh_plate,	
				sub4.items->'id' AS item_id,
				sub4.items->>'name' AS item_name,
				sub4.items->'is_income' AS item_is_income,
				sub4.items->'input' AS item_input,
				sub4.d AS period,
				sub4.items->'val' AS val,
				
				(SELECT
					count(*)
				FROM shipments AS sh
				JOIN vehicle_schedules AS vsch ON vsch.id = sh.vehicle_schedule_id
				WHERE vsch.vehicle_id = sub4.veh_id
					AND sh.shipped
					AND sh.ship_date_time BETWEEN sub4.d + const_first_shift_start_time_val() AND get_shift_end(sub4.d + const_first_shift_start_time_val())				
				) AS runs,
				
				(SELECT
					count(*)
				FROM shipments AS sh
				JOIN vehicle_schedules AS vsch ON vsch.id = sh.vehicle_schedule_id
				JOIN orders AS o ON o.id = sh.order_id
				WHERE vsch.vehicle_id = sub4.veh_id
					AND sh.shipped
					AND sh.ship_date_time BETWEEN sub4.d + const_first_shift_start_time_val() AND get_shift_end(sub4.d + const_first_shift_start_time_val())				
					AND o.destination_id = const_self_ship_dest_id_val()
				) AS self_runs,
				
				coalesce((SELECT
					round(sum(sh.quant) / count(*))
				FROM shipments AS sh
				JOIN vehicle_schedules AS vsch ON vsch.id = sh.vehicle_schedule_id
				WHERE vsch.vehicle_id = sub4.veh_id
					AND sh.shipped
					AND sh.ship_date_time BETWEEN sub4.d + const_first_shift_start_time_val() AND get_shift_end(sub4.d + const_first_shift_start_time_val())				
				),0) AS avg_quant,
				
				0 AS avg_runs
				
			FROM ( 
			SELECT
				sub3.d,
				sub3.veh_id,
				json_array_elements(sub3.items) AS items
			FROM (
				SELECT
					sub2.d::date,
					sub2.veh_id,
					(SELECT
						json_agg(s.v)
					FROM
						(SELECT		 	
							json_build_object(
								'id', its.id,
								'code', its.code,
								'name', its.name,
								'is_income', coalesce(its.is_income, FALSE),
								'input', its.query IS NULL,
								'val',
									CASE
										WHEN its.query IS NOT NULL THEN
											vehicle_tot_rep_item_exec_query(
													its.query,
													sub2.veh_id,
													sub2.d,
													last_month_day(sub2.d::date)+'1 day'::interval+'05:59:59'									
											)
										ELSE coalesce(vals.value, 0.00)
									END
							) AS v
						FROM vehicle_tot_rep_items AS its
						LEFT JOIN vehicle_tot_rep_item_vals AS vals ON
							vals.vehicle_tot_rep_item_id = its.id
							AND vals.vehicle_id = sub2.veh_id
							AND vals.period = sub2.d::date
						) AS s
					) AS items

				FROM (

					SELECT
						sub1.d,
						unnest(sub1.veh_ids) As veh_id
					FROM (
						SELECT
							d AS d				
							,(SELECT
								array_agg(v.id)
							FROM vehicles AS v
							--LEFT JOIN vehicle_schedules AS sch ON sch.vehicle_id = v.id AND sch.schedule_date = d::date
							WHERE (
									vehicle_owner_on_date(
											v.vehicle_owners,
										(date_trunc('month', d::date) + interval '1 month - 1 day')::date
									)->'keys'->>'id')::int = %d
								--AND sch.id IS NOT NULL
							) AS veh_ids

							FROM generate_series(
								%s::timestamp,
								%s::timestamp,
								'1 month'::interval
							) AS d
					) AS sub1
				) AS sub2
			) AS sub3	
			) AS sub4
			LEFT JOIN vehicles AS v ON v.id = sub4.veh_id
			ORDER BY 
				sub4.veh_id,
				(sub4.items->>'code')::int,
				sub4.d"
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

		$this->addNewModel(sprintf(
			"WITH
			bal AS (SELECT coalesce(
					(SELECT
						value
					FROM vehicle_tot_rep_balances
					WHERE vehicle_owner_id = %d AND period &lt;= %s
					ORDER BY period DESC
					LIMIT 1
					),	
				0) AS v		
			)
			SELECT
				veh.id,
				coalesce(vh_per.runs, 0) AS runs,
				coalesce(vh_per.quant, 0) AS quant,
				coalesce(vh_per.quant_avg, 0) AS quant_avg,
				coalesce(vh_per.runs_self, 0) AS runs_self,
				d::date AS period_mon,
				coalesce(vh_per.work_day_count, 0) AS work_day_count,
				(SELECT v FROM bal) AS balance_beg
			FROM generate_series(
					%s::timestamp,
					%s::timestamp,
					'1 month'::interval
			) AS d			
			CROSS JOIN (
				SELECT v.id
				FROM vehicles v
				WHERE (
					vehicle_owner_on_date(
						v.vehicle_owners,
						%s::date
					)->'keys'->>'id')::int = %d
			) AS veh
			LEFT JOIN (
				SELECT
					v.id,
					sh.runs AS runs,
					sh.quant AS quant,
					CASE WHEN coalesce(sh.runs,0) = 0 THEN 0 ELSE round(sh.quant::numeric / sh.runs::numeric, 2) END AS quant_avg,
					coalesce(sh.runs_self, 0) AS runs_self,
					sh.period_mon,
					(SELECT count(*)
					FROM vehicle_schedules AS t
					WHERE t.vehicle_id = v.id AND t.schedule_date BETWEEN sh.period_mon AND sh.period_mon+'1 month'::interval-'1 day'::interval
					) AS work_day_count
				FROM vehicles AS v
				LEFT JOIN (
					SELECT
						vsch.vehicle_id,
						date_trunc('month', get_shift_start(t.ship_date_time)::date)::date AS period_mon,
						count(*) AS runs,
						sum(t.quant) AS quant,
						sum(CASE WHEN o.destination_id = const_self_ship_dest_id_val() THEN 1 ELSE 0 END) AS runs_self
					FROM shipments AS t
					LEFT JOIN vehicle_schedules AS vsch ON vsch.id = t.vehicle_schedule_id
					LEFT JOIN orders AS o ON o.id = t.order_id
					WHERE t.shipped AND t.ship_date_time BETWEEN get_shift_start(%s::timestamp without time zone) AND get_shift_end(%s::timestamp without time zone+'1 month'::interval-'1 day'::interval)
					GROUP BY vsch.vehicle_id, period_mon
				) AS sh ON sh.vehicle_id = v.id
				WHERE (
					vehicle_owner_on_date(
						v.vehicle_owners,
						%s
					)->'keys'->>'id')::int = %d
				AND sh.period_mon IS NOT NULL				
			) AS vh_per ON vh_per.id = veh.id AND vh_per.period_mon = d::date"
			,$vown_id
			,$date_from_db

			,$date_from_db
			,$date_to_db

			,$date_from_db
			,$vown_id
			
				
			,$date_from_db
			,$date_to_db
			
			,$date_from_db
			,$vown_id
			
			)			
			,'VehicleOwnerTotIncomeReportStat_Model'
		);
	}

</xsl:template>

</xsl:stylesheet>
