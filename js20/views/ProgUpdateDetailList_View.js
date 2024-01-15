/** Copyright (c) 2023
 *	Andrey Mikhalevich, Katren ltd.
 *
 *	Только для детального просмотра с фильтром по шапке!
 */
function ProgUpdateDetailList_View(id,options){	

	options = options || {};
	//options.HEAD_TITLE = "";
	this.m_view = options.view;

	ProgUpdateDetailList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.ProgUpdateDetail_Model)? options.models.ProgUpdateDetail_Model : new ProgUpdateDetail_Model();
	var contr = new ProgUpdateDetail_Controller();
	
	var popup_menu = new PopUpMenu();

	var self = this;
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
		}),		
		"popUpMenu":popup_menu,
		"filters":(options.detailFilters&&options.detailFilters.ProgUpdateDetail_Model)? options.detailFilters.ProgUpdateDetail_Model:null,	
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:code",{
							"value":"Код",
							"columns":[
								new GridColumn({
									"field":model.getField("code")
								})
							]
						})
					
						,new GridCellHead(id+":grid:head:description",{
							"value":"Описание",
							"columns":[
								new GridColumn({
									"field":model.getField("description"),
									"ctrlClass":EditText
								})
							]
						})
						,new GridCellHead(id+":grid:head:description_tech",{
							"value":"Описание техн.",
							"columns":[
								new GridColumn({
									"field":model.getField("description_tech"),
									"ctrlClass":EditText
								})
							]
						})
					]
				})				
			]
		}),
		"pagination": null,				
		"autoRefresh":options.detailFilters? true:false,
		"refreshInterval":null,
		"rowSelect":false,
		"focus":true,
		"srvEvents": null
	}));	
}
extend(ProgUpdateDetailList_View,ViewAjxList);

