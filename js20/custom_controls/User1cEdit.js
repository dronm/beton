/** Copyright (c) 2023
 *	Andrey Mikhalevich, Katren ltd.
 */
function User1cEdit(id,options){

	options = options || {};	
	if (options.labelCaption!=""){
		options.labelCaption = options.labelCaption || "Пользователь 1с:";
	}
	if (options.title!=""){
		options.title = options.title || "Ссылка на пользователя 1с";
	}
	if (options.placeholder!=""){
		options.placeholder = options.placeholder || "фио пользователя в 1с";
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
	options.acPublicMethod = options.acController.getPublicMethod("complete_user");
	options.acModel = new ModelJSON("User1cList_Model", {
		"fields":["name", "ref"]
	});
	options.acPatternFieldId = options.acPatternFieldId || "search";
	options.acKeyFields = options.acKeyFields || [options.acModel.getField("ref")];
	options.acDescrFields = options.acDescrFields || [options.acModel.getField("name")];
	options.acICase = options.acICase || "1";
	options.acMid = options.acMid || "1";
	
	User1cEdit.superclass.constructor.call(this,id,options);
}
extend(User1cEdit,EditRef);

/* Constants */


/* private members */

/* protected*/


/* public methods */


