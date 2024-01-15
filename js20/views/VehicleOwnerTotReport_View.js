/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2019

 * @extends ViewAjxList
 * @requires core/extend.js
 * @requires controls/ViewAjxList.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function VehicleOwnerTotReport_View(id,options){
	options = options || {};	
	
	var role_id = window.getApp().getServVar("role_id");
	
	var self = this;
	var vehicle_owner, vehicle_owner_id = 0;
	if(role_id!="vehicle_owner"){
		var vals = this.getSavedValues();
		if(vals && vals.vehicle_owner){
			vehicle_owner = vals.vehicle_owner;
			vehicle_owner_id = vehicle_owner.getKey("id");
		}
	}
	options.addElement = function(){
		if(role_id!="vehicle_owner"){
			this.addElement(new VehicleOwnerEdit(id+":vehicle_owner",{
				"onSelect":function(f){
					self.makeReport(self.getElement("period").getDateFrom(), f.id.getValue());
				},
				"value":vehicle_owner,
				"focus":true
			}));
		}
	
		this.addElement(new EditPeriodMonth(id+":period",{
			"onChange":function(dFrom,dTo){
				var vehicle_owner_ctrl = self.getElement("vehicle_owner");
				var vehicle_owner_id = 0;
				if(vehicle_owner_ctrl){
					var vehicle_owner_ref = vehicle_owner_ctrl.getValue();
					if(vehicle_owner_ref && !vehicle_owner_ref.isNull()){
						vehicle_owner_id = vehicle_owner_ref.getKey("id");
					}
				}
				self.makeReport(dFrom, vehicle_owner_id);
			}
		}));
		this.addElement(new Control(id+":report","DIV",{
		}));
		
	}
	
	VehicleOwnerTotReport_View.superclass.constructor.call(this,id,options);
	
	this.makeReport(this.getElement("period").getDateFrom(), vehicle_owner_id);
}
//ViewObjectAjx,ViewAjxList
extend(VehicleOwnerTotReport_View,ViewAjxList);

/* Constants */


/* private members */

/* protected*/


/* public methods */
VehicleOwnerTotReport_View.prototype.getSavedValues = function(){
	var res = {"vehicle_owner": null};
	if(window["localStorage"]){
		res.vehicle_owner = CommonHelper.unserialize(localStorage.getItem('VehicleOwnerTotReport_vehicle_owner'));
	}
	return res;
}

VehicleOwnerTotReport_View.prototype.saveValues = function(){
	if(window["localStorage"]){
		var vehicle_owner_ctrl = this.getElement("vehicle_owner");
		if(vehicle_owner_ctrl){
			localStorage.setItem('VehicleOwnerTotReport_vehicle_owner', CommonHelper.serialize(vehicle_owner_ctrl.getValue()));
		}
	}
}

VehicleOwnerTotReport_View.prototype.makeReport = function(d, vehicleOwnerId){
	this.saveValues();
	window.setGlobalWait(true);
	var pm = (new VehicleOwner_Controller()).getPublicMethod("get_tot_report");
	pm.setFieldValue("date",d);
	pm.setFieldValue("vehicle_owner_id",vehicleOwnerId);
	pm.setFieldValue("templ","VehicleOwnerTotReport");
	var self = this;
	pm.run({
		"viewId":"ViewXSLT",
		"retContentType":"text",
		"ok":function(resp){
			self.getElement("report").getNode().innerHTML = resp;
		},
		"all":function(){
			window.setGlobalWait(false);
		}
	});
}
