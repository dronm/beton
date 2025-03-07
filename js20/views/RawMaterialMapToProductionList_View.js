/** Copyright (c) 2019
	Andrey Mikhalevich, Katren ltd.
*/
function RawMaterialMapToProductionList_View(id,options){	

	options = options || {};
	options.models = options.models || {};
	
	RawMaterialMapToProductionList_View.superclass.constructor.call(this,id,options);
	
	var auto_refresh = options.models.RawMaterialMapToProductionList_Model? false:true;
	var model = options.models.RawMaterialMapToProductionList_Model? options.models.RawMaterialMapToProductionList_Model : new RawMaterialMapToProductionList_Model();
	var contr = new RawMaterialMapToProduction_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var period_ctrl = new EditPeriodDateShift(id+":filter-ctrl-period",{
		"field":new FieldDateTime("date_time")
	});

	var filters = {
		"period":{
			"binding":new CommandBinding({
				"control":period_ctrl,
				"field":period_ctrl.getField()
			}),
			"bindings":[
				{"binding":new CommandBinding({
					"control":period_ctrl.getControlFrom(),
					"field":period_ctrl.getField()
					}),
				"sign":"ge"
				},
				{"binding":new CommandBinding({
					"control":period_ctrl.getControlTo(),
					"field":period_ctrl.getField()
					}),
				"sign":"le"
				}
			]
		}
		,"production_sites_ref":{
			"binding":new CommandBinding({
				"control":new ProductionSiteEdit(id+":filter-ctrl-production_sites_ref",{
					"contClassName":"form-group-filter",
					"labelCaption":"Завод:"
				}),
				"field":new FieldInt("production_site_id")}),
			"sign":"e"		
		}
		,"materials_ref":{
			"binding":new CommandBinding({
				"control":new MaterialSelect(id+":filter-ctrl-materials_ref",{
					"contClassName":"form-group-filter",
					"labelCaption":"Материал:"
				}),
				"field":new FieldInt("raw_material_id")}),
			"sign":"e"		
		}
		,"production_descr":{
			"binding":new CommandBinding({
				"control":new Edit(id+":filter-ctrl-production_descr",{
					"contClassName":"form-group-filter",
					"labelCaption":"Материал в производстве:"
				}),
				"field":new FieldText("production_descr")}),
			"sign":"lk",
			"icase": true,
			lwcards: true,
			rwcards: true
		}
	};

	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdFilter":true,
			"filters":filters,
			"variantStorage":options.variantStorage
		}),
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						,new GridCellHead(id+":grid:head:raw_materials_ref",{
							"value":"Материал в этой программе",
							"columns":[
								new GridColumnRef({
									"field":model.getField("raw_materials_ref"),
									"ctrlClass":MaterialSelect,
									"ctrlOptions":{
										"labelCaption":""
									},
									"ctrlBindFieldId":"raw_material_id"
								})
							]
							//"sortable":true
						})
						,new GridCellHead(id+":grid:head:date_time",{
							"value":"Дата",
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("date_time")
									//"dateFormat":"d/m/y H:i",
									//"editMask":"99/99/9999 99:99"
								})
							],
							"sortable":true,
							"sort":"desc"						
						})
					
						,new GridCellHead(id+":grid:head:production_descr",{
							"value":"Материал в производстве",
							"columns":[
								new GridColumn({
									"field":model.getField("production_descr"),
									"ctrlClass":EditString,
									"ctrlOptions":{
										"maxLength":100
									}																		
								})
							],
							"sortable":true
						})
						
						,new GridCellHead(id+":grid:head:production_sites_ref",{
							"value":"Завод (если не указан, то для всех заводов)",
							"columns":[
								new GridColumnRef({
									"field":model.getField("production_sites_ref"),
									"ctrlClass":ProductionSiteEdit,
									"ctrlBindFieldId":"production_site_id",
									"ctrlOptions":{
										"labelCaption":""
									}																		
								})
							]
							//"sortable":true
						})
						
						/*,new GridCellHead(id+":grid:head:order_id",{
							"value":"Порядок сортировки",
							"title":"При 0 - не отображать материал в общей таблице",
							"columns":[
								new GridColumn({
									"field":model.getField("order_id"),
									"ctrlClass":EditInt
								})
							]
						})
						*/
					]
				})
			]
		}),
		"pagination":new pagClass(id+"_page",
			{"countPerPage":constants.doc_per_page_count.getValue()}),		
		
		"autoRefresh":auto_refresh,
		"refreshInterval":constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true
	}));	
	


}
extend(RawMaterialMapToProductionList_View,ViewAjxList);
