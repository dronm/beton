/** Copyright (c) 2026
 *	Andrey Mikhalevich, Katren ltd.
 */
function WorkplaceDialog_Form(options){
	options = options || {};	
	
	options.formName = "WorkplaceDialog";
	options.controller = "Workplace_Controller";
	options.method = "get_object";
	
	WorkplaceDialog_Form.superclass.constructor.call(this,options);
	
}
extend(WorkplaceDialog_Form,WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */


