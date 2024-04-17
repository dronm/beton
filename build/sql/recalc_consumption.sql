-- PROCEDURE: public.recalc_consumption(in_period_id integer, in_production_site_id integer)

-- DROP PROCEDURE public.recalc_consumption(in_period_id integer, in_production_site_id integer);

-- завешивает базу при большом количестве документов

CREATE OR REPLACE PROCEDURE public.recalc_consumption(in_period_id integer, in_production_site_id integer)
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    r RECORD;
BEGIN
	/*
	WITH dt_to AS (
		SELECT d.dt FROM raw_material_cons_rate_dates AS d WHERE d.id = in_period_id
	)
	UPDATE shipments
		SET shipped = true
	WHERE shipped
		AND ship_date_time BETWEEN
			coalesce(
				(SELECT d.dt
				FROM raw_material_cons_rate_dates AS d
				WHERE d.dt > (SELECT dt FROM dt_to)
				ORDER BY d.dt DESC
				LIMIT 1),
				now()::timestamp without time zone
			)
			AND (SELECT dt FROM dt_to)
		AND production_site_id = in_production_site_id
	;
	*/
	
	FOR r IN
		WITH dt_to AS (
			SELECT d.dt FROM raw_material_cons_rate_dates AS d WHERE d.id = in_period_id
		)
		SELECT id
		FROM shipments
		WHERE shipped
			AND ship_date_time BETWEEN
				(SELECT dt FROM dt_to)
				AND 
				coalesce(
					(SELECT d.dt
					FROM raw_material_cons_rate_dates AS d
					WHERE d.dt > (SELECT dt FROM dt_to)
					ORDER BY d.dt DESC
					LIMIT 1),
					now()::timestamp without time zone
				)				
			AND production_site_id = in_production_site_id
		LOOP
		
		UPDATE shipments SET
			shipped = TRUE
		WHERE id = r.id;
		
		COMMIT; -- fix changes
	END LOOP;	
END;
$BODY$;

ALTER PROCEDURE public.recalc_consumption(in_period_id integer, in_production_site_id integer) OWNER TO ;

