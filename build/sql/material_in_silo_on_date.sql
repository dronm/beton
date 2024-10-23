-- Function: material_in_silo_on_date(in_silo_id int, in_date_time timestamp with time zone)

-- DROP FUNCTION material_in_silo_on_date(in_silo_id int, in_date_time timestamp with time zone);

/*
 * returns material id which is in silo at the given date time.
 */

CREATE OR REPLACE FUNCTION material_in_silo_on_date(in_silo_id int, in_date_time timestamp with time zone)
  RETURNS int AS
$$
	WITH
	silo as (
		select
			production_descr,
			production_site_id
		from cement_silos
		where id = in_silo_id
	)
	SELECT
		mpr.raw_material_id
	FROM raw_material_map_to_production AS mpr
	WHERE
		(mpr.production_site_id is null or mpr.production_site_id = (SELECT silo.production_site_id FROM silo))
		AND mpr.production_descr = (SELECT silo.production_descr FROM silo)
		AND mpr.date_time <= in_date_time
	ORDER BY mpr.date_time DESC
	LIMIT 1;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION material_in_silo_on_date(in_silo_id int, in_date_time timestamp with time zone) OWNER TO ;
