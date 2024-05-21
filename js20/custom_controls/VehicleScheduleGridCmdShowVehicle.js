
/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>,2024

 * @class
 * @classdesc
 
 * @requires core/extend.js  
 * @requires controls/GridCmd.js

 * @param {string} id Object identifier
 * @param {namespace} options
*/
function VehicleScheduleGridCmdShowVehicle(id,options){
	options = options || {};	

	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;
	options.glyph = "glyphicon-pencil";
	options.title="Открыть карточку ТС";
	options.caption = "Карточка ТС";
	
	VehicleScheduleGridCmdShowVehicle.superclass.constructor.call(this,id,options);
		
}
extend(VehicleScheduleGridCmdShowVehicle,GridCmd);

/* Constants */


/* private members */

/* protected*/


/* public methods */
VehicleScheduleGridCmdShowVehicle.prototype.onCommand = function(){
	this.m_grid.setModelToCurrentRow();
	let model = this.m_grid.getModel();
	let v_ref = model.getFieldValue("vehicles_ref");
	if(!v_ref || v_ref.isNull()){
		throw new Error("vehicle ref not defined.");
	}
	let veh_id = v_ref.getKey();
	(new VehicleDialog_Form({"keys":{"id": veh_id}})).open();
}

