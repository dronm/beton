/**
 * Запрос кода для авторизации
 */
var UserCode = {
	show:function(tel){
		var self = this;
		this.m_tel = tel;
		this.m_view = new ControlContainer("UserCode", "DIV", {
			"addElement":function(){
				this.addElement(new EditNum("UserCode:code",{
					"cmdClear":false,
					"maxLength":3,
					"focus":true,
					"events":{
						"keyup":function(e){
							var c = self.m_view.getElement("code").getValue();
							if(c && c.length==3){
								self.setCode();
							}
						}
					}
				}));
				this.addElement(new Control("UserCode:leftTime","DIV"));
			}
		});
		this.m_form = new WindowFormModalBS(CommonHelper.uniqid(),{
			/*"onClickOk":function(){
				self.m_form.close();
			},*/
			"content":this.m_view,
			"contentHead":"Введите код авторизации из Telegram"
		});

		this.m_form.open();
		
		var self = this;
		self.m_timeLeft = 120;
		setInterval(function(){
			self.m_timeLeft--;
			self.m_view.getElement("leftTime").setValue("Осталось секунд: "+self.m_timeLeft);
			if(self.m_timeLeft==0){
				self.m_form.close();
			}
		}, 1000);
	}
	,"setCode": function(){
		var self = this;
		var ctrl = this.m_view.getElement("code");
		var t = ctrl.getValue();
		var pm = (new User_Controller()).getPublicMethod("tm_check_code");
		pm.setFieldValue("code", t);
		pm.setFieldValue("tel", this.m_tel);
		this.m_view.setEnabled(false);
		pm.run({
			"ok":function(resp){
				var m = resp.getModel("Auth_Model");
				if (m.getNextRow()){
					document.location.href = window.location.href;
				}
			}
			,"fail":function(resp,errCode,errStr){
				self.m_view.setEnabled(true);
				ctrl.setNotValid(errStr);
			}
		});
	
	}
}
