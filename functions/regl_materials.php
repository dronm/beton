<?php
require_once('db_con.php');
require_once('notification.php');

/*****  ФОРМИРОВАНИЕ ЗАКАЗОВ ПОСТАВЩИКАМ ******* */
$dbLink->query('SELECT sup_make_orders()');

/*****  ОТПРАВКА SMS С ЗАКАЗАМИ ПОСТАВЩИКАМ ******* */
$id = $dbLink->query("SELECT * FROM sup_orders_for_sms");
while ($ar=$dbLink->fetch_array($id)){
	//Новая система с отправкой СМС через задание
	/*
	$dbLink->query(sprintf(
		"INSERT INTO sms_for_sending
		(tel, body, sms_type)
		VALUES ('%s','%s','procur')",
		$ar['tel'],
		$ar['mes_text']
	));					
	*/
	
	add_notification($dbLink, $ar['tel'], $ar['mes_text'], 'procur', '{}', $ar['ext_obj'])
	
	if ($ar['tel2']){
		add_notification($dbLink, $ar['tel2'], $ar['mes_text'], 'procur', '{}', $ar['ext_obj'])
		/*
		$dbLink->query(sprintf(
			"INSERT INTO sms_for_sending
			(tel, body, sms_type)
			VALUES ('%s','%s','procur')",
			$ar['tel2'],
			$ar['mes_text']
		));					
		*/
	}
}

?>
