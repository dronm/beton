/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2016
 
 * @class
 * @classdesc
	
 * @param {namespace} options
 */	
function AppBeton(options){
	options = options || {};
	
	options.lang = "rus";	
	options.paginationClass = Pagination;
	
	this.setColorClass(options.servVars.color_palette || this.COLOR_CLASS);

	AppBeton.superclass.constructor.call(this,"AppBeton",options);
	
	if (this.storageGet(this.getSidebarId())=="xs"){
		$('body').toggleClass('sidebar-xs');
	}

	this.m_phpAppServer = true;//for specific events
}
extend(AppBeton,App);

/* Constants */

AppBeton.prototype.DEF_phoneEditMask = "7-(999)-999-99-99";
AppBeton.prototype.ER_PERIOD_NOT_ALLOWED = "Запрещено просматривать данный период!";

AppBeton.prototype.FILE_MIME_TYPES = {
  'audio/x-mpeg': 'mpega',
  'application/postscript': 'ps',
  'audio/x-aiff': 'aiff',
  'application/x-aim': 'aim',
  'image/x-jg': 'art',
  'video/x-ms-asf': 'asx',
  'audio/basic': 'ulw',
  'video/x-msvideo': 'avi',
  'video/x-rad-screenplay': 'avx',
  'application/x-bcpio': 'bcpio',
  'application/octet-stream': 'exe',
  'image/bmp': 'dib',
  'text/html': 'html',
  'application/x-cdf': 'cdf',
  'application/pkix-cert': 'cer',
  'application/java': 'class',
  'application/x-cpio': 'cpio',
  'application/x-csh': 'csh',
  'text/css': 'css',
  'application/msword': 'doc',
  'application/xml-dtd': 'dtd',
  'video/x-dv': 'dv',
  'application/x-dvi': 'dvi',
  'application/vnd.ms-fontobject': 'eot',
  'text/x-setext': 'etx',
  'image/gif': 'gif',
  'application/x-gtar': 'gtar',
  'application/x-gzip': 'gz',
  'application/x-hdf': 'hdf',
  'application/mac-binhex40': 'hqx',
  'text/x-component': 'htc',
  'image/ief': 'ief',
  'text/vnd.sun.j2me.app-descriptor': 'jad',
  'application/java-archive': 'jar',
  'text/x-java-source': 'java',
  'application/x-java-jnlp-file': 'jnlp',
  'image/jpeg': 'jpg',
  'application/javascript': 'js',
  'text/plain': 'txt',
  'application/json': 'json',
  'audio/midi': 'midi',
  'application/x-latex': 'latex',
  'audio/x-mpegurl': 'm3u',
  'image/x-macpaint': 'pnt',
  'text/troff': 'tr',
  'application/mathml+xml': 'mathml',
  'application/x-mif': 'mif',
  'video/quicktime': 'qt',
  'video/x-sgi-movie': 'movie',
  'audio/mpeg': 'mpa',
  'video/mp4': 'mp4',
  'video/mpeg': 'mpg',
  'video/mpeg2': 'mpv2',
  'application/x-wais-source': 'src',
  'application/x-netcdf': 'nc',
  'application/oda': 'oda',
  'application/vnd.oasis.opendocument.database': 'odb',
  'application/vnd.oasis.opendocument.chart': 'odc',
  'application/vnd.oasis.opendocument.formula': 'odf',
  'application/vnd.oasis.opendocument.graphics': 'odg',
  'application/vnd.oasis.opendocument.image': 'odi',
  'application/vnd.oasis.opendocument.text-master': 'odm',
  'application/vnd.oasis.opendocument.presentation': 'odp',
  'application/vnd.oasis.opendocument.spreadsheet': 'ods',
  'application/vnd.oasis.opendocument.text': 'odt',
  'application/vnd.oasis.opendocument.graphics-template': 'otg',
  'application/vnd.oasis.opendocument.text-web': 'oth',
  'application/vnd.oasis.opendocument.presentation-template': 'otp',
  'application/vnd.oasis.opendocument.spreadsheet-template': 'ots',
  'application/vnd.oasis.opendocument.text-template': 'ott',
  'application/ogg': 'ogx',
  'video/ogg': 'ogv',
  'audio/ogg': 'spx',
  'application/x-font-opentype': 'otf',
  'audio/flac': 'flac',
  'application/annodex': 'anx',
  'audio/annodex': 'axa',
  'video/annodex': 'axv',
  'application/xspf+xml': 'xspf',
  'image/x-portable-bitmap': 'pbm',
  'image/pict': 'pict',
  'application/pdf': 'pdf',
  'image/x-portable-graymap': 'pgm',
  'audio/x-scpls': 'pls',
  'image/png': 'png',
  'image/x-portable-anymap': 'pnm',
  'image/x-portable-pixmap': 'ppm',
  'application/vnd.ms-powerpoint': 'pps',
  'image/vnd.adobe.photoshop': 'psd',
  'image/x-quicktime': 'qtif',
  'image/x-cmu-raster': 'ras',
  'application/rdf+xml': 'rdf',
  'image/x-rgb': 'rgb',
  'application/vnd.rn-realmedia': 'rm',
  'application/rtf': 'rtf',
  'text/richtext': 'rtx',
  'application/font-sfnt': 'sfnt',
  'application/x-sh': 'sh',
  'application/x-shar': 'shar',
  'application/x-stuffit': 'sit',
  'application/x-sv4cpio': 'sv4cpio',
  'application/x-sv4crc': 'sv4crc',
  'image/svg+xml': 'svgz',
  'application/x-shockwave-flash': 'swf',
  'application/x-tar': 'tar',
  'application/x-tcl': 'tcl',
  'application/x-tex': 'tex',
  'application/x-texinfo': 'texinfo',
  'image/tiff': 'tiff',
  'text/tab-separated-values': 'tsv',
  'application/x-font-ttf': 'ttf',
  'application/x-ustar': 'ustar',
  'application/voicexml+xml': 'vxml',
  'image/x-xbitmap': 'xbm',
  'application/xhtml+xml': 'xhtml',
  'application/vnd.ms-excel': 'xls',
  'application/xml': 'xsl',
  'image/x-xpixmap': 'xpm',
  'application/xslt+xml': 'xslt',
  'application/vnd.mozilla.xul+xml': 'xul',
  'image/x-xwindowdump': 'xwd',
  'application/vnd.visio': 'vsd',
  'audio/x-wav': 'wav',
  'image/vnd.wap.wbmp': 'wbmp',
  'text/vnd.wap.wml': 'wml',
  'application/vnd.wap.wmlc': 'wmlc',
  'text/vnd.wap.wmlsc': 'wmls',
  'application/vnd.wap.wmlscriptc': 'wmlscriptc',
  'video/x-ms-wmv': 'wmv',
  'application/font-woff': 'woff',
  'application/font-woff2': 'woff2',
  'model/vrml': 'wrl',
  'application/wspolicy+xml': 'wspolicy',
  'application/x-compress': 'z',
  'application/zip': 'zip'
};
/* private members */
AppBeton.prototype.m_colorClass;

/* protected*/
/*App.prototype.m_serverTemplateIds = [
	"ProductionMaterialList"
];
*/
AppBeton.prototype.makeItemCurrent = function(elem){
	if (elem){
		var l = DOMHelper.getElementsByAttr("active", document.body, "class", true,"LI");
		for(var i=0;i<l.length;i++){
			DOMHelper.delClass(l[i],"active");
		}
		DOMHelper.addClass(elem.parentNode,"active");
		if (elem.nextSibling){
			elem.nextSibling.style="display: block;";
		}
	}
}

AppBeton.prototype.showMenuItem = function(item,c,f,t,extra,title){
	AppBeton.superclass.showMenuItem.call(this,item,c,f,t,extra,title);
	this.makeItemCurrent(item);
}


/* public methods */
AppBeton.prototype.getSidebarId = function(){
	return this.getServVar("user_name")+"_"+"sidebar-xs";
}
AppBeton.prototype.toggleSidebar = function(){
	var id = this.getSidebarId();
	this.storageSet(id,(this.storageGet(id)=="xs")? "":"xs");
}

AppBeton.prototype.formatError = function(erCode,erStr){
	return (erStr +( (erCode)? (", код:"+erCode):"" ) );
}

AppBeton.prototype.getColorClass = function(){
	return this.m_colorClass;
}
AppBeton.prototype.setColorClass = function(v){
	this.m_colorClass = v;
}

AppBeton.prototype.formatCellStr = function(fVal,cell,len){
	var res = "";
	if(fVal && fVal.length>len+2){
		cell.setAttr("title",fVal);
		res = fVal.substr(0,len)+"...";
	}
	else if(fVal){
		res = fVal;
	}
	return res;
}

AppBeton.prototype.formatCell = function(field,cell,len){
	var res = "";
	if(field&&!field.isNull()){
		var f_val = field.getValue();
		if(typeof f_val=="object")
			f_val = f_val.getDescr();
		/*	
		if(f_val&&f_val.length>len+2){
			cell.setAttr("title",f_val);
			res = f_val.substr(0,len)+"...";
		}
		else if(f_val){
			res = f_val;
		}
		*/
		res = this.formatCellStr(f_val,cell,len);
	}
	return res;
}

AppBeton.prototype.getProdSiteModel = function(){
	if(!this.m_prodSite_Model){
		var self = this;
		(new ProductionSite_Controller()).getPublicMethod("get_list").run({
			"async":false,
			"ok":function(resp){
				self.m_prodSite_Model = resp.getModel("ProductionSite_Model");
			}
		})
	}
	return this.m_prodSite_Model;
}

AppBeton.prototype.makeGridNewDataSound = function(){
	var audio = new Audio("img/Bell-sound-effect-ding.mp3");
	audio.play();
	//console.log("AppBeton.prototype.makeGridNewDataSound")
}

AppBeton.prototype.callActions = function(callId,tel){
	var self = this;
	this.m_callSubscriptions = this.m_callSubscriptions || {};
	this.m_callSubscriptions[callId] = this.m_appSrv.subscribe({
		"events":[
			{"id":"AstCall.pickup."+callId}
			,{"id":"AstCall.hangup."+callId}
		]
		,"onEvent":(function(call_id, phone){
			return function(json){
				if(json && json.eventId=="AstCall.pickup."+call_id){
					window.showTempNote("Начало разговора "+phone,null,5000);					
				
				}else if(json && json.eventId=="AstCall.hangup."+call_id){
					window.showTempNote("Окончания разговора "+phone,null,5000);
					self.m_appSrv.unsubscribe(self.m_callSubscriptions[call_id]);
				}
			}
		})(callId,tel)
	});
}

AppBeton.prototype.makeCallContinue = function(tel){
	/*f(this.getServVar("debug")==1){
		window.showTempNote("ТЕСТ Набор номера: "+tel,null,10000);
		return;
	}*/
	
	var pm = (new Caller_Controller()).getPublicMethod("call");
	pm.setFieldValue("tel",tel);
	var self = this;
	pm.run({
		"ok":function(resp){
			if(self.m_appSrv){
				var m = resp.getModel("Call_Model");
				if(m && m.getNextRow()){
					//subscribe
					self.callActions(m.getFieldValue("call_id"),tel);
				}
			}
			window.showTempNote("Набор номера: "+tel,null,10000);			
		}
	})
}

AppBeton.prototype.makeCall = function(tel){
	if(!window.Caller_Controller){
		throw new Error("Контроллер Caller_Controlle не определен!");
	}
	var self = this;
	WindowQuestion.show({
		"cancel":false,
		"text":"Набрать номер "+tel+"?",
		"callBack":function(res){
			if(res==WindowQuestion.RES_YES){
				self.makeCallContinue(tel);
			}
		}
	});
}

/**
 * opens dialog form
 */
AppBeton.prototype.materialQuantCorrection = function(fields){
	var mat_id = fields.material_id.getValue();
	this.m_materialDifStore = this.m_materialDifStore || {};
	if(this.m_materialDifStore["id"+mat_id]==undefined){
		//get attribute
		var self = this;
		var pm = (new RawMaterial_Controller()).getPublicMethod("get_object");
		pm.setFieldValue("id",mat_id);
		pm.run({
			"ok":(function(fields,matId){
				return function(resp){
					var m = resp.getModel("RawMaterial_Model");
					if(m.getNextRow()){
						var dif_store = m.getFieldValue("dif_store");
						self.m_materialDifStore["id"+matId] = dif_store;
						self.materialQuantCorrectionCont(fields,dif_store);
					}
				}
			})(fields,mat_id)
		});
	}
	else{
		this.materialQuantCorrectionCont(fields,this.m_materialDifStore["id"+mat_id]);
	}	
}

AppBeton.prototype.materialQuantCorrectionCont = function(fields,matDifStore){
	var self = this;
	var elements = [];
	if(matDifStore){
		elements.push(
			new ProductionSiteEdit("CorrectQuant:cont:production_sites_ref",{
				"labelCaption":"Завод:",
				"required":"true",
				"focus":(!fields.production_site_id),
				"enabled":(!fields.production_site_id),
				"value":fields.production_site_id
			})
		);
	}
	elements.push(
		new EditFloat("CorrectQuant:cont:quant",{
			"labelCaption":"Количество:",
			"length":19,
			"precision":4,
			"focus":!(matDifStore&&!fields.production_site_id)
		})
	);
	elements.push(
		new EditText("CorrectQuant:cont:comment_text",{
			"labelCaption":"Комментарий:",
			"rows":3
		})
	);
	
	this.m_viewMatertialQuantCorrect = new EditJSON("CorrectQuant:cont",{
		"elements":elements
	});
	this.m_formMatertialQuantCorrect = new WindowFormModalBS("CorrectQuant",{
		"content":this.m_viewMatertialQuantCorrect,
		"cmdCancel":true,
		"cmdOk":true,
		"contentHead":"Корректировка количества "+fields.material_descr.getValue(),
		"onClickCancel":function(){
			self.closeMatertialQuantCorrect();
		},
		"onClickOk":(function(matDifStore,self){
			return function(){
				var res = self.m_viewMatertialQuantCorrect.getValueJSON();
				if(!res||!res.production_sites_ref||res.production_sites_ref.isNull()){
					throw new Error("Не указан завод!");
				}
				self.setMatertialQuantCorrectOnServer(res,matDifStore,self.m_viewMatertialQuantCorrect.fieldValues);
			}
		})(matDifStore,self)
	});
	this.m_viewMatertialQuantCorrect.fieldValues = {
		"material_id":fields.material_id.getValue(),		
		"material_descr":fields.material_descr.getValue()
	}
	this.m_formMatertialQuantCorrect.open();
}

AppBeton.prototype.setMatertialQuantCorrectOnServer = function(newValues,matDifStore,fieldValues){
	var self = this;
	var pm = (new MaterialFactBalanceCorretion_Controller()).getPublicMethod("insert");
	pm.setFieldValue("material_id",fieldValues.material_id);
	pm.setFieldValue("comment_text",newValues.comment_text);
	pm.setFieldValue("required_balance_quant",newValues.quant);
	if(matDifStore){
		pm.setFieldValue("production_site_id",newValues.production_sites_ref.getKey("id"));
	}
	else{
		pm.resetFieldValue("production_site_id");
	}
	pm.run({
		"ok":function(){
			window.showTempNote(fieldValues.material_descr+": откорректирован остаток на утро",null,5000);				
			self.closeMatertialQuantCorrect();
			self.m_refresh();
		}
	})	
}

AppBeton.prototype.closeMatertialQuantCorrect = function(){
	this.m_viewMatertialQuantCorrect.delDOM()
	this.m_formMatertialQuantCorrect.delDOM();
	delete this.m_viewMatertialQuantCorrect;
	delete this.m_formMatertialQuantCorrect;			
}

AppBeton.prototype.getChartColors = function(){
	if(!this.m_chartColors){
		this.m_chartColors = {
			red: 'rgb(255, 99, 132)',
			orange: 'rgb(255, 159, 64)',
			yellow: 'rgb(255, 205, 86)',
			green: 'rgb(75, 192, 192)',
			blue: 'rgb(54, 162, 235)',
			purple: 'rgb(153, 102, 255)',
			grey: 'rgb(201, 203, 207)'
		};	
	}
	return this.m_chartColors;
}

AppBeton.prototype.checkRoleViewRestriction = function(dateFrom, dateTo){
	var vars = {"role_view_restriction":null};
	this.getSessionVarManager().get(vars);
	if(vars && vars.role_view_restriction){
		//console.log("vars=")
		//console.log(vars)
		if(dateFrom && vars.role_view_restriction.back_days_allowed>=0){
			var date = DateHelper.getStartOfShift();
			date.setDate(date.getDate() - vars.role_view_restriction.back_days_allowed);		
			if(dateFrom < date){
				return false;
			}
		}
		if(dateTo && vars.role_view_restriction.front_days_allowed>=0){
			var date = DateHelper.getEndOfShift();
			date.setDate(date.getDate() + vars.role_view_restriction.front_days_allowed);		
			if(dateTo > date){
				return false;
			}
		}
	}
	/*
	if(this.getServVar("role_view_restriction")){
		if(!this.role_view_restriction){
			this.role_view_restriction = CommonHelper.unserialize(this.getServVar("role_view_restriction"))
		}
		if(dateFrom &&this.role_view_restriction.back_days_allowed>=0){
			var date = DateHelper.getStartOfShift();
			date.setDate(date.getDate() - this.role_view_restriction.back_days_allowed);		
			if(dateFrom < date){
				return false;
			}
		}
		if(dateTo && this.role_view_restriction.front_days_allowed>=0){
			var date = DateHelper.getEndOfShift();
			date.setDate(date.getDate() + this.role_view_restriction.front_days_allowed);		
			if(dateTo > date){
				return false;
			}
		}
	}
	*/
	return true;
}

AppBeton.prototype.sendNotificationToEntityCont = function(m, selectedRowNode){
	var el = [];
	var self = this;
	while(m.getNextRow()){
		var ct_ref = m.getFieldValue("contacts_ref");
		var descr = ct_ref.getDescr();
		var id = ct_ref.getKey("id");
		el.push({"id":CommonHelper.uniqid(),
			"onClick":(function(id, descr){
				return function(){
					self.sendNotification(new RefType({
						"dataType": "contacts",
						"descr": descr,
						"keys":{"id": id}
					}));
				}
			})(id, descr),
			"caption":descr,
			"glyph": (m.getFieldValue("tm_exists"))? "glyphicon-send":""
		});
	}
	if(el.length >1){
		(new PopUpMenu({
			"elements":el
		})).show(null, selectedRowNode);
		
	}else if(el.length == 1 ){
		el[0].onClick();
	}										
}

AppBeton.prototype.sendNotificationToEntity = function(entityType, entityId, selectedRowNode){
	var pm = (new EntityContact_Controller()).getPublicMethod("get_list");
	var sep = ControllerObj.prototype.PARAM_FIELD_SEP_VAL;
	var c_fields = "entity_type" + sep + "entity_id";
	var c_vals = entityType + sep + entityId;
	var c_sgns = ControllerObj.prototype.PARAM_SGN_EQUAL + sep + ControllerObj.prototype.PARAM_SGN_EQUAL;
	
	pm.setFieldValue("cond_fields", c_fields);
	pm.setFieldValue("cond_vals", c_vals);
	pm.setFieldValue("cond_sgns", c_sgns);
	pm.setFieldValue("field_sep", sep);	
	var self = this;
	pm.run({
		"ok":function(resp){
			var m = resp.getModel("EntityContactList_Model");
			if(m){
				self.sendNotificationToEntityCont(m, selectedRowNode);
			}
		}
	});
}

//ref - contacts
AppBeton.prototype.sendNotification = function(ref){
	var view = new TmNotification_View("notification:body:view",{
		"ref":ref
	});
	
	var closeForm = function(v, f){
		v.delDOM()
		f.delDOM();
		delete v;
		delete f;			
	}
		
	var form = new WindowFormModalBS("notification",{
		"content":view,
		"cmdCancel":true,
		"cmdOk":true,
		"contentHead":"Отправка сообщения: "+ref.getDescr(),
		"onClickCancel":function(){
			closeForm(view,form);
		},
		"onClickOk":function(){
			view.onSubmit(function(res){
				if(res==true){
					closeForm(view, form);
				}
			});				
		}
	});
	form.open();
}

//enterprise user chat
AppBeton.prototype.showUserChat = function(){
	var r = this.getServVar("role_id");
	var w = window.getWidthType();
	
	return ( (w!="sm"&&w!="xs") && (r!="client"));
}


AppBeton.prototype.showTmChat = function(){
	var r = this.getServVar("role_id");
	var w = window.getWidthType();
	
	return ( (w!="sm"&&w!="xs") && (r=="admin"||r=="owner"||r=="manager"||r=="sales"));
}

AppBeton.prototype.subscribeToEventSrv = function(clientId){
	AppBeton.superclass.subscribeToEventSrv.call(this,clientId);
	
	//custom
	if(this.showTmChat()){
		var self = this;
		this.m_appSrv.subscribe({
			"events":[
				{"id":"TmInMessage.insert"},
				{"id":"TmOutMessage.sent"}
			]
			,"onEvent":function(json){				
				self.m_tmChat.onNewMessage(json);
			}
		});			
	}

	if(this.showUserChat()){
		var self = this;
		this.m_appSrv.subscribe({
			"events":[
				{"id": "UserChat.common"},
				{"id": this.getServVar("chat_private_id")},
				{"id": this.getServVar("chat_out_id")}
			]
			,"onEvent":function(json){				
				self.m_userChat.onNewMessage(json);
			}
		});			
	}
}

AppBeton.prototype.getTmUserDescr = function(ref){
	if(!ref)return "";
	var dt = ref.getDataType();
	var res = "";
	/*if(dt=="users"){
		res= "Пользователь: ";
		
	}else if(dt=="clients" || dt=="client_tels"){
		res= "Клиент: ";
		
	}else if(dt=="pump_vehicles"){
		res= "Насос: ";
	*/	
	if(!dt){
		res = "<неопределен тип>";
		//console.log("AppBeton.prototype.getTmUserDescr, dt=",dt)
	}	
	return (res + ref.getDescr());
}

AppBeton.prototype.setContactRefOnTel = function(tel ,callBack){
	var pm = (new ClientTel_Controller()).getPublicMethod("get_ref");
	pm.setFieldValue("tel", tel);
	pm.run({
		"ok":function(resp){
			var m = resp.getModel("Ref_Model");
			if(m && m.getNextRow()){
				callBack(CommonHelper.unserialize(m.getFieldValue("ref")));
			}
		}
	})
}
AppBeton.prototype.formatContactList = function(f, cell){
	var contact_list = f.contact_list.getValue();
	if(!contact_list || !contact_list.length){
		return;
	}
	var cell_n = cell.getNode();
	var ul_tag = document.createElement("ul");
	
	for(var i = 0; i< contact_list.length; i++){
		var tel = contact_list[i].tel;
		var tel_m = tel;
		if(tel_m && tel_m.length==10){
			tel_m = "+7"+tel;
		}
		else if(tel_m && tel_m.length==11){
			tel_m = "+7"+tel.substr(1);
		}
		var li_tag = document.createElement("li");
		li_tag.textContent = contact_list[i]["name"];
		if(contact_list[i]["email"]){
			li_tag.textContent+= ", "+contact_list[i]["email"];
		}
		if(contact_list[i]["post"]){
			li_tag.textContent+= ", "+contact_list[i]["post"];
		}		
		
		if(tel_m && tel_m.length){
			li_tag.textContent+= ", ";
			var t_tag = document.createElement("A");
			t_tag.setAttribute("href","tel:"+tel_m);
			t_tag.textContent = CommonHelper.maskFormat(tel, window.getApp().getPhoneEditMask());
			t_tag.setAttribute("title","Позвонить на номер "+t_tag.textContent);
			if(window.getWidthType()!="sm"){
				t_tag.setAttribute("tel",tel_m);
				EventHelper.add(t_tag,"click",function(e){
					e.preventDefault();
					window.getApp().makeCall(this.getAttribute("tel"));
				});
			}
			
			li_tag.appendChild(t_tag);
		}
		
		ul_tag.appendChild(li_tag);
	}	
	
	cell_n.appendChild(ul_tag);
}

AppBeton.prototype.TMInviteContact = function(contactRef, callBack){
	var pm = (new TmOutMessage_Controller()).getPublicMethod("tm_invite_contact");
	pm.setFieldValue("contact_id", contactRef.getKey("id"));
	window.setGlobalWait(true);
	pm.run({
		"all":function(){
			window.setGlobalWait(false);
			if(callBack){
				callBack();//disable controls
			}
		}
		,"ok":function(){
			window.showTempNote("Отправлено приглашение в Telegram",null,5000);
		}
	});
}


AppBeton.prototype.selectLoginRole = function(){
	var allowed_roles = this.getServVar("allowed_roles");
	if(!this.m_allowed_roles && !allowed_roles || !allowed_roles.length){
		return;
	}
	if(!this.m_allowed_roles && typeof(allowed_roles)=="string"){
		this.m_allowed_roles = CommonHelper.unserialize(allowed_roles);
	}
	if(!this.m_allowed_roles.length){
		return;
	}
	var role_id = this.getServVar("role_id");
	var opts = [];
	for(var i = 0; i < this.m_allowed_roles.length; i++){
		opts.push(
			new EditSelectOption("selectLoginRole:cont:role_id:" + this.m_allowed_roles[i].id,{
				"checked": (this.m_allowed_roles[i].id==role_id),
				"value": this.m_allowed_roles[i].id,
				"descr": this.m_allowed_roles[i].descr
			})			
		);
	}
	
	this.m_viewSelectLoginRole = new EditJSON("selectLoginRole:cont",{
		"elements":[
			new EditSelect("selectLoginRole:cont:role_id",{
				"addNotSelected": false,
				"elements": opts
			})
		]
	});
	var self = this;
	this.m_formSelectLoginRole = new WindowFormModalBS("selectLoginRole",{
		"content":this.m_viewSelectLoginRole,
		"cmdCancel":true,
		"cmdOk":true,
		"contentHead":"Смена роли пользователя",
		"onClickCancel":function(){
			self.closeSelectLoginRole();
		},
		"onClickOk":(function(self){
			return function(){
				var res = self.m_viewSelectLoginRole.getValueJSON();
				self.closeSelectLoginRole();
				if(!res||!res.role_id){
					throw new Error("Не указана роль!");
				}
				self.setSelectLoginRoleOnServer(res.role_id);
			}
		})(self)
	});
	this.m_formSelectLoginRole.open();

}

AppBeton.prototype.setSelectLoginRoleOnServer = function(roleId){
	if(roleId==this.getServVar("role_id")){
		this.closeSelectLoginRole();
		return;
	}
	const self = this;
	const pm = (new User_Controller()).getPublicMethod("select_login_role");
	pm.setFieldValue("role_id",roleId);
	pm.run({
		"ok":function(resp){
			if(resp){
				// let lsn = "";
				// const model = resp.getModel("Lsn_Model");
				// if(model && model.getNextRow()){
				// 	lsn = model.getFieldValue("lsn");
				// }
				// let h = document.location.href;
				// if(!h.includes("?")){
				// 	h+= "?";
				// }else {
				// 	h+= "&";
				// }
				// h+= "lsn=" + lsn;
				// document.location.href = encodeURI(h);			
				// document.location.href = document.location.href;
				console.log("redirecting:"+document.location.href)
			}
		}
	});
}

AppBeton.prototype.closeSelectLoginRole = function(){
	if(this.m_viewSelectLoginRole){
		this.m_viewSelectLoginRole.delDOM()
		delete this.m_viewSelectLoginRole;
	}
	if(this.m_formSelectLoginRole){
		this.m_formSelectLoginRole.delDOM();	
		delete this.m_formSelectLoginRole;			
	}
}

// Calculate min height
AppBeton.prototype.containerHeight = function() {
	var availableHeight = $(window).height() - $('.page-container').offset().top - $('.navbar-fixed-bottom').outerHeight();

	$('.page-container').attr('style', 'min-height:' + availableHeight + 'px');
}

AppBeton.prototype.panelToggle = function(panelNode) {	
	var $panelCollapse = $(panelNode).parent().parent().parent().parent().nextAll();
	$(panelNode).parents('.panel').toggleClass('panel-collapsed');
	$(panelNode).toggleClass('rotate-180');

	this.containerHeight(); // recalculate page height

	$panelCollapse.slideToggle(150);
}

AppBeton.prototype.panelSaveState = function(target) {
	if(target.id && window["localStorage"]){
		var v = localStorage.getItem(target.id);
		localStorage.setItem(target.id, (v==1)? 0 : 1);
	}
}

AppBeton.prototype.addCollapseOnClick = function(callbacks) {
	var self = this;
	
	// Hide if collapsed by default
	$('.panel-collapsed').children('.panel-heading').nextAll().hide();


	// Rotate icon if collapsed by default
	$('.panel-collapsed').find('[data-action=collapse]').addClass('rotate-180');
	
	// Collapse on click
	$('.panel [data-action=collapse]').click(function (e) {
		e.preventDefault();
		
		if(callbacks && callbacks[e.target.id] && DOMHelper.hasClass(e.target, "rotate-180")){
			var panel_cont = this;
			callbacks[e.target.id].call(this, function(){
				self.panelToggle(panel_cont);
				self.panelSaveState(e.target);
			});
		}else{
			self.panelToggle(this);
			self.panelSaveState(e.target);
		}
		
	});
	
	if(window["localStorage"]){
		var panels = DOMHelper.getElementsByAttr("collapse", document.body, "data-action", false);
		for(var i = 0; i <  panels.length; i++){
			if(panels[i].id){
				var v = localStorage.getItem(panels[i].id);				
				//collapsed
				if(v == 1){
					self.panelToggle(panels[i]);
				}
			}
		}
	}
}

AppBeton.prototype.initViewPanels = function(view) {
	var self_id = view.getId();
	
	if(window["localStorage"]){
		var p_order = localStorage.getItem(self_id + "PanelOrder");
		if(p_order){
			panel_order = CommonHelper.unserialize(p_order);
			//set custom order
			var l = DOMHelper.getElementsByAttr("draggable", view.m_node, "class", false);
			for(i = 0; i < panel_order.length; i++){				
				var n = document.getElementById(panel_order[i]);
				if(n){
					n.parentNode.append(n);
				}
			}			
		}
	}
//console.log(self_id + ":panelCont")	
	DOMHelper.show(self_id + ":panelCont");
	
	//dragging
	view.m_panels = [];
	var l = DOMHelper.getElementsByAttr("draggable", view.m_node, "class", false);
	for(i = 0; i < l.length; i++){
		var obj = {
			"drag": new DragObject(l[i],{"offsetY":0,"offsetX":0}),
			"drop": new DropTarget(l[i])
		};
		/*obj.drag.onDragFail = function(dropObject){
			console.log("dropObject=",dropObject)
			console.log("drag=",this)
		}*/		
		obj.drop.accept = function(dragObject) {
			var drag_n = dragObject.element;
			drag_n.parentNode.insertBefore(drag_n, this.element);
			if(window["localStorage"]){
				var p_order = [];
				var l = DOMHelper.getElementsByAttr("draggable", drag_n.parentNode, "class", false);
				for(i = 0; i < l.length; i++){
					p_order.push(l[i].id)					
				}
				localStorage.setItem(self_id + "PanelOrder", CommonHelper.serialize(p_order));
			}
		};				
		view.m_panels.push(obj);
	}

}

//chat: tm|chat
AppBeton.prototype.getChatFileRef = function(chatFolder, fileId){
	return "output/" + chatFolder + "/" + fileId;
}


AppBeton.prototype.htmlTagVideo = function(msg, chat) {
	var href = this.getChatFileRef(chat, msg.video.file_unique_id);
	var mimeType = msg.video.mime_type;
	var w = msg.video.width
	var h = msg.video.height;
	var caption = (msg.caption && msg.caption.length)? msg.caption : "Видео";
	
	var tag = document.createElement("a");
	tag.href = "#";
	tag.textContent = (caption && caption.length)? caption : "Видео";
	tag.title = "Кликните для открытия видео";
	
	EventHelper.add(tag, "click", (function(href, mimeType, w, h){
		return function(){
			var win = window,
			    doc = document,
			    docElem = doc.documentElement,
			    body = doc.getElementsByTagName('body')[0],
			    x = (win.innerWidth || docElem.clientWidth || body.clientWidth) - 10,
			    y = (win.innerHeight|| docElem.clientHeight|| body.clientHeight) - 150;
			var img_w = w;
			var img_h = h;
			if(y < h){														
				var k = y / h;
				img_h = y;
				img_w = Math.round(img_h * k);
			}
			
			(new WindowFormModalBS("TmRes",{
				"dialogWidth":y + "px",
				"cmdOk":true,
				"cmdCancel":false,		
				"onClickOk":function(){
					this.close();
				},
				"cmdClose":true,
				"content":new ControlContainer("TmRes:view", "VIDEO", {
					"elements":[
						new Control("TmRes:view:source", "source", {
							"attrs":{
								"src": href,
								"type": mimeType
							}
						})
					],
					"attrs":{
						"class": "video-js",
						"controls":"controls",
						"data-setup":"{}",
						"preload": "auto",
						"width": img_w,
						"height": img_h
					}
				})
			})).open();
			
		}
	})(href,
		mimeType,
		w,
		h
	));
	
	return tag;
}

AppBeton.prototype.htmlTagAudio = function(msg, tagId, chat) {
	var recHref = this.getChatFileRef(chat, msg[tagId].file_unique_id);
	var caption = (msg.caption && msg.caption.length)? msg.caption : "Аудио файл";
	
	var tag = document.createElement("audio");
	tag.setAttribute("controls", null);
	tag.setAttribute("src", recHref);
	
	var subst = document.createElement("A");
	subst.setAttribute("href", recHref);
	subst.setAttribute("target","_blank");
	subst.textContent = caption;
	
	tag.appendChild(subst);	
	return tag;
}

AppBeton.prototype.htmlTagDocument = function(msg, chat) {
	if(!msg.document) {
		return;
	}
	var caption = (msg.caption && msg.caption.length)? msg.caption : (msg.document.file_name? msg.document.file_name : "Документ");
	var href = this.getChatFileRef(chat, msg.document.file_unique_id);

	var tag = document.createElement("A");
	tag.textContent = caption;
	tag.href = href;	
	if(msg.document.file_name){
		tag.download = msg.document.file_name;
		
	}else if(msg.document.mime_type){
		tag.download = "Документ." + this.FILE_MIME_TYPES[msg.document.mime_type];
	}

	if(msg.document && msg.document.thumb){
		//preview image
		tag.target = "_blank";

		var prHref = this.getChatFileRef(chat, msg.document.thumb.file_unique_id);
		var prW = msg.document.thumb.width;
		var prH = msg.document.thumb.height; 

	
		var img = document.createElement("IMG");
		img.src = prHref;
		img.width = prW;
		img.height = prH;
		img.alt = "<файл не найден>";	
		tag.appendChild(img);											

	}else if(msg.document.file_name && (!caption || !caption.length)){
		//no preview
		tag.textContent = msg.document.file_name;

	}else if (msg.document.file_name){
		var img = document.createElement("IMG");
		img.src = "img/paperClip.png";
		img.width = 30;
		img.height = 30;
		img.alt = "<файл не найден>";	
		tag.appendChild(img);											
	}
	return tag;
}

AppBeton.prototype.htmlTagPhoto = function(msg, chat) {
	var prHref = this.getChatFileRef(chat, msg.photo[0].file_unique_id);
	var prW = msg.photo[0].width;
	var prH = msg.photo[0].height; 
	var href = this.getChatFileRef(chat, msg.photo[msg.photo.length-1].file_unique_id);
	var w = msg.photo[msg.photo.length-1].width;
	var h = msg.photo[msg.photo.length-1].height; 
	var caption = (msg.caption && msg.caption.length)? msg.caption : "Фото";
	
	var tag = document.createElement("A");
	tag.textContent = caption;
	
	var img = document.createElement("IMG");
	img.src = prHref;
	img.width = prW;
	img.height = prH;
	img.alt = "<файл не найден>";
	//img.style = "cursor:pointer;";
	tag.appendChild(img);												

	//click
	EventHelper.add(tag, "click", (function(href, w, h){
		return function(){
			var win = window,
			    doc = document,
			    docElem = doc.documentElement,
			    body = doc.getElementsByTagName('body')[0],
			    x = (win.innerWidth || docElem.clientWidth || body.clientWidth) - 10,
			    y = (win.innerHeight|| docElem.clientHeight|| body.clientHeight) - 150;
			var img_w = w;
			var img_h = h;
			if(y < h){														
				var k = y / h;
				img_h = y;
				img_w = Math.round(img_h * k);
			}
			(new WindowFormModalBS("TmRes",{
				"dialogWidth":y + "px",
				"cmdOk":true,
				"cmdCancel":false,		
				"onClickOk":function(){
					this.close();
				},
				"cmdClose":true,
				"content":new Control("TmRes:view", "IMG", {
					"attrs":{
						"src": href,
						"width": img_w,
						"height": img_h
					}
				})
			})).open();
		}
	})(
		href,
		w,
		h
	));
	
	return tag;
}

AppBeton.prototype.htmlTagSticker = function(msg, chat) {
	var prHref = this.getChatFileRef(chat, msg.sticker.thumbnail.file_unique_id);
	var prW = msg.sticker.thumbnail.width;
	var prH = msg.sticker.thumbnail.height; 
	var href = this.getChatFileRef(chat, msg.sticker.file_unique_id);
	var w = msg.sticker.width;
	var h = msg.sticker.height; 
	var caption = (msg.caption && msg.caption.length)? msg.caption : "Стикер";
	
	var tag = document.createElement("A");
	tag.textContent = caption;
	
	var img = document.createElement("IMG");
	img.src = prHref;
	img.width = prW;
	img.height = prH;
	img.alt = "<файл не найден>";
	//img.style = "cursor:pointer;";
	tag.appendChild(img);												

	//click
	EventHelper.add(tag, "click", (function(href, w, h){
		return function(){
			var win = window,
			    doc = document,
			    docElem = doc.documentElement,
			    body = doc.getElementsByTagName('body')[0],
			    x = (win.innerWidth || docElem.clientWidth || body.clientWidth) - 10,
			    y = (win.innerHeight|| docElem.clientHeight|| body.clientHeight) - 150;
			var img_w = w;
			var img_h = h;
			if(y < h){														
				var k = y / h;
				img_h = y;
				img_w = Math.round(img_h * k);
			}
			(new WindowFormModalBS("TmRes",{
				"dialogWidth":y + "px",
				"cmdOk":true,
				"cmdCancel":false,		
				"onClickOk":function(){
					this.close();
				},
				"cmdClose":true,
				"content":new Control("TmRes:view", "IMG", {
					"attrs":{
						"src": href,
						"width": img_w,
						"height": img_h
					}
				})
			})).open();
		}
	})(
		href,
		w,
		h
	));
	
	return tag;
}

AppBeton.prototype.addVideoPlayerSupport = function() {
	import('https://vjs.zencdn.net/8.10.0/video-js.css');
	import('https://vjs.zencdn.net/8.10.0/video.min.js');
}

AppBeton.prototype.tmMessageFormat = function(fields, cell) {
	var msg = fields["message"].getValue();
	let chat = "tm";
	
	if(msg.sticker){
		var tag = window.getApp().htmlTagSticker(msg, chat);
		cell.getNode().appendChild(tag);
		
	}else if(msg.document){
		var tag = window.getApp().htmlTagDocument(msg, chat);
		cell.getNode().appendChild(tag);	
	
	}else if(msg.video){	
		var tag = window.getApp().htmlTagVideo(msg, chat);
		cell.getNode().appendChild(tag);
													
	}else if(msg.audio){
		var tag = window.getApp().htmlTagAudio(msg, "audio", chat);
		cell.getNode().appendChild(tag);	
		
	}else if(msg.voice){
		var tag = window.getApp().htmlTagAudio(msg, "voice", chat);
		cell.getNode().appendChild(tag);	
		
	}else if(msg.animation){
		var tag = window.getApp().htmlTagVideo(msg, chat);
		cell.getNode().appendChild(tag);
		
	}else if(msg.text){	
		return msg.text;
	
	}else if(msg.photo && CommonHelper.isArray(msg.photo) && msg.photo.length){	
		var tag = window.getApp().htmlTagPhoto(msg);
		cell.getNode().appendChild(tag);
	}
	return "";
}

AppBeton.prototype.getChatStatusRef = function() {
	if(!this.m_chatStatusRef){
		this.m_chatStatusRef = CommonHelper.unserialize(this.getServVar("chat_statuses_ref"));
	}
	return this.m_chatStatusRef;
}

//controlePumpVehicle returns true if for this role
//pump vehicle extra parameters are controled.
AppBeton.prototype.controlePumpVehicle = function() {
	let role_id = this.getServVar("role_id");
	return !(role_id == "admin" || role_id == "boss" || role_id == "owner");
}

/**
 * cont is for context, for massage being shown in context window not in parent
 */
AppBeton.prototype.openHrefDownload = function(cont, pm, viewId, href){
	var wnd = pm.openHref(viewId, href);
	if(pm.fieldExists("inline") && (!wnd || !wnd.top)){
		pm.setFieldValue("inline", 0);
		pm.download();	
		cont.showTempWarn("Всплывающие окна заблокированы, файл открыт в режиме скачивания",null,10000);
	}

}

//online-offline
AppBeton.prototype.m_offLineWarnTimer;
AppBeton.prototype.MSG_ONLINE = "Интернет соединение воосстановлено.";
AppBeton.prototype.MSG_OFFLINE = "Нет соединения, работа в автономном режиме. Некоторые функции не доступны.";
AppBeton.prototype.MSG_OFFLINE_THROTLE = 5*60*1000;
AppBeton.prototype.MSG_DURATION = 10*1000;

AppBeton.prototype.initWorkers = function(){	
	const self = this;
	console.log("AppBeton.initWorkers")
	if ('serviceWorker' in navigator) {
		navigator.serviceWorker.register("sw.js")
		.then(reg => {
			console.log('Service Worker registered')
			 // listen for messages from SW
			navigator.serviceWorker.addEventListener('message', event => {
				const msg = event.data;
				if (!msg || !msg.type) return;

				if (msg.type === 'OFFLINE') {
					self.setOffline();

				}else if (msg.type === 'ONLINE') {
					self.setOnline();
				}
			});
		}).catch(
			err => {
				window.showTempError('ServiceWorker registration failed:', null, 10000);					
			}
		);
	}

	window.addEventListener('online', () => {
		self.setOnline();
	});

	window.addEventListener('offline', () => {
		self.setOffline();
	});
}

AppBeton.prototype.setOffline = function(){
	const isOffline = !DOMHelper.visible("main-menu");

	if(this.m_offLineWarnTimer && isOffline){
		return;
	}

	this.enableControlsForOnline(false);
	window.showTempError(this.MSG_OFFLINE, null, this.MSG_DURATION);					

	if(!this.m_offLineWarnTimer){
		this.m_offLineWarnTimer = setInterval(
			() => {
				window.showTempWarn(this.MSG_OFFLINE, null, this.MSG_DURATION);					
			},
			this.MSG_OFFLINE_THROTLE
		);
	}
}

AppBeton.prototype.setOnline = function(){
	window.showTempOk(this.MSG_ONLINE, null, this.MSG_DURATION);					
	if(this.m_offLineWarnTimer){
		clearInterval(this.m_offLineWarnTimer);
	}
	this.enableControlsForOnline(true);
}

AppBeton.prototype.enableControlsForOnline = function(en){
	if(!en){
		DOMHelper.hide("main-menu");
		DOMHelper.hide("user-menu");
		DOMHelper.disable("OrderMakeList:order_make_filter:downFast");
		DOMHelper.disable("OrderMakeList:order_make_filter:down");
		DOMHelper.disable("OrderMakeList:order_make_filter:upFast");
		DOMHelper.disable("OrderMakeList:order_make_filter:up");
		DOMHelper.disable("OrderMakeList:order_make_grid:order_make_grid:cmd:insert");
		DOMHelper.disable("OrderMakeList:order_make_grid:order_make_grid:cmd:allCommands");
		DOMHelper.show("offline-mode-alert");
		// const n = document.getElementById("OrderMakeList:order_make_grid:body");
		// if(n){
		// 	const sh = DOMHelper.getElementsByAttr("detailToggle", n, "class", false);
		// 	if(sh && sh.length){
		// 		sh.forEach(n => {
		// 			DOMHelper.hide(n);
		// 		});
		// 	}
		// }
	}else{
		DOMHelper.hide("offline-mode-alert");
		DOMHelper.show("main-menu");
		DOMHelper.show("user-menu");
		DOMHelper.enable("OrderMakeList:order_make_filter:downFast");
		DOMHelper.enable("OrderMakeList:order_make_filter:up");
		DOMHelper.enable("OrderMakeList:order_make_filter:upFast");
		DOMHelper.enable("OrderMakeList:order_make_filter:up");
		DOMHelper.enable("OrderMakeList:order_make_grid:order_make_grid:cmd:insert");
		DOMHelper.enable("OrderMakeList:order_make_grid:order_make_grid:cmd:allCommands");
		// const n = document.getElementById("OrderMakeList:order_make_grid:body");
		// if(n){
		// 	const sh = DOMHelper.getElementsByAttr("detailToggle", n, "class", false);
		// 	if(sh && sh.length){
		// 		sh.forEach(n => {
		// 			DOMHelper.hide(n);
		// 		});
		// 	}
		// }
	}
}
