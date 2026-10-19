<?php
/** Shared, framework-independent helpers. PHP 7.4+. */
class RouteYandexError extends RuntimeException
{
	public $status;

	public function __construct(string $message, int $status = 400)
	{
		parent::__construct($message);
		$this->status = $status;
	}
}

function route_option(string $name, $default = null)
{
	return defined($name) ? constant($name) : $default;
}

function route_bool($value): bool
{
	return $value === true || $value === 1 || $value === '1' || $value === 't' || $value === 'true';
}

function route_id($value): int
{
	if (!is_string($value) && !is_int($value)) {
		throw new RouteYandexError('Неверная ссылка.', 400);
	}
	$text = (string) $value;
	if (!preg_match('/^[1-9][0-9]{0,9}$/D', $text) || (float) $text > 2147483647) {
		throw new RouteYandexError('Неверная ссылка.', 400);
	}
	return (int) $text;
}

/** Supports ?123, ?m123, ?id=123 and ?id=m123. No loose intval() parsing. */
function route_request(array $query): array
{
	if (count($query) !== 1) {
		throw new RouteYandexError('Неверная ссылка.', 400);
	}
	if (array_key_exists('id', $query)) {
		$value = $query['id'];
	} else {
		$key = array_keys($query)[0];
		if ($query[$key] !== '') {
			throw new RouteYandexError('Неверная ссылка.', 400);
		}
		$value = (string) $key;
	}
	if (!is_string($value) && !is_int($value)) {
		throw new RouteYandexError('Неверная ссылка.', 400);
	}
	$value = (string) $value;
	$isClient = substr($value, 0, 1) !== 'm';
	return array('id' => route_id($isClient ? $value : substr($value, 1)), 'isClient' => $isClient);
}

function route_number($value): ?float
{
	if ((!is_int($value) && !is_float($value) && !is_string($value)) || !is_numeric($value)) {
		return null;
	}
	$number = (float) $value;
	return is_finite($number) ? $number : null;
}

function route_coordinates($lon, $lat): ?array
{
	$lon = route_number($lon);
	$lat = route_number($lat);
	if ($lon === null || $lat === null || abs($lon) > 180 || abs($lat) > 90) {
		return null;
	}
	return array($lon, $lat);
}

function route_json($value): string
{
	$json = json_encode($value, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES |
		JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_INVALID_UTF8_SUBSTITUTE);
	if ($json === false) {
		throw new RuntimeException('Cannot encode route response.');
	}
	return $json;
}

function route_decode($value)
{
	if (is_array($value)) {
		return $value;
	}
	return is_string($value) ? json_decode($value, true) : null;
}

function route_escape($value): string
{
	return htmlspecialchars((string) $value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

function route_headers(): void
{
	header('Cache-Control: no-store, private');
	header('X-Content-Type-Options: nosniff');
	header('X-Frame-Options: SAMEORIGIN');
	// Preserve Yandex domain-key checks without sending the shipment ID in the Referer.
	header('Referrer-Policy: origin');
	header('X-Robots-Tag: noindex, nofollow, noarchive');
}

function route_reply(array $data, int $status = 200): void
{
	route_headers();
	http_response_code($status);
	header('Content-Type: application/json; charset=UTF-8');
	echo route_json($data);
}

function route_error(Throwable $error, bool $json = false): void
{
	$status = $error instanceof RouteYandexError ? $error->status : 500;
	$message = $error instanceof RouteYandexError ? $error->getMessage() : 'Не удалось загрузить маршрут. Попробуйте обновить страницу.';
	if (!($error instanceof RouteYandexError)) {
		error_log('[yandex-route] '.$error->getMessage());
	}
	if (session_status() === PHP_SESSION_ACTIVE) {
		session_write_close();
	}
	if ($json) {
		route_reply(array('error' => $message), $status);
		return;
	}
	route_headers();
	http_response_code($status);
	header('Content-Type: text/html; charset=UTF-8');
	require __DIR__.'/../templates/error.php';
}

function route_method(string $method): void
{
	if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== $method) {
		header('Allow: '.$method);
		throw new RouteYandexError('Недопустимый метод запроса.', 405);
	}
}

function route_https(): bool
{
	$https = strtolower((string) ($_SERVER['HTTPS'] ?? ''));
	return ($https !== '' && $https !== 'off' && $https !== '0') ||
		($_SERVER['REQUEST_SCHEME'] ?? '') === 'https' || (int) ($_SERVER['SERVER_PORT'] ?? 0) === 443;
}

function route_asset(string $path, string $version): string
{
	return $path.(strpos($path, '?') === false ? '?' : '&').'v='.rawurlencode($version);
}
