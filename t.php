<?php
require_once("Config.php");
require_once(ABSOLUTE_PATH."functions/db_con_f.php");
require_once(ABSOLUTE_PATH."functions/notifications.php");

$conn = db_con();
add_notification_from_contact($conn, '9222695251', 'Test message from Bereg', 'info', null, 73688);
?>
