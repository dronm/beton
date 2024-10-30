/** Copyright (c) 2024
	Andrey Mikhalevich, Katren ltd.
 */
function LeasorEdit(id,options){
	options = options || {};

	if (options.labelCaption==undefined){
		options.labelCaption = "Лизингодатель:";
	}
	options.maxLength = 250;
	
	options.cmdAutoComplete	= true;	
	options.acMinLengthForQuery = 1;
	options.acController = new Vehicle_Controller();
	options.acModel = new LeasorList_Model();
	options.acPublicMethod = options.acController.getPublicMethod("complete_leasors")
	options.acPatternFieldId = options.acPatternFieldId || "leasor";
	options.acKeyFields = options.acKeyFields || [options.acModel.getField("leasor")];
	options.acDescrFields = options.acDescrFields || [options.acModel.getField("leasor")];
	options.acICase = options.acICase || "1";
	options.acMid = options.acMid || "1";
		
	LeasorEdit.superclass.constructor.call(this,id,options);
	
}
extend(LeasorEdit,EditString);



