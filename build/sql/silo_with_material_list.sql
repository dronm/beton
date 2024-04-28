-- Function: silo_with_material_list(in_material_id int, in_date_time timestamp with time zone)

-- DROP FUNCTION silo_with_material_list(in_material_id int, in_date_time timestamp with time zone);

CREATE OR REPLACE FUNCTION silo_with_material_list(in_material_id int, in_date_time timestamp with time zone)
  RETURNS table(
  	silo_id int,
  	production_site_id int,
  	silo_name text  	
  ) AS
$$
	select
			sl.silo_id,
			sl.production_site_id,
			sl.name as silo_name
	from (	
		select
			sl.id as silo_id,
			sl.production_site_id,
			sl.name,
			sl.production_descr,
			(select
				mpr.raw_material_id
			from raw_material_map_to_production as mpr
			where (mpr.production_site_id is null or mpr.production_site_id = sl.production_site_id)
				and mpr.production_descr = sl.production_descr
				and mpr.date_time <= in_date_time
			order by date_time desc
			limit 1) as raw_material_id
		from cement_silos as sl
	) AS sl
	where sl.production_descr is not null AND raw_material_id = in_material_id
	;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION silo_with_material_list(in_material_id int, in_date_time timestamp with time zone) OWNER TO ;
