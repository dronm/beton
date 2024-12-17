-- VIEW: putevoi_list

--DROP VIEW putevoi_list;


CREATE OR REPLACE VIEW putevoi_list AS
	SELECT
		sh.id AS nomer,
		to_char(sh.date_time::date,'DD') AS data_den,
		to_char(sh.date_time::date,'TMMonth') AS data_mes,
		to_char(sh.date_time::date,'YYYY') AS data_god,

		coalesce(vh.plate,'') AS avto_nomer,
		coalesce(vh.make,'') AS avto_marka,

		person_init(dr.name) AS voditel_fio,
		coalesce(dr.driver_licence,'') AS voditel_udost,
		coalesce(dr.driver_licence_class,'') AS voditel_udost_class,		
		
		'Бетон '||ct.name AS nomen_naim,
		
		to_char(sh.date_time,'DD') AS date_day_n,
		to_char(sh.date_time,'MM') AS date_mon_n,
		to_char(sh.date_time,'HH24') AS date_hour_n,
		to_char(sh.date_time,'MI') AS date_min_n,
		
		to_char(sh.date_time,'DD/MM HH24:MI') AS ship_dt_fact,
		
		cl.name AS client,
		dest.name AS object
		
	FROM shipments AS sh
	LEFT JOIN orders o ON o.id = sh.order_id
	LEFT JOIN clients cl ON cl.id = o.client_id
	LEFT JOIN concrete_types ct ON ct.id = o.concrete_type_id
	LEFT JOIN vehicle_schedules sch ON sch.id = sh.vehicle_schedule_id
	LEFT JOIN drivers dr ON dr.id = sch.driver_id
	LEFT JOIN destinations dest ON dest.id = o.destination_id
	LEFT JOIN vehicles vh ON vh.id = sch.vehicle_id
	;
	
ALTER VIEW putevoi_list OWNER TO ;

