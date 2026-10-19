-- All basket mutations take the same transaction-scoped lock before reading it.
-- Client row locks precede selection row locks: a merge can remove baskets for
-- every user without deadlocking a concurrent selection of one of its clients.
CREATE OR REPLACE FUNCTION public.clients_merge_select(p_user_id integer, p_client_id integer)
RETURNS void
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $select$
BEGIN
	IF p_user_id IS NULL OR p_user_id <= 0 THEN
		RAISE EXCEPTION 'Не определен пользователь.';
	END IF;
	PERFORM pg_advisory_xact_lock(10063, p_user_id);
	PERFORM id FROM public.users WHERE id = p_user_id FOR KEY SHARE;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'Пользователь не найден.';
	END IF;
	IF p_client_id IS NULL OR p_client_id <= 0 THEN
		RAISE EXCEPTION 'Некорректный код клиента.';
	END IF;
	PERFORM id FROM public.clients WHERE id = p_client_id FOR KEY SHARE;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'Клиент уже удален. Обновите список.';
	END IF;
	IF EXISTS (
		SELECT 1 FROM public.client_merge_selections
		WHERE user_id = p_user_id AND client_id = p_client_id
	) THEN
		RETURN;
	END IF;
	IF (SELECT count(*) FROM public.client_merge_selections WHERE user_id = p_user_id) >= 100 THEN
		RAISE EXCEPTION 'Можно выбрать не более 100 клиентов.';
	END IF;
	INSERT INTO public.client_merge_selections (user_id, client_id)
	VALUES (p_user_id, p_client_id);
END;
$select$;

CREATE OR REPLACE FUNCTION public.clients_merge_unselect(p_user_id integer, p_client_id integer)
RETURNS void
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $unselect$
BEGIN
	IF p_user_id IS NULL OR p_user_id <= 0 THEN
		RAISE EXCEPTION 'Не определен пользователь.';
	END IF;
	PERFORM pg_advisory_xact_lock(10063, p_user_id);
	PERFORM id FROM public.users WHERE id = p_user_id FOR KEY SHARE;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'Пользователь не найден.';
	END IF;
	IF p_client_id IS NULL OR p_client_id <= 0 THEN
		RAISE EXCEPTION 'Некорректный код клиента.';
	END IF;
	DELETE FROM public.client_merge_selections
	WHERE user_id = p_user_id AND client_id = p_client_id;
END;
$unselect$;

CREATE OR REPLACE FUNCTION public.clients_merge_clear(p_user_id integer)
RETURNS void
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $clear$
BEGIN
	IF p_user_id IS NULL OR p_user_id <= 0 THEN
		RAISE EXCEPTION 'Не определен пользователь.';
	END IF;
	PERFORM pg_advisory_xact_lock(10063, p_user_id);
	PERFORM id FROM public.users WHERE id = p_user_id FOR KEY SHARE;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'Пользователь не найден.';
	END IF;
	DELETE FROM public.client_merge_selections WHERE user_id = p_user_id;
END;
$clear$;

-- Merge the server-side basket; callers cannot substitute an arbitrary ID list.
CREATE OR REPLACE FUNCTION public.clients_merge_selected(p_user_id integer, p_main_id integer, p_expected_ids integer[])
RETURNS void
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $selected$
DECLARE
	v_ids integer[];
	v_expected_ids integer[];
BEGIN
	IF p_user_id IS NULL OR p_user_id <= 0 THEN
		RAISE EXCEPTION 'Не определен пользователь.';
	END IF;
	PERFORM pg_advisory_xact_lock(10063, p_user_id);
	PERFORM id FROM public.users WHERE id = p_user_id FOR KEY SHARE;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'Пользователь не найден.';
	END IF;
	SELECT array_agg(client_id ORDER BY client_id) INTO v_ids
	FROM public.client_merge_selections WHERE user_id = p_user_id;
	-- Compare the visible set from the caller with the authoritative locked basket.
	-- Another tab may have selected clients since this page last refreshed.
	IF p_expected_ids IS NULL OR cardinality(p_expected_ids) > 100
		OR EXISTS (SELECT 1 FROM unnest(p_expected_ids) AS x(id) WHERE id IS NULL OR id <= 0)
	THEN
		RAISE EXCEPTION 'Выбор клиентов изменился. Обновите списки и повторите объединение.';
	END IF;
	SELECT array_agg(id ORDER BY id) INTO v_expected_ids
	FROM (SELECT DISTINCT unnest(p_expected_ids) AS id) AS expected;
	IF v_ids IS DISTINCT FROM v_expected_ids THEN
		RAISE EXCEPTION 'Выбор клиентов изменился. Обновите списки и повторите объединение.';
	END IF;
	IF coalesce(cardinality(v_ids), 0) < 2
		OR p_main_id IS NULL OR NOT (p_main_id = ANY(v_ids))
	THEN
		RAISE EXCEPTION 'Выберите не менее двух клиентов и главного клиента из этого списка.';
	END IF;
	PERFORM public.clients_merge(p_main_id, v_ids);
	-- Any failure above rolls back both business changes and basket cleanup.
	DELETE FROM public.client_merge_selections WHERE user_id = p_user_id;
END;
$selected$;
