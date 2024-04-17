/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>,2019

 * @class
 * @classdesc
 
 * @requires core/extend.js  
 * @requires controls/GridCmd.js

 * @param {string} id Object identifier
 * @param {namespace} options
*/
function VehicleRunGridCmdShowMap(id,options){
	options = options || {};	

	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;
	options.glyph = "glyphicon-road";
	options.title="Показать местоположение ТС";
	options.caption = "Местоположение ";
	
	VehicleRunGridCmdShowMap.superclass.constructor.call(this,id,options);
		
}
extend(VehicleRunGridCmdShowMap,GridCmd);

/* Constants */


/* private members */

/* protected*/


/* public methods */
VehicleRunGridCmdShowMap.prototype.onCommand = function(){
	this.m_grid.setModelToCurrentRow();
	var veh_ref = this.m_grid.getModel().getFieldValue("vehicles_ref");
	var dt_from = this.m_grid.getModel().getFieldValue("st_free_start");
	var dt_to = this.m_grid.getModel().getFieldValue("st_free_end");
	
	if(!veh_ref || veh_ref.isNull())return;
	
	var win_w = $( window ).width();
	var h = $( window ).height()-20;//win_w/3*2;
	var left = win_w/3;
	var w = win_w/3*2;//left - 20;
	
	var veh_key = veh_ref.getKey();
	var db_fm = "d/m/Y H:i:s";
	
	var href = "t=Map&v=Child&c=Vehicle_Controller&f=get_track&id="+veh_key+"&dt_from="+DateHelper.format(dt_from,db_fm)+"&dt_to="+DateHelper.format(dt_to,db_fm)+"&stop_dur=00:05";
	var conn = window.getApp().getServConnector();
	if(conn.getAccessTokenParam){
		href+= "&"+conn.getAccessTokenParam()+"="+conn.getAccessToken();
	}
	alert("href="+href)
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
				"vehicle":new RefType({"keys":{"id":veh_key}}),
				"valueFrom":dt_from,
				"valueTo":dt_to
			}
		},
		"onClose":function(){
			self.m_mapForm.close();
			delete self.m_mapForm;			
		}
	});
	this.m_mapForm.open();
	
}
