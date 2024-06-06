
/** Copyright (c) 2024
 *	Andrey Mikhalevich, Katren ltd.
 */
function OrderGarbageList_View(id,options){	

	options.orderModel =  options.models.OrderGarbageList_Model;
	options.controller = new OrderGarbage_Controller();
	options.dialogForm = OrderGarbageDialog_Form;
	options.readOnly = true;

	OrderGarbageList_View.superclass.constructor.call(this,id,options);
}
extend(OrderGarbageList_View, OrderList_View);
