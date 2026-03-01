<?php
require_once(dirname(__FILE__).'/../Config.php');

class Exch1c{

	/*
	 * @param $params
	 * @param $options
	 */
	private static function httpExecute($command, $params = NULL, $options = []) {

		static $status_codes = null;

		if ($status_codes === null) {
			$status_codes = array (
				100 => 'Continue',
				101 => 'Switching Protocols',
				102 => 'Processing',
				200 => 'OK',
				201 => 'Created',
				202 => 'Accepted',
				203 => 'Non-Authoritative Information',
				204 => 'No Content',
				205 => 'Reset Content',
				206 => 'Partial Content',
				207 => 'Multi-Status',
				300 => 'Multiple Choices',
				301 => 'Moved Permanently',
				302 => 'Found',
				303 => 'See Other',
				304 => 'Not Modified',
				305 => 'Use Proxy',
				307 => 'Temporary Redirect',
				400 => 'Bad Request',
				401 => 'Unauthorized',
				402 => 'Payment Required',
				403 => 'Forbidden',
				404 => 'Not Found',
				405 => 'Method Not Allowed',
				406 => 'Not Acceptable',
				407 => 'Proxy Authentication Required',
				408 => 'Request Timeout',
				409 => 'Conflict',
				410 => 'Gone',
				411 => 'Length Required',
				412 => 'Precondition Failed',
				413 => 'Request Entity Too Large',
				414 => 'Request-URI Too Long',
				415 => 'Unsupported Media Type',
				416 => 'Requested Range Not Satisfiable',
				417 => 'Expectation Failed',
				422 => 'Unprocessable Entity',
				423 => 'Locked',
				424 => 'Failed Dependency',
				426 => 'Upgrade Required',
				500 => 'Internal Server Error',
				501 => 'Not Implemented',
				502 => 'Bad Gateway',
				503 => 'Service Unavailable',
				504 => 'Gateway Timeout',
				505 => 'HTTP Version Not Supported',
				506 => 'Variant Also Negotiates',
				507 => 'Insufficient Storage',
				509 => 'Bandwidth Limit Exceeded',
				510 => 'Not Extended'
			);
		}

		$isDebugMode = (defined("EXCH_1C_DEBUG") && EXCH_1C_DEBUG === TRUE);

		$isFileDownload = (!empty($options['save_to']));

		$urlCommand = false;
		$postCommand = false;

		$methEndpoint = "";
		if($isFileDownload){
			$methEndpoint = "bin-data";

		}else if(
			$command == "health" || $command == "status"
		){
			$methEndpoint = $command;
			$urlCommand = true;
			$postCommand = false;

		}else if($command == "start" || $command == "stop"
		){
			$methEndpoint = $command;
			$urlCommand = true;
			$postCommand = true;
		}else{
			$methEndpoint = "execute";
			$postCommand = true;
		}

		$url = sprintf("%s:%d/%s", EXCH_1C_HOST, EXCH_1C_PORT, $methEndpoint);

		if($isDebugMode){
			echo "url: ".$url.PHP_EOL;
			echo "urlCommand: ".$urlCommand.PHP_EOL;
			echo "command: ".$command.PHP_EOL;
			echo "params: ".var_export($params, TRUE).PHP_EOL;
		}

		$ch = curl_init($url);

		$jsonData = "";

		if(!$urlCommand){
			$jsonData = json_encode(
				[
					"command" => $command, 
					"params" => $params
				],
				JSON_UNESCAPED_UNICODE
			);
		}

		$headers = [
			"Content-Type: application/json",
			"Content-Length: " . strlen($jsonData)
		];

		// Add Basic Auth header if credentials provided
		if(defined("EXCH_1C_USER") && defined("EXCH_1C_PASSWORD")){
			$auth = base64_encode(EXCH_1C_USER . ':' . EXCH_1C_PASSWORD);
			$headers[] = "Authorization: Basic " . $auth;
		}

		$curlOptions = [
			CURLOPT_RETURNTRANSFER  => true,
			CURLOPT_TIMEOUT         => $options['timeout']? $options['timeout']: 120,
			CURLOPT_CONNECTTIMEOUT  => $options['connect_timeout']? $options['connect_timeout']: 10,
		];

		if ($postCommand) {
			$curlOptions[CURLOPT_POST] = true;
			$curlOptions[CURLOPT_POSTFIELDS] = $jsonData;
			$curlOptions[CURLOPT_HTTPHEADER] = $headers;
		} else {
			// PURE GET
			$curlOptions[CURLOPT_HTTPGET] = true;

			// For GET we should NOT send Content-Type / Length
			$curlOptions[CURLOPT_HTTPHEADER] = array_filter($headers, function($h){
				return stripos($h, 'Content-') !== 0;
			});
		}

		curl_setopt_array($ch, $curlOptions);

		if($isDebugMode){
			echo "headers: ".var_export($headers, TRUE).PHP_EOL;
		}

		// If we need to download file
		if ($isFileDownload) {
			$fp = fopen($options['save_to'], 'wb');
			curl_setopt($ch, CURLOPT_FILE, $fp);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, false);
		}

		$response = curl_exec($ch);
		$error    = curl_error($ch);
		$errno    = curl_errno($ch);
		$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);

		curl_close($ch);

		if (!empty($fp)) {
			fclose($fp);
		}

		if ($errno) {
			throw new Exception("cURL error ({$errno}): {$error}");
		}

		// For file download just return path and status
		if ($isFileDownload) {
			return [
				'http_code' => $httpCode,
				'file'      => $options['save_to']
			];
		}

		// Otherwise return decoded JSON (if possible)
		$decoded = json_decode($response, true);
		if(isset($decoded['success']) && $decoded["success"]!==TRUE && isset($decoded["error"])){
			throw new Exception($decoded["error"]);

		}else if ($httpCode < 200 || $httpCode >300){
			throw new Exception($httpCode." ".$status_codes[$httpCode]);
		} 

		return [
			'http_code' => $httpCode,
			'raw'       => $response,
			'payload'      => isset($decoded['payload'])? $decoded['payload'] : NULL
		];
	}

	/*
	 * returns pong
	 */
	public static function ping() {
		$res = self::httpExecute("ping", NULL);
		return $res["payload"];
	}

	/*
	 * returns
		[ firm,
		firm_inn,
		firm_ref,
		client,
		client_ref,
		contract,
		contract_ref,
        debt_total ]
	 */
	public static function clientDebtList() {
		$res = self::httpExecute("get_client_debt_list", NULL);
		return $res["payload"];
	}

	/*
	 * catId: clients, users, rbp
	 * returns specifig catalog attributes
	 */
	public static function catalogByAttr($catId, $search) {
		$res = self::httpExecute("catalog_by_attr", ["catalog" => $catId, "search" => $search]);
		/* file_put_contents(OUTPUT_PATH.'resp.txt', var_export($res, true)); */
		return $res["payload"];
	}

	/** 
	 * returns
	 * [ ref, data, faktura_nomer, faktura_data ]
	 */
	public static function shipments($clientRef, $date,  $multiple) {
		$res = self::httpExecute("get_shipments", [
			"client_ref" => $clientRef, 
			"date" => $date,
			"multiple" => $multiple
		]
		);
		return $res["payload"];
	}

	/** 
	 * returns
	 * ref, name, name_full,inn, kpp,  email_edo, address_legal, address_fact, tels
	 */
	public static function client($ref) {
		$res = self::httpExecute("get_client", ["ref" => $ref]);
		return $res["payload"];
	}

	/** 
	 * returns
	 * [ ref, name ]
	 */
	public static function completeClientDogovor($ref, $search) {
		$res = self::httpExecute("complete_client_dog", ["ref" => $ref, "search" => $search]);
		return $res["payload"];
	}

	/** 
	 * returns
	 * [ ref, name ]
	 */
	public static function clientDogovorList( $ref) {
		$res = self::httpExecute("get_client_dog", ["ref" => $ref]);
		return $res["payload"];
	}

	/** 
	 * @param $params
	* order_ref,
	* client_ref
	* dogovor_ref
	* num, date
	* items:
	*		code_1c
	*		quant
	*		price
	*		total
	*
	* returns
	*	{ id, num, descr }
	 */
	public static function newOrder($params) {
		$res = self::httpExecute("new_order", $params);
		return $res["payload"];
	}

	/*
	 * returns saves file to $fileName
	*/
	public static function printOrder($ref, $userDescr, $fileName) {
		self::httpExecute(
			"print_order", 
			["order_ref" => $ref], 
			["user" => $userDescr], 
			["save_to" => $fileName]
		);
	}

	public static function complete_item($search) {
		$res = self::httpExecute("catalog_by_attr", ["catalog" => "items", "search" => $search]);
		return $res["payload"];
	}

	public static function status() {
		$res = self::httpExecute("status");
		return $res["payload"];
	}

	public static function health() {
		$res = self::httpExecute("health");
		return $res["payload"];
	}

	public static function stop() {
		$res = self::httpExecute("stop");
		return $res["payload"];
	}

	public static function start() {
		$res = self::httpExecute("start");
		return $res["payload"];
	}

	/** 
	 * @param $params
	* ref_1c,
	* date,
	* items:
	*		code_1c
	*		quant
	*
	* materials:
	*		ref_1c
	*		quant
	*
	* returns
	*	{ id, num, descr }
	 */
	public static function newProductionReport(array $params) {
		$res = self::httpExecute("new_production", $params);
		return $res["payload"];
	}

	public static function newProductionReportMat(array $params) {
		$res = self::httpExecute("new_production_mat", $params);
		return $res["payload"];
	}

	public static function newShipment(array $params) {
		throw new Exception("newShipment not implemented");
		/* $res = self::httpExecute("new_production_mat", $params); */
		/* return $res["payload"]; */
	}
}
?>
