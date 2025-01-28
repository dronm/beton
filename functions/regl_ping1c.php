<?php
require_once('ExtProg.php');
require_once('db_con_f.php');

function hasFileExpired(string $filePath, int $interval = 150): bool {
    if (!file_exists($filePath)) {
        throw new Exception("File does not exist.");
    }
    
    // Get file creation time
    $creationTime = filectime($filePath);
    if ($creationTime === false) {
        throw new Exception("Unable to retrieve file creation time.");
    }
    
    // Compare with the current time
    return (time() - $creationTime) > $interval;
}

$sigFile = "ping1c.chk";

if(hasFileExpired($sigFile)){
	unlink($sigFile);
}else{
	return;
}

file_put_contents($sigFile, date("Y-m-d H:i:s"));
try{
	$res = ExtProg::ping();
	$link = db_con();
	$dbResult = sprintf('{"result": %s, "date": "%s"}', ($res===TRUE? "true" : "false"), date("Y-m-d H:i:s"));
	$link->query(sprintf("SELECT const_ping1c_set_val('%s'::JSON)", $dbResult));
}finally{
	unlink($sigFile);
}

?>

