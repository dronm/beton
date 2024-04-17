-- Function: quality_passports_smes_num(in_concrete_type_id int, in_shipment_id int)

-- DROP FUNCTION quality_passports_smes_num(in_concrete_type_id int, in_shipment_id int);

CREATE OR REPLACE FUNCTION quality_passports_smes_num(in_concrete_type_id int, in_shipment_id int)
  RETURNS text AS
$$
	WITH
	sh_data AS (
		SELECT
			sh.production_site_id,
			sh.date_time
		FROM shipments AS sh
		WHERE sh.id = in_shipment_id
	),
	podbor AS (
		SELECT
			rt_h.id,
			rt_h.code
		FROM raw_material_cons_rate_dates AS rt_h
		WHERE rt_h.production_site_id = (SELECT production_site_id FROM sh_data)
			AND  rt_h.dt + const_first_shift_start_time_val() < (SELECT date_time FROM sh_data)
		ORDER BY rt_h.dt DESC
		LIMIT 1
	)
	SELECT podbor.code::text FROM podbor;
	
	/*
	podbor_mat_num AS (
		SELECT
			sub.concrete_type_id,
			ROW_NUMBER() OVER() AS r_num
		FROM (
			SELECT DISTINCT ON (ctp.name)
				t.concrete_type_id,
				t.concrete_types_ref
			FROM raw_material_cons_rates_list AS t
			LEFT JOIN concrete_types AS ctp ON ctp.id=t.concrete_type_id
			WHERE rate_date_id = (SELECT podbor.id FROM podbor)
			ORDER BY ctp.name
		) AS sub		
	)
	SELECT
		--ID подбора/порядковый номер материала в подбре
		(SELECT podbor.code::text FROM podbor) || '/' ||
			(SELECT podbor_mat_num.r_num::text
			FROM podbor_mat_num
			WHERE podbor_mat_num.concrete_type_id = in_concrete_type_id
			)
	;
	*/
$$
  LANGUAGE sql STABLE
  COST 100;
ALTER FUNCTION quality_passports_smes_num(in_concrete_type_id int, in_shipment_id int) OWNER TO ;
