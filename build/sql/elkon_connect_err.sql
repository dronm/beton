-- Function: elkon_connect_err(in_elkon_log_message text, in_elkon_log_date_time timestamp)

-- DROP FUNCTION elkon_connect_err(in_elkon_log_message text, in_elkon_log_date_time timestamp);

CREATE OR REPLACE FUNCTION elkon_connect_err(in_elkon_log_message text, in_elkon_log_date_time timestamp)
  RETURNS bool AS
$$
	SELECT
		SUBSTRING(in_elkon_log_message from 1 for 28) = 'Ошибка соединения с сервером'
		AND EXTRACT(EPOCH FROM NOW() - in_elkon_log_date_time) * 1000 > const_ping_elkon_interval_err_val()
	;
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
