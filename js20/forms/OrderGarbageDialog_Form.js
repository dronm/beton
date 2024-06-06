
/** Copyright (c) 2024
 *	Andrey Mikhalevich, Katren ltd.
 */
function OrderGarbageDialog_Form(options){
	options = options || {};	
	
	options.formName = "OrderGarbageDialog";
	options.controller = "OrderGarbage_Controller";
	options.method = "get_object";
	// options.template = "OrderDialog";
	
	OrderGarbageDialog_Form.superclass.constructor.call(this,options);
	
}
extend(OrderGarbageDialog_Form, WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */

