/**
 * Запрос номера телефона для авторизации
 */
var UserTel = {
	show:function(){
		var self = this;
		this.m_view = new ControlContainer("UserTel", "DIV", {
			"elements":[
				new EditPhone("tel",{
					"cmdClear":false,
					"focus":true,
					"events":{
						"keydown":function(e){
							e = EventHelper.fixKeyEvent(e);
							if (e.keyCode==13){
								self.setTelCtrl();
							}						
						}
					}
				})
			]
		});
		this.m_form = new WindowFormModalBS(CommonHelper.uniqid(),{
			"cmdCancel":true,
			"controlCancelCaption":"Отмена",
			"controlCancelTitle":"Отмена",
			"cmdOk":true,
			"onClickOk":function(){
				self.setTelCtrl();
			},
			"onClickCancel":function(){
				self.m_form.close();
			},		
			"content":this.m_view,
			"contentHead":"Номер телефона"
		});

		this.m_form.open();
	
	},
	"setUserData": function(uData){
		//modify button, set cookie
		
		document.cookie = 'tm_tel='+encodeURIComponent(uData.tel.getValue())+'; Path=/; max-age='+uData.tel_duration_sec.getValue()+';';
		document.cookie = 'tm_first_name='+encodeURIComponent(uData.first_name.getValue())+'; Path=/; max-age='+uData.tel_duration_sec.getValue()+';';								
		
		var n = document.getElementById("Login:submit_login_tm");
		if(n){
			DOMHelper.setText(n, " Сообщение в Telegram для "+uData.first_name.getValue())
		}
	},
	"setTelCtrl": function(){
		var tel_ctrl = this.m_view.getElement("tel");
		var t = tel_ctrl.getValue();
		
		if(!t || t.length!=10){
			tel_ctrl.setNotValid("Неверный номер");
			return;
		}
		tel_ctrl.setValid();
		this.setTel(t);
	},
	
	"setTel": function(t){
		var self = this;
		var pm = (new User_Controller()).getPublicMethod("tm_check_tel");
		pm.setFieldValue("tel", t);
		pm.run({
			"ok":function(resp){
				var m = resp.getModel("TmUser_Model");
				if (m.getNextRow()){
					self.setUserData(m.getFields());
					if(self.m_form){
						self.m_form.close();
					}
					UserCode.show(m.getFieldValue("tel"));
				}
			}
			,"fail":function(resp,errCode,errStr){
				if(self.m_form){
					self.m_view.getElement("tel").setNotValid(errStr);
				}else{
					UserCode.show(t);
				}
			}
		});
	}
}
