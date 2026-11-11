<?php

/** php tests/contact-facsimile.test.php; requires ImageMagick, PHP 7.4+ and zlib. */
$binary = getenv('FACSIMILE_TEST_BINARY') ?: '/usr/bin/convert';
define('FACSIMILE_IMAGEMAGICK_BINARY', $binary);
$testDirectory = sys_get_temp_dir().'/contact-facsimile-test-'.bin2hex(random_bytes(8));
mkdir($testDirectory, 0700);
mkdir($testDirectory.'/basic_classes');
mkdir($testDirectory.'/output');
define('FRAME_WORK_PATH', $testDirectory.'/');
define('OUTPUT_PATH', $testDirectory.'/output/');
define('DT_STRING', 'string');
define('DT_INT', 'int');
file_put_contents($testDirectory.'/basic_classes/ModelVars.php', '<?php');

// No application/database bootstrap is needed for image and transaction regression tests.
class Field {
	public $id;
	public $value;
	public function __construct($id, $type, $options) {
		$this->id = $id;
		$this->value = $options['value'];
	}
}
class ModelVars {
	public $values = [];
	public function __construct($options) {
		foreach ($options['values'] as $field) { $this->values[$field->id] = $field->value; }
	}
}
// A codec shim belongs to this fake database only; run tests with PHP -n if pgsql is installed.
if (function_exists('pg_unescape_bytea') || function_exists('pg_escape_bytea')) {
	fwrite(STDERR, "Run this isolated test with php -n (pgsql must not be loaded).\n");
	exit(1);
} else {
	function pg_unescape_bytea($data) { return $data; }
	function pg_escape_bytea($connection, $data) { return $data; }
}

require_once(__DIR__.'/../functions/ContactFacsimile.php');

function check($condition, $message) {
	if (!$condition) { throw new Exception($message); }
}
function rejects($callback, $message) {
	try { $callback(); } catch (Exception $error) { return; }
	throw new Exception($message);
}
function pngChunk($type, $data) {
	return pack('N', strlen($data)).$type.$data.pack('N', crc32($type.$data));
}
function fixture($width = 80, $height = 40, $background = [255, 255, 255, 255]) {
	$rows = '';
	for ($y = 0; $y < $height; $y++) {
		$rows .= "\0";
		for ($x = 0; $x < $width; $x++) {
			$pixel = $x >= 20 && $x < 60 && $y >= 10 && $y < 30 ? "\0\0\0\xff" : pack('C4', ...$background);
			if ($x === 2 && $y === 2) { $pixel = "\x14\x1e\x28\x40"; }
			$rows .= $pixel;
		}
	}
	return "\x89PNG\r\n\x1a\n".pngChunk('IHDR', pack('NNCCCCC', $width, $height, 8, 6, 0, 0, 0)).pngChunk('IDAT', gzcompress($rows)).pngChunk('IEND', '');
}
function asymmetricFixture() {
	$colors = [
		[255, 0, 0, 255], [0, 255, 0, 255], [0, 0, 255, 255],
		[255, 255, 0, 255], [0, 255, 255, 255], [255, 0, 255, 64],
	];
	$rows = '';
	foreach (array_chunk($colors, 3) as $row) {
		$rows .= "\0";
		foreach ($row as $color) { $rows .= pack('C4', ...$color); }
	}
	return "\x89PNG\r\n\x1a\n".pngChunk('IHDR', pack('NNCCCCC', 3, 2, 8, 6, 0, 0, 0)).pngChunk('IDAT', gzcompress($rows)).pngChunk('IEND', '');
}
function rgba($image) {
	$process = proc_open([FACSIMILE_IMAGEMAGICK_BINARY, 'PNG:-', '-depth', '8', 'RGBA:-'], [0 => ['pipe', 'r'], 1 => ['pipe', 'w'], 2 => ['pipe', 'w']], $pipes);
	fwrite($pipes[0], $image);
	fclose($pipes[0]);
	$result = stream_get_contents($pipes[1]);
	$error = stream_get_contents($pipes[2]);
	fclose($pipes[1]);
	fclose($pipes[2]);
	check(proc_close($process) === 0, 'Pixel inspection failed: '.$error);
	return $result;
}
function pixel($bytes, $width, $x, $y) {
	return array_values(unpack('C4', substr($bytes, ($y * $width + $x) * 4, 4)));
}
class FakeFacsimileDb {
	public $link_id = NULL;
	public $row;
	public $events = [];
	public $conflictOnLock = FALSE;
	public $failUpdate = FALSE;
	private $snapshot;
	public function __construct($image) {
		$this->row = ['id' => 7, 'content_info' => json_encode(['id' => '1', 'name' => 'signature.jpg', 'size' => strlen($image), 'other' => 'keep']), 'content_data' => $image];
	}
	public function query_first($sql, $params) {
		check(strpos($sql, "ref->>'dataType' = 'contacts'") !== FALSE, 'Missing contact datatype scope');
		check(strpos($sql, "ref->'keys'->>'id' = $1") !== FALSE, 'Missing contact id scope');
		check(strpos($sql, "content_info->>'id' = $2") !== FALSE, 'Missing content id scope');
		$this->events[] = strpos($sql, 'FOR UPDATE') !== FALSE ? 'LOCK' : 'LOAD';
		if ($params !== ['42', '1']) { return FALSE; }
		if ($this->conflictOnLock && strpos($sql, 'FOR UPDATE') !== FALSE) { $this->row['content_data'] .= 'changed'; }
		return $this->row;
	}
	public function query($sql, $params = NULL) {
		$this->events[] = $sql;
		if ($sql === 'BEGIN') { $this->snapshot = $this->row; }
		if ($sql === 'ROLLBACK') { $this->row = $this->snapshot; }
		if (strpos($sql, 'UPDATE attachments') === 0) {
			if ($this->failUpdate) { throw new Exception('Simulated DB failure'); }
			check($params[3] === 7, 'Saved the wrong attachment');
			$this->row['content_info'] = $params[0];
			$this->row['content_data'] = $params[1];
			$this->row['content_preview'] = $params[2];
		}
	}
}
class FakeFacsimileController {
	public $db;
	public function __construct($db) { $this->db = $db; }
	public function getDbLinkMaster() { return $this->db; }
	public function getExtVal($pm, $field) { return isset($pm[$field]) ? $pm[$field] : NULL; }
}

try {
	$source = fixture();
	$options = ['x' => 20, 'y' => 10, 'width' => 40, 'height' => 20, 'output_width' => 80, 'output_height' => 40, 'fuzz' => 10, 'remove_background' => FALSE];
	$image = ContactFacsimile::render($source, $options);
	check(array_slice(getimagesizefromstring($image), 0, 2) === [80, 40], 'Crop/enlargement dimensions differ');
	check(pixel(rgba($image), 80, 40, 20) === [0, 0, 0, 255], 'Crop included margins or changed signature pixels');
	$rounded = ContactFacsimile::render(fixture(450, 100), array_merge($options, ['x' => 0, 'y' => 0, 'width' => 450, 'height' => 100, 'output_width' => 100, 'output_height' => 22]));
	check(array_slice(getimagesizefromstring($rounded), 0, 2) === [100, 22], 'Rounded resize did not preserve requested pixel dimensions');
	$heightDriven = ContactFacsimile::render(fixture(100, 450), array_merge($options, ['x' => 0, 'y' => 0, 'width' => 100, 'height' => 450, 'output_width' => 22, 'output_height' => 100]));
	check(array_slice(getimagesizefromstring($heightDriven), 0, 2) === [22, 100], 'Height-driven rounded resize dimensions differ');
	$thin = fixture(1000, 1);
	$thinOptions = array_merge($options, ['x' => 0, 'y' => 0, 'width' => 1000, 'height' => 1, 'output_width' => 2000, 'output_height' => 2]);
	check(array_slice(getimagesizefromstring(ContactFacsimile::render($thin, $thinOptions)), 0, 2) === [2000, 2], 'Thin crop proportional enlargement failed');
	rejects(function() use ($thin, $thinOptions) { ContactFacsimile::render($thin, array_merge($thinOptions, ['output_height' => 1])); }, 'Thin crop distortion accepted');
	$whole = array_merge($options, ['x' => 0, 'y' => 0, 'width' => 80, 'height' => 40]);
	$opaque = rgba(ContactFacsimile::render($source, $whole));
	check(pixel($opaque, 80, 0, 0)[3] === 255, 'White background changed without request');
	check(pixel($opaque, 80, 2, 2)[3] === 64, 'Existing alpha was not preserved');
	$transparent = rgba(ContactFacsimile::render($source, array_merge($whole, ['remove_background' => TRUE])));
	check(pixel($transparent, 80, 0, 0)[3] === 0, 'White background was not made transparent');
	check(pixel($transparent, 80, 40, 20)[3] === 255, 'Signature ink became transparent');
	check(pixel($transparent, 80, 2, 2)[3] === 64, 'Existing alpha changed during background removal');
	foreach ([[180, 174, 158, 255], [244, 225, 160, 255]] as $paperColor) {
		$paper = fixture(80, 40, $paperColor);
		$hex = sprintf('#%02x%02x%02x', $paperColor[0], $paperColor[1], $paperColor[2]);
		$paperOptions = array_merge($whole, ['remove_background' => TRUE, 'background_color' => $hex, 'fuzz' => 0]);
		$paperResult = rgba(ContactFacsimile::render($paper, $paperOptions));
		check(pixel($paperResult, 80, 0, 0)[3] === 0, 'Selected gray/yellow paper color was not removed');
		check(pixel($paperResult, 80, 40, 20) === [0, 0, 0, 255], 'Paper background removal changed signature ink');
		check(pixel($paperResult, 80, 2, 2)[3] === 64, 'Paper background removal changed existing alpha');
	}
	$asymmetric = asymmetricFixture();
	$originalPixels = rgba($asymmetric);
	$rotationOrder = [0 => [0, 1, 2, 3, 4, 5], 90 => [3, 0, 4, 1, 5, 2], 180 => [5, 4, 3, 2, 1, 0], 270 => [2, 5, 1, 4, 0, 3]];
	foreach ($rotationOrder as $rotation => $order) {
		$rotatedWidth = $rotation === 90 || $rotation === 270 ? 2 : 3;
		$rotatedHeight = $rotation === 90 || $rotation === 270 ? 3 : 2;
		$rotationOptions = array_merge($whole, ['rotation' => $rotation, 'width' => $rotatedWidth, 'height' => $rotatedHeight, 'output_width' => $rotatedWidth, 'output_height' => $rotatedHeight]);
		$rotated = ContactFacsimile::render($asymmetric, $rotationOptions);
		check(array_slice(getimagesizefromstring($rotated), 0, 2) === [$rotatedWidth, $rotatedHeight], 'Quarter-turn dimensions differ');
		$expected = '';
		foreach ($order as $index) { $expected .= substr($originalPixels, $index * 4, 4); }
		check(rgba($rotated) === $expected, 'Clockwise rotation pixels/alpha differ at '.$rotation.' degrees');
	}
	$cropRotated = ContactFacsimile::render($asymmetric, array_merge($whole, ['rotation' => 90, 'x' => 0, 'y' => 1, 'width' => 1, 'height' => 2, 'output_width' => 1, 'output_height' => 2]));
	check(rgba($cropRotated) === substr($originalPixels, 4 * 4, 4).substr($originalPixels, 5 * 4, 4), 'Crop coordinates were applied before rotation');
	$fourTurns = $asymmetric;
	$turnWidth = 3;
	$turnHeight = 2;
	for ($turn = 0; $turn < 4; $turn++) {
		$fourTurns = ContactFacsimile::render($fourTurns, array_merge($whole, ['rotation' => 90, 'width' => $turnHeight, 'height' => $turnWidth, 'output_width' => $turnHeight, 'output_height' => $turnWidth]));
		[$turnWidth, $turnHeight] = [$turnHeight, $turnWidth];
	}
	check(rgba($fourTurns) === $originalPixels, 'Four clockwise quarter turns did not restore original pixels');
	foreach ([-90, 45, 360, '90;ignored'] as $rotation) {
		rejects(function() use ($source, $whole, $rotation) { ContactFacsimile::render($source, array_merge($whole, ['rotation' => $rotation])); }, 'Invalid rotation accepted');
	}
	foreach (['white', '#fff', '#ffffffx', "#ffffff\n", '#gg0000', '#ffffff;ignored'] as $color) {
		rejects(function() use ($source, $whole, $color) { ContactFacsimile::render($source, array_merge($whole, ['background_color' => $color])); }, 'Invalid background color accepted');
	}
	rejects(function() use ($source, $options) { ContactFacsimile::render($source, array_merge($options, ['x' => 70])); }, 'Out of bounds crop accepted');
	rejects(function() use ($source, $options) { ContactFacsimile::render($source, array_merge($options, ['width' => 0])); }, 'Empty crop accepted');
	rejects(function() use ($source, $options) { ContactFacsimile::render($source, array_merge($options, ['output_height' => 80])); }, 'Aspect ratio distortion accepted');
	rejects(function() use ($source, $options) { ContactFacsimile::render($source, array_merge($options, ['output_width' => 5000])); }, 'Oversized result accepted');
	rejects(function() use ($source, $options) { ContactFacsimile::render($source, array_merge($options, ['fuzz' => 31])); }, 'Excessive background tolerance accepted');
	rejects(function() { ContactFacsimile::normalize('<svg xmlns="http://www.w3.org/2000/svg"></svg>'); }, 'Non-raster input accepted');
	rejects(function() { ContactFacsimile::normalize(str_repeat('x', 8 * 1024 * 1024 + 1)); }, 'Oversized source accepted');

	$db = new FakeFacsimileDb($source);
	$controller = new FakeFacsimileController($db);
	$pm = array_merge($options, ['id' => 42, 'content_id' => '1', 'source_hash' => hash('sha256', $source), 'save' => FALSE]);
	$model = ContactFacsimile::get($controller, $pm);
	check($model->values['source_hash'] === hash('sha256', $source), 'Source hash changed on read');
	check($model->values['mime_type'] === 'image/png', 'Editor source was not normalized to PNG');
	$cache = OUTPUT_PATH.md5('attachment_7');
	file_put_contents($cache, 'old cached signature');
	$preview = ContactFacsimile::process($controller, $pm);
	check($db->row['content_data'] === $source && file_exists($cache), 'Preview mutated stored image or cache');
	check(!in_array('BEGIN', $db->events, TRUE), 'Preview opened a write transaction');
	check($preview->values['source_hash'] === $pm['source_hash'], 'Preview changed optimistic version');
	$save = array_merge($pm, ['save' => TRUE]);
	$saved = ContactFacsimile::process($controller, $save);
	check(!file_exists($cache), 'Saved facsimile cache was not invalidated');
	$info = json_decode($db->row['content_info'], TRUE);
	check($info['id'] === '1' && $info['name'] === 'signature.png' && $info['other'] === 'keep', 'Attachment metadata was not preserved');
	check($saved->values['source_hash'] === hash('sha256', $db->row['content_data']), 'Saved source version differs');
	check($info['size'] === strlen($db->row['content_data']), 'Saved content size differs');
	$previewSize = getimagesizefromstring($db->row['content_preview']);
	check($previewSize[0] <= 250 && $previewSize[1] <= 100, 'Saved thumbnail too large');
	rejects(function() use ($controller, $save) { ContactFacsimile::process($controller, $save); }, 'Stale hash accepted');
	rejects(function() use ($controller, $pm) { ContactFacsimile::get($controller, array_merge($pm, ['id' => 99])); }, 'Different contact attachment accepted');
	rejects(function() use ($controller, $pm) { ContactFacsimile::get($controller, array_merge($pm, ['content_id' => '2'])); }, 'Different attachment accepted');

	$paper = fixture(80, 40, [180, 174, 158, 255]);
	$paperDb = new FakeFacsimileDb($paper);
	$paperController = new FakeFacsimileController($paperDb);
	$paperSave = array_merge($pm, ['x' => 0, 'y' => 0, 'width' => 40, 'height' => 80, 'output_width' => 40, 'output_height' => 80, 'rotation' => 90, 'background_color' => '#b4ae9e', 'remove_background' => '1', 'save' => TRUE, 'fuzz' => 0, 'source_hash' => hash('sha256', $paper)]);
	$paperPreview = ContactFacsimile::process($paperController, array_merge($paperSave, ['save' => '0']));
	check($paperDb->row['content_data'] === $paper, 'Rotated paper preview mutated storage');
	$paperSaved = ContactFacsimile::process($paperController, $paperSave);
	check(array_slice(getimagesizefromstring($paperDb->row['content_data']), 0, 2) === [40, 80], 'Rotated save dimensions differ');
	$paperPixels = rgba($paperDb->row['content_data']);
	check(pixel($paperPixels, 40, 0, 0)[3] === 0, 'Selected paper transparency was not persisted');
	check(pixel($paperPixels, 40, 20, 40) === [0, 0, 0, 255], 'Rotated save changed signature ink');
	check(pixel($paperPixels, 40, 37, 2)[3] === 64, 'Rotated save changed pre-existing alpha');
	check(base64_decode($paperSaved->values['data_base64']) === $paperDb->row['content_data'], 'Returned save PNG differs from stored PNG');
	check(rgba(base64_decode($paperPreview->values['data_base64'])) === $paperPixels, 'Rotated transparency preview differs from save');

	foreach (['conflictOnLock', 'failUpdate'] as $failureMode) {
		$db = new FakeFacsimileDb($source);
		$db->$failureMode = TRUE;
		$controller = new FakeFacsimileController($db);
		file_put_contents($cache, 'old cached signature');
		rejects(function() use ($controller, $save) { ContactFacsimile::process($controller, $save); }, 'Concurrent change/database failure accepted');
		check(in_array('ROLLBACK', $db->events, TRUE), 'Failed save did not roll back');
		check($db->row['content_data'] === $source, 'Failed save changed stored pixels');
		check(file_get_contents($cache) === 'old cached signature', 'Failed save invalidated cache');
	}
	fwrite(STDOUT, "Facsimile crop, resize, rotation, background/alpha, validation, contact scope, preview/save and rollback checks passed.\n");
} finally {
	foreach (glob($testDirectory.'/output/*') as $file) { unlink($file); }
	unlink($testDirectory.'/basic_classes/ModelVars.php');
	rmdir($testDirectory.'/basic_classes');
	rmdir($testDirectory.'/output');
	rmdir($testDirectory);
}
