/** Copyright (c) 2025
	Andrey Mikhalevich, Katren ltd.
*/
function AuditLogList_View(id,options){	

	AuditLogList_View.superclass.constructor.call(this,id,options);

	var model = options?.models?.AuditLogList_Model
		?options.models.AuditLogList_Model
		: new AuditLogList_Model();
	var contr = new AuditLog_Controller();
	
	const constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);

	const self = this;
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":true,
		"filters":options?.detailFilters?.AuditLogList_Model ?? null,
		"readOnly": true,
		"editWinClass":null,
		"commands": null,
		// "commands":new GridCmdContainerAjx(id+":grid:cmd",{ 
		// 	cmdInsert: false,
		// 	cmdEdit: false,
		// 	cmdDelete: false,
		// }),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						options.detail? null :
						new GridCellHead(id+":grid:head:table_name",{
							"value":"Тип объекта",
							"columns":[
								new GridColumn({
									"field":model.getField("table_name"),
									"master":true,
									"detailViewClass":AuditLogDialog_View,
									"detailViewOptions":{
										"listView":self.m_listView,
										"detailFilters":{
											"AuditLogDialog_Model":[
												{
												"masterFieldId":"id",
												"field":"id",
												"sign":"e",
												"val":"0"
												}	
											]
										}													
									}
								})
							],
							"sortable":true,
						})

						,options.detail? null :
						new GridCellHead(id+":grid:head:type_descr",{
							"value":"Представление типа объекта",
							"columns":[
								new GridColumn({
									"field":model.getField("type_descr")
								})
							],
							"sortable":true
						})

						,options.detail? null :
						new GridCellHead(id+":grid:head:record_id",{
							"value":"Идентификатор",
							"columns":[
								new GridColumn({
									"field":model.getField("record_id"),
								})
							]
						})						

						,new GridCellHead(id+":grid:head:changed_at",{
							"value":"Время",
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("changed_at"),
									"master":(options.detail===true),
									"detailViewClass":AuditLogDialog_View,
									 "detailViewOptions": options.detail===true? {
										"listView":self.m_listView,
										"detailFilters":{
											"AuditLogDialog_Model":[
												{
												"masterFieldId":"id",
												"field":"id",
												"sign":"e",
												"val":"0"
												}	
											]
										}													
									} : null
								})
							],
							"sortable":true,
							"sort":"desc"														
						})						
						,options.detail === true? null :
						new GridCellHead(id+":grid:head:object_ref",{
							"value":"Объект",
							"columns":[
								new GridColumnRef({
									"field":model.getField("object_ref"),
								})
							]
						})						
						,new GridCellHead(id+":grid:head:operation_descr",{
							"value":"Операция",
							"columns":[
								new GridColumn({
									"field":model.getField("operation_descr"),
								})
							]
						})						
						,new GridCellHead(id+":grid:head:changed_by",{
							"value":"Пользователь",
							"columns":[
								new GridColumn({
									"field":model.getField("changed_by"),
								})
							]
						})						
					]
				})
			]
		}),
		"pagination":options.detail? null : new pagClass(id+"_page",
			{"countPerPage":constants.doc_per_page_count.getValue()}),		
		
		"autoRefresh":false,
		"refreshInterval":constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true
	}));	
	
}
extend(AuditLogList_View,ViewAjxList);

