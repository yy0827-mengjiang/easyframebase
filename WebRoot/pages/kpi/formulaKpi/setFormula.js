function doBds() {
	var options = $("#kpi_bds option:selected");
	var selValue = options.val();
	while (selValue.indexOf("</div>") != -1) {
		selValue = selValue.replace("</div>", "");
	}
	while (selValue.indexOf("<div>") != -1) {
		selValue = selValue.replace("<div>", "");
	}
	$("#kpi_formula").val(selValue);
	$("#kpi_formula").focus();
}
function doClare() {
	$("#kpi_formula").val("");
	$("#kpi_formula").focus();
}
function doYsf(ysf) {
	// 定义显示公式内容对象
	var textObj = document.getElementById("kpi_formula");
	// 定义临时公式
	var tmp = "";
	// 定义显示公式内容
	var textValue = textObj.value;
	// 定义光标在表达式的位置
	// var position = getCursortPosition(textObj);
	// 公式定义显示区内无内容情况
	if (textValue == "") {
		// 如果选择左括号或者右括号，则自动填充左右括号，并将光标指向中间位置
		if (ysf == "(" || ysf == ")") {
			tmp = "()";
		} else {
			tmp = ysf;
		}
	} else {
		tmp = ysf;
	}
	// 向显示公式区写入内容
	insertContent(textObj, tmp);
	if (textValue == "" && tmp == "()")
		// 将光标自动移入括号内
		setCaretPosition(textObj, 1);
}
function insertContent(textObj, filedValue) {
	if (document.all) {
		if (textObj.createTextRange && textObj.caretPos) {
			var caretPos = textObj.caretPos;
			caretPos.text = caretPos.text.charAt(caretPos.text.length - 1) == '   ' ? filedValue
					+ '   '
					: filedValue;
		} else {
			textObj.value = textObj.value+filedValue;
		}
	} else {
		if (textObj.setSelectionRange) {
			var rangeStart = textObj.selectionStart;
			var rangeEnd = textObj.selectionEnd;
			var tempStr1 = textObj.value.substring(0, rangeStart);
			var tempStr2 = textObj.value.substring(rangeEnd);
			textObj.value = tempStr1 + filedValue + tempStr2;
		}
	}
}
function formulaAgree() {
	var _formula = $('#kpi_formula').val();
	var _tmp = _formula.replace(/<kpi>/g, '1');
	try {
		var k = eval(_tmp);
	} catch (e) {
		$.messager.alert("提示信息！", "公式格式出错！", "info");
		return false;
	}
//	_formula = _formula.replace(/\//g, "<div>/</div>").replace(/\(/g,
//			"<div>(</div>").replace(/\)/g, "<div>)</div>").replace(/\+/g,
//			"<div>+</div>").replace(/\-/g, "<div>-</div>").replace(/\*/g,
//			"<div>*</div>");
	var __formula = _formula;
	var _t = "<span class='box_div formulaTD'>&nbsp;</span>";
	while (_formula.indexOf("<kpi>") != -1) {
		_formula = replaceKpiFormula(_t, _formula);
	}
	
	forIndex = 0;

	var _forExplain = $('#for_explain').val();
	var _forName = $('#forName').val();
	if(_forName==""||_forName==null){
		$.messager.alert("提示信息！", "请输入公式名称！", "info");
		return false;
	}
	var a = {};
	a.formula = __formula;
	a.forExplain = _forExplain;
	a.forName = _forName;
	$.post("../../../pages/kpi/formulaKpi/formulaAction.jsp?eaction=addFormul", a,
			function(result) {
				$('#tid').html('');
				$('#tid').append(_formula);
				formulaTD();
				formulaTdEvent();
				$.messager.alert("提示信息！", "公式配置成功！", "info");
				$('#f-dlg').dialog('close');
			});

}