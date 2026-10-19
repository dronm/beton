BEGIN;

-- Single-statement, transactional merge. Run through migration 000126.
CREATE OR REPLACE FUNCTION public.clients_merge(p_main_id integer, p_client_ids integer[])
RETURNS void
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $merge$
DECLARE
	v_ids integer[];
	v_sources integer[];
	v_count integer;
	v_table text;
	v_constraint text;
	v_ref record;
	v_remaining boolean;
	v_tables constant text[] := ARRAY[
		'orders', 'order_garbage', 'offer', 'ast_calls', 'client_tels',
		'specialist_requests', 'client_valid_duplicates', 'vehicle_owners',
		'vehicle_owner_clients', 'vehicle_owner_concrete_prices',
		'client_destinations', 'client_specifications', 'quality_passports',
		'client_contracts_1c', 'client_debts'
	];
BEGIN
	IF p_main_id IS NULL OR p_main_id <= 0
		OR p_client_ids IS NULL OR cardinality(p_client_ids) > 100
		OR EXISTS (SELECT 1 FROM unnest(p_client_ids) AS x(id) WHERE id IS NULL OR id <= 0)
	THEN
		RAISE EXCEPTION 'Некорректный список клиентов (не более 100 положительных кодов).';
	END IF;
	SELECT array_agg(id ORDER BY id) INTO v_ids
	FROM (SELECT DISTINCT unnest(p_client_ids) AS id) AS selected;
	IF coalesce(cardinality(v_ids), 0) < 2 OR NOT (p_main_id = ANY(v_ids)) THEN
		RAISE EXCEPTION 'Выберите не менее двух клиентов и главного клиента из этого списка.';
	END IF;
	v_sources := array_remove(v_ids, p_main_id);

	-- Lock the main client too: overlapping merges must not delete one another's target.
	PERFORM id FROM public.clients WHERE id = ANY(v_ids) ORDER BY id FOR UPDATE;
	GET DIAGNOSTICS v_count = ROW_COUNT;
	IF v_count <> cardinality(v_ids) THEN
		RAISE EXCEPTION 'Один из выбранных клиентов уже удален. Обновите список.';
	END IF;
	-- Also protect legacy client_id columns without foreign keys from concurrent writes.
	FOREACH v_table IN ARRAY v_tables LOOP
		EXECUTE format('LOCK TABLE public.%I IN SHARE ROW EXCLUSIVE MODE', v_table);
	END LOOP;
	LOCK TABLE public.entity_contacts IN SHARE ROW EXCLUSIVE MODE;

	-- These tables contain set membership, with no business values to choose between.
	DELETE FROM public.client_valid_duplicates AS d
	USING public.client_valid_duplicates AS keep
	WHERE d.client_id = ANY(v_sources)
		AND keep.client_id = ANY(v_ids) AND keep.tel = d.tel
		AND (keep.client_id = p_main_id OR keep.client_id < d.client_id);
	DELETE FROM public.vehicle_owner_clients AS d
	USING public.vehicle_owner_clients AS keep
	WHERE d.client_id = ANY(v_sources) AND keep.client_id = ANY(v_ids)
		AND keep.vehicle_owner_id = d.vehicle_owner_id
		AND (keep.client_id = p_main_id OR keep.client_id < d.client_id);

	-- Contracts must move before specifications: their BEFORE trigger looks up the contract.
	FOREACH v_table IN ARRAY ARRAY[
		'client_contracts_1c', 'orders', 'order_garbage', 'offer', 'ast_calls',
		'client_tels', 'specialist_requests', 'client_valid_duplicates',
		'vehicle_owners', 'vehicle_owner_clients', 'vehicle_owner_concrete_prices',
		'client_destinations', 'client_specifications', 'quality_passports', 'client_debts'
	] LOOP
		BEGIN
			EXECUTE format('UPDATE public.%I SET client_id = $1 WHERE client_id = ANY($2)', v_table)
			USING p_main_id, v_sources;
		EXCEPTION WHEN unique_violation THEN
			GET STACKED DIAGNOSTICS v_constraint = CONSTRAINT_NAME;
			RAISE EXCEPTION 'Объединение отменено: конфликт данных в таблице % (ограничение %). Устраните конфликт и повторите.',
				v_table, v_constraint;
		END;
	END LOOP;

	-- Modern contacts use a polymorphic link rather than client_id.
	DELETE FROM public.entity_contacts AS d
	USING public.entity_contacts AS keep
	WHERE d.entity_type = 'clients' AND keep.entity_type = 'clients'
		AND d.entity_id = ANY(v_sources) AND keep.entity_id = ANY(v_ids)
		AND keep.contact_id = d.contact_id
		AND (keep.entity_id = p_main_id OR keep.entity_id < d.entity_id);
	UPDATE public.entity_contacts SET entity_id = p_main_id
	WHERE entity_type = 'clients' AND entity_id = ANY(v_sources);

	-- Detect unhandled references BEFORE DELETE, including ON DELETE CASCADE/SET NULL.
	FOR v_ref IN
		SELECT DISTINCT ns.nspname AS schema_name, rel.relname AS table_name, attr.attname AS column_name
		FROM pg_constraint AS con
		JOIN pg_class AS rel ON rel.oid = con.conrelid
		JOIN pg_namespace AS ns ON ns.oid = rel.relnamespace
		CROSS JOIN LATERAL unnest(con.conkey, con.confkey) AS keys(local_att, remote_att)
		JOIN pg_attribute AS attr ON attr.attrelid = con.conrelid AND attr.attnum = keys.local_att
		JOIN pg_attribute AS remote_attr ON remote_attr.attrelid = con.confrelid AND remote_attr.attnum = keys.remote_att
		WHERE con.contype = 'f' AND con.confrelid = 'public.clients'::regclass AND remote_attr.attname = 'id'
	LOOP
		EXECUTE format('SELECT EXISTS (SELECT 1 FROM %I.%I WHERE %I = ANY($1))',
			v_ref.schema_name, v_ref.table_name, v_ref.column_name)
		INTO v_remaining USING v_sources;
		IF v_remaining THEN
			RAISE EXCEPTION 'Объединение отменено: остались ссылки на клиентов в %.% (%).',
				v_ref.schema_name, v_ref.table_name, v_ref.column_name;
		END IF;
	END LOOP;
	DELETE FROM public.clients WHERE id = ANY(v_sources);
	GET DIAGNOSTICS v_count = ROW_COUNT;
	IF v_count <> cardinality(v_sources) THEN
		RAISE EXCEPTION 'Объединение отменено: не все выбранные клиенты удалены.';
	END IF;
END;
$merge$;


INSERT INTO views (id, c, f, t, section, descr, limited)
VALUES ('10063', 'Client_Controller', 'get_list', 'ClientMerge', 'Справочники', 'Объединение клиентов', FALSE);

COMMIT;
