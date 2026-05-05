/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>,2026

 * @class
 * @classdesc
 
 * @requires core/extend.js  
 * @requires controls/GridCmd.js

 * @param {string} id Object identifier
 * @param {namespace} options
*/
function OrderGridCmdShipmentToBuh(id,options){
	options = options || {};	

	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;
	
	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;	
	options.glyph = "glyphicon-";
	options.title="Напечатать транспортную накладную";
	options.caption = " Перенести в 1с ";

	// this.m_grid = options.grid;
	// this.m_btn = new PrintTranspNaklBtn(id+"btn",{ "cmd":true });
	// options.controls = [ this.m_btn ]
	
	OrderGridCmdShipmentToBuh.superclass.constructor.call(this,id,options);
}
extend(OrderGridCmdShipmentToBuh,GridCmd);

/* Constants */


/* private members */

/* protected*/

OrderGridCmdShipmentToBuh.prototype.onCommandCont = function(model){
	const nakls = [];
	const docs1c = JSON.parse(model.getFieldValue("docs"));
	const shipmentIds = model.getFieldValue("shipment_ids");
	docs1c.forEach((doc, ind) => {
		nakls.push(
			new EditSelectOption("naklSelect:view:nakl:"+doc.ref, {
				value: doc.ref,
				descr: "№ " + doc.nomer + " от " + doc.data + " , факт." + doc.faktura_nomer,
				checked: (ind == 0),
				attrs: {doc: JSON.stringify(doc)}
			})
		);
	});
	const self = this;
	this.m_form = new WindowFormModalBS("naklSelect",{
		"dialogWidth":"30%",
		"cmdOk":false,		
		"cmdCancel":true,
		"onClickCancel":function(){
			this.close();
		},
		"cmdClose":true,
		"content":new BuhDocDialog_View("BuhDocDialog:view")
	});
	this.m_form.open();
}

OrderGridCmdShipmentToBuh.prototype.onCommand = function(e){
	//get selected orders && shipments
	const selectNodes = DOMHelper.getElementsByAttr("selectMark", this.m_grid.getNode(), "class", false);
	if(!selectNodes || !selectNodes.length){
		return;
	}
	const selectedOrders = [];
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
			if(table.id == "OrderForBuhList:grid"){
				selectedOrders.push(id);
			}else{
				//shipment
				selectedShips.push(id);
			}
		}
	});

	if(!selectedOrders.length && !selectedShips.length){
		window.showTempError("Не выбраны заявки/отгрузки", null, 5000);
		return;
	}

	const pm = (new BuhDoc_Controller()).getPublicMethod("new_doc");
	pm.setFieldValue("shipment_ids", selectedShips.join(","));
	pm.setFieldValue("order_ids", selectedOrders.join(","));
	window.setGlobalWait(true);
	const self = this;
	pm.run({
		"ok": function(resp){
			const m = resp.getModel("ShipmentDoc_Model");
			if(!m.getNextRow()){
				throw new Error("УПД не найдена");
			}
			self.onCommandCont(m);
		},
		"all": function(){
			window.setGlobalWait(false);
		}
	});
}

/* public methods */

