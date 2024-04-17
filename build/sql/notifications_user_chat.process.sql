-- Function: notifications.user_chat_process()

-- DROP FUNCTION notifications.user_chat_process();

CREATE OR REPLACE FUNCTION notifications.user_chat_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='INSERT') THEN
		
		IF NEW.to_user_id IS NULL THEN
			--common
			PERFORM pg_notify(
				'UserChat.common',
				json_build_object(
					'params',json_build_object(
						'text', NEW.message->>'text',
						'sender_id', NEW.from_user_id,
						'sender_descr', (SELECT name FROM users WHERE id = NEW.from_user_id),
						'media_type', (SELECT notifications.message_media_type(NEW.message)),
						'msg_id', NEW.id
					)
				)::text							
			);
		ELSE
			--private
			PERFORM pg_notify(
				md5('fd45g654g5y44_USER_CHAT_PRIVATE_MESSAGE_FOR_' || NEW.to_user_id::text),
				json_build_object(
					'params',json_build_object(
						'text', NEW.message->>'text',
						'sender_id', NEW.from_user_id,
						'sender_descr', (SELECT name FROM users WHERE id = NEW.from_user_id),
						'media_type', (SELECT notifications.message_media_type(NEW.message)),
						'msg_id', NEW.id
					)
				)::text							
			);
		
		END IF;
		
		--out message
		PERFORM pg_notify(
			md5('fd45g654g5y44_USER_CHAT_OUT_MESSAGE_FROM_' || NEW.from_user_id::text),
			json_build_object(
				'params',json_build_object(
					'text', NEW.message->>'text',
					'receiver_id', NEW.to_user_id,
					'media_type', (SELECT notifications.message_media_type(NEW.message)),
					'msg_id', NEW.id
				)
			)::text							
		);

		RETURN NEW;
		
	ELSIF (TG_WHEN='BEFORE' AND TG_OP='DELETE') THEN
		DELETE FROM notifications.user_chat_message_views WHERE user_chat_id = OLD.id;
	
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION notifications.user_chat_process()
  OWNER TO ;

