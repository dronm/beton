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



require_once(USER_CONTROLLERS_PATH.'Graph_Controller.php');
require_once(USER_CONTROLLERS_PATH.'RawMaterial_Controller.php');
require_once(USER_CONTROLLERS_PATH.'RawMaterialTicket_Controller.php');
require_once(USER_CONTROLLERS_PATH.'VehicleSchedule_Controller.php');
require_once(USER_CONTROLLERS_PATH.'Shipment_Controller.php');
require_once(USER_CONTROLLERS_PATH.'Weather_Controller.php');
require_once(USER_CONTROLLERS_PATH.'Destination_Controller.php');

require_once(USER_MODELS_PATH.'OrderMakeList_Model.php');
require_once(USER_MODELS_PATH.'ConcreteType_Model.php');
require_once(USER_MODELS_PATH.'Lang_Model.php');

require_once(FUNC_PATH.'EventSrv.php');

require_once('common/MyDate.php');

require_once(ABSOLUTE_PATH.'functions/Beton.php');
require_once(ABSOLUTE_PATH.'functions/notifications.php');
require_once(ABSOLUTE_PATH.'functions/checkPmPeriod.php');

class Order_Controller extends ControllerSQL{

	const ER_PERIOD_NOT_ALLOWED = 'Запрещено просматривать период!';

	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			

		/* insert */
		$pm = new PublicMethod('insert');
		
			$f_params = array();
			
				$f_params['alias']='клиент';
			
				$f_params['required']=TRUE;
			$param = new FieldExtInt('client_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Направление';
			
				$f_params['required']=TRUE;
			$param = new FieldExtInt('destination_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Марка бетона';
			
				$f_params['required']=TRUE;
			$param = new FieldExtInt('concrete_type_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Прокачка';
			
				$param = new FieldExtEnum('unload_type',',','pump,band,none'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Комментарий';
			
				$f_params['required']=FALSE;
			$param = new FieldExtText('comment_text'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Описание';
			
				$f_params['required']=FALSE;
			$param = new FieldExtText('descr'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Дата';
			
				$f_params['required']=TRUE;
			$param = new FieldExtDateTime('date_time'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Время до';
			
				$f_params['required']=FALSE;
			$param = new FieldExtDateTime('date_time_to'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Количество';
			$param = new FieldExtFloat('quant'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Сот.телефон';
			$param = new FieldExtString('phone_cel'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Разгрузка куб/ч';
			$param = new FieldExtFloat('unload_speed'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Автор';
			$param = new FieldExtInt('user_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Язык';
			$param = new FieldExtInt('lang_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Сумма';
			$param = new FieldExtFloat('total'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Стоимость';
			$param = new FieldExtFloat('concrete_price'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Стоимость дост.';
			$param = new FieldExtFloat('destination_price'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Стоимость прокачки';
			$param = new FieldExtFloat('unload_price'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Насос';
			$param = new FieldExtInt('pump_vehicle_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Оплата на месте';
			$param = new FieldExtBool('pay_cash'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtBool('total_edit'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtBool('payed'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtBool('under_control'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Кто последний вносил изменения';
			$param = new FieldExtInt('last_modif_user_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Время последнего изменения';
			$param = new FieldExtDateTimeTZ('last_modif_date_time'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Время создания';
			$param = new FieldExtDateTimeTZ('create_date_time'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Для другого завода';
			$param = new FieldExtBool('ext_production'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Контакт';
			
				$f_params['required']=FALSE;
			$param = new FieldExtInt('contact_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Спецификация';
			$param = new FieldExtInt('client_specification_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='F';
			$param = new FieldExtInt('f_val'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='W';
			$param = new FieldExtInt('w_val'
				,$f_params);
		$pm->addParam($param);
		
		$pm->addParam(new FieldExtInt('ret_id'));
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('Order.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('Order_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			$param = new FieldExtInt('id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='клиент';
			$param = new FieldExtInt('client_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Направление';
			$param = new FieldExtInt('destination_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Марка бетона';
			$param = new FieldExtInt('concrete_type_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Прокачка';
			
				$param = new FieldExtEnum('unload_type',',','pump,band,none'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Комментарий';
			$param = new FieldExtText('comment_text'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Описание';
			$param = new FieldExtText('descr'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Дата';
			$param = new FieldExtDateTime('date_time'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Время до';
			$param = new FieldExtDateTime('date_time_to'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Количество';
			$param = new FieldExtFloat('quant'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Сот.телефон';
			$param = new FieldExtString('phone_cel'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Разгрузка куб/ч';
			$param = new FieldExtFloat('unload_speed'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Автор';
			$param = new FieldExtInt('user_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Язык';
			$param = new FieldExtInt('lang_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Сумма';
			$param = new FieldExtFloat('total'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Стоимость';
			$param = new FieldExtFloat('concrete_price'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Стоимость дост.';
			$param = new FieldExtFloat('destination_price'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Стоимость прокачки';
			$param = new FieldExtFloat('unload_price'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Насос';
			$param = new FieldExtInt('pump_vehicle_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Оплата на месте';
			$param = new FieldExtBool('pay_cash'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtBool('total_edit'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtBool('payed'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtBool('under_control'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Кто последний вносил изменения';
			$param = new FieldExtInt('last_modif_user_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Время последнего изменения';
			$param = new FieldExtDateTimeTZ('last_modif_date_time'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Время создания';
			$param = new FieldExtDateTimeTZ('create_date_time'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Для другого завода';
			$param = new FieldExtBool('ext_production'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Контакт';
			$param = new FieldExtInt('contact_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Спецификация';
			$param = new FieldExtInt('client_specification_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='F';
			$param = new FieldExtInt('f_val'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='W';
			$param = new FieldExtInt('w_val'
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
			$pm->addEvent('Order.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('Order_Model');

			
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
		$pm->addEvent('Order.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('Order_Model');

			
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
		
		$this->setListModelId('OrderList_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('OrderDialog_Model');		

			
		$pm = new PublicMethod('get_object_for_lab');
		
				
	$opts=array();
			
		$pm->addParam(new FieldExtInt('id',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_make_orders_form');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtDate('date',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtString('lsn',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_make_orders_form_ord');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtDate('date',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtString('lsn',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_make_orders_form_veh');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtDate('date',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtString('lsn',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_make_orders_form_mat');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtDate('date',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtString('lsn',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_make_orders_for_weighing_form');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtDate('date',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtString('lsn',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_make_orders_for_lab_form');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtDate('date',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtString('lsn',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_make_orders_for_lab_form_ord');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtDate('date',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtString('lsn',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_make_orders_for_lab_form_veh');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtDate('date',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtString('lsn',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_make_orders_for_lab_form_mat');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtDate('date',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtString('lsn',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_make_orders_list');
		
				
					
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('get_make_orders_list.delete',$ev_opts);

					
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('get_make_orders_list.delete',$ev_opts);

				
				
	$opts=array();
			
		$pm->addParam(new FieldExtInt('id',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_make_orders_for_lab_list');
		
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_avail_spots');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtDate('date',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtFloat('quant',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtFloat('speed',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('complete_descr');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('client_id',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtString('descr',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_comment');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('order_id',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('fields_from_client_order');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('client_order_id',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('set_payed');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('id',$opts));
	
			
		$this->addPublicMethod($pm);

			
		/* complete  */
		$pm = new PublicMethod('complete');
		$pm->addParam(new FieldExtString('pattern'));
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('ic'));
		$pm->addParam(new FieldExtInt('mid'));
		$pm->addParam(new FieldExtString('number'));		
		$this->addPublicMethod($pm);					
		$this->setCompleteModelId('OrderList_Model');

			
		$pm = new PublicMethod('get_list_for_client');
		
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

			
		$pm = new PublicMethod('calc_for_site');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtText('address',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('concrete_type_id',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtFloat('quant',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}	
	
	/**
	 * smsFunc: sms_pump_order_ins/sms_pump_order_upd/sms_pump_order_del
	 */
	private function send_pumpSMS($smsFunc, $orderId, $ordersRef, $specialistInform){
		if(!SMS_ACTIVE){
			return;
		}
		//Вызываем новые SQL функции *_ct(), которые используют контакты, а не телефоны из таблиц!
		$pump_sms_q_id = $this->getDbLink()->query(sprintf(
			"SELECT * FROM %s_ct(%d)"
			,$smsFunc
			,$orderId
		));

		if($smsFunc=='sms_pump_order_ins'){
			$sms_type = 'order_for_pump_ins';
			
		}else if($smsFunc=='sms_pump_order_upd'){
			$sms_type = 'order_for_pump_upd';
			
		}else if($smsFunc=='sms_pump_order_del'){
			$sms_type = 'order_for_pump_del';
		}

		$link_m = $this->getDbLinkMaster();
		$pump_sms_mes = NULL;
		while($pump_sms_ar = $this->getDbLink()->fetch_array($pump_sms_q_id)){
			$pump_sms_mes = $pump_sms_ar['message'];
			add_notification_from_contact($link_m, $pump_sms_ar['phone_cel'], $pump_sms_mes, $sms_type, $ordersRef, $pump_sms_ar['ext_contact_id']);
		}
		
		//ответственному
		if(!is_null($pump_sms_mes) && $specialistInform){
			$tel_id = $this->pumpActionRespTels($sms_type);
			
			while($tel = $this->getDbLink()->fetch_array($tel_id)){			
				add_notification_from_contact($link_m, $tel['phone_cel'], $pump_sms_mes, $sms_type, $ordersRef, $tel['ext_contact_id']);
			}															
		}
	
	}
	
	public function send_messages($id, $phone_cel, $quant, $total,
		$date_time, $concrete_type_id, $destination_id,
		$lang_id, $pumpVehicleId, $order_update,
		$ordersRef, $extContactId){
		//SMS service		
		if (SMS_ACTIVE && strlen($phone_cel)){
			$dbLink = $this->getDbLink();
			$dbLinkMaster = $this->getDbLinkMaster();
			
			//$ar_doc = $dbLinkMaster->query_first(sprintf("SELECT orders_ref(orders) AS orders_ref FROM orders WHERE id=%d",$id));
			
			if (strlen($phone_cel)){
				//date + rout time
				$date_time_str = NULL;
				FieldSQLDateTime::formatForDb($date_time,$date_time_str);
				$ar = $dbLink->query_first(sprintf(
					"SELECT %s::timestamp + coalesce(time_route,'00:00'::time) AS date_time
					FROM destinations
					WHERE id=%d",
					$date_time_str,$destination_id)
				);
				if ($ar){
					$date_time = strtotime($ar['date_time']);
				}
				$lang_id = intval($lang_id);
				$lang_id = ($lang_id==0)? 1:$lang_id;
				$ar = $dbLink->query_first(sprintf(
					"SELECT
						pattern AS text
					FROM sms_patterns
					WHERE sms_type='%s'::sms_types AND lang_id=%d",
					(floatval($quant)>0)? 'order':'order_cancel',
					$lang_id					
				));
				if (!is_array($ar) || count($ar)==0){
					throw new Exception('Шаблон для SMS не найден!');
				}
				$text = str_replace('[quant]',$quant,$ar['text']);
				$total_repl= ($total)? ' стоимость:'.$total:'';
				$text = str_replace('[total]',$total_repl,$text);
				$text = str_replace('[time]',date('H:i',$date_time),$text);
				$text = str_replace('[date]',date('d/m/y',$date_time),$text);
				$text = str_replace('[day_of_week]',MyDate::getRusDayOfWeek($date_time),$text);
				
				$is_dest = (strpos($text,'[dest]')>=0);
				$is_concr = (strpos($text,'[concrete]')>=0);
				if ($is_dest || $is_concr){
					$q = 'SELECT ';
					if ($is_dest){
						$q.='(SELECT name FROM destinations WHERE id='.$destination_id.') AS dest';
					}
					if ($is_concr){
						if ($is_dest){
							$q.=',';
						}
						$q.='(SELECT name FROM concrete_types WHERE id='.$concrete_type_id.') AS concrete';
					}
					$ar = $dbLink->query_first($q);
					foreach($ar as $key=>$val){
						$text = str_replace(sprintf('[%s]',$key),$val,$text);
					}
				}
			}
			
			if (strlen($phone_cel)){
				$sms_type = (floatval($quant)>0)? 'order':'order_cancel';
				add_notification_from_contact($dbLinkMaster, $phone_cel, $text, $sms_type, $ordersRef, $extContactId);
			}
			
			$sms_res_str = '';
			$sms_res_ok = 1;
		}
		else{
			$sms_res_str = 'Сервис SMS выключен.';
			$sms_res_ok = 0;
		}
		
		/**
		 * Больше такая отправка не используется, чтобы иметь возможность
		 * отслеживать тексты, время и т.д.
		 */ 
		$this->addModel(new ModelVars(
			array('id'=>'SMSSend',
				'values'=>array(
					new Field('sent',DT_INT,
						array('value'=>$sms_res_ok))
					,					
					new Field('resp',DT_STRING,
						array('value'=>$sms_res_str))
					)
				)
			)
		);
	}
	
	public function insert($pm){
	
		if($_SESSION['role_id']!='owner'||!$pm->getParamValue('user_id')){
			$pm->setParamValue('user_id',$_SESSION['user_id']);
		}
	
		Graph_Controller::clearCacheOnDate($this->getDbLink(),$pm->getParamValue("date_time"));
		
		
		$pm->addParam(new FieldExtInt('ret_id',array('value'=>1)));
		$id_ar = parent::insert($pm);

		$pump_vehicle_id = $pm->getParamValue("pump_vehicle_id");
		$ar_doc = $this->getDbLinkMaster()->query_first(sprintf(
			"SELECT
				orders_ref(o) AS orders_ref,
				coalesce(o.contact_id, ct.id) AS ext_contact_id,
				coalesce(pv.specialist_inform, FALSE) AS specialist_inform
			FROM orders AS o
			LEFT JOIN contacts AS ct ON ct.tel = o.phone_cel
			LEFT JOIN pump_vehicles AS pv ON pv.id = o.pump_vehicle_id
			WHERE o.id=%d"
			,$id_ar['id']
		));

		$this->send_messages(
			$id_ar['id'],
			$pm->getParamValue('phone_cel'),
			$pm->getParamValue('quant'),
			($pm->getParamValue('pay_cash')=='true')?
				$pm->getParamValue('total'):0,
			$pm->getParamValue('date_time'),
			$pm->getParamValue('concrete_type_id'),
			$pm->getParamValue('destination_id'),
			$pm->getParamValue('lang_id'),
			$pump_vehicle_id,
			FALSE,
			$ar_doc['orders_ref'],
			$ar_doc['ext_contact_id']
		);
		
		//насоснику insert
		if ($pump_vehicle_id!='null'){
			try{
				$this->send_pumpSMS('sms_pump_order_ins', $id_ar['id'], $ar_doc['orders_ref'], ($ar_doc['specialist_inform']=='t'));
			}catch(Exception $e){
				error_log($e->getMessage());
			}
		}		
	}
	
	public function update($pm){
	
		$pm->setParamValue('last_modif_user_id',$_SESSION['user_id']);
	
		$order_id = $this->getExtDbVal($pm, 'old_id');
	
		$dbLink = $this->getDbLink();
		$ar = $dbLink->query_first(sprintf(
			"SELECT
				o.date_time,
				o.quant,
				o.pay_cash,
				CASE WHEN o.pay_cash THEN o.total ELSE 0 END AS total,
				o.unload_speed,
				o.phone_cel,
				o.concrete_type_id,
				o.destination_id,
				o.lang_id,
				COALESCE(o.pump_vehicle_id::text,'null') AS pump_vehicle_id,
				COALESCE(
					(SELECT SUM(sh.quant)>0
					FROM shipments sh
					WHERE sh.order_id=o.id
					),
				FALSE
				) AS shipped,
				orders_ref(o) AS orders_ref,
				coalesce(o.contact_id, ct.id) AS ext_contact_id,
				coalesce(pv.specialist_inform,FALSE) AS specialist_inform,
				o.client_specification_id,
				o.pay_cash,
				o.total_edit
				
			FROM orders AS o
			LEFT JOIN pump_vehicles AS pv ON pv.id = o.pump_vehicle_id
			LEFT JOIN contacts AS ct ON ct.tel = o.phone_cel
			WHERE o.id=%d",
			$order_id
		));
		
		$new_pump_vehicle_id = $this->getExtVal($pm,'pump_vehicle_id');
		
		if (is_array($ar) && count($ar)){
			$old_date_time = strtotime($ar['date_time']);
			$new_date_time = $pm->getParamValue("date_time");
			
			$rebuild_chart = (
				 (floatval($this->getExtDbVal($pm,'quant'))!=floatval($ar['quant']))
				||(intval($this->getExtDbVal($pm,'unload_speed'))!=intval($ar['unload_speed']))
				||(isset($new_date_time) && $new_date_time!=$old_date_time)
			);
			if ($rebuild_chart){
				Graph_Controller::clearCacheOnDate($dbLink, $old_date_time);
			}
			
			if (isset($new_date_time) && $new_date_time != $old_date_time){
				Graph_Controller::clearCacheOnDate($dbLink, $new_date_time);
			}			
			
			//если был насос, а сейчас нет или замена насоса - СМС старому насоснику
			if(isset($ar['pump_vehicle_id'])
			&& isset($new_pump_vehicle_id)
			&& ($new_pump_vehicle_id=='null' || $new_pump_vehicle_id!=$ar['pump_vehicle_id'])
			){
				try{
					$this->send_pumpSMS('sms_pump_order_del', $order_id, $ar['orders_ref'], ($ar['specialist_inform']=='t'));
				}catch(Exception $e){
					error_log($e->getMessage());
				}
			}									
		}

		if($_SESSION["role_id"] == "lab_worker"){
			//if concrete_type_id has changed and client_specification_id is not null - clear,
			// if concrete_type_id has changed and pay_cash and !total_edit - recalc total

			$concrete_type_id = $this->getExtVal($pm,'concrete_type_id');
			if(isset($concrete_type_id) && $concrete_type_id !='null'
			&& $concrete_type_id != $ar["concrete_type_id"]
			){
				if(isset($ar["client_specification_id"])){
					//clear specification
					$pm->setParamValue("client_specification_id", "null");
				}
				if(isset($ar["pay_cash"]) && $ar["pay_cash"] == "t"
				&& $ar["total_edit"] != "t"
				){
					//recalc is not implemented
					throw new Exception("При изменении марки с ценой необходим пересчет!");
				}
			}
		}

		//no quotes!!!	
		$phone_cel = ($pm->getParamValue('phone_cel'))? $this->getExtVal($pm,'phone_cel'):$ar['phone_cel'];
		$resend_sms = (
			isset($phone_cel)&&strlen($phone_cel)
			&& $ar['shipped']=='f'
			&&
			( ( !is_null($pm->getParamValue('quant')) && $this->getExtVal($pm,'quant')!=$ar['quant'])
			||($this->getExtVal($pm,'phone_cel') && $this->getExtVal($pm,'phone_cel')!=$ar['phone_cel'])
			||($this->getExtVal($pm,'concrete_type_id') && $this->getExtVal($pm,'concrete_type_id')!=$ar['concrete_type_id'])
			||($this->getExtVal($pm,'destination_id') && $this->getExtVal($pm,'destination_id')!=$ar['destination_id'])
			||($this->getExtVal($pm,'lang_id') && $this->getExtVal($pm,'lang_id')!=$ar['lang_id'])
			||($new_date_time && $new_date_time!=$old_date_time)
			||($new_pump_vehicle_id && $new_pump_vehicle_id!=$ar['pump_vehicle_id'])
			)
		);
		//
		parent::update($pm);
		
		if ($resend_sms){
			//changed phone or date_time
			$destination_id = ($pm->getParamValue('destination_id'))? $this->getExtDbVal($pm,'destination_id'):$ar['destination_id'];
			
			//no quotes!!!
			
			$lang_id = ($pm->getParamValue('lang_id'))? $this->getExtDbVal($pm,'lang_id'):$ar['lang_id'];			
			
			$concrete_type_id = ($pm->getParamValue('concrete_type_id'))? $this->getExtDbVal($pm,'concrete_type_id'):$ar['concrete_type_id'];
			
			$pump_vehicle_id = ($pm->getParamValue('pump_vehicle_id'))? $this->getExtDbVal($pm,'pump_vehicle_id'):$ar['pump_vehicle_id'];
			
			$quant = (is_null($pm->getParamValue('quant')))? floatval($ar['quant']):$this->getExtDbVal($pm,'quant');
			
			$total = 0;
			$pay_cash = $pm->getParamValue("pay_cash");
			if (
				(isset($pay_cash)&&$pay_cash=='true')
				||
				(!isset($pay_cash)&&$ar['pay_cash']=='t')
			){
				$total = $this->getExtDbVal($pm,'total');
				$total = (isset($total))? $total:$ar['total'];
			}
			
			$date_time = ($pm->getParamValue('date_time'))? $this->getExtVal($pm,"date_time"):$old_date_time;
			
			if(!is_null($pm->getParamValue('quant')) || floatval($ar['quant'])>0){
				//Если количества нет и было=0, то не отправлять!
				$this->send_messages(
					$order_id,
					$phone_cel,$quant,$total,$date_time,
					$concrete_type_id,$destination_id,
					$lang_id,$pump_vehicle_id,TRUE,
					$ar['orders_ref'], $ar['ext_contact_id']
				);
			}
			
			/** Тип СМС для насосника insert/update/delete
			 * update только если был насос и он же остался (т.е. сейчас передали путую строку)
			 * если quant=0 - delete
			 * если авто сменилось - insert
			 */			
			$sms_fn_type = NULL;
			$specialist_inform = FALSE;
			if( (!isset($ar['pump_vehicle_id'])||$ar['pump_vehicle_id']=='null') && isset($new_pump_vehicle_id) && $new_pump_vehicle_id!='null'){
				//НЕТ --> ЕСТЬ
				$sms_fn_type = 'sms_pump_order_ins';
				$ar_new_pv = $dbLink->query_first(sprintf(
					"SELECT specialist_inform FROM pump_vehicles WHERE id = %d"
					, $new_pump_vehicle_id
				));
				if(is_array($ar_new_pv) && count($ar_new_pv)  && isset($ar_new_pv['specialist_inform'])){
					$specialist_inform = ($ar_new_pv['specialist_inform'] == 't');
				}
			
			}else if(isset($ar['pump_vehicle_id']) && $ar['pump_vehicle_id']!=''
			&& isset($new_pump_vehicle_id) && $new_pump_vehicle_id!='null' && $new_pump_vehicle_id!=$ar['pump_vehicle_id']){
				//ЕСТЬ --> ЕСТЬ другой
				$sms_fn_type = 'sms_pump_order_ins';
				$ar_new_pv = $dbLink->query_first(sprintf(
					"SELECT specialist_inform FROM pump_vehicles WHERE id = %d"
					, $new_pump_vehicle_id
				));
				if(is_array($ar_new_pv) && count($ar_new_pv)  && isset($ar_new_pv['specialist_inform'])){
					$specialist_inform = ($ar_new_pv['specialist_inform'] == 't');
				}
				
			
			}else if(isset($ar['pump_vehicle_id']) && $ar['pump_vehicle_id']!=''
				&& !isset($new_pump_vehicle_id)
				&& (!is_null($pm->getParamValue('quant')) || floatval($ar['quant'])>0)
			){
				//Был и остался, поменялись другие параметры
				//Если количества нет и было=0, то не отправлять!
				$sms_fn_type = ($quant==0)? 'sms_pump_order_del':'sms_pump_order_upd';				
				$specialist_inform = ($ar['specialist_inform'] == 't');
			}
			
			if (!is_null($sms_fn_type)){
				try{
					$this->send_pumpSMS($sms_fn_type, $order_id, $ar['orders_ref'], $specialist_inform);
				}catch(Exception $e){
					error_log($e->getMessage());
				}
			}		
			
		}
	}
	
	private function pumpActionRespTels($action){
		return $this->getDbLink()->query(sprintf(
			"SELECT
				u_tels.user_tel AS phone_cel,
				u_tels.contact_id AS ext_contact_id
			FROM sms_pattern_user_phones_list AS u_tels
			WHERE u_tels.sms_pattern_id = (SELECT pt.id FROM sms_patterns AS pt WHERE pt.sms_type='%s')",
			$action
		));		
	}
	
	public function delete($pm){
		$order_id = $this->getExtDbVal($pm,'id');

		/* SMS насоснику */
		$ar_doc = $this->getDbLink()->query_first(sprintf(
			"SELECT
				o.pump_vehicle_id
				,orders_ref(o) AS orders_ref
				,o.lang_id
				,o.destination_id
				,o.concrete_type_id
				,o.date_time
				,o.quant
				,o.phone_cel
				,o.pay_cash
				,o.total
				,coalesce(o.contact_id, ct.id) AS contact_id
				,coalesce(pv.specialist_inform, FALSE) AS specialist_inform
				
			FROM orders AS o
			LEFT JOIN contacts AS ct ON ct.tel = o.phone_cel
			LEFT JOIN pump_vehicles AS pv ON pv.id = o.pump_vehicle_id
			WHERE o.id = %d"
			,$order_id
			)
		);
		if (!is_array($ar_doc) || !count($ar_doc) ){
			throw new Exception('Document not found!');
		}
		
		if(floatval($ar_doc['quant']) > 0 && isset($ar_doc['pump_vehicle_id'])){
			try{
				$this->send_pumpSMS('sms_pump_order_del', $order_id, $ar_doc['orders_ref'], ($ar_doc['specialist_inform']=='t'));
			}catch(Exception $e){
				error_log($e->getMessage());
			}			
		}		
		
		/* СМС клиенту о снятии */
		if(floatval($ar_doc['quant']) > 0 && isset($ar_doc['phone_cel']) && strlen($ar_doc['phone_cel'])){
			$this->send_messages(
				$order_id,
				$ar_doc['phone_cel'],
				0,
				($ar_doc['pay_cash']=='t')? $ar_doc['total']:0,			
				strtotime($ar_doc['date_time']),
				$ar_doc['concrete_type_id'],
				$ar_doc['destination_id'],
				$ar_doc['lang_id'],
				NULL,
				FALSE,
				$ar_doc['orders_ref'],
				$ar_doc['contact_id']
			);
		}
					
		//from 04/06/2024 copy deleted orders to a different table, set user who did it and time.
		$fields = 'client_id,
			destination_id,
			concrete_type_id,
			unload_type,
			comment_text,
			descr,
			date_time,
			time_to,
			quant,
			phone_cel,
			unload_speed,
			user_id,
			client_mark,
			"number",
			date_time_to,
			lang_id,
			total,
			concrete_price,
			destination_price,
			unload_price,
			pump_vehicle_id,
			pay_cash,
			total_edit,
			payed,
			under_control,
			create_date_time,
			ext_production,
			contact_id,
			client_specification_id,
			f_val,
			w_val
		';

		$link = $this->getDbLinkMaster();
		$link->query("BEGIN");
		try{
			$link->query(sprintf(
				"INSERT INTO order_garbage
					(%s,
					last_modif_user_id, last_modif_date_time
					)
				SELECT 
					%s,
					%d,
					now()
				FROM orders 
				WHERE orders.id = %d"
				,$fields, $fields
				,$_SESSION["user_id"]
				,$order_id
			));

			parent::delete($pm);

			$link->query("COMMIT");
		}catch(Exception $e){
			$link->query("ROLLBACK");
			throw $e;
		}

		//+event OrderGarbage.insert
		$event_par = [];
		$ar = $link->query_first("SELECT pg_current_wal_lsn() AS lsn");
		if(is_array($ar) && count($ar) && isset($ar['lsn'])){
		     $event_par["lsn"] = $ar["lsn"];
		}
		EventSrv::publishAsync('OrderGarbage.insert',$event_par);

		Graph_Controller::clearCacheOnOrderId($this->getDbLink(),$pm->getParamValue('id'));
	}
	
	public function get_make_orders_list($pm){
		$model = new OrderMakeList_Model($this->getDbLink());
		$this->modelGetList($model,$pm);		
	}

	public function get_make_orders_form($pm){
	
		$dt = (!$pm->getParamValue('date'))? time() : ($this->getExtVal($pm,'date')+Beton::shiftStartTime());
		$date_from = Beton::shiftStart($dt);
		$date_to = Beton::shiftEnd($date_from);
		
		//06/10/21 check restrictions
		if(!Beton::viewRestricted($date_from, $date_to)){
			throw new Exception(self::ER_PERIOD_NOT_ALLOWED);
		}
		
		$db_link = $this->getDbLink();
		self::add_production_bases($db_link);
		
		//list
		$this->addNewModel(sprintf(
			"SELECT * FROM orders_make_list WHERE date_time BETWEEN '%s' AND '%s'",
			date('Y-m-d H:i:s',$date_from),
			date('Y-m-d H:i:s',$date_to)
		),'OrderMakeList_Model'
		);

		//silos list
		$this->addSilosModels();

		//Bases
		$this->addProductionBaseModel();

		//material stores list
		$this->addMaterialStoreModels();
		
		//chart
		$db_link_master = $this->getDbLinkMaster();
		$date_for_db = "'".date('Y-m-d',$date_from)."'";
		$this->addModel(Graph_Controller::getPlantLoadModel($db_link,$db_link_master,$date_from,$date_to));
		
		//mat_totals
		$this->addMatTotalsModels($db_link, $date_for_db);

		//Assigning
		$this->addAssigningModels($db_link);				
		
		//Vehicles		
		$this->addModel(VehicleSchedule_Controller::getMakeListModel($db_link,$date_for_db));
		
		//features
		$this->addModel(VehicleSchedule_Controller::getFeatureListModel($db_link,$date_for_db));
		
		//weather
		//$this->addModel(Weather_Controller::getCurrentModel($db_link,$this->getDbLinkMaster()));
		
		//init date
		$this->addModel(new ModelVars(
			array('id'=>'InitDate',
				'values'=>array(
					new Field('dt',DT_DATETIME,
						array('value'=>date('Y-m-d H:i:s',$date_from)))
				)
			)
		));		
	}

	/**
	 * Заявки,отгрузки,график
	 */
	public function get_make_orders_form_ord($pm){	
		$dt = (!$pm->getParamValue('date'))? time() : ($this->getExtVal($pm,'date')+Beton::shiftStartTime());
		$date_from = Beton::shiftStart($dt);
		$date_to = Beton::shiftEnd($date_from);
		
		//06/10/21 check restrictions
		if(!Beton::viewRestricted($date_from, $date_to)){
			throw new Exception(self::ER_PERIOD_NOT_ALLOWED);
		}
		
		$db_link = $this->getDbLink();
		
		//list
		$this->addNewModel(sprintf(
			"SELECT * FROM orders_make_list WHERE date_time BETWEEN '%s' AND '%s'",
			date('Y-m-d H:i:s',$date_from),
			date('Y-m-d H:i:s',$date_to)
		),'OrderMakeList_Model'
		);

		//chart
		$db_link_master = $this->getDbLinkMaster();
		$date_for_db = "'".date('Y-m-d',$date_from)."'";
		$this->addModel(Graph_Controller::getPlantLoadModel($db_link,$db_link_master,$date_from,$date_to));		
	}

	/**
	 * статусы автомобилей
	 */
	public function get_make_orders_form_veh($pm){	
		$dt = (!$pm->getParamValue('date'))? time() : ($this->getExtVal($pm,'date')+Beton::shiftStartTime());
		$date_from = Beton::shiftStart($dt);
		$date_to = Beton::shiftEnd($date_from);
		
		$db_link = $this->getDbLink();
		$date_for_db = "'".date('Y-m-d',$date_from)."'";
		
		//Assigning		
		$this->addAssigningModels($db_link);
		
		//Vehicles		
		$this->addModel(VehicleSchedule_Controller::getMakeListModel($db_link,$date_for_db));
		
		//features
		$this->addModel(VehicleSchedule_Controller::getFeatureListModel($db_link,$date_for_db));
	}

	//Добавляет модели по остаткам материалов, отдельно по базам
	public function addMatTotalsModels($dbLink, $dateForDb){
		//mat_totals по производствам
		if(isset($_SESSION['production_bases']) && count($_SESSION['production_bases'])){
			foreach($_SESSION['production_bases'] as $prod_id){
				$this->addModel(RawMaterial_Controller::getTotalsModel($dbLink, $dateForDb, $prod_id));
			}
		}
		//Утяшево
		//$this->addModel(RawMaterial_Controller::getTotalsModel($dbLink, $dateForDb, 1));
		//Ветеранов
		//$this->addModel(RawMaterial_Controller::getTotalsModel($dbLink, $dateForDb, 2));	
		//Республики
		//$this->addModel(RawMaterial_Controller::getTotalsModel($dbLink, $dateForDb, 3));	
		
	}
	
	//Добавляет модели по силосам, отдельно по базам
	public function addSilosModels(){
		/*
		$this->addNewModel(
			"SELECT * FROM cement_silos_for_order_list
			WHERE production_base_id = 1",
			'CementSiloForOrderList1_Model'
		);
		$this->addNewModel(
			"SELECT * FROM cement_silos_for_order_list
			WHERE production_base_id = 2",
			'CementSiloForOrderList2_Model'
		);		
		$this->addNewModel(
			"SELECT * FROM cement_silos_for_order_list
			WHERE production_base_id = 3",
			'CementSiloForOrderList3_Model'
		);		
		*/
		if(isset($_SESSION['production_bases']) && count($_SESSION['production_bases'])){
			foreach($_SESSION['production_bases'] as $prod_id){
				$this->addNewModel(
					"SELECT * FROM cement_silos_for_order_list
					WHERE production_base_id = ".$prod_id,
					'CementSiloForOrderList'.$prod_id.'_Model'
				);					
			}
		}
		
	}

	//Добавляет модели по назначениям, отдельно по базам
	public function addAssigningModels($dbLink){
		$this->addModel(Shipment_Controller::getAssigningModel($dbLink, NULL, NULL));
	}

	public static function add_production_bases($dbLink){
		if(!isset($_SESSION['production_bases']) || !count($_SESSION['production_bases'])){
			$_SESSION['production_bases'] = [];
			$ar = $dbLink->query("SELECT id FROM production_bases");
			while($prod = $dbLink->fetch_array($ar)){
				array_push($_SESSION['production_bases'], $prod['id']);
			}
		}	
	}

	public function addProductionBaseModel(){
		$this->addNewModel(
			"SELECT * FROM production_bases",
			'ProductionBase_Model'
		);	
	}

	//Добавляет модели по добавкам, отдельно по базам
	public function addMaterialStoreModels(){
		/*
		$this->addNewModel(
			"SELECT * FROM material_store_for_order_list
			WHERE production_base_id = 1
			ORDER BY id",
			'MaterialStoreForOrderList1_Model'
		);
		$this->addNewModel(
			"SELECT * FROM material_store_for_order_list
			WHERE production_base_id = 2
			ORDER BY id",
			'MaterialStoreForOrderList2_Model'
		);
		$this->addNewModel(
			"SELECT * FROM material_store_for_order_list
			WHERE production_base_id = 3
			ORDER BY id",
			'MaterialStoreForOrderList3_Model'
		);
		*/
		if(isset($_SESSION['production_bases']) && count($_SESSION['production_bases'])){
			foreach($_SESSION['production_bases'] as $prod_id){
				$this->addNewModel(
					"SELECT * FROM material_store_for_order_list
					WHERE production_base_id = ".$prod_id."
					ORDER BY id",
					'MaterialStoreForOrderList'.$prod_id.'_Model'
				);
			}
		}
	}


	/**
	 * материалы цемент
	 */
	public function get_make_orders_form_mat($pm){
	
		$dt = (!$pm->getParamValue('date'))? time() : ($this->getExtVal($pm,'date')+Beton::shiftStartTime());
		$date_from = Beton::shiftStart($dt);
		$date_to = Beton::shiftEnd($date_from);
		
		$db_link = $this->getDbLink();
		self::add_production_bases($db_link);
		$date_for_db = "'".date('Y-m-d',$date_from)."'";
		
		//Bases
		$this->addProductionBaseModel();
		
		//silos list
		$this->addSilosModels();
		
		//material stores list
		$this->addMaterialStoreModels();
		
		//mat_totals
		$this->addMatTotalsModels($db_link, $date_for_db);
	}

	public function get_make_orders_for_weighing_form($pm){
		$dt = (!$pm->getParamValue('date'))? time() : ($this->getExtVal($pm,'date')+Beton::shiftStartTime());
		$date_from = Beton::shiftStart($dt);
		$date_to = Beton::shiftEnd($date_from);
	
		$db_link = $this->getDbLink();
		self::add_production_bases($db_link);
		$date_for_db = "'".date('Y-m-d',$date_from)."'";
	
		//silos list
		$this->addSilosModels();
	
		//order list
		$this->addNewModel(sprintf(
			"SELECT * FROM orders_make_list WHERE date_time BETWEEN '%s' AND '%s'",
			date('Y-m-d H:i:s',$date_from),
			date('Y-m-d H:i:s',$date_to)
		),'OrderMakeList_Model'
		);
	
		//Bases
		$this->addProductionBaseModel();
	
		//tickets
		$this->addModel(RawMaterialTicket_Controller::getCarrierAggModel($db_link));
		
		//material stores list
		$this->addMaterialStoreModels();
	
		//mat_totals
		$this->addMatTotalsModels($db_link, $date_for_db);
		
		//weather
		//$this->addModel(Weather_Controller::getCurrentModel($db_link,$this->getDbLinkMaster()));
		
		//init date
		$this->addModel(new ModelVars(
			array('id'=>'InitDate',
				'values'=>array(
					new Field('dt',DT_DATETIME,
						array('value'=>date('Y-m-d H:i:s',$date_from)))
				)
			)
		));			
	}

	public function get_make_orders_for_lab_form($pm){
	
		$dt = (!$pm->getParamValue('date'))? time() : ($this->getExtVal($pm,'date')+Beton::shiftStartTime());
		$date_from = Beton::shiftStart($dt);
		$date_to = Beton::shiftEnd($date_from);
		
		//06/10/21 check restrictions
		if(!Beton::viewRestricted($date_from, $date_to)){
			throw new Exception(self::ER_PERIOD_NOT_ALLOWED);
		}
		
		$date_for_db = "'".date('Y-m-d',$date_from)."'";
		$date_to_for_db = "'".date('Y-m-d',$date_to)."'";
		
		$db_link = $this->getDbLink();
		self::add_production_bases($db_link);
		
		//list
		$this->addNewModel(sprintf(
			"SELECT * FROM orders_make_for_lab_period_list
			WHERE date_time BETWEEN '%s' AND '%s'",
			date('Y-m-d H:i:s',$date_from),
			date('Y-m-d H:i:s',$date_to)
		),'OrderMakeForLabList_Model'
		);
		
		//Lab list
		//Убрано 31/01/23
		//$this->addNewModel('SELECT * FROM lab_entry_30days_2','LabEntry30DaysList_Model');
		//+Журнал испытания образцов по тек. дате и фильтру (отобран/ не отобран) выводится свом запросом

		//Bases
		$this->addProductionBaseModel();

		//material stores list
		$this->addMaterialStoreModels();
		
		//silos list
		$this->addSilosModels();
		
		//Assigning		
		$this->addAssigningModels($db_link);
		
		//mat_totals
		$this->addMatTotalsModels($db_link, $date_for_db);
		
		//Vehicles		
		$this->addModel(VehicleSchedule_Controller::getMakeListModel($db_link,$date_for_db));

		//OperatorList	
		Shipment_Controller::addOperatorModels($this,$date_for_db,$date_to_for_db);	
		
		//weather
		//$this->addModel(Weather_Controller::getCurrentModel($db_link,$this->getDbLinkMaster()));
		
		//init date
		$this->addModel(new ModelVars(
			array('id'=>'InitDate',
				'values'=>array(
					new Field('dt',DT_DATETIME,
						array('value'=>date('Y-m-d H:i:s',$date_from)))
				)
			)
		));		
	}

	public function get_make_orders_for_lab_form_ord($pm){
	
		$dt = (!$pm->getParamValue('date'))? time() : ($this->getExtVal($pm,'date')+Beton::shiftStartTime());
		$date_from = Beton::shiftStart($dt);
		$date_to = Beton::shiftEnd($date_from);
		
		//06/10/21 check restrictions
		if(!Beton::viewRestricted($date_from, $date_to)){
			throw new Exception(self::ER_PERIOD_NOT_ALLOWED);
		}
		
		$date_for_db = "'".date('Y-m-d',$date_from)."'";
		$date_to_for_db = "'".date('Y-m-d',$date_to)."'";
		
		$db_link = $this->getDbLink();
		
		//list
		$this->addNewModel(sprintf(
			"SELECT * FROM orders_make_for_lab_period_list
			WHERE date_time BETWEEN '%s' AND '%s'",
			date('Y-m-d H:i:s',$date_from),
			date('Y-m-d H:i:s',$date_to)
		),'OrderMakeForLabList_Model'
		);
		
		//Lab list
		//$this->addNewModel('SELECT * FROM lab_entry_30days_2','LabEntry30DaysList_Model');
		//+Журнал испытания образцов по тек. дате и фильтру (отобран/ не отобран) выводится свом запросом

		//OperatorList	
		Shipment_Controller::addOperatorModels($this,$date_for_db,$date_to_for_db);	
	}
	
	public function get_make_orders_for_lab_form_mat($pm){
	
		$dt = (!$pm->getParamValue('date'))? time() : ($this->getExtVal($pm,'date')+Beton::shiftStartTime());
		$date_from = Beton::shiftStart($dt);
		$date_to = Beton::shiftEnd($date_from);
		$date_for_db = "'".date('Y-m-d',$date_from)."'";
		$date_to_for_db = "'".date('Y-m-d',$date_to)."'";
		
		$db_link = $this->getDbLink();
		self::add_production_bases($db_link);
		
		//Bases
		$this->addProductionBaseModel();
		
		//material stores list
		$this->addMaterialStoreModels();
		
		//silos list
		$this->addSilosModels();
		
		//mat_totals
		$this->addMatTotalsModels($db_link, $date_for_db);
	}
	
	public function get_make_orders_for_lab_form_veh($pm){	
		$dt = (!$pm->getParamValue('date'))? time() : ($this->getExtVal($pm,'date')+Beton::shiftStartTime());
		$date_from = Beton::shiftStart($dt);
		$date_to = Beton::shiftEnd($date_from);
		$date_for_db = "'".date('Y-m-d',$date_from)."'";
		$date_to_for_db = "'".date('Y-m-d',$date_to)."'";
		
		$db_link = $this->getDbLink();
		
		//Assigning	
		$this->addAssigningModels($db_link);	
		
		//Vehicles		
		$this->addModel(VehicleSchedule_Controller::getMakeListModel($db_link,$date_for_db));

	}

	
	public function get_make_orders_for_lab_list($pm){
		$this->addNewModel("SELECT * FROM lab_orders_list",'get_make_orders_for_lab_list');
	}
	
	public function get_avail_spots($pm){		
		$model = new ModelSQL($this->getDbLinkMaster(),array('id'=>'OrderAvailSpots_Model'));
		$model->setSelectQueryText(sprintf(
			"SELECT * FROM available_spots_for_order_dif_speed(%s,%f,%f)",
			$this->getExtDbVal($pm,'date'),
			$this->getExtDbVal($pm,'quant'),
			$this->getExtDbVal($pm,'speed')
		));
		
		$model->select(false,null,null,
			null,null,null,null,null,TRUE);
		//
		$this->addModel($model);				
		
	}
	public function complete_descr($pm){
		$this->addNewModel(sprintf(
			"SELECT * FROM orders_complete_contact(%d, %s)",
			$this->getExtDbVal($pm,'client_id'),
			$this->getExtDbVal($pm,'descr')
		),
		'OrderDescr_Model');		
	}
	
	public function get_comment($pm){
		$ar=$this->getDbLink()->query_first(sprintf(
		"SELECT
			comment_text
		FROM orders WHERE id=%d",
		$this->getExtDbVal($pm,'order_id')
		));
		
		if ($ar && count($ar)==1){
			throw new Exception($ar['comment_text']);
		}
		else{
			throw new Exception('Документ не найден');
		}
	}
	
	public function fields_from_client_order($pm){
		$this->addNewModel(sprintf(
		"SELECT
			ct.id AS concrete_type_id,
			ct.name AS concrete_type_descr,
			o.quant,
			format_cel_phone(o.tel::text) AS tel,
			o.name AS client_descr,
			cl.id AS client_id,
			o.total,
			o.dest AS dest_descr,
			CASE
				WHEN o.pump THEN 'pump'::unload_types
				ELSE 'none'::unload_types
			END AS pump,			
			o.comment_text
			
		FROM orders_from_clients AS o
		LEFT JOIN concrete_types AS ct ON ct.name=o.concrete_type
		LEFT JOIN clients AS cl ON cl.name=o.name
		WHERE o.id=%d",
		$this->getExtDbVal($pm,'client_order_id')
		)
		,"fields_from_client_order");
	}
	
	public function set_payed($pm){
		$this->getDbLinkMaster()->query(sprintf(
			"UPDATE orders
			SET payed=TRUE
			WHERE id=%d",
			$this->getExtDbVal($pm,'id')
		));	
	}	
	
	public function get_list_for_client($pm){	
		$this->modelGetList(new OrderForClientList_Model($this->getDbLink()),$pm);
	}

	public function get_list($pm){	
		checkPublicMethodPeriod($pm, new OrderMakeList_Model($this->getDbLink()), "date_time", 370);
		parent::get_list($pm);
	}

	//localhost/beton_new/?c=Order_Controller&f=calc_for_site&v=ViewXML&concrete_type_id=1&quant=1&address=Тюмень сакко 5
	public function calc_for_site($pm){
		$dest = new Destination_Controller($this->getDbLinkMaster());
		$data = NULL;
		$dest->get_data_for_address($this->getExtVal($pm,'address'), $data);
		//throw new Exception($data['route']);
		
		$ar = $this->getDbLink()->query_first(sprintf(
			"SELECT
				coalesce(act_price.price,0) AS price
				,(SELECT const_min_quant_for_ship_cost_val()) AS quant_min
			FROM concrete_types AS ctp
			LEFT JOIN concrete_costs AS act_price ON act_price.concrete_type_id=ctp.id
				AND act_price.concrete_costs_h_id= (SELECT t.id
					FROM concrete_costs_h AS t
					WHERE
						(t.clients_list IS NULL OR (jsonb_array_length(clients_list->'rows')=0) )
						AND t.date <= now()::date
					ORDER BY t.date DESC
					LIMIT 1
				)				
			WHERE ctp.id=%d"
			,$this->getExtDbVal($pm,'concrete_type_id')
		));
		
		if(!is_array($ar) || !isset($ar['price'])){
			throw new Exception('Concrete type not found!');
		}
		
		$quant = $this->getExtVal($pm,'quant');
		
		$quant_min = floatval($ar['quant_min']);
		$distance_km = floor($data['distance']/1000);	
		$quant_for_deliv = $quant;
		if($quant < $quant_min){
			//depends on distance
			$ar_gr = $this->getDbLink()->query_first(sprintf(
				"SELECT
					quant_to
				FROM ship_quant_for_cost_grades
				WHERE distance_from <= %f AND distance_to >= %f
				AND quant <=%f AND quant_to>=%f"
				,$distance_km
				,$distance_km
				,$quant
				,$quant
			));
			
			if(!is_array($ar_gr) || !isset($ar_gr['quant_to'])){
				throw new Exception('Price grade table error!');
			}
			
			$quant_for_deliv = $ar_gr['quant_to'];
			
		}
		$ar_pr = $this->getDbLink()->query_first(sprintf(
			"WITH
			price_h AS (
				SELECT date
				FROM shipment_for_owner_costs_h
				WHERE date <= now()::date
				ORDER BY date DESC
				LIMIT 1
			)
			SELECT
				price.price
			FROM shipment_for_owner_costs AS price
			WHERE price.date = (SELECT price_h.date FROM price_h) AND price.distance_to>=%d
			ORDER BY price.distance_to ASC
			LIMIT 1"
			,$distance_km
		));
		if(!is_array($ar_pr) || !isset($ar_pr['price'])){
			throw new Exception('Price table error!');
		}
		
		$concrete_cost = floatval($ar['price']) * $quant;
		$delivery_cost = floatval($ar_pr['price']) * $quant_for_deliv;
		
		$this->addModel(new ModelVars(
			array('id'=>'CalcForSite_Model',
				'values'=>array(
					new Field('concrete_cost',DT_FLOAT,
						array('value'=>$concrete_cost))

					,new Field('delivery_cost',DT_FLOAT,
						array('value'=>$delivery_cost))

					,new Field('total_cost',DT_FLOAT,
						array('value'=>($delivery_cost+$concrete_cost)))
						
					,new Field('distance',DT_FLOAT,
						array('value'=>$data['distance']))
					
					,new Field('route',DT_STRING,
						array('value'=>$data['route']))
					)
					
				)
			)
		);
	}
	
	public function get_object_for_lab($pm){
		$this->addNewModel(sprintf(
			"SELECT
				orders.id,
				orders.comment_text,
				concrete_types_ref(ct) AS concrete_types_ref
		FROM orders
			LEFT JOIN concrete_types AS ct ON ct.id = orders.concrete_type_id
			WHERE orders.id = %d",
			$this->getExtDbVal($pm, 'id')
		),'OrderMakeForLabDialog_Model'		
		);
	}
	
	
}
?>