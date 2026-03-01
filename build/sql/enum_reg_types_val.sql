	/* type get function */
	CREATE OR REPLACE FUNCTION enum_reg_types_val(reg_types,locales)
	RETURNS text AS $$
		SELECT
		CASE
		WHEN $1='material'::reg_types AND $2='ru'::locales THEN 'Учет материалов'
		WHEN $1='material_fact'::reg_types AND $2='ru'::locales THEN 'Учет материалов по факту'
		WHEN $1='cement'::reg_types AND $2='ru'::locales THEN 'Учет цемента'
		WHEN $1='material_consumption'::reg_types AND $2='ru'::locales THEN 'Расход материалов'
		WHEN $1='fuel_flow'::reg_types AND $2='ru'::locales THEN 'Движение топлива'
		ELSE ''
		END;		
	$$ LANGUAGE sql;	
