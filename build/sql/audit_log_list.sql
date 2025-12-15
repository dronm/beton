-- View: public.audit_log_list

-- DROP VIEW public.audit_log_dialog;
-- DROP VIEW public.audit_log_list;

CREATE OR REPLACE VIEW public.audit_log_list
 AS
SELECT 
	t.id,
	t.table_name,
	t.record_id,
	t.operation,
	t.changed_at,
	t.changed_by,
	CASE
		WHEN t.table_name = 'suppliers' THEN suppliers_ref(sp)
	ELSE NULL
	END AS object_ref,

	CASE
		WHEN t.table_name = 'suppliers' THEN 'Поставщик'
	ELSE NULL
	END AS type_descr,

	CASE
		WHEN t.operation = 'I' THEN 'Добавление'
		WHEN t.operation = 'U' THEN 'Изменение'
		WHEN t.operation = 'D' THEN 'Удаление'
	ELSE NULL
	END AS operation_descr

FROM public.audit_log AS t
LEFT JOIN suppliers AS sp ON t.table_name = 'suppliers' AND t.record_id = sp.id::text
ORDER BY t.changed_at DESC;
