<?php
declare(strict_types=1);

require_once(dirname(__FILE__).'/../Config.php');
require_once(dirname(__FILE__).'/../functions/db_con.php');

/*
 * MAX long-poll worker.
 *
 * Assumptions:
 * - notifications.max_out_messages is an outgoing queue, so this script inserts bot replies there.
 * - Registration / binding is handled only by bot_started payload token flow.
 * - Ordinary inbound text messages from message_created are stored in notifications.max_in_messages.
 */

// require_once __DIR__ . '/bootstrap.php';

const MAX_API_BASE = 'https://platform-api.max.ru';
const MAX_MARKER_FILE = __DIR__ . '/max_updates.marker';
const MAX_LOG_FILE = __DIR__ . '/max_updates.log';
const MAX_LOCK_KEY = 90452001;

const REPLY_BIND_OK = 'Ваш аккаунт MAX успешно привязан.';
const REPLY_BIND_INVALID = 'Код активации недействителен. Запросите новую ссылку.';
const REPLY_BIND_EXPIRED = 'Срок действия кода истёк. Запросите новую ссылку.';
const REPLY_BIND_USED = 'Этот код уже был использован.';
const REPLY_NEED_BIND = 'Чтобы привязать ваш аккаунт MAX, пожалуйста, отправьте свой номер телефона кнопкой ниже.';
const REPLY_PHONE_NOT_FOUND = 'Мы получили ваш номер, но не нашли его в базе контактов. Обратитесь в офис.';
const REPLY_START_WITH_SMS = 'Для привязки откройте ссылку из SMS с кодом активации.';

main();

function main(): void {
	$link = db_con();

	$lock = $link->query_first(
		'SELECT pg_try_advisory_lock($1) AS locked',
		[MAX_LOCK_KEY]
	);

	if (!is_array($lock) || !isset($lock['locked']) || $lock['locked'] !== 't') {
		log_msg('info', 'worker is already running');
		return;
	}

	try {
		$marker = load_marker();

		log_msg('info', 'polling updates', [
			'marker' => $marker,
		]);

		$response = max_api_get_updates(MAX_BOT_TOKEN, $marker);

		$updates = [];
		if (isset($response['updates']) && is_array($response['updates'])) {
			$updates = $response['updates'];
		}

		$nextMarker = isset($response['marker']) ? (string)$response['marker'] : null;

		foreach ($updates as $update) {
			try {
				if (!is_array($update)) {
					continue;
				}

				handle_update($link, $update);
			} catch (Throwable $e) {
				log_msg('error', 'update processing failed', [
					'error' => $e->getMessage(),
					'update' => $update,
				]);
			}
		}

		if ($nextMarker !== null && $nextMarker !== '') {
			save_marker($nextMarker);
		}

		log_msg('info', 'polling done', [
			'updates_count' => count($updates),
			'next_marker' => $nextMarker,
		]);
	} catch (Throwable $e) {
		log_msg('error', 'worker failed', [
			'error' => $e->getMessage(),
			'trace' => $e->getTraceAsString(),
		]);
	} finally {
		try {
			$link->query(
				'SELECT pg_advisory_unlock($1)',
				[MAX_LOCK_KEY]
			);
		} catch (Throwable $e) {
			log_msg('error', 'unlock failed', [
				'error' => $e->getMessage(),
			]);
		}
	}
}

function handle_update($link, array $update): void {
	$updateType = (string)($update['update_type'] ?? '');

	switch ($updateType) {
		case 'bot_started':
			handle_bot_started($link, $update);
			return;

		case 'message_created':
			handle_message_created($link, $update);
			return;

		default:
			log_msg('info', 'update skipped', [
				'update_type' => $updateType,
			]);
			return;
	}
}

function handle_bot_started($link, array $update): void {
	$user = isset($update['user']) && is_array($update['user'])
		? $update['user']
		: [];

	$maxUserId = (int)($user['user_id'] ?? 0);
	$chatId = (int)($update['chat_id'] ?? 0);
	$token = trim((string)($update['payload'] ?? ''));

	if ($maxUserId <= 0 || $chatId <= 0) {
		throw new RuntimeException('bot_started has no valid user_id/chat_id');
	}

	$link->query('BEGIN');

	try {
		if ($token === '') {
			upsert_max_user($link, $user, null);
			queue_outgoing_text($link, $chatId, null, REPLY_START_WITH_SMS);
			$link->query('COMMIT');
			return;
		}

		$activation = $link->query_first(
			"SELECT
				id,
				contact_id,
				token,
				used_at,
				(expires_at <= now()) AS is_expired
			FROM notifications.max_user_activation_tokens
			WHERE token = $1
			FOR UPDATE",
			[$token]
		);

		if (!is_array($activation)) {
			upsert_max_user($link, $user, null);
			queue_outgoing_text($link, $chatId, null, REPLY_BIND_INVALID);
			$link->query('COMMIT');
			return;
		}

		$contactId = isset($activation['contact_id']) ? (int)$activation['contact_id'] : null;
		if ($contactId !== null && $contactId <= 0) {
			$contactId = null;
		}

		if (isset($activation['used_at']) && $activation['used_at'] !== null) {
			upsert_max_user($link, $user, $contactId);
			queue_outgoing_text($link, $chatId, $contactId, REPLY_BIND_USED);
			$link->query('COMMIT');
			return;
		}

		if (($activation['is_expired'] ?? 'f') === 't') {
			upsert_max_user($link, $user, $contactId);
			queue_outgoing_text($link, $chatId, $contactId, REPLY_BIND_EXPIRED);
			$link->query('COMMIT');
			return;
		}

		upsert_max_user($link, $user, $contactId);

		$link->query(
			"UPDATE notifications.max_user_activation_tokens
			SET
				used_at = now(),
				max_user_id = $2,
				max_chat_id = $3,
				raw_bot_started = $4::jsonb
			WHERE id = $1",
			[
				$activation['id'],
				$maxUserId,
				$chatId,
				json_encode($update, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES),
			]
		);

		queue_outgoing_text($link, $chatId, $contactId, REPLY_BIND_OK);

		$link->query('COMMIT');

		log_msg('info', 'user bound by bot_started', [
			'max_user_id' => $maxUserId,
			'chat_id' => $chatId,
			'contact_id' => $contactId,
		]);
	} catch (Throwable $e) {
		$link->query('ROLLBACK');
		throw $e;
	}
}

function handle_message_created($link, array $update): void {
	$message = isset($update['message']) && is_array($update['message'])
		? $update['message']
		: null;

	if (!is_array($message)) {
		return;
	}

	$sender = isset($message['sender']) && is_array($message['sender'])
		? $message['sender']
		: [];

	$maxUserId = (int)($sender['user_id'] ?? 0);
	if ($maxUserId <= 0) {
		return;
	}

	$chatId = extract_chat_id_from_message_update($update);
	$text = extract_message_text($message);
	$sharedPhone = extract_shared_phone_from_message($message);

	$link->query('BEGIN');

	try {
		upsert_max_user($link, $sender, null);

		$userRow = $link->query_first(
			"SELECT
				id,
				contact_id
			FROM notifications.max_users
			WHERE max_user_id = $1
			LIMIT 1",
			[$maxUserId]
		);

		$contactId = null;
		if (is_array($userRow) && isset($userRow['contact_id']) && $userRow['contact_id'] !== null) {
			$contactId = (int)$userRow['contact_id'];
			if ($contactId <= 0) {
				$contactId = null;
			}
		}

		// user is not bound yet and shared phone with bot
		if ($contactId === null && $sharedPhone !== null) {
			$foundContactId = find_contact_id_by_phone($link, $sharedPhone);

			if ($foundContactId !== null) {
				upsert_max_user($link, $sender, $foundContactId);
				$contactId = $foundContactId;

				if ($chatId !== null) {
					queue_outgoing_text($link, $chatId, $contactId, REPLY_BIND_OK);
				}
			} else {
				if ($chatId !== null) {
					queue_outgoing_text($link, $chatId, null, REPLY_PHONE_NOT_FOUND);
				}
			}
		}

		insert_incoming_message($link, $message, $contactId);

		// no binding yet, no phone shared yet -> ask user to share phone
		if ($contactId === null && $sharedPhone === null && $chatId !== null) {
			queue_outgoing_request_contact(
				$link,
				$chatId,
				null,
				REPLY_NEED_BIND,
				'Поделиться телефоном'
			);
		}

		$link->query('COMMIT');

		log_msg('info', 'message stored', [
			'max_user_id' => $maxUserId,
			'chat_id' => $chatId,
			'has_contact_id' => $contactId !== null,
			'shared_phone' => $sharedPhone,
			'text' => $text,
		]);
	} catch (Throwable $e) {
		$link->query('ROLLBACK');
		throw $e;
	}
}

function upsert_max_user($link, array $user, ?int $contactId): void {
	echo "upsert_max_user, contact:".$contactId.PHP_EOL;
	$maxUserId = (int)($user['user_id'] ?? 0);
	if ($maxUserId <= 0) {
		throw new RuntimeException('invalid MAX user_id');
	}

	$username = normalize_nullable_string($user['username'] ?? null);
	$avatarUrl = normalize_nullable_string($user['avatar_url'] ?? null);

	$rawUser = json_encode(
		$user,
		JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES
	);

	$rawUserWithPhoto = null;
	if (array_key_exists('avatar_url', $user) || array_key_exists('full_avatar_url', $user) || array_key_exists('description', $user)) {
		$rawUserWithPhoto = json_encode(
			$user,
			JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES
		);
	}
	$link->query(
		"SELECT notifications.upsert_max_user(
			$1,
			$2,
			$3,
			$4::jsonb,
			$5::jsonb,
			$6
		)",
		[
			$maxUserId,
			$username,
			$avatarUrl,
			$rawUser,
			$rawUserWithPhoto,
			$contactId,
		]
	);
}

function insert_incoming_message($link, array $message, ?int $contactId): void {
	$messageJson = json_encode(
		$message,
		JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES
	);

	$link->query(
		"INSERT INTO notifications.max_in_messages_write (
			message,
			contact_id,
			app_id
		)
		VALUES (
			$1::jsonb,
			$2,
			$3
		)",
		[
			$messageJson,
			$contactId,
			MS_APP_ID,
		]
	);
}

function queue_outgoing_text($link, int $chatId, ?int $contactId, string $text): void {
	$message = json_encode(
		[
			'text' => $text,
		],
		JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES
	);

	$link->query(
		"INSERT INTO notifications.max_out_messages_write (
			message,
			max_chat_id,
			contact_id,
			app_id
		)
		VALUES (
			$1::jsonb,
			$2,
			$3,
			$4
		)",
		[
			$message,
			$chatId,
			$contactId,
			MS_APP_ID,
		]
	);
}

function extract_chat_id_from_message_update(array $update): ?int {
	if (isset($update['chat_id']) && (int)$update['chat_id'] > 0) {
		return (int)$update['chat_id'];
	}

	$message = isset($update['message']) && is_array($update['message'])
		? $update['message']
		: [];

	$recipient = isset($message['recipient']) && is_array($message['recipient'])
		? $message['recipient']
		: [];

	if (isset($recipient['chat_id']) && (int)$recipient['chat_id'] > 0) {
		return (int)$recipient['chat_id'];
	}

	/*
	 * Fallback only if chat_id is absent in payload.
	 * In direct dialogs this may still be enough for your downstream sender logic,
	 * but ideally MAX should provide chat_id in recipient/update.
	 */
	if (isset($message['sender']['user_id']) && (int)$message['sender']['user_id'] > 0) {
		return (int)$message['sender']['user_id'];
	}

	return null;
}

function max_api_get_updates(string $token, ?string $marker): array {
	$params = [
		'limit' => 100,
		'timeout' => 30,
		'types' => 'bot_started,message_created',
	];

	if ($marker !== null && $marker !== '') {
		$params['marker'] = $marker;
	}

	$url = MAX_API_BASE . '/updates?' . http_build_query($params);

	$ch = curl_init($url);
	if ($ch === false) {
		throw new RuntimeException('curl_init failed');
	}

	curl_setopt_array($ch, [
		CURLOPT_RETURNTRANSFER => true,
		CURLOPT_HTTPHEADER => [
			'Authorization: ' . $token,
			'Accept: application/json',
		],
		CURLOPT_CONNECTTIMEOUT => 10,
		CURLOPT_TIMEOUT => 40,
		CURLOPT_FAILONERROR => false,
	]);

	$body = curl_exec($ch);
	if ($body === false) {
		$error = curl_error($ch);
		curl_close($ch);
		throw new RuntimeException('MAX API request failed: ' . $error);
	}

	$httpCode = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
	curl_close($ch);

	if ($httpCode < 200 || $httpCode >= 300) {
		throw new RuntimeException('MAX API HTTP ' . $httpCode . ': ' . $body);
	}

	$data = json_decode($body, true);
	if (!is_array($data)) {
		throw new RuntimeException('MAX API returned invalid JSON: ' . $body);
	}

	return $data;
}

function load_marker(): ?string {
	if (!is_file(MAX_MARKER_FILE)) {
		return null;
	}

	$marker = trim((string)file_get_contents(MAX_MARKER_FILE));
	if ($marker === '') {
		return null;
	}

	return $marker;
}

function save_marker(string $marker): void {
	file_put_contents(MAX_MARKER_FILE, $marker . PHP_EOL, LOCK_EX);
}

function normalize_nullable_string($value): ?string {
	if ($value === null) {
		return null;
	}

	$value = trim((string)$value);
	return $value === '' ? null : $value;
}

function log_msg(string $level, string $message, array $context = []): void {
	$line = sprintf(
		"[%s] [%s] %s%s",
		date('Y-m-d H:i:s'),
		strtoupper($level),
		$message,
		$context ? ' ' . json_encode($context, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES) : ''
	);

	error_log($line);

	file_put_contents(
		MAX_LOG_FILE,
		$line . PHP_EOL,
		FILE_APPEND | LOCK_EX
	);
}

function extract_message_text(array $message): string {
	$body = isset($message['body']) && is_array($message['body'])
		? $message['body']
		: [];

	return trim((string)($body['text'] ?? ''));
}

function extract_shared_phone_from_message(array $message): ?string {
	$body = isset($message['body']) && is_array($message['body'])
		? $message['body']
		: [];

	$attachments = isset($body['attachments']) && is_array($body['attachments'])
		? $body['attachments']
		: [];

	foreach ($attachments as $attachment) {
		if (!is_array($attachment)) {
			continue;
		}

		$type = (string)($attachment['type'] ?? '');
		if ($type !== 'contact') {
			continue;
		}

		$payload = isset($attachment['payload']) && is_array($attachment['payload'])
			? $attachment['payload']
			: [];

		$candidates = [
			$payload['phone'] ?? null,
			$payload['tel'] ?? null,
			$payload['vcf_phone'] ?? null,
		];

		foreach ($candidates as $candidate) {
			$phone = normalize_phone($candidate);
			if ($phone !== null) {
				return $phone;
			}
		}

		$vcfInfo = $payload['vcf_info'] ?? null;
		if (is_string($vcfInfo) && $vcfInfo !== '') {
			$phone = extract_phone_from_vcf($vcfInfo);
			if ($phone !== null) {
				return $phone;
			}
		}
	}

	return null;
}

function extract_phone_from_vcf(string $vcfInfo): ?string {
	$lines = preg_split('/\r\n|\r|\n/', $vcfInfo);
	if (!is_array($lines)) {
		return null;
	}

	foreach ($lines as $line) {
		$line = trim($line);

		if (!preg_match('/^TEL/i', $line)) {
			continue;
		}

		$pos = strrpos($line, ':');
		if ($pos === false) {
			continue;
		}

		$rawPhone = substr($line, $pos + 1);
		$phone = normalize_phone($rawPhone);
		if ($phone !== null) {
			return $phone;
		}
	}

	return null;
}

function normalize_phone($phone): ?string {
	if (!is_string($phone) || trim($phone) === '') {
		return null;
	}

	$digits = preg_replace('/\D+/', '', $phone);
	if (!is_string($digits) || $digits === '') {
		return null;
	}

	// RU normalization
	if (strlen($digits) === 10) {
		$digits = '7' . $digits;
	} elseif (strlen($digits) === 11 && $digits[0] === '8') {
		$digits = '7' . substr($digits, 1);
	}

	if (strlen($digits) < 10 || strlen($digits) > 15) {
		return null;
	}

	return $digits;
}

function find_contact_id_by_phone($link, string $phone): ?int {
	if(substr($phone, 0, 1) == "7"){
		$phone =  substr($phone, 1);
	}
	$row = $link->query_first(
		"SELECT id
		FROM public.contacts
		WHERE tel = $1
		LIMIT 1",
		[$phone]
	);

	if (!is_array($row) || !isset($row['id'])) {
		return null;
	}

	$id = (int)$row['id'];
	return $id > 0 ? $id : null;
}

function queue_outgoing_request_contact(
	$link,
	int $chatId,
	?int $contactId,
	string $text,
	string $buttonText
): void {
	$message = json_encode(
		[
			'text' => $text,
			'attachments' => [
				[
					'type' => 'inline_keyboard',
					'payload' => [
						'buttons' => [
							[
								[
									'type' => 'request_contact',
									'text' => $buttonText,
								],
							],
						],
					],
				],
			],
		],
		JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES
	);

	$link->query(
		"INSERT INTO notifications.max_out_messages_write (
			message,
			max_chat_id,
			contact_id,
			app_id
		)
		VALUES (
			$1::jsonb,
			$2,
			$3,
			$4
		)",
		[
			$message,
			$chatId,
			$contactId,
			MS_APP_ID
		]
	);
}
