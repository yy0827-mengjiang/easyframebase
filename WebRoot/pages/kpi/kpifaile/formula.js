var operJson = {"0":"=","1":"in","2":">","3":"<","4":"<>","5":">=","6":"<=","7":"is null","8":"is not null"};
var forIndex = 0;
var vaildName = 0;
//双击《指标公式》Table打开弹窗
function setFormula(){
	$('#f-dlg').dialog('open');
}
function addFormula() {
	$('#formula-dlg').load('../formulaKpi/formula.jsp', {}, function() {});
	$('#formula-dlg').dialog('open');
}
//单击公式出现公式说明
function clickFormula(node) {
	var _FORMULA_EXPLAIN = node.attributes.FORMULA_EXPLAIN;
	$('#diaExplain').html('');
	$('#diaExplain').html(_FORMULA_EXPLAIN);
}
//选择公式
function dbFormula(node) {
	var _formula = node.attributes.FORMULA;
	var _tmp = "<span class='box_div formulaTD'>&nbsp;</span>";
	while(_formula.indexOf("<kpi>")!=-1){
		_formula = replaceKpiFormula(_tmp,_formula);
	}
	$('#tid').html('');
	$('#tid').append(_formula);
	formulaTD();
	formulaTdEvent();
	forIndex = 0;
	$('#formula-dlg').dialog('close');
}
//公式拖拽
/*function formulaTD(){
	$('.formulaTD').droppable({  
		onDragEnter: function (e, source) {  
        	$(source).draggable("proxy").find("span.tree-dnd-icon").removeClass("tree-dnd-no tree-dnd-no").addClass("tree-dnd-yes");
        },
        onDrop:function(e,s){
        	var node = $('#tt').tree('getNode', s);
        	var isleaf = $(this).tree('isLeaf',node.target);
         	if(isleaf){
        		if(_type=='1'){
        			var _kpiType = node.attributes.kpi_type;
        			if(!vaildKpiType(_usedType,_kpiType)){
    	        		$.messager.alert("提示信息！", "错误的类型结点！", "info");
    	        		return false;
    	        	}
        			if($(this).html()=='&nbsp;'){
    	        		$(this).attr("id",node.attributes.code);
    	        		$(this).attr("nodeid",node.attributes.code);
    	        		$(this).attr("nodeType",node.attributes.kpi_type);
    	        		$(this).html(node.text);
    					$(this).append("<strong>X</strong>");
    	        	}else{
    	        		$.messager.alert("提示信息！", "请清除公式中指标后再进行设置！", "info");
    	        		return false;
    	        	}
        		}else if(_type=='2'){
        			var _kpiType = node.attributes.kpi_type;
        			if(!vaildKpiType(_usedType,_kpiType)){
    	        		$.messager.alert("提示信息！", "错误的类型结点！", "info");
    	        		return false;
    	        	}
        			if(node.attributes.code==comCode){
    	        		$.messager.alert("提示信息！", "不能将自己放入公式！", "info");
    	        		return false;
    	        	}
        			$('#kpiType').val(node.attributes.code + "_" + forIndex);
        			acctTypeSub1(node.text,node.attributes.code,node.attributes.version,node.attributes.account,node.attributes.code + "_" + forIndex,'typeSelect');
    	        	if($(this).html()=='&nbsp;'){
    	        		$(this).attr("id",node.attributes.code + "_" + forIndex);
    	        		$(this).attr("nodeType",node.attributes.kpi_type);
    	        	}else{
    	        		$.messager.alert("提示信息！", "请清除公式中指标后再进行设置！", "info");
    	        		return false;
    	        	}
        		}else if(_type=='3'){
        			var _kpiType = node.attributes.kpi_type;
        			if(!vaildKpiType(_usedType,_kpiType)){
    	        		$.messager.alert("提示信息！", "错误的类型结点！", "info");
    	        		return false;
    	        	}
        			if(node.attributes.code==comCode){
    	        		$.messager.alert("提示信息！", "不能将自己放入公式！", "info");
    	        		return false;
    	        	}
        			$('#kpiType').val(node.attributes.code + "_" + forIndex);
        			acctTypeSub1(node.text,node.attributes.code,node.attributes.version,node.attributes.account,node.attributes.code + "_" + forIndex,'typeSelect');
    	        	if($(this).html()=='&nbsp;'){
    	        		$(this).attr("id",node.attributes.code + "_" + forIndex);
    	        		$(this).attr("nodeType",node.attributes.kpi_type);
    					$(this).append("<strong>X</strong>");
    	        	}else{
    	        		$.messager.alert("提示信息！", "请清除公式中指标后再进行设置！", "info");
    	        		return false;
    	        	}
        		}
	        	spanEvent();
	        	forIndex++;
        	}else{
        		$.messager.alert("提示信息！", "非法指标！", "info");
        		return false;
        	}
        }
    });
}*/
function formulaTD(){
	$('.formulaTD').droppable({  
		onDragEnter: function (e, source) {  
        	$(source).draggable("proxy").find("span.tree-dnd-icon").removeClass("tree-dnd-no tree-dnd-no").addClass("tree-dnd-yes");
        },
        onDrop:function(e,s){
        	var node = $('#tt').tree('getNode', s);
        	var isleaf = $(this).tree('isLeaf',node.target);
         	if(isleaf){
         		var _dropNode = node.attributes.node_type;
    			var _dropDate = node.attributes.data_type;
         		if(_dropNode != 'KPI'){
         			$.messager.alert("提示信息！", "结点类型错误！", "info");
	        		return false;
         		}
    			if(!vaildKpiType(_usedType,_usedName,_typeName,node.attributes.kpi_type)){
    				var _text = "";
    				for(var i=0;i<_usedName.length;i++){
    					if(_text.length>2){
    						_text += "，";
    					}
    					_text += _usedName[i].TYPE_NAME;
    				}
	        		$.messager.alert("提示信息！", _typeName + "只能使用" + _text, "info");
	        		return false;
	        	}
    			if(node.attributes.code==comCode){
	        		$.messager.alert("提示信息！", "不能将自己放入公式！", "info");
	        		return false;
	        	}
	        	//内蒙要把下面的if注释打开
//    			if(_dropDate=='3'){
//    				if($(this).html()=='&nbsp;'){
//    	        		$(this).attr("id",node.attributes.code);
//    	        		$(this).attr("nodeid",node.attributes.code);
//    	        		$(this).attr("nodeType",node.attributes.kpi_type);
//    	        		$(this).html(node.text);
//    					$(this).append("<strong>X</strong>");
//    	        	}else{
//    	        		$.messager.alert("提示信息！", "请清除公式中指标后再进行设置！", "info");
//    	        		return false;
//    	        	}
//    			}else{
    	        	if($(this).html()=='&nbsp;'){
    	        		$('#kpiType').val(node.attributes.code + "_" + forIndex);
            			acctTypeSub1(node.text,node.attributes.code,node.attributes.version,node.attributes.account,node.attributes.code + "_" + forIndex,'typeSelect');
    	        		$(this).attr("id",node.attributes.code + "_" + forIndex);
    	        		$(this).attr("nodeType",node.attributes.kpi_type);
    	        	}else{
    	        		$.messager.alert("提示信息！", "请清除公式中指标后再进行设置！", "info");
    	        		return false;
    	        	}
//    			}
	        	spanEvent();
	        	forIndex++;
        	}else{
        		$.messager.alert("提示信息！", "非法指标！", "info");
        		return false;
        	}
        }
    });
}
//清除公式中span的指标
function spanEvent(){
	$("strong").on('click',function(event){
		event.stopPropagation();
 		var _par = $(this).parents('span')
 		var _id = $(_par).attr("nodeId");
 		$(_par).attr("id","");
 		$(_par).attr("nodeId","");
 		$(_par).attr("nodetype","");
 		var _falg = disExt(_par);
 		if(!_falg){
 			$("input[name=formKpiTypes]").attr('disabled',false);
 		}
 		_par.html('&nbsp;');
 	});
}
function disExt(td){
	var _span = $(td).parents("td").children("span");
	_span.each(function(){
		var _nodeId = $(this).attr("nodeId");
		var _ext = _nodeId.substring(_nodeId.lastIndexOf("_"),_nodeId.length);
		if(_ext!="_A"){
			return true;
		}
	});
	return false;
}
//阻止事件传播，现在没有用了
function formulaTdEvent(){
	$(".formulaTD").on('dblclick',function(event){
		 event.preventDefault();
		 return false;
	 });
}
//公式替换
function replaceKpiFormula(kpi,kpi_forms){
	var i = kpi_forms.indexOf('<kpi>');
	var tmp =  kpi_forms;
	if(i != -1) {
		tmp = kpi_forms.substring(0,i) + kpi + kpi_forms.substring(i+5);
	}
	return tmp;
}
//条件值
function CondValue(dim_id,id){
	var _select = $("#"+id+">select");
	var _option="";
	if(dim_id==null||dim_id==""){
		$.messager.alert("提示信息！", "非法选择！", "info");
		return false;
	}
	cn.com.easy.kpi.service.FormulaService.setCondValue(dim_id,function(data){
		var _data = $.parseJSON(data);
		if(_data.res=="success"){
			var _value = _data.data;
			for(var i=0;i<_value.length;i++){
				if(i==0){
					$("#"+id).attr("nodeId",_value[i].code);
				}
				_option = _option + "<option value='"+_value[i].code+"'>"+_value[i].name+"</option>";
			}
			_select.append(_option);
		}else{
			$.messager.alert("提示信息！", "获取条件值出错！", "info");
			return false;
		}
	});
}
//选择框
function opter(data){
	var _data = $.parseJSON(data);
	var _select = "<select style='width:200px' attrName='nodeId'>";
	for(var i=0;i<_data.length;i++){
		_select = _select + "<option value='"+_data[i].CODE+"'>"+_data[i].NAME+"</option>";
	}
	_select = _select +  "</select>";
	return _select;
}
//条件全选
function allCheck(){
	if($("#all").attr("checked")=="checked"){
		$("input[name='condCB']").attr("checked",true);
	}else{
		$("input[name='condCB']").attr("checked",false);
	}
}
//条件删除
function delCond(){
	var _array = new Array();
	var _trs = $("input[name='condCB']");
	_trs.each(function(){
		if($(this).attr("checked")=="checked"){
			_array.push($(this).attr("id"));
		}
	});
	if(_array.length<1){
		$.messager.alert("提示信息！", "请选择要删除的条件！", "info");
		return false;
	}
	for(var i=0;i<_array.length;i++){
		$("#"+_array[i]).parents("tr").remove();
	}
	$('#all').attr("checked",false);
}
//验证复合指标名称
function validName() {
	var _code = $('#base_key').val();
	var _value = $('#formula_name').val();
	var _type = $('#cubeCode').val();
	if ('' != _value) {
		cn.com.easy.kpi.service.FormulaService.vaildName(_value,_type,_code,
				function(data) {
					var _data = $.parseJSON(data);
					if (_data.data) {
						vaildName=1;
						$.messager.alert("提示信息！", '指标名称己存在！', "info");
					}else{
						vaildName=0;
					}
				});
	}
}
//为条件中选择框绑定事件
function selectOper(){
	$("[name='oper']>select").on("change",function(){	
		var _td = $(this).parents("tr").children("td").eq(0).attr("nodeId");
		var _dimType = $(this).parents("tr").children("td").eq(1).attr("dimType");
		var _condAttr = $(this).parents("tr").children("td").eq(3).attr("condAttr");
		var _value = $(this).find("option:selected").val();
		if(_td=="6"){
			if("6"==_dimType){
				if(_value!="1"&&_value!="7"&&_value!="8"){
					$(this).parents("tr").children("td").eq(3).html('');
					var _selectVal="<select style='width:300px'><option value=''>空</option></select>";
					var id = $(this).parents("tr").children("td").eq(1).attr("nodeId");
					$(this).parents("tr").children("td").eq(3).append(_selectVal);
					CondValue(id,$(this).parents("tr").children("td").eq(3).attr("id"));
					selectVal();
				}else if(_value=="1"){
					$(this).parents("tr").children("td").eq(3).html('');
					$(this).parents("tr").children("td").eq(3).attr('nodeId','');
					$(this).parents("tr").children("td").eq(3).html('双击打开选择窗口');
					var _id = $(this).parents("tr").children("td").eq(3).attr("id");
					var _dimId = $(this).parents("tr").children("td").eq(1).attr("nodeId");
					$('#srcId').attr('srcId',_id);
					inCondValue(_dimId);
	//				$(this).parents("tr").children("td").eq(3).append('<input type="text">');
	//				inputOper();
				}else if(_value=="7"||_value=="8"){
					$(this).parents("tr").children("td").eq(3).html('');
				}
			}else{
				if(_value!="1"&&_value!="7"&&_value!="8"){
					$(this).parents("tr").children("td").eq(3).html('');
					var _selectVal="<select style='width:300px'><option value=''>空</option></select>";
					var id = $(this).parents("tr").children("td").eq(1).attr("nodeId");
					$(this).parents("tr").children("td").eq(3).append(_selectVal);
					CondValue(id,$(this).parents("tr").children("td").eq(3).attr("id"));
					selectVal();
				}else if(_value=="7"||_value=="8"){
					$(this).parents("tr").children("td").eq(3).html('');
				}
			}
		}else{
			if(_value=="7"||_value=="8"){
				$(this).parents("tr").children("td").eq(3).children().hide();
			}else{
				$(this).parents("tr").children("td").eq(3).children().show();
			}
		}
		var _td = $(this).parents("td");
		_td.attr("nodeId",_value);
	});
}
//维度条件选择
function openCondValue(id){
	var _tr =  $('#'+id).parent("tr");
	var _opt = _tr.children("td").eq(2).children("select").val();
	if("1"==_opt){
		var _id = $('#'+id).parent("tr").children("td").eq(3).attr("id");
		var _select =$('#dim1');
		var _valSelect =$('#dim_value1');
		var _option="";
		var _valOption="";
		$('#srcId').attr('srcId',_id);
		var _valueId = $('#'+id).parent("tr").children("td").eq(3).attr("nodeId")	;
		var _dimId = $('#'+id).parent("tr").children("td").eq(1).attr("nodeId");
		if(_dimId==null||_dimId==""){
			$.messager.alert("提示信息！", "非法选择！", "info");
			return false;
		}
		cn.com.easy.kpi.service.FormulaService.setCondValue(_dimId,function(data){
			var _data = $.parseJSON(data);
			if(_data.res=="success"){
				//_select.find("option").remove();
				_select.empty();
				//_valSelect.find("option").remove();
				_valSelect.empty();
				var _value = _data.data;
				for(var i=0;i<_value.length;i++){
					if(_valueId.indexOf(_value[i].code)!=-1){
						_valOption = _valOption + "<option value='"+_value[i].code+"'>"+_value[i].name+"</option>";
					}else{
						_option = _option + "<option value='"+_value[i].code+"'>"+_value[i].name+"</option>";
					}
				}
				_select.append(_option);
				_valSelect.append(_valOption);
				$('#dim_conds_dlg').dialog('open');
			}else{
				$.messager.alert("提示信息！", "获取条件值出错！", "info");
				return false;
			}
		});
	}
}
//回显运算符为in的约束条件
function inCondValue(dimId){
	var _select =$('#dim1');
	var _option="";
	if(dimId==null||dimId==""){
		$.messager.alert("提示信息！", "非法选择！", "info");
		return false;
	}
	cn.com.easy.kpi.service.FormulaService.setCondValue(dimId,function(data){
		var _data = $.parseJSON(data);
		if(_data.res=="success"){
			var _value = _data.data;
			_select.empty();
			for(var i=0;i<_value.length;i++){
				_option = _option + "<option value='"+_value[i].code+"'>"+_value[i].name+"</option>";
			}
			_select.append(_option);
			$('#dim_conds_dlg').dialog('open');
		}else{
			$.messager.alert("提示信息！", "获取条件值出错！", "info");
			return false;
		}
	});
}
//确认
function onAgree(){
	var _valueCode = "";
	var _valueText = "";
	var _id = $('#srcId').attr('srcId');
	var _targSelect = $('#dim_value1 option');
	_targSelect.each(function(){
		if(_valueCode.length>0){
			_valueCode = _valueCode + ",";
			_valueText = _valueText + "、";
		}
		_valueCode = _valueCode + $(this).val();
		_valueText = _valueText + $(this).html();
		
	});
	$('#'+_id).parent("tr").children("td").eq(3)
	$('#'+_id).parent("tr").children("td").eq(3).html('');
	$('#'+_id).parent("tr").children("td").eq(3).attr('nodeId',"");
	var _condAttr = $('#'+_id).parent("tr").children("td").eq(3).attr('condAttr');
	$('#'+_id).attr('nodeId',_valueCode);
	$('#'+_id).html("");
	if("T"!=_condAttr){
		//$('#'+_id).html("("+_valueText+")&nbsp;偏移量：<input type='text' value='' attrName='attrVal' style='width:300px;'>");
		$('#'+_id).html("("+_valueText+")&nbsp;<input type='hidden' value='' attrName='attrVal' style='width:300px;'>");
		inputOper();
	}else{
		$('#'+_id).html(_valueText);
	}
	
	$('#dim_conds_dlg').dialog('close');
}
//运算符为in的约束条件
function leftToRight(){
	var checkText=$("#dim1").find("option:selected");
	$('#dim_value1').append(checkText);

}
function rightToLeft(){
	var checkText=$("#dim_value1").find("option:selected");
	$('#dim1').append(checkText);
	
}
//为条件值选择框绑定事件
function selectVal(){
	$("[name='condval']>select").on("change",function(){
		var _attrName = $("[name='condval']>select").attr("attrName");
		if(_attrName == undefined ||  _attrName == "") {
			_attrName = "nodeId"; //到底是nodeId还是nodeid
		}
		var _value = $(this).find("option:selected").val();
		var _td = $(this).parents("td");
		_td.attr(_attrName,_value);
	});
}
//为条件中input绑定事件
function inputOper(){
	$("td>input[type='text']").on("blur",function(){
		var _attrName = $(this).attr("attrName");
		var _value = $(this).val();
		var _td = $(this).parents("td");
		_td.attr(_attrName,_value);
	});
}
//为条件中checkBox绑定事件
function checkBoxOper(){
	$("input[name='condCB']").on("click",function(){
		var _array = new Array();
		if($(this).attr("checked")!="checked"){
			$("#all").attr("checked",false);
		}else{
    		$("input[name='condCB']").each(function(){
    			if($(this).attr("checked")=="checked"){
    				_array.push($(this).attr("id"));
    			}
    		});
    		if(_array.length==$("input[name='condCB']").length){
    			$("#all").attr("checked",true);
    		}
		}
	});
}
//字符串转公式
function formulaToStr(str,start,end){
	var _s = str.indexOf(start);
	var _e = str.indexOf(end);
	if(_s!=-1){
		if(_e==-1){
			$.messager.alert("提示信息！", '公式错误！', "info");
			return false;
		}
	}
	var _str = str.substring(_s,_e+7);
	var _id = $(_str).attr("nodeId");
	if(null==_id||''==_id){
		return '';
	}
	var _tmp = str.substring(0,_s)+"{"+_id+"}" + str.substring(_e+7,str.length);
	return _tmp;
}
function formulaToTXT(str,start,end){
	var _s = str.indexOf(start);
	var _e = str.indexOf(end);
	if(_s!=-1){
		if(_e==-1){
			$.messager.alert("提示信息！", '公式错误！', "info");
			return false;
		}
	}
	var _str = str.substring(_s,_e+7);
	var _txt = $(_str).html();
	_txt = _txt.substring(0,_txt.indexOf("<"));
	var _tmp = str.substring(0,_s)+ $.trim(_txt) + str.substring(_e+7,str.length);
	return _tmp;
}
function formulaToOper(str,start,end){
	var _s = str.indexOf(start);
	var _e = str.indexOf(end);
	if(_s!=-1){
		if(_e==-1){
			$.messager.alert("提示信息！", '公式错误！', "info");
			return false;
		}
	}
	var _str = str.substring(_s,_e+7);
	var _id = $(_str).attr("nodeId");
	var _tmp = str.substring(0,_s)+"{"+_id+"}" + str.substring(_e+7,str.length);
	return _tmp;
}
//转换指标公式为正常公式和字符串
function formulaConvert(){
	var _str = $("#tid").html();
	var _tmp = _str;
	var _formulaStr = _str.replace(/</g,"&lt;").replace(/>/g,"&gt;");
	while(_tmp.indexOf("</span>")!=-1){
		_tmp = formulaToStr(_tmp,"<span","</span>");
	}
	while(_tmp.indexOf("</div>")!=-1){
		_tmp = _tmp.replace("</div>"," ");
	}
	while(_tmp.indexOf("<div>")!=-1){
		_tmp = _tmp.replace("<div>"," ");
	}
	
	$("#formulaStr").val(_formulaStr);
	$("#formula").val(_tmp);
}
//公式转json
function formulaToJson(){
	var _span = $("#tid>span");
	var _kpis="[";
	var _formulaKpi = $("#formulaKpi").val();
	if(null==_formulaKpi||''==_formulaKpi){
		_formulaKpi='';
	}
	_span.each(function(){
		if(_kpis.length>2){
			_kpis = _kpis+",";
		}
		var _kpi = "{";
		var nodeId = $(this).attr("nodeId");
		var nodeType = $(this).attr("nodeType");
		if(''==nodeId||null==nodeId){
			_kpi = _kpi +'"nodeType":"","nodeId":""}';
		}else{
			_kpi = _kpi +'"nodeType":"'+nodeType+'","nodeId":"'+nodeId+'"}';
			_kpis = _kpis + _kpi;
			if(_formulaKpi.length>0){
				_formulaKpi = _formulaKpi+",";
			}
			_formulaKpi = _formulaKpi + nodeId;
		}
	});
	_kpis = _kpis+"]";
	$("#kpis").val(_kpis);
	$("#formulaKpi").val(_formulaKpi);
}
//条件转字符串
function condToStr(){
	var _str = $("#cond").html();
	var _condStr = _str.replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/'/g,"&gl;");
	$("#condStr").val(_condStr);
}
//回显时解释约束条件
function paserCond(){
	var _tr = $("#cond>tr");
	condition(_tr);
	var _cond = '[';
	_tr.each(function(){
		if(_cond.length>2){
			_cond = _cond + ",";
		}
		var _td = $(this).children('td');
		var _condchi = '{';
		for(var i=0;i<_td.length;i++){
			var _nodeId = $(_td[i]).attr("nodeId");
			var _name = $(_td[i]).attr("name");
			if(_condchi.length>1){
				_condchi = _condchi+",";
			}
			_condchi = _condchi + '"'+_name+'":"'+_nodeId+'"';
		}
		_condchi = _condchi + "}";
		_cond = _cond + _condchi;
	})
	_cond = _cond + "]";
	$("#condJson").val(_cond);
}

//约束条件拼where条件
function condition(tr){
	var cond = "";
	var islogic = "";
	var txtLogic ="";
	var condText = ""; 
	var _tdType = "";
	tr.each(function(){
		var _td = $(this).children('td');
		var type = $(_td[0]).attr("nodeId");
		if("0"==type){
			var _prepend = $(_td[2]).attr("nodeId");
			if(_prepend == "or"){
				islogic = "or";
			}else if(_prepend == "and"){
				islogic = "and";
			}else if(_prepend == "("){
				islogic = "(";
			}else if(_prepend == ")"){
				islogic = ")";
			}
			if(_prepend == "("&&cond==""){
				cond = cond + " and " + _prepend;
			}else if (_prepend == "("&&cond!=""){
				if(_tdType=='1'){
					cond = cond + " and " + _prepend;
				}else{
					cond = cond + " " + _prepend;
				}
			}else{
				if(_prepend == "0") {
					_prepend = " ";
				}
				cond = cond + " " + _prepend;
			}
			_tdType = "0";
		}else{
			
			if(""==islogic){
				cond = cond + " and {" + $(_td[1]).attr('nodeId') + "} ";
			}else if("or"==islogic){
				cond = cond + " {" + $(_td[1]).attr('nodeId') + "} ";
			}else if("and"==islogic){
				cond = cond + " {" + $(_td[1]).attr('nodeId') + "} ";
			}else if("("==islogic){
				cond = cond + " {" +$(_td[1]).attr('nodeId') + "} ";
			}else if(")"==islogic){
				cond = cond + " and {" + $(_td[1]).attr('nodeId') + "} ";
			}
			
			cond = cond + jointCond(this);
			condText = jointCondTxt(this);
			_tdType = "1";
			islogic = "";
		}
	});
	$('#condPar').val(cond);
	$("#technical0").val($("#technical0").val() + " " + condText);
	
}
//function jointCond1(object1,object2){
//	var oper = object1;
//	if(oper!="1"&&oper!="7"&&oper!="8"){
//		return " " + $(operJson).attr(oper)  + " add_months(#ACCT_MONTH#,"+object2+")" ;
//	}else if(oper=="7"||oper=="8"){
//		return " "+$(operJson).attr(oper);
//	}else if(oper=="1"){
//		var _v =" (",_array = object2.split(",");
//		for(var i=0;i<_array.length;i++){
//			if(_v.length>2){
//				_v = _v +",";
//			}
//			_v = _v +"'"+_array[i]+"'";
//		}
//		return " " + $(operJson).attr(oper)+ _v + ")";
//	}
//}
function jointCondTxt(tr){
	var _td = $(tr).children('td');
	var oper = $(_td[2]).attr('nodeId');
	var operTxt = "";
	if(oper=="1"){
		operTxt = " 包含 ";
	}else if(oper=="2"){
		operTxt = " 大于 ";
	}else if(oper=="3"){
		operTxt = " 小于 ";
	}else if(oper=="4"){
		operTxt = " 不等于 ";
	}else if(oper=="5"){
		operTxt = " 大于等于 ";
	}else if(oper=="6"){
		operTxt = " 小于等于 ";
	}else if(oper=="7"){
		operTxt = " 为空 ";
	}else if(oper=="8"){
		operTxt = " 不为空 ";
	}else if(oper=="0"){
		operTxt = " 等于 ";
	}
	var _kpiType = $(_td[0]).attr("nodeId");
	var _condAttr = $(_td[3]).attr("condAttr");
	if(_kpiType=="6"||_kpiType=="7"){
		if(oper=="7"||oper=="8"){
			return operTxt;
		}else if(oper=="1"){
			return operTxt + $(_td[3]).html();
		}else{
			if(_condAttr){
				if("T" == _condAttr){
					var _select = $(_td[3]).children("select").get(0);
					return operTxt + $(_select).find("option:selected").html();
				}else if("D" == _condAttr){
					var s0 = $(_td[3]).attr('nodeId');
					var s1 = $(_td[3]).attr('attrVal');
					if(s1>0){
						return operTxt + s0 + " + " + s1 + "天";
					}else if(s1<0){
						return operTxt + s0 + " - " + s1 + "天";
					}else{
						return operTxt + s0;
					}
				}else if("M" == _condAttr){
					var s0 = $(_td[3]).attr('nodeId');
					var s1 = $(_td[3]).attr('attrVal');
					if(s1>0){
						return operTxt + s0 + " + " + s1 + "月";
					}else if(s1<0){
						return operTxt + s0 + " - " + s1 + "月";
					}else{
						return operTxt + s0;
					}
				}
			}else{
				return operTxt + $(_td[3]).attr("nodeId");
			}
		}
	}else if(_kpiType=="5"){
		var _select = $(_td[3]).children("select").get(0);
		
		return operTxt + $(_select).find("option:selected").html();
	}else{
		return operTxt + $(_td[3]).attr("nodeId");
	}
}

//拼约束条件where的面的日期类型
function jointCond(tr){
	var _condStr = "";
	var _td = $(tr).children('td');
	var oper = $(_td[2]).attr('nodeId');
	var _oper = $(operJson).attr(oper);
	if(oper!="1"&&oper!="7"&&oper!="8"){
		var _condAttr = $(_td[3]).attr("condAttr");
		if(_condAttr){
			if("T" == _condAttr){
				return " " + _oper + " '" + $(_td[3]).attr('nodeId') + "'";
			}else if("D" == _condAttr){
				return " " + _oper + " TO_DATE('" + $(_td[3]).attr('nodeId') + "','YYYY_MM_DD')" + "+" + $(_td[3]).attr('attrVal');
			}else if("M" == _condAttr){
				return " " + _oper + " ADD_MONTHS(TO_DATE('" + $(_td[3]).attr('nodeId') + "','YYYY_MM_DD')," + $(_td[3]).attr('attrVal')+ ")";
			}
		}else{
			return " " + _oper + " '" + $(_td[3]).attr("nodeId") + "'";
		}
	}else  if(oper=="7"||oper=="8"){
		return " " + _oper;
	}else if(oper=="1"){
		var _condAttr = $(_td[3]).attr("condAttr");
		if("T" == _condAttr){
			var _v =" (",_array = $(_td[3]).attr('nodeId').split(",");
			for(var i=0;i<_array.length;i++){
				if(_v.length>2){
					_v = _v +",";
				}
				_v = _v +"'"+_array[i]+"'";
			}
		}else if("D" == _condAttr){
			var _v =" (",_array = $(_td[3]).attr('nodeId').split(",");
			for(var i=0;i<_array.length;i++){
				if(_v.length>2){
					_v = _v +",";
				}
				var attrVal = $(_td[3]).attr('attrVal');
				
				_v = _v + "TO_DATE('"+_array[i]+ "','YYYY_MM_DD')" + "+" + $(_td[3]).attr('attrVal');
			}
		}else if("M" == _condAttr){
			var _v =" (",_array = $(_td[3]).attr('nodeId').split(",");
			for(var i=0;i<_array.length;i++){
				if(_v.length>2){
					_v = _v +",";
				}
				_v = _v + "ADD_MONTHS(TO_DATE('"+_array[i]+ "','YYYY_MM_DD')," + $(_td[3]).attr('attrVal')+ ")";
			}
		}
		return " " + _oper + _v + ")";
	}
}
//function jointCond(object1,object2){
//	var oper = object1;
//	if(oper!="1"&&oper!="7"&&oper!="8"){
//		return " " + $(operJson).attr(oper) + " '" + object2 + "'";
//	}else if(oper=="7"||oper=="8"){
//		return " "+$(operJson).attr(oper);
//	}else if(oper=="1"){
//		var _v =" (",_array = object2.split(",");
//		for(var i=0;i<_array.length;i++){
//			if(_v.length>2){
//				_v = _v +",";
//			}
//			_v = _v +"'"+_array[i]+"'";
//		}
//		return " " + $(operJson).attr(oper)+ _v + ")";
//	}
//}
//回显时字符串转换公式
function strToformula(str,id){
	var _str = str.replace(/&lt;/g,"<").replace(/&gt;/g,">");
	$("#"+id).append(_str);
	$("#"+id).removeClass("droppable");
	formulaTD();
	spanEvent();
	formulaTdEvent();
}
function disExtA(str){
	var _falg = false;
	var _span = $("#"+str).children("span");
	_span.each(function(){
		var _nodeId = $(this).attr("nodeId");
		var _ext = _nodeId.substring(_nodeId.lastIndexOf("_"),_nodeId.length);
		if(_ext!="_A"){
			_falg = true;
			return ;
		}
	});
	return _falg;
}
//回显时字符串转约束条件
function strTocond(str,id){
	var _str = str.replace(/&lt;/g,"<").replace(/&gt;/g,">").replace(/&gl;/g,"'");
	$("#"+id).html('');
	$("#"+id).append(_str);
	var _tr = $("#"+id).children('tr');
	_tr.each(function(){
		var _td = $(this).children('td');
		var _type = $(_td[0]).attr('nodeid');
		if(_type=='0'){
			setOper(_td[2],_logi);
		}else if(_type=='4'){
			setOper(_td[2],oper);
			setTdHtml(_td[2],_td[3]);
		}else if(_type=='6'||_type=='7'){
			setOper(_td[2],oper);
			setTdHtml(_td[2],_td[3],_td[1]);
		}else if(_type=='2'){
			setOper(_td[2],oper);
			setTdHtml(_td[2],_td[3]);
		}else if(_type=='5'){
			setOper(_td[2],oper);
			setTdHtmlLabel(_td[2],_td[3],_td[1]);
		}else if(_type=='1'){
			setOper(_td[2],oper);
			setAcctTypeSub(_td[1]);
			setTdHtml(_td[2],_td[3]);
		}
		checkBoxOper();
		selectOper();
		inputOper();
		selectVal();
	});
//	checkBoxOper();
//	selectOper();
//	inputOper();
//	selectVal();
}
//回显时显示运算符
function setOper(o,json){
	var _d = $.parseJSON(json);
	var _value = $(o).attr("nodeId");
	var _select = "<select style='width:200px' attrName='nodeId'>";
	for(var i=0;i<_d.length;i++){
		if(_value==_d[i].CODE){
			_select = _select + "<option value='"+_d[i].CODE+"' selected='selected'>"+_d[i].NAME+"</option>";
		}else{
			_select = _select + "<option value='"+_d[i].CODE+"'>"+_d[i].NAME+"</option>";
		}
	}
	_select = _select +  "</select>";
	$(o).html("");
	$(o).append(_select);
}
//回显时显示指标标签
function setTdHtmlLabel(o,o1){
	var _select  = "<select style='width:300px;' attrName='nodeId'>";
	var _value = $(o1).attr("nodeId");
	if("1"==_value){
		_select = _select + "<option value='1' selected='selected'>是</option>";
		_select = _select + "<option value='0' >否</option>";
	}else{
		_select = _select + "<option value='1'>是</option>";
		_select = _select + "<option value='0' selected='selected'>否</option>";
	}
	_select = _select + "</select>";
	$(o1).html('');
	$(o1).append(_select);
}
//回显时显示账期束约条件
function setTdHtml(o2,o,o1){
	var _operId = $(o2).attr('nodeId');
	if(_operId=='7'||_operId=='8'||_operId=='1'){
		return false;
	}
	var _dimAttr =  $(o).attr('condAttr');
	if(_dimAttr){
		var c = $(o).children();
		if(_dimAttr=="T"){
			var _value = $(o).attr("nodeId");
			var _tagName = c[0].nodeName;
			if(_tagName=="SELECT"){
				var _dimid = $(o1).attr("nodeId");
				var _id = $(o).attr("id");
				var _value = $(o).attr("nodeId");
				setCondValue(_dimid,_id,_value);
			}else if(_tagName=="INPUT"){
				$(o).html('');
				$(o).append("<input type='text' value='"+_value+"' style='width:300px;' attrName='nodeId' >");
			}
		}else{
			var _value = $(o).attr("nodeId");
			var _offset = $(o).attr("attrVal");
			$(o).html('');
			//$(o).append("<input type='text' value='"+_value+"' attrName='nodeId' style='width:300px;'>&nbsp;偏移量：<input type='text' value='" + _offset + "' attrName='attrVal' style='width:300px;'>");
			$(o).append("<input type='text' value='"+_value+"' attrName='nodeId' style='width:300px;'>&nbsp<input type='hidden' value='" + _offset + "' attrName='attrVal' style='width:300px;'>");
		}
	}else{
		var c = $(o).children().get(0);
		var _value = $(o).attr("nodeId");
		if(c){
			if(c.tagName=="INPUT"){
				$(o).html('');
				$(o).append("<input type='text' value='"+_value+"' style='width:300px;' attrName='nodeId' >");
			}else{
				var _dimid = $(o1).attr("nodeId");
				var _id = $(o).attr("id");
				var _value = $(o).attr("nodeId");
				setCondValue(_dimid,_id,_value);
			}
		}
	}
}
//回显时显示约束条件值
function setCondValue(dimid,id,value){
	var _option="";
	var _select ="<select style='width:400px' attrName='nodeId'></select>";
	$("#"+id).html('');
	$("#"+id).append(_select);
	cn.com.easy.kpi.service.FormulaService.setCondValue(dimid,function(data){
		var _data = $.parseJSON(data);
		if(_data.res=="success"){
			var _value = _data.data;
			for(var i=0;i<_value.length;i++){
				if(value==_value[i].code){
					_option = _option + "<option value='"+_value[i].code+"' selected='selected'>"+_value[i].name+"</option>";
				}else{
					_option = _option + "<option value='"+_value[i].code+"'>"+_value[i].name+"</option>";
				}
				
			}
			$("#"+id+">select").append(_option);
		}else{
			$.messager.alert("提示信息！", "获取条件值出错！", "info");
			return false;
		}
	});
}
function clearArg(){
	$("#formulaStr").val('');
	$("#formula").val('');
	$("#kpis").val('');
	$("#formulaKpi").val('');
	$("#condJson").val('');
	$('#condPar').val('');
	$("#condStr").val('');
}
//保存
function formulasaved(status){
	disbBut();
	formulaConvert();
	formulaToJson();
	paserCond();
	condToStr();
	
	var _formKpiTypes = $("input[name=formKpiTypes]");
	var _formType = "";
	for(var i=0;i<_formKpiTypes.length;i++){
		if(_formKpiTypes[i].checked){
			if(_formType!=''&&_formType!=null){
				_formType = _formType + ",";
			}
			_formType = _formType + $(_formKpiTypes[i]).val();
		}
	}
	$("#formKpiSub").val(_formType);
	$("#status").val(status);
	
	var _form = $('#formulaKpi').val();
	var _name = $('#formula_name').val();
	var _technical =  $('#technical').val();
	var _business =  $('#business').val();
	var _dimAuthor =  $('#dim_author').val();
	var _dimDept =  $('#dim_dept').val();
//	var _cond = $('#cond').children('tr');
//	if(_cond.length!=0){
//		var _condLast=_cond[_cond.length-1];
//		if(null!=_condLast){
//			var _td = $(_condLast).children('td');
//			var _type = $(_td[0]).attr('nodeid');
//			var _oper = $(_td[2]).attr('nodeid');
//			if(_cond.length>1&&_type=='0'&&_oper!=')'){
//				$.messager.alert("提示信息！", '约束条件错误！', "info");
//				clearArg();
//				return false;
//			}else if(_cond.length==1&&_type=='0'){
//				$.messager.alert("提示信息！", '约束条件错误！', "info");
//				clearArg();
//				return false;
//			}
//		}
//	}
//	if(_formType==null||_formType==""){
//		$.messager.alert("提示信息！", '请选择类型！', "info");
//		clearArg();
//		enbBut();
//		return false;
//	}
//	if(_form==""||null==_form){
//		$.messager.alert("提示信息！", '公式错误！', "info");
//		clearArg();
//		return false;
//	}
//	var _formulaKpi = $('#formulaKpi').val().split(',');
//	for(var i=0;i<_formulaKpi.length;i++){
//		if (_formulaKpi[i] == "undefined")
//		{
//			$.messager.alert("提示信息！", '公式错误！', "info");
//			clearArg();
//			return false;
//		}
//	}
	if(_name==""||null==_name||_name.length>100){
		$.messager.alert("提示信息！", '指标名称不能为空 ！', "info");
		clearArg();
		enbBut();
		return false;
	}
	if(vaildName==1){
		$.messager.alert("提示信息！", '指标名称己存在！', "info");
		enbBut();
		return false;
	}
	if(_technical==""||null==_technical){
		$.messager.alert("提示信息！", '请输入技术口径 ！', "info");
		clearArg();
		enbBut();
		return false;
	}
	if(_business==""||null==_business){
		$.messager.alert("提示信息！", '请输入业务口径 ！', "info");
		clearArg();
		enbBut();
		return false;
	}
	if(_dimAuthor==""||null==_dimAuthor){
		$.messager.alert("提示信息！", '请输入提出者 ！', "info");
		clearArg();
		enbBut();
		return false;
	}
	if(_dimDept==""||null==_dimDept){
		$.messager.alert("提示信息！", '请输入提出部门！', "info");
		clearArg();
		enbBut();
		return false;
	}
	var _operation = $("#operation").val();
	var _messager = "是否保存指标信息?";
	if(_operation.toLowerCase()=="update"){
		_messager = "保存后会生成新版本,确认保存吗?";
	}
	
	$.messager.confirm('提示信息', _messager, function(r){
		if (r){
			var _param = $('#condPar').val();
			cn.com.easy.kpi.service.FormulaService.vaildConds(_param,function(data){
			//$("#formKpi_type").val($("#acctData").find("option:selected").val());
				var _data = $.parseJSON(data);
				if(_data.res=="success"){
					$("#formKpiSub").val(_formType);
					$("#status").val(status);
					$("#formulaForm").get(0).enctype = "multipart/form-data";
					$("#formulaForm").get(0).encoding = "multipart/form-data";
					$('#formulaForm').attr("method","post");
					$('#formulaForm').attr("action","../../../formulaKpi.e");
					$("#formulaForm").get(0).target = 'hidden_frame';
					$('#formulaForm').submit();
				}else{
					$.messager.alert("提示信息！", "约束条件不正确！", "info");
					enbBut();
					return false;
				}
			});
		}else{
			clearArg();
			enbBut();
		}
	});
}
//保存草稿，现在没有用
function draft(status){
	formulaConvert();
	formulaToJson();
	paserCond();
	condToStr();
	var _name = $('#formula_name').val();
	if(_name==""||null==_name||_name.length>100){
		$.messager.alert("提示信息！", '指标名称错误 ！', "info");
		return false;
	}
	$("#status").val(status);
	$("#formulaForm").get(0).enctype = "multipart/form-data";
	$("#formulaForm").get(0).encoding = "multipart/form-data";
	$('#formulaForm').attr("method","post");
	$('#formulaForm').attr("action","../../../formulaKpi.e");
	$("#formulaForm").get(0).target = 'hidden_frame';
	$('#formulaForm').submit();
}
//确认指标是否存在审核状态
function validAudit(kpiCode){
	if(_currAdmin != '1') {
		if(_currUser != create_user) {
			$.messager.alert("提示信息！", "当前指标的创建人为"+  create_user_name +"，您不能做修改操作！", "info");
			$('#formulasaved').attr('disabled','disabled');
			$('#draft').addClass('prohibit_btn');
			$('#formulasaved').addClass('prohibit_btn');
			return;
		}
	}
	cn.com.easy.kpi.service.FormulaService.validAudit(kpiCode,function(data){
		var _data = $.parseJSON(data);
		if(_data.res=="success"){
			var _value = _data.count;
			if(_value>0){
				$.messager.alert("提示信息！", "选中指标存在待审核数据，请审核后再进行修改！", "info");
				$('#formulasaved').attr('disabled','disabled');
				$('#draft').addClass('prohibit_btn');
				$('#formulasaved').addClass('prohibit_btn');
			}
		}else{
			$.messager.alert("提示信息！", "获取条件值出错！", "info");
			return false;
		}
	});
}
function validMax(kpiCode,version){
	if(_currAdmin != '1') {
		if(_currUser != create_user) {
			$.messager.alert("提示信息！", "当前指标的创建人为"+  create_user_name +"，您不能做修改操作！", "info");
			$('#formulasaved').attr('disabled','disabled');
			$('#draft').addClass('prohibit_btn');
			$('#formulasaved').addClass('prohibit_btn');
			return;
		}
	}
	cn.com.easy.kpi.service.FormulaService.validMax(kpiCode,version,function(data){
		var _data = $.parseJSON(data);
		if(_data.res=="success"){
			var _value = _data.count;
			if(_value>0){
				$.messager.alert("提示信息！", "当前指标已存在新版本！", "info");
				$('#formulasaved').attr('disabled','disabled');
				$('#draft').addClass('prohibit_btn');
				$('#formulasaved').addClass('prohibit_btn');
			}
		}else{
			$.messager.alert("提示信息！", "获取条件值出错！", "info");
			return false;
		}
	});
}
//页面关闭
function closeFormula(){
	$.messager.confirm('提示信息', '确认关闭当前页面?', function(r){
		if (r){
			history.back(-1);
		}
	});
}
function kpiType(){
	var _type = $('#typeSelect  option:selected').val();
	var _text = $('#typeSelect  option:selected').text();
	var _id = $('#kpiType').val();
	var kpi_code = $('#'+_id).attr("nodeId");
	var kpi_text = $('#'+_id).html();
	kpi_code = kpi_code.substr(0,kpi_code.lastIndexOf("_"));
	$('#'+_id).attr("nodeId",kpi_code+"_"+_type);
	$('#'+_id).html(kpi_text.substr(0,kpi_text.lastIndexOf("_"))+"_"+_text+"<strong>X</strong>");
	spanEvent();
	if(_type!="A"){
		var _checkbox = $("input[name=formKpiTypes]");
		_checkbox.each(function(){
			$(this).attr('checked',false);
		});
		$(_checkbox[0]).attr('checked','checked');
		$("input[name=formKpiTypes]").attr('disabled',true);
	}
	$("#kpi_type").dialog('close');
}
function selectType(id){
	var _type = $('#' + id + '  option:selected').val();
	var _td = $('#'+id).parent("td");
	var _code = $(_td).attr("nodeId");
	_code = _code.substr(0,_code.lastIndexOf("_"));
	_td.attr("nodeId",_code + "_" + _type);
}
function typeSelect1(){
	var _type = $('#typeSelect1' + '  option:selected').val();
	$('#formKpi_type').val(_type);
}
function openDailog(){
	$('#formulaType').dialog('open');
}
function acctType(){
	var _type =  $("#acctData").find("option:selected").val();
	cn.com.easy.kpi.service.FormulaService.kpiAttr(_type,function(data){
		var _data = $.parseJSON(data);
		if(_data.res=="success"){
			var _value = _data.data;
			var _acctType = $("#acctType");
			_acctType.html('');
			for(var i=0;i<_value.length;i++){
				var _option=
				_acctType.append("<input type='checkbox' name='formKpiTypes' value='" +_value[i]['code'] + "'>"+_value[i]['text']);
			}
		}else{
			$.messager.alert("提示信息！", "获取出错！", "info");
			return false;
		}
	});
}
function acctTypeAle(acctType,sub){
	cn.com.easy.kpi.service.FormulaService.kpiAttr(acctType,function(data){
		var _data = $.parseJSON(data);
		var _sub = $.parseJSON(sub);
		if(_data.res=="success"){
			var _value = _data.data;
			var _acctType = $("#acctType");
			_acctType.html('');
			for(var i=0;i<_value.length;i++){
				for(var k=0;k<_sub.length;k++){
					if(_sub[k].ATTR_CODE==_value[i]['code']){
						_value[i].ischeck = "1";
					}
					
				}
			}
			for(var i=0;i<_value.length;i++){
				if(_value[i].ischeck=='1'){
					_acctType.append("<input type='checkbox' name='formKpiTypes' value='" +_value[i]['code'] + "' checked='checked'>"+_value[i]['text']);
				}else{
					_acctType.append("<input type='checkbox' name='formKpiTypes' value='" +_value[i]['code'] + "'>"+_value[i]['text']);
				}
			}
			var _falg = disExtA("tid");
			if(_falg&&_type!='1'){
				$("input[name=formKpiTypes]").attr('disabled','disabled');
			}
			var lookUpFlag = $("#lookUpFlag");
			if(lookUpFlag != undefined && lookUpFlag.val() == '1') {
				$("input[name=formKpiTypes]").attr('disabled','disabled');
			}
		}else{
			$.messager.alert("提示信息！", "获取出错！", "info");
			return false;
		}
	});
}
function acctTypeSub(text,kpi_code,version,accType,kpiIndex,id){
	cn.com.easy.kpi.service.FormulaService.acctTypeSub(kpi_code,version,accType,function(data){
		var _data = $.parseJSON(data);
		if(_data.res=="success"){
			var _value = _data.data;
			$('#'+id).find("option").remove();
			for(var i=0;i<_value.length;i++){
				$('#'+id).append("<option value='"+_value[i]['code']+"'>"+_value[i]['text']);
			}
			spanEvent();
		}else{
			$.messager.alert("提示信息", "获取出错！", "info");
			return false;
		}
		
	});
	
}
function acctTypeSub1(text,kpi_code,version,accType,kpiIndex,id){
	cn.com.easy.kpi.service.FormulaService.acctTypeSub(kpi_code,version,accType,function(data){
		var _data = $.parseJSON(data);
		if(_data.res=="success"){
			var _value = _data.data;
			$('#'+id).html('');
			for(var i=0;i<_value.length;i++){
//				$('#'+id).append("<option value='"+_value[i]['code']+"'>"+_value[i]['text']);
				$('#'+id).append("<div style='height:20px;width:160px' code='"+_value[i]['code']+"'>"+_value[i]['text']+"</div>");
			}
			if(_value.length>0){
				$('#'+kpiIndex).attr("nodeid",kpi_code + "_" + _value[0]['code']);
				$('#'+kpiIndex).html(text+"_"+_value[0]['text']+"<strong>X</strong>");
			}else{
				$.messager.alert("提示信息！", "获取扩展属性出错！", "info");
				return false;
			}
			if(_value[0]['code']!='A'){
				var _checkbox = $("input[name=formKpiTypes]");
				_checkbox.each(function(){
					$(this).attr('checked',false);
					if($(this).val()=='A'){
						$(this).attr('checked','checked');
					}
				});
				$("input[name=formKpiTypes]").attr('disabled',true);
			}
			$('#'+id+' div').on('mouseover',function(event){
				$(this).css('background-color','#2b579a');
			});
			$('#'+id+' div').on('mouseout',function(event){
				$(this).css('background-color','#FFFFFF');
			});
			$('#'+id+' div').on('click',function(event){
				var _m = this;
				clickSubType(_m);
			});
			spanEvent();
			if(_value.length>1){
				$("#kpi_type").dialog('open');
			}
		}else{
			$.messager.alert("提示信息！", "获取扩展属性出错！", "info");
			return false;
		}
		
	});
	
}

function clickSubType(m){
	var _type = $(m).attr('code');
	var _text = $(m).html();
	var _id = $('#kpiType').val();
	var kpi_code = $('#'+_id).attr("nodeId");
	var kpi_text = $('#'+_id).html();
	kpi_code = kpi_code.substr(0,kpi_code.lastIndexOf("_"));
	$('#'+_id).attr("nodeId",kpi_code+"_"+_type);
	$('#'+_id).html(kpi_text.substr(0,kpi_text.lastIndexOf("_"))+"_"+_text+"<strong>X</strong>");
	spanEvent();
	if(_type!="A"){
		var _checkbox = $("input[name=formKpiTypes]");
		_checkbox.each(function(){
			$(this).attr('checked',false);
			if($(this).val()=='A'){
				$(this).attr('checked','checked');
			}
		});
//		$(_checkbox[0]).attr('checked','checked');
		$("input[name=formKpiTypes]").attr('disabled',true);
	}
	$("#kpi_type").dialog('close');
}

function downLoadFile(fileName,filePath,urlPath) {
	window.location.href = urlPath + 'downLoadFile.e?fileName='+fileName+'&filePath='+filePath;
} 

function vaildKpiType(usedType,usedName,typeName,kpiType){
	var _falg = false;
	var _usedType = usedType.split(',');
	for(var _i = 0;_i<_usedType.length;_i++){
		if(_usedType[_i]==kpiType){
			_falg = true;
			return _falg;
		}
	}
	return _falg;
	
}
function setAcctTypeSub(o){
	var _index = $(o).attr('id').split('_');
	var _subCode =  $(o).attr('nodeid').split('_');
	var _kpiVersion = $('#base_key').val();
	cn.com.easy.kpi.service.AcctTypeSubService.subType(_kpiVersion,_index[0]+"_"+_index[1],function(data){
		var _data = $.parseJSON(data);
		if(_data.rs=="success"){
			var _subType = $('#sel'+_index[2]);
			var _sub =_data.data;
			for(var i=0;i<_sub.length;i++){
				if(_subCode[2]==_sub[i]['code']){
					_subType.append("<option value='"+_sub[i]['code']+"' selected='selected'>"+_sub[i]['text']);
				}else{
					_subType.append("<option value='"+_sub[i]['code']+"'>"+_sub[i]['text']);
				}
			}
		}else{
			$.messager.alert("提示信息！",_data.data, "info");
			return false;
		}
	});
}

function disbBut(){
	$('#formulasaved').attr('disabled','disabled');
	$('#draft').addClass('prohibit_btn');
	$('#formulasaved').addClass('prohibit_btn');
}
function enbBut(){
	$('#formulasaved').attr('disabled',false);
	$('#draft').removeClass('prohibit_btn');
	$('#formulasaved').removeClass('prohibit_btn');
}