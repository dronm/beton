/** Copyright (c) 2023
 *	Andrey Mikhalevich, Katren ltd.
 */
function VehicleTotRepItem_Form(options){
	options = options || {};	
	
	options.formName = "VehicleTotRepItemDialog";
	options.controller = "VehicleTotRepItem_Controller";
	options.method = "get_object";
	
	VehicleTotRepItem_Form.superclass.constructor.call(this,options);
	
}
extend(VehicleTotRepItem_Form,WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */

