/** Copyright (c) 2023
 *	Andrey Mikhalevich, Katren ltd.
 */
function Client1cEdit(id,options){

	options = options || {};	
	if (options.labelCaption!=""){
		options.labelCaption = options.labelCaption || "Контрагент 1с:";
	}
	if (options.title!=""){
		options.title = options.title || "Ссылка на контрагента 1с";
	}
	if (options.placeholder!=""){
		options.placeholder = options.placeholder || "ИНН/наименование контрагента";
	}
	
	options.cmdInsert = false;
	
	options.keyIds = options.keyIds || ["ref_1c"];
	
	//форма выбора из списка
	options.selectWinClass = null;
	options.selectDescrIds = null;
	
	//форма редактирования элемента
	options.editWinClass = null;
	
	options.acMinLengthForQuery = (options.acMinLengthForQuery!=undefined)? options.acMinLengthForQuery:1;
	options.acController = new Client1c_Controller();
	options.acPublicMethod = options.acController.getPublicMethod("complete");
	options.acModel = new ModelJSON("Client1cList_Model", {
		"fields":["name", "inn", "ref"]
	});
	options.acPatternFieldId = options.acPatternFieldId || "search";
	options.acKeyFields = options.acKeyFields || [options.acModel.getField("ref")];
	options.acDescrFields = options.acDescrFields || [options.acModel.getField("name"), options.acModel.getField("inn")];
	options.acICase = options.acICase || "1";
	options.acMid = options.acMid || "1";
	
	Client1cEdit.superclass.constructor.call(this,id,options);
}
extend(Client1cEdit,EditRef);

/* Constants */


/* private members */

/* protected*/


/* public methods */

