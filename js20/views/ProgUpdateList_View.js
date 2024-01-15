/** Copyright (c) 2023
 *	Andrey Mikhalevich, Katren ltd.
 */
function ProgUpdateList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Обновления прогрммы";

	ProgUpdateList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models. ProgUpdate_Model)? options.models. ProgUpdate_Model : new ProgUpdate_Model();
	var contr = new ProgUpdate_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	
	var period_ctrl = new EditPeriodDate(id+":filter-ctrl-period",{
		"field":new FieldDateTime("creata_date_time")
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
	};
		
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"filters": filters
		}),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:create_date_time",{
							"value":"Дата",
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("create_date_time")
								})
							],
							"sortable":true
						})
					
						,new GridCellHead(id+":grid:head:release",{
							"value":"Релиз",
							"columns":[
								new GridColumn({
									"field":model.getField("release"),
									"master":true,
									"detailViewClass":ProgUpdateDetailList_View,
									"detailViewOptions":{								
										"detailFilters":{
											"ProgUpdateDetail_Model":[
												{
												"masterFieldId":"id",
												"field":"prog_update_id",
												"sign":"e",
												"val":"0"
												}	
											]
										}													
									}									
								})								
							],
							"sortable":true,
							"sort":"desc"
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
extend(ProgUpdateList_View,ViewAjxList);
