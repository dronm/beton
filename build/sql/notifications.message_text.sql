-- Function: notifications.message_text(in_msg jsonb)

--DROP FUNCTION notifications.message_text(in_msg jsonb);
 
CREATE OR REPLACE FUNCTION notifications.message_text(in_msg jsonb)
  RETURNS text
  AS
$$
	SELECT
		CASE
			WHEN in_msg->'video' IS NOT NULL AND coalesce(in_msg->>'caption', '')<>'' THEN in_msg->>'caption'
			WHEN in_msg->'video' IS NOT NULL AND coalesce(in_msg->>'caption', '')='' THEN in_msg->>'file_name'
			WHEN in_msg->'document' IS NOT NULL AND coalesce(in_msg->>'caption', '')<>'' THEN in_msg->>'caption'
			WHEN in_msg->'document' IS NOT NULL AND coalesce(in_msg->>'caption', '')='' THEN in_msg->>'file_name'
			WHEN in_msg->'audio' IS NOT NULL THEN in_msg->>'caption'
			WHEN in_msg->'photo' IS NOT NULL THEN in_msg->>'caption'
			WHEN in_msg->'voice' IS NOT NULL THEN in_msg->>'caption'
			WHEN in_msg->'animation' IS NOT NULL THEN in_msg->>'caption'
			WHEN in_msg->'sticker' IS NOT NULL THEN in_msg->'sticker'->>'emoji'
			WHEN in_msg->'text' IS NOT NULL THEN in_msg->>'text'
			ELSE NULL
		END AS text
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION notifications.message_text(in_msg jsonb) OWNER TO ;

