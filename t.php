<?php
$s = '{"err":"","imei":"866201059622933","status":{"runTime":0,"downloadedBytes":46,"uploadedBytes":0}}';
$res = json_decode($s, TRUE);
$resStr = var_export($res, TRUE);
echo $resStr;
