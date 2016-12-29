<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="account">
	select ACCOUNT_NAME from OCT_ACCOUNT where ACCOUNT_CODE=#accountCodeInput#
</e:q4o>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<c:resources type="easyui,app" style="${ThemeStyle }"></c:resources>
<script type="text/javascript">
	$(window).resize(function(){
		 	$('#addUser').treegrid('resize');
	});
	$(function(){
		$("#userWinDialog").dialog({
			width:600,
			height:450,
			modal:true,
			closed:true,
			top:8
		});
	});
	function addUser(){
		//$("#userWin").window({title: '&nbsp;添加用户',height: 420,iconCls:'icon-add',top:10});
		//$("#userWin").window('open');
		$("#userWinDialog").dialog('open');
		$('#userWinLoad').load('<e:url value="/pages/frame/portal/account/UserList.jsp"/>',{width:500,height:380,account_code:'${param.accountCodeInput}'},function (data){
			                                 
			$("#confirmLoad").linkbutton();
			$("#doQueryLoad").linkbutton();
		});
	}
	function delUser(Id){
		var info={};
		info.userId=Id;
		info.account_code="${param.accountCodeInput}";
		info.eaction="DELUSER";
		var postUrl = "<e:url value='/pages/frame/portal/account/accountAction.jsp'/>";
		$.post(postUrl,info,function(data){
			if(data>0){
				$("#addUserTreeDialog").dialog('close');
				//$.messager.alert("提示信息","删除用户成功","info");
				$("#addUser").datagrid("load",$("#addUser").datagrid("options").queryParams);
			}else{
				$.messager.alert("提示信息","删除用户失败,请稍候联系管理员！","error");
			}
		});
	}
	
	
	function doSelectUser(){
		var rows = $('#userTable').datagrid('getSelections');
		if(rows.length>0){
			//var list = [];
			var ids = '';
			$(rows).each(function(){
				ids = ids + this.USER_ID + ',';
				//list.push(this.USER_ID);
			});
			if(ids.length>0){
				ids = ids.substr(0, ids.length-1);
			}
			var postUrl = '<e:url value="/pages/frame/portal/account/accountAction.jsp"/>';
			var info = {};
			info.userIds = ids;
			info.account_code = '${param.accountCodeInput}';
			info.eaction = "ADDUSER";
			//$.post('<e:url value="/pages/frame/portal/account/accountAction.jsp?eaction=ADDUSER"/>', {account_code:"${param.accountCodeInput}",userIds:$.toJSON(list)}, function(data){
			$.post(postUrl, info, function(data){
				$('#userWinDialog').dialog('close'); 
				$('#addUser').datagrid("load",$("#addUser").datagrid("options").queryParams); 
				$.messager.alert('消息','添加用户成功','info'); 
			});
		}
	}
	function doQuery(){
		var params = {};
		params.userId=$("#userId").val();
		params.userName=$("#userName").val();
		//$('#addUser').datagrid('options').queryParams=params;
		$('#addUser').datagrid("load",params);
	}
	function goBack(){
		window.location.href="<e:url value='/pages/frame/portal/account/accountManager.jsp'/>";
	}
	function formatterRU(value,rowData){
		return '<a href="javascript:void(0);" style="text-decoration: none;" onclick="delUser(\''+rowData.USER_ID+'\')">删除</a>';
	}
</script>
</head>
<body>
	<div id="gridTools" class="datagrid-toolbar">
		<h2>添加用户 > 当前账户：${account.ACCOUNT_NAME}</h2>
		<div class="search-area">
			登录ID:&nbsp;<input name="userId" id="userId" type="text">
			用户名:&nbsp;<input name="userName" id="userName" type="text">
			<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQuery()">查询</a>
			<a href="javascript:void(0);" class="easyui-linkbutton  easyui-linkbutton-green" onclick="addUser()">新增</a>
			<a href="javascript:void(0);" class="easyui-linkbutton easyui-linkbutton-gray" onclick="goBack()">返回</a>
		</div>
	</div>
	<c:datagrid url="/pages/frame/portal/account/accountAction.jsp?eaction=AccUser&account_code=${param.accountCodeInput}" id="addUser" singleSelect="true" nowrap="true" fit="true" border="false" toolbar="#gridTools" pageSize="15">
		<thead>
			<tr>
		           <th data-options="field:'USER_ID',width:200,sortable:true" align="center">用户ID</th>
		           <th data-options="field:'LOGIN_ID',width:200,sortable:true" align="center">登录ID</th>
		           <th data-options="field:'USER_NAME',width:200,sortable:true" align="center">用户姓名</th>
		           <th data-options="field:'cz',width:200,sortable:true,formatter:formatterRU" align="center">操作</th>
			</tr>                          
		</thead>                    
	</c:datagrid>
	<div id="userWinDialog" title="新增用户" iconCls='icon-add'>
		<div id="userWinLoad" style="height:100%;"></div>
	</div>
</body>
</html>