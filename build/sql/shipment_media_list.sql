-- VIEW: shipment_media_list

--DROP VIEW shipment_media_list;

CREATE OR REPLACE VIEW shipment_media_list AS
	SELECT
		t.id 
		,t.driver_id
		,drivers_ref(dr) AS drivers_ref
		,t.shipment_id
		,shipments_ref(sh) AS shipments_ref
		,orders_ref(o) AS orders_ref
		,t.date_time
		,msg.message
		,o.id AS order_id
		
	FROM shipment_media AS t
	LEFT JOIN drivers AS dr ON dr.id = t.driver_id
	LEFT JOIN shipments AS sh ON sh.id = t.shipment_id
	LEFT JOIN orders AS o ON o.id = t.order_id
	LEFT JOIN notifications.tm_in_messages AS msg ON msg.id = t.message_id AND msg.app_id = 1
	ORDER BY t.date_time DESC
	;
	
ALTER VIEW shipment_media_list OWNER TO ;
