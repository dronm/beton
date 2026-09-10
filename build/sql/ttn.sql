-- VIEW: ttn

--DROP VIEW ttn;

CREATE OR REPLACE VIEW ttn AS
/*
	WITH 
	dispatcher AS (
		SELECT emp.name
		FROM shipments AS sh 
		LEFT JOIN production_sites AS ps ON ps.id = sh.production_site_id
		LEFT JOIN employees AS emp ON emp.id = ps.dispatcher_id
		WHERE sh.id = 264346
	)
	*/

	SELECT
		sh.id AS nomer,
		to_char(sh.ship_date_time::date,'DD.MM.YY') AS data,
		to_char(sh.ship_date_time::date,'DD TMMonth YYYY') AS data_propis,
		
		to_char(sh.ship_date_time::date,'DD') AS data_den,
		to_char(sh.ship_date_time::date,'TMMonth') AS data_mes,
		to_char(sh.ship_date_time::date,'YYYY')||'г.' AS data_god,
		
		coalesce(cl.name_full, cl.name)||
		coalesce(', ИНН '||cl.inn, '')||
		coalesce(', КПП '||cl.kpp, '')||
		', '||coalesce( coalesce(cl.address_fact, cl.address_legal), dest.name)||
		coalesce(', '||cl.tels_1c, '')		
		AS platelschik,
		 
		sh.quant AS nomen_kol,
		sh.quant*2.4 AS nomen_massa,
		'Бетон '||ct.name AS nomen_naim,
		substr('00000',1,5-length(ct.id::text))||ct.id AS nomen_kod,
		
		trim(to_char(
			CASE WHEN coalesce(sh.quant,0)=0 THEN 0
			ELSE shipments_cost(pb.id, dest, o.concrete_type_id, o.date_time::date, sh, TRUE, cl) / sh.quant
			END
		, '9999999D99'
		)) AS nomen_cena,
		
		trim(to_char(shipments_cost(pb.id, dest, o.concrete_type_id, o.date_time::date, sh, TRUE, cl), '9999999D99')) AS nomen_summa,
		ucase(
			num_spelled(shipments_cost(pb.id, dest, o.concrete_type_id, o.date_time::date, sh, TRUE, cl), 'M', '{рубль,рубля,рублей}', 'F', '{копейка,копейки,копеек}', '00d')
		) AS nomen_summa_propis,
		
		person_init(dr.name) AS voditel_fio,
		coalesce(dr.driver_licence,'') AS voditel_udost,
		dest.name AS punkt_razgruzki,
		coalesce(vh.plate,'') AS avto_nomer,
		coalesce(vh.make,'') AS avto_marka,
		
		coalesce(vh.weight_t,0) + sh.quant*2.4 AS massa_brutto,
		ucase(num_spelled((sh.quant*2.4)::numeric, 'F', '{тонна,тонны,тонн}', 'M', '{кг}', '999d')) AS nomen_massa_propis,
		
		ucase(num_spelled((coalesce(vh.weight_t,0) + sh.quant*2.4)::numeric, 'F', '{тонна,тонны,тонн}', 'M', '{кг}', '999d')) AS massa_brutto_propis,
		
		(SELECT 
			coalesce(perev.name||', ', '')||
			coalesce('ИНН '||perev.inn||' ', '')||
			coalesce('КПП '||perev.kpp||' ', '')||
			coalesce(', '||perev.address_legal, '')||
			coalesce(', р/с '||perev.bank_account, '')||
			coalesce(', в банке '||bnk.name, '')||
			coalesce(', БИК '||perev.bank_bik, '')||
			coalesce(', к/с '||bnk.korshet, '')
		FROM
		(SELECT jsonb_array_elements(vh.vehicle_owners->'rows') As r) AS s
		LEFT JOIN vehicle_owners AS perev_org ON (s.r->'fields'->'owner'->'keys'->>'id')::int = perev_org.id
		LEFT JOIN clients AS perev ON perev.id = perev_org.client_id
		LEFT JOIN banks.banks AS bnk ON bnk.bik = perev.bank_bik		
		
		WHERE (s.r->'fields'->>'dt_from')::timestamp with time zone <= sh.ship_date_time
		ORDER BY (s.r->'fields'->>'dt_from')::timestamp with time zone DESC
		LIMIT 1
		) AS perevozchik,

		person_init(contacts.name) AS dispatcher,
		person_init(contacts.name) AS dispatcher2,
		'' AS buhgalter
		
	FROM shipments AS sh
	LEFT JOIN orders o ON o.id = sh.order_id
	LEFT JOIN clients cl ON cl.id = o.client_id
	LEFT JOIN concrete_types ct ON ct.id = o.concrete_type_id
	LEFT JOIN vehicle_schedules sch ON sch.id = sh.vehicle_schedule_id
	LEFT JOIN destinations dest ON dest.id = o.destination_id
	LEFT JOIN vehicles vh ON vh.id = sch.vehicle_id
	--LEFT JOIN drivers dr ON dr.id = sch.driver_id
	LEFT JOIN drivers dr ON dr.id = vh.driver_id -- vehicle "official" driver 
	LEFT JOIN production_sites AS ps ON ps.id = sh.production_site_id
	LEFT JOIN production_bases AS pb ON pb.id = ps.production_base_id
	--LEFT JOIN employees AS disp_emp ON disp_emp.id = ps.dispatcher_id
	LEFT JOIN operators_for_transp_nakl_schedules AS opers ON 
		opers.production_site_id  = sh.production_site_id AND opers.for_date = sh.date_time::date
	LEFT JOIN users AS oper_u ON oper_u.id  = opers.user_id
	LEFT JOIN entity_contacts AS ent_ct ON ent_ct.entity_id  = oper_u.id AND ent_ct.entity_type = 'users'
	LEFT JOIN contacts ON ent_ct.contact_id  = contacts.id
	;
	
--ALTER VIEW ttn OWNER TO ;
