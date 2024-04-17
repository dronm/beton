<?php
require_once('db_con.php');

/**  Благодарность клиентам *******
 *   ТОЛЬКО ТЕЛЕГРАМ!
 */
/*
	'sms',jsonb_build_object(
		'tel', t.phone_cel::text,
		'body', t.message,
		'sms_type', 'client_thank',
		'doc_ref', '{}'::jsonb
	)							

*/

//LEFT JOIN notifications.ext_users_list AS e_us ON e_us.ext_obj->>'dataType' = t.ext_obj->>'dataType' AND (e_us.ext_obj->'keys'->>'id')::int = (t.ext_obj->'keys'->>'id')::int

$dbLink->query(sprintf(
	"INSERT INTO notifications.ext_messages
	(SELECT
		jsonb_build_object(
			'app_id', %d,
			'messages', jsonb_build_array(
				jsonb_build_object(
					'ext_obj', t.ext_obj::jsonb,					
					'tm', jsonb_build_object(
						'text', t.message
					)
				)
			)
		)
	FROM sms_client_thank t	
	LEFT JOIN notifications.ext_users_list AS e_us ON e_us.ext_contact_id = t.ext_contact_id
	WHERE t.shift = get_shift_start(now()::timestamp-'1 day'::interval)
		AND e_us.ext_obj IS NOT NULL
	)",
	MS_APP_ID
));


/*
$dbLink->query(
	"INSERT INTO sms_for_sending
	(tel, body, sms_type)
	(SELECT
			t.phone_cel,
			t.message,
			'client_thank'::sms_types
		FROM sms_client_thank t
		WHERE t.shift = get_shift_start(now()::timestamp-'1 day'::interval)
		AND NOT EXISTS (
			SELECT old_sms.tel
			FROM sms_for_sending AS old_sms
			WHERE old_sms.tel=t.phone_cel
				AND old_sms.sms_type='client_thank'::sms_types
				AND old_sms.date_time>=now()-'1 month'::interval
				AND old_sms.sent
			)
	)"
);
*/
?>
