<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4l var="classNum">
	select * from X_KPI_CODE_CLASS t where t.flag='1' order by t.ord
</e:q4l>
<e:q4o var="classCount">
	select count(1) c from X_KPI_CODE_CLASS t where t.flag='1' order by t.ord
</e:q4o>
<e:q4o var="kpi">
	SELECT T.ACCTTYPE,T.cube_code,T.KPI_TYPE,T.KPI_CATEGORY,T.KPI_CODE,T.KPI_CALIBER,T.KPI_EXPLAIN,T.KPI_USER,T.KPI_DEPT,T.EXPLAIN,T.KPI_NAME,T.KPI_VERSION FROM X_KPI_INFO_TMP T WHERE T.KPI_KEY='${id }'
</e:q4o>
<e:q4l var="formulaSub">
	select t1.attr_code from x_kpi_info_tmp t ,X_KPI_ATTR_RELATION t1 where t.kpi_code=t1.kpi_code and t.kpi_version = t1.kpi_version and t.kpi_key='${id }'
</e:q4l>
<e:q4l var="formulaObj">
	SELECT T.ID,T.NAME,T.FORMULA,T.FORMULA_EXPLAIN FROM X_KPI_FORMULA T
</e:q4l>
<e:q4o var="typeInfo">
	SELECT T.TYPE_CODE,T.TYPE_NAME,T.USED_TYPE,T.VIEW_RULE,T.EXT_VIEW,T.SERVER_VIEW FROM X_KPI_TYPE T WHERE T.TYPE_CODE ='${kpi_type}' AND T.TYPE_STATUS='1'
</e:q4o>
<e:q4l var="unit">select code,name from x_kpi_code where type='0' order by ord</e:q4l>
<e:q4l var="opter">select code,name from x_kpi_code where type='1' order by ord</e:q4l>
<e:q4l var="logical">select code,name from x_kpi_code where type='2' order by ord</e:q4l>

<e:q4l var="kpiType">select code,name from X_KPI_CODE_TYPE where type='1' order by ord</e:q4l>
<e:q4l var="serviceType">select code,name from X_KPI_CODE_TYPE where type='2' order by ord</e:q4l>
<e:q4l var="classification">select code,name from X_KPI_CODE_TYPE where type='3' order by ord</e:q4l>
<e:q4l var="cycle">select code,name from X_KPI_CODE_TYPE where type='4' and accountype='${kpi.ACCTTYPE }' order by ord</e:q4l>
<e:q4l var="reservedAttr">select code,name from X_KPI_CODE_TYPE where type='6' order by ord</e:q4l>
<!DOCTYPE>
<html>
  <head>
    
    <title>${kpi.KPI_NAME}</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<e:service/>
	<e:if condition="${lookUpFlag ne '1'}">
		<c:resources type="easyui,app"  style="${ThemeStyle }"/>
	</e:if>
	<e:style value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
	<e:style value="/resources/easyResources/component/easyui/icon.css" />
	<e:style value="/resources/themes/base/boncBase@links.css"/>
	<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
	<e:script value="/pages/kpi/formulaKpi/easyui-lang-zh_CN.js" />
	<e:if condition="${lookUpFlag ne '1'}">
		<e:script value="/pages/kpi/formulaKpi/formula.js"/>
	</e:if>
	<script type="text/javascript">
		var _accountType = '${kpi.ACCTTYPE}';
		var _type = '${kpi.KPI_TYPE}';
		var comCode = '${kpi.KPI_CODE }';
		var _logi='${e:java2json(logical.list)}';
		var oper = '${e:java2json(opter.list)}';
		var _selectOption = "";
		var lookUpFlag = '${lookUpFlag}';
		$(function(){
			$('#formulaBut').hide();
			$('#ysArea').hide();
			$("#showFormular").hide();
			var _viewRule = '${typeInfo.VIEW_RULE}';
			if(_viewRule != "") {
				var _rule = _viewRule.split(",");
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
				if(${serviceCode!=null&&serviceCode!=''}){
					for(var i=0;i<_data.length;i++){
			   			 $('#' +_data[i].CLASS_NAME+"1").val($(_serviceCode).attr(_data[i].CLASS_NAME));
			   			 $('#' +_data[i].CLASS_NAME).val($(_serviceCode).attr(_data[i].CLASS_NAME));
			   			 $('#' + _data[i].CLASS_NAME + 'Val').html($('#' + _data[i].CLASS_NAME+"1").find("option:selected").text() + " " +$(_serviceCode).attr(_data[i].CLASS_NAME));
					}
   		 		}else{
	   		 		 $('#' +_data[0].CLASS_NAME).val('${param.serverClass}');
		        	 for(var i=0;i<_data.length;i++){
		        		 $('#' + _data[i].CLASS_NAME).val($('#' + _data[i].CLASS_NAME+"1").find("option:selected").val());
		        		 $('#' + _data[i].CLASS_NAME + "Val").html($('#' + _data[i].CLASS_NAME+"1").find("option:selected").val());
		        	 }
   		 		}
			}
			//根据后台反回的字符串，回显公式
			strToformula('${formulaStr}','tid');
			//根据后台反回的字符串，回显约束条件
			strTocond('${condStr}','cond');
			//如果当前指标存在待审核，隐藏保存按钮
			//回显指标类型
			acctTypeAle1('${kpi.ACCTTYPE}','${e:java2json(formulaSub.list)}','view');
			$(".formulaTD").find("strong").each(function(index,item){
				$(item).html("");
			});
			$(".formulaTD").each(function(index,item){
				$(item).css({"border":"0"});
			});
			$(".formular_table").find("input").each(function(index,item){
				$(item).attr("disabled",true);
				$(item).css({"border":"0"});

			});
			$(".formular_table").find("input[type='checkbox']").each(function(index,item){
				$(item).css({"display":"none"});

			});
			$(".formular_table").find("select").each(function(index,item){
				$(item).attr("disabled",true);
				$(item).css({"border":"0","overflow":"hidden"});
				
			});
		}); 
		
		function addLogical(){
			var index = $(".condTab tr").length;
			var _select = opter(_logi);
			var _tr = '<tr><td name="nodeType" nodeId="0"><input type="checkbox" name="condCB" id="'+index+'"></td><td name="nodeId" nodeId="">逻辑符</td><td name="oper" nodeId="0">'+_select+'</td><td name="condval" nodeId=""></td></tr>';
			$('#cond').append(_tr);
			$("td>select").on("change",function(){
        		var _value = $(this).find("option:selected").val();
        		var _td = $(this).parents("td");
        		_td.attr("nodeId",_value);
        	});
		}
		function callback(msg,flag)   
		{   
			$.messager.alert('提示信息！', msg, 'info',function(){  
				if(flag!="1"){
					return false;
				}else{
					window.location.href='../../../pages/kpi/kpiManager/newKpiManager.jsp';
				}
			});
		}
		$(function(){
			  	 var browser_width = $(window).width(); 
				$('.tit_div1').css({'width':browser_width-20,'left':'10px' });
				$(window).resize(function() { 
						$('.tit_div1').css({'width':$(window).width()-20,'left':'10px' });
				}); 
		})
	</script>
  </head>
  
  <body>
  <input type="hidden" id="lookUpFlag" name="lookUpFlag" value="1"/>
  <div class="kpi_guide">
  	<div class="tit_div1">
		<h3>${kpi.KPI_NAME }</h3>
	</div>
	<div class="editBase_div1">
	<form id="formulaForm" enctype="multipart/form-data">
		<input type="hidden" name="isPublish" id="isPublish" value="true">
		<input type="hidden" name="operation" id="operation" value="update">
		<input type="hidden" name="baseType" id="baseType" value="3">
		<input type="hidden" name="parentId" id="parentId" value="${kpi.KPI_CATEGORY }">
		<input type="hidden" name="kpis" id="kpis">
		<input type="hidden" name="formulaStr" id="formulaStr">
		<input type="hidden" name="formula" id="formula">
		<input type="hidden" name="formulaKpi" id="formulaKpi">
		<input type="hidden" name="condStr" id="condStr">
		<input type="hidden" name="condJson" id="condJson">
		<input type="hidden" name="condPar" id="condPar">
		<input type="hidden" name="status" id="status">
		<input type="hidden" name="formKpi_type" id="formKpi_type" value="${param.type }">
		<input type="hidden" name="formKpiSub" id="formKpiSub">
		<input type="hidden" name="fkId" id="fkId" value="${id }">
		<div class="editBase_div_child1">
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
							<e:if condition="${null!=codeId}">
								<span class="kpiCodeCol" id="codeIdVal" height="30px">
									${codeId }
								</span>
							</e:if>
					</div>
				<table>
					<tr class="kpiTrBot" style="display: none;">
					<e:forEach items="${classNum.list }" var="class" indexName="index">
						<td  width="${100/classCount.C }%" >
						<select id="${class.CLASS_NAME }1"  codeStart="${index*2}" name="${class.CLASS_NAME }1" style="width: 100%; height:26px; display:none;" disabled="disabled">
							<e:q4l var="kpiType">select code,name from X_KPI_CODE_TYPE where type='${class.ID }'
								<e:if condition="${class.ID =='4' }">
							   		and accountype='${kpi.ACCTTYPE }'
							    </e:if>
							 order by ord</e:q4l>
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
		<dl>
			<dt>指标名称：</dt>
			<dd><span>${kpi.KPI_NAME }</span>
<!-- 			<input type="text" name="formula_name" id="formula_name" onblur="validName()" value="${kpi.KPI_NAME }" disabled="disabled"> -->
			</dd>
		</dl>
	   <dl class="ddLine">
			<dt>技术口径：</dt>
			<dd><span>${kpi.KPI_CALIBER }</span>
<!-- 			<textarea rows="3" cols="100" name="technical" id="technical" disabled="disabled">${kpi.KPI_CALIBER }</textarea> -->
			</dd>
		</dl>
		<dl class="ddLine">
			<dt>业务口径：</dt>
			<dd><span>${kpi.KPI_EXPLAIN }</span>
<!-- 			<textarea rows="3" cols="100" name="business" id="business" disabled="disabled">${kpi.KPI_EXPLAIN }</textarea> -->
			</dd>
		</dl>
	    <div class="kpiDivider"></div>
		<dl>
			<dt>指标版本：</dt>
			<dd>${kpi.KPI_VERSION }
<!-- 			<input type="text" name="formula_version" id="formula_version" readonly="readonly" value="${kpi.KPI_VERSION }" disabled="disabled"> -->
			</dd>
		</dl>
		<e:if condition="${typeInfo.EXT_VIEW=='1' }">
		<div class="kpiDivider"></div>
		<dl class="ddLine">
			<dt>扩展属性：</dt>
			<dd>
				<div id="acctType">
             	</div>
			</dd>
		</dl>
		</e:if>
		<dl>
			<dt>提出者：</dt>
			<dd><span>${kpi.KPI_USER }</span>
<!-- 				<input type="text" id="dim_author" name="dim_author" value="${kpi.KPI_USER }" disabled="disabled"> -->
			</dd>
		</dl>
		<dl>
			<dt>提出部门：</dt>
			<dd><span>${kpi.KPI_DEPT }</span>
<!-- 				<input type="text" id="dim_dept" name="dim_dept" value="${kpi.KPI_DEPT }" disabled="disabled"> -->
			</dd>
		</dl>
		<dl class="ddLine">
			<dt>需求来源：</dt>
			<dd><span>${kpi.EXPLAIN }</span><br/>
<!-- 				<textarea rows="3" cols="100" id="explain" name="explain" disabled="disabled">${kpi.EXPLAIN }</textarea><br> -->
				<e:if condition="${fileName != null && fileName !=''}"><a href="javascript:void(0)" onclick="downLoadFile('${fileName}','${filePath}','./')">${fileName}</a></e:if>
			</dd>
		</dl>
	</div>
  <div class="kpi_guide">
   	<div id="showFormular" style="display: none;">
  	<div class="tit_div">
		<h3>指标公式</h3>
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
	<!-- <div id="formulaBut" class="btn_div fn">
		<button type="button" name="setFormula" id="setFormula" onclick="addFormula()">使用公式</button>
		<button type="button" name="setFormula" id="setFormula" onclick="setFormula()">配置公式</button>
	</div> -->
	<div id="ysArea">
		<div class="tit_div">
			<h3>约束条件</h3>
		</div>
		<table class="condTab formular_table" cellpadding="0" cellspacing="1">
			<thead>
				<tr>
					<th width="5%">
<!-- 					<input type="checkbox" id="all" name="all" onclick="allCheck()"> -->
					</th>
					<th width="15%">名称/公式</th> 
					<th width="25%">连接符</th> 
					<th>条件值</th>
				</tr>
			</thead>
			<tbody id="cond">
			</tbody>
		</table>
		<!-- <div class="btn_div fn">
			<button type="button" name="addLogical" id="addLogical" onclick="addLogical()">添加逻辑符</button>
			<button type="button" name="delFormula" id="delFormula" onclick="delCond()">删除条件</button>
		</div> -->
	</div>
	<iframe name='hidden_frame' id="hidden_frame" style='display:none'></iframe>
	</form>
	</div>
	<div class="kpi_guide">
	<div class="tit_div">
		<h3>审核信息</h3>
	</div>
	<div class="editBase_div">
	<c:datagrid url="pages/kpi/kpifaile/kpiFaileAction.jsp?eaction=audit&kpi_key=${id }" id="audit" style="height:175px;">
		<thead>
    		<tr>
   				<th field="V11" width="10%">审核类型</th>
    			<th field="V13" width="10%">审核人</th>
    			<th field="V8" width="10%">审核时间</th>
    			<th field="V20" width="10%">审核结果</th>
    			<th field="V10" width="30%">审核意见</th>
   			</tr>
  			</thead>
	</c:datagrid>
	</div>
	</div>
	</div>
	</div>
  </body>
</html>
