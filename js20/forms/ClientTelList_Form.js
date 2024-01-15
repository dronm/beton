/** Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function ClientTelList_Form(options){
	options = options || {};	
	
	options.formName = "ClientTelList";
	options.controller = "ClientTel_Controller";
	options.method = "get_list";
	
	ClientTelList_Form.superclass.constructor.call(this,options);
		
}
extend(ClientTelList_Form,WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */

