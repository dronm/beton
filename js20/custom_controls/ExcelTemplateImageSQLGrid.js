/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2021

 * @extends GridAjx
 * @requires core/extend.js  

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {Object} options
 * @param {string} options.className
 */
function ExcelTemplateImageSQLGrid(id,options){
	var model = new ExcelTemplateImageSQL_Model({
		"sequences":{"id":0}
	});

	var cells = [
		new GridCellHead(id+":head:name",{
			"value":"Ячейка картинки",
			"columns":[
				new GridColumn({
					"field":model.getField("name"),
					"ctrlClass":EditString,
					"ctrlOptions":{
						"maxLength":100
					}					
				})
			]
		})
		,new GridCellHead(id+":head:h",{
			"value":"Длина",
			"columns":[
				new GridColumn({
					"field":model.getField("h"),
					"ctrlClass":EditInt
				})
			]
		})
		,new GridCellHead(id+":head:w",{
			"value":"Ширина",
			"columns":[
				new GridColumn({
					"field":model.getField("w"),
					"ctrlClass":EditInt
				})
			]
		})
		,new GridCellHead(id+":head:sql_query",{
			"value":"Запрос SQL",
			"columns":[
				new GridColumn({
					"field":model.getField("sql_query"),
					"ctrlClass":EditString,
					"ctrlOptions":{
						"maxLength":5000
					}					
				})
			]
		})
		
		,new GridCellHead(id+":head:comment_text",{
			"value":"Описание",
			"columns":[
				new GridColumn({
					"field":model.getField("comment_text"),
					"ctrlClass":EditString,
					"ctrlOptions":{
						"maxLength":5000
					}					
				})
			]
		})
	];

	options = {
		"model":model,
		"keyIds":["id"],
		"controller":new ExcelTemplateImageSQL_Controller({"clientModel":model}),
		"editInline":true,
		"editWinClass":null,
		"popUpMenu":new PopUpMenu(),
		"commands":new GridCmdContainerAjx(id+":cmd",{
			"cmdSearch":false,
			"cmdExport":false
		}),
		"head":new GridHead(id+":head",{
			"elements":[
				new GridRow(id+":head:row0",{
					"elements":cells
				})
			]
		}),
		"pagination":null,				
		"autoRefresh":false,
		"refreshInterval":0,
		"rowSelect":true
	};	
	ExcelTemplateImageSQLGrid.superclass.constructor.call(this,id,options);
}
extend(ExcelTemplateImageSQLGrid, GridAjx);

/* Constants */


/* private members */

/* protected*/


/* public methods */

