/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2025

 * @extends GridAjx
 * @requires core/extend.js  

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {Object} options
 * @param {string} options.className
 */
function AuditLogChangeGrid(id,options){
	var model = new AuditLogChange_Model({
		simpleStructure: true
	});

	const self = this;
	var cells = [
		new GridCellHead(id+":head:alias",{
			"value":"Поле",
			"columns":[
				new GridColumn({
					"field":model.getField("alias"),
					"ctrlClass":EditString
				})
			]
		})
		//show only for changed operations U/D not I
		,new GridCellHead(id+":head:old",{
			"value":"Было",
			"columns":[
				new GridColumn({
					"field":model.getField("old"),
					"formatFunction": function(f, cell) {
						return self.fieldDescr(f.old.getValue(), f.old_descr.getValue()); 
					}
				})
			]
		})
		,new GridCellHead(id+":head:new",{
			"value":"Стало",
			"columns":[
				new GridColumn({
					"field":model.getField("new"),
					"formatFunction": function(f, cell) {
						return self.fieldDescr(f.new.getValue(), f.new_descr.getValue()); 
					}
				})
			]
		})
	];

	options = {
		"model":model,
		"keyIds":["col"],
		"controller":new AuditLogChange_Controller({"clientModel":model}),
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
	AuditLogChangeGrid.superclass.constructor.call(this,id,options);
}
extend(AuditLogChangeGrid, GridAjx);

/* Constants */


/* private members */

/* protected*/


/* public methods */

AuditLogChangeGrid.prototype.fieldDescr = function(descr, objDescr){
	if(objDescr != undefined && objDescr.length){
		//object field
		return `${objDescr} (ИД:${descr})`;
	}
	if(descr == undefined){
		return "";
	}
	//typing
	if (descr === "false" || descr === false){
		return "Нет";
	}else if (descr === "true" || descr === true){
		return "Да";
	} else if(isValidStrictDateFormat(descr)){
		return DateHelper.format(new Date(descr), "d/m/y H:i:s");
	}
	return descr;
}

function isValidStrictDateFormat(str) {
    // First check the format
    const formatPattern = /^\d{4}-\d{2}-\d{2}(T\d{2}:\d{2}:\d{2}(\.\d{1,6})?)?$/;
    
    if (!formatPattern.test(str)) return false;
    
    // Try to parse the date to ensure it's a valid date
    const date = new Date(str);
    return !isNaN(date.getTime());
}
