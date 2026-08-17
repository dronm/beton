BEGIN;
	-- Adding new type
	CREATE TYPE ship_weighing_causes AS ENUM (
		'self_ship'			
	,
		'redirection'			
	);
COMMIT;

	/* type get function */
	CREATE OR REPLACE FUNCTION enum_ship_weighing_causes_val(ship_weighing_causes,locales)
	RETURNS text AS $$
		SELECT
		CASE
		WHEN $1='self_ship'::ship_weighing_causes AND $2='ru'::locales THEN 'Самовывоз'
		WHEN $1='redirection'::ship_weighing_causes AND $2='ru'::locales THEN 'Переадресация'
		ELSE ''
		END;		
	$$ LANGUAGE sql;	
	ALTER FUNCTION enum_ship_weighing_causes_val(ship_weighing_causes,locales) OWNER TO beton;		
		

