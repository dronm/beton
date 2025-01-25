<?php
class ExtProg{

	private static function parseHeaders($headers){
	    $head = array();
	    foreach( $headers as $k=>$v )
	    {
		$t = explode( ':', $v, 2 );
		if( isset( $t[1] ) )
		    $head[ trim($t[0]) ] = trim( $t[1] );
		else{
		    $head[] = $v;
		    if( preg_match( "#HTTP/[0-9\.]+\s+([0-9]+)#",$v, $out ) )
		        $head['reponse_code'] = intval($out[1]);
		        $head['reponse_descr'] = $v;
		}
	    }
	    return $head;
	}
	
	/* 
	 * $fileOpts = array('name',disposition,contentType,toFile boolean)
	 * If $parseContent is TRUE, the response string is parsed as json value and returned as array.
	 * If $ileOpts is not null, then the returned value from 1c is treated as file.
	 * Function returnes parsed/unparsed responce from 1c or file path.
	 */
	private static function send_query($cmd, $params, $parseContent, $fileOpts=NULL): string|array {
		$CON_TIMEOUT = 120;//seconds
		
		$params['key'] = KEY_1C;
		$params['cmd'] = $cmd;
		
		$options = array(
			'http' => array(
				'method'  => 'POST',
				'header'  => array(
					'Content-type: application/x-www-form-urlencoded; charset="utf-8"'
					),
				'content' => http_build_query($params),
				'timeout' => $CON_TIMEOUT
			)
		);
		$context = stream_context_create($options);
		$contents = @file_get_contents('http://'.HOST_1C.':'.PORT_1C.'/api.php', FALSE, $context);
		if($contents === FALSE){
			$error = error_get_last();
			throw new Exception($error['message']);
		}
		$header_res = self::parseHeaders($http_response_header);
		if ($header_res['reponse_code'] && $header_res['reponse_code']!=200){
			throw new Exception($header_res['reponse_descr']);
		}
		
		//ответ всегда в utf-8
		if (!is_null($fileOpts) && is_array($fileOpts)){
			if (!array_key_exists('name',$fileOpts)){
				$fileOpts['name'] = uniqid().'.pdf';
			}
		
			if (array_key_exists('toFile',$fileOpts) && $fileOpts['toFile']==TRUE){
				file_put_contents(OUTPUT_PATH.$fileOpts['name'],$contents);
				return OUTPUT_PATH.$fileOpts['name'];
			}
			else{
				if (!array_key_exists('contentType',$fileOpts)){
					$p = strpos($fileOpts['name'],'.');
					if ($p !== FALSE){
						$ext = substr($fileOpts['name'],$p+1);
						if (in_array($ext,array('zip','pdf','xls'))){
							$fileOpts['contentType'] = 'application/'.$ext;
						}
					}
					if (!array_key_exists('contentType',$fileOpts)){
						$fileOpts['contentType'] = 'application/octet-stream';
					}
				}
				if (!array_key_exists('disposition',$fileOpts)){
					$fileOpts['disposition'] = 'attachment';
				}
				ob_clean();//attachment
				header("Content-type: ".$fileOpts['contentType']);
				header("Content-Disposition: ".$fileOpts['disposition']."; filename=\"".$fileOpts['name']."\"");		
				header("Content-length: ".strlen($contents));
				header("Cache-control: private");
				echo $contents;
			}			
		}
		else if (!strlen($contents)){
			throw new Exception('Нет доступа к серверу 1с!');
			
		}else if ($parseContent){
			//file_put_contents('output/cont1.json', $contents);		
			try{
				$resp_cont = json_decode($contents, TRUE);				
			}catch(Exception $e){
				throw new Exception('Ошибка парсинга ответа 1с:'.$e->getMessage().' Строка: '.$contents);
			}
			if(!isset($resp_cont['models'])
			|| !isset($resp_cont['models']['ModelServResponse'])
			|| !isset($resp_cont['models']['ModelServResponse']['rows'])
			|| !count($resp_cont['models']['ModelServResponse']['rows'])
			|| !isset($resp_cont['models']['ModelServResponse']['rows'][0]['result'])
			|| !isset($resp_cont['models']['ModelServResponse']['rows'][0]['descr'])
			){
				throw new Exception('Неверная структура ответа 1с: '.$contents);
			}
			if ($resp_cont['models']['ModelServResponse']['rows'][0]['result'] != '0'){
				throw new Exception($resp_cont['models']['ModelServResponse']['rows'][0]['descr']);
			}							
			return $resp_cont;
		}else{
			//as is
			return $contents;
		}
	}

	public static function getClientList(string $search): array {
		return (array)ExtProg::send_query('get_catalog_by_attr', array('catalog'=>'clients','search'=>$search), TRUE);
	}
	
	public static function getClientOnPP(string $ppNum): array {
		return (array)ExtProg::send_query('get_client_on_pp', array('pp_num'=>$ppNum), TRUE);
	}

	public static function getClientOborot(): array {
		return (array)ExtProg::send_query('get_client_dog_oborot', array(), TRUE);
	}

	public static function getClientDebtList(): array {
		return (array)ExtProg::send_query('get_client_debt_list', array(), TRUE);
	}

	public static function getBuhRBPList(string $search): array {
		return  (array)ExtProg::send_query('get_catalog_by_attr', array('catalog'=>'rbp','search'=>$search), TRUE);
	}

	public static function completeClientContract(string $clientRef1c, string $search): array {
		return (array)ExtProg::send_query('complete_client_dog', array('client_ref_1c'=>$clientRef1c,'search'=>$search), TRUE);
	}

	public static function getClientContract(string $contractRef1c): array {
		return (array)ExtProg::send_query('get_client_dog', array('ref_1c'=>$contractRef1c), TRUE);
	}

	public static function ping(): bool {
		try{
			$respModel = ExtProg::send_query('ping', array(), TRUE);
		}catch(Exception $e){
			return FALSE;
		}
		if(!isset($respModel) 
			|| !isset($respModel["models"])
			|| !isset($respModel["models"]["Query1c_Model"])
			|| !isset($respModel["models"]["Query1c_Model"]["rows"])
			|| !is_array($respModel["models"]["Query1c_Model"]["rows"])
			|| !count($respModel["models"]["Query1c_Model"]["rows"])
			|| !isset($respModel["models"]["Query1c_Model"]["rows"][0]["result"])
			|| $respModel["models"]["Query1c_Model"]["rows"][0]["result"] !== TRUE
		){
			return FALSE;
		}
		return TRUE;
	}
}
?>
