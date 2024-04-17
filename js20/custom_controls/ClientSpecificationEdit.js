/* Copyright (c) 2023
 *	Andrey Mikhalevich, Katren ltd.
 */
function ClientSpecificationEdit(id,options){
	options = options || {};	
	if (options.labelCaption!=""){
		options.labelCaption = options.labelCaption || "Спецификация:";
	}
	options.cmdInsert = false;
	
	options.keyIds = options.keyIds || ["id"];
	
	//форма выбора из списка
	options.selectWinClass = ClientSpecificationList_Form;
	
	//options.selectDescrIds = options.selectDescrIds || ["name"];
	var self = this;
	options.selectDescrIds = function(f){
		return self.getSelectDescr(f);
	}
	
	//форма редактирования элемента
	options.editWinClass = null;
	
	options.labelClassName = "control-label "+window.getBsCol(2);
	
	options.acMinLengthForQuery = 1;
	options.acController = new ClientSpecification_Controller(options.app);
	options.acCount = 100;
	options.acPublicMethod = options.acController.getPublicMethod("complete_for_client");
	options.acModel = new ClientSpecificationList_Model();
	options.acPatternFieldId = "search";
	options.acKeyFields = options.acKeyFields || [options.acModel.getField("id")];
	
	options.selectWinParams = (function(pm){
		return function(){
			var s = "cond_fields=client_id@@destination_id@@concrete_type_id&cond_sgns=e@@e@@e&cond_vals="+
				pm.getFieldValue("client_id") + "@@" +
				pm.getFieldValue("destination_id") + "@@" +
				pm.getFieldValue("concrete_type_id") +
				"&field_sep=@@";
			return s;
		}
	})(options.acPublicMethod);
	
	options.acDescrFunction = function(f){
		//return f.contract.getValue() + "/" + f.specification.getValue() + " (" +f.concrete_types_ref.getValue().getDescr() +": " + f.quant_balance.getValue() + " м3)";
		return self.getSelectDescr(f);
	};
	options.acOnBeforeSendQuery = function(){
		var pm = this.getPublicMethod()
		return (pm.getField("client_id").isSet()
			&&pm.getField("concrete_type_id").isSet()
			&&pm.getField("destination_id").isSet());
	}
	options.acICase = options.acICase || "1";
	options.acMid = options.acMid || "1";
	
	ClientSpecificationEdit.superclass.constructor.call(this,id,options);
}
extend(ClientSpecificationEdit,EditRef);

/* Constants */


/* private members */

/* protected*/


/* public methods */

ClientSpecificationEdit.prototype.getSelectDescr = function(f){
	return f.contract.getValue() + "/" + f.specification.getValue() + " (" +f.concrete_types_ref.getValue().getDescr() +": " + f.quant_balance.getValue() + " м3)";
}
