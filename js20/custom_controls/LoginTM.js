/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022
 
 * @class
 * @classdesc
	
 * @param {string} id view identifier
 * @param {namespace} options
 * @param {namespace} options.models All data models
 * @param {namespace} options.variantStorage {name,model}
 */	
function LoginTM(id,options){	
	
	options = options || {};
	
	var self = this;
	options.addElement = function(){
		this.addElement(new ErrorControl(id+":error"));
		
		this.addElement(new Control(id+":userData"));
		this.addElement(new Control(id+":userPhoto"));
		
		this.addElement(
			new EditPhone(id+":tel",{
				"cmdClear":false,
				"focus":true,
				// "editContClassName": "input-group "+window.getBsCol(12),
				"editContClassName": "",
				"events":{
					"keyup":function(){
						var t = self.getElement("tel").getValue();
						if(t && t.length==10){
							self.setTel(t);
						}
					}
				}
			})
		);
		
		this.addElement(
			new ButtonCmd(id+":check_code",{
				"onClick":function(){
					self.checkCode();
				}
			})
		);
	}

	LoginTM.superclass.constructor.call(this,id,options);	
}

extend(LoginTM,ViewAjx);

LoginTM.prototype.m_tel;
LoginTM.prototype.m_timeLeft;

LoginTM.prototype.toDOM = function(p){
	LoginTM.superclass.toDOM.call(this,parent);

	var tm_tel = CommonHelper.getCookie("tm_tel");
	if(tm_tel){
		var tm_photo;
		if(window["localStorage"]){
			tm_photo = localStorage.getItem('tm_photo');
		}
		this.setUserDataCtrl(tm_tel, CommonHelper.getCookie("tm_first_name"), tm_photo);
	}
	const self = this;
	// EventHelper.add("tm_сode1", "keyup", function(e){
	// 		console.log("code1")
	// 	e.preventDefault();
	// 	e.stopPropagation();
	// 	var v = document.getElementById("tm_сode1").value;
	// 	var key = e.keyCode || e.charCode;
	// 	if( key == 13 || key == 39 || key == 9 || (v && v.length) ){
	// 		console.log("code1 next")
	// 		//right,tab,any digit
	// 		const n = document.getElementById("tm_сode2");
	// 		n.focus();
	// 		n.select();
	// 	}
	// });
	// EventHelper.add("tm_сode2", "keydown", function(e){
	// 		console.log("code2")
	// 	var v = document.getElementById("tm_сode2").value;
	// 	var key = e.keyCode || e.charCode;
	// 	if(key == 37) {
	// 		console.log("code2 37")
	// 		//left
	// 		const n = document.getElementById("tm_сode1");
	// 		n.focus();
	// 		n.select();
	//
	// 	}else if( (key == 8 ||key == 46) && (!v || !v.length)){
	// 		//del
	// 		console.log("code2 delete")
	// 		const n = document.getElementById("tm_сode1");
	// 		n.value = "";
	// 		n.focus();
	//
	// 	}else if(key == 13 || key == 39 || key == 9 || (v && v.length)){
	// 		console.log("code2 next")
	// 		//right,tab
	// 		const n = document.getElementById("tm_сode3");
	// 		n.focus();
	// 		n.select();
	// 	}
	// });
	// EventHelper.add("tm_сode3", "keyup", function(e){
	// 	var v = document.getElementById("tm_сode3").value;
	// 	var key = e.keyCode || e.charCode;
	// 	if(key == 37 || key == 8 ||key == 46){
	// 		//left, del
	// 		document.getElementById("tm_сode2").focus();
	//
	// 	}else if(v && v.length){
	// 		self.submitCode();
	// 	}
	// });
    // const inputs = document.querySelectorAll("input[id^='tm_code']");
	const inputs = DOMHelper.getElementsByAttr("tmCode", document.body, "class", false);
	// console.log("INPUTS:",inputs)
	//
   function checkAndSubmit() {
        if ([...inputs].every(input => input.value.length === 1)) {
			self.submitCode();
        }
    }

    inputs.forEach((input, index) => {
		console.log("iterating inputs")
        input.addEventListener("keydown", function (event) {
            const key = event.key;
            
			event.preventDefault();
            if (key >= "0" && key <= "9") {
                // event.preventDefault();
                input.value = key;
                if (index < inputs.length - 1) {
                    inputs[index + 1].focus();
                    inputs[index + 1].select();
                }
				checkAndSubmit();

            } else if (key === "Backspace" || key === "Delete") {
                if (input.value === "") {
                    if (index > 0) {
                        inputs[index - 1].focus();
                        inputs[index - 1].value = "";
                        inputs[index - 1].select();
                    }
                } else {
                    input.value = "";
                }
                // event.preventDefault();
            } else if (key === "ArrowRight") {
                if (index < inputs.length - 1) {
                    inputs[index + 1].focus();
                    inputs[index + 1].select();
                }
            } else if (key === "ArrowLeft") {
                if (index > 0) {
                    inputs[index - 1].focus();
                    inputs[index - 1].select();
                }
            } else if (key === "Tab") {
                // event.preventDefault();
                if (index < inputs.length - 1) {
                    inputs[index + 1].focus();
                    inputs[index + 1].select();
                }
            }
        });
    });	
	//check left time
	var tm_l = CommonHelper.getCookie("tm_time_left");
	if( tm_l || CommonHelper.getCookie("tm_code_time_left")){
		if(tm_l){
			this.checkCodeContCont();
		}else{
			DOMHelper.show(this.getId()+":codeInput");
			document.getElementById("tm_сode1").focus();		
			this.setSubmitText("Запросить код повторно")
		}
		
	}else if(tm_tel && tm_tel.length>=10){
		CommonHelper.unsetCookie("tm_time_left");
		var pm = (new User_Controller()).getPublicMethod("tm_get_left_time");
		pm.setFieldValue("tel", tm_tel);
		pm.run({
			"ok":function(resp){
				var m = resp.getModel("TmLeftTime_Model");
				if (m.getNextRow()){
					var set_code_left_time = function(m){
						var c_lt = parseInt(m.getFieldValue("code_left_time"), 10);
						if(c_lt){
							document.cookie = 'tm_code_time_left='+c_lt+'; Path=/; max-age='+c_lt+';';
						}
						return c_lt;
					}
					
					var lt = parseInt(m.getFieldValue("left_time"), 10);					
					if(lt){
						lt+= 2;
						document.cookie = 'tm_time_left='+lt+'; Path=/; max-age='+lt+';';
						set_code_left_time(m);
						self.checkCodeContCont();
						
					}else if (set_code_left_time(m)){
						self.checkCodeContCont();
					}
				}
			}
			,"fail":function(resp,errCode,errStr){
				self.setError(errStr);
			}
		});	
	}
}


LoginTM.prototype.setError = function(s){
	this.getElement("error").setValue(s);
}

LoginTM.prototype.setSubmitText = function(t){
	DOMHelper.setText(this.getId()+":check_code", t);
}

LoginTM.prototype.setSubmitLeftTime = function(){
	var t_m = Math.floor(this.m_timeLeft / 60);
	var t_s = this.m_timeLeft - t_m*60;
	this.setSubmitText("Запросить код повторно через "+((t_m>9)? t_m.toString():"0"+t_m.toString())+":"+((t_s>9)? t_s.toString():"0"+t_s.toString()));
}

LoginTM.prototype.checkCodeCont = function(){
	var pm = (new User_Controller()).getPublicMethod("tm_send_code");
	pm.setFieldValue("tel", this.m_tel);
	var self = this;
	pm.run({
		"ok":function(resp){
			self.checkCodeContCont();
		}
		,"fail":function(resp,errCode,errStr){
			self.setError(errStr);
			self.unsetUserData();
		}
	});
}

LoginTM.prototype.clearCode = function(){
	DOMHelper.setText("tm_сode1", "");
	DOMHelper.setText("tm_сode2", "");
	DOMHelper.setText("tm_сode3", "");
	document.getElementById("tm_сode1").focus();
}

LoginTM.prototype.checkCodeContCont = function(){
	var self = this;
	this.clearCode();	
	DOMHelper.show(this.getId()+":codeInput");
	this.m_timeLeft = CommonHelper.getCookie("tm_time_left");
	if(!this.m_timeLeft){
		this.m_timeLeft = CommonHelper.getCookie("tm_duration_sec");
		if(!this.m_timeLeft){
			this.m_timeLeft = 120;
		}
	}else{
		CommonHelper.unsetCookie("tm_time_left");
	}
	var ctrl = this.getElement("check_code");
	//DOMHelper.delNode("tmSubmitPic");
	this.setSubmitLeftTime();
	ctrl.setEnabled(false);
	document.getElementById("tm_сode1").focus();
	this.m_timeInterval = setInterval(function(){
		self.m_timeLeft--;
		var ctrl = self.getElement("check_code");
		if(self.m_timeLeft==0){
			clearInterval(self.m_timeInterval);
			self.setSubmitText("Запросить код повторно");
			ctrl.setAttr("title", "Запросить новый код авторизации");
			ctrl.setEnabled(true);
		}else{
			self.setSubmitLeftTime();
		}
	}, 1000);
}

LoginTM.prototype.checkCode = function(){
	//check tel
	var t = this.getCorrectTel();
	if(!t){
		return;
	}
	this.setError("");
	if(this.m_tel && this.m_tel!=t){
		//new number
		this.setTel(t, function(){
			self.checkCodeCont();
		});
	}else{
		this.m_tel = t;
		this.checkCodeCont();
	}
}

LoginTM.prototype.unsetUserData = function(){
	CommonHelper.unsetCookie("tm_tel");
	CommonHelper.unsetCookie("tm_first_name");
	if(window["localStorage"]){
		localStorage.removeItem('tm_photo');
	}
	CommonHelper.unsetCookie("tm_duration_sec");
	this.unsetUserDataCtrl();
}

LoginTM.prototype.setUserDataCtrl = function(tel, name, photo){
	this.m_tel = tel;
	this.getElement("tel").setValue(tel? tel : "");
	this.getElement("userData").setValue(name? name:"");
	if(photo){
		this.getElement("userPhoto").setAttr("src", "data:image/png;base64, "+photo);
	}
	this.getElement("userPhoto").setVisible(photo? true:false);
}

LoginTM.prototype.unsetUserDataCtrl = function(){
	this.getElement("userData").setValue("");
	this.getElement("userPhoto").setAttr("src", "");
	this.getElement("userPhoto").setVisible(false);
}

LoginTM.prototype.setUserData = function(uData){
	var tm_tel = uData.tel.getValue();
	var tm_first_name = uData.first_name.getValue();
	var tm_photo = uData.tm_photo.getValue();
	if(window["localStorage"]){
		localStorage.setItem('tm_photo', tm_photo);
	}
	CommonHelper.setCookie("tm_tel", tm_tel, uData.tel_duration_sec.getValue());
	CommonHelper.setCookie("tm_first_name", tm_first_name, uData.tel_duration_sec.getValue());	
	CommonHelper.setCookie("tm_duration_sec", uData.duration_sec.getValue(), uData.tel_duration_sec.getValue());	
	this.setUserDataCtrl(tm_tel, tm_first_name, tm_photo);
}

LoginTM.prototype.setTel = function(t, callback){
	this.setError("");
	var self = this;
	var pm = (new User_Controller()).getPublicMethod("tm_check_tel");
	pm.setFieldValue("tel", t);
	pm.run({
		"ok":function(resp){
			var m = resp.getModel("TmUserData_Model");
			if (m.getNextRow()){
				self.setUserData(m.getFields());
				if(m.getFieldValue("code_exists") == "1"){
					var lt = parseInt(m.getFieldValue("left_time"), 10);					
					if(lt){
						lt+= 2;
						document.cookie = 'tm_time_left='+lt+'; Path=/; max-age='+lt+';';
					}
					self.checkCodeContCont();
				}
				if(callback)callback();
			}
		}
		,"fail":function(resp,errCode,errStr){
			self.setError(errStr);
			self.unsetUserData();
		}
	});

}

LoginTM.prototype.getCorrectTel = function(){	
	var tel = this.getElement("tel").getValue();
	if(!tel || tel.length!=10){
		this.unsetUserData();
		this.setError("Неверный номер!");
		return undefined;
	}
	return tel;
}

LoginTM.prototype.submitCode = function(){	
	if(!this.m_tel){
		return;
	}
	var code = DOMHelper.getText("tm_сode1") + DOMHelper.getText("tm_сode2") + DOMHelper.getText("tm_сode3");	
	if(!code || code.length!=3){
		this.setError("Код не введен");
		return;
	}
	var pm = (new User_Controller()).getPublicMethod("tm_check_code");
	pm.setFieldValue("code", code);
	pm.setFieldValue("tel", this.m_tel);
	var self = this;
	pm.run({
		"ok":function(resp){
			var m = resp.getModel("Auth_Model");
			if (m.getNextRow()){
				document.location.href = window.location.href;
			}
		}
		,"fail":function(resp,errCode,errStr){
			self.setError(errStr);
			self.clearCode();
		}
	});
}
