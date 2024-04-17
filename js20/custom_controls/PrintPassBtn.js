/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2024

 * @extends Button
 * @requires core/extend.js
 * @requires controls/Button.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function PrintPassBtn(id,options){
	options = options || {};	
		
	if(options.cmd){
		options.colorClass = "bg-"+window.getApp().getColorClass();//"bg-blue-400";
		options.className = "btn "+options.colorClass+" btn-cmd";
		options.caption = " Паспорт ";
	}
	else{
		options.className = "btn btn-default";
	}

	options.glyph = "glyphicon-print";
	options.caption = "Паспорт";
	options.title = "Печать паспорта качества";

	var self = this;
	options.onClick = function(e){
		self.onClick(e);
	}
	
	this.m_cmd = options.cmd;
	this.m_dialogView = options.dialogView;
	this.m_closeAfterPrint = options.closeAfterPrint;
	
	PrintPassBtn.superclass.constructor.call(this,id,options);
}
//ViewObjectAjx,ViewAjxList
extend(PrintPassBtn, ButtonCmd);

/* Constants */


/* private members */

/* protected*/
PrintPassBtn.prototype.m_grid;

/* public methods */
PrintPassBtn.prototype.onClick = function(e){
	var self = this;
	var p = new PopUpMenu({
		"elements":[
			new Button(this.getId()+":stamp_ship", {
				"caption":"На одну отгрузку с печатью",
				"onClick":function(){
					self.onCommandCont("get_passport_stamp_ship");
				}
			})
			,new Button(this.getId()+":stamp_order", {
				"caption":"На все отгрузки с печатью",
				"onClick":function(){
					self.onCommandCont("get_passport_stamp_all");
				}
			})
			,new Button(this.getId()+":ship", {
				"caption":"На одну отгрузку без печати",
				"onClick":function(){
					self.onCommandCont("get_passport_ship");
				}
			})
			,new Button(this.getId()+":order", {
				"caption":"На все отгрузки без печати",
				"onClick":function(){
					self.onCommandCont("get_passport_all");
				}
			})
		],
		"caption":"Печать паспорта"
	});
	var btn = DOMHelper.getParentByAttrValue(e.target, "name", "printPass");
	if(!btn){
		throw new Error("parent button not found");
	}
	p.show(e, btn);
}

PrintPassBtn.prototype.onPrint = function(pmId, shipment_id){
	var pm = (new Shipment_Controller()).getPublicMethod(pmId);
	var offset = 0;
	pm.setFieldValue("id", shipment_id);	
	var h = $( window ).width()/3*2;
	var left = $( window ).width()/2;
	var w = left - 20;
	pm.openHref("ViewPDF","location=0,menubar=0,status=0,titlebar=0,top="+(50+offset)+",left="+(left+offset)+",width="+w+",height="+h);			
	
	if(this.m_closeAfterPrint && this.m_dialogView){
		this.m_dialogView.close();
	}
}

PrintPassBtn.prototype.onCommandCont = function(pmId){
	var self = this;
	
	var shipment_id;
	if(this.m_grid){
		this.m_grid.setModelToCurrentRow();
		shipment_id = this.m_grid.getModel().getFieldValue("id");		
		
	}else if(this.m_dialogView){
		shipment_id = this.m_dialogView.getModel().getFieldValue("shipment_id");
		
	}else{
		throw new Error("shipment_id not defind");
	}
	
	if (this.m_dialogView.getCmd() == "insert" || this.m_dialogView.getModified()){
		this.m_dialogView.getControlOK().setEnabled(false);
		this.m_dialogView.getControlSave().setEnabled(false);				
		this.m_dialogView.onSave(
			function(){
				self.onPrint(pmId, shipment_id);
			},
			null,
			function(){
				self.m_dialogView.getControlOK().setEnabled(true);
				self.m_dialogView.getControlSave().setEnabled(true);				
			}
		);			
	}else{
		this.onPrint(pmId, shipment_id);
	}
}

