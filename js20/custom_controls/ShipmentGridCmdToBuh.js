/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>,2026

 * @class
 * @classdesc
 
 * @requires core/extend.js  
 * @requires controls/GridCmd.js

 * @param {string} id Object identifier
 * @param {namespace} options
*/
function ShipmentGridCmdToBuh(id,options){
	options = options || {};	

	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;	
	options.caption = " Экспорт в бухгалтерию ";
	options.glyph = "glyphicon-transfer";
	options.title = "Экспорт документов в бухгалтерию";

	ShipmentGridCmdToBuh.superclass.constructor.call(this,id,options);
}
extend(ShipmentGridCmdToBuh, GridCmd);

/* Constants */


/* private members */

/* protected*/

ShipmentGridCmdToBuh.prototype.onCommand = function(e){
	//get selected orders && shipments
	const selectNodes = DOMHelper.getElementsByAttr("selectMark", this.m_grid.getNode(), "class", false);
	if(!selectNodes || !selectNodes.length){
		return;
	}
	const selectedShips = [];

	selectNodes.forEach((inpNode) => {
		if(inpNode.checked === true){
			//get select type
			const table = DOMHelper.getParentByTagName(inpNode, "TABLE");
			const tr = DOMHelper.getParentByTagName(inpNode, "TR");
			if(!table || !tr){
				return;
			}
			const keys = tr.getAttribute("keys");
			if(!keys || !keys.length){
				return;
			}
			const id = JSON.parse(keys).id;
			selectedShips.push(id);
		}
	});

	if(!selectedShips.length){
		window.showTempError("Не выбраны отгрузки", null, 5000);
		return;
	}

	const pm = (new Connect1c_Controller()).getPublicMethod("export_shipments");
	pm.setFieldValue("ids", selectedShips.join(","));
	window.setGlobalWait(true);
	const self = this;
	pm.run({
		"ok": function(resp){
			self.onRefresh(function(){
				window.showTempNote("Документы отправлены в 1с", null, 5000);
			});
		},
		"all": function(){
			window.setGlobalWait(false);
		}
	});
}
