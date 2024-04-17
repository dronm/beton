-- Function: notifications.message_media_type(in_msg jsonb)

--DROP FUNCTION notifications.message_media_type(in_msg jsonb);
 
CREATE OR REPLACE FUNCTION notifications.message_media_type(in_msg jsonb)
  RETURNS text
  AS
$$
	SELECT
		CASE
			WHEN in_msg->'video' IS NOT NULL THEN 'video'
			WHEN in_msg->'audio' IS NOT NULL THEN 'audio'
			WHEN in_msg->'document' IS NOT NULL THEN 'document'
			WHEN in_msg->'photo' IS NOT NULL THEN 'photo'
			WHEN in_msg->'voice' IS NOT NULL THEN 'voice'
			WHEN in_msg->'animation' IS NOT NULL THEN 'animation'
			WHEN in_msg->'sticker' IS NOT NULL THEN 'sticker'
			WHEN in_msg->'text' IS NOT NULL THEN 'text'
			ELSE NULL
		END AS media_type
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION notifications.message_media_type(in_msg jsonb) OWNER TO ;

