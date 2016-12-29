<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>数据库连接使用情况</title>
		<c:resources type="easyui"  style="${ThemeStyle }"/>
		<script type="text/javascript">
			$(function(){
				$(window).resize(function(){
				 	$('#loginLogListTable').treegrid('resize');
				});
			});
			function reflushDataGrid(){
				var params = {};
				params.program=$("#program").val();
				params.status=$("#status").val();
				//$('#loginLogListTable').datagrid('options').queryParams=params;
				$('#loginLogListTable').datagrid("load",params);
			}
		</script>
	</head>
	<body>
		<div id="tb">
			<h2>数据库连接使用情况</h2>
			<div class="search-area">
				<form id="loginLogForm" method="post" name="loginLogForm" action="">
				连接方式:<select id="program" name="program"><option value="">所有</option><option value="JDBC Thin Client">程序</option><option value="999">其他</option></select>
				状态:<select id="status" name="status"><option value="">所有</option><option value="INACTIVE">不活动</option><option value="ACTIVE">活跃的</option><option value="999">其他</option></select>
					<a href="javascript:void(0);" class="easyui-linkbutton" onclick="reflushDataGrid()">查询</a>
			</form>
			</div>
		</div>
		<c:datagrid url="pages/frame/dbmonitor/monitorAction.jsp" id="loginLogListTable" nowrap="false" border="false" pageSize="15" fit="true" download="" toolbar="#tb">
			<thead>
				<tr>
					<th field="USERNAME" width="60">DB用户</th>
					<th field="PROGRAM" width="100" align="center">连接方式</th>
					<th field="MODULE" width="100" align="center">软件名称</th>
					<th field="STATUS" width="80" align="center">连接状态</th>
					<th field="STATE" width="130">连接状态2</th>
					<th field="LOGON_TIME" width="120" align="center">连接建立时间</th>
					<th field="MACHINE" width="100" align="center">PC名</th>
					<th field="OSUSER" width="100" align="center">PC用户名</th>
					<th field="SERVICE_NAME" width="100" align="center">DB实例名称</th>
				</tr>
			</thead>
		</c:datagrid>
	</body>
</html>