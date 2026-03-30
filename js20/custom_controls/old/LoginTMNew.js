
/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022
 
 * @class
 * @classdesc
	
 * @param {string} id view identifier
 * @param {namespace} options
 * @param {namespace} options.models All data models
 * @param {namespace} options.variantStorage {name,model}
 */
function LoginTM(id, options) {

	options = options || {};

	var self = this;
	options.addElement = function() {
		this.addElement(new ErrorControl(id + ":error"));

		this.addElement(new Control(id + ":userData"));
		this.addElement(new Control(id + ":userPhoto"));

		this.addElement(
			new EditPhone(id + ":tel", {
				"cmdClear": false,
				"focus": true,
				// "editContClassName": "input-group "+window.getBsCol(12),
				"editContClassName": "",
				"events": {
					"keyup": function() {
						var t = self.getElement("tel").getValue();

						self.m_telResolved = false;
						self.m_tel = null;
						self.updateSubmitAvailability();

						if (t && t.length == 10) {
							self.setTel(t);
						} else {
							self.unsetUserData();
						}
					}
				}
			})
		);

		this.addElement(
			new ButtonCmd(id + ":check_code", {
				"onClick": function() {
					self.checkCode();
				}
			})
		);
	}

	LoginTM.superclass.constructor.call(this, id, options);
}

extend(LoginTM, ViewAjx);

LoginTM.prototype.m_tel;
LoginTM.prototype.m_timeLeft;

LoginTM.prototype.m_timeInterval = null;
LoginTM.prototype.m_telResolved = false;
LoginTM.prototype.m_requestInFlight = false;
LoginTM.prototype.m_submitInFlight = false;
LoginTM.prototype.m_timerLocksSubmit = false;

LoginTM.prototype.getSubmitBtnEl = function() {
	return document.getElementById(this.getId() + ":check_code");
};

LoginTM.prototype.setSubmitBtnEnabled = function(enabled) {
	var ctrl = this.getElement("check_code");
	var btn = this.getSubmitBtnEl();

	if (ctrl && ctrl.setEnabled) {
		ctrl.setEnabled(enabled);
	}

	if (btn) {
		if (enabled) {
			btn.classList.remove("tm-btn-disabled");
			btn.setAttribute("aria-disabled", "false");
		} else {
			btn.classList.add("tm-btn-disabled");
			btn.setAttribute("aria-disabled", "true");
		}
	}
};

LoginTM.prototype.updateSubmitAvailability = function() {
	var enabled =
		!!this.m_telResolved &&
		!this.m_requestInFlight &&
		!this.m_submitInFlight &&
		!this.m_timerLocksSubmit;

	this.setSubmitBtnEnabled(enabled);
};

LoginTM.prototype.getCodeInputs = function() {
	return [
		document.getElementById("tm_сode1"),
		document.getElementById("tm_сode2"),
		document.getElementById("tm_сode3")
	].filter(function(input) {
		return !!input;
	});
};

LoginTM.prototype.focusCodeInput = function(index) {
	var inputs = this.getCodeInputs();
	if (inputs[index]) {
		inputs[index].focus();
		inputs[index].select();
	}
};

LoginTM.prototype.getCodeValue = function() {
	return this.getCodeInputs().map(function(input) {
		return (input.value || "").replace(/\D/g, "").slice(0, 1);
	}).join("");
};

LoginTM.prototype.setFormInputsDisabled = function(disabled) {
	var form = document.getElementById(this.getId());
	if (!form) {
		return;
	}

	var inputs = form.querySelectorAll("input");
	for (var i = 0; i < inputs.length; i++) {
		inputs[i].disabled = disabled;
	}
};

LoginTM.prototype.resetCodeState = function() {
	if (this.m_timeInterval) {
		clearInterval(this.m_timeInterval);
		this.m_timeInterval = null;
	}

	this.m_timerLocksSubmit = false;

	var codeCont = document.getElementById(this.getId() + ":codeInput");
	if (codeCont) {
		codeCont.classList.add("hidden");
	}

	this.clearCode();
	this.setSubmitText("Отправить код");
};

LoginTM.prototype.toDOM = function(p) {
	LoginTM.superclass.toDOM.call(this, p);

	var tm_tel = CommonHelper.getCookie("tm_tel");
	if (tm_tel) {
		var tm_photo;
		if (window["localStorage"]) {
			tm_photo = localStorage.getItem("tm_photo");
		}
		this.setUserDataCtrl(tm_tel, CommonHelper.getCookie("tm_first_name"), tm_photo);
	}

	this.updateSubmitAvailability();

	var self = this;
	var inputs = this.getCodeInputs();

	function checkAndSubmit() {
		if (self.m_submitInFlight) {
			return;
		}

		var code = self.getCodeValue();
		if (code.length === inputs.length) {
			self.submitCode();
		}
	}

	function fillFrom(startIndex, text) {
		var digits = (text || "").replace(/\D/g, "").slice(0, inputs.length - startIndex);
		if (!digits) {
			return;
		}

		for (var i = 0; i < digits.length; i++) {
			inputs[startIndex + i].value = digits.charAt(i);
		}

		var nextIndex = startIndex + digits.length;
		if (nextIndex < inputs.length) {
			self.focusCodeInput(nextIndex);
		} else {
			checkAndSubmit();
		}
	}

	inputs.forEach(function(input, index) {
		input.addEventListener("input", function() {
			if (self.m_submitInFlight) {
				return;
			}

			var value = (input.value || "").replace(/\D/g, "");
			if (!value) {
				input.value = "";
				return;
			}

			if (value.length > 1) {
				fillFrom(index, value);
				return;
			}

			input.value = value.charAt(0);

			if (index < inputs.length - 1) {
				self.focusCodeInput(index + 1);
			} else {
				checkAndSubmit();
			}
		});

		input.addEventListener("keydown", function(event) {
			if (self.m_submitInFlight) {
				event.preventDefault();
				return;
			}

			var key = event.key;

			if (key === "Backspace") {
				if (input.value === "" && index > 0) {
					event.preventDefault();
					inputs[index - 1].value = "";
					self.focusCodeInput(index - 1);
				}
				return;
			}

			if (key === "Delete") {
				event.preventDefault();
				input.value = "";
				return;
			}

			if (key === "ArrowLeft") {
				event.preventDefault();
				if (index > 0) {
					self.focusCodeInput(index - 1);
				}
				return;
			}

			if (key === "ArrowRight") {
				event.preventDefault();
				if (index < inputs.length - 1) {
					self.focusCodeInput(index + 1);
				}
				return;
			}

			if (key === "Enter") {
				event.preventDefault();
				checkAndSubmit();
				return;
			}

			if (key === "Tab") {
				return;
			}

			if (key.length === 1 && !/\d/.test(key)) {
				event.preventDefault();
			}
		});

		input.addEventListener("paste", function(event) {
			event.preventDefault();
			var text = (event.clipboardData || window.clipboardData).getData("text");
			fillFrom(index, text);
		});
	});

	var tm_l = CommonHelper.getCookie("tm_time_left");
	if (tm_l || CommonHelper.getCookie("tm_code_time_left")) {
		if (tm_l) {
			this.checkCodeContCont();
		} else {
			DOMHelper.show(this.getId() + ":codeInput");
			this.setSubmitText("Запросить код повторно");
			this.updateSubmitAvailability();
			this.focusCodeInput(0);
		}
	} else if (tm_tel && tm_tel.length >= 10) {
		CommonHelper.unsetCookie("tm_time_left");
		var pm = (new User_Controller()).getPublicMethod("tm_get_left_time");
		pm.setFieldValue("tel", tm_tel);
		pm.run({
			"ok": function(resp) {
				var m = resp.getModel("TmLeftTime_Model");
				if (m.getNextRow()) {
					var set_code_left_time = function(mdl) {
						var c_lt = parseInt(mdl.getFieldValue("code_left_time"), 10);
						if (c_lt) {
							document.cookie = "tm_code_time_left=" + c_lt + "; Path=/; max-age=" + c_lt + ";";
						}
						return c_lt;
					};

					var lt = parseInt(m.getFieldValue("left_time"), 10);
					if (lt) {
						lt += 2;
						document.cookie = "tm_time_left=" + lt + "; Path=/; max-age=" + lt + ";";
						set_code_left_time(m);
						self.checkCodeContCont();
					} else if (set_code_left_time(m)) {
						self.updateSubmitAvailability();
						DOMHelper.show(self.getId() + ":codeInput");
						self.focusCodeInput(0);
					}
				}
			},
			"fail": function(resp, errCode, errStr) {
				self.setError(errStr);
			}
		});
	}
};

LoginTM.prototype.setError = function(s) {
	this.getElement("error").setValue(s);
}

LoginTM.prototype.setSubmitText = function(t) {
	DOMHelper.setText(this.getId() + ":check_code", t);
}

LoginTM.prototype.setSubmitLeftTime = function() {
	var t_m = Math.floor(this.m_timeLeft / 60);
	var t_s = this.m_timeLeft - t_m * 60;
	this.setSubmitText("Запросить код повторно через " + ((t_m > 9) ? t_m.toString() : "0" + t_m.toString()) + ":" + ((t_s > 9) ? t_s.toString() : "0" + t_s.toString()));
}

LoginTM.prototype.checkCodeCont = function() {
	var pm = (new User_Controller()).getPublicMethod("tm_send_code");
	pm.setFieldValue("tel", this.m_tel);
	var self = this;
	pm.run({
		"ok": function(resp) {
			self.checkCodeContCont();
		}
		, "fail": function(resp, errCode, errStr) {
			self.setError(errStr);
			self.unsetUserData();
		}
	});
}

LoginTM.prototype.clearCode = function() {
	var inputs = this.getCodeInputs();
	for (var i = 0; i < inputs.length; i++) {
		inputs[i].value = "";
	}
	this.focusCodeInput(0);
};

LoginTM.prototype.checkCodeContCont = function() {
	var self = this;

	if (this.m_timeInterval) {
		clearInterval(this.m_timeInterval);
		this.m_timeInterval = null;
	}

	this.clearCode();
	DOMHelper.show(this.getId() + ":codeInput");

	this.m_timeLeft = CommonHelper.getCookie("tm_time_left");
	if (!this.m_timeLeft) {
		this.m_timeLeft = CommonHelper.getCookie("tm_duration_sec");
		if (!this.m_timeLeft) {
			this.m_timeLeft = 120;
		}
	} else {
		CommonHelper.unsetCookie("tm_time_left");
	}

	this.m_timerLocksSubmit = true;
	this.setSubmitLeftTime();
	this.updateSubmitAvailability();
	this.focusCodeInput(0);

	this.m_timeInterval = setInterval(function() {
		self.m_timeLeft--;

		if (self.m_timeLeft <= 0) {
			clearInterval(self.m_timeInterval);
			self.m_timeInterval = null;
			self.m_timerLocksSubmit = false;
			self.setSubmitText("Запросить код повторно");
			self.updateSubmitAvailability();
		} else {
			self.setSubmitLeftTime();
		}
	}, 1000);
};

LoginTM.prototype.checkCode = function() {
	if (this.m_requestInFlight || this.m_submitInFlight) {
		return;
	}

	var t = this.getCorrectTel();
	if (!t) {
		return;
	}

	this.setError("");

	var self = this;
	if (this.m_tel !== t || !this.m_telResolved) {
		this.setTel(t, function() {
			self.checkCodeCont();
		});
	} else {
		this.m_tel = t;
		this.checkCodeCont();
	}
};

LoginTM.prototype.unsetUserData = function() {
	CommonHelper.unsetCookie("tm_tel");
	CommonHelper.unsetCookie("tm_first_name");
	CommonHelper.unsetCookie("tm_duration_sec");

	if (window["localStorage"]) {
		localStorage.removeItem("tm_photo");
	}

	this.m_tel = null;
	this.m_telResolved = false;
	this.m_requestInFlight = false;
	this.m_submitInFlight = false;

	this.unsetUserDataCtrl();
	this.resetCodeState();
	this.updateSubmitAvailability();
};

LoginTM.prototype.setUserDataCtrl = function(tel, name, photo) {
	this.m_tel = tel;
	this.m_telResolved = !!tel;

	this.getElement("tel").setValue(tel ? tel : "");
	this.getElement("userData").setValue(name ? name : "");

	if (photo) {
		this.getElement("userPhoto").setAttr("src", "data:image/png;base64, " + photo);
	}
	this.getElement("userPhoto").setVisible(!!photo);

	this.updateSubmitAvailability();
};

LoginTM.prototype.unsetUserDataCtrl = function() {
	this.getElement("userData").setValue("");
	this.getElement("userPhoto").setAttr("src", "");
	this.getElement("userPhoto").setVisible(false);
};

LoginTM.prototype.setUserData = function(uData) {
	var tm_tel = uData.tel.getValue();
	var tm_first_name = uData.first_name.getValue();
	var tm_photo = uData.tm_photo.getValue();
	if (window["localStorage"]) {
		localStorage.setItem('tm_photo', tm_photo);
	}
	CommonHelper.setCookie("tm_tel", tm_tel, uData.tel_duration_sec.getValue());
	CommonHelper.setCookie("tm_first_name", tm_first_name, uData.tel_duration_sec.getValue());
	CommonHelper.setCookie("tm_duration_sec", uData.duration_sec.getValue(), uData.tel_duration_sec.getValue());
	this.setUserDataCtrl(tm_tel, tm_first_name, tm_photo);
}

LoginTM.prototype.setTel = function(t, callback) {
	this.setError("");
	this.m_requestInFlight = true;
	this.m_telResolved = false;
	this.updateSubmitAvailability();

	var self = this;
	var pm = (new User_Controller()).getPublicMethod("tm_check_tel");
	pm.setFieldValue("tel", t);

	pm.run({
		"ok": function(resp) {
			self.m_requestInFlight = false;

			var m = resp.getModel("TmUserData_Model");
			if (m.getNextRow()) {
				self.setUserData(m.getFields());

				if (m.getFieldValue("code_exists") == "1") {
					var lt = parseInt(m.getFieldValue("left_time"), 10);
					if (lt) {
						lt += 2;
						document.cookie = "tm_time_left=" + lt + "; Path=/; max-age=" + lt + ";";
					}
					self.checkCodeContCont();
				}

				if (callback) {
					callback();
				}
			} else {
				self.m_telResolved = false;
				self.updateSubmitAvailability();
			}
		},
		"fail": function(resp, errCode, errStr) {
			self.m_requestInFlight = false;
			self.m_telResolved = false;
			self.setError(errStr);
			self.unsetUserData();
		}
	});
};

LoginTM.prototype.getCorrectTel = function() {
	var tel = this.getElement("tel").getValue();
	if (!tel || tel.length != 10) {
		this.unsetUserData();
		this.setError("Неверный номер!");
		return undefined;
	}
	return tel;
}

LoginTM.prototype.submitCode = function() {
	if (!this.m_tel || this.m_submitInFlight) {
		return;
	}

	var code = this.getCodeValue();
	if (!code || code.length !== 3) {
		this.setError("Код не введен");
		return;
	}

	this.m_submitInFlight = true;
	this.setError("");
	this.setFormInputsDisabled(true);
	this.setSubmitBtnEnabled(false);

	var pm = (new User_Controller()).getPublicMethod("tm_check_code");
	pm.setFieldValue("code", code);
	pm.setFieldValue("tel", this.m_tel);

	var self = this;
	pm.run({
		"ok": function(resp) {
			var m = resp.getModel("Auth_Model");
			if (m.getNextRow()) {
				document.location.href = window.location.href;
				return;
			}

			self.m_submitInFlight = false;
			self.setFormInputsDisabled(false);
			self.updateSubmitAvailability();
		},
		"fail": function(resp, errCode, errStr) {
			self.m_submitInFlight = false;
			self.setError(errStr);
			self.setFormInputsDisabled(false);
			self.clearCode();
			self.updateSubmitAvailability();
		}
	});
};
