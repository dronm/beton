<?php
/** After npm install, copy the pinned full OpenLayers build for local hosting. */
$root = dirname(__DIR__);
$package = $root.'/node_modules/ol';
if (!is_file($package.'/package.json') || !is_file($package.'/dist/ol.js')) {
	fwrite(STDERR, "OpenLayers is not installed. Run npm install first.\n");
	exit(1);
}
$metadata = json_decode(file_get_contents($package.'/package.json'), true);
if (($metadata['version'] ?? '') !== '10.10.0') {
	fwrite(STDERR, "Expected OpenLayers 10.10.0; update the application deliberately before using a different version.\n");
	exit(1);
}
$destination = $root.'/vendor/ol';
if (!is_dir($destination) && !mkdir($destination, 0755, true)) {
	fwrite(STDERR, "Cannot create vendor/ol.\n");
	exit(1);
}
foreach (array('dist/ol.js' => 'ol.js', 'ol.css' => 'ol.css', 'LICENSE.md' => 'LICENSE.md') as $source => $target) {
	if (!copy($package.'/'.$source, $destination.'/'.$target)) {
		fwrite(STDERR, "Cannot copy OpenLayers file: ".$source."\n");
		exit(1);
	}
}
file_put_contents($destination.'/VERSION', $metadata['version']."\n");
echo "OpenLayers 10.10.0 copied to vendor/ol/. Deploy that directory with the PHP page.\n";
