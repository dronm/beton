/**	
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_js.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2017
 * @class
 * @classdesc Model class. Created from template build/templates/models/Model_js.xsl. !!!DO NOT MODEFY!!!
 
 * @extends ModelXML
 
 * @requires core/extend.js
 * @requires core/ModelXML.js
 
 * @param {string} id 
 * @param {Object} options
 */

function VehicleTemplateRoute_Model(options){
	var id = 'VehicleTemplateRoute_Model';
	options = options || {};
	
	options.fields = {};
	
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	filed_options.alias = 'Объект откуда';
	filed_options.autoInc = false;	
	
	options.fields.destination_from_id = new FieldInt("destination_from_id",filed_options);
	options.fields.destination_from_id.getValidator().setRequired(true);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	filed_options.alias = 'Объект куда';
	filed_options.autoInc = false;	
	
	options.fields.destination_to_id = new FieldInt("destination_to_id",filed_options);
	options.fields.destination_to_id.getValidator().setRequired(true);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Данные маршрута OSRM (encoded(5) polyline)';
	filed_options.autoInc = false;	
	
	options.fields.route_osrm = new Fieldgeometry("route_osrm",filed_options);
	options.fields.route_osrm.getValidator().setRequired(true);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Время обновления';
	filed_options.autoInc = false;	
	
	options.fields.update_dt = new FieldDateTimeTZ("update_dt",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Количество точек маршрута';
	filed_options.autoInc = false;	
	
	options.fields.point_cnt = new FieldInt("point_cnt",filed_options);
	
		VehicleTemplateRoute_Model.superclass.constructor.call(this,id,options);
}
extend(VehicleTemplateRoute_Model,ModelXML);

