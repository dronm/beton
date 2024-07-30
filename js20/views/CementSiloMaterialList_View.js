/** Copyright (c) 2024
 *	Andrey Mikhalevich, Katren ltd.
 */
function CementSiloMaterialList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Материалы в силосах";

	CementSiloMaterialList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.CementSiloMaterialList_Model)? options.models.CementSiloMaterialList_Model : new CementSiloMaterialList_Model();
	var contr = new CementSiloMaterial_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	
	var filters;
	this.addElement(new GridAjx(id+":grid",{
		"filters": filters,
		"model":model,
		"keyIds":["id"],
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"editViewClass":null,
		"editViewOptions":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"exportFileName" :"МатериалыВСилосах"
		}),		
		"popUpMenu":popup_menu,
		"filters":(options.detailFilters&&options.detailFilters.CementSiloMaterialList_Model)? options.detailFilters.CementSiloMaterialList_Model:null,	
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:date_time",{
							"value":"Дата",
							"columns":[
								new GridColumnDateTime({"field":model.getField("date_time")})
							]
						}),
						options.detailFilters? null : new GridCellHead(id+":grid:head:cement_silos_ref",{
							"value":"Силос",
							"columns":[
								new GridColumnRef({
									"field":model.getField("cement_silos_ref"),
									"ctrlClass":CementSiloEdit,
									"searchOptions":{
										"field":new FieldInt("cement_silo_id"),
										"searchType":"on_match"
									},									
									"ctrlBindFieldId":"cement_silo_id",
								})
							],
							"sortable":true,
							"sort":"asc"							
						}),
						new GridCellHead(id+":grid:head:materials_ref",{
							"value":"Материал",
							"columns":[
								new GridColumnRef({
									"field":model.getField("materials_ref"),
									"ctrlClass":MaterialSelect,
									"ctrlOptions":{
										"labelCaption":""
									},
									"searchOptions":{
										"field":new FieldInt("material_id"),
										"searchType":"on_match"
									},
									"ctrlBindFieldId":"material_id",
								})
							],
							"sortable":true
						})
					]
				})
			]
		}),
		"pagination":new pagClass(id+"_page",
			{"countPerPage":constants.doc_per_page_count.getValue()}),		
		
		"autoRefresh":options.detailFilters? true:false,
		"refreshInterval":constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true
	}));	
}
extend(CementSiloMaterialList_View,ViewAjxList);

