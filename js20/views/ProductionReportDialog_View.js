/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2026
 
 * @extends ViewObjectAjx.js
 * @requires core/extend.js  
 * @requires controls/ViewObjectAjx.js 
 
 * @class
 * @classdesc
	
 * @param {string} id view identifier
 * @param {object} options
 * @param {object} options.models All data models
 * @param {object} options.variantStorage {name,model}
 */	
function ProductionReportDialog_View(id,options){	

	options = options || {};
	
	options.controller = new ProductionReport_Controller();
	options.model = options.models.ProductionReportDialog_Model;
	
	options.addElement = function(){
		this.addElement(new EditNum(id+":id",{
			"labelCaption": "Номер:"
			// "editContClassName": "input-group "+window.getBsCol(2),
			// "labelClassName": "control-label "+window.getBsCol(2)
		}));	
		this.addElement(new EditDateTime(id+":shift_from",{
			"labelCaption": "Смена с:"
			// "editContClassName": "input-group "+window.getBsCol(2),
			// "labelClassName": "control-label "+window.getBsCol(2)
		}));	
		this.addElement(new EditDateTime(id+":shift_to",{
			"labelCaption": "Смена по:"
			// "editContClassName": "input-group "+window.getBsCol(2),
			// "labelClassName": "control-label "+window.getBsCol(2)
		}));	

		//items
		this.m_modelItems = new ModelJSON(id+":itmes", {
			simpleStructure: true,
			fields: ["code_1c", "name", "quant"]
		});

		this.addElement(new Grid(id+":items",{
			"model":this.m_modelItems,
			"keyIds":["code_1c"],
			"head":new GridHead(id+":head",{
				"elements":[
					new GridRow(id+":head:row0",{
						"elements":[
							new GridCellHead(id+":head:code_1c",{
								"value":"Код 1с",
								"columns":[
									new GridColumn({
										"field":this.m_modelItems.getField("code_1c")
									})
								]
							})
							,new GridCellHead(id+":head:name",{
								"value":"Наименование",
								"columns":[
									new GridColumn({
										"field":this.m_modelItems.getField("name")
									})
								]
							})
							,new GridCellHead(id+":head:quant",{
								"value":"Количество",
								"columns":[
									new GridColumnFloat({
										"field":this.m_modelItems.getField("quant"),
										"precision": 4
									})
								]
							})
						]
					})
				]
			}),
			"pagination":null,				
			"autoRefresh":false,
			"refreshInterval":0,
			"rowSelect":true
		}));

		//materials
		//
		this.m_modelMaterials = new ModelJSON(id+":materials", {
			simpleStructure: true,
			fields: [
				"wareshouse_ref_1c", "wareshouse_name", "production_site_name",
				"ref_1c", "name", "quant", "ref_1c_descr"
			]
		});

		this.addElement(new Grid(id+":materials",{
			"model":this.m_modelMaterials,
			"keyIds":["ref_1c"],
			"head":new GridHead(id+":materials:head",{
				"elements":[
					new GridRow(id+":materials:head:row0",{
						"elements":[
							new GridCellHead(id+":materials:head:production_site_name",{
								"value":"Завод",
								"columns":[
									new GridColumn({
										"field":this.m_modelMaterials.getField("production_site_name")
									})
								]
							})
							,new GridCellHead(id+":materials:head:wareshouse_name",{
								"value":"Склад 1с",
								"columns":[
									new GridColumn({
										"field":this.m_modelMaterials.getField("wareshouse_name")
									})
								]
							})
							,new GridCellHead(id+":materials:head:name",{
								"value":"Материал",
								"columns":[
									new GridColumn({
										"field":this.m_modelMaterials.getField("name")
									})
								]
							})
							,new GridCellHead(id+":materials:head:ref_1c_descr",{
								"value":"Материал 1с",
								"columns":[
									new GridColumn({
										"field":this.m_modelMaterials.getField("ref_1c_descr")
										// "formatFunction": function(f){
										// 	const ref1cStr = f.ref_1c.getValue();
										// 	if(!ref1cStr || ref1cStr.lenght==0){
										// 		return "";
										// 	}
										// 	const ref1c = JSON.parse(ref1cStr);
										// 	if(!ref1c || !("descr" in ref1c)){
										// 		return "";
										// 	}
										// 	return ref1c.descr;
										// }
									})
								]
							})
							,new GridCellHead(id+":materials:head:quant",{
								"value":"Количество",
								"columns":[
									new GridColumnFloat({
										"field":this.m_modelMaterials.getField("quant"),
										"precision": 4
									})
								]
							})
						]
					})
				]
			}),
			"pagination":null,				
			"autoRefresh":false,
			"refreshInterval":0,
			"rowSelect":true
		}));
	}
	
	ProductionReportDialog_View.superclass.constructor.call(this,id,options);
	
	//****************************************************
	//read
	this.setDataBindings([
		new DataBinding({"control":this.getElement("shift_from")})
		,new DataBinding({"control":this.getElement("shift_to")})
	]);
	
	//write
	this.setWriteBindings([
		new CommandBinding({"control":this.getElement("shift_from")})		
		,new CommandBinding({"control":this.getElement("shift_to")})
	]);
}
extend(ProductionReportDialog_View,ViewObjectAjx);


ProductionReportDialog_View.prototype.onGetData = function(resp,cmd){
	ProductionReportDialog_View.superclass.onGetData.call(this,resp,cmd);

	const m = this.getModel();

	const materials = m.getFieldValue("materials");
	this.m_modelMaterials.setData(materials);
	this.getElement("materials").onRefresh();

	const items = m.getFieldValue("items");
	this.m_modelItems.setData(items);
	this.getElement("items").onRefresh();
}
