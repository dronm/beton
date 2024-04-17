/** Copyright (c) 2023
 *	Andrey Mikhalevich, Katren ltd.
 */
function ClientSpecificationList_Form(options){
	options = options || {};	
	
	options.formName = "ClientSpecificationList";
	options.controller = "ClientSpecification_Controller";
	options.method = "get_list";
	
	ClientSpecificationList_Form.superclass.constructor.call(this,options);
		
}
extend(ClientSpecificationList_Form,WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */

