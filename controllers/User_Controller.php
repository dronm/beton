<?php
require_once(FRAME_WORK_PATH.'basic_classes/ControllerSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtFloat.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtEnum.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtDateTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtDate.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtPassword.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtBool.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtInterval.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtDateTimeTZ.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtJSON.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtJSONB.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtArray.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtBytea.php');

/**
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/controllers/Controller_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */



//require_once('functions/res_rus.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/GlobalFilter.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelWhereSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/ParamsSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelVars.php');
require_once(FRAME_WORK_PATH.'basic_classes/SessionVarManager.php');

require_once('common/PwdGen.php');
require_once(ABSOLUTE_PATH.'functions/notifications.php');

require_once(ABSOLUTE_PATH.'functions/CustomEmailSender.php');

require_once(ABSOLUTE_PATH.'functions/Beton.php');

//User Agent parser
//if (PHP_VERSION_ID >= 70000) {

require_once 'common/matomo/device-detector/autoload.php';
require_once 'common/matomo/device-detector/DeviceDetector.php';
require_once 'common/matomo/device-detector/Parser/AbstractParser.php';
require_once 'common/matomo/device-detector/Parser/AbstractBotParser.php';
require_once 'common/matomo/device-detector/Parser/Bot.php';
require_once 'common/matomo/device-detector/Parser/OperatingSystem.php';
require_once 'common/matomo/device-detector/Yaml/ParserInterface.php';
require_once 'common/matomo/device-detector/Yaml/Spyc.php';
require_once 'common/matomo/device-detector/Cache/CacheInterface.php';
require_once 'common/matomo/device-detector/Cache/StaticCache.php';

require_once 'common/matomo/device-detector/Parser/VendorFragment.php';
require_once 'common/matomo/device-detector/Parser/Client/AbstractClientParser.php';
require_once 'common/matomo/device-detector/Parser/Client/FeedReader.php';
require_once 'common/matomo/device-detector/Parser/Client/MobileApp.php';
require_once 'common/matomo/device-detector/Parser/Client/MediaPlayer.php';
require_once 'common/matomo/device-detector/Parser/Client/PIM.php';
require_once 'common/matomo/device-detector/Parser/Client/Browser.php';
require_once 'common/matomo/device-detector/Parser/Client/Browser/Engine/Version.php';
require_once 'common/matomo/device-detector/Parser/Client/Library.php';
require_once 'common/matomo/device-detector/Parser/Device/AbstractDeviceParser.php';
require_once 'common/matomo/device-detector/Parser/Device/HbbTv.php';
require_once 'common/matomo/device-detector/Parser/Device/Notebook.php';
require_once 'common/matomo/device-detector/Parser/Device/Console.php';
require_once 'common/matomo/device-detector/Parser/Device/CarBrowser.php';
require_once 'common/matomo/device-detector/Parser/Device/Camera.php';
require_once 'common/matomo/device-detector/Parser/Device/PortableMediaPlayer.php';
require_once 'common/matomo/device-detector/Parser/Device/Mobile.php';


use DeviceDetector\DeviceDetector;
use DeviceDetector\Parser\Device\AbstractDeviceParser;
AbstractDeviceParser::setVersionTruncation(AbstractDeviceParser::VERSION_TRUNCATION_NONE);

//}
class User_Controller extends ControllerSQL{

	const PWD_LEN = 6;
	const ER_USER_NOT_DEFIND = "Пользователь не определен!@1000";
	const ER_NO_EMAIL = "Не задан адрес электронный почты!@1001";
	const ER_NO_EMAIL_TEL = "У пользователя нет ни телефона ни эл.почты!";
	const ER_LOGIN_TAKEN = "Имя пользователя занято.";
	const ER_EMAIL_TAKEN = "Есть такой адрес электронной почты.";

	const ER_BANNED = "Доступ запрещен!@1005";
	const ER_DEVICE_BANNED = "Доступ с данного устройства запрещен!@1006";
	
	const ER_AUTOREFRESH_NOT_ALLOWED = "Обновление сессии запрещено!@1010";
	
	const TM_REGEN_DURATION_SEC = 2*60; //Сколько времени до возможности регенерации кода
	const TM_CODE_DURATION_SEC = 30*60;//
	const TM_ALLOWED_TRIES = 3;
	const TM_TEL_DURATION_SEC = 10*24*60*60;

	const USER_TM_LOGIN_MAX_INCORRECT_COUNT = 4;
	const USER_TM_LOGIN_WAIT_SEC = 120;

	public function __construct($dbLinkMaster=NULL, $dbLink=NULL){
		parent::__construct($dbLinkMaster, $dbLink);
			

		/* insert */
		$pm = new PublicMethod('insert');
		
			$f_params = array();
			
				$f_params['required']=TRUE;
			$param = new FieldExtString('name'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['required']=TRUE;
			
				$param = new FieldExtEnum('role_id',',','admin,owner,boss,operator,manager,dispatcher,accountant,lab_worker,supplies,sales,plant_director,supervisor,vehicle_owner,client,weighing'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['required']=FALSE;
			$param = new FieldExtString('email'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtPassword('pwd'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtString('tel_ext'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtString('phone_cel'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Дата создания';
			$param = new FieldExtDateTimeTZ('create_dt'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtBool('banned'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtInt('time_zone_locale_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtInt('production_site_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Не используется, используется справочник user_map_to_production';
			$param = new FieldExtString('elkon_user_name'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Для облачной АТС';
			$param = new FieldExtString('domru_user_name'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtJSONB('params'
				,$f_params);
		$pm->addParam($param);
		
		$pm->addParam(new FieldExtInt('ret_id'));
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('User.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('User_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			$param = new FieldExtInt('id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtString('name'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$param = new FieldExtEnum('role_id',',','admin,owner,boss,operator,manager,dispatcher,accountant,lab_worker,supplies,sales,plant_director,supervisor,vehicle_owner,client,weighing'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtString('email'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtPassword('pwd'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtString('tel_ext'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtString('phone_cel'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Дата создания';
			$param = new FieldExtDateTimeTZ('create_dt'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtBool('banned'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('time_zone_locale_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('production_site_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Не используется, используется справочник user_map_to_production';
			$param = new FieldExtString('elkon_user_name'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Для облачной АТС';
			$param = new FieldExtString('domru_user_name'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtJSONB('params'
				,$f_params);
			$pm->addParam($param);
		
			$param = new FieldExtInt('id',array(
			));
			$pm->addParam($param);
		
			//default event
			$ev_opts = [
				'dbTrigger'=>FALSE
				,'eventParams' =>['id'
				]
			];
			$pm->addEvent('User.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('User_Model');

			
		/* delete */
		$pm = new PublicMethod('delete');
		
		$pm->addParam(new FieldExtInt('id'
		));		
		
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('from'));				
				
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('User.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('User_Model');

			
		/* get_list */
		$pm = new PublicMethod('get_list');
		
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('from'));
		$pm->addParam(new FieldExtString('cond_fields'));
		$pm->addParam(new FieldExtString('cond_sgns'));
		$pm->addParam(new FieldExtString('cond_vals'));
		$pm->addParam(new FieldExtString('cond_ic'));
		$pm->addParam(new FieldExtString('ord_fields'));
		$pm->addParam(new FieldExtString('ord_directs'));
		$pm->addParam(new FieldExtString('field_sep'));
		$pm->addParam(new FieldExtString('lsn'));

		$this->addPublicMethod($pm);
		
		$this->setListModelId('UserList_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('UserDialog_Model');		

			
		$pm = new PublicMethod('set_new_pwd');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtPassword('pwd',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('reset_pwd');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('user_id',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('login');
		
				
	$opts=array();
	
		$opts['alias']='Имя пользователя';
		$opts['length']=50;				
		$pm->addParam(new FieldExtString('name',$opts));
	
				
	$opts=array();
	
		$opts['alias']='Пароль';
		$opts['length']=20;				
		$pm->addParam(new FieldExtPassword('pwd',$opts));
	
				
	$opts=array();
	
		$opts['length']=2;				
		$pm->addParam(new FieldExtString('width_type',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('login_ext');
		
				
	$opts=array();
	
		$opts['alias']='Имя пользователя';
		$opts['length']=50;				
		$pm->addParam(new FieldExtString('name',$opts));
	
				
	$opts=array();
	
		$opts['alias']='Пароль';
		$opts['length']=20;				
		$pm->addParam(new FieldExtPassword('pwd',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('login_refresh');
		
				
	$opts=array();
	
		$opts['length']=50;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('refresh_token',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('login_k');
		
				
	$opts=array();
	
		$opts['length']=50;				
		$pm->addParam(new FieldExtString('k',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('login_ks');
		
				
	$opts=array();
	
		$opts['length']=50;				
		$pm->addParam(new FieldExtString('k',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('logout');
		
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('login_tm');
		
				
	$opts=array();
	
		$opts['length']=1000;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtText('auth_data',$opts));
	
				
	$opts=array();
	
		$opts['length']=2;				
		$pm->addParam(new FieldExtString('width_type',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('tm_check_tel');
		
				
	$opts=array();
	
		$opts['length']=10;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('tel',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('tm_send_code');
		
				
	$opts=array();
	
		$opts['length']=10;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('tel',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('tm_get_left_time');
		
				
	$opts=array();
	
		$opts['length']=10;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('tel',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('tm_check_code');
		
				
	$opts=array();
	
		$opts['length']=10;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('tel',$opts));
	
				
	$opts=array();
	
		$opts['length']=5;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('code',$opts));
	
				
	$opts=array();
	
		$opts['length']=2;				
		$pm->addParam(new FieldExtString('width_type',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('logout_html');
		
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('login_html');
		
				
	$opts=array();
	
		$opts['alias']='Имя пользователя';
		$opts['length']=50;				
		$pm->addParam(new FieldExtString('name',$opts));
	
				
	$opts=array();
	
		$opts['alias']='Пароль';
		$opts['length']=20;				
		$pm->addParam(new FieldExtPassword('pwd',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('logged');
		
		$this->addPublicMethod($pm);

			
		/* complete  */
		$pm = new PublicMethod('complete');
		$pm->addParam(new FieldExtString('pattern'));
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('ic'));
		$pm->addParam(new FieldExtInt('mid'));
		$pm->addParam(new FieldExtString('name'));		
		$this->addPublicMethod($pm);					
		$this->setCompleteModelId('UserList_Model');

			
		$pm = new PublicMethod('get_profile');
		
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('password_recover');
		
				
	$opts=array();
	
		$opts['length']=100;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('email',$opts));
	
				
	$opts=array();
	
		$opts['length']=10;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('captcha_key',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_user_operator_list');
		
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('from'));
		$pm->addParam(new FieldExtString('cond_fields'));
		$pm->addParam(new FieldExtString('cond_sgns'));
		$pm->addParam(new FieldExtString('cond_vals'));
		$pm->addParam(new FieldExtString('cond_ic'));
		$pm->addParam(new FieldExtString('ord_fields'));
		$pm->addParam(new FieldExtString('ord_directs'));
		$pm->addParam(new FieldExtString('field_sep'));
		$pm->addParam(new FieldExtString('lsn'));

		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('update_production_site');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('old_id',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('production_site_id',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('set_param');
		
				
	$opts=array();
	
		$opts['length']=200;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('name',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtText('val',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_param');
		
				
	$opts=array();
	
		$opts['length']=200;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('param_name',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('select_login_role');
		
				
	$opts=array();
	
		$opts['length']=150;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('role_id',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}
		
	
	public function insert($pm){
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->addAll();
	
		/*
		$email = $params->getVal('email');
		$tel = $params->getVal('phone_cel');	
		if (!strlen($email)){
			throw new Exception(User_Controller::ER_NO_EMAIL);
		}
		*/
		
		$new_pwd = '159753';//gen_pwd(self::PWD_LEN);
		$pm->setParamValue('pwd',$new_pwd);
		
		$model_id = $this->getInsertModelId();
		$model = new $model_id($this->getDbLinkMaster());
		$inserted_id_ar = $this->modelInsert($model,TRUE);
		
		//$this->pwd_notify($inserted_id_ar['id'],$new_pwd,"'".$new_pwd."'",$email,$tel);
			
		$fields = array();
		foreach($inserted_id_ar as $key=>$val){
			array_push($fields,new Field($key,DT_STRING,array('value'=>$val)));
		}			
		$this->addModel(new ModelVars(
			array('id'=>'InsertedId_Model',
				'values'=>$fields)
			)
		);
			
	}
	
	private function setLogged($logged){
		if ($logged){			
			$_SESSION['LOGGED'] = TRUE;			
		}
		else{
			session_destroy();
			$_SESSION = array();
		}		
	}
	public function logout(){
		$this->setLogged(FALSE);
	}
	
	public function logout_html(){
		$this->logout();
		header("Location: index.php");
	}
	
	/* array with user inf*/
	private function set_logged($ar,&$pubKey){
		//if($ar['role_id'] == "vehicle_owner" || $ar['role_id'] == "client"){
		//	throw new Exception("Доступ временно запрещен!");
		//}
		
		//global $dbLinkSessMaster;
		
		//check User-Agent header for restricted devices
		$headers = '';			
		if (!function_exists('getallheaders')){
			function getallheaders(){
				$headers = [];
				foreach ($_SERVER as $name => $value){
					if (substr($name, 0, 5) == 'HTTP_'){
						$headers[str_replace(' ', '-', ucwords(strtolower(str_replace('_', ' ', substr($name, 5)))))] = $value;
					}
				}
				return $headers;
			}
		} 
		$headers = getallheaders();
		//remove unnecessary headers
		$skeep_hd = ['if-modified-since','cookie','referer','connection','accept-encoding','accept-language','accept','content-length','content-type'];		
		foreach($skeep_hd as $skeep_k){
			if(isset($headers[$skeep_k])){
				unset($headers[$skeep_k]);
			}
		}
		
		$headers_json = $this->getDbLink()->escape_string(json_encode($headers));
		
		if (isset($headers['User-Agent'])){
			$userAgent = $headers['User-Agent'];//$_SERVER['HTTP_USER_AGENT'];
			if (PHP_VERSION_ID >= 70000) {
			
				$dd = new DeviceDetector($userAgent);
				$dd->skipBotDetection();
				$dd->parse();
				$header_user_agent = json_encode(array(
					'clientInfo'	=> $dd->getClient()
					,'osInfo'	=> $dd->getOs()
					,'device'	=> $dd->getDeviceName()
					,'brand'	=> $dd->getBrandName()
					,'model'	=> $dd->getModel()
				));
				
				//if ($ar['role_id']!='admin'
				//&&$ar['role_id']!='owner'
				//&&$ar['role_id']!='boss'
				//){
					$dev_hash_ar = $this->getDbLink()->query_first(sprintf(
						"SELECT md5(login_devices_uniq('%s')) AS hash", $header_user_agent
					));
					if(is_array($dev_hash_ar)
					&& count($dev_hash_ar)				
					&& $dev_hash_ar['hash']!=''
					){
						if(isset($ar['ban_hash']) && strpos($ar['ban_hash'], $dev_hash_ar['hash'])!==FALSE){
							throw new Exception(self::ER_DEVICE_BANNED);
						}
					
						//new device? было ло ли в logins такое устройство?
						$user_devices_ar = $this->getDbLink()->query_first(sprintf(
							"SELECT
								date_time_in
							FROM login_devices_list
							WHERE user_id = %d AND ban_hash = '%s'",
							$ar['id'],
							$dev_hash_ar['hash']
						));
						if(!is_array($user_devices_ar) || !count($user_devices_ar) ||!isset($user_devices_ar['date_time_in'])){
							//first login - ban!
							$this->getDbLinkMaster()->query(sprintf(
								"INSERT INTO login_device_bans
								(user_id, hash)
								VALUES (%d, '%s')
								ON CONFLICT (user_id, hash) DO NOTHING",
								$ar['id'],
								$dev_hash_ar['hash']
							));
							$this->getDbLinkMaster()->query(sprintf(
								"INSERT INTO logins
								(date_time_in, date_time_out, ip,session_id, pub_key, user_id, headers_j, user_agent)
								VALUES(now(), now(), '%s', '%s', 'NULL', %d, '%s', %s)"
								,$_SERVER["REMOTE_ADDR"]
								,session_id()
								,$ar['id']
								,$headers_json
								,is_null($header_user_agent)? 'NULL':"'".$header_user_agent."'"
							));								
							throw new Exception(self::ER_DEVICE_BANNED);
						}							
					}
				//}							
			}else{
				$header_user_agent = NULL;
			}
		}
		else{
			$header_user_agent = NULL;
		}
		$this->setLogged(TRUE);
		
		$_SESSION['user_id']		= $ar['id'];
		$_SESSION['user_name']		= $ar['name'];
		
		$_SESSION['role_id']		= $ar['role_id'];
		$_SESSION['USER_ROLE']		= $ar['role_id']; //for goapp
		
		$_SESSION['locale_id'] 		= 'ru';
		$_SESSION['user_time_locale'] 	= $ar['user_time_locale'];
		if(isset($ar['ct_tel_ext'])){
			$_SESSION['tel_ext'] 	= $ar['ct_tel_ext'];
		}else{
			$_SESSION['tel_ext'] 	= $ar['tel_ext'];
		}
		if(isset($ar['allowed_roles'])){
			$allowed_roles = json_decode($ar['allowed_roles']);
			if(is_array($allowed_roles) && count($allowed_roles) >1){
				$_SESSION['allowed_roles'] = $allowed_roles;
			}
		}
		
		if(isset($ar['production_sites_ref'])){
			$_SESSION['production_site_id']	= intval(json_decode($ar['production_sites_ref'])->keys->id);
		}		
		
		$_SESSION['first_shift_start_time'] = $ar['first_shift_start_time'];
		$_SESSION['first_shift_end_time'] = $ar['first_shift_end_time'];
		
		//microservices
		$_SESSION['ms_app_id']		= MS_APP_ID;
		$_SESSION['ms_role_id']		= 'client';
		
		//chat status
		if($ar['chat_statuses_ref']){
			$_SESSION['chat_statuses_ref']	= $ar['chat_statuses_ref'];
		}
		
		//$_SESSION['role_view_restriction']		= isset($ar['role_view_restriction'])? json_decode($ar['role_view_restriction']):NULL;
		
		SessionVarManager::addVar('eventServerToken','',TRUE);
		SessionVarManager::addVar('role_view_restriction',isset($ar['role_view_restriction'])? json_decode($ar['role_view_restriction']):NULL,TRUE);
		
		//shift start, end - default date filter
		$dt = time() + Beton::shiftStartTime();
		$date_from = Beton::shiftStart($dt);
		$date_to = Beton::shiftEnd($date_from);
		$shift_from_s = date("Y-m-d H:i:s", $date_from);
		$shift_to_s = date("Y-m-d H:i:s", $date_to);	

		//global filters				
		if ($ar['role_id']=='client'){
			$client_ar = $this->getDbLink()->query_first(sprintf("SELECT id,account_from_date FROM clients WHERE user_id=%d",$ar['id']));
			$_SESSION['global_client_id'] = (count($client_ar)&&isset($client_ar['id']))? $client_ar['id']:null;
			$_SESSION['global_client_from_date'] = (count($client_ar)&&isset($client_ar['account_from_date']))? strtotime($client_ar['account_from_date']):null;
			
			$model = new ShipmentForClientList_Model($this->getDbLink());
			$filter = new ModelWhereSQL();
			//client_id
			$field = clone $model->getFieldById('client_id');
			$field->setValue($_SESSION['global_client_id']);
			$filter->addField($field,'=');
			//client_from_date
			/*
			$field2 = clone $model->getFieldById('ship_date');
			$field2->setValue($_SESSION['global_client_from_date']);
			$filter->addField($field2,'>=');
			*/
			GlobalFilter::set('ShipmentForClientList_Model',$filter);
						
			$model = new OrderForClientList_Model($this->getDbLink());
			$filter = new ModelWhereSQL();
			$field = clone $model->getFieldById('client_id');
			$field->setValue($_SESSION['global_client_id']);
			$filter->addField($field,'=');
			//client_from_date
			/*
			$field2 = clone $model->getFieldById('date_time');
			$field2->setValue($_SESSION['global_client_from_date']);
			$filter->addField($field2,'>=');
			*/
			GlobalFilter::set('OrderForClientList_Model',$filter);
						
			$model = new ShipmentForOrderList_Model($this->getDbLink());
			$filter = new ModelWhereSQL();
			//client_id
			$field = clone $model->getFieldById('client_id');
			$field->setValue($_SESSION['global_client_id']);
			$filter->addField($field,'=');
			//client_from_date
			$field2 = clone $model->getFieldById('date_time');
			$field2->setValue($_SESSION['global_client_from_date']);
			$filter->addField($field2,'>=');
			GlobalFilter::set('ShipmentForOrderList_Model',$filter);
			
		}else if ($ar['role_id']=='vehicle_owner'){
			$ar_veh_owner = $this->getDbLink()->query_first(sprintf("SELECT id FROM vehicle_owners WHERE user_id=%d LIMIT 1",$ar['id']));
			if(is_array($ar_veh_owner) && count($ar_veh_owner)){
				$_SESSION['global_vehicle_owner_id'] = $ar_veh_owner['id'];
				$ar_clients = $this->getDbLink()->query_first(
					sprintf(
						"SELECT
							string_agg(client_id::text,',') AS client_list
						FROM vehicle_owner_clients
						WHERE vehicle_owner_id = (SELECT id FROM vehicle_owners WHERE user_id=%d)",
						$ar['id']
					)
				);
				if(is_array($ar_clients) && count($ar_clients) && isset($ar_clients['client_list'])){
					$_SESSION['global_vehicle_owner_client_list'] = $ar_clients['client_list'];
				}
				else{
					$_SESSION['global_vehicle_owner_client_list'] = '0';
				}
			}
			else{
				$_SESSION['global_vehicle_owner_id'] = 0;
			}
						
			$model = new OrderPumpList_Model($this->getDbLink());
			$filter = new ModelWhereSQL();
			$field = clone $model->getFieldById('pump_vehicle_owner_id');
			$field->setValue($_SESSION['global_vehicle_owner_id']);
			$filter->addField($field,'=');
			GlobalFilter::set('OrderPumpList_Model',$filter);
						
			$model = new ShipmentList_Model($this->getDbLink());
			$filter = new ModelWhereSQL();
			$field = clone $model->getFieldById('vehicle_owner_id');
			$field->setValue($_SESSION['global_vehicle_owner_id']);
			$filter->addField($field,'=');
			GlobalFilter::set('ShipmentList_Model',$filter);
						
			$model = new ShipmentForVehOwnerList_Model($this->getDbLink());
			$filter = new ModelWhereSQL();
			$field = clone $model->getFieldById('vehicle_owner_id');
			$field->setValue($_SESSION['global_vehicle_owner_id']);
			$filter->addField($field,'=');
			GlobalFilter::set('ShipmentForVehOwnerList_Model',$filter);
						
			$model = new ShipmentDialog_Model($this->getDbLink());
			$filter = new ModelWhereSQL();
			$field = clone $model->getFieldById('vehicle_owner_id');
			$field->setValue($_SESSION['global_vehicle_owner_id']);
			$filter->addField($field,'=');
			GlobalFilter::set('ShipmentDialog_Model',$filter);
						
			$model = new ShipmentPumpList_Model($this->getDbLink());
			$filter = new ModelWhereSQL();
			$field = clone $model->getFieldById('pump_vehicle_owner_id');
			$field->setValue($_SESSION['global_vehicle_owner_id']);
			$filter->addField($field,'=');
			GlobalFilter::set('ShipmentPumpList_Model',$filter);
						
			$model = new ShipmentPumpForVehOwnerList_Model($this->getDbLink());
			$filter = new ModelWhereSQL();
			$field = clone $model->getFieldById('pump_vehicle_owner_id');
			$field->setValue($_SESSION['global_vehicle_owner_id']);
			$filter->addField($field,'=');
			GlobalFilter::set('ShipmentPumpForVehOwnerList_Model',$filter);
			
			
			$cl_ar = explode(',',$_SESSION['global_vehicle_owner_client_list']);
			$cl_single = (count($cl_ar)==1);			
			
			//ALWAYS fieldId
			$filter = new ModelWhereSQL();
			if($cl_single){
				$expr = sprintf('client_id = %d',$_SESSION['global_vehicle_owner_client_list']);
			}
			else{
				$expr = sprintf('client_id IN (%s)',$_SESSION['global_vehicle_owner_client_list']);
			}
			$filter->addExpression('vehicle_owner_client_list',$expr,'AND');
			GlobalFilter::set('ShipmentForClientVehOwnerList_Model',$filter);
						
			
			//** owner list ***
			
			//ALWAYS fieldId
			$filter = new ModelWhereSQL();
			$filter->addExpression(
				'vehicle_owner_list',
				sprintf('%d =ANY(vehicle_owners_ar)',
					$_SESSION['global_vehicle_owner_id']
				),
				'AND'
			);
			GlobalFilter::set('VehicleDialog_Model',$filter);
			
			//ALWAYS fieldId
			$filter = new ModelWhereSQL();
			$filter->addExpression(
				'vehicle_owner_list',
				sprintf('%d =ANY(vehicle_owners_ar)',
					$_SESSION['global_vehicle_owner_id']
				),
				'AND'
			);
			GlobalFilter::set('PumpVehicleList_Model',$filter);
			
			//ALWAYS fieldId
			$filter = new ModelWhereSQL();
			$filter->addExpression(
				'vehicle_owner_list',
				sprintf('%d =ANY(pump_vehicle_owners_ar)',
					$_SESSION['global_vehicle_owner_id']
				),
				'AND'
			);
			GlobalFilter::set('PumpVehicleWorkList_Model',$filter);
						
		}else{

			//mild filters
			$filter = new ModelWhereSQL();
			$f1 = new FieldSQLDateTime(NULL, NULL, NULL, "date_time");
			$f1->setValue($date_from);
			$filter->addField($f1,'>=');		
			$f2 = new FieldSQLDateTime(NULL, NULL, NULL, "date_time");
			$f2->setValue($date_to);
			$filter->addField($f2,'<=');				
			GlobalFilter::set('OrderList_Model', $filter, TRUE);

			$filter = new ModelWhereSQL();
			$f1 = new FieldSQLDateTime(NULL, NULL, NULL, "date_time");
			$f1->setValue($date_from);
			$filter->addField($f1,'>=');		
			$f2 = new FieldSQLDateTime(NULL, NULL, NULL, "date_time");
			$f2->setValue($date_to);
			$filter->addField($f2,'<=');				
			GlobalFilter::set('OrderPumpList_Model', $filter, TRUE);

			$filter = new ModelWhereSQL();
			$f1 = new FieldSQLDateTime(NULL, NULL, NULL, "ship_date_time");
			$f1->setValue($date_from);
			$filter->addField($f1,'>=');		
			$f2 = new FieldSQLDateTime(NULL, NULL, NULL, "ship_date_time");
			$f2->setValue($date_to);
			$filter->addField($f2,'<=');				
			GlobalFilter::set('ShipmentList_Model', $filter, TRUE);

			$filter = new ModelWhereSQL();
			$f1 = new FieldSQLDateTime(NULL, NULL, NULL, "ship_date_time");
			$f1->setValue($date_from);
			$filter->addField($f1,'>=');		
			$f2 = new FieldSQLDateTime(NULL, NULL, NULL, "ship_date_time");
			$f2->setValue($date_to);
			$filter->addField($f2,'<=');				
			GlobalFilter::set('ShipmentForVehOwnerList_Model', $filter, TRUE);

			$filter = new ModelWhereSQL();
			$f1 = new FieldSQLDateTime(NULL, NULL, NULL, "ship_date");
			$f1->setValue($date_from);
			$filter->addField($f1,'>=');		
			$f2 = new FieldSQLDateTime(NULL, NULL, NULL, "ship_date");
			$f2->setValue($date_to);
			$filter->addField($f2,'<=');				
			GlobalFilter::set('ShipmentForClientList_Model', $filter, TRUE);

			$filter = new ModelWhereSQL();
			$f1 = new FieldSQLDateTime(NULL, NULL, NULL, "date_time");
			$f1->setValue($date_from);
			$filter->addField($f1,'>=');		
			$f2 = new FieldSQLDateTime(NULL, NULL, NULL, "date_time");
			$f2->setValue($date_to);
			$filter->addField($f2,'<=');				
			GlobalFilter::set('OrderForClientList_Model', $filter, TRUE);

			$filter = new ModelWhereSQL();
			$f1 = new FieldSQLDateTime(NULL, NULL, NULL, "ship_date");
			$f1->setValue($date_from);
			$filter->addField($f1,'>=');		
			$f2 = new FieldSQLDateTime(NULL, NULL, NULL, "ship_date");
			$f2->setValue($date_to);
			$filter->addField($f2,'<=');				
			GlobalFilter::set('ShipmentForClientVehOwnerList_Model', $filter, TRUE);

			$filter = new ModelWhereSQL();
			$f1 = new FieldSQLDateTime(NULL, NULL, NULL, "date_time");
			$f1->setValue($date_from);
			$filter->addField($f1,'>=');		
			$f2 = new FieldSQLDateTime(NULL, NULL, NULL, "date_time");
			$f2->setValue($date_to);
			$filter->addField($f2,'<=');				
			GlobalFilter::set('ShipmentPumpList_Model', $filter, TRUE);

			$filter = new ModelWhereSQL();
			$f1 = new FieldSQLDateTime(NULL, NULL, NULL, "date_time");
			$f1->setValue($date_from);
			$filter->addField($f1,'>=');		
			$f2 = new FieldSQLDateTime(NULL, NULL, NULL, "date_time");
			$f2->setValue($date_to);
			$filter->addField($f2,'<=');				
			GlobalFilter::set('ShipmentPumpForVehOwnerList_Model', $filter, TRUE);

			$filter = new ModelWhereSQL();
			$f1 = new FieldSQLDateTime(NULL, NULL, NULL, "ship_date");
			$f1->setValue($date_from);
			$filter->addField($f1,'>=');		
			$f2 = new FieldSQLDateTime(NULL, NULL, NULL, "ship_date");
			$f2->setValue($date_to);
			$filter->addField($f2,'<=');				
			GlobalFilter::set('ShipmentDateList_Model', $filter, TRUE);

			$filter = new ModelWhereSQL();
			$f1 = new FieldSQLDateTime(NULL, NULL, NULL, "date_time");
			$f1->setValue($date_from);
			$filter->addField($f1,'>=');		
			$f2 = new FieldSQLDateTime(NULL, NULL, NULL, "date_time");
			$f2->setValue($date_to);
			$filter->addField($f2,'<=');				
			GlobalFilter::set('DOCMaterialProcurementList_Model', $filter, TRUE);

			$filter = new ModelWhereSQL();
			$f1 = new FieldSQLDateTime(NULL, NULL, NULL, "date_time");
			$f1->setValue($date_from);
			$filter->addField($f1,'>=');		
			$f2 = new FieldSQLDateTime(NULL, NULL, NULL, "date_time");
			$f2->setValue($date_to);
			$filter->addField($f2,'<=');				
			GlobalFilter::set('MaterialFactConsumptionCorretionList_Model', $filter, TRUE);

			$filter = new ModelWhereSQL();
			$f1 = new FieldSQLDateTime(NULL, NULL, NULL, "issue_date_time");
			$f1->setValue($date_from);
			$filter->addField($f1,'>=');		
			$f2 = new FieldSQLDateTime(NULL, NULL, NULL, "issue_date_time");
			$f2->setValue($date_to);
			$filter->addField($f2,'<=');				
			GlobalFilter::set('RawMaterialTicketList_Model', $filter, TRUE);

			$filter = new ModelWhereSQL();
			$f1 = new FieldSQLDateTime(NULL, NULL, NULL, "start_time");
			$f1->setValue($date_from);
			$filter->addField($f1,'>=');		
			$f2 = new FieldSQLDateTime(NULL, NULL, NULL, "start_time");
			$f2->setValue($date_to);
			$filter->addField($f2,'<');				
			GlobalFilter::set('AstCallList_Model', $filter, TRUE);


			$filter = new ModelWhereSQL();
			$f1 = new FieldSQLDateTime(NULL, NULL, NULL, "date_time");
			$f1->setValue($date_from);
			$filter->addField($f1,'>=');		
			$f2 = new FieldSQLDateTime(NULL, NULL, NULL, "date_time");
			$f2->setValue($date_to);
			$filter->addField($f2,'<');				
			GlobalFilter::set('MaterialFactConsumptionRolledList_Model', $filter, TRUE);
		}	
		
		//raw material list
		$model = new RawMaterial_Model($this->getDbLink());
		$filter = new ModelWhereSQL();
		$field = clone $model->getFieldById('deleted');
		$field->setValue(FALSE);
		$filter->addField($field,'=');
		GlobalFilter::set('RawMaterial_Model', $filter, TRUE);

		//app_id clobal filter
					
		$model = new TmUserList_Model($this->getDbLink());
		$filter = new ModelWhereSQL();
		$field = clone $model->getFieldById('app_id');
		$field->setValue(MS_APP_ID);
		$filter->addField($field,'=');
		GlobalFilter::set('TmUserList_Model',$filter);
					
		$model = new TmUserDialog_Model($this->getDbLink());
		$filter = new ModelWhereSQL();
		$field = clone $model->getFieldById('app_id');
		$field->setValue(MS_APP_ID);
		$filter->addField($field,'=');
		GlobalFilter::set('TmUserDialog_Model',$filter);
					
		$model = new TmUserPhotoList_Model($this->getDbLink());
		$filter = new ModelWhereSQL();
		$field = clone $model->getFieldById('app_id');
		$field->setValue(MS_APP_ID);
		$filter->addField($field,'=');
		GlobalFilter::set('TmUserPhotoList_Model',$filter);
					
		$model = new TmOutMessageList_Model($this->getDbLink());
		$filter = new ModelWhereSQL();
		$field = clone $model->getFieldById('app_id');
		$field->setValue(MS_APP_ID);
		$filter->addField($field,'=');
		GlobalFilter::set('TmOutMessageList_Model',$filter);
					
		$model = new TmInMessage_Model($this->getDbLink());
		$filter = new ModelWhereSQL();
		$field = clone $model->getFieldById('app_id');
		$field->setValue(MS_APP_ID);
		$filter->addField($field,'=');
		GlobalFilter::set('TmInMessage_Model',$filter);
		
				
		$dif_sess_srv = (
			(defined('SESS_SERVER_MASTER')&&defined('DB_SERVER_MASTER')&&SESS_SERVER_MASTER!=DB_SERVER_MASTER)
			&& (isset($_SESSION['ms_app_id'])? $_SESSION['ms_app_id'] : ( defined('MS_APP_ID')? MS_APP_ID : 0))
		);
		
		$sess_db_link = $this->getDbLinkMaster();//$GLOBALS['dbLinkSessMaster'];
		$log_ar = $sess_db_link->query_first(sprintf(
			"SELECT pub_key
			FROM logins
			WHERE session_id='%s' AND user_id =%d AND date_time_out IS NULL%s"
			,session_id()
			,intval($ar['id'])
			,$dif_sess_srv? aprintf(' AND app_id=%d',MS_APP_ID):''
		));
		/* file_put_contents(OUTPUT_PATH.'login.txt',var_export($log_ar, true)); */
		if (!isset($log_ar['pub_key'])){
			//no user login
			
			$pubKey = uniqid();
			
			$log_ar = $sess_db_link->query_first(
				sprintf("UPDATE logins SET 
					user_id = %d,
					pub_key = '%s',
					date_time_in = now(),
					set_date_time = now(),
					headers_j='%s',
					user_agent=%s
					FROM (
						SELECT
							l.id AS id
						FROM logins l
						WHERE l.session_id='%s' AND l.user_id IS NULL
						ORDER BY l.date_time_in DESC
						LIMIT 1										
					) AS s
					WHERE s.id = logins.id
					RETURNING logins.id",
					intval($ar['id']),
					$pubKey,
					$headers_json,
					is_null($header_user_agent)? 'NULL':"'".$header_user_agent."'",
					session_id()
				)
			);				
			if (!isset($log_ar['id'])){
				//нет вообще юзера
				if($dif_sess_srv){
					$log_ar = $sess_db_link->query_first(sprintf(
						"INSERT INTO logins
						(date_time_in,ip,session_id,pub_key,user_id,headers_j,user_agent,app_id)
						VALUES(now(),'%s','%s','%s',%d,'%s',%s,%d)
						RETURNING id"
						,$_SERVER["REMOTE_ADDR"]
						,session_id()
						,$pubKey
						,$ar['id']
						,$headers_json
						,is_null($header_user_agent)? 'NULL':"'".$header_user_agent."'"
						,MS_APP_ID
					));								
				}
				else{
					$log_ar = $sess_db_link->query_first(sprintf(
						"INSERT INTO logins
						(date_time_in,ip,session_id,pub_key,user_id,headers_j,user_agent)
						VALUES(now(),'%s','%s','%s',%d,'%s',%s)
						RETURNING id"
						,$_SERVER["REMOTE_ADDR"]
						,session_id()
						,$pubKey
						,$ar['id']
						,$headers_json
						,is_null($header_user_agent)? 'NULL':"'".$header_user_agent."'"
					));								
				}
			}
			$_SESSION['LOGIN_ID'] = $log_ar['id'];			
		}
		else{
			//user logged
			$pubKey = trim($log_ar['pub_key']);
		}
	}
	
	private function do_login($pm,&$pubKey,&$pwd){		
		$pwd = $this->getExtVal($pm,'pwd');
		$ar = $this->getDbLink()->query_first(
			sprintf(
			"SELECT 
				ud.*,
				const_first_shift_start_time_val() AS first_shift_start_time,
				CASE
					WHEN const_shift_length_time_val()>='24 hours'::interval THEN
						const_first_shift_start_time_val()::interval + 
						const_shift_length_time_val()::interval-'24 hours 1 second'::interval
					ELSE
						const_first_shift_start_time_val()::interval + 
						const_shift_length_time_val()::interval-'1 second'::interval
				END AS first_shift_end_time,
				(SELECT string_agg(bn.hash,',') FROM login_device_bans bn WHERE bn.user_id=u.id) AS ban_hash,
				(SELECT
					json_build_object(
						'back_days_allowed',restr.back_days_allowed,
						'front_days_allowed',restr.front_days_allowed
						
					)
				FROM role_view_restrictions AS restr WHERE restr.role_id = u.role_id) AS role_view_restriction,
			users_login_roles(u.id) AS allowed_roles,

			u_ct.contact_id as login_contact_id
				
			FROM users AS u
			LEFT JOIN users_dialog AS ud ON ud.id=u.id
			LEFT JOIN entity_contacts AS u_ct ON u_ct.entity_type = 'users' AND u_ct.entity_id = u.id
			WHERE (u.name=%s OR u.email=%s) AND u.pwd=md5(%s)",
			$this->getExtDbVal($pm,'name'),
			$this->getExtDbVal($pm,'name'),
			$this->getExtDbVal($pm,'pwd')
			));
			
		if (!is_array($ar) || !count($ar)){
			throw new Exception(ERR_AUTH);
			
		}else if ($ar['banned']=='t'){
			throw new Exception(self::ER_BANNED);
			
		}else{
			$this->set_logged($ar,$pubKey);
			$_SESSION['width_type'] = $pm->getParamValue("width_type");			

			//base contact
			$_SESSION['login_contact_id'] = $ar["login_contact_id"];

			if(!isset($_SESSION["tm_photo"])){
				//login with "login" method
				$ar = $this->getDbLink()->query_first(sprintf(
					"SELECT
						encode(ex_u.tm_photo_preview, 'base64') AS tm_photo
					FROM notifications.ext_users AS ex_u
					WHERE ex_u.app_id = %d AND ex_u.ext_contact_id = %d"
					,MS_APP_ID
					,$_SESSION["login_contact_id"]
				));
				if(is_array($ar) && count($ar)){
					$_SESSION["tm_photo"] = $ar["tm_photo"];
				}
			}
		}
	}
	
	public function login($pm){		
		$pubKey = '';
		$pwd = '';
		$this->do_login($pm,$pubKey,$pwd);
		$this->add_auth_model($pubKey,session_id(),md5($pwd),$this->calc_session_expiration_time());
	}

	public function login_refresh($pm){	
	
		if(!defined('SESSION_EXP_SEC') || !intval(SESSION_EXP_SEC)){
			throw new Exception(self::ER_AUTOREFRESH_NOT_ALLOWED);
		}
		
		$p = new ParamsSQL($pm,$this->getDbLink());
		$p->addAll();
		$refresh_token = $p->getVal('refresh_token');
		$refresh_p = strpos($refresh_token,':');
		if ($refresh_p===FALSE){
			throw new Exception(ERR_AUTH);
		}
		$refresh_salt = substr($refresh_token,0,$refresh_p);
		$refresh_salt_db = NULL;
		$f = new FieldExtString('salt');
		FieldSQLString::formatForDb($this->getDbLink(),$f->validate($refresh_salt),$refresh_salt_db);
		
		$refresh_hash = substr($refresh_token,$refresh_p+1);
		
		$sess_db_link = $this->getDbLinkMaster();//$GLOBALS['dbLinkSessMaster'];
		$ar = $sess_db_link->query_first(sprintf(
			"SELECT
				l.id,
				trim(l.session_id) session_id
			FROM logins l
			WHERE l.date_time_out IS NULL AND l.pub_key=%s AND l.user_id=%d"
			,$refresh_salt_db
			,$_SESSION['user_id']
		));
		
		$u_pwd_ar = $this->getDbLink()->query_first(sprintf(
			"SELECT pwd AS u_pwd_hash FROM users WHERE id=%d"
			,$_SESSION['user_id']
		));
		
		if (!$ar['session_id'] || $refresh_hash!=md5($refresh_salt.$_SESSION['user_id'].$u_pwd_ar['u_pwd_hash'])
		){
			throw new Exception(ERR_AUTH);
		}	
				
		try{
			//session prolongation, new id assigning
			$old_sess_id = session_id();
			session_regenerate_id();
			$new_sess_id = session_id();
			$pub_key = uniqid();
			
			$sess_db_link->query('BEGIN');									
			$sess_db_link->query(sprintf(
			"UPDATE sessions
				SET id='%s'
			WHERE id='%s'",$new_sess_id,$old_sess_id));
			
			$sess_db_link->query(sprintf(
			"UPDATE logins
			SET
				set_date_time=now()::timestamp,
				session_id='%s',
				pub_key='%s'
			WHERE id=%d",$new_sess_id,$pub_key,$ar['id']));
			
			$sess_db_link->query('COMMIT');
		}
		catch(Exception $e){
			$sess_db_link->query('ROLLBACK');
			$this->setLogged(FALSE);
			throw new Exception(ERR_AUTH);
		}
		
		$this->add_auth_model($pub_key,$new_sess_id,$u_pwd_ar['u_pwd_hash'],$this->calc_session_expiration_time());
	}

	/**
	 * @returns {DateTime}
	 */
	private function calc_session_expiration_time(){
		return time()+
			(
				(defined('SESSION_EXP_SEC')&&intval(SESSION_EXP_SEC))?
				SESSION_EXP_SEC :
				( (defined('SESSION_LIVE_SEC')&&intval(SESSION_LIVE_SEC))? SESSION_LIVE_SEC : 365*24*60*60)
			);
	}
	
	private function add_auth_model($pubKey,$sessionId,$pwdHash,$expiration){
	
		$_SESSION['token'] = $pubKey.':'.md5($pubKey.$sessionId);
		$_SESSION['tokenExpires'] = $expiration;
		
		$fields = array(
			new Field('access_token',DT_STRING, array('value'=>$_SESSION['token'])),
			new Field('tokenExpires',DT_DATETIME,array('value'=>date('Y-m-d H:i:s',$expiration)))
		);
		
		if(defined('SESSION_EXP_SEC') && intval(SESSION_EXP_SEC)){
			$_SESSION['tokenr'] = $pubKey.':'.md5($pubKey.$_SESSION['user_id'].$pwdHash);			
			array_push($fields,new Field('refresh_token',DT_STRING,array('value'=>$_SESSION['tokenr'])));
		}
		
		setcookie("token",$_SESSION['token'],$expiration,'/');
		
		SessionVarManager::setValue('eventServerToken', $_SESSION['token'], FALSE);
		
		$this->addModel(new ModelVars(
			array('name'=>'Vars',
				'id'=>'Auth_Model',
				'values'=>$fields
			)
		));		
	}
		
	private function pwd_notify($userId,$pwd,$pwdDb,$email,$tel){
		if (strlen($email)){
			//email
			//@ToDo: change to notification
			CustomEmailSender::regEMail(
				$this->getDbLinkMaster(),
				sprintf("email_user_reset_pwd(%d,%s)",
					$userId,
					$pwdDb
				),
				NULL,
				'reset_pwd'
			);
		}		
		if (strlen($tel)){
			//SMS
			$q_id = $this->getDbLink()->query(sprintf(
				"SELECT * FROM sms_new_pwd(%d, '%s')",
				$userId,$pwd
			));
			$cnt = 0;
			while($ar = $this->getDbLink()->fetch_array($q_id)){
				add_notification_from_contact($this->getDbLinkMaster(), $ar['tel'], $ar['message'], 'reset_pwd', NULL, $ar['ext_contact_id']);
				$cnt++;
			}
			
			if(!$cnt){
				throw new Exception('pwd_notify: User has no contacts');
			}
		}
	
	}
	
	private function email_confirm_notify($userId,$key){
		//email
		//@ToDo: change to notification
		CustomEmailSender::regEMail(
			$this->getDbLinkMaster(),
			sprintf("email_user_email_conf(%d,%s)",
				$userId,$key
			),
			NULL,
			'user_email_conf'
		);
	}
	
	public function password_recover($pm){		
		$ar = $this->getDbLink()->query_first(sprintf(
		"SELECT id FROM users WHERE email=%s",
		$this->getExtDbVal($pm,'email')
		));
		if (!is_array($ar) || !count($ar)){
			throw new Exception('Адрес электронной почты не найден!');
		}		
		
		$pwd = gen_pwd(self::PWD_LEN);
		$pwd_db = "'".$pwd."'";
		try{
			$this->getDbLinkMaster()->query('BEGIN');
			
			$this->getDbLinkMaster()->query(sprintf(
				"UPDATE users SET pwd=md5(%s)
				WHERE id=%d",
				$pwd_db,$ar['id'])
			);
			$this->pwd_notify($ar['id'],$pwd,$pwd_db,$this->getExtVal($pm,'email'),NULL);
			
			$this->getDbLinkMaster()->query('COMMIT');
		}
		catch(Exception $e){
			$this->getDbLinkMaster()->query('ROLLBACK');
			throw new Exception($e);		
		}
	}
	
	public function get_time($pm){
		$this->addModel(new ModelVars(
			array('name'=>'Vars',
				'id'=>'Time_Model',
				'values'=>array(
					new Field('value',DT_STRING,
						array('value'=>round(microtime(true) * 1000)))
					)
				)
			)
		);		
	}
	
	public function register($pm){
		/*
		1) Проверить почту
		2) занести в users
		3) Подтверждение письма
		4) Отправить письмо для подтверждения мыла. после подтверждения можно заходить через мыло
		5) авторизовать
		*/
		
		$ar = $this->field_check($pm,'email');
		if (count($ar) && $ar['ex']=='t'){
			throw new Exception(self::ER_EMAIL_TAKEN);
		}
		
		try{
			$this->getDbLinkMaster()->query('BEGIN');
			
			$inserted_id_ar = $this->getDbLinkMaster()->query_first(sprintf(
			"INSERT INTO users (role_id,name,pwd,email,pers_data_proc_agreement,time_zone_locale_id)
			values ('client'::role_types,%s,md5(%s),%s,TRUE,1)
			RETURNING id",
			$this->getExtDbVal($pm,'name'),
			$this->getExtDbVal($pm,'pwd'),
			$this->getExtDbVal($pm,'email')
			));

			$ar_email_key = $this->getDbLinkMaster()->query_first(sprintf(
				"INSERT INTO user_email_confirmations (key,user_id)
				values (md5(CURRENT_TIMESTAMP::text),%d)
				RETURNING key",
				$inserted_id_ar['id']
			));
	
			ExpertEmailSender::addEMail(
				$this->getDbLinkMaster(),
				sprintf("email_new_account(%d,%s)",
					$inserted_id_ar['id'],$this->getExtDbVal($pm,'pwd')
				),
				NULL,
				'reset_pwd'
			);
		
			$this->email_confirm_notify($inserted_id_ar['id'],"'".$ar_email_key['key']."'");
		
			$ar = $this->getDbLink()->query_first(
				sprintf(
				"SELECT 
					u.*,
					const_first_shift_start_time_val() AS first_shift_start_time,
					CASE
						WHEN const_shift_length_time_val()>='24 hours'::interval THEN
							const_first_shift_start_time_val()::interval + 
							const_shift_length_time_val()::interval-'24 hours 1 second'::interval
						ELSE
							const_first_shift_start_time_val()::interval + 
							const_shift_length_time_val()::interval-'1 second'::interval
					END AS first_shift_end_time				
				FROM users_dialog AS u
				WHERE u.id=%d",
				$inserted_id_ar['id']
				));
			$pub_key = '';
			$this->set_logged($ar,$pub_key);
			
			$this->getDbLinkMaster()->query('COMMIT');
		}
		catch(Exception $e){
			$this->getDbLinkMaster()->query('ROLLBACK');
			throw new Exception($e);		
		}				
	}

	private function field_check($pm,$field){
		return $this->getDbLink()->query_first(sprintf("SELECT TRUE AS ex FROM users WHERE ".$field."=%s",$this->getExtDbVal($pm,$field)));
	}
	
	public function name_check($pm){
		$ar = $this->field_check($pm,'name');
		if (count($ar) && $ar['ex']=='t'){
			throw new Exception(self::ER_LOGIN_TAKEN);
		}
	}

	public function email_confirm($pm){
		try{
			$this->getDbLinkMaster()->query('BEGIN');
			$ar = $this->getDbLinkMaster()->query_first(sprintf(
				"UPDATE user_email_confiramtions
				SET confirmed=TRUE
				WHERE key=%s AND confirmed=FALSE
				RETURNING user_id",
				$this->getExtDbVal($pm,'key')
			));
			if (!count($ar)){
				throw new Exception('ER');
			}

			$this->getDbLinkMaster()->query(sprintf(
				"UPDATE users
				SET email_confirmed=TRUE
				WHERE id=%d",
				$ar['user_id']
			));
			
			$this->getDbLinkMaster()->query('COMMIT');
			
			header('index.php?v=EmailConfirmed');
		}	
		catch(Exception $e){
			$this->getDbLinkMaster()->query('ROLLBACK');
			
			header('HTTP/1.0 404 Not Found');
		}
	}
	public function get_profile(){
		if (!$_SESSION['user_id']){
			throw new Exception(self::ER_USER_NOT_DEFIND);	
		}
		$m = new UserProfile_Model($this->getDbLink());		
		$f = $m->getFieldById('id');
		$f->setValue($_SESSION['user_id']);		
		$where = new ModelWhereSQL();
		$where->addField($f,'=');
		$m->select(FALSE,$where,null,null,null,null,null,null,true);		
		$this->addModel($m);
	}
	
	//depricated use login_ks
	private function login_k_f($pm,$field){
		$link = $this->getDbLink();
		
		$k = NULL;
		FieldSQLString::formatForDb($link,$pm->getParamValue('k'),$k);
		
		$ar = $link->query_first(
			sprintf(
			"SELECT 
				u.*,
				usr.pwd AS pwd,
				const_first_shift_start_time_val() AS first_shift_start_time,
				CASE
					WHEN const_shift_length_time_val()>='24 hours'::interval THEN
						const_first_shift_start_time_val()::interval + 
						const_shift_length_time_val()::interval-'24 hours 1 second'::interval
					ELSE
						const_first_shift_start_time_val()::interval + 
						const_shift_length_time_val()::interval-'1 second'::interval
				END AS first_shift_end_time				
				
			FROM user_mac_addresses AS ma
			LEFT JOIN users_dialog AS u ON u.id=ma.user_id
			LEFT JOIN users AS usr ON usr.id=ma.user_id
			WHERE ma.%s=%s"
			,$field
			,$k
			));
			
		if ($ar){
			$pub_key = '';
			$this->set_logged($ar,$pub_key);
			
			//session id
			$this->addNewModel(sprintf(
				"SELECT '%s' AS id",session_id()
			),'session');
			
			$this->add_auth_model($pub_key,session_id(),$ar['pwd'],$this->calc_session_expiration_time());			
			
			//user inf
			$this->addModel(new ModelVars(
				array('name'=>'Vars',
					'id'=>'UserInf_Model',
					'values'=>array(
						new Field('name',DT_STRING, array('value'=>$ar['name'])),
						new Field('tel_ext',DT_STRING,array('value'=>$ar['tel_ext']))
					)
				)
			));		
			
		}
		else{
			throw new Exception(ERR_AUTH);
		}
	
	}

	//depricated use login_ks
	public function login_k($pm){
		$this->login_k_f($pm, 'mac_address');
	}
	
	//new method
	public function login_ks($pm){
		$this->login_k_f($pm, 'mac_address_hash');
	}
	
	private function update_pwd($userId,$pwd,$email,$tel){
		$pwd_db = NULL;
		FieldSQLString::formatForDb($this->getDbLink(),
			$pwd,
			$pwd_db);
	
		$this->pwd_notify($userId,$pwd,$pwd_db,$email,$tel);
		
		$this->getDbLinkMaster()->query(sprintf(
			"UPDATE users SET pwd=md5(%s)
			WHERE id=%d",
			$pwd_db,$userId)
		);
	}
	
	public function reset_pwd($pm){
		
		$ar = $this->getDbLink()->query_first(sprintf(
		"SELECT email,phone_cel
		FROM users
		WHERE id=%d",
		$this->getExtDbVal($pm,'user_id')
		));
		if (!is_array($ar)||!count($ar)){
			throw new Exception(User_Controller::ER_USER_NOT_DEFIND);
		}		
		if (!strlen($ar['email'])&&!strlen($ar['phone_cel'])){
			throw new Exception(User_Controller::ER_NO_EMAIL_TEL);
		}
		
		$this->update_pwd(
			$this->getExtDbVal($pm,'user_id'),
			gen_pwd(self::PWD_LEN),
			$ar['email'],$ar['phone_cel']);
	}
	
	
	public function update($pm){
		if($this->getExtDbVal($pm,'old_id')!=$_SESSION['user_id'] && $_SESSION['role_id']!='owner'){
			throw new Exception('Permission denied!');
		}
		parent::update($pm);
		
	}

	public function update_production_site($pm){
		$this->getDbLinkMaster()->query(
			sprintf(
				"UPDATE users
				SET production_site_id = %d
				WHERE id=%d",
				$this->getExtDbVal($pm,'production_site_id'),
				$this->getExtDbVal($pm,'old_id')
			)
		);
	}
	
	public function get_user_operator_list($pm){
		$model = new UserOperatorList_Model($this->getDbLink());
		$model->query("SELECT * FROM user_operator_list",TRUE);
		$this->addModel($model);
	}

	public static function closeConnection($conn,$pubKey){
		$conn->query(sprintf(
			"SELECT pg_notify(
			'User.logout'
			,json_build_object(
				'params',json_build_object(
					'pub_key','%s'
				)
			)::text
			)"
			,$pubKey
		));					
	
	}
	
	public function login_tm($pm){
		$auth_data = json_decode($pm->getParamValue('auth_data'), TRUE);
		$check_hash = $auth_data['hash'];
		unset($auth_data['hash']);
		$data_check_arr = [];
		foreach ($auth_data as $key => $value) {
			$data_check_arr[] = $key . '=' . $value;
		}		
		sort($data_check_arr);
		$data_check_string = implode("\n", $data_check_arr);
		$secret_key = hash('sha256', TM_BOT_TOKEN, true);
		$hash = hash_hmac('sha256', $data_check_string, $secret_key);
		if (strcmp($hash, $check_hash) !== 0) {
			throw new Exception(self::ERR_AUTH);
		}
		
		if ((time() - intval($auth_data['auth_date'])) > 86400) {
			throw new Exception('Data is outdated');
		}
		
		//match ext_users to our users
		$ar = $this->getDbLink()->query_first(sprintf(
			"SELECT 
				u.*,
				usr.pwd AS pwd,
				const_first_shift_start_time_val() AS first_shift_start_time,
				CASE
					WHEN const_shift_length_time_val()>='24 hours'::interval THEN
						const_first_shift_start_time_val()::interval + 
						const_shift_length_time_val()::interval-'24 hours 1 second'::interval
					ELSE
						const_first_shift_start_time_val()::interval + 
						const_shift_length_time_val()::interval-'1 second'::interval
				END AS first_shift_end_time				
				
			FROM notifications.ext_users AS ex_u
			LEFT JOIN client_tels AS ct ON ct.id = (ex_u.ext_obj->'keys'->>'id')::int
			LEFT JOIN users AS usr ON format_cel_standart(usr.phone_cel) = format_cel_standart(ct.tel)
			LEFT JOIN users_dialog AS u ON usr.id = u.id
			WHERE ex_u.app_id = %d AND ex_u.tm_user->>'id' = '%s'
			LIMIT 1"
			,MS_APP_ID
			,$auth_data['id']
		));
		
		if (!is_array($ar) || !count($ar)){
			//mark new user
			/*
			$this->getDbLinkMaster()->query(sprintf(
				"SELECT notifications.reg_ext_user(%d, '%s'::jsonb) AS id",
				MS_APP_ID,
				sprintf(
					'{"id":%s, "is_bot":false, "first_name":"%s", "username":"%s"}',
					$auth_data['id'],
					$auth_data['first_name'],
					$auth_data['username']
				)
			));
			*/
			throw new Exception('Нет соответствия пользователя из Telergam!');
			
		}else if ($ar['banned']=='t'){
			throw new Exception(self::ER_BANNED);
			
		}else{
			$pubKey = '';
			
			$this->getDbLinkMaster()->query('BEGIN');
			$log_e = NULL;
			try{
				$this->set_logged($ar, $pubKey);
			}catch(Exception $e){
				$log_e = $e;
			}
			$this->getDbLinkMaster()->query('COMMIT');
			if(!is_null($log_e)){
				throw $log_e;
			}
			
			$_SESSION['width_type'] = $pm->getParamValue("width_type");			
			
			if(isset($auth_data['photo_url'])){
				$_SESSION['photo_url'] = $auth_data['photo_url'];
			}
			$this->add_auth_model($pubKey, session_id(), md5($ar['pwd']), $this->calc_session_expiration_time());
		}
	}

	public function get_param($pm){
		$this->addNewModel(sprintf(
			"SELECT
				%s AS name,
				params->%s AS val
			FROM users
			WHERE id = %d"
			,$this->getExtDbVal($pm,'name')
			,$this->getExtDbVal($pm,'name')
			,$_SESSION['user_id']			
		),'UserParam_Model');	
	}

	/**
	 * Сверка введеного кода с кодом из Телеграм
	 * Это и есть авторизация, запрос совпадает с запросом из аторизации html
	 * все отправляется в set_logged
	 */
	public function tm_check_code($pm){
		$ar_log = $this->getDbLinkMaster()->query_first(sprintf(
			"SELECT
				l.*,
				(l.code_exp_date_time < now()::timestampTZ) AS code_expired
			FROM notifications.tm_logins AS l
			WHERE l.tel = %s AND app_id=%d",
			$this->getExtDbVal($pm,'tel'),
			MS_APP_ID
		));
		
		// code_expired используется для РЕгенерации кода
		if(is_array($ar_log) && count($ar_log) && $ar_log['code_expired']=='t'){
			//expired
			$this->getDbLinkMaster()->query(sprintf(
				"DELETE FROM notifications.tm_logins WHERE tel = %s AND app_id=%d",
				$this->getExtDbVal($pm,'tel'),
				MS_APP_ID
			));				
			throw new Exception('Истекло время ожидания, сгенерируйте новый код!');
		}
		
		if(!is_array($ar_log) || !count($ar_log)){
			//No code
			throw new Exception('Сформируйте новый код авторизации!');
			
		}else if(is_array($ar_log) && count($ar_log) && $ar_log['code']!=$this->getExtVal($pm,'code')
		&& intval($ar_log['tries']) > 0){
			$this->getDbLinkMaster()->query(sprintf(
				"UPDATE notifications.tm_logins
				SET tries = tries - 1
				WHERE tel = %s AND app_id=%d",
				$this->getExtDbVal($pm,'tel'),
				MS_APP_ID
			));
		
			throw new Exception('Неверный код авторизации!');
			
		}else if(is_array($ar_log) && count($ar_log) && $ar_log['tries']==0){
			//Max try count
			$this->getDbLinkMaster()->query(sprintf(
				"DELETE FROM notifications.tm_logins WHERE tel = %s AND app_id=%d",
				$this->getExtDbVal($pm,'tel'),
				MS_APP_ID
			));
			throw new Exception('Достигнуто максимальное число попыток ввода, сгенерите новый код!');
		}
		
		//OK
		$this->getDbLinkMaster()->query('BEGIN');
		try{
			$this->getDbLinkMaster()->query(sprintf(
				"DELETE FROM notifications.tm_logins WHERE tel = %s AND app_id=%d",
				$this->getExtDbVal($pm,'tel'),
				MS_APP_ID
			));
			
			//match ext_users to our users
			$ar = $this->getDbLinkMaster()->query_first(sprintf(
				"SELECT 
					u.*,
					usr.pwd AS pwd,
					const_first_shift_start_time_val() AS first_shift_start_time,
					CASE
						WHEN const_shift_length_time_val()>='24 hours'::interval THEN
							const_first_shift_start_time_val()::interval + 
							const_shift_length_time_val()::interval-'24 hours 1 second'::interval
						ELSE
							const_first_shift_start_time_val()::interval + 
							const_shift_length_time_val()::interval-'1 second'::interval
					END AS first_shift_end_time,
					encode(ex_u.tm_photo_preview, 'base64') AS tm_photo,
					
					(SELECT string_agg(bn.hash,',') FROM login_device_bans bn WHERE bn.user_id=u.id) AS ban_hash,
					(SELECT
						json_build_object(
							'back_days_allowed',restr.back_days_allowed,
							'front_days_allowed',restr.front_days_allowed
							
						)
					FROM role_view_restrictions AS restr WHERE restr.role_id = u.role_id
					) AS role_view_restriction,
					ct.tel_ext AS ct_tel_ext,
					users_login_roles(u.id) AS allowed_roles,
					u_ct.contact_id AS login_contact_id
					
				FROM notifications.ext_users AS ex_u
				LEFT JOIN entity_contacts AS u_ct ON u_ct.entity_type = 'users' AND u_ct.contact_id = ex_u.ext_contact_id
				LEFT JOIN contacts AS ct ON ct.id = u_ct.contact_id
				LEFT JOIN users AS usr ON usr.id = u_ct.entity_id
				LEFT JOIN users_dialog AS u ON usr.id = u.id
				WHERE ex_u.app_id = %d AND ex_u.ext_contact_id = %d
				LIMIT 1"
				,MS_APP_ID
				,$ar_log['ext_user_id']
			));
			
			//Если одно совпадение - берем его, если более одного, ищем незабаненного, если нет - ошибка, есть - берм его
			//
			if (!is_array($ar) || !count($ar)){
				//mark new user
				/*
				$this->getDbLinkMaster()->query(sprintf(
					"SELECT notifications.reg_ext_user(%d, '%s'::jsonb) AS id",
					MS_APP_ID,
					sprintf(
						'{"id":%s, "is_bot":false, "first_name":"%s", "username":"%s"}',
						$auth_data['id'],
						$auth_data['first_name'],
						$auth_data['username']
					)
				));
				*/
				throw new Exception('Нет соответствия пользователя из Telergam!');
				
			}else if ($ar['banned']=='t'){
				throw new Exception(self::ER_BANNED);
				
			}else{
				$pubKey = '';
				$this->getDbLinkMaster()->query('BEGIN');
				$log_e = NULL;
				try{
					$this->set_logged($ar, $pubKey);
				}catch(Exception $e){
					$log_e = $e;
				}
				$this->getDbLinkMaster()->query('COMMIT');
				if(!is_null($log_e)){
					throw $log_e;
				}
				
				$_SESSION['width_type'] = $pm->getParamValue("width_type");
				$_SESSION['tm_photo'] = $ar['tm_photo'];						
				
				if(isset($auth_data['photo_url'])){
					$_SESSION['photo_url'] = $auth_data['photo_url'];
				}
				
				//Этот контакт будет базовым для смены ролей, запомним, что через него залогинились!
				$_SESSION['login_contact_id'] = $ar['login_contact_id'];
				
				$this->add_auth_model($pubKey, session_id(), md5($ar['pwd']), $this->calc_session_expiration_time());
			}
			$this->getDbLinkMaster()->query('COMMIT');
			
		}catch(Exception $e){
			$this->getDbLinkMaster()->query('ROLLBACK');
			throw $e;
		}		
	}
	
	/**
	 * возвращает остаток времени, пока нельзя получить новый код
	 * если есть, или 0
	 * этот запрос всегда отправляется в браузере
	 * после открытия страницы с авторизацией, чтобы проверить вдруг повторное открытие
	 */
	public function tm_get_left_time($pm){
		$ar_log = $this->getDbLink()->query_first(sprintf(
			"SELECT
				round(EXTRACT(epoch FROM l.exp_date_time - now()::timestampTZ)) AS left_time,
				round(EXTRACT(epoch FROM l.code_exp_date_time - now()::timestampTZ)) AS code_left_time
			FROM notifications.tm_logins AS l
			WHERE l.tel = %s AND app_id=%d",
			$this->getExtDbVal($pm,'tel'),
			MS_APP_ID
		));
		$left_time = 0;
		$code_left_time = 0;
		if(is_array($ar_log) && count($ar_log) && isset($ar_log['left_time'])){
			$left_time = intval($ar_log['left_time']);
			if($left_time < 0){
				$left_time = 0;
			}
			$code_left_time = intval($ar_log['code_left_time']);
		}
		$this->addModel(new ModelVars(
			array('id'=>'TmLeftTime_Model',
				'values'=>array(
					new Field('left_time',DT_INT, array('value'=>$left_time))
					,new Field('code_left_time',DT_INT, array('value'=>$code_left_time))
				)
			)
		));						
	}
		
	/**
	 * Отпрвляет код в телеграм
	 */
	public function tm_send_code($pm){
		$ar_log = $this->getDbLink()->query_first(sprintf(
			"SELECT
				l.*,
				(l.exp_date_time < now()::timestampTZ) AS expired
			FROM notifications.tm_logins AS l
			WHERE l.tel = %s AND app_id=%d",
			$this->getExtDbVal($pm,'tel'),
			MS_APP_ID
		));
		if(is_array($ar_log) && count($ar_log) && $ar_log['expired']=='t'){
			//есть, но умер
			$this->getDbLinkMaster()->query(sprintf(
				"DELETE FROM notifications.tm_logins WHERE tel = %s AND app_id=%d",
				$this->getExtDbVal($pm,'tel'),
				MS_APP_ID
			));				
			
		}else if(is_array($ar_log)  &&  count($ar_log)){
			//еще живой
			throw new Exception('Код авторизации уже отправлен!');
		}

		$ar = $this->getDbLinkMaster()->query_first(sprintf(
			"SELECT
				u.tm_first_name AS first_name,
				u.ext_contact_id
			FROM notifications.ext_users_list AS u
			WHERE u.app_id = %d
				AND u.ext_contact_id=(SELECT ct.id FROM contacts AS ct WHERE ct.tel=%s LIMIT 1)"
			,MS_APP_ID
			,$this->getExtDbVal($pm,'tel')
		));
		
		/*
		$ar = $this->getDbLinkMaster()->query_first(sprintf(
			"SELECT
				u.tm_first_name AS first_name,
				u.ext_obj,
				t.id AS client_tel_id
			FROM client_tels AS t
			LEFT JOIN notifications.ext_users_list AS u ON
				u.ext_obj->>'dataType'='client_tels'
				AND (u.ext_obj->'keys'->>'id')::int=t.id
			WHERE format_cel_standart(t.tel) = %s AND u.ext_obj IS NOT NULL
			LIMIT 1",
			$this->getExtDbVal($pm,'tel')
		));
		*/
		
		if(!is_array($ar) || !count($ar)){
			throw new Exception(self::ER_USER_NOT_DEFIND);
		}
		
		$this->getDbLinkMaster()->query('BEGIN');
		try{
			$code = gen_pwd(3, "NUM");
			
			add_notification_from_contact_tm($this->getDbLinkMaster(), $this->getExtVal($pm,'tel'), 'Код авторизации: '.$code, 'tm_auth', NULL, $ar['ext_contact_id']);
			
			$tm_logins = $this->getDbLinkMaster()->query_first(sprintf(
				"SELECT 
					TRUE AS exists 
				FROM notifications.tm_logins 
				WHERE app_id = %d AND tel = %s",
				MS_APP_ID,
				$this->getExtDbVal($pm,'tel')
			));
			if(is_array($tm_logins) && count($tm_logins) && $tm_logins["exists"] == "t"){
				 $this->getDbLinkMaster()->query(sprintf(
					"DELETE FROM notifications.tm_logins 
					WHERE app_id = %d AND tel = %s",
					MS_APP_ID,
					$this->getExtDbVal($pm,'tel')
				));
			}

			$this->getDbLinkMaster()->query(sprintf(
				"INSERT INTO notifications.tm_logins (tel, exp_date_time, code_exp_date_time, tries, ext_user_id, app_id, code)
				VALUES (%s,
					now()::timestampTZ+'%d seconds'::interval,
					now()::timestampTZ+'%d seconds'::interval,
					%d, %d, %d, '%s'
				)",
				$this->getExtDbVal($pm,'tel'),
				self::TM_REGEN_DURATION_SEC,
				self::TM_CODE_DURATION_SEC,
				self::TM_ALLOWED_TRIES,
				$ar['ext_contact_id'],
				MS_APP_ID,
				$code
			));
			
			$this->getDbLinkMaster()->query('COMMIT');
			
		}catch(Exception $e){
			$this->getDbLinkMaster()->query('ROLLBACK');
			throw $e;
		}
	
	}
	
	/**
	 * Получение данных по номеру телефона
	 * Генерация нового кода
	 * TODO: make maximum incorrect call count, then wait
	 */
	public function tm_check_tel($pm){
		if(isset($_SESSION["user_tel_login_incorrect_count"]) && 
		$_SESSION["user_tel_login_incorrect_count"] > self::USER_TM_LOGIN_MAX_INCORRECT_COUNT 
		){
			if(isset($_SESSION["user_tel_login_incorrect_time"]) &&
				time() - $_SESSION["user_tel_login_incorrect_time"] < self::USER_TM_LOGIN_WAIT_SEC
			){
				throw new Exception("Слишком много неправильных ответов");
				$_SESSION["user_tel_login_incorrect_time"] = time();
			}
			unset($_SESSION["user_tel_login_incorrect_time"]);
		}

		$ar_log = $this->getDbLink()->query_first(sprintf(
			"SELECT
				l.*,
				(l.exp_date_time < now()::timestampTZ) AS regen_expired,
				(l.code_exp_date_time < now()::timestampTZ) AS code_expired,
				round(EXTRACT(epoch FROM l.exp_date_time - now()::timestampTZ)) AS left_time
			FROM notifications.tm_logins AS l
			WHERE l.tel = %s AND app_id=%d",
			$this->getExtDbVal($pm,'tel'),
			MS_APP_ID
		));
		
		$code_exists = FALSE;
		$left_time = 0;
		
		if(is_array($ar_log) && count($ar_log) && $ar_log['code_expired']=='t'){
			//есть, но умер
			$this->getDbLinkMaster()->query(sprintf(
				"DELETE FROM notifications.tm_logins WHERE tel = %s AND app_id=%d",
				$this->getExtDbVal($pm,'tel'),
				MS_APP_ID
			));				
			
		}else if(is_array($ar_log)  &&  count($ar_log) && $ar_log['regen_expired']!='t'){
			//еще живой
			$code_exists = TRUE;
			$left_time = intval($ar_log['left_time']);
		}

		$ar = $this->getDbLinkMaster()->query_first(sprintf(
			"SELECT
				u.tm_first_name AS first_name,
				encode(u_o.tm_photo,'base64') AS tm_photo
			FROM notifications.ext_users_photo_list AS u
			LEFT JOIN notifications.ext_users AS u_o ON u_o.id = u.id
			WHERE u.app_id = %d
				AND u.ext_contact_id=(SELECT ct.id FROM contacts AS ct WHERE ct.tel=%s LIMIT 1)"
			,MS_APP_ID
			,$this->getExtDbVal($pm,'tel')
		));

		if(!is_array($ar) || !count($ar)){
			if(!isset($_SESSION["user_tel_login_incorrect_count"])){
				$_SESSION["user_tel_login_incorrect_count"] = 0;
				$_SESSION["user_tel_login_incorrect_time"] = time();
			}
			$_SESSION["user_tel_login_incorrect_count"]++;
			throw new Exception(self::ER_USER_NOT_DEFIND);
		}
		unset($_SESSION["user_tel_login_incorrect_count"]);
		unset($_SESSION["user_tel_login_incorrect_time"]);
		
		$this->addModel(new ModelVars(
			array('id'=>'TmUserData_Model',
				'values'=>array(
					new Field('first_name',DT_STRING, array('value'=>$ar['first_name']))					
					,new Field('duration_sec',DT_INT, array('value'=>self::TM_REGEN_DURATION_SEC))
					,new Field('tel_duration_sec',DT_INT, array('value'=>self::TM_TEL_DURATION_SEC))
					,new Field('tel',DT_STRING, array('value'=>$this->getExtVal($pm,'tel')))
					,new Field('tm_photo',DT_STRING, array('value'=>$ar['tm_photo']))
					,new Field('code_exists',DT_BOOL, array('value'=>$code_exists))
					,new Field('left_time',DT_INT, array('value'=>$left_time))
				)
			)
		));				
	}
	
	public function set_param($pm){
		$name = $this->getExtVal($pm,'name');
		$val = $this->getExtVal($pm,'val');
		if(is_numeric($val)){
			$v = sprintf('"%s": %d', $name, $val);
		}else{
			//string/data/object
			//date= 2022-05-12,
			//	2022-05-12T14:26,
			//	2022-05-12T14:26:31,
			//	2022-05-12T14:26:31.000,
			//	2022-05-12T14:26:31Z+05:00
			//	, 2022-05-12T14:26:31.000Z05:00
			
			$v = sprintf('"%s": "%s"', $name, $val);
			$v = sprintf('"%s": %s', $name, $val);
		}
		
		$this->getDbLinkMaster()->query(sprintf(
			"UPDATE users
			SET params = params||%s
			WHERE id = %d"
			,$v
			,$_SESSION['user_id']			
		));	
	
	}
	
	/**
	 * Можем сменить роль пользователя на любую, ему доступную
	 * только чтобы не забаненная!
	 */
	public function select_login_role($pm){
		//Обязятально должны были залогиниться через контакт!
		if(!isset($_SESSION['user_id']) || !$_SESSION['user_id'] || !isset($_SESSION['login_contact_id'])){
			throw new Exception('Session user_id not set');
		}
		$login_contact_id = $_SESSION['login_contact_id'];
		
		//check selected role and ban
		$ar = $this->getDbLinkMaster()->query_first(sprintf(
			"SELECT 
				ud.*,
				const_first_shift_start_time_val() AS first_shift_start_time,
				CASE
					WHEN const_shift_length_time_val()>='24 hours'::interval THEN
						const_first_shift_start_time_val()::interval + 
						const_shift_length_time_val()::interval-'24 hours 1 second'::interval
					ELSE
						const_first_shift_start_time_val()::interval + 
						const_shift_length_time_val()::interval-'1 second'::interval
				END AS first_shift_end_time,
				(SELECT string_agg(bn.hash,',') FROM login_device_bans bn WHERE bn.user_id=u.id) AS ban_hash,
				(SELECT
					json_build_object(
						'back_days_allowed',restr.back_days_allowed,
						'front_days_allowed',restr.front_days_allowed
						
					)
				FROM role_view_restrictions AS restr WHERE restr.role_id = u.role_id) AS role_view_restriction,
				users_login_roles(u.id) AS allowed_roles
				
			FROM users AS u
			LEFT JOIN users_dialog AS ud ON ud.id=u.id
			WHERE
				--Подберем другого пользователя по данному контакту
				
				-- Не текущий (нужен любой другой)
				u.id <> %d
				
				-- Требуемая роль
				AND u.role_id = %s
				
				-- контакт с которым логинились входит в пользователя
				AND %d IN (SELECT contact_id FROM entity_contacts WHERE entity_type='users' and entity_id = u.id)
				
			-- Может случиться, что более одного пользователя с такой ролью и этим контактом
			LIMIT 1"			
			,$_SESSION['user_id']
			,$this->getExtDbVal($pm, 'role_id')
			,$login_contact_id
		));
		
		if (!is_array($ar) || !count($ar)){
			//mark new user
			throw new Exception('Session user_id not found');
			
		}else if ($ar['banned']=='t'){
			throw new Exception(self::ER_BANNED);
			
		}else{
			//
			$width_type = $_SESSION['width_type'];
			$tm_photo = isset($_SESSION['tm_photo'])? $_SESSION['tm_photo'] : NULL;	
			$photo_url = isset($_SESSION['photo_url'])? $_SESSION['photo_url'] : NULL;		

			//DO NOT KILL OLD SESSSION!!!!
			//$_SESSION = array(); 
		
			$pubKey = '';
			$this->set_logged($ar, $pubKey);
			$_SESSION['width_type'] = $width_type;
			$_SESSION['tm_photo'] = $tm_photo;
			$_SESSION['photo_url'] = $photo_url;
			
			//base contact
			$_SESSION['login_contact_id'] = $login_contact_id;
			
			$this->add_auth_model($pubKey, session_id(), md5($ar['pwd']), $this->calc_session_expiration_time());

			//add lsn model
			/* $ar = $this->getDbLinkMaster()->query_first(sprintf("SELECT pg_current_wal_lsn() AS lsn")); */
			/* if(is_array($ar) && count($ar) && isset($ar["lsn"])) { */
			/* 	$this->addModel(new ModelVars( */
			/* 		array('name' => 'Vars', */
			/* 			'id' => 'Lsn_Model', */
			/* 			'values' => array(new Field("lsn", DT_STRING, array('value' => $ar["lsn"])))  */
			/* 		) */
			/* 	));		 */
			/* } */
		}
	}
	

}
?>
