/** Copyright (c) 2025
 *	Andrey Mikhalevich, Katren ltd.
 */
function ClientContract1cEdit(id,options){

	options = options || {};	
	if (options.labelCaption!=""){
		options.labelCaption = options.labelCaption || "Договор 1с";
	}
	if (options.title!=""){
		options.title = options.title || "Договор 1с";
	}
	if (options.placeholder!=""){
		options.placeholder = options.placeholder || "Договор 1с";
	}
	
	options.cmdInsert = false;
	
	options.keyIds = options.keyIds || ["ref"];
	
	//форма выбора из списка
	options.selectWinClass = null;
	options.selectDescrIds = null;
	
	//форма редактирования элемента
	options.editWinClass = null;
	
	options.acMinLengthForQuery = (options.acMinLengthForQuery!=undefined)? options.acMinLengthForQuery:1;
	options.acController = new ClientContract1c_Controller();
	options.acPublicMethod = options.acController.getPublicMethod("complete_from_1c");
	options.acModel = new ModelJSON("Contract1cList_Model", {
		"fields":["name", "ref"]
	});
	// const self = this;
	// options.onSelect = function(f){
	// 	console.log("contract selected,", f)
		// const n = self.getNode();
		// n.setAttribute("date_from", f.date_from.getValue());
		// n.setAttribute("date_to", f.date_to.getValue());
		// n.setAttribute("total", f.total.getValue());
	// }
	// options.acResultFieldIdsToAttr = ["date_from", "date_to", "total"];
	options.acPatternFieldId = options.acPatternFieldId || "search";
	options.acKeyFields = options.acKeyFields || [options.acModel.getField("ref") ];
	options.acDescrFields = [options.acModel.getField("name")];

	options.acICase = options.acICase || "1";
	options.acMid = options.acMid || "1";
	
	ClientContract1cEdit.superclass.constructor.call(this,id,options);
}
extend(ClientContract1cEdit,EditRef);

ClientContract1cEdit.prototype.setClientRef1c = function(clientRef1c) {
	const pm = this.getAutoComplete().getPublicMethod("complete_from_1c");
	pm.setFieldValue("client_ref_1c", clientRef1c); 
}

