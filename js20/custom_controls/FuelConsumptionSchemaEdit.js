/** Copyright (c) 2026
 *	Andrey Mikhalevich, Katren ltd.
 */
function FuelConsumptionSchemaEdit(id,options){

	options = options || {};	
	if (options.labelCaption!=""){
		options.labelCaption = options.labelCaption || "Схема расхода ГСМ:";
	}
	options.cmdInsert = (options.cmdInsert!=undefined)? options.cmdInsert:false;
	
	options.keyIds = options.keyIds || ["id"];
	
	//форма выбора из списка
	options.selectWinClass = FuelConsumptionSchemaList_Form;
	options.selectDescrIds = options.selectDescrIds || ["name"];
	
	//форма редактирования элемента
	options.editWinClass = null;
	
	options.acMinLengthForQuery = 1;
	options.acController = new FuelConsumptionSchema_Controller();
	options.acModel = options.acModel || (new FuelConsumptionSchema_Model());
	options.acPublicMethod = options.acController.getPublicMethod((options.acPublicMethodId||"complete"))
	options.acPatternFieldId = options.acPatternFieldId || "name";
	options.acKeyFields = options.acKeyFields || [options.acModel.getField("id")];
	options.acDescrFields = options.acDescrFields || [options.acModel.getField("name")];
	options.acICase = options.acICase || "1";
	options.acMid = options.acMid || "1";
	
	FuelConsumptionSchemaEdit.superclass.constructor.call(this,id,options);
}
extend(FuelConsumptionSchemaEdit,EditRef);

/* Constants */


/* private members */

/* protected*/


/* public methods */


