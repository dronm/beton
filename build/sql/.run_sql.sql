 
-- DROP FUNCTION public.vehicle_list_report(in_date_from date, in_date_to date, in_vehicle_id int);

CREATE OR REPLACE FUNCTION public.vehicle_list_report(in_date_from date, in_date_to date, in_vehicle_id int)
    RETURNS TABLE(
    	id integer,
    	plate text,
    	vin text,
    	make text,
    	owner text,
    	driver text,
    	leasor text,
    	leasing_contract text,
    	leasing_total numeric(15, 2),
    	
    	ins_osago_issuer text,
    	ins_osago_total numeric(15, 2),
    	ins_osago_period text,
    	
    	ins_kasko_issuer text,
    	ins_kasko_total numeric(15, 2),
    	ins_kasko_period text    	
) 
    LANGUAGE 'sql'
    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
	WITH
	vh_list AS (
		SELECT
			DISTINCT (sch.vehicle_id) AS id,
			sch.driver_id
		FROM vehicle_schedules AS sch
		WHERE
			sch.schedule_date >= in_date_from AND sch.schedule_date <= in_date_to
			AND (in_vehicle_id = 0 OR in_vehicle_id = sch.vehicle_id)
	)

	SELECT
		vh.id,
		vh.plate,
		vh.vin,
		vh.make,
		(SELECT
			o.fields->'owner'->>'descr'
		FROM
			(SELECT jsonb_array_elements(vh.vehicle_owners->'rows')->'fields' AS fields) AS o
		ORDER BY (o.fields->>'dt_from')::timestamp DESC
		LIMIT 1
		) AS owner,
		dr.name AS driver,
	    	vh.leasor,
	    	coalesce(vh.leasing_contract_num,'') || coalesce(' от '||to_char(vh.leasing_contract_date, 'DD/MM/YYYY'), ''),
	    	vh.leasing_total,
	    	
	    	--osago
	    	(SELECT
	    		osago.fields->>'issuer'
	    	FROM
		    	(SELECT
				jsonb_array_elements(vh.insurance_osago->'rows')->'fields' AS fields
		    	) AS osago
		ORDER BY (osago.fields->>'dt_to')::timestamp DESC
		LIMIT 1    	
		) AS ins_osago_issuer,
	    	(SELECT
	    		(osago.fields->>'total')::numeric(15,2)
	    	FROM
		    	(SELECT
				jsonb_array_elements(vh.insurance_osago->'rows')->'fields' AS fields
		    	) AS osago
		ORDER BY (osago.fields->>'dt_to')::timestamp DESC
		LIMIT 1    	
		) AS ins_osago_total,
	    	(SELECT
	    		to_char((osago.fields->>'dt_from')::timestamp, 'DD/MM/YY') || '-' || to_char((osago.fields->>'dt_to')::timestamp, 'DD/MM/YY')
	    	FROM
		    	(SELECT
				jsonb_array_elements(vh.insurance_osago->'rows')->'fields' AS fields
		    	) AS osago
		ORDER BY (osago.fields->>'dt_to')::timestamp DESC
		LIMIT 1    	
		) AS ins_osago_period,
		
		--kasko
	    	(SELECT
	    		kasko.fields->>'issuer'
	    	FROM
		    	(SELECT
				jsonb_array_elements(vh.insurance_kasko->'rows')->'fields' AS fields
		    	) AS kasko
		ORDER BY (kasko.fields->>'dt_to')::timestamp DESC
		LIMIT 1    	
		) AS ins_kasko_issuer,
	    	(SELECT
	    		(kasko.fields->>'total')::numeric(15,2)
	    	FROM
		    	(SELECT
				jsonb_array_elements(vh.insurance_kasko->'rows')->'fields' AS fields
		    	) AS kasko
		ORDER BY (kasko.fields->>'dt_to')::timestamp DESC
		LIMIT 1    	
		) AS ins_kasko_total,
	    	(SELECT
	    		to_char((kasko.fields->>'dt_from')::timestamp, 'DD/MM/YY') || '-' || to_char((kasko.fields->>'dt_to')::timestamp, 'DD/MM/YY')
	    	FROM
		    	(SELECT
				jsonb_array_elements(vh.insurance_kasko->'rows')->'fields' AS fields
		    	) AS kasko
		ORDER BY (kasko.fields->>'dt_to')::timestamp DESC
		LIMIT 1    	
		) AS ins_kasko_period
		
	FROM vh_list
	LEFT JOIN vehicles AS vh ON vh.id = vh_list.id
	LEFT JOIN drivers AS dr ON dr.id = vh_list.driver_id
	ORDER BY vh.plate_n, vh.plate
	;
$BODY$;

ALTER FUNCTION public.vehicle_list_report(in_date_from date, in_date_to date, in_vehicle_id int)
    OWNER TO beton;

