/** Copyright (c) 2019
	Andrey Mikhalevich, Katren ltd.
*/
function SupplierList_View(id,options){	

	SupplierList_View.superclass.constructor.call(this,id,options);

	var model = options.models.SupplierList_Model;
	var contr = new Supplier_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	var self = this;
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":false,
		"editWinClass":SupplierDialog_Form,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"addCustomCommandsAfter":function(commands){
				commands.push(new SendNotificationCmd(id+":grid:cmd:sendNotif",{
					"showCmdControl":true,
					"entityType": "suppliers",
					"getEntityId": function(){
						return model.getFieldValue("id");
					}
				}));
			}		
		}),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:name",{
							"value":"Наименование",
							"columns":[
								new GridColumn({
									"field":model.getField("name")
								})
							],
							"sortable":true,
							"sort":"asc"														
						})
						/*,new GridCellHead(id+":grid:head:tel",{
							"value":"Телефон",
							"columns":[
								new GridColumnPhone({
									"field":model.getField("tel")
									})
							]
						})						
						,new GridCellHead(id+":grid:head:tel2",{
							"value":"Телефон2",
							"columns":[
								new GridColumnPhone({"field":model.getField("tel2")})
							]
						})						
						*/
						,new GridCellHead(id+":grid:head:contact_ids",{
							"value":"Контакты",
							"columns":[
								new GridColumn({
									"field":model.getField("contact_ids"),
									"formatFunction": function(f,cell){
										window.getApp().formatContactList(f,cell);
										return "";
									},
									"ctrlClass":ContactEdit,
									"searchOptions":{
										"searchType":"on_match",
										"typeChange":false,
										"condSign":"any"
									}
								})
							]
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
extend(SupplierList_View,ViewAjxList);
