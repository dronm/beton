/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>,2024

 * @class
 * @classdesc
 
 * @requires core/extend.js  
 * @requires controls/GridCmd.js

 * @param {string} id Object identifier
 * @param {namespace} options
*/
function OrderGridCmdPrintTranspNakl(id,options){
	options = options || {};	

	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;
	
	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;	
	options.glyph = "glyphicon-print";
	options.title="Напечатать транспортную накладную";
	options.caption = " Транс.накл. ";

	// this.m_grid = options.grid;
	// this.m_btn = new PrintTranspNaklBtn(id+"btn",{ "cmd":true });
	// options.controls = [ this.m_btn ]
	
	OrderGridCmdPrintTranspNakl.superclass.constructor.call(this,id,options);
}
extend(OrderGridCmdPrintTranspNakl,GridCmd);

/* Constants */


/* private members */

/* protected*/

OrderGridCmdPrintTranspNakl.prototype.onCommandCont = function(model){
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
		"content":new View("naklSelect:view", {
			addElement: function(){
				const naklView = this;
				this.addElement(new EditSelect("naklSelect:view:nakl",{
					labelCaption: "УПД:",
					elements: nakls
				}));	
				this.addElement(new ButtonCmd("naklSelect:view:nakl:printSgn", {
					caption: "С подписями",
					onClick: function(){
						const ctrl = naklView.getElement("nakl");
						const opt = ctrl.getNode().options[ctrl.getIndex()];
						self.printWithSgn(opt.getAttribute("doc"), shipmentIds, naklView);
					}
				}));
				this.addElement(new ButtonCmd("naklSelect:view:nakl:printNoSgn", {
					caption: "Без подписей",
					onClick: function(){
						const ctrl = naklView.getElement("nakl");
						const opt = ctrl.getNode().options[ctrl.getIndex()];
						self.printNoSgn(opt.getAttribute("doc"), shipmentIds, naklView);
					}
				}))
			}
		})
	});
	this.m_form.open();
}

OrderGridCmdPrintTranspNakl.prototype.printWithSgn = function(doc, shipmentIds, naklView){
	this.print(doc, shipmentIds, "1", naklView);
}

OrderGridCmdPrintTranspNakl.prototype.printNoSgn = function(doc, shipmentIds, naklView){
	this.print(doc, shipmentIds, "0", naklView);
}

OrderGridCmdPrintTranspNakl.prototype.print = function(doc, shipmentIds, faksim, naklView){
	if(!doc){
		throw new Error("Документ не выбран");
	}

	window.setGlobalWait(true);
	naklView.getElement("printSgn").setEnabled(false);
	naklView.getElement("printNoSgn").setEnabled(false);

	const self =  this;
	const pm = (new Shipment_Controller()).getPublicMethod("shipment_transp_nakl_on_list");
	pm.setFieldValue("shipment_ids", shipmentIds);
	pm.setFieldValue("faksim", faksim);
	pm.setFieldValue("buh_doc", doc);
	pm.download("ViewXML", 0, function(res){
		window.setGlobalWait(false);
		naklView.getElement("printSgn").setEnabled(true);
		naklView.getElement("printNoSgn").setEnabled(true);

		if(res == 0){
			if(self.m_form){
				self.m_form.close();
			}
			window.showTempNote("Файл загружен", null, 5000);
		}
	});
}

//"shipment_transp_nakl"
//1) retrieve nakls from 1c for client && date
//2) show these nakls for selecting
//3) print selected nakl with marked orders && marked shipments
OrderGridCmdPrintTranspNakl.prototype.onCommand = function(e){
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
			if(table.id == "OrderForTranspNaklList:grid"){
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
	//make query to retrieve documents from 1c && show them
	// console.log(selectedOrders)
	// console.log(selectedShips)
	const pm = (new Order_Controller()).getPublicMethod("get_nakl_1c_list");
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
