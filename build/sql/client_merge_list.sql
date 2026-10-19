-- The merge page deliberately has its own view rather than extending clients_list.
-- The controller adds the authenticated user's NOT EXISTS selection predicate.
CREATE OR REPLACE VIEW public.client_merge_list AS
SELECT
	cl.id,
	cl.name,
	cl.inn,
	cl.phone_cel,
	(SELECT count(*) FROM public.orders AS o WHERE o.client_id = cl.id) AS orders_count
FROM public.clients AS cl;
