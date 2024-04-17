/** Copyright (c) 2019
	Andrey Mikhalevich, Katren ltd.
*/
function CementSiloBalanceResetList_View(id,options){	

	CementSiloBalanceResetList_View.superclass.constructor.call(this,id,options);
	
	var model = options.models.CementSiloBalanceResetList_Model;
	var contr = new CementSiloBalanceReset_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var period_ctrl = new EditPeriodDate(id+":filter-ctrl-period",{
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
	};
	var role_id = window.getApp().getServVar("role_id");	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"filters":filters,
			"variantStorage":options.variantStorage
		}),
		"popUpMenu":popup_menu,
		"onEventSetCellOptions":function(opts){
			if(opts.gridColumn.getId()=="quant"&&this.getModel().getFieldValue("quant")<0){
				opts.attrs = opts.attrs || {};
				opts.attrs["class"] = opts.attrs["class"] || "";
				opts.attrs["class"]+= (opts.attrs["class"]=="")? "":" ";
				opts.attrs["class"]+= "negativeNumber";
			}
		},
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:date_time",{
							"value":"Дата",
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("date_time"),
									//"dateFormat":"d/m/y H:i",
									//"editMask":"99/99/9999 99:99",
									"searchOptions":{
										"field":new FieldDate("date_time"),
										"searchType":"on_beg",
										"ctrlClass":EditDate
									}
								})
							],
							"sortable":true,
							"sort":"desc"							
						})										
						,new GridCellHead(id+":grid:head:cement_silos_ref",{
							"value":"Силос",
							"columns":[
								new GridColumnRef({
									"field":model.getField("cement_silos_ref"),
									"ctrlClass":CementSiloEdit,
									"ctrlBindFieldId":"cement_silo_id",
									"ctrlOptions":{
										"labelCaption":""
									},
									"searchOptions":{
										"field":new FieldInt("cement_silo_id"),
										"searchType":"on_match"
									}									
									
								})
							],
							"sortable":true
						})
						/*
						,new GridCellHead(id+":grid:head:comment_text",{
							"value":"Комментарий",
							"columns":[
								new GridColumn({
									"field":model.getField("comment_text")
								})
							]
						})
						*/
						,new GridCellHead(id+":grid:head:quant_required",{
							"value":"Кол-во фактич.",
							"columns":[
								new GridColumnFloat({
									"field":model.getField("quant_required"),
									"precision":"4",
									"ctrlOptions":{
										"length":"19",
										"precision":"4"
									}
								})
							]
						})
						
						,new GridCellHead(id+":grid:head:quant",{
							"value":"Разница (-не хватило,+ излишек)",
							"columns":[
								new GridColumnFloat({
									"field":model.getField("quant"),
									"precision":"4",
									"ctrlOptions":{
										"enabled":false,
										"precision":"4"
									}
								})
							]
						})
						,new GridCellHead(id+":grid:head:users_ref",{
							"value":"Пользователь",
							"columns":[
								new GridColumnRef({
									"field":model.getField("users_ref"),
									"form":User_Form,
									"ctrlClass":UserEditRef,
									"ctrlBindFieldId":"user_id",
									"ctrlOptions":{
										"labelCaption":"",
										"enabled":(role_id=="admin"||role_id=="owner"),
									},
									"searchOptions":{
										"field":new FieldInt("user_id"),
										"searchType":"on_match"
									}									
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
		
		"autoRefresh":false,
		"refreshInterval":constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true
	}));	
	


}
extend(CementSiloBalanceResetList_View,ViewAjxList);
