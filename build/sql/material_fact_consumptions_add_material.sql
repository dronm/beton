-- DROP FUNCTION material_fact_consumptions_add_material2(in_production_site_id int, in_material_descr text, in_date_time timestamp without time zone)

CREATE OR REPLACE FUNCTION material_fact_consumptions_add_material(in_production_site_id int, in_material_descr text, in_date_time timestamp without time zone)
RETURNS int as $$
DECLARE
	v_raw_material_id int;
BEGIN
	v_raw_material_id = NULL;
	
	SELECT
		raw_material_id
	INTO
		v_raw_material_id
	FROM raw_material_map_to_production
	WHERE
		(production_site_id = in_production_site_id OR production_site_id IS NULL)
		AND production_descr = in_material_descr AND date_time <= in_date_time
	ORDER BY
		date_time DESC
	LIMIT 1;
	
	IF v_raw_material_id IS NULL AND coalesce(in_material_descr,'')<>'' THEN
		SELECT id FROM raw_materials INTO v_raw_material_id WHERE name = in_material_descr LIMIT 1;
	
		IF raw_material_id IS NOT NULL THEN
			INSERT INTO raw_material_map_to_production
			(date_time, production_descr, raw_material_id)
			VALUES
			(in_date_time, in_material_descr, v_raw_material_id)
			;
		END IF;
	END IF;
	
	RETURN v_raw_material_id;
END;
$$ language plpgsql;
