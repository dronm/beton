/** Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function DriverDialog_Form(options){
	options = options || {};	
	
	options.formName = "DriverDialog";
	options.controller = "Driver_Controller";
	options.method = "get_object";
	
	DriverDialog_Form.superclass.constructor.call(this,options);
	
}
extend(DriverDialog_Form,WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */

