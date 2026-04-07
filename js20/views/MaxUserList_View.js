/** Copyright (c) 2026
 *	Andrey Mikhalevich, Katren ltd.
 */
function MaxUserList_View(id,options){	

	options.HEAD_TITLE = "Соответствие пользователей в MAX";

	MaxUserList_View.superclass.constructor.call(this,id,options);

	var model = (options.models&&options.models.MaxUserList_Model)
		? options.models.MaxUserList_Model : new MaxUserList_Model();
	var contr = new MaxUser_Controller();
	
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
						,new GridCellHead(id+":grid:head:max_user_id",{
							"value":"ИД MAX",
							"columns":[
								new GridColumn({
									"field":model.getField("max_user_id"),
									"ctrlOptions":{
										"enabled":false,
										"labelCaption":""
									},
									"ctrlEdit":false
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:username",{
							"value":"Имя в MAX",
							"columns":[
								new GridColumn({
									"field":model.getField("username"),
									"ctrlOptions":{
										"enabled":false,
										"labelCaption":""
									},
									"ctrlEdit":false,
									"formatFunction":(function(self){
										return function(f, cell){
											var cell_n = cell.getNode();										
											var photo_url = f.avatar_url.getValue();
											if(photo_url){
												var i = document.createElement("img");
												i.setAttribute("src", photo_url);
												i.className = "userPhoto";
												cell_n.appendChild(i);

												(new ToolTip({
													"node": cell_n,
													"wait":500,
													"onHover":(function(grid, photoUrl){
														return function(event){
															self.showPhoto(this, photoUrl);
														}
													})(self, photo_url)
												}));
											}
											var nm = f.username.getValue();	
											var t = document.createElement("span");										
											DOMHelper.setText(t, ((nm && nm.length)? nm:""));
											cell_n.appendChild(t);
											
										}
									})(self)
								})
							],
							"sortable":true
						})
						
						,new GridCellHead(id+":grid:head:contacts_ref",{
							"value":"Контакт",
							"columns":[
								new GridColumnRef({
									"field":model.getField("contacts_ref"),
									"ctrlBindFieldId":"contact_id",
									"ctrlClass":ContactEdit,
									"ctrlOptions":{
										"labelCaption":""
									}
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:contacts_tel",{
							"value":"Телефон",
							"columns":[
								new GridColumnPhone({
									"field":model.getField("contacts_tel"),
									"ctrlEdit":false,
									"ctrlClass":EditPhone,
									"ctrlOptions":{
										"labelCaption":""
									}
								})
							],
							"sortable":true
						})
						
						,new GridCellHead(id+":grid:head:updated_at",{
							"value":"Дата обновления",
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("updated_at"),
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
extend(MaxUserList_View, ViewAjxList);

MaxUserList_View.prototype.showPhoto = function(ctrl, photoUrl){
	ctrl.popup(
		'<div><img src="'+photoUrl+'"/></div>',
		{"title":"Данные по контакту"}
	);
}

