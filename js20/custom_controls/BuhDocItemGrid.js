/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2026

 * @extends GridAjx
 * @requires core/extend.js  

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {Object} options
 * @param {string} options.className
 */
function BuhDocItemGrid(id,options){
	var model = new BuhDocItem_Model({
		simpleStructure: true
	});

	const self = this;
	var cells = [
		new GridCellHead(id+":head:alias",{
			"value":"Номенклатура",
			"columns":[
				new GridColumn({
					"field":model.getField("alias"),
					"ctrlClass":Item1cEdit
				})
			]
		})
		,new GridCellHead(id+":head:quant",{
			"value":"Кол-во",
			"columns":[
				new GridColumnFloat({
					"field":model.getField("quant"),
					"precision": "5",
					"length": "19"
					//calculate total
				})
			]
		})
		,new GridCellHead(id+":head:price",{
			"value":"Цена",
			"columns":[
				new GridColumnFloat({
					"field":model.getField("price"),
					"precision": "2",
					"length": "15"
					//calculate total
				})
			]
		})
		,new GridCellHead(id+":head:total",{
			"value":"Сумма",
			"columns":[
				new GridColumnFloat({
					"field":model.getField("total"),
					"precision": "2",
					"length": "15"
				})
			]
		})
	];

	options = {
		"model":model,
		"keyIds":["col"],
		"controller":new BuhDocItem_Controller({"clientModel":model}),
		"readOnly": true,
		"editInline":true,
		"editWinClass":null,
		// "popUpMenu":new PopUpMenu(),
		// "commands":new GridCmdContainerAjx(id+":cmd",{
		// 	"cmdSearch":false,
		// 	"cmdExport":false
		// }),
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
	BuhDocItemGrid.superclass.constructor.call(this,id,options);
}
extend(BuhDocItemGrid, GridAjx);

/* Constants */


/* private members */

/* protected*/


/* public methods */

