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
										//materials
										const ref = f.ref_1c.getValue();
										const refMat = f.material_ref_1c.getValue();
										const cellNode = gridCell.getNode();

										const matCont = document.createElement("div");
										(new ProductionReportMatTo1cBtn("prodRepList:export_mat", {
											grid: self.getElement("grid")
										})).toDOM(matCont);
										if(refMat && refMat.length){
											const matNode = document.createElement("span");
											let docs = "";
											for(let i = 0; i < refMat.length; i++){
												if(!("descr" in refMat[i])){
													continue;
												}
												if(docs !== ""){
													docs+= ", ";
												}
												docs+= refMat[i].descr;
											}
											matNode.textContent = docs;
											matCont.appendChild(matNode);
										}
										cellNode.appendChild(matCont);

										//production report
										const prodCont = document.createElement("div");
										(new ProductionReportTo1cBtn("prodRepList:export", {
											grid: self.getElement("grid")
										})).toDOM(prodCont);
										if(ref && ("descr" in ref)){
											const prodNode = document.createElement("span");
											prodNode.textContent = ref.descr;
											prodCont.appendChild(prodNode);
										}
										cellNode.appendChild(prodCont);

										return "";
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

