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
function ExcelTemplateFieldMatchGrid(id,options){
	var model = new ExcelTemplateFieldMatch_Model({
		"sequences":{"id":0}
	});

	var cells = [
		new GridCellHead(id+":head:field",{
			"value":"Поле запроса",
			"columns":[
				new GridColumn({
					"field":model.getField("field"),
					"ctrlClass":EditString,
					"ctrlOptions":{
						"maxLength":100
					}					
				})
			]
		})
		,new GridCellHead(id+":head:cell",{
			"value":"Ячейка Excel",
			"columns":[
				new GridColumn({
					"field":model.getField("cell"),
					"ctrlClass":EditString,
					"ctrlOptions":{
						"maxLength":20
					}					
				})
			]
		})
		
	];

	options = {
		"model":model,
		"keyIds":["id"],
		"controller":new ExcelTemplateFieldMatch_Controller({"clientModel":model}),
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
	ExcelTemplateFieldMatchGrid.superclass.constructor.call(this,id,options);
}
extend(ExcelTemplateFieldMatchGrid,GridAjx);

/* Constants */


/* private members */

/* protected*/


/* public methods */
