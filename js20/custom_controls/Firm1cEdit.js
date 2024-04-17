/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2023
 
 * @class
 * @classdesc
	
 * @param {string} id view identifier
 * @param {namespace} options
 */	
function Firm1cEdit(id,options){
	options = options || {};
	options.model = new Firm1cList_Model();
	
	if (options.labelCaption!=""){
		options.labelCaption = options.labelCaption || "Организация:";
	}
	
	options.keyIds = options.keyIds || ["id"];
	options.modelKeyFields = [options.model.getField("id")];
	options.modelDescrFields = [options.model.getField("descr")];
	
	var contr = new Firm1c_Controller();
	options.readPublicMethod = contr.getPublicMethod("get_list");
	
	Firm1cEdit.superclass.constructor.call(this,id,options);
	
}
extend(Firm1cEdit,EditSelectRef);


