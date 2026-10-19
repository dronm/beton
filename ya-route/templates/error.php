<?php if (!isset($message, $status)) { http_response_code(404); exit; } ?>
<!doctype html>
<html lang="ru">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="robots" content="noindex, nofollow">
	<title><?= route_escape($message) ?></title>
	<link rel="icon" href="favicon.ico">
	<link rel="stylesheet" href="assets/route.css">
</head>
<body class="error-page">
	<main class="error-card">
		<img src="img/mixer.png" alt="" width="38" height="38">
		<p class="eyebrow">Отслеживание доставки</p>
		<h1><?= route_escape($message) ?></h1>
		<p><?= $status === 500 ? 'Если ошибка повторяется, обратитесь к диспетчеру.' : 'Проверьте ссылку из сообщения или обратитесь к диспетчеру.' ?></p>
	</main>
</body>
</html>
