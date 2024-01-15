<?php
/**
 * Функции получения фото из телграм
 */
require_once('common/telegram.php');

define('TM_APP_NAME', 'eurobeton');
define('OUTPUT_PATH', dirname(__FILE__).'/../output'.DIRECTORY_SEPARATOR);

//********************************************

function gen_thumbnail($fl, $w, $h){
	$thbn_fl = OUTPUT_PATH.uniqid().'.jpeg';
	$cmd = sprintf("convert -define jpeg:size=%dx%d '%s' -auto-orient -thumbnail 32x32 -unsharp 0x.5 '%s'", $w, $h, $fl, $thbn_fl);
	exec($cmd);
	
	return (file_exists($thbn_fl)? $thbn_fl:NULL);
}

//returns photodata && fills $photoMD['file_id', 'file_size', 'width', 'height', 'file_path']
function get_user_photo($token, $userId, &$photoMD){
	$resp = apiRequestJson($token, "getUserProfilePhotos",
		array(
			'user_id' => $userId
		),
		TRUE
	);
	
	if(!is_array($resp)||!count($resp)
	||!isset($resp["total_count"])||!intval($resp["total_count"])
	||!isset($resp["photos"])
	){
		return NULL;
	}

	for($i = 0; $i < count($resp['photos']); $i++){
		if(!is_array($resp['photos'][$i])||!count($resp['photos'][$i])){
			continue;
		}
		$ph = $resp['photos'][$i][0];
		$photoMD = array(
			'file_id' => $ph['file_id']
			,'file_size' => $ph['file_size']
			,'width' => $ph['width']
			,'height' => $ph['height']
		);
		
		$resp_f = apiRequestJson($token, "getFile",
			array(
				'file_id' => $ph['file_id']
			),
			TRUE
		);
		if(is_array($resp_f)&&count($resp_f)&&isset($resp_f["file_path"])){
			$photoMD['file_path'] = $resp_f["file_path"];
			return file_get_contents(sprintf('https://api.telegram.org/file/bot%s/%s', $token, $resp_f["file_path"]));
		}
		break;
	}
	
	return NULL;
}

function update_user_photo($conn, $tmID, $photoData, $photoMD){
	//+ preview
	$fl = OUTPUT_PATH.uniqid().'.jpeg';
	$p_fl = '';
	try{
		file_put_contents($fl, $photoData);
		$p_fl = gen_thumbnail($fl, $photoMD['width'], $photoMD['height']);
		
		$conn->query(sprintf(
			"UPDATE notifications.ext_users
				SET
					tm_photo='%s',					
					tm_photo_preview='%s',
					tm_photo_md='%s'
			WHERE id = %d"
			,pg_escape_bytea($conn->link_id, $photoData)
			,pg_escape_bytea($conn->link_id, file_get_contents($p_fl))
			,json_encode($photoMD)
			,$tmID
		));
		
	}catch(Exception $e){
		if(file_exists($fl)){
			unlink($fl);
		}
		if(strlen($p_fl) && file_exists($p_fl)){
			unlink($p_fl);
		}		
	}		
}


function update_all_photos(){
	$conn = getTMDbConn();
	$q_params = $conn->query_first(sprintf(
		"SELECT
			id,
			tm_params
		FROM apps WHERE name = '%s'", TM_APP_NAME
	));
	if(!isset($q_params['tm_params'])){
		throw new Exception('TM params not found on application name '.$appName);
	}
	$tm_params = json_decode($q_params['tm_params'], TRUE);
	
	$id = $conn->query(sprintf(
		"SELECT *
		FROM notifications.ext_users AS u
		WHERE u.ext_contact_id IS NOT NULL
			AND tm_photo_md IS NULL
			AND app_id = %d
			AND tm_user IS NOT NULL
			AND tm_user->>'id' IS NOT NULL"
		,$q_params['id']
	));

	$cnt = 0;	
	while ($ar = $conn->fetch_array($id)){		
		$tm_user = json_decode($ar['tm_user'], TRUE);
		if(!isset($tm_user['id'])){
			continue;
		}
		$md = NULL;
		$d = get_user_photo($tm_params['token'], $tm_user['id'], $md);
		if(!is_null($d)){
			update_user_photo($conn, $ar['id'], $d, $md);
			echo 'ID='.$ar['id'].PHP_EOL;
			sleep(1);
			$cnt++;			
			//break;
		}
	}
	echo 'Done:'.$cnt.PHP_EOL;
}	

function update_all_new(){
	$conn = getTMDbConn();
	$q_params = $conn->query_first(sprintf(
		"SELECT
			id,
			tm_params
		FROM apps WHERE name = '%s'", TM_APP_NAME
	));
	if(!isset($q_params['tm_params'])){
		throw new Exception('TM params not found on application name '.$appName);
	}
	$tm_params = json_decode($q_params['tm_params'], TRUE);
	
	$id = $conn->query(sprintf(
		"SELECT *
		FROM notifications.ext_users AS u
		WHERE u.ext_contact_id IS NOT NULL
			AND tm_photo_md IS NULL
			AND app_id = %d
			AND tm_user IS NOT NULL
			AND tm_user->>'id' IS NOT NULL
			AND now()::date - date_time::date <=1"
		,$q_params['id']
	));

	while ($ar = $conn->fetch_array($id)){		
		$tm_user = json_decode($ar['tm_user'], TRUE);
		if(!isset($tm_user['id'])){
			continue;
		}
		$md = NULL;
		$d = get_user_photo($tm_params['token'], $tm_user['id'], $md);
		if(!is_null($d)){
			update_user_photo($conn, $ar['id'], $d, $md);
			sleep(1);
		}
	}
}	

//update_all_photos();

?>
