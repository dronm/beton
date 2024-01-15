/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022
 
 * @class
 * @classdesc
	
 * @param {string} id view identifier
 * @param {namespace} options
 */	
function ProductionBaseEdit(id,options){
	options = options || {};
	options.model = new ProductionBaseList_Model();
	
	if (options.labelCaption!=""){
		options.labelCaption = options.labelCaption || "База:";
	}
	
	options.keyIds = options.keyIds || ["id"];
	options.modelKeyFields = [options.model.getField("id")];
	options.modelDescrFields = [options.model.getField("name")];
	
	var contr = new ProductionBase_Controller();
	options.readPublicMethod = contr.getPublicMethod("get_list");
	
	ProductionBaseEdit.superclass.constructor.call(this,id,options);
	
}
extend(ProductionBaseEdit,EditSelectRef);

