<?php if (!isset($page, $title)) { http_response_code(404); exit; } ?>
<!doctype html>
<html lang="ru">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
	<meta name="robots" content="noindex, nofollow">
	<meta name="theme-color" content="#132d46">
	<meta name="description" content="<?= route_escape($title) ?>">
	<title><?= route_escape($title) ?></title>
	<link rel="icon" href="favicon.ico">
	<link rel="stylesheet" href="<?= route_escape($olCss) ?>">
	<link rel="stylesheet" href="<?= route_escape(route_asset('assets/route.css', (string) filemtime(__DIR__.'/../assets/route.css'))) ?>">
	<script defer src="<?= route_escape($olJs) ?>"></script>
<?php foreach ($scripts as $script): ?>
	<script defer src="<?= route_escape(route_asset((string) $script, $version)) ?>"></script>
<?php endforeach; ?>
	<script defer src="<?= route_escape(route_asset('assets/route.js', $appVersion)) ?>"></script>
</head>
<body>
	<main class="app">
		<header class="summary">
			<div class="vehicle">
				<img class="vehicle-icon" src="img/mixer.png" alt="" width="38" height="38">
				<div>
					<p class="eyebrow">Отслеживание доставки <span>· № <?= $request['id'] ?></span></p>
					<h1><?= route_escape($page['vehiclePlate'] !== '' ? $page['vehiclePlate'] : 'Миксер') ?></h1>
				</div>
			</div>
			<div class="metrics">
				<div class="metric"><span class="metric-label">До объекта</span><strong id="distance">—</strong></div>
				<div class="metric"><span class="metric-label">Последняя позиция</span><strong id="position-time" class="time">—</strong></div>
			</div>
		</header>
		<section class="toolbar" aria-label="Управление картой">
			<div class="actions">
				<button id="find-vehicle" class="button primary" type="button" disabled>Найти машину</button>
				<button id="fit-route" class="button" type="button" disabled>Весь маршрут</button>
				<button id="follow-vehicle" class="button follow" type="button" aria-pressed="false" disabled><span class="follow-dot" aria-hidden="true"></span>Следить</button>
			</div>
			<div class="live-state">
				<span id="live-status" class="status" data-kind="waiting" role="status">Ожидание обновлений</span>
				<button id="reload-page" class="text-button" type="button" title="Загрузить свежие данные и подключиться заново">Обновить страницу</button>
			</div>
		</section>
		<div id="notice" class="notice" role="status" data-scope="route"<?= $routeWarning === null ? ' hidden' : '' ?>><?= route_escape($routeWarning ?? '') ?></div>
		<div id="tiles-notice" class="notice" role="status" hidden>Не удалось загрузить часть карты. Проверьте подключение к интернету.</div>
<?php if ($page['locationEnabled']): ?>
		<section id="location-panel" class="location-panel">
			<p>Вы уже на объекте? Передайте водителю точное место разгрузки.</p>
			<button id="share-location" class="button compact" type="button" disabled>Я на объекте</button>
		</section>
<?php endif; ?>
		<section class="map-shell" aria-label="Карта маршрута">
			<div id="map" class="map" tabindex="0" aria-label="Карта. Для перемещения используйте мышь, жесты или клавиши со стрелками."></div>
			<div id="map-message" class="map-message"><p>Открываем карту…</p></div>
			<noscript><div class="map-message">Для просмотра маршрута включите JavaScript в браузере.</div></noscript>
		</section>
		<footer class="footer"><span><i class="legend-route" aria-hidden="true"></i>Оставшийся маршрут</span><span><i class="legend-destination" aria-hidden="true"></i>Объект</span><span class="footer-note">Перемещение карты отключает слежение за машиной</span></footer>
	</main>
	<script id="route-config" type="application/json"><?= route_json($page) ?></script>
</body>
</html>
