/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2018

 * @extends Control
 * @requires core/extend.js
 * @requires controls/Control.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function Statistics_View(id,options){
	options = options || {};	

	options.addElement = function(){
		var model = new ModelXML("get_vehicle_statistics",{
			"fields":["key","val"]
		});
		this.addElement(new GridAjx(id+":grid",{
			"model":model,
			"keyIds":["key"],
			"className":OrderMakeList_View.prototype.TABLE_CLASS_NO_WRAP,
			"contClassName":"v_scroll_grid_cont",
			"attrs":{"style":"width:100%;"},
			"readPublicMethod":(new Vehicle_Controller()).getPublicMethod("get_vehicle_statistics"),
			"editInline":false,
			"editWinClass":null,
			"commands":null,
			"popUpMenu":null,
			"head":new GridHead(id+":grid:head",{
				"elements":[
					new GridRow(id+":grid:head:row0",{
						"elements":[
							new GridCellHead(id+":grid:key",{
								"value":"Показатель",
								"columns":[
									new GridColumn({"field":model.getField("key")})
								]
							})
							,new GridCellHead(id+":grid:head:val",{
								"value":"Зн-е",
								"colAttrs":{"align":"right"},
								"columns":[
									new GridColumn({"field":model.getField("val")})
								]
							})
						]
					})
				]
			}),
			"pagination":null,
			"autoRefresh":true,
			"refreshInterval":null,
			"rowSelect":false,
			"focus":false,
			"navigate":false,
			"navigateClick":false
		
		}));
	}
	Statistics_View.superclass.constructor.call(this,id, options);
}
//ViewObjectAjx,ViewAjxList
extend(Statistics_View, ViewAjxList);

/* Constants */

/* private members */

/* protected*/
/* public methods */

Statistics_View.prototype.toDOM = function(p){
	
	Statistics_View.superclass.toDOM.call(this,p);
	
	/*
	var self = this;
	var stat_tg_n = document.getElementById("OrderMakeList:statisticsTgl");
	$(stat_tg_n).click(function (e) {
		e.preventDefault();
		window.getApp().panelToggle(this);
		if(e.target.id && window["localStorage"]){
			var v = localStorage.getItem(e.target.id);
			localStorage.setItem(e.target.id, (v==1)? 0 : 1);
			if(v==0){
				self.getElement("grid").onRefresh();
			}
		}
	});
	if(window["localStorage"]){
		var v = localStorage.getItem(stat_tg_n.id);				
		//collapsed
		if(v == 1){
			self.panelToggle(stat_tg_n);
		}
	}
	*/
}

