/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2024
 
 * @class
 * @classdesc
	
 * @param {string} id view identifier
 * @param {namespace} options
 */	
function ChatStatusEdit(id,options){
	options = options || {};
	options.model = new ChatStatus_Model();
	
	if (options.labelCaption!=""){
		options.labelCaption = options.labelCaption || "Статус:";
	}
	
	options.keyIds = options.keyIds || ["id"];
	options.modelKeyFields = [options.model.getField("id")];
	options.modelDescrFields = [options.model.getField("name")];
	
	var contr = new ChatStatus_Controller();
	options.readPublicMethod = contr.getPublicMethod("get_list");
	
	ChatStatusEdit.superclass.constructor.call(this,id,options);
	
}
extend(ChatStatusEdit, EditSelectRef);

