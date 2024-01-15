var Route = {

	init: function(params){
		var self = this;

		var pos = JSON.parse(params.lastPos);	
		this.m_curVehicleId = pos.id;
		this.m_curTrackerId = pos.tracker_id;
		this.m_curVehiclePlate = pos.plate;
		this.m_vehicleCoords = [pos.pos_data.lat,pos.pos_data.lon];
		this.m_ID = params.id;
		
		var map_n = document.getElementById("map");
		map_n.style.height = (window.screen.height-200)+'px';
		map_n.style.width = '100%';
		
		if(params.c && !params.locationExists && this.mobileCheck()){
			this.updateLocation();
		}
		
		DG.then(function () {						
			self.m_map = DG.map('map', {
			    center: self.m_vehicleCoords,
			    zoom: TRACK_CONSTANTS.INI_ZOOM
			});

			self.m_vehicleIcon = DG.icon({
				iconUrl: 'img/mixer.png',
				iconSize: [38, 38],
			});		

			//self.addZone(params.destZone);				
			self.updateVehiclePosition(pos.pos_data);			
			self.updateDistance(parseInt(params.routeRestLen,10));
			self.addGuessedRoute(params.route,null);	
			
			self.m_map.fitBounds(self.m_routeLine.getBounds());				
			
			self.m_srv = new AppSrv({
				"host": params.appSrvHost
				,"port": params.appSrvPort
				,"appId": params.appName
				,"token": params.token
				,"tokenExpires": null
			});
			self.m_srv.connect();
			self.m_srv.subscribe({
				"events":[
					{"id":"Vehicle.position."+self.m_curTrackerId}
					,{"id":"Vehicle.route_redraw."+self.m_curTrackerId}
					,{"id":"Vehicle.route_end."+self.m_curTrackerId}
					,{"id":"User.logout"}
				]
				,"onEvent":function(json){
					if(json.eventId && json.eventId == "Vehicle.route_redraw."+self.m_curTrackerId){
						if(json.params && json.params.long_route_rest===true){
							self.fetchGuessedRoute("Маршрут перестроен");
						
						}else if(json.params && json.params.route_rest&&json.params.route_rest.length){
							self.addGuessedRoute(json.params.route_rest, "Маршрут перестроен");
						}
						
					}else if(json.eventId &&
					(json.eventId == "Vehicle.route_end."+self.m_curTrackerId)
					||(json.eventId == "User.logout")
					){
						//маршрут закончен
						window.location.href = window.location.href;
						
					}else{						
						self.updateVehiclePosition(json.params);
						self.m_map.setView(self.m_vehicleCoords);
						
						if(json.params && json.params.long_route_rest===true){
							self.fetchGuessedRoute(null);
							
						}else if(json.params && json.params.route_rest){
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
				if(self.m_vehicleCoords){
					self.m_map.setView(self.m_vehicleCoords);
				}
			});						
		});
	}

	//string lon1 lat1, lon2 lat2 to [[lat1,lon1],[lat2,lon2]]
	,strCoordsToArray: function(str){
		if(str){
			var coords_ar = str.split(",");
			var res = [];
			for(var i=0;i<coords_ar.length;i++){
				var pt = coords_ar[i].split(" ");
				res.push([pt[1],pt[0]]);
			}
			return res;
		}
	}
	
	,updateVehiclePosition: function (posData){
		if(this.m_vehicle){
			this.m_vehicle.remove();
		}
		this.m_vehicleCoords = [posData.lat,posData.lon];
		this.m_vehicle = DG.marker(this.m_vehicleCoords,{icon: this.m_vehicleIcon});		
		var p = posData.period.indexOf("T");
		if(p>=0){
			var d_parts = posData.period.substring(p+1).split(":");			
			if(d_parts.length>=2){
				this.m_vehicle.bindLabel(d_parts[0]+":"+d_parts[1]);//
			}
		}
		this.m_vehicle.bindPopup(this.m_curVehiclePlate);
		this.m_vehicle.addTo(this.m_map);
	}

	,addGuessedRoute:function(coords,msg){
		if(this.m_routeLine){
			this.m_routeLine.remove();
		}
		var route_pt = this.strCoordsToArray(coords);
		this.m_routeLine = DG.polyline(route_pt);
		this.m_routeLine.addTo(this.m_map);
		
		//zone marker
		if(this.m_zone){
			this.m_zone.remove();	
		}
		var z_marker_coord = route_pt[route_pt.length-1];
		this.m_zone = DG.marker(z_marker_coord).addTo(this.m_map);				
	}
	
	,addZone:function(coords){
		if(this.m_zone){
			this.m_zone.remove();	
			return;
		}
		var zone_pt = this.strCoordsToArray(coords);
		if(!zone_pt.length){
			return;
		}
		this.m_zone = DG.polygon(zone_pt, {color: "green"});
		this.m_zone.addTo(this.m_map);	
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
	
	,fetchGuessedRoute: function(msg){
		var p = window.location.href.indexOf("?");
		var url = window.location.href.substring(0,p);
		var xhr = CommonHelper.createXHR();	
		url = url+"long_route_rest.php?"+this.m_curTrackerId;
		var self = this;
		xhr.onreadystatechange = function(){
			if (xhr.readyState == 4 && xhr.status>=200 && xhr.status<300){
				var json = JSON.parse(xhr.responseText);
				if(json&&json.models&&json.models.RouteRest_Model&&json.models.RouteRest_Model.rows&&json.models.RouteRest_Model.rows.length){
					self.addGuessedRoute(json.models.RouteRest_Model.rows[0].route_rest,msg);
				}
			}
		}
		
		xhr.open("GET", encodeURI(url), true);
		xhr.send(null);	
	}
}



