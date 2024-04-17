-- VIEW: notifications.tm_out_messages_list

--DROP VIEW notifications.tm_out_messages_list;

CREATE OR REPLACE VIEW notifications.tm_out_messages_list AS
	SELECT
		m.id,
		m.app_id,
		m.message,
		m.date_time
		
	FROM notifications.tm_out_messages AS m
	ORDER BY m.date_time DESC;
	
ALTER VIEW notifications.tm_out_messages_list OWNER TO ;
