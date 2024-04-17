/** Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function DriverEdit(id,options){

	options = options || {};	
	if (options.labelCaption!=""){
		options.labelCaption = options.labelCaption || "Водитель:";
	}
	options.cmdInsert = (options.cmdInsert!=undefined)? options.cmdInsert:false;
	
	options.keyIds = options.keyIds || ["id"];
	
	//форма выбора из списка
	options.selectWinClass = DriverList_Form;
	options.selectDescrIds = options.selectDescrIds || ["name"];
	
	//форма редактирования элемента
	options.editWinClass = Driver_Form;
	
	options.acMinLengthForQuery = 1;
	options.acController = new Driver_Controller();
	options.acModel = options.acModel || (new DriverList_Model());
	options.acPublicMethod = options.acController.getPublicMethod((options.acPublicMethodId||"complete"))
	options.acPatternFieldId = options.acPatternFieldId || "name";
	options.acKeyFields = options.acKeyFields || [options.acModel.getField("id")];
	options.acDescrFields = options.acDescrFields || [options.acModel.getField("name")];
	options.acICase = options.acICase || "1";
	options.acMid = options.acMid || "1";
	
	DriverEdit.superclass.constructor.call(this,id,options);
}
extend(DriverEdit,EditRef);

/* Constants */


/* private members */

/* protected*/


/* public methods */

