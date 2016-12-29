<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>账号信息管理</title>
<c:resources type="easyui,app" style="${ThemeStyle }"></c:resources>
<e:style value="/resources/themes/base/boncBase@links.css"/>
<e:style value="/resources/themes/blue/boncBlue.css"/>
<script type="text/javascript">
$(function(){
	
	$.extend($.fn.validatebox.defaults.rules, {
	     test: {
	         validator: function(value, param){
			 var spaceEmpty = $.trim(value);
			 return !param[0].test(spaceEmpty);
	         },
	     message: '角色编码只能由数字、字母和下划线组成（A-Za-z0-9_）。'
	     }
	 });
	//定义新增表单
	$('#addAccountForm').form({  
		url:appBase + "/pages/frame/portal/account/accountAction.jsp?eaction=INSERT",
	    onSubmit: function(){  
	        return $(this).form('validate');
	    },
	    success:function(data){  
	        var temp = $.trim(data);
			if(temp == "isHave"){
				$.messager.alert("信息","账户编码已经存在！","info");
			}else if(temp>0) {
				$.messager.alert("信息","增添成功！","info");
				$("#accountAddDialog").dialog("close");
				//window.location.href="<e:url value='/pages/frame/role/RoleManager.jsp'/>";
				$('#accountTable').datagrid("load",$("#accountTable").datagrid("options").queryParams);
			} else {
				alert("账户保存过程中出现错误，请联系管理员！");
			}
		}
	}); 
	//定义新增弹出框
	$("#accountAddDialog").dialog({
		width:400,
		height:280,
		modal:true,
		closed:true,
		top:160,
		buttons:[{
			text:'提交',
			handler:saveRole
		}]
	});
	
	 $('#updAccountForm').form({  
			url:appBase + "/pages/frame/portal/account/accountAction.jsp?eaction=UPDATE",
		    onSubmit: function(){
		        return $(this).form('validate');
		    },
		    success:function(data){  
		       var temp = $.trim(data);
		       if(temp == "isHave"){
					$.messager.alert("信息","账户编码已经存在！","info");
				}else if(temp>0) {
					$.messager.alert("信息","更新成功！","info");
					$("#accountUpdDialog").dialog("close");
					//window.location.href="<e:url value='/pages/frame/role/RoleManager.jsp'/>";
					$('#accountTable').datagrid("load",$("#accountTable").datagrid("options").queryParams);
				} else {
					alert("账户保存过程中出现错误，请联系管理员！");
				}
			}
		}); 
	//编辑弹出窗
		$("#accountUpdDialog").dialog({
			width:400,
			height:280,
			modal:true,
			closed:true,
			top:90,
			buttons:[{
				text:'提交',
				handler:saveUpdRole
			}]
		});
});
//新增角色提交按钮事件
function saveRole(){
	$("#addAccountForm").submit();
}
//
//编辑角色提交按钮事件
function saveUpdRole(){
	$("#updAccountForm").submit();
}
//
function addAccount(){
	setFormDataNull();
	$("#accountAddDialog").dialog("open");
}

//编辑角色按钮的响应事件
function updAccount(Id){
	var info = {};
	info.account_code=Id;
	info.eaction="ACCOUNTRELOAD";
	$("#accountUpdDialog").dialog("open");
	var postUrl=appBase + "/pages/frame/portal/account/accountAction.jsp";
	$.post(postUrl,info,function(data){
		if(data!=null){
			$("#updAccountForm").form("load",data[0]);
		}
	},"json");
}

//将form表单内容初始化
function setFormDataNull(){
	$("#account_code").val("");
	$("#account_name").val("");
	$("#account_desc").val("");
}
function delAccount(code){
	var info = {};
	info.eaction="DELETE";
	info.account_code = code;
	var postUrl=appBase + "/pages/frame/portal/account/accountAction.jsp";
	$.messager.confirm("删除信息提示","您确定要删除账户吗？",function(r){
		if(r){
			$.post(postUrl,info,function(data){
				var temp = $.trim(data);
				if(!isEmpty(temp)){
					$.messager.alert("信息","删除成功！","info");
					//window.location.href="<e:url value='/pages/frame/role/RoleManager.jsp'/>";
					$('#accountTable').datagrid("load",$("#accountTable").datagrid("options").queryParams);
				}else {
					$.messager.alert("信息","账户删除过程中出现错误，请联系管理员！","error");
				}
			});
		}
	});
}

//判断是否为空
function isEmpty(obj){
	if(obj==null || obj=='' ){
		return true;
	} else {
		var spaceEmpty = obj.replace(/\s/g,'');
		if(spaceEmpty == ''){
			return true;
		}
	}
	return false;
}

//添加用户
function addUser(Id){
	$("#accountCodeInput").val(Id);
	$("#addUserForm").attr("action",appBase + "/pages/frame/portal/account/accountAddUser.jsp");
	$("#addUserForm").submit();
}

//查询按钮
function doQuery(){
	$("#procLogForm").attr('action',appBase + '/pages/frame/portal/account/accountManager.jsp');
    $("#procLogForm").attr('method','post');
    $("#procLogForm").submit(); 
}

function formatterCZ(value,rowData){
	var res ='<a href="javascript:void(0);" class="easyui-linkbutton" onclick="updAccount(\''+rowData.ACCOUNT_CODE+'\')">编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;'+
		'<a href="javascript:void(0);" class="easyui-linkbutton" onclick="delAccount(\''+rowData.ACCOUNT_CODE+'\')">删除</a>&nbsp;&nbsp;&nbsp;&nbsp;'+
		'<a href="javascript:void(0);" class="easyui-linkbutton" onclick="addUser(\''+rowData.ACCOUNT_CODE+'\')">添加用户</a>';
	return res;
}
</script>
</head>
<body>
	<div id="tb" class="newSearchA">
		<h2>账户信息维护</h2>
		<div class="search-area">
			<form action="" method="post" id="procLogForm">
				账户编码： <input type="text" id="account_code_s" name="account_code_s"  value="${param.account_code_s}">
				账户名称： <input type="text" id="account_name_s" name="account_name_s"  value="${param.account_name_s}">
				<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQuery()">查询</a>
				<a href="javascript:void(0);" class="easyui-linkbutton easyui-linkbutton-green" onclick="addAccount()">新增</a>
			</form>
		</div>
	</div>
	<c:datagrid url="/pages/frame/portal/account/accountAction.jsp?eaction=LIST&accountCode=${param.account_code_s}&accountName=${param.account_name_s}" id="accountTable" singleSelect="true" 
			    nowrap="false" fit="true" style="width:auto;height:500px;" toolbar="#tb" pageSize="15">
	<thead>
		<tr>
			<th field="ACCOUNT_CODE" width="80" sortable="true" align="center">账号编码</th>
			<th field="ACCOUNT_NAME" width="80" sortable="true" align="center">账号名称</th>
			<th field="ACCOUNT_DESC" width="300" sortable="true" align="left">账号描述</th>
			<th field="CREATED_USER" width="80" sortable="true" align="center">创建人</th>
			<th field="CREATED_DATE" width="80" sortable="true" align="center" formatter="formatDAT_accountTable">创建时间</th>
			<th field="MODIFIED_USER" width="80" sortable="true" align="center">修改人</th>
			<th field="MODIFIED_DATE" width="80" sortable="true" align="center" formatter="formatDAT_accountTable">修改时间</th>
			<th field="cz" width="150" formatter="formatterCZ">操作</th>
		</tr>                          
	</thead>                    
</c:datagrid>
<div id="accountAddDialog" title="新增账户">
		<form action="" method="post" id="addAccountForm">
			<table class="windowsTable">
			<colgroup>
			<col width="24%"/>
			<col width="*"/>
			</colgroup>
				<tr>
					<th>账户编码：</th>
					<td>
						<input type="text" id="account_code" name="account_code" class="easyui-validatebox" required validType="test[/[^A-Za-z0-9_]/g]" style="width:260px;">
					</td>
				</tr>
				<tr>
					<th>账户名称：</th>
					<td >
						<input type="text" id="account_name" name="account_name"  class="easyui-validatebox" required style="width:260px;">
					</td>
				</tr>
				<tr>
					<th>账户描述：</th>
					<td>
						<textarea id="account_desc" name="account_desc" style="width:260px;height: 50px;"></textarea>
					</td>
				</tr>
			</table>
		</form>
	</div>
	
	<div id="accountUpdDialog" title="编辑账户">
		<form action="" method="post" id="updAccountForm">
			<table class="windowsTable">
			<colgroup>
			<col width="24%">
			<col width="*">
			</colgroup>
				<tr>
					<th>账户编码：</th>
					<td>
						<input type="hidden" id="account_code_old"  name="account_code_old">
						<input type="text" id="account_code_upd" name="account_code_upd" disabled="disabled" style="width:260px">
					</td>
				</tr>
				<tr>
					<th>账户名称：</th>
					<td >
						<input type="text" id="account_name_upd" name="account_name_upd"  class="easyui-validatebox" required style="width:260px">
					</td>
				</tr>
				<tr>
					<th>账户描述：</th>
					<td>
						<textarea id="account_desc_upd" name="account_desc_upd" style="width:270px; height:70px"></textarea>
					</td>
				</tr>
			</table>
		</form>
	</div>
<form style="display: inline;" method="post" action="" id="addUserForm">
	<input type="hidden" id="accountCodeInput" name="accountCodeInput">
</form>
</body>
</html>