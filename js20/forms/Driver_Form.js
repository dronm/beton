/** Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function Driver_Form(options){
	options = options || {};	
	
	options.formName = "DriverDialog";
	options.controller = "Driver_Controller";
	options.method = "get_object";
	
	Driver_Form.superclass.constructor.call(this,options);
	
}
extend(Driver_Form,WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */

