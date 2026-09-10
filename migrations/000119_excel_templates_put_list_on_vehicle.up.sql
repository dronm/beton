insert into excel_templates (
	id,
	name,
	file_info,
	sql_query,
	cell_matching,
	file_content,
	update_dt,
	image_sql
)
select 
	71,
	'Путевой лист ТС',
	file_info,
	sql_query,
	cell_matching,
	file_content,
	update_dt,
	image_sql
From excel_templates where id = 2
ON CONFLICT (id) DO NOTHING;

