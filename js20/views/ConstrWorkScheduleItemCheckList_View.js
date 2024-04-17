/** Copyright (c) 2023
 *	Andrey Mikhalevich, Katren ltd.
 *
 *	Только для режима рассшифровки с указанием работы объекта!
 */
function ConstrWorkScheduleItemCheckList_View(id,options){	

	options = options || {};

	ConstrWorkScheduleItemCheckList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.ConstrWorkScheduleItemCheck_Model)? options.models.ConstrWorkScheduleItemCheck_Model : new ConstrWorkScheduleItemCheck_Model();
	var contr = new ConstrWorkScheduleItemCheck_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);

	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd"),		
		"popUpMenu":new PopUpMenu(),
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:constr_work",{
							"value":"Работа",
							"columns":[
								new GridColumn({
									"field":model.getField("constr_work"),
									"ctrlClass": EditString,
									"ctrlOptions":{
										"maxLength":"1000"
									}
								})
							]
						})
						,new GridCellHead(id+":grid:head:begin_date",{
							"value":"Дата начала",
							"columns":[
								new GridColumnDate({
									"field":model.getField("begin_date"),
									"ctrlClass": EditDate
								})
							]
						})
						,new GridCellHead(id+":grid:head:end_date",{
							"value":"Дата окончания",
							"columns":[
								new GridColumnDate({
									"field":model.getField("end_date"),
									"ctrlClass": EditDate
								})
							]
						})
						,new GridCellHead(id+":grid:head:fact_end_date",{
							"value":"Фактическая дата окончания",
							"columns":[
								new GridColumnDate({
									"field":model.getField("fact_end_date"),
									"ctrlClass": EditDate,
									"ctrlEdit": false
								})
							]
						})
						
					]
				})
			]
		}),
		"pagination":null,		
		
		"autoRefresh":false,
		"refreshInterval":constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true,
		"srvEvents": null,
	}));	
}
extend(ConstrWorkScheduleItemCheckList_View,ViewAjxList);


