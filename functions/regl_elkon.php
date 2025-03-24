<?php
require_once('db_con.php');
require_once(USER_CONTROLLERS_PATH.'Production_Controller.php');
//При ошибке все залогится куда надо... исключения не будет!!!
//$dbLink->reportError = TRUE;
function isFileOlderThanInterval(string $fileName, int $allowedInterval) {
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

$allowedInterval = 60000 * 10; //10 minutes
$sygFile = OUTPUT_PATH."elkon_upload.syg";

if(file_exists($sygFile) && !isFileOlderThanInterval($sygFile, $allowedInterval)){
	echo "file ".$sygFile." exists - exiting";
	exit;
}

file_put_contents($sygFile, date("Y-m-dTH:i:s"));
try{
	$contr = new Production_Controller($dbLink);
	$contr->check_data(NULL);
}finally{
	unlink($sygFile);
}

?>
