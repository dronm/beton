	/* type get function */
	CREATE OR REPLACE FUNCTION enum_ownership_types_val(ownership_types,locales)
	RETURNS text AS $$
		SELECT
		CASE
		WHEN $1='preperty'::ownership_types AND $2='ru'::locales THEN 'Собственность'
		WHEN $1='leasing'::ownership_types AND $2='ru'::locales THEN 'Лизинг'
		WHEN $1='rent'::ownership_types AND $2='ru'::locales THEN 'Аренда'
		ELSE ''
		END;		
	$$ LANGUAGE sql;	

