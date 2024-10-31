/** Copyright (c) 2024
 *	Andrey Mikhalevich, Katren ltd.
 */
function BuhRBP1cEdit(id,options){

	options = options || {};	
	if (options.labelCaption!=""){
		options.labelCaption = options.labelCaption || "Статья рбп 1с:";
	}
	if (options.title!=""){
		options.title = options.title || "Ссылка на статью расходов будущих периодов 1с";
	}
	if (options.placeholder!=""){
		options.placeholder = options.placeholder || "Наименование статьи в 1с";
	}
	
	options.cmdInsert = false;
	
	options.keyIds = options.keyIds || ["name"];
	
	//форма выбора из списка
	options.selectWinClass = null;
	options.selectDescrIds = null;
	
	//форма редактирования элемента
	options.editWinClass = null;
	
	options.acMinLengthForQuery = (options.acMinLengthForQuery!=undefined)? options.acMinLengthForQuery:1;
	options.acController = new BuhRBP1c_Controller();
	options.acPublicMethod = options.acController.getPublicMethod("complete");
	options.acModel = new ModelJSON("BuhRBP1cList_Model", {
		"fields":["name", "date_to", "date_from", "total"]
	});
	const self = this;
	options.onSelect = function(f){
		const n = self.getNode();
		n.setAttribute("date_from", f.date_from.getValue());
		n.setAttribute("date_to", f.date_to.getValue());
		n.setAttribute("total", f.total.getValue());
	}
	// options.acResultFieldIdsToAttr = ["date_from", "date_to", "total"];
	options.acPatternFieldId = options.acPatternFieldId || "search";
	options.acKeyFields = options.acKeyFields || [options.acModel.getField("name") ];
	options.acDescrFields = options.acDescrFields || [options.acModel.getField("name"),
			options.acModel.getField("date_from"),
			options.acModel.getField("date_to")	
	];

	options.acICase = options.acICase || "1";
	options.acMid = options.acMid || "1";
	
	BuhRBP1cEdit.superclass.constructor.call(this,id,options);
}
extend(BuhRBP1cEdit,EditRef);

