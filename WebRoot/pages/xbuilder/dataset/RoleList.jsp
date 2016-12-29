<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<script type="text/javascript">
	
	//查询按钮
	function doQueryRole(){
		var params = {};
		params.role_code=$("#rl_role_code").val();
		params.role_name=$("#rl_role_name").val();
		$('#roleTableNoSel').datagrid('options').queryParams=params;
		$('#roleTableNoSel').datagrid('reload');
	}
	
</script>
<div id="rltbar">
	<div class="search-area">
	角色编码：<input type="text" id="rl_role_code" name="role_code" style="width:90px">
	角色名称：<input type="text" id="rl_role_name" name="role_name" style="width:120px">
	<a id="doQueryRolea" href="javascript:void(0);" onclick="doQueryRole()">查询</a>
	<a id="doSelectRolea" href="javascript:void(0);" onclick="doSelectRole()">确认</a>
	</div>
</div>

<c:datagrid url="/pages/xbuilder/dataset/RoleAction.jsp?eaction=XBROLELISTNO&db_name=${param.db_name}" id="roleTableNoSel" singleSelect="false"   fit="true" border="false" toolbar="#rltbar">
	<thead>
		<tr>
			<th field="ck" checkbox="true"></th>
			<th field="ROLE_CODE" width="100">角色编码</th>
			<th field="ROLE_NAME" width="100">角色名称</th>
			<th field="MEMO" width="120">角色描述</th>
		</tr>                          
	</thead>                    
</c:datagrid>