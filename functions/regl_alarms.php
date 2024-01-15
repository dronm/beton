<?php
require_once('db_con.php');

/*****  НЕРАБОТАЮЩИЕ ТРЭКЕРЫ ******* */
$dbLink->query(sprintf(
	"INSERT INTO notifications.ext_messages
	(WITH tracker_list AS (SELECT string_agg(plate,',') AS v FROM car_tracking_malfunctions_list)	
	SELECT
		jsonb_build_object(
			'app_id', %d,
			'messages', jsonb_build_array(
				jsonb_build_object(
					'ext_obj', users_ref(u)::jsonb,					
					'tm', jsonb_build_object(
						'text', 'Нет данных от '|| (SELECT v FROM tracker_list)
					),
					'sms',jsonb_build_object(
						'tel', u.phone_cel::text,
						'body', 'Нет данных от '||(SELECT v FROM tracker_list),
						'sms_type', 'vehicle_tracker_malfunction',
						'doc_ref', '{}'::jsonb
					)							
				)
			)
		)
	FROM sms_pattern_user_phones AS ph
	LEFT JOIN users u ON u.id = ph.user_id
	WHERE
		length(coalesce((SELECT v FROM tracker_list),''))>0
		AND ph.sms_pattern_id = (SELECT id FROM sms_patterns WHERE sms_type='vehicle_tracker_malfunction' LIMIT 1)
		AND (SELECT now()-sent_date_time
			FROM sms_for_sending
			WHERE sms_type='vehicle_tracker_malfunction'
			ORDER BY sent_date_time DESC LIMIT 1
		)>=const_no_tracker_signal_warn_interval_val()::interval
	)",
	MS_APP_ID
));

/*
$dbLink->query(
	"INSERT INTO sms_for_sending (tel, body, sms_type)
	(WITH tracker_list AS (SELECT string_agg(plate,',') AS v FROM car_tracking_malfunctions_list)
	
	SELECT
		u.phone_cel::text AS tel,
		'Нет данных от '||(SELECT v FROM tracker_list) AS body,
		'vehicle_tracker_malfunction'::sms_types
	FROM sms_pattern_user_phones AS ph
	LEFT JOIN users u ON u.id = ph.user_id
	WHERE
		length(coalesce((SELECT v FROM tracker_list),''))>0
		AND ph.sms_pattern_id = (SELECT id FROM sms_patterns WHERE sms_type='vehicle_tracker_malfunction' LIMIT 1)
		AND (SELECT now()-sent_date_time
			FROM sms_for_sending
			WHERE sms_type='vehicle_tracker_malfunction'
			ORDER BY sent_date_time DESC LIMIT 1
		)>=const_no_tracker_signal_warn_interval_val()::interval
	)"
);
*/

/*****  ЭФФЕКТИВНОСТЬ" ******* */
$dbLink->query(sprintf(
	"INSERT INTO notifications.ext_messages
	(WITH efficiency AS (
		SELECT
			ROUND(quant_shipped_before_now - quant_ordered_before_now,2) AS v
		FROM efficiency_view	
	)
	SELECT
		jsonb_build_object(
			'app_id', %d,
			'messages', jsonb_build_array(
				jsonb_build_object(
					'ext_obj', users_ref(u)::jsonb,					
					'tm', jsonb_build_object(
						'text', 'Состояние: '||(SELECT v FROM efficiency)
					),
					'sms',jsonb_build_object(
						'tel', u.phone_cel::text,
						'body', 'Состояние: '||(SELECT v FROM efficiency),
						'sms_type', 'efficiency_warn',
						'doc_ref', '{}'::jsonb
					)							
				)
			)
		)
	FROM sms_pattern_user_phones AS ph
	LEFT JOIN users u ON u.id = ph.user_id
	WHERE ph.sms_pattern_id = (SELECT id FROM sms_patterns WHERE sms_type='efficiency_warn' LIMIT 1)
		AND (SELECT now()-sent_date_time
			FROM sms_for_sending
			WHERE sms_type='efficiency_warn'
			ORDER BY sent_date_time DESC LIMIT 1
		)>='2 hours'::interval
	)",
	MS_APP_ID
));

/*
$dbLink->query(
	"INSERT INTO sms_for_sending (tel, body, sms_type)
	(WITH efficiency AS (
		SELECT
			ROUND(quant_shipped_before_now - quant_ordered_before_now,2) AS v
		FROM efficiency_view	
	)
	SELECT
		u.phone_cel::text AS tel,
		'Состояние: '||(SELECT v FROM efficiency) AS body,
		'efficiency_warn'::sms_types
	FROM sms_pattern_user_phones AS ph
	LEFT JOIN users u ON u.id = ph.user_id
	WHERE ph.sms_pattern_id = (SELECT id FROM sms_patterns WHERE sms_type='efficiency_warn' LIMIT 1)
		AND (SELECT now()-sent_date_time
			FROM sms_for_sending
			WHERE sms_type='efficiency_warn'
			ORDER BY sent_date_time DESC LIMIT 1
		)>='2 hours'::interval
	)"
);
*/
?>
