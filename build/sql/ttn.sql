-- VIEW: ttn

--DROP VIEW ttn;

CREATE OR REPLACE VIEW ttn AS
	SELECT
		sh.id AS nomer,
		to_char(sh.ship_date_time::date,'DD.MM.YY') AS data,
		to_char(sh.ship_date_time::date,'DD TMMonth YYYY') AS data_propis,
		
		to_char(sh.ship_date_time::date,'DD') AS data_den,
		to_char(sh.ship_date_time::date,'TMMonth') AS data_mes,
		to_char(sh.ship_date_time::date,'YYYY')||'г.' AS data_god,
		
		coalesce(cl.name||' ', '')||
		coalesce('ИНН '||cl.inn||' ', '')||
		coalesce('КПП '||cl.kpp||' ', '')||
		coalesce(', '||cl.address_legal, '')		
		AS platelschik,
		 
		sh.quant AS nomen_kol,
		sh.quant*2.4 AS nomen_massa,
		'Бетон '||ct.name AS nomen_naim,
		substr('00000',1,5-length(ct.id::text))||ct.id AS nomen_kod,
		
		trim(to_char(
			CASE WHEN coalesce(sh.quant,0)=0 THEN 0
			ELSE shipments_cost(dest, o.concrete_type_id, o.date_time::date, sh, TRUE) / sh.quant
			END
		, '9999999D99'
		)) AS nomen_cena,
		
		trim(to_char(shipments_cost(dest, o.concrete_type_id, o.date_time::date, sh, TRUE), '9999999D99')) AS nomen_summa,
		ucase(
			num_spelled(shipments_cost(dest, o.concrete_type_id, o.date_time::date, sh, TRUE), 'M', '{рубль,рубля,рублей}', 'F', '{копейка,копейки,копеек}', '00d')
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
		) AS perevozchik
		
	FROM shipments AS sh
	LEFT JOIN orders o ON o.id = sh.order_id
	LEFT JOIN clients cl ON cl.id = o.client_id
	LEFT JOIN concrete_types ct ON ct.id = o.concrete_type_id
	LEFT JOIN vehicle_schedules sch ON sch.id = sh.vehicle_schedule_id
	LEFT JOIN drivers dr ON dr.id = sch.driver_id
	LEFT JOIN destinations dest ON dest.id = o.destination_id
	LEFT JOIN vehicles vh ON vh.id = sch.vehicle_id
	;
	
ALTER VIEW ttn OWNER TO ;
