	/* type get function */
	CREATE OR REPLACE FUNCTION enum_sms_types_val(sms_types,locales)
	RETURNS text AS $$
		SELECT
		CASE
		WHEN $1='order'::sms_types AND $2='ru'::locales THEN 'заявка'
		WHEN $1='ship'::sms_types AND $2='ru'::locales THEN 'отгрузка'
		WHEN $1='remind'::sms_types AND $2='ru'::locales THEN 'напоминание'
		WHEN $1='procur'::sms_types AND $2='ru'::locales THEN 'поставка'
		WHEN $1='order_for_pump_ins'::sms_types AND $2='ru'::locales THEN 'заявка для насоса (новая)'
		WHEN $1='order_for_pump_upd'::sms_types AND $2='ru'::locales THEN 'заявка для насоса (изменена)'
		WHEN $1='order_for_pump_del'::sms_types AND $2='ru'::locales THEN 'заявка для насоса (удалена)'
		WHEN $1='order_for_pump_ship'::sms_types AND $2='ru'::locales THEN 'заявка для насоса (отгружена)'
		WHEN $1='remind_for_pump'::sms_types AND $2='ru'::locales THEN 'напоминание для насоса'
		WHEN $1='client_thank'::sms_types AND $2='ru'::locales THEN 'благодарность клиенту'
		WHEN $1='vehicle_zone_violation'::sms_types AND $2='ru'::locales THEN 'Въезд в запрещенную зону'
		WHEN $1='vehicle_tracker_malfunction'::sms_types AND $2='ru'::locales THEN 'Нерабочий трекер'
		WHEN $1='efficiency_warn'::sms_types AND $2='ru'::locales THEN 'Низская эффективность'
		WHEN $1='material_balance'::sms_types AND $2='ru'::locales THEN 'Остатки материалов'
		WHEN $1='mixer_route'::sms_types AND $2='ru'::locales THEN 'Маршрут для миксериста'
		WHEN $1='order_cancel'::sms_types AND $2='ru'::locales THEN 'Отмена заявки'
		WHEN $1='tm_invite'::sms_types AND $2='ru'::locales THEN 'Приглашение в Telegram'
		WHEN $1='max_invite'::sms_types AND $2='ru'::locales THEN 'Приглашение в MAX'
		WHEN $1='new_pwd'::sms_types AND $2='ru'::locales THEN 'Новый пароль'
		ELSE ''
		END;		
	$$ LANGUAGE sql;	
