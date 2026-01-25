/** Copyright (c) 2026
 *	Andrey Mikhalevich, Katren ltd.
 */
function ProductionReportList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Отчеты производства за смену";

	ProductionReportList_View.superclass.constructor.call(this,id,options);
	
	// var model = (options.models && options.models.ProductionReportList_Model)? options.models.ProductionReportList_Model : new ProductionReportList_Model();
	const model = options.models.ProductionReportList_Model;
	var contr = new ProductionReport_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	
	const self = this;
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":false,
		"editWinClass":ProductionReportDialog_Form,
		"commands":new GridCmdContainerAjx(id+":grid:cmd"),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:period",{
							"value":"Смена",
							"columns":[
								new GridColumn({
									"ctrlEdit":false,
									"formatFunction":function(f, gridCell){
										const shFrom = f.shift_from.getValue();
										// const shTo = f.shift_to.getValue();
										return DateHelper.format(shFrom, "d/m/y");
									}
								})
							]
						})
						,new GridCellHead(id+":grid:head:ref_1c",{
							"value":"Документ 1с",
							"columns":[
								new GridColumn({
									"ctrlEdit":false,
									"formatFunction":function(f, gridCell){
										const ref = f.ref_1c.getValue();
										if(!ref || !("descr" in ref)){
											const n = gridCell.getNode();
											(new ProductionReportTo1cBtn("prodRepList:export", {
												grid: self.getElement("grid")
											})).toDOM(n);
											return "";
										}
										return ref.descr;
									}
								})
							]
						})
					]
				})
			]
		}),
		"pagination":new pagClass(id+"_page",
			{"countPerPage":constants.doc_per_page_count.getValue()}),		
		
		"autoRefresh":false,
		"refreshInterval":constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true
	}));	
}
extend(ProductionReportList_View,ViewAjxList);

