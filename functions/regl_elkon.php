<?php
require_once('db_con.php');
require_once(USER_CONTROLLERS_PATH.'Production_Controller.php');

define('ALLOWED_INTERVAL', 30000 * 10);
define('WARN_SCRIPT', '/home/andrey/failover/notify.sh');

//При ошибке все залогится куда надо... исключения не будет!!!
//$dbLink->reportError = TRUE;
function isFileOlderThanInterval($fileName, $allowedInterval) {
    if (!file_exists($fileName)) {
        return false; // File doesn't exist
    }
    
    // Get file creation time (or closest available - ctime or mtime)
    $fileCreationTime = filectime($fileName); 
    
    if ($fileCreationTime === false) {
        return false; // Unable to retrieve file creation time
    }
    
    // Convert allowedInterval from milliseconds to seconds
    $allowedIntervalSeconds = $allowedInterval / 1000;
    
    // Get current time
    $currentTime = time();
    
    // Check if the file is older than the allowed interval
    return ($currentTime - $fileCreationTime) * 1000 >= $allowedInterval;
}

$sygFile = OUTPUT_PATH."elkon_upload.syg";

$fileEx = file_exists($sygFile);

if ($fileEx && !isFileOlderThanInterval($sygFile, ALLOWED_INTERVAL)) {
    echo "file ".$sygFile." exists - exiting";
    exit;
} elseif ($fileEx) {
    // Read PID from file
    $line = trim(file_get_contents($sygFile));
    $warnMsg = "";

    if (preg_match('/PID:(\d+)/', $line, $matches)) {
        $pid = (int)$matches[1];

        // Check if process exists
        if (posix_kill($pid, 0)) { // signal 0 just tests existence
            // Try to terminate gracefully
            if (posix_kill($pid, SIGTERM)) {
                $warnMsg = "ReglElkon: Process $pid killed successfully";
            } 
            // If still alive, force kill
            elseif (posix_kill($pid, SIGKILL)) {
                $warnMsg = "ReglElkon: Process $pid forcefully killed";
            } else {
                $warnMsg = "ReglElkon: Failed to kill process $pid";
            }

            // Send warning message
            $cmd = escapeshellcmd(WARN_SCRIPT) . ' ' . escapeshellarg($warnMsg);
            exec($cmd . " > /dev/null 2>&1 &");

        } 
        // Process does not exist: do nothing
    } else {
        // No PID in file
		// do nothing
    }
}
//$cmd = escapeshellcmd(WARN_SCRIPT) . ' ' . escapeshellarg('Running regl_elkon.php');
//exec($cmd . " > /dev/null 2>&1 &");

file_put_contents($sygFile, date("Y-m-dTH:i:s").' PID:'.getmypid());
try{
	$contr = new Production_Controller($dbLink);
	$contr->check_data(NULL);
}finally{
	unlink($sygFile);
}

?>
