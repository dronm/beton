/** Copyright (c) 2026
 *	Andrey Mikhalevich, Katren ltd.
 */
function Warehouse1cEdit(id,options){

	options = options || {};	
	if (options.labelCaption!=""){
		options.labelCaption = options.labelCaption || "Склад 1с:";
	}
	if (options.title!=""){
		options.title = options.title || "Ссылка на склад 1с";
	}
	if (options.placeholder!=""){
		options.placeholder = options.placeholder || "склад в 1с";
	}
	
	options.cmdInsert = false;
	
	options.keyIds = options.keyIds || ["ref_1c"];
	
	//форма выбора из списка
	options.selectWinClass = null;
	options.selectDescrIds = null;
	
	//форма редактирования элемента
	options.editWinClass = null;
	
	options.acMinLengthForQuery = (options.acMinLengthForQuery!=undefined)? options.acMinLengthForQuery:1;
	options.acController = new Connect1c_Controller();
	options.acPublicMethod = options.acController.getPublicMethod("complete_warehouse");
	options.acModel = new ModelXML("Warehouse1cList_Model", {
		"fields":["name", "ref"]
	});
	options.acPatternFieldId = options.acPatternFieldId || "search";
	options.acKeyFields = options.acKeyFields || [options.acModel.getField("ref")];
	options.acDescrFields = options.acDescrFields || [options.acModel.getField("name")];
	options.acICase = options.acICase || "1";
	options.acMid = options.acMid || "1";
	
	Warehouse1cEdit.superclass.constructor.call(this,id,options);
}
extend(Warehouse1cEdit,EditRef);

/* Constants */


/* private members */

/* protected*/


/* public methods */



