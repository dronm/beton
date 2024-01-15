/** Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function TmUserPhotoList_View(id,options){	

	options.HEAD_TITLE = "Соответствие пользователей в Telegram";

	TmUserPhotoList_View.superclass.constructor.call(this,id,options);

	var model = (options.models&&options.models.TmUserPhotoList_Model)? options.models.TmUserPhotoList_Model : new TmUserPhotoList_Model();
	var contr = new TmUser_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var self = this;
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdInsert":false,
			"cmdEdit":true,
			"cmdDelete":true
		}),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:id",{
							"value":"ИД",
							"columns":[
								new GridColumn({
									"field":model.getField("id"),
									"ctrlOptions":{
										"enabled":false,
										"labelCaption":""
									}
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:tm_id",{
							"value":"ИД Telegram",
							"columns":[
								new GridColumn({
									"field":model.getField("tm_id"),
									"ctrlOptions":{
										"enabled":false,
										"labelCaption":""
									},
									"ctrlEdit":false
									/*"formtFucntion":function(f){
										var v = f.tm_id.geValue();
										if (v){
											return v;
										}else{
											return "";
										}
									}*/
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:tm_first_name",{
							"value":"Имя в Telegram",
							"columns":[
								new GridColumn({
									"field":model.getField("tm_first_name"),
									"ctrlOptions":{
										"enabled":false,
										"labelCaption":""
									},
									"ctrlEdit":false,
									"formatFunction":function(f, cell){
										var cell_n = cell.getNode();										
										var ft = f.tm_photo.getValue();
										if(ft){
											var i = document.createElement("img");
											i.setAttribute("src", "data:image/png;base64, "+ft);
											i.className = "userPhoto";
											cell_n.appendChild(i);
											if(self.photoDetail){
												delete self.photoDetail;
											}											
											self.photoDetail = new ToolTip({
												"node": cell_n,
												"wait":2,
												"onHover":(function(grid, id){
													return function(event){
														if(!grid.photoDetailData){
															grid.photoDetailData = [];
														}
														if(!grid.photoDetailData[id]){
															var pm = (new TmUser_Controller()).getPublicMethod("get_object");
															pm.setFieldValue("id", id);
															var ctrl = this;
															pm.run({
																"ok":function(resp){
																	var m = resp.getModel("TmUserDialog_Model");
																	if(m.getNextRow()){
																		self.photoDetailData[id] = m.getFieldValue("tm_photo");
																		self.showPhoto(ctrl, self.photoDetailData[id]);
																	}
																}																
															});
														}else{
															self.showPhoto(this, self.photoDetailData[id]);
														}													
													}
												})(self, f.id.getValue())
											});
										}
										var nm = f.tm_first_name.getValue();	
										var t = document.createElement("span");										
										DOMHelper.setText(t, ((nm && nm.length)? nm:""));
										cell_n.appendChild(t);
										
									}
								})
							],
							"sortable":true
						})
						
						,new GridCellHead(id+":grid:head:ext_contacts_ref",{
							"value":"Контакт",
							"columns":[
								new GridColumnRef({
									"field":model.getField("ext_contacts_ref"),
									"ctrlBindFieldId":"ext_contact_id",
									"ctrlClass":ContactEdit,
									"ctrlOptions":{
										"labelCaption":""
									}
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:ext_contacts_tel",{
							"value":"Телефон",
							"columns":[
								new GridColumnPhone({
									"field":model.getField("ext_contacts_tel"),
									"ctrlEdit":false,
									"ctrlClass":EditPhone,
									"ctrlOptions":{
										"labelCaption":""
									}
								})
							],
							"sortable":true
						})
						
						,new GridCellHead(id+":grid:head:date_time",{
							"value":"Дата создания",
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("date_time"),
									"ctrlEdit":false
								})
							],
							"sortable":true,
							"sort":"desc"
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
extend(TmUserPhotoList_View,ViewAjxList);

TmUserPhotoList_View.prototype.showPhoto = function(ctrl, base64Data){
	ctrl.popup(
		'<div><img src="data:image/png;base64, '+base64Data+'"/></div>',
		{"title":"Данные по контакту"}
	);
}
