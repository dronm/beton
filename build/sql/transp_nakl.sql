-- VIEW: transp_nakl

DROP VIEW transp_nakl;

CREATE OR REPLACE VIEW transp_nakl AS
	SELECT
		sh.id,
		(SELECT nomer FROM buh_docs WHERE order_id = o.id)||'/'||
		(SELECT
			ranks.sh_rank
		FROM 
			(SELECT
				rank() over (order by t.ship_date_time) AS sh_rank,
				t.id
			FROM
				shipments AS t
			WHERE t.order_id = o.id 
			)
		AS ranks
		WHERE ranks.id = sh.id	
		) AS nomer,
		
		(SELECT nomer FROM buh_docs WHERE order_id = o.id)||'/'||
		(SELECT
			ranks.sh_rank
		FROM 
			(SELECT
				rank() over (order by t.ship_date_time) AS sh_rank,
				t.id
			FROM
				shipments AS t
			WHERE t.order_id = o.id 
			)
		AS ranks
		WHERE ranks.id = sh.id	
		) AS nomer2,
		
		to_char(sh.date_time::date,'DD.MM.YY') AS data,
		to_char(sh.date_time::date,'DD.MM.YY') AS data_nakl,
		
		'' AS gruzopoluchatel1,

		coalesce(cl.name_full, cl.name)||
		coalesce(', ИНН '||cl.inn, '')||
		--coalesce(', КПП '||cl.kpp, '')||
		', '||coalesce( coalesce(cl.address_fact, cl.address_legal), dest.name)||
		coalesce(', '||cl.tels_1c, '')		
		AS gruzopoluchatel,
		
		'УПД '||(SELECT REGEXP_REPLACE(faktura_nomer, '^0+', '', 'g') FROM buh_docs WHERE order_id = o.id)::text||' от '||
		(SELECT SUBSTRING(faktura_data,1,10) FROM buh_docs WHERE order_id = o.id)
		AS faktura,
		
		CASE
			WHEN substring(ct.name, 1, 2) = 'ПБ' THEN '(БСМ)'
			WHEN substring(ct.name, 1, 2) = 'РР' THEN ''
			WHEN ct.name ilike '%%вода%%' THEN 'Вода'
			ELSE 'Бетон (БСТ)'
		END||' '||coalesce(ct.official_name, ct.name) AS gruz_naim,
		
		'1 место' AS gruz_mest,
		round(sh.quant*2.4*1000)||' кг, '||sh.quant||' м3' AS gruz_massa,
		round(sh.quant*2.4*1000)||' кг' AS massa_netto,
		
		(SELECT
			coalesce(cl_per.name_full, cl_per.name)||
			coalesce(', ИНН '||cl_per.inn, '')||
			--coalesce(', КПП '||cl_per.kpp, '')||
			', '||coalesce( coalesce(cl_per.address_fact, cl_per.address_legal), dest.name)||
			coalesce(', '||cl_per.tels_1c, '')		
		FROM
		(SELECT  
			vh_cl.name_full,
			vh_cl.name,
			vh_cl.inn,
			vh_cl.id,
			vh_cl.ref_1c,
			vh_cl.address_fact,
			vh_cl.address_legal,
			vh_cl.tels_1c
		FROM vehicle_owners AS vh_own 
		LEFT JOIN clients AS vh_cl ON vh_cl.id = vh_own.client_id
		WHERE vh_own.id = wehicle_owner_last(vh.id)
		) AS cl_per
		) AS perevozchik,
		
		coalesce(vh.make,'') || ' ' ||coalesce(vh.load_capacity::text,'') AS avto_marka,
		UPPER(vh.plate)||coalesce(vh.plate_region,' 72') AS avto_nomer,
		
		coalesce(dr.name,'')||
		coalesce(', ИНН '||dr.inn,'') AS voditel,
		
		
		dest.name AS adres,
		
		to_char(sh.date_time,'DD.MM.YY HH24:MI') AS data_vremia_pogruzki,
		
		coalesce(
			(SELECT
				to_char(st.date_time,'DD.MM.YY HH24:MI')
			FROM vehicle_schedule_states AS st
			WHERE st.schedule_id = sh.vehicle_schedule_id
				AND st.date_time > sh.date_time
				AND st.state = 'at_dest'
			ORDER BY st.date_time ASC
			LIMIT 1),			
			to_char(sh.date_time,'DD.MM.YY')	
		) AS data_vremia_vigruzki,

		coalesce(
			(SELECT
				to_char(st.date_time,'DD.MM.YY HH24:MI')
			FROM vehicle_schedule_states AS st
			WHERE st.schedule_id = sh.vehicle_schedule_id
				AND st.date_time > sh.date_time
				AND st.state = 'assigned'
			ORDER BY st.date_time ASC
			LIMIT 1),			
			to_char(sh.date_time,'DD.MM.YY')	
		) AS data_fakt_prib_pogruzki,
		
		to_char(sh.ship_date_time, 'DD.MM.YY HH24:MI') AS data_fakt_ubit_pogruzki,
		
		coalesce(
			(SELECT
				to_char(st.date_time,'DD.MM.YY HH24:MI')
			FROM vehicle_schedule_states AS st
			WHERE st.schedule_id = sh.vehicle_schedule_id
				AND st.date_time > sh.date_time
				AND st.state = 'at_dest'
			ORDER BY st.date_time ASC
			LIMIT 1),			
			to_char(sh.date_time,'DD.MM.YY')	
		) AS data_fakt_prib_vigruzki,
		
		coalesce(
			(SELECT
				to_char(st.date_time,'DD.MM.YY HH24:MI')
			FROM vehicle_schedule_states AS st
			WHERE st.schedule_id = sh.vehicle_schedule_id
				AND st.date_time > sh.date_time
				AND st.state = 'left_for_base'
			ORDER BY st.date_time ASC
			LIMIT 1),			
			to_char(sh.date_time,'DD.MM.YY')	
		) AS data_fakt_ubit_vigruzki,
		
		'' AS sost_gruza_pogruzka,
		'' AS sost_gruza_vigruzka,
		
		sh.quant*2.4*1000 AS gruz_massa_pogruzka,
		sh.quant*2.4*1000 AS gruz_massa_vigruzka,
		
		to_char(sh.ship_date_time::date,'DD.MM.YY') AS data_ispoln,
		
		coalesce(emp_disp.name, 'Верхорубов Евгений Николаевич') AS dispetcher,
		coalesce(emp_disp.post, 'Диспетчер РБУ') AS dispetcher_dolzhnost
		
	FROM shipments AS sh
	LEFT JOIN orders o ON o.id = sh.order_id
	LEFT JOIN clients cl ON cl.id = o.client_id
	LEFT JOIN concrete_types ct ON ct.id = o.concrete_type_id
	
	LEFT JOIN vehicle_schedules sch ON sch.id = sh.vehicle_schedule_id
	LEFT JOIN drivers dr ON dr.id = sch.driver_id
	LEFT JOIN destinations dest ON dest.id = o.destination_id
	LEFT JOIN vehicles vh ON vh.id = sch.vehicle_id
	LEFT JOIN production_sites pr_st ON pr_st.id = sh.production_site_id
	LEFT JOIN employees emp_disp ON emp_disp.id = pr_st.dispatcher_id
	;
	
ALTER VIEW transp_nakl OWNER TO ;
