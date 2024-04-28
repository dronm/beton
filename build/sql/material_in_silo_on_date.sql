-- Function: material_in_silo_on_date(in_silo_id int, in_date_time timestamp with time zone)

-- DROP FUNCTION material_in_silo_on_date(in_silo_id int, in_date_time timestamp with time zone);

/*
 * returns material id which is in silo at the given date time.
 */

CREATE OR REPLACE FUNCTION material_in_silo_on_date(in_silo_id int, in_date_time timestamp with time zone)
  RETURNS int AS
$$
	with
	silo as (select production_descr, production_site_id from cement_silos where id = in_silo_id)
	select
		mpr.raw_material_id
	from raw_material_map_to_production as mpr
	where
		(mpr.production_site_id is null or mpr.production_site_id = (select silo.production_site_id from silo))
		and mpr.production_descr = (select silo.production_descr from silo)
		and mpr.date_time <= in_date_time
	order by mpr.date_time desc
	limit 1;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION material_in_silo_on_date(in_silo_id int, in_date_time timestamp with time zone) OWNER TO ;
