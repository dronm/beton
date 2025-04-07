/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022

 * @extends ViewAjxList
 * @requires core/extend.js
 * @requires controls/ViewAjxList.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function ProductionBaseList_View(id,options){
	options = options || {};	
	
	options.HEAD_TITLE  = "Производственные базы";
	ProductionBaseList_View.superclass.constructor.call(this,id,options);
	
	
	var model = options.models.ProductionBaseList_Model;
	var contr = new ProductionBase_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd"),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:name",{
							"value":"Наименование",
							"columns":[
								new GridColumn({
									"field":model.getField("name"),
									"ctrlClass":EditString,
									"ctrlOptions":{
										"maxLength":200
									},
									"master":true,
									"detailViewClass":ProductionSiteList_View,
									"detailViewOptions":{
										"detailFilters":{
											"ProductionSite_Model":[
												{
												"masterFieldId":"id",
												"field":"production_base_id",
												"sign":"e",
												"val":"0"
												}	
											]
										}													
									}
									
								})
							],
							"sortable":true,
							"sort":"asc"							
						})
						,new GridCellHead(id+":grid:head:destinations_ref",{
							"value":"Геозона",
							"columns":[
								new GridColumnRef({
									"field":model.getField("destinations_ref"),
									"ctrlBindFieldId":"destination_id",
									"ctrlClass":DestinationEdit,
									"ctrlOptions":{
										"labelCaption":""										
									}
								})
							]
						})						
						,new GridCellHead(id+":grid:head:address",{
							"value":"Адрес",
							"columns":[
								new GridColumn({
									"field":model.getField("address")
								})
							]
						})						
						,new GridCellHead(id+":grid:head:deleted",{
							"value":"Удален",
							"columns":[
								new GridColumnBool({
									"field":model.getField("deleted"),
									"showFalse": false
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
//ViewObjectAjx,ViewAjxList
extend(ProductionBaseList_View,ViewAjxList);

/* Constants */


/* private members */

/* protected*/


/* public methods */

