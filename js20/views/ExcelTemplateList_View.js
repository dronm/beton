/** Copyright (c) 2021
 *	Andrey Mikhalevich, Katren ltd.
 */
function ExcelTemplateList_View(id,options){	

	options.templateOptions = options.templateOptions || {};
	options.templateOptions.HEAD_TITLE = "Шаблоны Excel";

	ExcelTemplateList_View.superclass.constructor.call(this,id,options);
	
	var model = options.models.ExcelTemplateList_Model;
	var contr = new ExcelTemplate_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	this.addElement(new GridAjx(id+":grid",{
		"keyIds":["id"],
		"model":model,
		"controller":contr,
		"editInline":false,
		"editWinClass":ExcelTemplateDialog_Form,
		"commands":new GridCmdContainerAjx(id+":grid:cmd"),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:name",{
							"value":"Наименование",
							"columns":[
								new GridColumn({"field":model.getField("name")})
							],
							"sortable":true,
							"sort":"asc"							
						}),
						new GridCellHead(id+":grid:head:file_info",{
							"value":"Файл",
							"columns":[
								new GridColumn({
									"file_info":model.getField("file_info"),
									"formatFunction":function(fields){
										var res = "";
										if(fields&&fields.file_info&&fields.file_info["name"]){
											res = fields.file_info["name"];
											if(fields.file_info["size"]){
												var sz = CommonHelper.byteForamt(fields.file_info["size"], 2);
												res += " ("+sz+")";
											}
										}
										return res;
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
extend(ExcelTemplateList_View,ViewAjxList);
