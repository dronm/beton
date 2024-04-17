/* Copyright (c) 2019
 *	Andrey Mikhalevich, Katren ltd.
 */
function DestinationDialog_View(id,options){	

	options = options || {};
	options.controller = new Destination_Controller();
	options.model = options.models.DestinationDialog_Model;
	
	var self = this;
	
	options.addElement = function(){
		this.addElement(new DestinationSearchEdit(id+":name",{
			"labelCaption":"Наименование:",
			"required":true,
			"value":(options.defDialogValues&&options.defDialogValues["name"])? options.defDialogValues["name"]:""
		}));	
	
		this.addElement(new EditFloat(id+":distance",{
			"labelCaption":"Расстояние (км.):",
			"editContClassName":"input-group "+window.getBsCol(4)
		}));	

		this.addElement(new EditTime(id+":time_route",{
			"labelCaption":"Время в пути (часы):",
			"editContClassName":"input-group "+window.getBsCol(4)
		}));	

		this.addElement(new EditFloatPeriodValue(id+":price",{
			"labelCaption":"Стоимость доставки (все базы):",
			"editContClassName":"input-group "+window.getBsCol(4),
			"periodOptions":{
				"formCaption": "История цен стоимость доставки",
				"valueType":"destination_price",
				"gridClass":GridColumnFloat,
				"gridOptions":{"precision":2},
				"ctrlClass":EditMoney,
				"key":function(){
					return self.getElement("id").getValue();
				}			
			}
			
		}));	
		this.addElement(new EditFloatPeriodValue(id+":price_for_driver",{
			"labelCaption":"Специальная цена для водителя:",
			"editContClassName":"input-group "+window.getBsCol(4),
			"periodOptions":{
				"formCaption": "История цен стоимость доставки для водителя",
				"valueType":"destination_price_for_driver",
				"gridClass":GridColumnFloat,
				"gridOptions":{"precision":2},
				"ctrlClass":EditMoney,
				"key":function(){
					return self.getElement("id").getValue();
				}			
			}
		}));	
		
		this.addElement(new DestinationProdBasePriceList_View(id+":production_base_price_list",{
			"detail": true
		}));	

		this.addElement(new DestinationProdBaseDriverPriceList_View(id+":production_base_driver_price_list",{
			"detail": true
		}));	
				
		this.addElement(new EditCheckBox(id+":special_price",{
			"labelCaption":"Специальная цена:",
			"title":"Разрешить для объекта использовать специальную цену (не по прайсу)",
			"labelClassName":"control-label "+window.getBsCol(3),
			"events":{
				"change":function(){
					self.setPriceEnabled();
				}
			}
		}));	

		this.addElement(new EditCheckBox(id+":send_route_sms",{
			"labelCaption":"Отправлять СМС с маршрутом:",
			"labelClassName":"control-label "+window.getBsCol(3),
			"value":true
		}));	
		
		this.addElement(new ButtonCmd(id+":cmdFindOnMap",{
			"caption":" Найти по адресу ",
			"title":"Построить зону, проложить маршрут по адресу",
			"glyph":"glyphicon-search",
			"onClick":function(){
				self.findOnMap();
			}
		}));	

		this.addElement(new ButtonCmd(id+":cmdMakeRoute",{
			"caption":" Проложить маршрут ",
			"title":"Проложить маршрут от производства до зоны объекта",
			"glyph":"glyphicon-road",
			"onClick":function(){
				self.makeRouteToZone();
			}
		}));	
	
	
		this.addElement(new ZoneDrawingControl(id+":map_controls",{
			"onDeleteZone":function(){
				if(self.m_routeLayers && self.m_routeLayers.length){
					for(var i = 0; i< self.m_routeLayers.length; i ++){
						self.m_map.removeLayer(self.m_routeLayers[i]); 
						delete self.m_routeLayers[i];
					}
				}
			}
		}));	
	
	}
	
	DestinationDialog_View.superclass.constructor.call(this,id,options);
	
	//****************************************************	
	
	//read
	var r_bd = [
		new DataBinding({"control":this.getElement("name")})
		,new DataBinding({"control":this.getElement("distance")})
		,new DataBinding({"control":this.getElement("time_route")})
		,new DataBinding({"control":this.getElement("price")})
		,new DataBinding({"control":this.getElement("special_price")})
		,new DataBinding({"control":this.getElement("send_route_sms")})
		,new DataBinding({"control":this.getElement("price_for_driver")})
	];
	this.setDataBindings(r_bd);
	
	//write
	this.setWriteBindings([
		new CommandBinding({"control":this.getElement("name")})
		,new CommandBinding({"control":this.getElement("distance")})
		,new CommandBinding({"control":this.getElement("time_route")})
		,new CommandBinding({"control":this.getElement("send_route_sms")})
		/*
		Periodic
		,new CommandBinding({
			"control":this.getElement("price"),
			"func":function(pm){
				if(self.getElement("special_price").getValue()){
					pm.setFieldValue("price",self.getElement("price").getValue());
				}
				else{
					pm.unsetFieldValue("price");
				}
			}
		})
		*/
		,new CommandBinding({"control":this.getElement("special_price")})
	]);
	
	this.addDetailDataSet({
		"control":this.getElement("production_base_price_list").getElement("grid"),
		"controlFieldId":"destination_id",
		"field":this.m_model.getField("id")
	});
	this.addDetailDataSet({
		"control":this.getElement("production_base_driver_price_list").getElement("grid"),
		"controlFieldId":"destination_id",
		"field":this.m_model.getField("id")
	});
	
}
extend(DestinationDialog_View,ViewObjectAjx);

DestinationDialog_View.prototype.PAM_DIV_ID = "mapdiv";

DestinationDialog_View.prototype.setPriceEnabled = function(resp,cmd){
	var price_en = this.getElement("special_price").getValue();
	var ctrl = this.getElement("price");
	if(ctrl.getEnabled()!=price_en){
		ctrl.setEnabled(price_en);
		ctrl.setAttr("title", price_en? "Специальная цена, не по прайсу":"Цена согласно прайса" );
	}
}

DestinationDialog_View.prototype.onGetData = function(resp,cmd){
	DestinationDialog_View.superclass.onGetData.call(this,resp,cmd);
	
	this.setPriceEnabled();
}

DestinationDialog_View.prototype.getModified = function(){
	var v = DestinationDialog_View.superclass.getModified.call(this);
	if(v){
		return true;
	}
	return (this.getController().getPublicMethod("update").getField("zone").isSet() && this.getController().getPublicMethod("insert").getField("zone").isSet());
}

DestinationDialog_View.prototype.updateZone = function(zoneStr){
//console.log("DestinationDialog_View.prototype.updateZone zoneStr="+zoneStr)
	this.getController().getPublicMethod("update").setFieldValue("zone",zoneStr);
	this.getController().getPublicMethod("insert").setFieldValue("zone",zoneStr);
}

DestinationDialog_View.prototype.makeRouteToZoneCont = function(model){
		//bases && routes
//http://localhost/beton_new/index.php?c=Destination_Controller&f=get_object&t=DestinationDialog&mode=insert&v=Child
//http://localhost/beton_new/index.php?c=Destination_Controller&f=get_coords_on_name&v=ViewXML&name=%D0%A2%D1%8E%D0%BC%D0%B5%D0%BD%D1%81%D0%BA%D0%B0%D1%8F%20%D0%BE%D0%B1%D0%BB%D0%B0%D1%81%D1%82%D1%8C%2C%20%D0%B3%20%D0%A2%D1%8E%D0%BC%D0%B5%D0%BD%D1%8C%2C%20%D1%83%D0%BB%20%D0%A1%D0%B0%D0%BA%D0%BA%D0%BE%2C%20%D0%B4%2025		

	if (this.m_routeLayers!=undefined && this.m_routeLayers.length){
		for(var i = 0; i < this.m_routeLayers.length; i++){
			this.m_map.removeLayer(this.m_routeLayers[i]); 
			delete this.m_routeLayers[i];
		}
	}
	this.m_routeLayers = [];

	//zone ID
	var constants = {"base_geo_zone_id":null};
	window.getApp().getConstantManager().get(constants);
	let base_zone_id = constants.base_geo_zone_id.getValue();

	var min_dist = 0;
	var routes = CommonHelper.unserialize(model.getFieldValue("routes"));		
	for(var id in routes){

		var b_zone_points = routes[id]? routes[id].zone_str.split(" ").join(",").split(",") : [];
		
		try{
			this.m_zones.setDrawComplete(null,null);//do not update
			this.m_zones.drawZoneOnCoords(b_zone_points);
		}finally{
			this.m_zones.setDrawComplete(this.drawComplete,this);
		}		
		//console.log(routes[id].route)
		
		if(!routes[id].route || routes[id].route.code!="Ok" || !routes[id].route.routes || !routes[id].route.routes.length){
			throw new Error("Ошибка получения данных!");
		}
		
		var route = routes[id].route;
		//eurobeton specific code
		if(id == base_zone_id){
			min_dist = Math.round(route.routes[0].distance/1000);
		}
		
		//route.waypoints[0]["name"]
		var route_descr = routes[id]["name"] + " - " + route.waypoints[1]["name"];

		var geom_str = route.routes[0].geometry.replace(/\\\\/g, "\\");
		var points = decodeLine(geom_str);//ext function				
		
		var route_layer = new OpenLayers.Layer.Vector(route_descr);
		this.m_routeLayers.push(route_layer);
		
		var map_features = [];
		
		//route to dest, making line points
		this.m_zones.addLineFromPoints(map_features,points,{
			strokeColor: "#0074FF",
			strokeWidth: 4,
			pointRadius: 6,
			pointerEvents: "visiblePainted"
		});
		
		//base center markers
		var center_pt = routes[id].zone_center_str.split(" ").join(",").split(",");
		var style_mark = OpenLayers.Util.extend({}, OpenLayers.Feature.Vector.style['default']);
		style_mark.externalGraphic = "./img/marker-blue.png";
		style_mark.graphicHeight = 25; 
		style_mark.graphicWidth = 21;		
		style_mark.graphicTitle = route.waypoints[0]["name"];//"Зона завода";
		style_mark.fillOpacity = 1;			
		style_mark.cursor = 'pointer';
		style_mark.labelXOffset = 7;
		style_mark.labelYOffset = 7;
		style_mark.fontSize = '8px';
		map_features.push(
			new OpenLayers.Feature.Vector(
				this.m_zones.getMapPoint(center_pt[0],center_pt[1])
				,null
				,style_mark
			)
		);

		//client center markers
		var style_mark = OpenLayers.Util.extend({}, OpenLayers.Feature.Vector.style['default']);
		style_mark.externalGraphic = "./img/marker-blue.png";
		style_mark.graphicHeight = 25; 
		style_mark.graphicWidth = 21;		
		style_mark.graphicTitle = route.waypoints[1]["name"];//"Зона клиента";
		style_mark.fillOpacity = 1;			
		style_mark.cursor = 'pointer';
		style_mark.labelXOffset = 7;
		style_mark.labelYOffset = 7;
		style_mark.fontSize = '8px';
		
		map_features.push(
			new OpenLayers.Feature.Vector(
				this.m_zones.getMapPoint(model.getFieldValue("road_lon_pos"),model.getFieldValue("road_lat_pos"))
				,null
				,style_mark
			)
		);
		
		
		route_layer.addFeatures(map_features);
		this.m_map.addLayer(route_layer); 
		
		window.showTempNote("Проложен маршрут до объекта",null,5000);
	}
	this.getElement("distance").setValue(min_dist);

}

DestinationDialog_View.prototype.makeRouteToZone = function(){

	var zone_coords = this.getController().getPublicMethod("update").getFieldValue("zone");

	if(!zone_coords || !zone_coords.length){
		zone_coords = this.getModel().getFieldValue("zone_str");
		if(!zone_coords || !zone_coords.length){
			return;
		}
	}
	
	var pm = (new Destination_Controller()).getPublicMethod("get_route_to_zone");
	pm.setFieldValue("zone_coords",zone_coords);
	var self = this;
	pm.run({
		"ok":function(resp){
			var model = resp.getModel("Coords_Model");
			if(model.getNextRow()){
				self.makeRouteToZoneCont(resp.getModel("Coords_Model"));
			}
		}
	})
}

DestinationDialog_View.prototype.findOnMapCont = function(model){
	if(model.getNextRow()){
		var lon_lower = model.getFieldValue("lon_lower");
		var lat_lower = model.getFieldValue("lat_lower");
		var lon_upper = model.getFieldValue("lon_upper");
		var lat_upper = model.getFieldValue("lat_upper");
		var zone_str = lon_lower+" "+lat_lower+","+
			lon_lower+" "+lat_upper+","+
			lon_upper+" "+lat_upper+","+
			lon_upper+" "+lat_lower+","+
			lon_lower+" "+lat_lower;							
		
		zone_str = zone_str.split(" ").join(",");
		var zone_points = zone_str.split(",");	
		this.m_zones.drawZoneOnCoords(zone_points);//updates coords!!
		
		this.makeRouteToZoneCont(model);
		
		var move_lon = lon_lower + (lon_upper - lon_lower)/2;
		var move_lat = lat_lower + (lat_upper - lat_lower)/2;				
		this.m_zones.moveMapToCoords(move_lon, move_lat,TRACK_CONSTANTS.FOUND_ZOOM);			
		
		window.showTempNote("Построена зона по адресу",null,5000);
	}
}

DestinationDialog_View.prototype.findOnMap = function(){
	var ctrl = this.getElement("name");
	if(ctrl.isNull())return;
	var pm = (new Destination_Controller()).getPublicMethod("get_coords_on_name");
	pm.setFieldValue("name",ctrl.getValue());
	var self = this;
	pm.run({
		"ok":function(resp){
			self.findOnMapCont(resp.getModel("Coords_Model"));
		}
	})
}

DestinationDialog_View.prototype.toDOM = function(parent){

	DestinationDialog_View.superclass.toDOM.call(this,parent);

	this.m_map = new OpenLayers.Map("map",{"controls":[]});
	this.m_layer = new OpenLayers.Layer.OSM();		
	
	this.m_map.addLayer(this.m_layer);		
	
	var zoom_bar = new OpenLayers.Control.PanZoomBar();
	this.m_map.addControl(zoom_bar);	
	this.m_map.addControl(new OpenLayers.Control.LayerSwitcher());
	this.m_map.addControl(new OpenLayers.Control.ScaleLine());
	this.m_map.addControl(new OpenLayers.Control.Navigation());
	
	var zone_str = this.getModel().getFieldValue("zone_str");
	var zone_points = [];
	if(zone_str){
		zone_str = zone_str.split(" ").join(",");
		zone_points = zone_str.split(",");	
		zone_points.splice(zone_points.length-2,2);//remove last point
	}
		
	this.m_zones = new GeoZones(this.m_map,"Объект",zone_points,true);	
	this.getElement("map_controls").setZones(this.m_zones);
	
	this.m_zones.setDrawComplete(this.drawComplete,this);
	
	var zone_center =  this.getModel().getFieldValue("zone_center_str");
	var zone_center_ar = zone_center? zone_center.split(" "):null;
	if (zone_center_ar && zone_center_ar.length>=2){
		move_lon = zone_center_ar[0];
		move_lat = zone_center_ar[1];
		zoom = TRACK_CONSTANTS.FOUND_ZOOM;
	}
	else{
		var constants = {"map_default_lon":null,"map_default_lat":null};
		window.getApp().getConstantManager().get(constants);
		
		move_lon = NMEAStrToDegree(constants.map_default_lon.getValue());
		move_lat = NMEAStrToDegree(constants.map_default_lat.getValue());
		zoom = TRACK_CONSTANTS.INI_ZOOM;
	}
	
	this.m_zones.moveMapToCoords(move_lon, move_lat,zoom);
	
}

DestinationDialog_View.prototype.drawComplete = function(coordsStr){
	//console.log("DestinationDialog_View.prototype.drawComplete coordsStr="+coordsStr)
	this.updateZone(coordsStr);
}
