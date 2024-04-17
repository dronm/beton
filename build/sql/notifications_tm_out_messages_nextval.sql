-- Function: notifications.tm_out_messages_nextval()

--DROP FUNCTION notifications.tm_out_messages_nextval();
 
CREATE OR REPLACE FUNCTION notifications.tm_out_messages_nextval()
RETURNS bigint AS 'SELECT a FROM notifications.tm_out_messages_seq_view;'
LANGUAGE SQL;

