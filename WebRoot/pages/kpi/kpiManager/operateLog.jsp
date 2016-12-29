<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>操作日志查询</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<e:style value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
	<e:style value="/resources/easyResources/component/easyui/icon.css" />
	<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
	<e:script value="/pages/xbuilder/resources/scripts/base64.js"/>
	<script type="text/javascript"> 
	function query(){
		var params={};
		params.kpi_name=$('#kpi_name').val();
		params.cube_code = $("#cube_code").combobox("getValue");
		params.kpi_category = $("#kpi_category").combotree("getValue");
		params.log_action = $("#log_action").combobox("getValue");
		$('#logTable').datagrid('options').queryParams=params;
		$('#logTable').datagrid('reload');
	}
	function frhis(value,row,index) {
		return '<a id="kpi_status_1" href="javascript:void(0)" onclick="hisView(\''+ row.V9 +'\')">'+value+'</a>';
	}
	function hisView(kpi_code) {
        window.open('../version/kpi_version.jsp?kpi_code='+kpi_code,'历史版本', 'height=480, width=800, top=60, left=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');

	}
	function fView(value,row,index){
		return '<a href="javascript:void(0)" onclick="winView('+row.V10+')">'+value+'</a>';
	}		
	function winView(kpi_key){
		window.open('../../../formulaKpiLook.e?kpi_key='+kpi_key);
	}
	$(function(){
		$('#cube_code').combobox({
			editable : false,
//				width : 200,
			url : '<e:url value="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=queryCube"/>',
			valueField : 'CUBE_CODE',
			textField : 'CUBE_NAME',
			value :' ',
			onSelect : function(_value) {
//					$('#kpi_category').combotree({
//					    url: '<e:url value="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=queryCategory&cube_code="/>'+_value,
//					    required: true
//					});
				$('#kpi_category').combotree('reload');
			}
		});
		$('#kpi_category').combotree({
		    url: '<e:url value="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=queryCategory"/>',
		    required: true,
		    value:'0',
		    onBeforeExpand:function(node) {
		    	var _cube_code = $('#cube_code').combobox("getValue");
		    	if(_cube_code==null ||_cube_code==' '){
		    		return false;
		    	}
		    	$('#kpi_category').combotree("tree").tree("options").url = '<e:url value="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=queryCategory&cube_code="/>'+_cube_code+'&id='+node.id;
		    }
		});
		$('#log_action').combobox({
			editable : false,
//				width : 200,
			url : '<e:url value="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=queryFlag"/>',
			valueField : 'VALUE',
			textField : 'TEXT',
			value :' '
		});
	});
	</script>
  </head>
  
  <body>
  <div id="tb">
  		<h2>操作日志</h2>
  		<div class="search-area">
  			 数据魔方：<input id="cube_code">
  			 指标分类：<input id="kpi_category">
			 操作状态：<input id="log_action" name="log_action">&nbsp;&nbsp;
  			 指标名称： <input type="text" id="kpi_name"/>
  			<a class="easyui-linkbutton" onclick="query()">查询</a>
  		</div>
  	</div>
    <c:datagrid url="/pages/kpi/kpiManager/kpiManagerAction.jsp?action=log&kpi_key=${param.kpi_key}" id="logTable" singleSelect="true" nowrap="true" fit="true" toolbar="#tb"  pageSize="20">
    	<thead>
    		<tr>
	    		<th field="V0" width="80px" align="left" formatter="fView">指标名称</th>
    			<th field="V5" width="120px"align="left" formatter="fView">指标名称</th>
    			<th field="V2" width="60px" align="left" formatter="frhis">指标版本</th>
    			<th field="V3" width="50px" align="left">操作状态</th>
    			<th field="V6" width="50px" align="left">操作人</th>
    			<th field="V7" width="60px" align="left">操作日期</th>
    			<th field="V8" width="60px" align="left">操作ip</th>
    		</tr>
    	</thead>
    </c:datagrid>
    <div id="dlg" style="width:500px;height:300px;top:1px;"></div>
  </body>
</html>
