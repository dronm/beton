-- View: orders_list

-- DROP VIEW orders_list;

CREATE OR REPLACE VIEW orders_list AS 
	SELECT
		o.id,
		order_num(o.*) AS number,
		clients_ref(cl) AS clients_ref,
		o.client_id,
		destinations_ref(d) AS destinations_ref,
		o.destination_id,
		concrete_types_ref(concr) AS concrete_types_ref,
		o.concrete_type_id,
		o.unload_type AS unload_type,
		o.comment_text AS comment_text,
		
		coalesce(ct.name::text, o.descr::text) AS descr,
		coalesce(ct.tel::text, o.phone_cel::text) AS phone_cel,
		
		o.date_time,
		o.quant,
		users_ref(u) AS users_ref,
		o.user_id,
		orders_ref(o) AS orders_ref,
		contacts_ref(ct) AS contacts_ref		
		
   FROM orders o
   LEFT JOIN clients cl ON cl.id = o.client_id
   LEFT JOIN destinations d ON d.id = o.destination_id
   LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
   LEFT JOIN contacts ct ON ct.id = o.contact_id
   LEFT JOIN users u ON u.id = o.user_id
  ORDER BY o.date_time DESC;

ALTER TABLE orders_list OWNER TO beton;
