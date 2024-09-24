/** Copyright (c) 2019
 *	Andrey Mikhalevich, Katren ltd.
 */

// import {PopUpMenu} from '../controls/PopUpMenu.js';

function ClientList_View(id,options){	

	options.addElement = function(){
		var model = options.models.ClientList_Model;
		var contr = new Client_Controller();
		
		var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
		window.getApp().getConstantManager().get(constants);
		
		var popup_menu = new PopUpMenu();
		var pagClass = window.getApp().getPaginationClass();
		//GridAjxScroll
		this.addElement(new GridAjx(id+":grid",{
			"model":model,
			"controller":contr,
			"editInline":false,
			"editWinClass":Client_Form,		
			"commands":new GridCmdContainerAjx(id+":grid:cmd",{
				"addCustomCommandsAfter":function(commands){
					commands.push(new SendNotificationCmd(id+":grid:cmd:sendNotif",{
						"showCmdControl":true,
						"entityType": "clients",
						"getEntityId": function(){
							return model.getFieldValue("id");
						}
					}));
				}		
			
			}),
			"onEventSetCellOptions": function(opts){
				var m = this.getModel();
				if(opts.gridColumn.getId() == "name"){
					opts.attrs = opts.attrs || {};
					opts.attrs.class = opts.attrs.class || "";
					if(m.getFieldValue("ref_1c_exists")){
						opts.attrs.class+= ((opts.attrs.class=="")? "":" ") + "ref_1c_exists";
						opts.attrs.title = "Контрагент связан с 1с";
					}					
				}
			},
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
								]
								// "sortable":true,
								// "sort":"asc"
							})
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
							// ,new GridCellHead(id+":grid:head:quant",{
							// 	"value":"Объем",
							// 	"columns":[
							// 		new GridColumn({"field":model.getField("quant")})
							// 	]
							// })						
							,new GridCellHead(id+":grid:head:client_types_ref",{
								"value":"Вид клиента",
								"columns":[
									new GridColumnRef({
										"field":model.getField("client_types_ref"),
										"ctrlClass":ClientTypeEdit,
										"searchOptions":{
											"field":new FieldInt("client_type_id"),
											"searchType":"on_match"
										}									
									})
								]
							})						
							,new GridCellHead(id+":grid:head:client_come_from_ref",{
								"value":"Источник обращения",
								"columns":[
									new GridColumnRef({
										"field":model.getField("client_come_from_ref"),
										"ctrlClass":ClientComeFromEdit,
										"searchOptions":{
											"field":new FieldInt("client_come_from_id"),
											"searchType":"on_match"
										}																		
									})
								]
							})						
							
							,new GridCellHead(id+":grid:head:first_call_date",{
								"value":"Первый звонок",
								"columns":[
									new GridColumnDate({"field":model.getField("first_call_date")})
								]
							})						

							,new GridCellHead(id+":grid:head:inn",{
								"value":"ИНН",
								"columns":[
									new GridColumn({
										"field":model.getField("inn")
									})
								]
								// "sortable":true
							})						
							
						]
					})
				]
			}),
			"pagination":new pagClass(id+"_page",{"countPerPage":constants.doc_per_page_count.getValue()}),				
			"autoRefresh":false,
			"refreshInterval":constants.grid_refresh_interval.getValue()*1000,
			"rowSelect":false,
			"focus":true
		}));	
	}
		
	ClientList_View.superclass.constructor.call(this,id,options);
}
extend(ClientList_View,ViewAjxList);

/*
ClientList_View.prototype.formatContactList = function(f, cell){
	var contact_list = f.contact_list.getValue();
	if(!contact_list || !contact_list.length){
		return;
	}
	var cell_n = cell.getNode();
	var ul_tag = document.createElement("ul");
	
	for(var i = 0; i< contact_list.length; i++){
		var tel = contact_list[i].tel;
		var tel_m = tel;
		if(tel_m && tel_m.length==10){
			tel_m = "+7"+tel;
		}
		else if(tel_m && tel_m.length==11){
			tel_m = "+7"+tel.substr(1);
		}
		var li_tag = document.createElement("li");
		li_tag.textContent = contact_list[i]["name"];
		if(contact_list[i]["email"]){
			li_tag.textContent+= ", "+contact_list[i]["email"];
		}
		if(contact_list[i]["post"]){
			li_tag.textContent+= ", "+contact_list[i]["post"];
		}		
		
		if(tel_m && tel_m.length){
			li_tag.textContent+= ", ";
			var t_tag = document.createElement("A");
			t_tag.setAttribute("href","tel:"+tel_m);
			t_tag.textContent = CommonHelper.maskFormat(tel, window.getApp().getPhoneEditMask());
			li_tag.appendChild(t_tag);
		}
		
		ul_tag.appendChild(li_tag);
	}	
	
	cell_n.appendChild(ul_tag);
}
*/
/* OLD functon
ClientList_View.prototype.sendNotification = function(model, callBack){	
	var pm = (new ClientTel_Controller()).getPublicMethod("get_list");
	pm.setFieldValue("cond_fields", "client_id");
	pm.setFieldValue("cond_vals", model.getFieldValue("id"));
	pm.setFieldValue("cond_sgns", "e");
	pm.run({
		"ok":function(resp){
			var m = resp.getModel("ClientTelList_Model");
			if(m){
				var el = [];
				while(m.getNextRow()){
					var descr = m.getFieldValue("search");
					var id = m.getFieldValue("id");
					el.push({"id":CommonHelper.uniqid(),
						"onClick":(function(id, descr, callBack){
							return function(){
								callBack(new RefType({
									"dataType": "client_tels",
									"descr": descr,
									"keys":{"id": id}
								}));
							}
						})(id, descr, callBack),
						"caption":descr,
						"glyph": (m.getFieldValue("tm_exists"))? "glyphicon-send":""
					});
				}
				if(el.length >1){
					var row_n = self.getElement("grid").getSelectedRow();
					(new PopUpMenu({
						"elements":el
					})).show(null, row_n);
					
				}else if(el.length == 1 ){
					el[0].onClick();
				}										
			}
		}
	});
}
*/
