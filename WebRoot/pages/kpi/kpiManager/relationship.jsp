<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="kpiInfo">
	SELECT * FROM X_KPI_INFO T WHERE T.KPI_KEY = '${param.kpi_key }'
</e:q4o>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>血缘关系地图</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
 	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<c:resources type="easyui,app"  style="${ThemeStyle }"/>
	<e:style value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
	<e:style value="/resources/easyResources/component/easyui/icon.css" />
	<e:style value="/resources/themes/base/boncBase@links.css"/>
	<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
	<script type="text/javascript">
	$(function(){
// 		 $("#limited").load('../coverage/coverage.jsp?kpi_key=${param.kpi_key}&kpi_name=${param.kpi_name}',null,function() {
// 			  $.parser.parse($("#limited"));
// 		 });
		 $("#ship").load('sibship.jsp?kpi_key=${param.kpi_key}&kpi_name=${param.kpi_name}',null,function() {
			  $.parser.parse($("#ship"));
		  });
	});
//     window.open('sibship.jsp?kpi_key='+selected.id+"&kpi_name="+selected.text,'血缘关系', 'height=480, width=800, top=60, left=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');
	function oper(value,rowData){
		if(rowData.OPER == '1'){
			return '<a href="javascript:void(0)" onclick="update(\''+rowData.SYS_NAME+'\',\''+rowData.REPORT_NAME+'\',\''+rowData.USEAREA_ID+'\')">编辑</a>&nbsp;&nbsp;<a href="javascript:void(0)" onclick="del(\''+rowData.USEAREA_ID+'\')">删除</a>';
		}else{
			return '';
		}
	}
	</script>
  </head>
  <body>
  <table width="100%" cellpadding="0" cellspacing="0">
  <tr><td width="40%" valign="top">
	<div class="contents-head">
			<h2 style="display:block;">血缘关系</h2>
			<div class="search-area">
				报表名称：<input type="text" id="reportName">
	<!-- 			创建时间：<input type="text" id="start"> - <input type="text" id="end"> -->
					   <a href="javascript:void(0)" class="easyui-linkbutton" onclick="query()">查询</a>
					   <a href="javascript:void(0)" class="easyui-linkbutton" onclick="add()">新增</a>
			</div>
		</div>
		<c:datagrid
			url="/pages/kpi/coverage/coverageAction.jsp?eaction=querylist&code=${kpiInfo.KPI_CODE }&version=${kpiInfo.KPI_VERSION }"
			id="coverage" singleSelect="true" nowrap="true" fit="true" style="width:auto;height:350px;">
			<thead>
				<tr>
	<!-- 				<th field="SERVICE_KEY" width=15% " align="left">指标编码</th> -->
	<!-- 				<th field="KPI_NAME" width="18%" align="left">指标名称</th> -->
	<!-- 				<th field="KPI_VERSION" width="15%" align="left">指标版本</th> -->
					<th field="SYS_NAME" width="20%" align="left">系统名称</th>
					<th field="REPORT_NAME" width="15%" align="left">报表名称</th>
					<th field="CREATE_TIME" width="12%" align="left">创建时间</th>
					<th field="CREATE_USER" width="10%" align="left">创建人</th>
					<th field="OPER"  width="10%" align="left" formatter="oper">操作</th>
				</tr>
			</thead>
		</c:datagrid>
		</td><td>
		<div id="ship">
		</div></td></tr>
		</table>
  </body>
</html>
