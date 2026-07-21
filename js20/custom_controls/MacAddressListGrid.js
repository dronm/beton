/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2026

 * @extends GridAjx
 * @requires core/extend.js
 * @requires GridAjx.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {Object} options
 */
function MacAddressListGrid(id,options){
	var model = new MacAddressList_Model({
		"sequences":{"id":0}
	});


	const cells = [
		new GridCellHead(id+":head:mac_address",{
			"value":"Мак адрес",
			"columns":[
				new GridColumn({
					"field":model.getField("mac_address"),
					"ctrlClass":EditString,
					"ctrlOptions":{
						"maxLength":"17",
						"placeholder":"A0-B1-C2-D4-E5-F6",
						"regExpression":/^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/,
						"formatterOptions":{
							"delimiter": "-",
							"blocks": [2, 2, 2, 2, 2, 2],
							"uppercase": true										
						}
					}
				})
			]
		})
	];

	options = {
		"model":model,
		"keyIds":["id"],
		"controller":new MacAddressList_Controller({"clientModel":model}),
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
	MacAddressListGrid.superclass.constructor.call(this,id,options);

}
extend(MacAddressListGrid,GridAjx);

/* Constants */


/* private members */

/* protected*/


