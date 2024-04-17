/** Copyright (c) 2019
	Andrey Mikhalevich, Katren ltd.
*/
function ConcreteTypeList_View(id,options){	

	ConcreteTypeList_View.superclass.constructor.call(this,id,options);

	var model = options.models.ConcreteTypeList_Model;
	var contr = new ConcreteType_Controller();
	
	var popup_menu = new PopUpMenu();
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd"),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:name",{
							"value":"Наименование",
							"columns":[
								new GridColumn({
									"field":model.getField("name"),
									"ctrlClass":EditString,
									"ctrlOptions":{
										"maxLength":100,
										"placeholder":"Наименование марки"
									}
								})
							],
							"sortable":true,
							"sort":"asc"							
						})
						,new GridCellHead(id+":grid:head:official_name",{
							"value":"Официальное наименование",
							"attrs":{"title":"Официальное наименование для накладной"},
							"columns":[
								new GridColumn({
									"field":model.getField("official_name"),
									"ctrlClass":EditString,
									"ctrlOptions":{
										"maxLength":200,
										"placeholder":"Наименование для накладной"
									}
								})
							]
						})
						
						,new GridCellHead(id+":grid:head:code_1c",{
							"value":"Код 1с",
							"columns":[
								new GridColumn({"field":model.getField("code_1c")})
							]
						})								
						,new GridCellHead(id+":grid:head:pres_norm",{
							"value":"Норма давл.",
							"columns":[
								new GridColumnFloat({"field":model.getField("pres_norm")})
							]
						})								
						,new GridCellHead(id+":grid:head:mpa_ratio",{
							"value":"Кф.МПА",
							"columns":[
								new GridColumnFloat({"field":model.getField("mpa_ratio")})
							]
						})
						,new GridCellHead(id+":grid:head:material_cons_rates",{
							"value":"Есть подборы",
							"colAttrs":{"align": "center"},
							"columns":[
								new GridColumnBool({
									"field":model.getField("material_cons_rates"),
									"showFalse": false
								})
							]
						})								

						,new GridCellHead(id+":grid:head:show_on_site",{
							"value":"Отображать на сайте",
							"colAttrs":{"align": "center"},
							"columns":[
								new GridColumnBool({
									"field":model.getField("show_on_site"),
									"showFalse": false
								})
							]
						})								
														
														
						,new GridCellHead(id+":grid:head:price",{
							"value":"Цена",
							"columns":[
								new GridColumnFloat({
									"field":model.getField("price"),
									"ctrlOptions":{
										"enabled":false
									}
								})
							]
						})								
						,new GridCellHead(id+":grid:head:prochnost",{
							"value":"Прочность",
							"colAttrs":{"align": "center"},
							"columns":[
								new GridColumn({
									"field":model.getField("prochnost"),
									"ctrlOptions":{
									}
								})
							]
						})								
						,new GridCellHead(id+":grid:head:f_val",{
							"value":"F",
							"colAttrs":{"align": "center"},
							"columns":[
								new GridColumn({
									"field":model.getField("f_val"),
									"ctrlOptions":{
										"ctrlClass":EditInt
									}
								})
							]
						})								
						,new GridCellHead(id+":grid:head:w_val",{
							"value":"W",
							"colAttrs":{"align": "center"},
							"columns":[
								new GridColumn({
									"field":model.getField("w_val"),
									"ctrlOptions":{
										"ctrlClass":EditInt
									}
								})
							]
						})								
						
					]
				})
			]
		}),
		"pagination":null,				
		"autoRefresh":false,
		"refreshInterval":null,
		"rowSelect":false,
		"focus":true
	}));	
	
}
extend(ConcreteTypeList_View,ViewAjxList);
