/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>,2019

 * @class
 * @classdesc
 
 * @requires core/extend.js  
 * @requires controls/GridCmd.js

 * @param {string} id Object identifier
 * @param {namespace} options
*/
function VehicleScheduleGridCmdShowPosition(id,options){
	options = options || {};	

	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;
	options.glyph = "glyphicon-road";
	options.title="Показать местоположение ТС";
	options.caption = "Местоположение ";
	
	VehicleScheduleGridCmdShowPosition.superclass.constructor.call(this,id,options);
		
}
extend(VehicleScheduleGridCmdShowPosition,GridCmd);

/* Constants */


/* private members */

/* protected*/


/* public methods */
VehicleScheduleGridCmdShowPosition.prototype.onCommand = function(){
	//this.m_grid.getFocused()
	console.log(this.m_grid.getName())
	this.m_grid.setModelToCurrentRow();
	var veh_ref = this.m_grid.getModel().getFieldValue("vehicles_ref");
	if(!veh_ref || veh_ref.isNull())return;
	
	var self = this;
	
	var win_w = $( window ).width();
	var h = $( window ).height()-20;//win_w/3*2;
	var left = win_w/3;
	var w = win_w/3*2;//left - 20;
	
	var veh_key = veh_ref.getKey();
	var href = "t=Map&v=Child&c=Vehicle_Controller&f=get_current_position&id="+veh_key;	
	var conn = window.getApp().getServConnector();
	if(conn.getAccessTokenParam){
		href+= "&"+conn.getAccessTokenParam()+"="+conn.getAccessToken();
	}
	
	this.m_mapForm = new WindowForm({
		"id":"MapForm",
		"height":h,
		"width":w,
		"left":left,
		"top":10,
		"URLParams":href,
		"name":"Map",
		"params":{
			"editViewOptions":{
				"vehicle":new RefType({"keys":{"id":veh_key}})	
				,"tracker_id":this.m_grid.getModel().getFieldValue("tracker_id")
			}
		},
		"onClose":function(){
			self.m_mapForm.close();
			delete self.m_mapForm;			
		}
	});
	this.m_mapForm.open();
}
