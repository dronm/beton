/** Copyright (c) 2019 
 *	Andrey Mikhalevich, Katren ltd.
 */
function Client_Form(options){
	options = options || {};	
	
	options.formName = "ClientDialog";
	options.controller = "Client_Controller";
	options.method = "get_object";
	
	Client_Form.superclass.constructor.call(this,options);
	
}
extend(Client_Form,WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */

