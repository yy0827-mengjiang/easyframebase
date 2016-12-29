<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:set var="parentId">${param.kpi_category }</e:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>修改复合指标</title>
<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="kpiires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<e:style value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
	<e:style value="/resources/easyResources/component/easyui/icon.css" />
	<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
<script type="text/javascript">
	var Vcheck = "0";
	/*
	 * 初始化行数
	 */
	$(function() {
		var ckpi_arr = $.parseJSON('${comKpiList}');
		$('#formulaTable').datagrid({
			data : ckpi_arr
		});
		var dim_arr = $.parseJSON('${dimCondition}');
		$('#conditionTable').datagrid({
			data : dim_arr
		});
		var formula_arr = $.parseJSON('${formula_arr}');
		$('#formTable').datagrid({
			data : formula_arr
		});
	});

	/*
	 * 选择指标或者公式
	 */
	function chooseKpiOrFormula() {
		$('#base_kpi').load('<e:url value="/pages/kpi/manager/kpi.jsp"/>', {},
				function() {
				});
		//$('#complex_kpi').load('<e:url value="/pages/kpi/manager/complexKpi.jsp"/>',{},function(){});

		$('#f-dlg').dialog('open');
		$("#kpi_formula").focus();
		$("#base_kpi").tree({
			onDblClick : function(node) {
				chooseKpiFromTree(node);
			}
		});
	}
	function chooseKpiFromTree(node) {
		var result = node.text;
		var tmp = "{" + result + "}";
		var row = $("#formTable").datagrid('getData').rows[0];
		if (row.kpi_forms == "") {

		} else {
			tmp = replaceKpiFormula(tmp, row.kpi_forms);
		}
		var param = {
			"index" : 0,
			"row" : {
				"kpi_forms" : tmp
			}
		};
		$("#formTable").datagrid('updateRow', param);
	}
	function replaceKpiFormula(kpi, kpi_forms) {
		var i = kpi_forms.indexOf("{kpi}");
		var tmp = kpi_forms;
		if (i != -1) {
			tmp = kpi_forms.substring(0, i) + kpi + kpi_forms.substring(i + 5);
		}
		return tmp;
	}
	function chooseDim() {
		$('#dim-dlg').css('display', '');
		$('#dimDIV').load('<e:url value="/pages/kpi/manager/dim.jsp"/>', {},
				function() {
				});
		$('#kpiDIV').load('<e:url value="/pages/kpi/manager/kpiCon.jsp"/>', {},
				function() {
				});
		$('#dim-dlg').dialog('open');
	}
	function chooseTjz() {
		var row = $('#conditionTable').datagrid('getSelected');
		var indexs = $('#conditionTable').datagrid('getRowIndex', row);
		var isConstant = $('#hidconstant' + indexs).val();
		if ('0' == isConstant) {
			$("#dim1").attr("disabled", true);
			$("#dim_value1").attr("disabled", true);
			$("#constant").attr("checkec", true);
			$("#clz0").attr("disabled", false);
			$("#clz0").val($("#tjz_unit0").val());
		} else if ('1' == isConstant) {
			$("#dim1").attr("disabled", false);
			$("#dim_value1").attr("disabled", false);
			$("#constant").attr("checkec", false);
			$("#clz0").attr("disabled", true);
			var dimCode = $("#dimName" + indexs).val();
			var tjzId = $("#did" + indexs).val();
			var tjzName = $("#tjz_unit" + indexs).val();
			$
					.ajax({
						type : "POST",
						url : "<e:url value='/pages/kpi/manager/kpiAction.jsp?eaction=dimensionForId'/>&oid="
								+ dimCode + "&tjzId=" + tjzId,
						dataType : "json",
						success : function(data) {
							var tjzId = $("#did" + indexs).val();
							var tjzName = $("#tjz_unit" + indexs).val();
							var dim1 = $('#dim1');
							var dim_value1 = document
									.getElementById("dim_value1");
							dim1.html("");
							for (var i = 0; i < data.length; i++) {
								dim1.append("<option value='"+data[i].KEY+"'>"
										+ data[i].VALUE + "</option>");
							}
							if (dim_value1.length <= 0) {
								var tjz = tjzId.split(",");
								var tjzv = tjzName.split(",");
								for (var i = 0; i < tjz.length; i++) {
									$(dim_value1).append(
											"<option value='"+tjz[i]+"'>"
													+ tjzv[i] + "</option>");
								}
							}
							$('#clz0').val("");
						}
					});
		}
		$('#tjz-dlg').dialog('open');
	}
	/*
	 * 运算符触发事件
	 * @parameter ysf 选择的运算符
	 */
	function doYsf(ysf) {
		//定义显示公式内容对象
		var textObj = document.getElementById("kpi_formula");
		//定义临时公式
		var tmp = "";
		//定义显示公式内容
		var textValue = textObj.value;
		//定义光标在表达式的位置
		//var position = getCursortPosition(textObj);
		//公式定义显示区内无内容情况
		if (textValue == "") {
			//如果选择左括号或者右括号，则自动填充左右括号，并将光标指向中间位置
			if (ysf == "(" || ysf == ")") {
				tmp = "()";
			} else {
				tmp = ysf;
			}
		} else {
			tmp = ysf;
		}
		//向显示公式区写入内容
		insertContent(textObj, tmp);
		if (textValue == "" && tmp == "()")
			//将光标自动移入括号内
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
				textObj.value = filedValue;
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
	function setCaret(textObj) {
		if (textObj.createTextRange) {
			textObj.caretPos = document.selection.createRange().duplicate();
		}
	}
	function setCaretPosition(ctrl, pos) {
		if (ctrl.setSelectionRange) {
			ctrl.focus();
			ctrl.setSelectionRange(pos, pos);
		} else if (ctrl.createTextRange) {
			var range = ctrl.createTextRange();
			range.collapse(true);
			range.moveEnd('character', pos);
			range.moveStart('character', pos);
			range.select();
		}
	}
	function getCursortPosition(ctrl) {
		var CaretPos = 0; //IESupport    
		if (document.selection) {
			ctrl.focus();
			var Sel = document.selection.createRange();
			Sel.moveStart('character', -ctrl.value.length);
			CaretPos = Sel.text.length;
		} else if (ctrl.selectionStart || ctrl.selectionStart == '0') // Firefox support      
			CaretPos = ctrl.selectionStart;
		return (CaretPos);
	}
	function doClare() {
		$("#kpi_formula").val("");
		$("#kpi_formula").focus();
	}
	function doBds() {
		var options = $("#kpi_bds option:selected");
		var selValue = options.val();
		$("#kpi_formula").val(selValue);
		$("#kpi_formula").focus();
	}

	//验证
	function check(str) {
		if (str.length == 0) {
			return 1;
		}
		var i = 0;
		do {
			str = str.replace(/\{kpi\}/, "1");
			i = str.indexOf("{kpi}");
		} while (i != -1)
		try {
			var k = eval(str);
			return 1;
		} catch (e) {
			return 0;
		}
	}
	function doLockFormula() {

		var formula = $("#kpi_formula").val();
		//alert(formula);
		//alert(check.test(formula));
		if (check(formula) == 0) {
			alert('请输入正确格式公式！');
			return false;
		}
		var lockstatus = $("#ysf8").val();
		var disabled = false;
		if (lockstatus == "解锁公式") {
			$("#ysf8").val("锁定公式");
			disabled = false;
		} else {
			$("#ysf8").val("解锁公式");
			disabled = true;
			var param = {
				"index" : 0,
				"row" : {
					"kpi_forms" : formula
				}
			};
			$("#formTable").datagrid('updateRow', param);
			$("#hidForms").val(formula);
		}
		for (var i = 0; i < 8; i++) {
			$("#ysf" + i).attr("disabled", disabled);
		}
		$("#kpi_formula").attr("disabled", disabled);
		$("#kpi_bds").attr("disabled", disabled);
	}

	function leftToRight() {
		var checkText = $("#dim1").find("option:selected");
		$('#dim_value1').append(checkText);

	}
	function rightToLeft() {
		var checkText = $("#dim_value1").find("option:selected");
		$('#dim1').append(checkText);

	}

	//新增条件
	function addkpi() {
		var indexs = $('#conditionTable').datagrid('getRows').length;
		$('#conditionTable')
				.datagrid(
						'insertRow',
						{
							index : indexs,
							row : {
								"dimName" : "<input type='text' id='dim_name"
										+ indexs
										+ "' name='kpi_name"
										+ indexs
										+ "' style='width:90%;' onclick='javascript:chooseDim();'><input type='hidden' id='dimName"+indexs+"' name='kpiName"+indexs+"'><input type='hidden' id='isKpi"+indexs+"' name='isKpi"+indexs+"' value='1'>",
								"ljf" : "<select id='ljf_name"
										+ indexs
										+ "' name='kpi_name"
										+ indexs
										+ "' style='width:90%;' onchange='onMultiple()'><option value='0'>等于</option><option value='1'>包含</option><option value='2'>大于</option><option value='3'>小于</option><option value='4'>不等于</option><option value='5'>大于等于</option><option value='6'>小于等于</option><option value='7'>为空</option><option value='8'>不为空</option></select>",
								"tjz" : "<input type='text' id='tjz_unit"
										+ indexs
										+ "' name='kpi_unit"
										+ indexs
										+ "' style='width:90%;' onclick='javascript:chooseTjz()'><input type='hidden' id='did"+indexs+"' name='did"+indexs+"' ><input type='hidden' name='hidconstant"+indexs+"' id='hidconstant"+indexs+"'>",
								"ljkjf" : "<select id='ljkjf"
										+ indexs
										+ "' name='ljkjf"
										+ indexs
										+ "' style='width:90%;'><option value='and'>并且</option><option value='or'>或者</option></select>"
							}
						});
		var dIndex = $('#dIndex').val();
		dIndex = dIndex + "," + indexs;
		$('#dIndex').val(dIndex);
	}
	//删除条件
	function removekpi() {
		var row = $('#conditionTable').datagrid('getSelected');
		var indexs = $('#conditionTable').datagrid('getRowIndex', row);
		var dIndex = $('#dIndex').val().split(",");
		var text = '';
		for (var i = 0; i < dIndex.length; i++) {
			if (i != indexs) {
				text = text + dIndex[i] + ",";
			}
		}
		text = text.substring(0, text.length - 1);
		$('#dIndex').val(text);
		$('#conditionTable').datagrid('deleteRow', indexs);
	}
	//条件弹出框确认
	function onAgree() {
		var row = $('#conditionTable').datagrid('getSelected');
		var indexs = $('#conditionTable').datagrid('getRowIndex', row);
		if ($("#constant").is(':checked')) {
			$('#hidconstant' + indexs).val('0');
			$('#tjz_unit' + indexs).val($('#clz0').val());
		} else {
			var text = '';
			var did = '';
			$("#dim_value1 option").each(function() { //遍历全部option
				var txt = $(this).text(); //获取option的内容
				var id = $(this).val();
				text = text + txt + ","; //添加到数组中
				did = did + id + ',';
			});
			$('#hidconstant' + indexs).val('1');
			$('#tjz_unit' + indexs).val(text.substring(0, text.length - 1));
			$('#did' + indexs).val(did.substring(0, did.length - 1));
		}
		$('#tjz-dlg').dialog('close');
	}
	//复合指标弹出框确认
	function onAgree1() {
		var rows = $('#formTable').datagrid('getRows');
		var text = rows[0]['kpi_forms'];
		var kpiFormula = $('#kpi_formula').val();
		$('#kpi_unit1').val(text);

		$('#f-dlg').dialog('close');
	}

	function onAgree2() {
		var agr = {};
		agr.kpiName = $('#kpi_name0').val();
		agr.kpiUnit0 = $("#kpi_unit0  option:selected").text();
		agr.kpiUnit1 = $('#kpi_unit1').val();
		agr.formual = $('#hidForms').val();
		agr.isFormula = $('#isFormula').val();
		agr.dIndex = $('#dIndex').val();
		agr.kpiCode = $('#kpiCode').val();
		agr.comKpiCode = $('#comkpicode').val();
		agr.complexkpiCode = $('#complexkpiCode').val();
		agr.kpi_category = '${parentId}';
		agr.kpiCalIber = $('#kpiCalIber').val();
		agr.kpiExplain = $('#kpiExplain').val();
		agr.kpiVersion = $('#kpiVersion').val();
		var dIndex = $('#dIndex').val();
		var indexs = dIndex.split(',');
		var arr = new Array(indexs.length);
		for (var i = 0; i < indexs.length; i++) {
			var b = {};
			b.dimName = $('#dim_name' + indexs[i]).val();
			b.dimCode = $('#dimName' + indexs[i]).val();
			b.ljfName = $('#ljf_name' + indexs[i]).val();
			b.tjzUnit = $('#tjz_unit' + indexs[i]).val();
			b.constant = $('#hidconstant' + indexs[i]).val();
			b.did = $('#did' + indexs[i]).val();
			b.ljkjf = $('#ljkjf' + indexs[i]).val();
			b.isKpi = $('#isKpi' + indexs[i]).val();

			arr[i] = b;
		}
		agr.arr = arr;
		switch (Vcheck) {
		case "1":
			alert('请输入指标名称！');
			Vcheck = "0";
			return false;
		case "2":
			alert('指标名称过长！');
			Vcheck = "0";
			return false;
		case "3":
			alert('指标名称己存在！');
			Vcheck = "0";
			return false;
		case "4":
			alert('请输入指标单位！');
			Vcheck = "0";
			return false;
		case "5":
			alert('指标单位过长！');
			Vcheck = "0";
			return false;
		}
		$.ajax({
			type : "POST",
			url : "<e:url value='/kpiAdd.e'/>",
			dataType : "json",
			data : agr,
			success : function(data) {
				onClose();
			}

		});

	}
	function onAgree3() {
		var agr = {};
		agr.kpiName = $('#kpi_name0').val();
		agr.kpiUnit0 = $("#kpi_unit0  option:selected").text();
		agr.kpiUnit1 = $('#kpi_unit1').val();
		agr.formual = $('#hidForms').val();
		agr.isFormula = $('#isFormula').val();
		agr.dIndex = $('#dIndex').val();
		agr.kpiCode = $('#kpiCode').val();
		agr.comKpiCode = $('#comkpicode').val();
		agr.complexkpiCode = $('#complexkpiCode').val();
		agr.kpiCategory = $('#kpiCategory').val();
		agr.kpiCalIber = $('#kpiCalIber').val();
		agr.kpiExplain = $('#kpiExplain').val();
		agr.kpiVersion = $('#kpiVersion').val();
		agr.oid = ${oid};
		var dIndex = $('#dIndex').val();
		var indexs = dIndex.split(',');
		var arr = new Array(indexs.length);
		for (var i = 0; i < indexs.length; i++) {
			var b = {};
			b.dimName = $('#dim_name' + indexs[i]).val();
			b.dimCode = $('#dimName' + indexs[i]).val();
			b.ljfName = $('#ljf_name' + indexs[i]).val();
			b.tjzUnit = $('#tjz_unit' + indexs[i]).val();
			b.constant = $('#hidconstant' + indexs[i]).val();
			b.did = $('#did' + indexs[i]).val();
			b.ljkjf = $('#ljkjf' + indexs[i]).val();
			b.isKpi = $('#isKpi' + indexs[i]).val();

			arr[i] = b;
		}
		agr.arr = arr;
		switch (Vcheck) {
		case "1":
			alert('请输入指标名称！');
			Vcheck = "0";
			return false;
		case "2":
			alert('指标名称过长！');
			Vcheck = "0";
			return false;
		case "3":
			alert('指标名称己存在！');
			Vcheck = "0";
			return false;
		case "4":
			alert('请输入指标单位！');
			Vcheck = "0";
			return false;
		case "5":
			alert('指标单位过长！');
			Vcheck = "0";
			return false;
		}
		$.ajax({
			type : "POST",
			url : "<e:url value='/kpiUpdate.e'/>",
			dataType : "json",
			data : agr,
			success : function(data) {
				onClose();
			}

		});

	}
	function onClose() {
		window.open('', '_self');
		window.close();
	}
	function onMultiple() {
		var row = $('#conditionTable').datagrid('getSelected');
		var indexs = $('#conditionTable').datagrid('getRowIndex', row);
		var ljfval = $('#ljf_name' + indexs).val();
		if (ljfval == "0" || ljfval == "1") {
			$('#tjz_unit' + indexs).attr('disabled', false);
			$('#dim1').attr('multiple', true);
		} else if (ljfval == "7" || ljfval == "8") {
			$('#tjz_unit' + indexs).attr('disabled', true);
		} else {
			$('#tjz_unit' + indexs).attr('disabled', false);
			$('#dim1').attr('multiple', false);
			$('#dim1').attr('size', 100);
		}
	}

	function onConstant() {
		if ($('#constant').is(':checked')) {
			$('#clz0').attr("disabled", false)
			$('#dim1').attr("disabled", true);
			$('#dim_value1').attr("disabled", true);
		} else {
			$('#clz0').attr("disabled", true)
			$('#dim1').attr("disabled", false);
			$('#dim_value1').attr("disabled", false);
		}

	}
	function onCheckKpiName() {
		var kpiName = $('#kpi_name0').val();
		if (kpiName.length == 0 || kpiName == '') {
			Vcheck = "1";
		}
		

		if (kpiName.length > 100) {
			Vcheck = "2";
		}
		$
				.ajax({
					type : "POST",
					url : "<e:url value='/pages/kpi/manager/ajax.jsp?eaction=name'/>&name="
							+ kpiName + "&comKpiCode=" + comKpiCode,
					dataType : "json",
					success : function(data) {
						if (data.C > 0) {
							Vcheck = "3";
						}
					}
				});
	}

	function onKpiUnit() {
		var kpiUnit = $('#kpi_unit0').val();
		if (kpiUnit.length == 0 || kpiUnit == '') {
			Vcheck = "4";
		}
		if (kpiUnit.length > 10) {
			Vcheck = "5";
		}
	}
</script>
</head>
<body id="underLine">
	<div id="topTitle">
		<h1>X-Builder</h1>
	</div>
	<div class="comOutBox">
		<!--titOut-->
		<div class="titOut">
			<h3><span>复合指标组成</span></h3>
		</div>
		<!--//titOut-->
		<!--comInbox-->
		<div class="comInbox">


			<%-- <div id="tb" style="padding:2px 5px;">
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" onClick="chooseKpiOrFormula();" plain="true">新增指标</a> <a href="javascript:void(0)"class="easyui-linkbutton" iconCls="icon-remove" onClick="removekpi();" plain="true">删除指标</a>
				</div> --%>
			<input type="hidden" id="kpiCode" name="kpiCode" value="${kpiCode }">
			<input type="hidden" id="complexkpiCode" name="complexkpiCode"
				value="${complexkpiCode }"> <input type="hidden"
				id="hidForms" name="hidForms" value="${formulaId }"> <input
				type="hidden" id="comkpicode" name="comkpicode"
				value="${COMKPICODE }"> <input type="hidden" id="kpiVersion"
				name="kpiVersion" value="${KPIVERSION }"> <input
				type="hidden" id="kpiCategory" name="kpiCategory"
				value="${kpiCategory }">
			<table width="100%">
				<c:datagrid url="#" id="formulaTable" pagination="false"
					rownumbers="true">
					<thead class="underLine">
						<tr>
							<th data-options="field:'name',width:'200'">复合指标名称</th>
							<th data-options="field:'unit',width:'130'">复合指标单位</th>
							<th data-options="field:'kpiression',width:'500',align:'left'">公式/指标</th>
						</tr>
					</thead>
				</c:datagrid>
			</table>
		</div>
		<!--//comInbox-->
		<!--titOut-->
		<div class="titOut">
			<h3>
				<span>约束条件</span>
			</h3>
		</div>
		<!--//titOut-->
		<!--comInbox-->
		<div class="comInbox">
			<input type="hidden" name="dIndex" id="dIndex" value="${dIndex }" />
			<!-- 条件id -->

			<table width="100%">
				<c:datagrid url="#" id="conditionTable" pagination="false"
					rownumbers="true">
					<thead>
						<tr>
							<th data-options="field:'dimName',width:150">维度名称</th>
							<th data-options="field:'ljf',width:150">连接符</th>
							<th data-options="field:'tjz',width:150">条件值</th>
							<th data-options="field:'ljkjf',width:150">逻辑符</th>
						</tr>
					</thead>
				</c:datagrid>
			</table>
			<div id="tb">
				<ul class="btnItem1">
					<li><a href="javascript:void(0)" class="addBtn" iconCls="icon-add"
						onClick="addkpi();" plain="true">新增条件</a></li>
					<li><a href="javascript:void(0)" class="deleteBtn" iconCls="icon-remove"
						onClick="removekpi();" plain="true">删除条件</a></li>
				</ul>
			</div>
		</div>
		<!--//comInbox-->
		<!--titOut-->
		<div class="titOut">
			<h3>
				<span>指标口径、解释</span>
			</h3>
		</div>
		<!--//titOut-->
		<!--comInbox-->
		<div class="comInbox">
			<dl class="group">
				<dt>指标口径：</dt>
				<dd>
					<textarea rows="6" id="kpiCalIber" name="kpiCalIber"
						style="width: 97%">${kpiCalIber }</textarea>
				</dd>
			</dl>
			<dl class="group">
				<dt>指标解释：</dt>
				<dd>
					<textarea rows="6" id="kpiExplain" name="kpiExplain"
						style="width: 97%">${kpiExplain }</textarea>
				</dd>
			</dl>

		</div>
	<!--//comInbox-->
		<div class="centerBtnItem">
			<p><a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="onAgree3()">保存到当前版本</a><a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="onAgree2()">保存新版本</a></p>
		</div>
	</div>	
		<div id="f-dlg" class="easyui-dialog" title="复合指标组成" style="width:860px;height:530px;" data-options="closed:true,modal:true" buttons='#dlg-buttons1'>
			<div id="cc" class="easyui-layout" style="width:840px;height:450px;">
				<div region="west" split="true" title="" style="width:220px;">
					<div class="easyui-tabs">
						<div title="基础指标" id="base_kpi" style="overflow:auto;padding:10px;height: 395px;"></div>
						<!-- <div title="复合指标" id="complex_kpi" style="overflow:auto;padding:10px;height: 395px;"></div> -->
					</div>
				</div>
				<div region="center" title="" style="padding:5px;">
					<c:datagrid url="#" id="formTable" pagination="false"
						rownumbers="true">
						<thead>
							<tr>
								<th data-options="field:'kpi_forms',width:600">复合指标</th>
							</tr>
						</thead>
					</c:datagrid>
					<div style="margin-top: 15px;">
						定义公式：<br />
						<textarea id="kpi_formula" name="kpi_formula"
							onselect="setCaret(this);" onclick="setCaret(this);"
							onkeyup="setCaret(this);" onfocus="setCaret(this);"
							style="width:600px;height:60px;font-size: 16px;margin-top: 10px;"
							disabled="disabled">${formula_source }</textarea>
					</div>
					<div style="margin-top: 15px;">
						运算符：&nbsp;&nbsp;<input id="ysf0" type="button" size="5" value="+"
							style="font-weight: bold;height: 30px;"
							onclick="javascript:doYsf('+');" disabled="disabled">&nbsp;
						<input id="ysf1" type="button" size="5" value="-"
							style="font-weight: bold; height: 30px;"
							onclick="javascript:doYsf('-');" disabled="disabled">&nbsp;
						<input id="ysf2" type="button" size="5" value="*"
							style="font-weight: bold; height: 30px;"
							onclick="javascript:doYsf('*');" disabled="disabled">&nbsp;
						<input id="ysf3" type="button" size="5" value="/"
							style="font-weight: bold; height: 30px;"
							onclick="javascript:doYsf('/');" disabled="disabled">
						&nbsp;&nbsp; <input id="ysf4" type="button" size="5" value="("
							style="font-weight: bold; height: 30px;"
							onclick="javascript:doYsf('(');" disabled="disabled">&nbsp;
						<input id="ysf5" type="button" size="5" value=")"
							style="font-weight: bold; height: 30px;"
							onclick="javascript:doYsf(')');" disabled="disabled"> <input
							id="ysf6" type="button" size="5" value="指标"
							style="font-weight: bold; height: 30px;"
							onclick="javascript:doYsf('{kpi}');" disabled="disabled">
						&nbsp;&nbsp; <input id="ysf7" type="button" size="5" value="清除"
							style="font-weight: bold; height: 30px;"
							onclick="javascript:doClare();" disabled="disabled">&nbsp;
						<input id="ysf8" type="button" size="15" value="解锁公式"
							style="font-weight: bold; height: 30px;"
							onclick="javascript:doLockFormula();">
					</div>
					<div style="margin-top: 15px;">
						表达式：<br /> <select id="kpi_bds" name="kpi_bds"
							multiple="multiple"
							style="width: 600px; height: 150px; margin-top: 10px; cursor: pointer; "
							ondblclick="javascrtip:doBds(this);" disabled="disabled">
							<option value="{kpi}+{kpi}+{kpi}">{kpi}+{kpi}+{kpi}</option>
							<option value="{kpi}+{kpi}-{kpi}">{kpi}+{kpi}-{kpi}</option>
							<option value="({kpi}+{kpi})*{kpi}">({kpi}+{kpi})*{kpi}</option>
							<option value="({kpi}+{kpi})/{kpi}">({kpi}+{kpi})/{kpi}</option>
							<option value="({kpi}-{kpi})*{kpi}">({kpi}-{kpi})*{kpi}</option>
							<option value="({kpi}-{kpi})/{kpi}">({kpi}-{kpi})/{kpi}</option>
							<option value="{kpi}+{kpi}+{kpi}+{kpi}">{kpi}+{kpi}+{kpi}+{kpi}</option>
							<option value="{kpi}-{kpi}-{kpi}-{kpi}">{kpi}-{kpi}-{kpi}-{kpi}</option>
						</select>
					</div>
				</div>
			</div>
		</div>
		<div id="dim-dlg" class="easyui-dialog" title="维度" style="width:300px;height:380px;" data-options="closed:true, modal:true">
			<div class="easyui-tabs">
				<div title="基础指标" id="kpiDIV" style="overflow:auto;padding:10px;height: 285px;"></div>
				<div title="基础维度" id="dimDIV" style="overflow:auto;padding:10px;height: 285px;"></div>
			</div>
		</div>
		<div id="tjz-dlg" class="easyui-dialog" title="条件值" style="width:460px;height:360px;" data-options="closed:true, modal:true" buttons="#dlg-buttons">
			<div class="twoSelectOut">
				<div class="group">
					<div class="twoSelectL">
						<h4>维度</h4>
						<select id="dim1" name="dim1"
							style="width:190px; height: 200px;" multiple="multiple">
						</select>
					</div>
					<div class="twoSelectM"><a href="javascript:void(0)"
							class="easyui-linkbutton" onClick="leftToRight()" plain="true">&gt;&gt;</a>
							<a href="javascript:void(0)" class="easyui-linkbutton" onClick="rightToLeft()"
							plain="true">&lt;&lt;</a></div>
					<div class="twoSelectR">
						<h4>值</h4>				
						<select id="dim_value1"
							name="dim_value1" style="width:190px; height: 200px;"
							multiple="multiple">
						</select>
					</div>
				</div>
				<div class="twoSelectB">
					<p><input type="checkbox" id="constant" name="constant" onclick="onConstant()">&nbsp;&nbsp;常量值 : &nbsp;<input type="text" id="clz0" name="clz0" style="width:350px;"></p>
					<div id="dlg-buttons"><a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="onAgree()">确认</a></div>
					<div id="dlg-buttons1"><a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="onAgree1()">确认</a></div>
				</div>
			</div>
		</div>
</body>
</html>
