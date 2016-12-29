<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="kpi">
	SELECT T.ACCTTYPE,T.cube_code,T.KPI_TYPE,T.KPI_CATEGORY,T.KPI_CODE,T.KPI_CALIBER,T.KPI_EXPLAIN,T.KPI_USER,T.KPI_DEPT,T.EXPLAIN,T.KPI_NAME,T.KPI_VERSION FROM X_KPI_INFO_TMP T WHERE T.KPI_KEY='${id }'
</e:q4o>
<e:q4l var="formulaSub">
	select t1.attr_code from x_kpi_info_tmp t ,X_KPI_ATTR_RELATION t1 where t.kpi_code=t1.kpi_code and t.kpi_version = t1.kpi_version and t.kpi_key='${id }'
</e:q4l>
<e:q4l var="formulaObj">
	SELECT T.ID,T.NAME,T.FORMULA,T.FORMULA_EXPLAIN FROM X_KPI_FORMULA T
</e:q4l>
<e:q4l var="unit">select code,name from x_kpi_code where type='0' order by ord</e:q4l>
<e:q4l var="opter">select code,name from x_kpi_code where type='1' order by ord</e:q4l>
<e:q4l var="logical">select code,name from x_kpi_code where type='2' order by ord</e:q4l>
<e:q4o var="typeInfo">
	SELECT T.TYPE_CODE,T.TYPE_NAME,T.USED_TYPE,T.VIEW_RULE,T.SERVER_VIEW FROM X_KPI_TYPE T WHERE T.TYPE_CODE ='${kpi_type}' AND T.TYPE_STATUS='1'
</e:q4o>
<e:if condition="${typeInfo.USED_TYPE != null && typeInfo.USED_TYPE !='' }">
<e:q4l var="userType">
	SELECT TYPE_NAME FROM X_KPI_TYPE T WHERE T.TYPE_CODE IN (${typeInfo.USED_TYPE })
</e:q4l>
</e:if>
<e:q4o var="cubeInfo">
	SELECT T.CUBE_CODE,T.ACCOUNT_TYPE,T.CUBE_DATASOURCE FROM X_KPI_CUBE T WHERE T.CUBE_CODE='${kpi.cube_code }'
</e:q4o>
<e:q4l var="kpiType">select code,name from X_KPI_CODE_TYPE where type='1' order by ord</e:q4l>
<e:q4l var="serviceType">select code,name from X_KPI_CODE_TYPE where type='2' order by ord</e:q4l>
<e:q4l var="classification">select code,name from X_KPI_CODE_TYPE where type='3' order by ord</e:q4l>
<e:q4l var="cycle">select code,name from X_KPI_CODE_TYPE where type='4' and accountype='${kpi.ACCTTYPE }' order by ord</e:q4l>
<e:q4l var="reservedAttr">select code,name from X_KPI_CODE_TYPE where type='6' order by ord</e:q4l>
<!DOCTYPE>
<html>
  <head>
    
    <title>新建复合指标</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<e:service/>
	<e:script value="/resources/easyResources/component/easyui/jquery.easyui.min.js" />
	<e:script value="/pages/kpi/formulaKpi/setFormula.js" />
	<script type="text/javascript">
		var _accountType = '${kpi.ACCTTYPE}';
		var _type = '${kpi.KPI_TYPE}';
		var comCode = '${kpi.KPI_CODE }';
		var _logi='${e:java2json(logical.list)}';
		var oper = '${e:java2json(opter.list)}';
		var _selectOption = "";
		var _usedType = '${typeInfo.USED_TYPE}';
		var _typeName = '${typeInfo.TYPE_NAME}';
		var _usedName = {};
		<e:if condition="${typeInfo.USED_TYPE != null && typeInfo.USED_TYPE !='' }">
			_usedName = $.parseJSON('${e:java2json(userType.list)}');
		</e:if>
		$(function(){
			$('#formulaBut').hide();
			$('#ysArea').hide();
			$("#showFormular").hide();
			var _viewRule = '${typeInfo.VIEW_RULE}';
			var _rule = _viewRule.split(",");
			if(_viewRule != "") {
				for(var _i=0;_i<_rule.length;_i++){
					if(_rule[_i]=='1'){
						$("#showFormular").show();
					}
					if(_rule[_i]=='2'){
						$('#formulaBut').show();	
					}
					if(_rule[_i]=='3'){
						$('#ysArea').show();	
					}
				} 
			}
			//设置业务编码
			if(${typeInfo.SERVER_VIEW}=="1"){
				var _data = $.parseJSON('${e:java2json(classNum.list)}');
				var _serviceCode =$.parseJSON('${serviceCode}');
				for(var i=0;i<_data.length;i++){
	   			 $('#' + _data[i].CLASS_NAME + 'Val').html($(_serviceCode).attr(_data[i].CLASS_NAME));
	   			 $('#' +_data[i].CLASS_NAME).val($(_serviceCode).attr(_data[i].CLASS_NAME));
   		 		}
			}
			//根据后台反回的字符串，回显公式
			strToformula('${formulaStr}','tid');
			//根据后台反回的字符串，回显约束条件
			strTocond('${condStr}','cond');
			//如果当前指标存在待审核，隐藏保存按钮
			//validAudit('${kpiCode}');
			//回显指标类型
			acctTypeAle('${kpi.ACCTTYPE}','${e:java2json(formulaSub.list)}');
			$('.condTab').droppable({  
				onDragEnter: function (e, source) {  
		        	$(source).draggable("proxy").find("span.tree-dnd-icon").removeClass("tree-dnd-no tree-dnd-no").addClass("tree-dnd-yes");
		        },
		        onDrop:function(e,s){
		        	//获取约束条件Table的总行数
		        	var index = $(".condTab tr").length;
		        	//生成约束条件中指标的账期下拉框
		        	var __type = "<select id='sel"+index+"' onchange=\"selectType('sel"+index+"')\"><option value=''>--请选择--</select>";
		        	//生新约整条件中运算符下拉框
		        	var _select = opter('${e:java2json(opter.list)}');
		        	//获取拖拽的数据在左侧树的node结点
		        	var node = $('#tt').tree('getNode', s);
		        	//获取拖拽的数据是否是叶子结点
		        	var isleaf = $(this).tree('isLeaf',node.target);
		        	//设置约束条件的值下拉框--空的
		        	var _selectVal="<select style='width:300px' attrName='nodeId'></select>";
		        	//如果是基础指标\复合指标运行if
		        	if(isleaf){
			        	var _dropNode = node.attributes.node_type;
	    				var _dropDate = node.attributes.data_type;
			        	if(_dropNode=='KPI'){
			        		if(!vaildKpiType(_usedType,_usedName,_typeName,node.attributes.kpi_type)){
			        			var _text = ""
			        				for(var i=0;i<_usedName.length;i++){
			        					if(_text.length>2){
			        						_text += "，";
			        					}
			        					_text += _usedName[i].TYPE_NAME;
			        				}
			    	        	$.messager.alert("提示信息！", _typeName + "只能使用" + _text, "info");
				        		return false;
				        	}
			        		if(_dropDate=='3'){
			        			var _tr = "";
		        				if(node.attributes.kpi_type!='5'){
		        					_tr = '<tr><td  name="nodeType" nodeID="'+node.attributes.kpi_type+'"><input type="checkbox" name="condCB" id="'+index+'" nodeId="'+node.id+'"></td><td id="'+node.attributes.code+'_'+index+'" name="nodeId" nodeId="'+node.attributes.code+'" dimType="">'+node.text+'</td><td name="oper" nodeId="0">'+_select+'</td><td name="condval" id="cond'+index+'" nodeId="0" condAttr="" attrVal=""><input type="text" value="0" style="width:300px"  attrName="nodeId"></td></tr>';
		        				}else {
		        					//标签中条件值只有1和0
		    		        		var _labeSelect ='<select style="width:400px" attrName="nodeId"><option value="1">是</option><option value="0">否</option></select>';
		    		        		//生成标签的tr
		    		        		_tr = '<tr><td name="nodeType" nodeID="'+node.attributes.kpi_type+'"><input type="checkbox" name="condCB" id="'+index+'" nodeId="'+node.id+'"></td><td nodeId="'+node.attributes.code+'" name="nodeId" dimType="">'+node.text+'</td><td  name="oper" nodeId="0">'+_select+'</td><td name="condval" id="cond'+index+'" nodeId="1" " condAttr="" attrVal="" >'+_labeSelect+'</td></tr>';
		        				}
			        			//将TR追加到table
			        			$(this).append(_tr);
			        			checkBoxOper();
					        	//为运算符下拉框绑定事件
					        	selectOper();
					        	if(node.attributes.kpi_type =='4'){
					        		//为约束条件的值绑定事件
						        	inputOper();
					        	}else if(node.attributes.kpi_type=='5'){
					        		//为条件值绑定事件
					        		selectVal();
					        	}
			        		}else{
			        			var _tr = "";
			        			if(node.attributes.kpi_type=='5'){
			        				//标签中条件值只有1和0
		    		        		var _labeSelect ='<select style="width:400px" attrName="nodeId"><option value="1">是</option><option value="0">否</option></select>';
		    		        		//生成标签的tr
		    		        		_tr = '<tr><td name="nodeType" nodeID="'+node.attributes.kpi_type+'"><input type="checkbox" name="condCB" id="'+index+'" nodeId="'+node.id+'"></td><td nodeId="'+node.attributes.code+'" name="nodeId" dimType="">'+node.text+'</td><td  name="oper" nodeId="0">'+_select+'</td><td name="condval" id="cond'+index+'" nodeId="1"  condAttr="" attrVal="" >'+_labeSelect+'</td></tr>';
		    		        	}else{
			        				//生成一个tr
				        			_tr = '<tr><td  name="nodeType" nodeID="'+node.attributes.kpi_type+'"><input type="checkbox" name="condCB" id="'+index+'" nodeId="'+node.id+'"></td><td id="'+node.attributes.code+'_'+index+'" name="nodeId" nodeId="'+node.attributes.code+"_A"+'" dimType="">'+node.text+__type+'</td><td name="oper" nodeId="0">'+_select+'</td><td name="condval" id="cond'+index+'" nodeId="0" condAttr="" attrVal=""><input type="text" value="0" style="width:300px"  attrName="nodeId"></td></tr>';
						        	/* var _tr = '<tr><td name="nodeType" nodeId="2"><input type="checkbox" name="condCB" id="'+index+'"></td><td nodeId="BK_20160229131737" name="nodeId">dsfdsf</td><td name="oper" nodeId="0">'+_select+'</td><td  name="condval" nodeId=""><input type="text"></td></tr>'; */
			        			}
			        			//将TR追加到table
					        	$(this).append(_tr);
					        	//通过结点的数据获取指标的类型
					        	acctTypeSub(node.text,node.attributes.code,node.attributes.version,node.attributes.account,node.attributes.code + "_" + index,'sel'+index);
					        	//acctTypeSub(node.attributes.code,'3','1',node.attributes.code + '_' + index,'sel'+index);
					        	//结tr中的checkbox绑定事件
					        	checkBoxOper();
					        	//为运算符下拉框绑定事件
					        	selectOper();
					        	//为约束条件的值绑定事件
					        	inputOper();
					        	selectVal();
			        		}
			        	}else if(_dropNode=='DIM'){
			        		//获取维度属性（R、常规 D、日账 M、月账）
			        		var _dimAttr = node.attributes.dim_attr;
			        		if('R'==_dimAttr){
			        			_tr = '<tr><td name="nodeType" nodeID="'+node.attributes.kpi_type+'"><input type="checkbox" name="condCB" id="'+index+'" nodeId="'+node.id+'"></td><td nodeId="'+node.attributes.code+'" name="nodeId" dimType="'+node.attributes.kpi_type+'">'+node.text+'</td><td  name="oper" nodeId="0">'+_select+'</td><td name="condval" id="cond'+index+'" nodeId="" condAttr="' + _dimAttr + '" attrVal="" ondblclick="openCondValue(\'cond'+index+'\')">'+_selectVal+'</td></tr>';
		        			}else{
		        				_tr = '<tr><td name="nodeType" nodeID="'+node.attributes.kpi_type+'"><input type="checkbox" name="condCB" id="'+index+'" nodeId="'+node.id+'"></td><td nodeId="'+node.attributes.code+'" name="nodeId" dimType="'+node.attributes.kpi_type+'">'+node.text+'</td><td  name="oper" nodeId="0">'+_select+'</td><td name="condval" id="cond'+index+'" nodeId="" condAttr="' + _dimAttr + '" attrVal="0"  ondblclick="openCondValue(\'cond'+index+'\')">'+_selectVal+'&nbsp;偏移量：<input type="text" style="width:300px" attrName="attrVal" value="0"></td></tr>';
		        			}
			        		//将生成的tr追加到约束条件table中
				        	$(this).append(_tr);
			        		//维度默认下拉框值
			        		CondValue(node.attributes.code,"cond"+index);
			        		//为下拉框绑定事件
			        		selectVal();
			        		//为checkbox绑定事件
				        	checkBoxOper();
				        	//为连接符绑定事件
				        	selectOper();
			        	}else if(_dropNode=='ATTR'){
			        		var mydate = new Date();
	        			   	var str =mydate.getFullYear()+"-";
	        			    str += (mydate.getMonth()+1)+"-";
	        			    str += mydate.getDate();
		        			if('R'==_dimAttr){
		        				_tr = '<tr><td name="nodeType" nodeID="'+node.attributes.kpi_type+'"><input type="checkbox" name="condCB" id="'+index+'" nodeId="'+node.id+'"></td><td nodeId="'+node.attributes.code+'" name="nodeId" dimType="'+_dropNode+'">'+node.text+'</td><td  name="oper" nodeId="0">'+_select+'</td><td name="condval" id="cond'+index+'" nodeId="0" condAttr="' + _dimAttr + '" attrVal="" ><input type="text" value="" style="width:300px" attrName="nodeId"></td></tr>';
		        			}else{
		        				_tr = '<tr><td name="nodeType" nodeID="'+node.attributes.kpi_type+'"><input type="checkbox" name="condCB" id="'+index+'" nodeId="'+node.id+'"></td><td nodeId="'+node.attributes.code+'" name="nodeId" dimType="'+_dropNode+'">'+node.text+'</td><td  name="oper" nodeId="0">'+_select+'</td><td name="condval" id="cond'+index+'" nodeId="' + str + '" condAttr="' + _dimAttr + '" attrVal="0" ><input type="text" value="' + str + '" style="width:300px"  attrName="nodeId">&nbsp;偏移量：<input type="text" style="width:300px"  attrName="attrVal" value="0"></td></tr>';
		        			}
		        			//将生成的tr追加到约束条件table中
				        	$(this).append(_tr);
		        			//为input绑定事件
			        		inputOper();
			        		//为checkbox绑定事件
				        	checkBoxOper();
				        	//为连接符绑定事件
				        	selectOper();
			        	}else{
			        		$.messager.alert("提示信息！", "错误的类型结点！", "info");
	    	        		return false;
			        	}
			        }else{
			        	$.messager.alert("提示信息！", "非法数据！", "info");
		        		return false;		  
			        }
		        }
		    });
		});
		
		function addLogical(){
			var index = $(".condTab tr").length;
			var _select = opter(_logi)
			var _tr = '<tr><td name="nodeType" nodeId="0"><input type="checkbox" name="condCB" id="'+index+'"></td><td name="nodeId" nodeId="">逻辑符</td><td name="oper" nodeId="and">'+_select+'</td><td name="condval" nodeId=""></td></tr>';
			$('#cond').append(_tr);
			$("td>select").on("change",function(){
        		var _value = $(this).find("option:selected").val();
        		var _td = $(this).parents("td");
        		_td.attr("nodeId",_value);
        	});
		}
		function callback(msg,flag)   
		{   if(msg == '提交版本成功') {
				msg = '指标信息保存成功';
			}else if (msg == '提交版本失败') {
				msg = '指标信息保存失败';
			}
			$.messager.alert('提示信息！', msg, 'info',function(){  
				if(flag!="1"){
					enbBut();
					return false;
				}else{
					window.location.href='<e:url value="pages/kpi/kpifaile/kpifaile.jsp"/>';
				}
			});
		}
		function doReturn() {
			window.location.href ='kpifaile.jsp';
		}
	</script>
  </head>
  
  <body>
  <input type="hidden" id="SEL_CUBE_CODE" name="SEL_CUBE_CODE" value="${kpi.cube_code }"/>
  <input type="hidden" id="operFlag" name="operFlag" value="upt"/>
  <div class="kpi_guide">
  <div class="tit_div">
		<h3>基础信息</h3>
	</div>
	</div>
	<div class="editBase_div">
	<form id="formulaForm" enctype="multipart/form-data">
		<input type="hidden" name="isPublish" id="isPublish" value="true">
		<input type="hidden" name="operation" id="operation" value="update">
		<input type="hidden" name="baseType" id="baseType" value="3">
		<input type="hidden" name="parentId" id="parentId" value="${kpi.KPI_CATEGORY }">
		<input type="hidden" name="types" id="types" value="${kpi.KPI_TYPE}">
		<input type="hidden" name="cubeCode" id="cubeCode" value="${kpi.CUBE_CODE }">
		<input type="hidden" name="kpis" id="kpis">
		<input type="hidden" name="formulaStr" id="formulaStr">
		<input type="hidden" name="formula" id="formula">
		<input type="hidden" name="formulaKpi" id="formulaKpi">
		<input type="hidden" name="condStr" id="condStr">
		<input type="hidden" name="condJson" id="condJson">
		<input type="hidden" name="condPar" id="condPar">
		<input type="hidden" name="status" id="status">
		<input type="hidden" name="formKpi_type" id="formKpi_type" value="${kpi.ACCTTYPE }">
		<input type="hidden" name="formKpiSub" id="formKpiSub">
		<input type="hidden" name="fkId" id="fkId" value="${id }">
		<input type="hidden" name="base_key" id="base_key" readonly="readonly" value="${kpi.KPI_CODE }"></dd>
		<div class="editBase_div_child">
		<e:if condition="${typeInfo.SERVER_VIEW=='1' }">
		<dl class="ddLine">
			<dt>指标编码：</dt>
			<input type="hidden" name="codeId" id="codeId" value="${codeId }" readonly="readonly" style="width: 12%; height:26px;">
			<dd class="kpiTableArea">
				<div class="kpiTrTop">
					<e:forEach items="${classNum.list }" var="class">
						<span class="kpiCodeCol" id="${class.CLASS_NAME }Val" height="30px">
						</span>
					</e:forEach>
						<span class="kpiCodeCol" id="codeIdVal" height="30px">
								${codeId }
						</span>
				</div>
			<table>
				<tr class="kpiTrBot">
				<e:forEach items="${classNum.list }" var="class" indexName="index">
					<td width="${100/classCount.C }%" >
					<select id="${class.CLASS_NAME }"  codeStart="${index*2}" name="${class.CLASS_NAME }" style="width: 100%; height:26px;">
						<e:q4l var="kpiType">select code,name from X_KPI_CODE_TYPE where type='${class.ID }' order by ord</e:q4l>
						<e:forEach items="${kpiType.list}" var="kt">
		                 	<option value ="${kt.CODE}">${kt.NAME}</option>	
		           		</e:forEach>	
					</select>
					</td>
				</e:forEach>
				</tr>
				</table>
		</dl>
		</e:if>
		<e:if condition="${typeInfo.EXT_VIEW=='1' }">
			<dl class="ddLine">
				<dt>扩展属性：</dt>
				<dd>
					<div id="acctType">
	             	</div>
				</dd>
			</dl>
		</e:if>
		<dl>
			<dt>指标名称：</dt>
			<dd><input type="text" name="formula_name" id="formula_name" onblur="validName()" value="${kpi.KPI_NAME }"><B style="color: red;">&nbsp;*</B></dd>
			<dt>指标版本：</dt>
			<dd><input type="text" name="tmp_version" id="tmp_version" readonly="readonly" value="${kpi.KPI_VERSION }">
				<input type="hidden" name="formula_version" id="formula_version" readonly="readonly" value="${kpi.KPI_VERSION+1 }">
			</dd>
		</dl>
		<dl class="ddLine">
			<dt>业务口径：</dt>
			<dd><textarea rows="3" cols="100" name="business" id="business">${kpi.KPI_EXPLAIN }</textarea><B style="color: red;">&nbsp;*</B></dd>
		</dl>
		<dl class="ddLine">
			<dt>技术口径：</dt>
			<dd><textarea rows="3" cols="100" name="technical" id="technical" disabled="disabled">${kpi.KPI_CALIBER }</textarea></dd>
		</dl>
		<dl>
			<dt>提出者：</dt>
			<dd>
				<input type="text" id="dim_author" name="dim_author" value="${kpi.KPI_USER }"><B style="color: red;">&nbsp;*</B>
			</dd>
	
			<dt>提出部门：</dt>
			<dd>
				<input type="text" id="dim_dept" name="dim_dept" value="${kpi.KPI_DEPT }"><B style="color: red;">&nbsp;*</B>
			</dd>
		</dl>
		<dl class="ddLine">
			<dt>需求来源：</dt>
			<dd>
				<textarea rows="3" cols="100" id="explain" name="explain">${kpi.EXPLAIN }</textarea><br>
				<input type="file" id="upload_file_name" name="upload_file_name">
				<div id="uploadFile">
					<e:if condition="${fileName != null && fileName !=''}">
						<a href="javascript:void(0)" onclick="downLoadFile('${fileName}','${filePath}','../../../')">
							${fileName}
						</a>
						<span>
							<a href="javascript:void(0)" onclick="delFile();">X</a>
						</span>
					</e:if>
				</div>
			</dd>
		</dl>
		</div>
		<iframe name='hidden_frame' id="hidden_frame" style='display:none'></iframe>
	</form>
	</div>
  <div class="kpi_guide">
  	<div id="showFormular" style="display: none;">
	  	<div class="tit_div">
			<h3>指标公式</h3>
			<span id="formulaBut" >
				<button type="button" name="setFormula" id="setFormula" onclick="addFormula()">使用公式</button>
				<button type="button" name="setFormula" id="setFormula" onclick="setFormula()">配置公式</button>
			</span>
		</div>
		<table cellpadding="0" cellspacing="1" class="formular_table">
			<thead>
				<tr>
					<th width="5%">序号</th> 
					<th class="td_left">名称/公式</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>1</td>
					<td>
						<p id="tid" class="boxTextP">
						</p>
					</td>
				</tr>
			</tbody>
		</table>
		
	</div>
	<div id="ysArea">
		<div class="tit_div">
			<h3>约束条件</h3>
			<span>
				<button type="button" name="addLogical" id="addLogical" onclick="addLogical()">添加逻辑符</button>
				<button type="button" name="delFormula" id="delFormula" onclick="delCond()">删除条件</button>
			</span>
		</div>
		<table class="condTab formular_table" cellpadding="0" cellspacing="1">
			<thead>
				<tr>
					<th width="5%"><input type="checkbox" id="all" name="all" onclick="allCheck()"></th>
					<th width="15%">名称/公式</th> 
					<th width="25%">连接符</th> 
					<th>条件值</th>
				</tr>
			</thead>
			<tbody id="cond">
			</tbody>
		</table>
	</div>
	<dl class="btn_div">
		<!-- <button onclick="draft('draft')" id="draft">保存草稿</button> -->
		<button onclick="formulasaved('0')" id="formulasaved">保存</button>
		<button onclick="doReturn()">返回</button>
	</dl>
	</div>
	<div id="formula-dlg" class="easyui-dialog" title="选择公式" style="width:600px;height:480px;" data-options="closed:true,modal:true">
   	<div id="dim_conds_dlg" class="easyui-dialog" title="包含条件" style="width:515px;height:330px;" data-options="closed:true,modal:true" buttons="#dlg-buttons">
   		<div class="twoSelectL">
			<h4>维度</h4>
			<select id="dim1" name="dim1" style="width:190px; height: 200px;" multiple="multiple">
	    	</select>
		</div>
		<div class="twoSelectM"><a href="javascript:void(0)"class="easyui-linkbutton" onClick="leftToRight()" plain="true">&gt;&gt;</a>
	   				<a href="javascript:void(0)"class="easyui-linkbutton" onClick="rightToLeft()" plain="true">&lt;&lt;</a></div>
		<div class="twoSelectR">
			<h4>值</h4>				
			<select id="dim_value1" name="dim_value1" style="width:190px; height: 200px;" multiple="multiple">
		    </select>
		</div>
		<input type="hidden" id="srcId" srcId="">
	</div>
	<div id="dlg-buttons"><a href="javascript:void(0)" class="easyui-linkbutton"  onclick="onAgree()">确认</a></div>
	<!-- 指标属性 -->
	<div id="kpi_type" class="easyui-dialog" title="扩展属性" style="width:180px;height:170px; text-align:center;" data-options="closed:true,modal:true">
		<div id="typeSelect" style="padding:15px 10px 15px 10px;"></div>
		<input type="hidden" id="kpiType" name="kpiType">
   	</div>
   	<!-- 公式配置 -->
   	<div id="f-dlg" class="easyui-dialog" title="公式配置" style="width:760px;height:450px;" data-options="closed:true,modal:true" buttons='#dlg-buttons1'>
		<table class ="pageTable">
			<colgroup>
			<col width="25%" />
			<col width="*" />
			</colgroup>
			<tr>
				<th>公式名称：</th>
				<td><input type="text" name="forName" id="forName"></td>
			</tr>
			<tr>
				<th>定义公式：</th>
				<td><textarea id="kpi_formula" name="kpi_formula"  onselect="setCaret(this);" onclick="setCaret(this);" onkeyup="setCaret(this);" onfocus="setCaret(this);" style="width:99%;height:60px;"></textarea></td>
			</tr>
			<tr>
				<th>运算符：</th>
				<td>
					 <input id="ysf0" class="numSmallBtn" type="button" size="5" value="+" onclick="javascript:doYsf('+');">
					 <input id="ysf1" class="numSmallBtn" type="button" size="5" value="-"  onclick="javascript:doYsf('-');">
					 <input id="ysf2" class="numSmallBtn"  type="button" size="5" value="*"  onclick="javascript:doYsf('*');">
					 <input id="ysf3" class="numSmallBtn"  type="button" size="5" value="/"  onclick="javascript:doYsf('/');">
					 <input id="ysf4" class="numSmallBtn"  type="button" size="5" value="("  onclick="javascript:doYsf('(');">
					 <input id="ysf5" class="numSmallBtn"  type="button" size="5" value=")"  onclick="javascript:doYsf(')');">
					 <input id="ysf6" class="numSmallBtn"  type="button" size="5" value="指标"  onclick="javascript:doYsf('<kpi>');">
					 <input id="ysf7" class="numSmallBtn"  type="button" size="5" value="清除"  onclick="javascript:doClare();">
				</td>
			</tr>
			<tr>
				<th>公式说明：</th>
				<td><textarea name="for_explain" id="for_explain" style="width:99%;height:60px;"></textarea></td>
			</tr>
			<tr>
				<th>表达式：</th>
				<td>
					<select id="kpi_bds" name="kpi_bds" multiple="multiple" style="width: 600px; height: 150px; margin-top: 10px; cursor: pointer; "  ondblclick="javascrtip:doBds(this);">
						<e:forEach items="${formulaObj.list}" var="formula">
			                 <option value ="${formula.FORMULA}">${formula.NAME}</option>	
			            </e:forEach>	
					</select>
				</td>
			</tr>
		</table>
		</div>
		<div id="dlg-buttons1"><a href="javascript:void(0)" class="easyui-linkbutton" onclick="formulaAgree()">确认</a></div>
		<!-- 保存时弹出的指标类型 -->
	    <div id="formulaType" class="easyui-dialog"  title="指标类型" style="width:400px;height:200px; text-align:center;" data-options="closed:true,modal:true" buttons="#dlg-buttons2">
	    	 <div id="acctType">
		   		 <e:forEach items="${formulaType.list}" var="fl">
	                <input type="checkbox" name="formKpiTypesa" value="${fl.ATTR_CODE }" >${fl.ATTR_NAME }
	             </e:forEach>
             </div>	
		</div>
		<div id="dlg-buttons2"><a href="javascript:void(0)" class="easyui-linkbutton"  onclick="formulasaved('0')">确认</a></div>
  </body>
</html>
