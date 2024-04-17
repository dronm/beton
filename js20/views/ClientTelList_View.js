/** Copyright (c) 2019
 *	Andrey Mikhalevich, Katren ltd.
 */
function ClientTelList_View(id,options){	

	options = options || {};
	
//	options.HEAD_TITLE = "Контакты";
	ClientTelList_View.superclass.constructor.call(this,id,options);

	var model = (options.models && options.models.ClientTelList_Model)? options.models.ClientTelList_Model : new ClientTelList_Model();
	var contr = new ClientTel_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var pagination;
	var grid_columns = [];
	var filters;
	
	if (!options.detail){
		var pagClass = window.getApp().getPaginationClass();
		pagination = new pagClass(id+"_page",{"countPerPage":constants.doc_per_page_count.getValue()});	
		filters = {};
		filters.client = {
			"binding":new CommandBinding({
				"control":new ClientEdit(id+":filter-ctrl-client"),
				"field":new FieldInt("client_id")
			}),
			"sign":"e"
		};

		
		grid_columns.push(
			new GridCellHead(id+":grid:head:clients_ref",{
					"value":"Клиент",
					"columns":[
						new GridColumnRef({
							"field":model.getField("clients_ref"),
							"form":ClientDialog_Form,
							"ctrlClass":ClientEdit,
							"searchOptions":{
								"field":model.getField("client_id"),
								"searchType":"on_match",
								"typeChange":false
							}
							
						})
					]
				})	
		);
		
		grid_columns.push(
			new GridCellHead(id+":grid:head:search",{
					"value":"Контакт",
					"columns":[
						new GridColumn({
							"field":model.getField("search"),
							"ctrlClass":EditString,
							"searchOptions":{
								"field":model.getField("search"),
								//"searchType":"on_match",
								"typeChange":false
							}
							
						})
					],
					"sortable":true,
					"sort":"asc"														
				})	
		);		
		
	}
	else{
		grid_columns.push(
			new GridCellHead(id+":grid:head:tel",{
					"value":"Телефон",
					"columns":[
						new GridColumnPhone({
							"field":model.getField("tel")
						})
					]
				})	
		);

		grid_columns.push(
			new GridCellHead(id+":grid:head:name",{
					"value":"ФИО",
					"columns":[
						new GridColumn({
							"field":model.getField("name")
						})
					]
				})	
		);
	
	}	
	
	grid_columns.push(
		new GridCellHead(id+":grid:head:post",{
				"value":"Должность",
				"columns":[
					new GridColumn({
						"field":model.getField("post")
					})
				]
			})	
	);
	grid_columns.push(
		new GridCellHead(id+":grid:head:email",{
				"value":"Почта",
				"columns":[
					new GridColumn({
						"field":model.getField("email")
					})
				]
			})	
	);
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"keyIds":["id"],
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"filters":filters,
			"variantStorage":!options.detail? options.variantStorage : null,
			"cmdSearch":!options.detail,
			"addCustomCommandsAfter":function(commands){
				commands.push(new SendNotificationCmd(id+":grid:cmd:sendNotif",{
					"showCmdControl":true,
					"getNotifRef":function(model, callBack){
						callBack(new RefType({
							"keys": {"id": model.getFieldValue("id")},
							"descr":model.getFieldValue("search"),
							"dataType":"client_tels"
						}));
					}
				}));
			}		
			
		}),
		"popUpMenu":new PopUpMenu(),
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":grid_columns
				})
			]
		}),
		"pagination":pagination,				
		"autoRefresh":false,
		"refreshInterval":!options.detail? (constants.grid_refresh_interval.getValue()*1000) : 0,
		"rowSelect":false,
		"focus":true
	}));	
	
}
extend(ClientTelList_View,ViewAjxList);

