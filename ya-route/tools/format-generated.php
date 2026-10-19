<?php
// TypeScript emits four-space indentation. Keep the deployed, readable file tab-indented too.
$path = __DIR__.'/../assets/route.js';
$source = file_get_contents($path);
if ($source === false) {
	fwrite(STDERR, "Cannot read compiled assets/route.js\n");
	exit(1);
}
$source = preg_replace_callback('/^(?: {4})+/m', function (array $match): string {
	return str_repeat("\t", (int) (strlen($match[0]) / 4));
}, $source);
if (file_put_contents($path, $source) === false) {
	fwrite(STDERR, "Cannot write compiled assets/route.js\n");
	exit(1);
}
