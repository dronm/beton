-- View: public.orders_for_buh_list;

--DROP VIEW public.orders_for_buh_list;

CREATE OR REPLACE VIEW public.orders_for_buh_list AS 
	SELECT
		o.id,
		o.date_time,
		order_num(o.*) AS number,		
		orders_ref(o) AS orders_ref,
		order_num(o.*) AS order_num,
		clients_ref(cl) AS clients_ref,	
		cl.name AS client_descr,	
		cl.ref_1c IS NOT NULL AS client_ref_1c_exists,
		destinations_ref(d) AS destinations_ref,
		concrete_types_ref(concr) AS concrete_types_ref,
		o.quant,
		bd.ref_1c AS buh_doc_ref_1c


	FROM orders o

	LEFT JOIN clients cl ON cl.id = o.client_id
	LEFT JOIN destinations d ON d.id = o.destination_id
	LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
	LEFT JOIN LATERAL (
		SELECT
			bd.ref_1c
		FROM buh_doc_shipments AS bdsh
		LEFT JOIN buh_docs AS bd ON bd.id = bdsh.buh_doc_id
		WHERE bdsh.order_id = o.id
		ORDER BY bdsh.shipment_id DESC
		LIMIT 1
	) AS bd ON true
	WHERE o.quant > 0

	ORDER BY cl.name, o.date_time;




