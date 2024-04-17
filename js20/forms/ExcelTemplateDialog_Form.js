/** Copyright (c) 2021
 *	Andrey Mikhalevich, Katren ltd.
 */
function ExcelTemplateDialog_Form(options){
	options = options || {};	
	
	options.formName = "ExcelTemplateDialog";
	options.controller = "ExcelTemplate_Controller";
	options.method = "get_object";
	
	ExcelTemplateDialog_Form.superclass.constructor.call(this,options);
	
}
extend(ExcelTemplateDialog_Form,WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */

