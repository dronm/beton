/** Copyright (c) 2019, 2023, 2024
 *	Andrey Mikhalevich, Katren ltd.
 */

// import {EditPeriodDateShift} from '../custom_controls/EditPeriodDateShift.js';
// import {CommandBinding} from '../controls/CommandBinding.js';
// import {PopUpMenu} from '../controls/PopUpMenu.js';
// import {GridAjx} from '../controls/GridAjx.js';
// import {FieldDateTime} from '../core/FieldDateTime.js';
// import {FieldInt} from '../core/FieldInt.js';
// import {DOCMaterialProcurement_Controller} from '../controllers/DOCMaterialProcurement_Controller.js';
// import {DOCMaterialProcurementList_Model} from '../models/DOCMaterialProcurementList_Model.js';
// import {MaterialSelect} from '../custom_controls/MaterialSelect.js';
// import {SupplierEdit} from '../custom_controls/SupplierEdit.js';
// import {DOCMaterialProcurementDialog_Form} from '../forms/DOCMaterialProcurementDialog_Form.js';

function DOCMaterialProcurementList_View(id,options){	

	if(!options.detailFilters){
		options.HEAD_TITLE = "Поступление материалов.";
	}
	DOCMaterialProcurementList_View.superclass.constructor.call(this,id,options);

	var model = (options.models&&options.models.DOCMaterialProcurementList_Model)? options.models.DOCMaterialProcurementList_Model:new DOCMaterialProcurementList_Model();
	var contr = new DOCMaterialProcurement_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var filters;
	if(!options.detailFilters){
		var period_ctrl = new EditPeriodDateShift(id+":filter-ctrl-period",{
			"field":new FieldDateTime("date_time")
		});
		
		filters = {
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
			,"material": {
				"binding":new CommandBinding({
					"control":new MaterialSelect(id+":filter-ctrl-material",{
						"contClassName":"form-group-filter"
					}),
					"field":new FieldInt("material_id")}),
				"sign":"e"		
			}
			,"supplier": {
				"binding":new CommandBinding({
					"control":new SupplierEdit(id+":filter-ctrl-supplier",{
						"contClassName":"form-group-filter"
					}),
					"field":new FieldInt("supplier_id")}),
				"sign":"e"		
			}
			,"carrier": {
				"binding":new CommandBinding({
					"control":new SupplierEdit(id+":filter-ctrl-carrier",{
						"contClassName":"form-group-filter",
						"labelCaption":"Перевозчик:"
					}),
					"field":new FieldInt("carrier_id")}),
				"sign":"e"		
			}
			
		};
	}
			
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	this.addElement(new GridAjx(id+":grid",{
		"keyIds":["id"],
		"model":model,
		"controller":contr,
		"editInline":false,
		"editWinClass":DOCMaterialProcurementDialog_Form,
		"contClassName":options.detailFilters? window.getBsCol(11):null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdInsert":true,
			"cmdEdit":true,
			"cmdDelete":true,
			"cmdFilter":!options.detailFilters,
			"filters":filters,
			"variantStorage":options.variantStorage,
			"cmdSearch":!options.detailFilters
		}),
		"filters":(options.detailFilters&&options.detailFilters.DOCMaterialProcurementList_Model)? options.detailFilters.DOCMaterialProcurementList_Model:null,
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:date_time",{
							"value":"Дата",
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("date_time"),
									"dateFormat":"d/m/y H:i"
								})
							],
							"sortable":true,
							"sort":"desc"
						})
						,new GridCellHead(id+":grid:head:number",{
							"value":"Номер",
							"columns":[
								new GridColumn({
									"field":model.getField("number")
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:materials_ref",{
							"value":"Материал",
							"columns":[
								new GridColumnRef({
									"field":model.getField("materials_ref"),
									"ctrlClass":MaterialSelect,
									"searchOptions":{
										"field":new FieldInt("material_id"),
										"searchType":"on_match",
										"typeChange":false
									}									
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:cement_silos_ref",{
							"value":"Силос",
							"columns":[
								new GridColumnRef({
									"field":model.getField("cement_silos_ref"),
									"ctrlClass":CementSiloEdit,
									"searchOptions":{
										"field":new FieldInt("cement_silos_id"),
										"searchType":"on_match",
										"typeChange":false
									}									
									
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:store",{
							"value":"Место хранения",
							"columns":[
								new GridColumn({
									"field":model.getField("store")
								})
							],
							"sortable":true
						})
						
						,new GridCellHead(id+":grid:head:suppliers_ref",{
							"value":"Поставщик",
							"columns":[
								new GridColumnRef({
									"field":model.getField("suppliers_ref"),
									"ctrlClass":SupplierEdit,
									"searchOptions":{
										"field":new FieldInt("supplier_id"),
										"searchType":"on_match",
										"typeChange":false
									}									
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:carriers_ref",{
							"value":"Перевозчик",
							"columns":[
								new GridColumnRef({
									"field":model.getField("carriers_ref"),
									"ctrlClass":SupplierEdit,
									"searchOptions":{
										"field":new FieldInt("carrier_id"),
										"searchType":"on_match",
										"typeChange":false
									}									
									
								})
							]
						})
						,new GridCellHead(id+":grid:head:vehicle_plate",{
							"value":"ТС",
							"columns":[
								new GridColumn({
									"field":model.getField("vehicle_plate")
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:sender_name",{
							"value":"Пункт отправления",
							"columns":[
								new GridColumn({
									"field":model.getField("sender_name")
								})
							]
						})
						/*,new GridCellHead(id+":grid:head:driver",{
							"value":"Водитель",
							"columns":[
								new GridColumn({
									"field":model.getField("driver")
								})
							],
							"sortable":true
						})*/
						,new GridCellHead(id+":grid:head:quant_net",{
							"value":"Вес нетто (весы)",
							"colAttrs":{"align":"right"},
							"columns":[
								new GridColumnFloat({
									"field":model.getField("quant_net"),
									"precision":"4"
								})
							]
						})
						,new GridCellHead(id+":grid:head:doc_quant_net",{
							"value":"Вес нетто (док-ты)",
							"colAttrs":{"align":"right"},
							"columns":[
								new GridColumnFloat({
									"field":model.getField("doc_quant_net"),
									"precision":"4",
									"formatFunction":function(fields, cell){
										var v = fields.doc_quant_net.getValue();
										if(isNaN(v)){
											v = 0;
										}
										if(v > fields.quant_net.getValue()){
											cell.getNode().setAttribute("class", "negativeNumber");
										}
										return v;
									}
								})
							]
						})
						
						,new GridCellHead(id+":grid:head:comment_text",{
							"value":"Комментарий",
							"columns":[
								new GridColumn({
									"field":model.getField("comment_text")
								})
							]
						})
					]
				})
			]
		}),
		"foot":new GridFoot(id+":grid:foot",{
			"autoCalc":true,			
			"elements":[
				new GridRow(id+":grid:foot:row0",{
					"elements":[
						new GridCell(id+":grid:foot:sp1",{
							"value":"Итого",
							"colSpan":"9"
						})
						,new GridCellFoot(id+":grid:foot:tot_quant_net",{
							"attrs":{"align":"right"},
							"totalFieldId":"total_quant_net",
							"gridColumn":new GridColumnFloat({
								"id":"tot_quant_net",
								"precision":"4"
							})
						})						
						,new GridCellFoot(id+":grid:foot:tot_doc_quant_net",{
							"attrs":{"align":"right"},
							"totalFieldId":"total_doc_quant_net",
							"gridColumn":new GridColumnFloat({
								"id":"tot_doc_quant_net",
								"precision":"4"
							})
						})						
					
					]
				})		
			]
		}),		
		"pagination":options.detailFilters? null:new pagClass(id+"_page",
			{"countPerPage":constants.doc_per_page_count.getValue()}),		
		"autoRefresh":options.detailFilters? true:false,
		"refreshInterval":constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true
	}));	
	
}
extend(DOCMaterialProcurementList_View,ViewAjxList);

