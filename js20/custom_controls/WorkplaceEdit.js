/* Copyright (c) 2026
 *	Andrey Mikhalevich, Katren ltd.
 */
function WorkplaceEdit(id,options){
	options = options || {};	
	if (options.labelCaption!=""){
		options.labelCaption = options.labelCaption || "Рабочее место:";
	}
	options.cmdInsert = (options.cmdInsert!=undefined)? options.cmdInsert:false;
	
	options.keyIds = options.keyIds || ["id"];
	
	//форма выбора из списка
	options.selectWinClass = WorkplaceList_Form;
	options.selectDescrIds = ["name"];
	
	//форма редактирования элемента
	options.editWinClass = null;
	
	options.acMinLengthForQuery = 1;
	options.acController = new Workplace_Controller();
	options.acModel = new WorkplaceList_Model();
	options.acPatternFieldId = options.acPatternFieldId || "name";
	options.acKeyFields = options.acKeyFields || [options.acModel.getField("id")];
	options.acDescrFields = options.acDescrFields || [options.acModel.getField("name")];
	options.acICase = options.acICase || "1";
	options.acMid = options.acMid || "1";
	
	WorkplaceEdit.superclass.constructor.call(this,id,options);
}
extend(WorkplaceEdit,EditRef);

/* Constants */


/* private members */

/* protected*/


/* public methods */


