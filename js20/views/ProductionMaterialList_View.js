/** Copyright (c) 2019
 *	Andrey Mikhalevich, Katren ltd.
 */
function ProductionMaterialList_View(id,options){	

	var production_id,production_site_id;
	if(options.detailFilters){	
		for(var i=0;i<options.detailFilters.ProductionMaterialList_Model.length;i++){
			if(options.detailFilters.ProductionMaterialList_Model[i].masterFieldId=="production_id"){
				production_id = options.detailFilters.ProductionMaterialList_Model[i].val;
			}
			else if(options.detailFilters.ProductionMaterialList_Model[i].masterFieldId=="production_site_id"){
				production_site_id = options.detailFilters.ProductionMaterialList_Model[i].val;
			}
			
		}
	}
	this.HEAD_TITLE = "Списание материалов в производство"+( production_id? " №"+production_id:"" );
	/*
	options.template = window.getApp().getTemplate("ProductionMaterialList");
	options.templateOptions = {
		this.HEAD_TITLE:"Списание материалов в производство"+( production_id? " №"+production_id:"" )
	};
	*/
	
	ProductionMaterialList_View.superclass.constructor.call(this,id,options);

	var model = (options.models&&options.models.ProductionMaterialList_Model)? options.models.ProductionMaterialList_Model : new ProductionMaterialList_Model();
	var contr = new Production_Controller();
	
	var popup_menu = new PopUpMenu();
	var pagination = null,refresh_int = 0;
	
	var role_id = window.getApp().getServVar("role_id");
	var show_comment = (CommonHelper.inArray(role_id,["operator","dispatcher"])==-1);
	
	if(!options.detailFilters){
		var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
		window.getApp().getConstantManager().get(constants);	
		refresh_int = constants.grid_refresh_interval.getValue()*1000;
		
		var pagClass = window.getApp().getPaginationClass();
		pagination = new pagClass(id+"_page",{"countPerPage":constants.doc_per_page_count.getValue()});		
	}
	var self = this;
	this.addElement(new GridAjx(id+":grid",{
		"keyIds":["production_site_id","production_id","material_id","cement_silo_id"],
		"className":"table table-bordered table-responsive table-striped productionMaterialList",//+(!options.detailFilters? " table":""),
		"model":model,
		"controller":contr,
		"readPublicMethod":contr.getPublicMethod("get_production_material_list"),
		"editInline":true,
		"editWinClass":null,
		"contClassName":options.detailFilters? window.getBsCol(6):null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdInsert":options.detailFilters?
				(new ProductionMaterialListGridInsertCmd(id+":grid:cmd:insert",{
					"production_id":production_id
					,"production_site_id":production_site_id
				}))
				:false,
			"cmdEdit":false,
			"cmdCopy":false,
			"cmdDelete":(options.detailFilters && (role_id=="admin"||role_id=="owner"||role_id=="manager"||role_id=="accountant"||role_id=="supervisor"))?
				(new ProductionMaterialListGridDelCmd(id+":grid:cmd:delete",{
					"production_id":production_id
					,"production_site_id":production_site_id
				}))
				:false,
			"filters":null,
			"cmdAllCommands":options.detailFilters? false:true,
			"cmdSearch":options.detailFilters? false:true,
			"variantStorage":options.variantStorage
		}),		
		"popUpMenu":popup_menu,
		"onEventSetCellOptions":function(opts){
			if(opts.gridColumn.getId()=="quant_fact"){
				var q_editable = true;//(opts.fields.quant_fact.getValue()==0);
				if(q_editable){
					opts.className = "quant_editable";
				}
				var v = opts.fields.quant_corrected.getValue();
				opts.attrs = opts.attrs || {};
				if(v){
					opts.className = opts.className || "";				
					var elkon_cor = opts.fields.elkon_correction_id.getValue();					
					if(elkon_cor&&elkon_cor!="0"){
						opts.attrs.title = "Исправления Elkon №"+elkon_cor+" от "+DateHelper.format(opts.fields.correction_date_time_set.getValue(),"d/m/y H:i")+
							", "+opts.fields.correction_users_ref.getValue().getDescr();
						opts.className+= ((opts.className=="")? "":" ")+"factQuantCorrectedElkon";
					}
					else{
						opts.className+= ((opts.className=="")? "":" ")+"factQuantCorrected";	
						opts.attrs.title = "Ручное исправление:"+" от "+DateHelper.format(opts.fields.correction_date_time_set.getValue(),"d/m/y H:i")+
							", "+opts.fields.correction_users_ref.getValue().getDescr();
						
					}
				}
				else{
					opts.attrs.title = "Двойной клик для корректировки";
				}
				if(q_editable){					
					opts.events = opts.event || {};
					opts.events.dblclick = (function(thisForm){
						return function(e){
							if(thisForm.m_editMode)return;
							var grid = thisForm.getElement("grid");
							var row = DOMHelper.getParentByTagName(e.target,"TR");
							if(row){							
								grid.setModelToCurrentRow(row);
								thisForm.onEditCons(grid.getModel().getFields());
							}
							if (e.preventDefault){
								e.preventDefault();
							}
							e.stopPropagation();
							return false;						
						}
					})(self);
				}
			}
			else if(opts.gridColumn.getId()=="quant_req_dif"){//quant_dif
				if (opts.fields.req_dif_violation.getValue()){//dif_violation
					opts.className = "factQuantViolation";
					opts.title="Отклонение вышло за допустимые пределы";
				}
			}
			else if(opts.gridColumn.getId()=="production_comment"){
				opts.className = "quant_editable";
				opts.attrs = opts.attrs || {};
				var el = opts.fields.production_comment? opts.fields.production_comment.getValue():null;
				if(el){
					opts.attrs.title = "Добавлено:"+DateHelper.format(DateHelper.strtotime(el.date_time),"d/m/y H:i");
				}
				
				
				opts.events = opts.event || {};
				opts.events.dblclick = (function(thisForm){
					return function(e){
						if(thisForm.m_editMode)return;
						var grid = thisForm.getElement("grid");
						var row = DOMHelper.getParentByTagName(e.target,"TR");
						if(row){							
							grid.setModelToCurrentRow(row);
							thisForm.onEditComment(grid.getModel().getFields());
						}
						if (e.preventDefault){
							e.preventDefault();
						}
						e.stopPropagation();
						return false;						
					}
				})(self);
			
			}
		},
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						options.detailFilters? null:new GridCellHead(id+":grid:head:prodution_sites_ref",{
							"value":"Завод",							
							"columns":[
								new GridColumnRef({
									"field":model.getField("prodution_sites_ref"),
									"ctrlClass":ProductionSiteEdit,
									"ctrlBindFieldId":"prodution_site_id",
									"ctrlOptions":{
										"labelCaption":""
									}
								})
							],
							"sortable":true,
							"sort":"desc"
						})
						,options.detailFilters? null:new GridCellHead(id+":grid:head:prodution_id",{
							"value":"№ произв-ва",
							"columns":[
								new GridColumn({
									"field":model.getField("prodution_id"),
									"ctrlClass":ProductionSiteEdit,
									"ctrlBindFieldId":"prodution_id",
									"ctrlOptions":{
										"labelCaption":""
									}
								})
							],
							"sortable":true,
							"sort":"desc"
						})
						,options.detailFilters? null:new GridCellHead(id+":grid:head:shipments_ref",{
							"value":"Отгрузка",
							"columns":[
								new GridColumnRef({
									"field":model.getField("shipments_ref"),
									"ctrlClass":ShipmentEdit,
									"ctrlBindFieldId":"shipment_id",
									"ctrlOptions":{
										"labelCaption":""
									}
								})
							]
						})
						,new GridCellHead(id+":grid:head:materials_ref",{
							"value":"Материал",
							"className":options.detailFilters? window.getBsCol(2):"",
							"columns":[
								new GridColumn({
									"field":model.getField("materials_ref"),
									"ctrlClass":MaterialSelect,
									"ctrlBindFieldId":"material_id",
									"ctrlOptions":{
										"labelCaption":""
									},
									"formatFunction":function(fields){
										var mat = fields.materials_ref.getValue();
										var res = !mat.isNull()? mat.getDescr():"";
										var sil = fields.cement_silos_ref.getValue();
										if(!sil.isNull()){
											res+= " (силос:"+sil.getDescr()+")";
										}
										return res;
									}
								})
							]
						})
						,new GridCellHead(id+":grid:head:quant_consuption",{
							"value":"Кол-во подбор (Бетон)",
							"className":options.detailFilters? window.getBsCol(1):"",
							"colAttrs":{"align":"right","width":"10px"},
							"columns":[
								new GridColumnFloat({
									"field":model.getField("quant_consuption"),
									"precision":"4",
									"ctrlOptions":{
										"enabled":false
									}									
								})
							]
						})
						,new GridCellHead(id+":grid:head:quant_fact_req",{
							"value":"Кол-во подбор (Elkon)",
							"className":options.detailFilters? window.getBsCol(1):"",
							"colAttrs":{"align":"right","width":"10px"},
							"columns":[
								new GridColumnFloat({
									"field":model.getField("quant_fact_req"),
									"precision":"4"
								})
							]
						})
						
						,new GridCellHead(id+":grid:head:quant_fact",{
							"value":"Кол-во факт",
							"className":options.detailFilters? window.getBsCol(1):"",
							"colAttrs":{"align":"right","width":"10px"},
							"title":"Двойной клик для ручного исправления",
							"columns":[
								new GridColumnFloat({
									"field":model.getField("quant_fact"),
									"precision":"4"
								})
							]
						})
						/*,new GridCellHead(id+":grid:head:quant_corrected",{
							"value":"Исправлено",
							"colAttrs":{"align":"right"},
							"title":"Ручное исправление",
							"columns":[
								new GridColumnFloat({
									"field":model.getField("quant_corrected")
								})
							]
						})
						*/
						,new GridCellHead(id+":grid:head:quant_dif",{
							"value":"Отклонение (факт-Бетон)",
							"className":options.detailFilters? window.getBsCol(1):"",
							"colAttrs":{"align":"right","width":"10px"},
							"columns":[
								new GridColumnFloat({
									"field":model.getField("quant_dif"),
									"precision":"4",
									"sign":true,
									"ctrlOptions":{
										"enabled":false
									}
								})
							]
						})
						
						,new GridCellHead(id+":grid:head:quant_req_dif",{
							"value":"Отклонение (факт-Elkon)",
							"className":options.detailFilters? window.getBsCol(1):"",
							"colAttrs":{"align":"right","width":"10px"},
							"columns":[
								new GridColumnFloat({
									"field":model.getField("quant_req_dif"),
									"precision":"4",
									"sign":true
								})
							]
						})
						
						,show_comment? new GridCellHead(id+":grid:head:production_comment",{
							"value":"Комментарий",
							"columns":[
								new GridColumn({
									"field":model.getField("production_comment"),
									"ctrlOptions":{
										"enabled":false
									},
									"formatFunction":function(fields){
										var el = fields.production_comment? fields.production_comment.getValue():null;
										var res = el? el.comment_text:"";
										return res;
									}
								})
							]
						}):null
						
					]
				})
			]
		}),
		"filters":options.detailFilters? options.detailFilters.ProductionMaterialList_Model:null,
		"pagination":pagination,				
		"autoRefresh":options.detailFilters? true:false,
		"refreshInterval":refresh_int,
		"rowSelect":false,
		"focus":true
	}));	
	
}
extend(ProductionMaterialList_View,ViewAjxList);

ProductionMaterialList_View.prototype.setCommentOnServer = function(newValues,fieldValues){
	var self = this;
	var pm = (new ProductionComment_Controller()).getPublicMethod("insert");	
	pm.setFieldValue("production_site_id",fieldValues.production_site_id);
	pm.setFieldValue("material_id",fieldValues.material_id);
	pm.setFieldValue("production_id",fieldValues.production_id);
	pm.setFieldValue("comment_text",newValues.comment_text);
	pm.run({
		"ok":function(){
			window.showTempNote(fieldValues.material_descr+": установлен комментарий",null,5000);				
			self.closeForm();
			self.getElement("grid").onRefresh();
		}
	})	
}

ProductionMaterialList_View.prototype.setCorrectionOnServer = function(newValues,fieldValues){
	var self = this;
	var pm = (new MaterialFactConsumptionCorretion_Controller()).getPublicMethod("operator_insert_correction");	
	pm.setFieldValue("production_site_id",fieldValues.production_site_id);
	pm.setFieldValue("material_id",fieldValues.material_id);
	pm.setFieldValue("cement_silo_id",fieldValues.cement_silo_id);
	pm.setFieldValue("production_id",fieldValues.production_id);
	//alert("newValues.quant="+newValues.quant+" fieldValues.material_quant="+fieldValues.material_quant);
	//return;
	pm.setFieldValue("cor_quant",newValues.quant);// - fieldValues.material_quant
	pm.setFieldValue("comment_text",newValues.comment_text);
	pm.run({
		"ok":function(){
			window.showTempNote(fieldValues.material_descr+": откорректирован фактический расход по материалу",null,5000);				
			self.closeForm();
			self.getElement("grid").onRefresh();
		}
	})	
}

ProductionMaterialList_View.prototype.onEditCons = function(fields){

	this.m_editMode = true;
	var self = this;
	this.m_view = new EditJSON("CorrectQuant:cont",{
		"elements":[
			new EditFloat("CorrectQuant:cont:quant",{
				"labelCaption":"Количество добавить:",
				"length":19,
				"precision":4,
				"focus":true,
				"value":0,//fields.quant_fact.getValue(),
				"focus":true
			})
			,new EditText("CorrectQuant:cont:comment_text",{
				"labelCaption":"Комментарий:",
				"rows":3
			})
		]
	});
	this.m_form = new WindowFormModalBS("CorrectQuant",{
		"content":this.m_view,
		"cmdCancel":true,
		"cmdOk":true,
		"contentHead":"Корректировка фактического расхода "+fields.materials_ref.getValue().getDescr(),
		"onClickCancel":function(){
			self.closeForm();
		},
		"onClickOk":function(){
			var res = self.m_view.getValueJSON();
			if(!res||!res.quant){
				self.closeForm();
			}
			else{
				self.setCorrectionOnServer(res,self.m_view.fieldValues);
			}
		}
	});
	this.m_view.fieldValues = {
		"material_descr":fields.materials_ref.getValue().getDescr(),
		"production_site_id":fields.production_site_id.getValue(),
		"production_id":fields.production_id.getValue(),
		"material_id":fields.material_id.getValue(),
		"cement_silo_id":fields.cement_silo_id.getValue(),
		"material_quant":fields.material_quant.getValue()
	}
	
	this.m_form.open();
	
}

ProductionMaterialList_View.prototype.onEditComment = function(fields){

	this.m_editMode = true;
	var el = fields.production_comment? fields.production_comment.getValue():null;
	var comment_text = el? el.comment_text:"";
	
	var self = this;
	this.m_view = new EditJSON("Comment:cont",{
		"elements":[
			new EditText("Comment:cont:comment_text",{
				"labelCaption":"Комментарий:",
				"rows":3,
				"value":comment_text,
				"focus":true
			})
		]
	});
	this.m_form = new WindowFormModalBS("Comment",{
		"content":this.m_view,
		"cmdCancel":true,
		"cmdOk":true,
		"contentHead":"Комментарий по материалу: "+fields.materials_ref.getValue().getDescr(),
		"onClickCancel":function(){
			self.closeForm();
		},
		"onClickOk":function(){
			var res = self.m_view.getValueJSON();
			//always send!!!
			self.setCommentOnServer(res,self.m_view.fieldValues);
			/*
			if(!res||!res.comment_text.length){
				self.closeForm();
			}
			else{
				self.setCommentOnServer(res,self.m_view.fieldValues);
			}
			*/
		}
	});
	this.m_view.fieldValues = {
		"material_descr":fields.materials_ref.getValue().getDescr(),
		"production_site_id":fields.production_site_id.getValue(),
		"production_id":fields.production_id.getValue(),
		"material_id":fields.material_id.getValue()
	}
	
	this.m_form.open();
	
}


ProductionMaterialList_View.prototype.closeForm = function(){
	this.m_view.delDOM()
	this.m_form.delDOM();
	delete this.m_view;
	delete this.m_form;			
	
	this.m_editMode = false;
}

