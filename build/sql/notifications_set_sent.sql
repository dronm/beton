-- Function: notifications.set_sent(in_msg_id int)

-- DROP FUNCTION notifications.set_sent(in_msg_id int);

CREATE OR REPLACE FUNCTION notifications.set_sent(in_msg_id int)
  RETURNS void AS
$$
	UPDATE notifications.tm_out_messages SET
		sent = true,
		sent_date_time = now()
	where id = in_msg_id;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION notifications.set_sent(in_msg_id int) OWNER TO ;
