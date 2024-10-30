/** Copyright (c) 2024
	Andrey Mikhalevich, Katren ltd.
 */
function InsuranceIssuerEdit(id,options){
	options = options || {};

	if (options.labelCaption==undefined){
		options.labelCaption = "Страховщик:";
	}
	options.maxLength = 250;
	
	options.cmdAutoComplete	= true;	
	options.acMinLengthForQuery = 1;
	options.acController = new Vehicle_Controller();
	options.acModel = new InsuranceIssuerList_Model();
	options.acPublicMethod = options.acController.getPublicMethod("complete_insurance_issuers")
	options.acPatternFieldId = options.acPatternFieldId || "issuer";
	options.acKeyFields = options.acKeyFields || [options.acModel.getField("issuer")];
	options.acDescrFields = options.acDescrFields || [options.acModel.getField("issuer")];
	options.acICase = options.acICase || "1";
	options.acMid = options.acMid || "1";
		
	InsuranceIssuerEdit.superclass.constructor.call(this,id,options);
	
}
extend(InsuranceIssuerEdit,EditString);


