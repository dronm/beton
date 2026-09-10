CREATE OR REPLACE FUNCTION number_to_russian_1_8(p_num bigint)
RETURNS text
LANGUAGE sql
IMMUTABLE
AS $$
	SELECT CASE p_num
		WHEN 1 THEN 'Один'
		WHEN 2 THEN 'Два'
		WHEN 3 THEN 'Три'
		WHEN 4 THEN 'Четыре'
		WHEN 5 THEN 'Пять'
		WHEN 6 THEN 'Шесть'
		WHEN 7 THEN 'Семь'
		WHEN 8 THEN 'Восемь'
		ELSE NULL
	END;
$$;
