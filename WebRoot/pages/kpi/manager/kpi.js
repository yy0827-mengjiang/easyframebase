var component = {};
function clickArea(e,id){
	component.type = $('#'+id).attr("myAttr");
	if("formkpi"==component.type){
		 component.id= id;
		 e.preventDefault();
	}else{
		 component.id =$('#'+id).attr("myChil");
	}
	$('#formKpi').css("border","1px #aeadab dashed");
	$('#conditionDiv').css("border","1px #aeadab dashed");
	$('#'+id).css("border","1px #aeadab dashed");
}


function clickNodeKpi(node){
	if(component.id==null||component.id==undefined||component.id=="")
	{
		$.messager.alert('信息提示','请先选择要添加组件！','info');
		return;
	}
	var isleaf = $(this).tree('isLeaf',node.target);
	if(isleaf){
		var type = component.type;
		var id = component.id;
		if("formkpi" == type){
			if('1'==node.attributes.type){
				$.messager.alert('信息提示','请不要将维度加入公式！','info');
				return;
			}
			var nodeName = node.text;
			var nodeId = node.id;
			nodeName = "<input type='button' class='delBtnB' kpiName = '" +nodeName+ "' kpiType = '" +node.attributes.type+ "' kpiId = '" + nodeId + "' value='"+nodeName+"'>";
			$('#'+id).attr("contenteditable",true);
			var sel; // 申明range 对象
			if (document.getSelection) { 
				insert($('#'+id)[0],nodeName);
			} else if (document.selection) {
				var  areaTxt = $('#'+id).html();
				$('#'+id).html(areaTxt + nodeName);
				var leng = $('#'+id).html().length
				sel = document.selection.createRange();// IE浏览器下的处理，如果要获取内容，需要在selection
														// 对象上加上text 属性
				sel.moveStart($('#'+id).html().length);
				sel.collapse(true);
				sel.select();
			}
			$('#'+id).focus();
			$('#kpiCode').val(","+nodeId);
		}else{
			if('1'==node.attributes.type){
				var nodeName = node.text;
				var nodeId = node.id;
				var type = node.attributes.type;
				var indexs = $('#'+id).datagrid('getRows').length;
				$('#dimName'+indexs).val(nodeId);
				$('#'+id).datagrid('insertRow',{index:indexs,row:{"dimName":nodeName,
			                                                            "ljf":"",
			                                                            "tjz":"",
			                                                            "ljkjf":"<input type='hidden' id='ljf_name"+indexs+"' name='ljf_name"+indexs+"' ><input type='hidden' id='ljkjf"+indexs+"' name='ljkjf"+indexs+"' ><input type='hidden' id='tjz"+indexs+"' name='tjz"+indexs+"' ><input type='hidden' id='did"+indexs+"' name='did"+indexs+"' ><input type='hidden' name='hidconstant"+indexs+"' id='hidconstant"+indexs+"' value='0'><input type='hidden' id='dimName"+indexs+"' name='dimName"+indexs+"' value='"+nodeId+"'><input type='hidden' id='isKpi"+indexs+"' name='isKpi"+indexs+"' value='0'>"}
														  });
				var dIndex = $('#dIndex').val();
				dIndex = dIndex+indexs+",";
				$('#dIndex').val(dIndex);
			}else{
				var nodeName = node.text;
				var nodeId = node.id;
				var type = node.attributes.type;
				var indexs = $('#'+id).datagrid('getRows').length;
				$('#dimName'+indexs).val(nodeId);
				$('#'+id).datagrid('insertRow',{index:indexs,row:{"dimName":nodeName,
			                                                            "ljf":"",
			                                                            "tjz":"",
			                                                            "ljkjf":"<input type='hidden' id='ljf_name"+indexs+"' name='ljf_name"+indexs+"' ><input type='hidden' id='ljkjf"+indexs+"' name='ljkjf"+indexs+"' ><input type='hidden' id='tjz"+indexs+"' name='tjz"+indexs+"' ><input type='hidden' id='did"+indexs+"' name='did"+indexs+"' ><input type='hidden' name='hidconstant"+indexs+"' id='hidconstant"+indexs+"' value='1'><input type='hidden' id='ljf"+indexs+"' name='ljf"+indexs+"' ><input type='hidden' id='dimName"+indexs+"' name='dimName"+indexs+"' value='"+nodeId+"'><input type='hidden' id='isKpi"+indexs+"' name='isKpi"+indexs+"' value='1'>"}
														  });
				var dIndex = $('#dIndex').val();
				dIndex = dIndex+indexs+",";
				$('#dIndex').val(dIndex);
			}
		}
	}

}

function chooseTjz(rowIndex, rowData) {
	if(-1 == rowIndex){
		return;
	}
	var dIndex = $('#dIndex').val();
	var dIndexArry = dIndex.substring(0,$('#dIndex').val().length-1).split(",");
	var index = dIndexArry[rowIndex];	
	var isConstant = $('#hidconstant'+index).val();
	$("#rowIndex").val(index);
	if('1'==isConstant){
		$("#dim1").attr("disabled",true);
		$("#dim1").html("");
		$("#dim_value1").attr("disabled",true);
		$("#dim_value1").html("");
		$("#constant").attr("checked",true);
		$("#clz0").attr("disabled",false);
		$("#clz0").val(rowData.tjz);
	}else if('0'==isConstant){
		$("#dim1").attr("disabled",false);
		$("#dim_value1").attr("disabled",false);
		$("#constant").attr("checked",false);
		$("#clz0").val("");
		$("#clz0").attr("disabled",true);
		var dimCode = $("#dimName"+index).val();
		var tjzId = $("#did"+index).val();
		var tjzName = $("#tjz"+index).val();
		$.ajax({
             type: "POST",
             url: "../manager/kpiAction.jsp?eaction=dimensionForId&oid="+dimCode+"&tjzId="+tjzId,
             dataType: "json",
             success: function(data){
                  var dim1 =$('#dim1');
                  var dim_value1 = $('#dim_value1');
                  dim1.html("");
                  $(dim_value1).html("");
                  for(var i=0;i<data.length;i++){
                  	dim1.append("<option value='"+data[i].KEY+"'>"+data[i].VALUE+"</option>");
                  }
                  var tjz = tjzId.split(",");
                  var tjzv = tjzName.split(",");
                  for(var i = 0;i<tjzv.length;i++){
                	  if('' != tjzv[i])
                		  dim_value1.append("<option value='"+tjz[i]+"'>"+tjzv[i]+"</option>");
                  }
                  $('#clz0').val("");
             }
         });
	}
	$('#tjz-dlg').dialog('open');
	
}
function removekpi(){
	var row = $('#conditionTable').datagrid('getSelected');
	var indexs = $('#conditionTable').datagrid('getRowIndex',row);
	var dIndex = $('#dIndex').val();
	var dIndexArry = dIndex.substring(0,$('#dIndex').val().length-1).split(",");
	dIndexArry.splice(indexs,1);
	var text ='';
	for(var i=0;i<dIndexArry.length;i++){
			text = text + dIndexArry[i]+",";
	}
	$('#dIndex').val(text);
	$('#conditionTable').datagrid('deleteRow',indexs);
}

function leftToRight(){
	var checkText=$("#dim1").find("option:selected");
	$('#dim_value1').append(checkText);

}

function rightToLeft(){
	var checkText=$("#dim_value1").find("option:selected");
	$('#dim1').append(checkText);
	
}

function onAgree(){
	var index = $("#rowIndex").val();
	var rows=$('#'+component.id).datagrid('getRows');// 获取所有当前加载的数据行
	var isKpi = $("#isKpi"+index).val();
	var row=rows[index];// /
	if($("#constant").is(':checked')){
		var nodeId = $("#dimName"+index).val();
		var rowData = {};
		rowData.dimName = row.dimName;
		rowData.ljf = $("#ljkjf  option:selected").text();
		rowData.tjz = $('#clz0').val();
		rowData.ljkjf = $("#ljf_name  option:selected").text()+"<input type='hidden' id='ljf_name"+index+"' name='ljf_name"+index+"' value='"+$('#ljf_name').val()+"' ><input type='hidden' id='ljkjf"+index+"' name='ljkjf"+index+"' value='"+$('#ljkjf').val()+"' ><input type='hidden' id='tjz"+index+"' name='tjz"+index+"' value='"+$('#clz0').val()+"' ><input type='hidden' id='did"+index+"' name='did"+index+"' value='' ><input type='hidden' name='hidconstant"+index+"' id='hidconstant"+index+"' value='0'><input type='hidden' id='dimName"+index+"' name='dimName"+index+"' value='"+nodeId+"'><input type='hidden' id='isKpi"+index+"' name='isKpi"+index+"' value='"+isKpi+"'>"; 
		var param = {"index": index, "row":rowData};
		$("#"+component.id).datagrid('updateRow',param);
		$('#hidconstant'+index).val('0');
		$('#ljkjf'+index).val($("#ljkjf").val());
		$('#ljf_name'+index).val($("#ljf_name").val());
	}else{
		var nodeId = $("#dimName"+index).val();
		var text = '';
		var did = '';
		$("#dim_value1 option").each(function(){ // 遍历全部option
	        var txt = $(this).text(); // 获取option的内容
	        var id = $(this).val();
	        text = text+txt+","; // 添加到数组中
	        did = did+id+',';
	    });
		$('#hidconstant'+index).val('1');
		$('#tjz_unit'+index).val(text.substring(0,text.length-1));
		$('#did'+index).val(did);
		$('#ljkjf'+index).val($("#ljkjf0").val());
		$('#ljf_name'+index).val($("#ljf_name").val());
		var rowData = {};
		rowData.dimName = row.dimName;
		rowData.tjz = text.substring(0,text.length-1);
		rowData.ljf = $("#ljkjf  option:selected").text();
		rowData.ljkjf = $("#ljf_name  option:selected").text()+"<input type='hidden' id='ljf_name"+index+"' name='ljf_name"+index+"' value='"+$('#ljf_name').val()+"' ><input type='hidden' id='ljkjf"+index+"' name='ljkjf"+index+"' value='"+$('#ljkjf').val()+"' ><input type='hidden' id='tjz"+index+"' name='tjz"+index+"' value='"+text+"' ><input type='hidden' id='did"+index+"' name='did"+index+"' value='"+did+"' ><input type='hidden' name='hidconstant"+index+"' id='hidconstant"+index+"' value='0'><input type='hidden' id='dimName"+index+"' name='kpiName"+index+"' value='"+nodeId+"'><input type='hidden' id='isKpi"+index+"' name='isKpi"+index+"' value='"+isKpi+"'>";
		var param = {"index": index, "row":rowData};
		$("#"+component.id).datagrid('updateRow',param);
	}
	$('#tjz-dlg').dialog('close');
}
function onAgree2(){
	
	var agr = {};
	agr.kpiName = $('#kpi_name0').val();// 复合指标名称
	agr.kpiUnit0 = $("#kpi_unit0  option:selected").text();// 复合指标单位
	agr.kpiUnit1 = $('#formKpi').html();// 复合指标公式（替换名称后）
	agr.formual = replaceForId($('#formKpi'));// 复合指标公式（替换ID后）
	agr.isFormula = $('#isFormula').val();// 是否公式
	agr.kpiCode = getFormUseKpi($('#formKpi'),0)// 标准指标ID
	agr.complexkpiCode = getFormUseKpi($('#formKpi'),1);// 复合指标ID
	agr.kpiCategory = $('#kpiCategory').val();// kpi_category分类
	agr.kpiCalIber = $('#kpiCalIber').val();// 指标说明
	agr.kpiExplain =$('#kpiExplain').val();// 技术指标
	agr.kpiVersion = $('#kpiVersion').val();// 版本号
	agr.kpiUser = $('#kpiUser').val();// 指标提出人
	agr.kpiDept = $('#kpiDept').val();// 批标提出部门
//	agr.kpiFile = getFileName($('#kpiFile').val());// 附件
	agr.code = $('#code').val();
	agr.kpiFile = $('#kpiFile').val();
	agr.dIndex = $('#dIndex').val();
	var dIndex = $('#dIndex').val().substring(0,$('#dIndex').val().length-1);
	var indexs = dIndex.split(',');
	var arr = new Array(indexs.length);
	var rows = $('#conditionTable').datagrid('getData');
	for(var i=0;i<indexs.length;i++){
		var row = rows.rows[i];
		var b = {};
		if(''!=indexs[i]){
			b.dimName = row.dimName;// 条件名称
			b.dimCode = $('#dimName'+indexs[i]).val();// 条件ID
			b.ljfName = $('#ljf_name'+indexs[i]).val();// 运算符
			b.tjzUnit = $('#tjz'+indexs[i]).val();// 值
			b.constant = $('#hidconstant'+indexs[i]).val();// 是否常量
			b.did = $('#did'+indexs[i]).val();// 值ID
			b.ljkjf  = $('#ljkjf'+indexs[i]).val();;// 连接符
			b.isKpi = $('#isKpi'+indexs[i]).val();// 是否指标
			
			arr[i] = b;
		}
	}
	//用户手动输入的查询条件
	var cond = $('#condition').val();
	if(cond.length!=0||cond!=''){
		if(cond.toUpperCase().indexOf("WHERE")==0){
			$.messager.alert("提示信息！", "手动输入条件中不要输入where关键字!", "info");
		}else{
			arg.cond=cond;
		}
	}
	agr.arr = arr;
	if(agr.kpiName.length == 0||agr.kpiName==''){
		$.messager.alert("提示信息！", "复合指标名称为空!", "info");
	}
	if(agr.kpiName.length > 100){
		$.messager.alert("提示信息！", "复合指标名称超长!", "info");
	}
	$.ajax({
		type : "POST",
		url : "../manager/ajax.jsp?eaction=name&name=" + agr.kpiName,
		dataType : "json",
		success : function(date) {
			if (date.C > 0) {
				$.messager.alert("提示信息！", "复合指标名称己存在!", "info");
			} else {
				$.ajax({
					type : "POST",
					url : "../../../kpiAdd.e",
					dataType : "json",
					data : agr,
					success : function(data) {
						$.messager.alert("提示信息！", "复合指标创建成功!", "info");
						$("#kpi").html("");
					}

				});
			}
		}
	});
}

function onAgree3(){
	var agr = {};
	agr.kpiName = $('#kpi_name0').val();// 复合指标名称
	agr.kpiUnit0 = $("#kpi_unit0  option:selected").text();// 复合指标单位
	agr.kpiUnit1 = $('#formKpi').html();// 复合指标公式（替换名称后）
	agr.formual = replaceForId($('#formKpi'));// 复合指标公式（替换ID后）
	agr.isFormula = $('#isFormula').val();// 是否公式
	agr.kpiCode = getFormUseKpi($('#formKpi'),0);// 标准指标ID
	agr.complexkpiCode = getFormUseKpi($('#formKpi'),1);// 复合指标ID
	agr.kpiCalIber = $('#kpiCalIber').val();// 指标说明
	agr.kpiExplain =$('#kpiExplain').val();// 技术指标
	agr.kpiVersion = $('#kpiVersion').val();// 版本号 
	agr.kpiUser = $('#kpiUser').val();// 指标提出人
	agr.kpiDept = $('#kpiDept').val();// 批标提出部门
//	agr.kpiFile = getFileName($('#kpiFile').val());// 附件
	agr.kpiFile = $('#kpiFile').val();
	agr.dIndex = $('#dIndex').val();
	agr.kpiCategory = $('#kpiCategory').val();
	agr.code=$('#code').val();
	agr.oid=$('#oid').val();
	var dIndex = $('#dIndex').val().substring(0,$('#dIndex').val().length-1);
	var indexs = dIndex.split(',');
	var arr = new Array(indexs.length);
	var rows = $('#conditionTable').datagrid('getData');
	for(var i=0;i<indexs.length;i++){
		var row = rows.rows[i];
		var b = {};
		if(''!=indexs[i]){
			b.dimName = row.dimName;// 条件名称
			b.dimCode = $('#dimName'+indexs[i]).val();// 条件ID
			b.ljfName = $('#ljf_name'+indexs[i]).val();// 运算符
			b.tjzUnit = $('#tjz'+indexs[i]).val()+",";//.substring(0,$('#tjz'+indexs[i]).val().length-1);// 值
			b.constant = $('#hidconstant'+indexs[i]).val();// 是否常量
			b.did = $('#did'+indexs[i]).val();// 值ID
			b.ljkjf  = $('#ljkjf'+indexs[i]).val();;// 连接符
			b.isKpi = $('#isKpi'+indexs[i]).val();// 是否指标
			
			arr[i] = b;
		}
	}
	//用户手动输入的查询条件
	var cond = $('#condition').val();
	if(cond.length!=0||cond!=''){
		if(cond.toUpperCase().indexOf("WHERE")==0){
			$.messager.alert("提示信息！", "手动输入条件中不要输入where关键字!", "info");
		}else{
			arg.cond=cond;
		}
	}
	agr.arr = arr;
	if(agr.kpiName.length == 0||agr.kpiName==''){
		$.messager.alert("提示信息！", "复合指标名称为空!", "info");
	}
	if(agr.kpiName.length > 100){
		$.messager.alert("提示信息！", "复合指标名称超长!", "info");
	}
	$.ajax({
		type : "POST",
		url : "../manager/ajax.jsp?eaction=name&name=" + agr.kpiName,
		dataType : "json",
		success : function(data) {
			if (data.C > 0) {
				$.messager.alert("提示信息！", "复合指标名称己存在!", "info");
			} else {
				$.ajax({
					type : "POST",
					url : "../../../kpiUpdate.e",
					dataType : "json",
					data : agr,
					success : function(data) {
						$.messager.alert("提示信息！", "复合指标修改成功!", "info");
						$("#kpi").html("");
					}
				});
			}
		}
	});
	 
	
}

$(function(){
	if ((typeof Range !== "undefined") && !Range.prototype.createContextualFragment) {
	      Range.prototype.createContextualFragment = function(html) {
	          var frag = document.createDocumentFragment(), 
	          div = document.createElement("div");
	          frag.appendChild(div);
	          div.outerHTML = html;
	          return frag;
	      };
	 }
});
function saveRange(){
	 var selection= window.getSelection ? window.getSelection() : document.selection;
	 var range= selection.createRange ? selection.createRange() : selection.getRangeAt(0);
	 _range = range;
}
function insert(obj,text) {
	if (!window.getSelection){
		 obj.focus();
		 var selection= window.getSelection ? window.getSelection() : document.selection;
		 var range= selection.createRange ? selection.createRange() : selection.getRangeAt(0);
		 range.pasteHTML(str);
		 range.collapse(false);
		 range.select();
	} else {
		 obj.focus();
		 var selection= window.getSelection ? window.getSelection() : document.selection;
		 selection.addRange(_range);
		 range = _range;
		 range.collapse(false);
		 var hasR = range.createContextualFragment(text);
		 var hasR_lastChild = hasR.lastChild;
		 while (hasR_lastChild && hasR_lastChild.nodeName.toLowerCase() == "br" && hasR_lastChild.previousSibling && hasR_lastChild.previousSibling.nodeName.toLowerCase() == "br") {
			 var e = hasR_lastChild;
			 hasR_lastChild = hasR_lastChild.previousSibling;
			 hasR.removeChild(e);
		 }
		range.insertNode(hasR);
		if (hasR_lastChild) {
			 range.setEndAfter(hasR_lastChild);
			 range.setStartAfter(hasR_lastChild)
		}
		 selection.removeAllRanges();
		 selection.addRange(range);
	}
}
function getFormUseKpi(obj,type){
	var txtFormId = "" ;
	var txtKpiId = "" ;
	var but = obj.find("input[type='button']");
	for(var i=0;i < but.length;i++){
		var t = $(but[i]);
		var txt = t.attr("kpiId");
		var kpiType = t.attr("kpiType");
		if(kpiType=='3'){
			txtFormId = txtFormId + "," + txt;
		}else if(kpiType=='2'){
			txtKpiId = txtKpiId + "," + txt;
		}
		
	  }
	if('1'==type){
		return txtFormId.substring(1,txtFormId.length);
	}else{
		return txtKpiId.substring(1,txtKpiId.length);
	}
	
}
function replaceForId(obj){
	var htm = obj.html();
	var i = 0;
	while(true){
		var k =  htm.indexOf("<");
		i = htm.indexOf(">");
		if(i==-1){
			break;
		}
		var prefix = htm.substring(0,k);
		var middle = htm.substring(k,i+1);
		var suffix= htm.substring(i+1,htm.length);
		var id = $(middle).attr("kpiId");
		htm = prefix + "{"+id+"}" + suffix;
	}
	
	return htm;
}
function getFileName(o){
    var pos=o.lastIndexOf("\\");
    return o.substring(pos+1);  
}








