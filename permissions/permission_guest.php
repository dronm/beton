<?php
/**
	DO NOT MODIFY THIS FILE!	
	Its content is generated automaticaly from template placed at build/permissions/permission_php.tmpl.	
 */
function method_allowed($contrId,$methId){
$permissions = array();

			$permissions['User_Controller_login']=TRUE;
		
			$permissions['User_Controller_login_html']=TRUE;
		
			$permissions['User_Controller_login_k']=TRUE;
		
			$permissions['User_Controller_login_ks']=TRUE;
		
			$permissions['User_Controller_login_tm']=TRUE;
		
			$permissions['User_Controller_tm_check_tel']=TRUE;
		
			$permissions['User_Controller_tm_send_code']=TRUE;
		
			$permissions['User_Controller_tm_get_left_time']=TRUE;
		
			$permissions['User_Controller_tm_check_code']=TRUE;
		
			$permissions['User_Controller_login_ext']=TRUE;
		
			$permissions['User_Controller_logged']=TRUE;
		
			$permissions['User_Controller_logout']=TRUE;
		
			$permissions['Captcha_Controller_get']=TRUE;
		
			$permissions['ConcreteType_Controller_get_for_site_list']=TRUE;
		
			$permissions['Destination_Controller_complete_for_site']=TRUE;
		
			$permissions['Vehicle_Controller_get_total_shipped']=TRUE;
		
			$permissions['Order_Controller_calc_for_site']=TRUE;
		
return array_key_exists($contrId.'_'.$methId,$permissions);
}
?>