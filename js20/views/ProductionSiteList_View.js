/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2018,2022

 * @extends ViewAjxList
 * @requires core/extend.js
 * @requires controls/ViewAjxList.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function ProductionSiteList_View(id,options){
	options = options || {};	
	
	ProductionSiteList_View.superclass.constructor.call(this,id,options);
		
	var model = (options.models&&options.models.ProductionSite_Model)? options.models.ProductionSite_Model : new ProductionSite_Model();
	var contr = new ProductionSite_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":options.detailFilters? null : new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdInsert":false,
			"cmdEdit":false,
			"cmdDelete":false		
		}),		
		"popUpMenu":options.detailFilters? null : popup_menu,
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
										"maxLength":100
									}
								})
							],
							"sortable":true,
							"sort":"asc"							
						})
					]
				})
			]
		}),
		"filters":options.detailFilters? options.detailFilters.ProductionSite_Model:null,
		"pagination":new pagClass(id+"_page",
			{"countPerPage":constants.doc_per_page_count.getValue()}),		
		
		"autoRefresh":options.detailFilters,
		"refreshInterval":constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true
	}));	
		
}
//ViewObjectAjx,ViewAjxList
extend(ProductionSiteList_View,ViewAjxList);

/* Constants */


/* private members */

/* protected*/


/* public methods */

