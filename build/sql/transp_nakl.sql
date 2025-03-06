-- VIEW: transp_nakl

--DROP VIEW transp_nakl;

CREATE OR REPLACE VIEW transp_nakl AS
	SELECT
		sh.id AS nomer,
		sh.id AS nomer2,
		to_char(sh.date_time::date,'DD.MM.YY') AS data,
		to_char(sh.date_time::date,'DD.MM.YY') AS data_nakl,
		
		coalesce(cl.name||' ', '')||
		coalesce(', '||cl.address_legal, '')||
		coalesce(', ИНН '||cl.inn, '')		
		AS gruzopoluchatel1,

		coalesce(cl.name||' ', '')||
		coalesce(', '||cl.address_legal, '')		
		AS gruzopoluchatel,
		
		'Бетон '||ct.name AS gruz_naim,
		1 AS gruz_mest,
		sh.quant*2.4*1000 AS gruz_massa,
		
		coalesce(vh.make,'') || ' ' ||coalesce(vh.load_capacity::text,'') AS avto_marka,
		vh.plate AS avto_nomer,
		
		coalesce(dr.name,'') AS voditel,
		
		
		dest.name AS adres,
		
		to_char(sh.date_time,'DD.MM.YY HH24:MI') AS data_vremia_pogruzki,
		
		
		(SELECT
			to_char(st.date_time,'DD.MM.YY HH24:MI')
		FROM vehicle_schedule_states AS st
		WHERE st.schedule_id = sh.vehicle_schedule_id
			AND st.date_time > sh.date_time
			AND st.state = 'at_dest'
		ORDER BY st.date_time DESC
		LIMIT 1
		) AS data_vremia_vigruzki,

		(SELECT
			to_char(st.date_time,'DD.MM.YY HH24:MI')
		FROM vehicle_schedule_states AS st
		WHERE st.schedule_id = sh.vehicle_schedule_id
			AND st.date_time > sh.date_time
			AND st.state = 'assigned'
		ORDER BY st.date_time DESC
		LIMIT 1
		) AS data_fakt_prib_pogruzki,
		
		(SELECT
			to_char(st.date_time,'DD.MM.YY HH24:MI')
		FROM vehicle_schedule_states AS st
		WHERE st.schedule_id = sh.vehicle_schedule_id
			AND st.date_time > sh.date_time
			AND st.state = 'left_for_dest'
		ORDER BY st.date_time DESC
		LIMIT 1
		) AS data_fakt_ubit_pogruzki,
		
		
		(SELECT
			to_char(st.date_time,'DD.MM.YY HH24:MI')
		FROM vehicle_schedule_states AS st
		WHERE st.schedule_id = sh.vehicle_schedule_id
			AND st.date_time > sh.date_time
			AND st.state = 'at_dest'
		ORDER BY st.date_time DESC
		LIMIT 1
		) AS data_fakt_prib_vigruzki,

		(SELECT
			to_char(st.date_time,'DD.MM.YY HH24:MI')
		FROM vehicle_schedule_states AS st
		WHERE st.schedule_id = sh.vehicle_schedule_id
			AND st.date_time > sh.date_time
			AND st.state = 'left_for_base'
		ORDER BY st.date_time DESC
		LIMIT 1
		) AS data_fakt_ubit_vigruzki,
		
		'' AS sost_gruza_pogruzka,
		'' AS sost_gruza_vigruzka,
		
		sh.quant*2.4*1000 AS gruz_massa_pogruzka,
		sh.quant*2.4*1000 AS gruz_massa_vigruzka,
		
		to_char(sh.ship_date_time::date,'DD.MM.YY') AS data_ispoln
		
	FROM shipments AS sh
	LEFT JOIN orders o ON o.id = sh.order_id
	LEFT JOIN clients cl ON cl.id = o.client_id
	LEFT JOIN concrete_types ct ON ct.id = o.concrete_type_id
	
	LEFT JOIN vehicle_schedules sch ON sch.id = sh.vehicle_schedule_id
	LEFT JOIN drivers dr ON dr.id = sch.driver_id
	LEFT JOIN destinations dest ON dest.id = o.destination_id
	LEFT JOIN vehicles vh ON vh.id = sch.vehicle_id
	;
	
ALTER VIEW transp_nakl OWNER TO ;
