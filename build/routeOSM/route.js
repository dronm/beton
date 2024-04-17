var Route = {
	init: function(params){

		this.m_map = new OpenLayers.Map("map",{"controls":[]});
		this.m_layer = new OpenLayers.Layer.OSM();		
		
		this.m_map.addLayer(this.m_layer);		
		
		var zoom_bar = new OpenLayers.Control.PanZoomBar();
		this.m_map.addControl(zoom_bar);	
		this.m_map.addControl(new OpenLayers.Control.LayerSwitcher());
		this.m_map.addControl(new OpenLayers.Control.ScaleLine());
		this.m_map.addControl(new OpenLayers.Control.Navigation());
		
		this.m_vehicles = new VehicleLayer(this.m_map);	
		
		this.m_vehicles.moveMapToCoords(
			params.lon,
			params.lat,
			TRACK_CONSTANTS.INI_ZOOM
		);
		
		if(!params.locationExists && this.mobileCheck()){
			this.updateLocation();
		}
						
		this.updateDistance(params.routeRestLen);
		
		this.m_zone = new GeoZones(this.m_map,"Гео зоны");
		if(params.destZone && params.destZone.length){
			zone_str = params.destZone.split(" ").join(",");
			var zone_points = zone_str.split(",");	
			zone_points.splice(zone_points.length-2,2);//remove last point				
			this.m_zone.drawZoneOnCoords(zone_points);
		}
		var pos = JSON.parse(params.lastPos);
		this.m_curVehicleId = pos.id;
		this.m_curTrackerId = pos.tracker_id;
		this.updateVehiclePosition({
			"id":this.m_curVehicleId
			,"pos_data":pos.pos_data
			}
			,TRACK_CONSTANTS.FOUND_ZOOM
		);
		
		this.addGuessedRoute(params.route, "Построен маршрут");			
		
		this.m_srv = new AppSrv({
			"host": params.appSrvHost
			,"port": params.appSrvPort
			,"appId": params.appName
			,"token": params.token
			,"tokenExpires": null
		});
		
		//60860d10271d9:db6910f4583416f0127b051fbbcfb1dd
		this.m_srv.connect();
		var self = this;
		this.m_srv.subscribe({
			"events":[
				{"id":"Vehicle.position."+this.m_curTrackerId}
				,{"id":"Vehicle.route_redraw."+this.m_curTrackerId}
				,{"id":"Vehicle.route_end."+this.m_curTrackerId}
				,{"id":"User.logout"}
			]
			,"onEvent":function(json){
				if(json.eventId && json.eventId == "Vehicle.route_redraw."+self.m_curTrackerId
				&& json.params && json.params.shipment_id && json.params.vehicle_state && json.params.route_rest){
					console.log("Redraw route!!!")
					
					self.addGuessedRoute(json.params.route_rest, "Маршрут перестроен");
					
				}else if(json.eventId &&
				(json.eventId == "Vehicle.route_end."+self.m_curTrackerId)
				||(json.eventId == "User.logout")
				){
					//маршрут закончен
					window.location.href = window.location.href;
					
				}else{						
					self.updateVehiclePosition({
						'id':self.m_curVehicleId
						,'pos_data':json.params
					});
					self.m_vehicles.setCurrentObj(self.m_curVehicleId,self.m_map.getZoom());
					
					if(json.params && json.params.route_rest){
						//change to rest
						self.addGuessedRoute(json.params.route_rest,null);	
					}
					
					if(json.params && json.params.route_rest_len){
						self.updateDistance(parseInt(json.params.route_rest_len,10));
					}
				}
			}
			,"onWakeup":function(){
				window.location.href = window.location.href;
			}
		});
		
		EventHelper.add(document.getElementById("showVehicle"), "click", function(){
			self.m_vehicles.setCurrentObj(self.m_curVehicleId,self.m_map.getZoom());
			
		});
	}
	
	,updateVehiclePosition: function(rowStruc,zoom){
		var marker = new MapCarMarker(rowStruc);
		marker.image = TRACK_CONSTANTS.VEH_IMG;
		marker.imageScale = 0.8;
		this.m_vehicles.removeVehicle(marker.id);
		this.m_vehicles.addVehicle(marker,null,true,false);
		
		this.m_vehicles.setCurrentObj(rowStruc.id, zoom? zoom:this.m_map.getZoom());
	}
	
	,addGuessedRoute: function(routeText, noteMsg){
		var route_line_style = {
			strokeColor: "#0074FF",
			strokeWidth: 4,
			pointRadius: 6,
			pointerEvents: "visiblePainted"
		};

		var point_list = [];
		var lon_lat_ar = routeText.split(",");
		for(var i=0;i<lon_lat_ar.length;i++){
			var pos = lon_lat_ar[i].split(" ");
			point_list.push(
				(new OpenLayers.Geometry.Point(pos[0],pos[1]))
				.transform(
					new OpenLayers.Projection("EPSG:4326"), // transform from WGS 1984
					this.m_map.getProjectionObject() // to Spherical Mercator Projection
		  		)	
			);
		}

		var add_layer = false;
		if (this.m_guessedRouteLayer == undefined){
			this.m_guessedRouteLayer = new OpenLayers.Layer.Vector("Предполагаемый маршрут");
			add_layer = true;
			
		}else if(this.m_guessedRouteLayer.m_mapFeatures && this.m_guessedRouteLayer.m_mapFeatures.length){
			//remove old features
			this.m_guessedRouteLayer.removeFeatures(this.m_guessedRouteLayer.m_mapFeatures);
		}

		this.m_guessedRouteLayer.m_mapFeatures = [
			new OpenLayers.Feature.Vector(
				new OpenLayers.Geometry.LineString(point_list)
				,null
				,route_line_style
			)
		];	
		this.m_guessedRouteLayer.addFeatures(this.m_guessedRouteLayer.m_mapFeatures);
		
		if(add_layer){
			this.m_map.addLayer(this.m_guessedRouteLayer); 	
		}
		
		/*if(noteMsg){
			var msg = new WindowTempMessage();
			msg.show({
				"text":routeText
				,"type":WindowTempMessage.TP_INFO
				,"timeout":5000
			});	
		}*/
	}
	
	,updateDistance: function(distance){
		var n = document.getElementById("distanceToDest");
		if(n){
			var km = Math.floor(distance / 1000);
			var distance_s = "";
			if(km){
				distance_s = km+"км.";
			}else if(distance){
				distance_s = Math.floor(distance)+"м.";
			}
			n.textContent = distance_s;
		}
	}
	,mobileCheck: function() {
		let check = false;
		(function(a){if(/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0,4))) check = true;})(navigator.userAgent||navigator.vendor||window.opera);
		return check;
	}
	
	,updateLocation: function() {
		if (navigator.geolocation) {
			var self = this;
			navigator.geolocation.getCurrentPosition(
			    function(position) {
				self.updateLocationServCall(position);
			    },
			    function(error){
				 console.log(error.message);
			    },
			    {
				 enableHighAccuracy: true
				      ,timeout : 3000
			    }
			);			
		}
	}	
	
	,updateLocationServCall: function(position){
		var p = window.location.href.indexOf("?");
		var url = window.location.href.substring(0,p);
		var xhr = CommonHelper.createXHR();	
		url = url+"location.php?id="+this.m_ID+"&lat=" + position.coords.latitude + "&lon="+position.coords.longitude;
		xhr.open("GET", encodeURI(url), true);
		xhr.send(null);	
	}
	
}
