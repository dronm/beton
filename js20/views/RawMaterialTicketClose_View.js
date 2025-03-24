/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022

 * @extends View
 * @requires core/extend.js
 * @requires controls/View.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function RawMaterialTicketClose_View(id,options){
	options = options || {};	

	var self = this;
	options.addElement = function(){
		if(!options.forSelect){
			this.addElement(new EditString(id+":barcode",{
				"labelCaption":"Штрих код талона:",
				"maxLength":13,
				"autofocus":true,
				"events":{
					"keypress":function(e){
						e = EventHelper.fixKeyEvent(e);
						if (e.keyCode==13){
							self.closeTicket(e.target.value);
						}								
					}
					,"input":function(e){
						e = EventHelper.fixKeyEvent(e);
						if (e.keyCode==13 || (e.target.value && e.target.value.length>=6)){
							self.closeTicket(e.target.value);
						}								
					}				
				}
			}));
		}	
	
		var model = options.listView? options.model : ((options.models&&options.models.RawMaterialTicketCarrierAggList_Model)? options.models.RawMaterialTicketCarrierAggList_Model : new RawMaterialTicketCarrierAggList_Model());
		
		let constants, contr;
		if(!options.listView){
			constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
			window.getApp().getConstantManager().get(constants);
		}
		contr = new RawMaterialTicket_Controller();		
		
		window.getApp().getConstantManager().get(constants);		
		this.addElement(new GridAjx(id+":grid",{
			"model":model,
			"attrs":{"style":"width:100%;"},
			//"className": options.listView? OrderMakeList_View.prototype.TABLE_CLASS : null,
			// "readPublicMethod": options.listView? null : contr.gePublicMethod("get_carrier_agg_list"),
			"readPublicMethod": contr.getPublicMethod("get_carrier_agg_list"),
			"controller": contr,
			"editInline":true,
			"editWinClass":null,		
			"commands": new GridCmdContainerAjx(id+":grid:cmd", {
				"cmdInsert": false,
				"cmdAllCommands": false
			}),//
			"popUpMenu":null,
			"head":new GridHead(id+"-grid:head",{
				"elements":[
					new GridRow(id+":grid:head:row0",{
						"elements":[
							new GridCellHead(id+":grid:head:carriers_ref",{
								"value":"Перевозчик",
								"columns":[
									new GridColumnRef({
										"field":model.getField("carriers_ref"),
										"ctrlBindFieldId": "carrier_id",
										"ctrlClass": SupplierEdit
									})
								],
								"sortable":true
							})
							,new GridCellHead(id+":grid:head:raw_materials_ref",{
								"value":"Материал",
								"columns":[
									new GridColumnRef({
										"field":model.getField("raw_materials_ref"),
										"ctrlBindFieldId": "raw_material_id",
										"ctrlClass": MaterialSelect
									})
								],
								"sortable":true
							})
							,new GridCellHead(id+":grid:head:quarries_ref",{
								"value":"Карьер",
								"columns":[
									new GridColumnRef({
										"field":model.getField("quarries_ref"),
										"ctrlBindFieldId": "quarry_id",
										"ctrlClass": QuarryEdit
									})
								],
								"sortable":true
							})
							,new GridCellHead(id+":grid:head:ticket_count",{
								"value":"Количество",
								"colAttrs":{
									"align":"right"
								},
								"columns":[
									new GridColumn({
										"field":model.getField("ticket_count")
									})
								]
							})
							,new GridCellHead(id+":grid:head:quant",{
								"value":"Вес за талон, т",
								"colAttrs":{
									"align":"right"
								},
								"columns":[
									new GridColumn({
										"field":model.getField("quant")
									})
								]
							})
							,new GridCellHead(id+":grid:head:quant_tot",{
								"value":"Вес итого, т",
								"colAttrs":{
									"align":"right"
								},
								"columns":[
									new GridColumn({
										"field":model.getField("quant_tot")
									})
								]
							})
						]
					})
				]
			}),
			"foot": new GridFoot(id+"grid:foot",{
				"autoCalc":true,							
				"elements":[
					new GridRow(id+":grid:foot:row0",{
						"elements":[
							new GridCell(id+":grid:foot:total_sp1",{
								"colSpan":"4"
							})											
							,new GridCellFoot(id+":grid:foot:tot_ticket_count",{
								"attrs":{"align": "right"},
								"calcOper":"sum",
								"calcFieldId":"ticket_count"
							})
							,new GridCellFoot(id+":grid:foot:tot_quant_tot",{
								"attrs":{"align": "right"},
								"calcOper":"sum",
								"calcFieldId":"quant_tot"
							})
						]
					})
				]
			}),			
			"pagination":null,				
			"autoRefresh": false,			
			"refreshInterval": options.listView? null : constants.grid_refresh_interval.getValue()*1000,
			"rowSelect":false,
			"focus":false
		}));	
	}
	
	RawMaterialTicketClose_View.superclass.constructor.call(this,id,options);
}
//ViewObjectAjx,ViewAjxList
extend(RawMaterialTicketClose_View,View);

/* Constants */


/* private members */

/* protected*/


/* public methods */

RawMaterialTicketClose_View.prototype.closeTicket = function(barcode){
	var pm = (new RawMaterialTicket_Controller()).getPublicMethod("close_ticket");
	pm.setFieldValue("barcode", barcode);
	window.setGlobalWait(true);
	var self = this;
	var ok_text = "Талон погашен";
	var w_tm = 3000;
	
	pm.run({
		"ok":function(resp){			
			self.getElement("barcode").reset();
			self.getElement("barcode").getErrorControl().setValue(ok_text, "info");
			setTimeout(function(){
				self.getElement("barcode").getErrorControl().clear();
			},w_tm);
			self.getElement("barcode").focus();
			var pm = (new RawMaterialTicket_Controller()).getPublicMethod("get_carrier_agg_list");
			pm.run({
				"ok":function(resp){
					var grid = self.getElement("grid");
					grid.getModel().setData(resp.getModelData("RawMaterialTicketCarrierAggList_Model"));
					grid.onGetData();
					window.showTempNote(ok_text, null, w_tm);
				}
			})
		}
		,"fail":function(resp,errCode,errStr){
			if(errCode == 1000 || errCode == 1001){
				self.getElement("barcode").getErrorControl().setValue(errStr, (errCode==1000)? "danger":"warn");
				setTimeout(function(){
					self.getElement("barcode").getErrorControl().clear();
				},w_tm);
				self.getElement("barcode").focus();
				
			}else{
				throw new Error(errStr);
			}
		}
		,"all":function(){
			window.setGlobalWait(false);
		}
	});
}

