<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>xbuilder指标使用情况</title>
		<c:resources type="easyui"  style="${ThemeStyle }"/>
		<script type="text/javascript">
			$(function(){
				$(window).resize(function(){
				 	$('#loginLogListTable').treegrid('resize');
				});
			});
			function reflushDataGrid(){
				var params = {};
				params.name=$("#name").val();
				$('#loginLogListTable').datagrid("load",params);
			}
		</script>
	</head>
	<body>
		<div id="tb">
			<h2>Xbuilder指标使用情况</h2>
			<div class="search-area">
				<form id="loginLogForm" method="post" name="loginLogForm" action="">
				报表名称：<input type="text" id="name" name="name">
					<a href="javascript:void(0);" class="easyui-linkbutton" onclick="reflushDataGrid()">查询</a>
			</form>
			</div>
		</div>
		<c:datagrid url="pages/xbuilder/meta/xmetaAction.jsp?eaction=LIST" id="loginLogListTable" nowrap="false" border="false" pageSize="15" fit="true" download="" toolbar="#tb">
			<thead>
				<tr>
					<th field="NAME" width="80">名称</th>
					<th field="URL" width="100" align="center">地址</th>
					<th field="REPORT_TYPE" width="80" align="center">数据源类型</th>
					<th field="REPORT_LTYPE" width="80" align="center">报表类型</th>
					<th field="SCREEN" width="80">屏幕宽</th>
					<th field="KPI_ID" width="120" align="center">指标编码</th>
					<th field="KPI_COLUMN" width="100" align="center">指标列</th>
					<th field="KPI_TYPE" width="80" align="center">指标类型</th>
					<th field="KPI_DESC" width="100" align="center">指标说明</th>
				</tr>
			</thead>
		</c:datagrid>
	</body>
</html>