/** Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 *
 * @param {bool} options.tm_exists
 */
function ClientTelEdit(id,options){

	options = options || {};	
	if (options.labelCaption!=""){
		options.labelCaption = options.labelCaption || "Контакт:";
	}
	options.cmdInsert = (options.cmdInsert!=undefined)? options.cmdInsert:false;
	
	options.keyIds = options.keyIds || ["id"];
	
	//форма выбора из списка
	options.selectWinClass = ClientTelList_Form;
	options.selectDescrIds = options.selectDescrIds || ["name"];
	
	//форма редактирования элемента
	options.editWinClass = null;
	
	options.acMinLengthForQuery = 1;
	options.acController = new ClientTel_Controller();
	options.acModel = options.acModel || (new ClientTelList_Model());
	options.acPublicMethod = options.acController.getPublicMethod("complete_tel");
	if(options.tm_exists===true){
		options.acPublicMethod.setFieldValue("tm_exists", true);
		options.selectWinParams = "cond_fields=tm_exists&cond_sgns=e&cond_vals=1";
	}	
	options.acPatternFieldId = options.acPatternFieldId || "search";
	options.acKeyFields = options.acKeyFields || [options.acModel.getField("id")];
	options.acDescrFields = options.acDescrFields || [options.acModel.getField("search")];
	options.acICase = options.acICase || "1";
	options.acMid = options.acMid || "1";
	
	ClientTelEdit.superclass.constructor.call(this,id,options);
}
extend(ClientTelEdit,EditRef);

/* Constants */


/* private members */

/* protected*/


/* public methods */

