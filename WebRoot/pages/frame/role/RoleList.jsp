<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<script type="text/javascript">
	
	//查询按钮
	function doQueryRole(){
		var params = {};
		params.role_code=$("#rl_role_code").val();
		params.role_name=$("#rl_role_name").val();
		//$('#roleTable').datagrid('options').queryParams=params;
		$('#roleTable').datagrid("load",params);
	}
	
</script>
<div id="rltbar">
	<div class="search-area">
		角色编码：<input type="text" id="rl_role_code" name="role_code" style="width:120px">
		角色名称：<input type="text" id="rl_role_name" name="role_name" style="width:120px">
		<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQueryRole()">查询</a>
		<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doSelectRole()">确认</a>
	</div>
</div>

<c:datagrid url="/pages/frame/role/RoleAction.jsp?eaction=ROLELIST&userId=${param.user_id}" id="roleTable" singleSelect="false" fit="true" border="false" toolbar="#rltbar">
	<thead>
		<tr>
			<th field="ck" checkbox="true"></th>
			<th field="ROLE_CODE" width="100">角色编码</th>
			<th field="ROLE_NAME" width="100">角色名称</th>
			<th field="MEMO" width="120">角色描述</th>
		</tr>                          
	</thead>                    
</c:datagrid>
