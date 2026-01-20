<?php

// --------------------------------------------------
// 1. Read connection from .env
// --------------------------------------------------

$env = parse_ini_file(__DIR__ . '/.env');
if (!$env || empty($env['DB_CONN'])) {
    die("DB_CONN not found in .env\n");
}

$url = parse_url($env['DB_CONN']);

$host = $url['host'];
$port = $url['port'] ?? 5432;
$db   = ltrim($url['path'], '/');
$user = $url['user'];
$pass = $url['pass'];

$connStr = "host=$host port=$port dbname=$db user=$user password=$pass";

$conn = pg_connect($connStr);
if (!$conn) {
    die("Cannot connect to database\n");
}

// --------------------------------------------------
// 2. Read clients_old.txt  (ref -> inn)
// --------------------------------------------------

$oldFile = __DIR__ . '/clients_old.txt';
$newFile = __DIR__ . '/clients_new.txt';

if (!file_exists($oldFile) || !file_exists($newFile)) {
    die("Source files not found\n");
}

$oldRefToInn = [];

$fh = fopen($oldFile, 'r');
while (($line = fgets($fh)) !== false) {
    $line = trim($line);
    if ($line === '') continue;

    $parts = explode('@@', $line);
    if (count($parts) < 5) continue;

    list($code, $name, $inn, $kpp, $ref) = $parts;

    $ref = trim($ref);
    $inn = trim($inn);

    if ($ref !== '') {
        $oldRefToInn[$ref] = $inn;
    }
}
fclose($fh);

// --------------------------------------------------
// 3. Read clients_new.txt (inn -> [ref,name])
// --------------------------------------------------

$innToNew = [];

$fh = fopen($newFile, 'r');
while (($line = fgets($fh)) !== false) {
    $line = trim($line);
    if ($line === '') continue;

    $parts = explode('@@', $line);
    if (count($parts) < 5) continue;

    list($code, $name, $inn, $kpp, $ref) = $parts;

    $inn = trim($inn);
    $ref = trim($ref);
    $name = trim($name);

    if ($inn !== '') {
        $innToNew[$inn] = [
            'ref'  => $ref,
            'name' => $name,
        ];
    }
}
fclose($fh);

// --------------------------------------------------
// 4. Select clients to process
// --------------------------------------------------

$sql = "
select id, ref_1c
from clients
where ref_1c is not null
  and ref_1c->'keys'->>'ref_1c' is not null
";

$res = pg_query($conn, $sql);
if (!$res) {
    die("Select error: " . pg_last_error($conn));
}

// prepare statements
pg_prepare($conn, "clear",  "update clients set ref_1c = null where id = $1");
pg_prepare($conn, "update", "update clients set ref_1c = $1 where id = $2");

$updated = 0;
$cleared = 0;

// --------------------------------------------------
// 5. Process each client
// --------------------------------------------------

while ($row = pg_fetch_assoc($res)) {

    $id = $row['id'];
    $json = $row['ref_1c'];

    $data = json_decode($json, true);

    if (!$data || !isset($data['keys']['ref_1c'])) {
        pg_execute($conn, "clear", [$id]);
        $cleared++;
        continue;
    }

    $oldRef = $data['keys']['ref_1c'];

    // --- Rule 2 ---
    if (!isset($oldRefToInn[$oldRef])) {
        pg_execute($conn, "clear", [$id]);
        $cleared++;
        continue;
    }

    $inn = $oldRefToInn[$oldRef];

    // --- Rule 3 ---
    if (!isset($innToNew[$inn])) {
        pg_execute($conn, "clear", [$id]);
        $cleared++;
        continue;
    }

    $newRef  = $innToNew[$inn]['ref'];
    $newName = $innToNew[$inn]['name'];

    $newJson = json_encode([
        'keys' => [
            'ref_1c' => $newRef
        ],
        'descr' => $newName
    ], JSON_UNESCAPED_UNICODE);

    pg_execute($conn, "update", [$newJson, $id]);

    $updated++;
}

echo "Updated: $updated\n";
echo "Cleared: $cleared\n";

pg_close($conn);

