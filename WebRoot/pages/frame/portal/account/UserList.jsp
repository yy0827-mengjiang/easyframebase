<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<e:style value="/resources/themes/base/boncBase@links.css"/>
<e:style value="/resources/themes/blue/boncBlue.css"/>
<script type="text/javascript">
	
	//查询按钮
	function doQueryUser(){
		var params = {};
		params.loginid=$("#ul_loginid").val();
		params.username=$("#ul_username").val();
		//$('#userTable').datagrid('options').queryParams=params;
		$('#userTable').datagrid("load",params);
	}
	
</script>
<div class="userSearch">
	<div class="search-area">
		登录ID：<input type="text" id="ul_loginid" name="loginid" style="width: 100px;">
		用户名称：<input type="text" id="ul_username" name="username" style="width: 100px;">
		<a href="javascript:void(0);" class="easyui-linkbutton" id="doQueryLoad" onclick="doQueryUser()">查询</a>
		<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doSelectUser()" id="confirmLoad">确认</a>
	</div>
</div>
<c:datagrid url="/pages/frame/portal/account/accountAction.jsp?eaction=SHOWLIST&account_code=${param.account_code}" id="userTable" singleSelect="false" data-options="border:false" fit="true"  toolbar="#tbar" tools="#utools">
	<thead>
		<tr>
			<th field="ck" checkbox="true"></th>
			<th field="USER_ID" width="100">用户ID</th>
			<th field="LOGIN_ID" width="100">登录ID</th>
			<th field="USER_NAME" width="100">用户名称</th>
		</tr>                          
	</thead>                    
</c:datagrid>
