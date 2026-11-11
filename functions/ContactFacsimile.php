<?php

/** Facsimile editing is kept outside generated controllers. Requires PHP 7.4+. */
class ContactFacsimile {
	public static function get($controller, $pm) {
		$row = self::load($controller->getDbLinkMaster(), self::contactId($controller, $pm), self::contentId($controller, $pm));
		$source = pg_unescape_bytea($row['content_data']);
		$image = self::normalize($source);
		return self::model($image, self::info($row)['name'], hash('sha256', $source));
	}

	public static function process($controller, $pm) {
		$link = $controller->getDbLinkMaster();
		$contactId = self::contactId($controller, $pm);
		$contentId = self::contentId($controller, $pm);
		$sourceHash = (string)$controller->getExtVal($pm, 'source_hash');
		if (!preg_match('/^[a-f0-9]{64}$/D', $sourceHash)) {
			throw new Exception('Некорректная версия факсимиле. Откройте редактор заново.');
		}
		$row = self::load($link, $contactId, $contentId);
		$source = pg_unescape_bytea($row['content_data']);
		self::checkHash($sourceHash, $source);
		$options = [];
		foreach (['x', 'y', 'width', 'height', 'output_width', 'output_height', 'fuzz'] as $field) {
			$options[$field] = $controller->getExtVal($pm, $field);
		}
		$options['rotation'] = $controller->getExtVal($pm, 'rotation');
		$options['background_color'] = $controller->getExtVal($pm, 'background_color');
		$options['remove_background'] = self::boolean($controller->getExtVal($pm, 'remove_background'));
		$save = self::boolean($controller->getExtVal($pm, 'save'));
		$image = self::render($source, $options);
		$info = self::info($row);
		$info['name'] = self::pngName($info['name']);
		$info['size'] = strlen($image);
		if ($save) {
			$preview = self::thumbnail($image);
			$link->query('BEGIN');
			try {
				$locked = self::load($link, $contactId, $contentId, TRUE);
				self::checkHash($sourceHash, pg_unescape_bytea($locked['content_data']));
				// Preserve any additional attachment metadata changed while the image was processed.
				$info = self::info($locked);
				$info['name'] = self::pngName($info['name']);
				$info['size'] = strlen($image);
				$link->query(
					'UPDATE attachments SET content_info = $1, content_data = $2, content_preview = $3 WHERE id = $4',
					[
						json_encode($info, JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR),
						pg_escape_bytea($link->link_id, $image),
						pg_escape_bytea($link->link_id, $preview),
						$locked['id'],
					]
				);
				$link->query('COMMIT');
			} catch (Throwable $error) {
				$link->query('ROLLBACK');
				throw $error;
			}
			$cache = OUTPUT_PATH.md5('attachment_'.$locked['id']);
			if (is_file($cache) && !unlink($cache)) {
				error_log('Could not invalidate cached contact facsimile: '.$locked['id']);
			}
			$sourceHash = hash('sha256', $image);
		}
		return self::model($image, $info['name'], $sourceHash);
	}

	private static function contactId($controller, $pm) {
		$id = self::integer($controller->getExtVal($pm, 'id'), 1, PHP_INT_MAX, 'контакт');
		return $id;
	}

	private static function contentId($controller, $pm) {
		$id = (string)$controller->getExtVal($pm, 'content_id');
		if ($id === '' || strlen($id) > 128) {
			throw new Exception('Некорректный идентификатор факсимиле.');
		}
		return $id;
	}

	private static function load($link, $contactId, $contentId, $lock = FALSE) {
		$row = $link->query_first(
			"SELECT id, content_info, content_data FROM attachments
			WHERE ref->>'dataType' = 'contacts'
				AND ref->'keys'->>'id' = $1
				AND content_info->>'id' = $2".($lock ? ' FOR UPDATE' : ''),
			[(string)$contactId, $contentId]
		);
		if (!is_array($row) || !isset($row['id'], $row['content_data'], $row['content_info'])) {
			throw new Exception('Факсимиле не найдено. Обновите карточку контакта.');
		}
		return $row;
	}

	private static function info($row) {
		$info = json_decode($row['content_info'], TRUE);
		if (!is_array($info) || !isset($info['id'], $info['name'])) {
			throw new Exception('Некорректные данные вложения.');
		}
		return $info;
	}

	private static function checkHash($expected, $source) {
		if (!hash_equals($expected, hash('sha256', $source))) {
			throw new Exception('Факсимиле уже изменено. Откройте редактор заново.');
		}
	}

	private static function boolean($value) {
		return $value === TRUE || $value === 1 || $value === '1' || $value === 'true';
	}

	private static function integer($value, $min, $max, $name) {
		if (filter_var($value, FILTER_VALIDATE_INT) === FALSE || $value < $min || $value > $max) {
			throw new Exception('Недопустимое значение: '.$name.'.');
		}
		return (int)$value;
	}

	private static function pngName($name) {
		$stem = pathinfo(basename(str_replace('\\', '/', (string)$name)), PATHINFO_FILENAME);
		return ($stem === '' ? 'facsimile' : $stem).'.png';
	}

	private static function dimensions($data) {
		$info = @getimagesizefromstring($data);
		if (!$info || !in_array($info[2], [IMAGETYPE_JPEG, IMAGETYPE_PNG], TRUE)) {
			throw new Exception('Для факсимиле допустимы только изображения JPEG и PNG.');
		}
		if ($info[0] < 1 || $info[1] < 1 || $info[0] > 16000 || $info[1] > 16000 || $info[0] * $info[1] > 16000000) {
			throw new Exception('Изображение слишком большое: допускается не более 16 млн пикселей.');
		}
		return $info;
	}

	/** Decode and orient the original once, so browser and server use identical crop coordinates. */
	public static function normalize($source) {
		if (strlen($source) > 8 * 1024 * 1024) {
			throw new Exception('Размер изображения превышает 8 МБ.');
		}
		$info = self::dimensions($source);
		return self::convert($source, $info[2] === IMAGETYPE_PNG ? 'PNG' : 'JPEG', ['-auto-orient', '+repage']);
	}

	public static function render($source, array $options) {
		$image = self::normalize($source);
		$size = self::dimensions($image);
		$rotation = self::integer(isset($options['rotation']) ? $options['rotation'] : 0, 0, 270, 'поворот');
		if (!in_array($rotation, [0, 90, 180, 270], TRUE)) {
			throw new Exception('Допустим поворот на 0, 90, 180 или 270 градусов.');
		}
		$backgroundColor = isset($options['background_color']) ? $options['background_color'] : '#ffffff';
		if (!is_string($backgroundColor) || !preg_match('/^#[a-fA-F0-9]{6}$/D', $backgroundColor)) {
			throw new Exception('Недопустимый цвет фона. Используйте формат #rrggbb.');
		}
		if ($rotation === 90 || $rotation === 270) {
			$size = [$size[1], $size[0]];
		}
		$x = self::integer($options['x'], 0, $size[0] - 1, 'левая граница');
		$y = self::integer($options['y'], 0, $size[1] - 1, 'верхняя граница');
		$width = self::integer($options['width'], 1, $size[0] - $x, 'ширина области');
		$height = self::integer($options['height'], 1, $size[1] - $y, 'высота области');
		$outputWidth = self::integer($options['output_width'], 1, 4096, 'ширина результата');
		$outputHeight = self::integer($options['output_height'], 1, 4096, 'высота результата');
		if ($outputWidth * $outputHeight > 8000000) {
			throw new Exception('Результат превышает 8 млн пикселей.');
		}
		// Either side may be edited; the other must be its nearest proportional pixel.
		$heightForWidth = max(1, (int)round($height * $outputWidth / $width));
		$widthForHeight = max(1, (int)round($width * $outputHeight / $height));
		if ($outputHeight !== $heightForWidth && $outputWidth !== $widthForHeight) {
			throw new Exception('Размер результата должен сохранять пропорции выделенной области.');
		}
		$fuzz = self::integer($options['fuzz'], 0, 30, 'допуск удаления фона');
		// Crop coordinates belong to the complete clockwise-rotated image shown in the editor.
		$args = $rotation === 0 ? [] : ['-rotate', (string)$rotation, '+repage'];
		$args = array_merge($args, ['-crop', $width.'x'.$height.'+'.$x.'+'.$y, '+repage']);
		if (!empty($options['remove_background'])) {
			$args = array_merge($args, ['-alpha', 'set', '-fuzz', $fuzz.'%', '-transparent', $backgroundColor]);
		}
		// The pair is validated above; force these exact rounded pixel dimensions.
		$args = array_merge($args, ['-resize', $outputWidth.'x'.$outputHeight.'!']);
		$result = self::convert($image, 'PNG', $args);
		if (strlen($result) > 8 * 1024 * 1024) {
			throw new Exception('Размер результата превышает 8 МБ. Уменьшите размер факсимиле.');
		}
		return $result;
	}

	private static function thumbnail($image) {
		return self::convert($image, 'PNG', ['-thumbnail', '250x100>']);
	}

	private static function model($image, $name, $sourceHash) {
		require_once(FRAME_WORK_PATH.'basic_classes/ModelVars.php');
		$size = self::dimensions($image);
		return new ModelVars([
			'id' => 'Facsimile_Model',
			'values' => [
				new Field('data_base64', DT_STRING, ['value' => base64_encode($image)]),
				new Field('mime_type', DT_STRING, ['value' => 'image/png']),
				new Field('name', DT_STRING, ['value' => $name]),
				new Field('width', DT_INT, ['value' => $size[0]]),
				new Field('height', DT_INT, ['value' => $size[1]]),
				new Field('size', DT_INT, ['value' => strlen($image)]),
				new Field('source_hash', DT_STRING, ['value' => $sourceHash]),
			],
		]);
	}

	private static function convert($source, $format, array $operations) {
		$binary = defined('FACSIMILE_IMAGEMAGICK_BINARY') ? FACSIMILE_IMAGEMAGICK_BINARY : '';
		if ($binary === '' || $binary[0] !== '/' || !is_executable($binary)) {
			throw new Exception('Редактор факсимиле недоступен: настройте FACSIMILE_IMAGEMAGICK_BINARY в Config.php.');
		}
		$input = tempnam(sys_get_temp_dir(), 'facsimile-in-');
		$output = tempnam(sys_get_temp_dir(), 'facsimile-out-');
		if ($input === FALSE || $output === FALSE) {
			if ($input !== FALSE) { unlink($input); }
			if ($output !== FALSE) { unlink($output); }
			throw new Exception('Не удалось создать временный файл факсимиле.');
		}
		try {
			if (file_put_contents($input, $source) !== strlen($source)) {
				throw new Exception('Не удалось записать временный файл факсимиле.');
			}
			$command = array_merge([
				$binary,
				'-limit', 'memory', '128MiB',
				'-limit', 'map', '256MiB',
				'-limit', 'disk', '256MiB',
				'-limit', 'time', '20',
				$format.':'.$input.'[0]',
			], $operations, ['-strip', 'PNG32:'.$output]);
			self::run($command);
			$image = file_get_contents($output);
			if ($image === FALSE || $image === '' || strlen($image) > 32 * 1024 * 1024) {
				throw new Exception('Не удалось обработать изображение факсимиле.');
			}
			self::dimensions($image);
			return $image;
		} finally {
			unlink($input);
			unlink($output);
		}
	}

	private static function run(array $command) {
		$process = proc_open($command, [0 => ['pipe', 'r'], 1 => ['pipe', 'w'], 2 => ['pipe', 'w']], $pipes);
		if (!is_resource($process)) {
			throw new Exception('Не удалось запустить ImageMagick.');
		}
		fclose($pipes[0]);
		stream_set_blocking($pipes[1], FALSE);
		stream_set_blocking($pipes[2], FALSE);
		$started = microtime(TRUE);
		$diagnostic = '';
		$timedOut = FALSE;
		$exitCode = -1;
		try {
			do {
				stream_get_contents($pipes[1]);
				$diagnostic = substr($diagnostic.stream_get_contents($pipes[2]), -8192);
				$status = proc_get_status($process);
				if (!$status['running']) {
					$exitCode = $status['exitcode'];
					break;
				}
				if (microtime(TRUE) - $started > 25) {
					$timedOut = TRUE;
					proc_terminate($process, 9);
					break;
				}
				usleep(20000);
			} while (TRUE);
			$diagnostic = substr($diagnostic.stream_get_contents($pipes[2]), -8192);
		} finally {
			fclose($pipes[1]);
			fclose($pipes[2]);
			$closedCode = proc_close($process);
		}
		if ($exitCode < 0) { $exitCode = $closedCode; }
		if ($timedOut || $exitCode !== 0) {
			error_log('Facsimile ImageMagick error: '.$diagnostic);
			throw new Exception($timedOut ? 'Превышено время обработки факсимиле.' : 'Не удалось обработать изображение факсимиле. Проверьте файл и настройки ImageMagick.');
		}
	}
}
