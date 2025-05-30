	/* type get function */
	CREATE OR REPLACE FUNCTION enum_doc_types_val(doc_types,locales)
	RETURNS text AS $$
		SELECT
		CASE
		WHEN $1='order'::doc_types AND $2='ru'::locales THEN 'Заявка'
		WHEN $1='material_procurement'::doc_types AND $2='ru'::locales THEN 'Поступление материалов'
		WHEN $1='shipment'::doc_types AND $2='ru'::locales THEN 'Отгрузка'
		WHEN $1='material_fact_consumption'::doc_types AND $2='ru'::locales THEN 'Фактический расход материалов'
		WHEN $1='material_fact_consumption_correction'::doc_types AND $2='ru'::locales THEN 'Корректировка фактического расхода материалов'
		WHEN $1='material_fact_balance_correction'::doc_types AND $2='ru'::locales THEN 'Корректировка остатка материала'
		WHEN $1='cement_silo_reset'::doc_types AND $2='ru'::locales THEN 'Обнуление силоса'
		WHEN $1='cement_silo_balance_reset'::doc_types AND $2='ru'::locales THEN 'Обнуление остатка силоса'
		WHEN $1='material_movement'::doc_types AND $2='ru'::locales THEN 'Перемещение материалов'
		ELSE ''
		END;		
	$$ LANGUAGE sql;	
