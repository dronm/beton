-- Function: transp_nakl_print(in_shipment_id int, in_shipment_ind int, in_buh_doc jsonb)

-- DROP FUNCTION transp_nakl_print(in_shipment_id int, in_shipment_ind int, in_buh_doc jsonb);

CREATE OR REPLACE FUNCTION transp_nakl_print(in_shipment_id int, in_shipment_ind int, in_buh_doc jsonb)
  RETURNS TABLE(
  	nomer text,
  	nomer2 text,
  	data text,
  	data_nakl text,
  	gruzopoluchatel1 text,
  	gruzopoluchatel text,
  	faktura text,
  	gruz_naim text,
  	gruz_mest text,
  	gruz_massa text,
  	massa_netto text,
  	perevozchik text,
  	avto_marka text,
  	avto_nomer text,
  	voditel text,
  	adres text,
  	data_vremia_pogruzki text,
  	data_vremia_vigruzki text,
  	data_fakt_prib_pogruzki text,
  	data_fakt_ubit_pogruzki text,
  	data_fakt_prib_vigruzki text,
  	data_fakt_ubit_vigruzki text,
	sost_gruza_pogruzka text,
	sost_gruza_vigruzka text,
	
	gruz_massa_pogruzka text,
	gruz_massa_vigruzka text,
	
	data_ispoln text,
	
	dispetcher text,
	dispetcher_dolzhnost text	
  )
     LANGUAGE 'sql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

	SELECT
		in_buh_doc->>'nomer'||'/'||in_shipment_ind::text AS nomer,
		
		in_buh_doc->>'nomer'||'/'||in_shipment_ind::text AS nomer2,
		
		to_char(sh.date_time::date,'DD.MM.YY') AS data,
		to_char(sh.date_time::date,'DD.MM.YY') AS data_nakl,
		
		'' AS gruzopoluchatel1,

		coalesce(cl.name_full, cl.name)||
		coalesce(', ИНН '||cl.inn, '')||
		--coalesce(', КПП '||cl.kpp, '')||
		', '||coalesce( coalesce(cl.address_fact, cl.address_legal), dest.name)||
		coalesce(', '||cl.tels_1c, '')		
		AS gruzopoluchatel,
		
		'УПД '||REGEXP_REPLACE(in_buh_doc->>'faktura_nomer', '^0+', '', 'g')::text||' от '||
		SUBSTRING(in_buh_doc->>'faktura_data',1,10)
		AS faktura,
		
		CASE
			WHEN substring(ct.name, 1, 2) = 'ПБ' THEN '(БСМ)'
			WHEN substring(ct.name, 1, 2) = 'РР' THEN ''
			WHEN ct.name ilike '%%вода%%' THEN 'Вода'
			ELSE 'Бетон (БСТ)'
		END||' '||coalesce(ct.official_name, ct.name) AS gruz_naim,
		
		'1 место' AS gruz_mest,
		-- round(sh.quant*2.4*1000)||' кг, '||sh.quant||' м3' AS gruz_massa,
		sh.quant||' м3' AS gruz_massa,
		round(sh.quant*2.4*1000)||' кг' AS massa_netto,

		coalesce(vh_cl.name_full, vh_cl.name)||
		coalesce(', ИНН '||vh_cl.inn, '')||
		--coalesce(', КПП '||cl_per.kpp, '')||
		', '||coalesce( coalesce(vh_cl.address_fact, vh_cl.address_legal), dest.name)||
		coalesce(', '||vh_cl.tels_1c, '')
		AS perevozchik,		
		
		coalesce(vh.make,'') || ' ' ||coalesce(vh.load_capacity::text,'') AS avto_marka,
		UPPER(vh.plate)||coalesce(vh.plate_region,' 72') AS avto_nomer,
		
		person_init(coalesce(dr.name,''))||
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
		
		(sh.quant*2.4*1000)::text AS gruz_massa_pogruzka,
		(sh.quant*2.4*1000)::text AS gruz_massa_vigruzka,
		
		to_char(sh.ship_date_time::date,'DD.MM.YY') AS data_ispoln,
		
		--coalesce(emp_disp.name, 'Верхорубов Евгений Николаевич') AS dispetcher,
		--coalesce(emp_disp.post, 'Диспетчер РБУ') AS dispetcher_dolzhnost
		person_init((select users_ref->>'descr'
		from operators_for_transp_nakls_list
		where (production_sites_ref->'keys'->>'id')::int = sh.production_site_id
		)::text) AS dispetcher,
		'Оператор' AS dispetcher_dolzhnost
		
	FROM shipments AS sh
	LEFT JOIN orders o ON o.id = sh.order_id
	LEFT JOIN clients cl ON cl.id = o.client_id
	LEFT JOIN concrete_types ct ON ct.id = o.concrete_type_id
	
	LEFT JOIN vehicle_schedules sch ON sch.id = sh.vehicle_schedule_id
	
	LEFT JOIN destinations dest ON dest.id = o.destination_id
	LEFT JOIN vehicles vh ON vh.id = sch.vehicle_id
	LEFT JOIN production_sites pr_st ON pr_st.id = sh.production_site_id
	LEFT JOIN drivers dr ON dr.id = vh.driver_id
	LEFT JOIN users AS op_u ON op_u.id=sh.operator_user_id
	LEFT JOIN vehicle_owners AS v_own ON v_own.id = vh.official_vehicle_owner_id
	LEFT JOIN clients AS vh_cl ON vh_cl.id = v_own.client_id
	
	WHERE sh.id = in_shipment_id;
$BODY$;
