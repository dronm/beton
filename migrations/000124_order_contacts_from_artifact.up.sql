INSERT INTO public.order_contacts (order_id, contact_id)
SELECT
    o.id,
    (o.contacts_ref #>> '{keys,id}')::integer
FROM public.orders_list AS o
WHERE (o.contacts_ref #>> '{keys,id}') IS NOT NULL
ON CONFLICT (order_id, contact_id) DO NOTHING;
