/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2024

 * @extends GridAjx
 * @requires core/extend.js
 * @requires GridAjx.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {Object} options
 */
function InsuranceListGrid(id,options){
	var model = new InsuranceList_Model({
		"sequences":{"id":0}
	});

	var cells = [
		new GridCellHead(id+":head:issuer",{
			"value":"Страховщик",
			"columns":[
				new GridColumn({
					"field":model.getField("issuer"),
					"ctrlClass":InsuranceIssuerEdit,
					"ctrlOptions":{
						"labelCaption":""
					}
				})
			]
		})
		,new GridCellHead(id+":head:total",{
			"value":"Сумма",
			"columns":[
				new GridColumnFloat({
					"field":model.getField("total"),
					"precision":"2",
					"length":"15"
				})
			]
		})
		,new GridCellHead(id+":head:dt_from",{
			"value":"Дата с",
			"columns":[
				new GridColumnDate({
					"field":model.getField("dt_from")
				})
			]
		})
		,new GridCellHead(id+":head:dt_to",{
			"value":"Дата по",
			"columns":[
				new GridColumnDate({
					"field":model.getField("dt_to")
				})
			]
		})
	];

	options = {
		"model":model,
		"keyIds":["id"],
		"controller":new InsuranceList_Controller({"clientModel":model}),
		"editInline":true,
		"editWinClass":null,
		"popUpMenu":new PopUpMenu(),
		"commands":new GridCmdContainerAjx(id+":cmd",{
			"cmdSearch":false,
			"cmdExport":false,
			"cmdInsert":true,
			"cmdEdit":true,
			"cmdDelete":true,
			"cmdAllCommands":false
		}),
		"readOnly":true,
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
	InsuranceListGrid.superclass.constructor.call(this,id,options);
}
extend(InsuranceListGrid,GridAjx);

/* Constants */


/* private members */

/* protected*/


/* public methods */

