/** Copyright (c) 2026
 *	Andrey Mikhalevich, Katren ltd.
 */
function FuelConsumptionSchemaList_Form(options){
	options = options || {};	
	
	options.formName = "FuelConsumptionSchemaList";
	options.controller = "FuelConsumptionSchema_Controller";
	options.method = "get_list";
	
	FuelConsumptionSchemaList_Form.superclass.constructor.call(this,options);
		
}
extend(FuelConsumptionSchemaList_Form,WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */

