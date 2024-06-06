/** Copyright (c) 2024
 *	Andrey Mikhalevich, Katren ltd.
 */
function OrderGarbageDialog_View(id,options){	
	
	options = options || {};
	options.readOnly = true;
	options.model =  ((options.models && options.models.OrderGarbageDialog_Model)? options.models.OrderGarbageDialog_Model: new OrderGarbageDialog_Model());
	options.controller = new OrderGarbage_Controller();
	// options.template = window.getApp().getTemplate("OrderDialog_View");

	OrderGarbageDialog_View.superclass.constructor.call(this,id,options);
}
extend(OrderGarbageDialog_View, OrderDialog_View);
