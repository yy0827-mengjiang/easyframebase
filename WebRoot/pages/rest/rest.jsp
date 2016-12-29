<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>test</title>
<c:resources type="easyui" style='b'/>
<e:style value="/resources/themes/base/boncBase@links.css"/>
<e:style value="/resources/themes/blue/boncBlue.css"/>
<script type="text/javascript">
</script>
</head>
<body>
<div id="tb"  class="newSearchA">
	<h2>Rest服务管理</h2>
	<div class="search-area">
	<form id="loginLogForm" method="post" name="loginLogForm" action="">
		接口名称：<input id="name" name="name" style="width:100px" type="text" value="${param.name}" class="easyui-validatebox" />
		接口URL：<input id="url" name="url" style="width:250px" type="text" value="${param.url}" class="easyui-validatebox" />
		请求方式：<input id="firstLevelMenu" name="firstLevelMenu" style="width:150px" class="easyui-combobox" data-options="valueField: 'CODE',textField: 'NAME',
				data: [{NAME : 'GET' , CODE : 'GET'},
					   {NAME : 'POST' , CODE : 'POST'},
					   {NAME : 'GET/POST' , CODE : 'GET/POST'}]" />
		<a href="javascript:void(0);" class="easyui-linkbutton" onclick="queryTable()">查询</a>
		<a href="javascript:void(0);" class="easyui-linkbutton  easyui-linkbutton-green" onclick="addNew()">新增</a>
	</form>
	</div>
</div>
<c:datagrid url="/pages/rest/restAction.jsp?eaction=rest" id="restTable" nowrap="false" fit="true" border="false" toolbar="#tb">
	<thead>
		<tr>
			<th field="NAME" width="200" align="center">接口名称</th>
			<th field="URL" width="500" align="center">请求地址</th>
			<th field="METHOD" width="150" align="center">请求方式</th>
			<th field="CREATE_USER" width="150" align="center">创建人</th>
			<th field="CREATE_TIME" width="150" align="center">创建时间</th>
			<th field="opt" width="150" align="center">操作</th>
		</tr>
	</thead>
</c:datagrid>
</body>
</html>