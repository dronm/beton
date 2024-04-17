/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2023
 
 * @class
 * @classdesc
	
 * @param {string} id view identifier
 * @param {namespace} options
 */	
function TaskImportanceLevelEdit(id,options){
	options = options || {};
	options.model = new TaskImportanceLevel_Model();
	
	if (options.labelCaption!=""){
		options.labelCaption = options.labelCaption || "Уровень важности:";
	}
	
	options.keyIds = options.keyIds || ["id"];
	options.modelKeyFields = [options.model.getField("id")];
	options.modelDescrFields = [options.model.getField("name")];
	
	var contr = new TaskImportanceLevel_Controller();
	options.readPublicMethod = contr.getPublicMethod("get_list");
	
	TaskImportanceLevelEdit.superclass.constructor.call(this,id,options);
	
}
extend(TaskImportanceLevelEdit,EditSelectRef);

