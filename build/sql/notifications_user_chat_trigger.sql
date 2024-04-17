-- Trigger: user_chat_trigger_after on notifications.user_chat

-- DROP TRIGGER user_chat_trigger_after ON notifications.user_chat;


CREATE TRIGGER user_chat_trigger_after
  AFTER INSERT
  ON notifications.user_chat
  FOR EACH ROW
  EXECUTE PROCEDURE notifications.user_chat_process();


-- DROP TRIGGER user_chat_trigger_before ON notifications.user_chat;
/*
CREATE TRIGGER user_chat_trigger_before
  BEFORE DELETE
  ON notifications.user_chat
  FOR EACH ROW
  EXECUTE PROCEDURE notifications.user_chat_process();
*/
