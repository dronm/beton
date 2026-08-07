/* Copyright (c) 2026
 *	Andrey Mikhalevich, Katren ltd.
 */
function WorkplaceList_Form(options){
	options = options || {};	
	
	options.formName = "WorkplaceList";
	options.controller = "Workplace_Controller";
	options.method = "get_list";
	
	WorkplaceList_Form.superclass.constructor.call(this,options);
		
}
extend(WorkplaceList_Form,WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */


