<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<script type="text/javascript">
	
	//查询按钮
	function doQueryAccount(){
		var params = {};
		params.account_code_add=$("#account_code_add").val();
		params.account_name_add=$("#account_name_add").val();
		$('#accountTableNoSel').datagrid('options').queryParams=params;
		$('#accountTableNoSel').datagrid('reload');
	}
	
</script>
<div id="rltbar">
	<div class="search-area" style="padding-left:0;">
	账户编码：<input type="text" id="account_code_add" name="account_code_add" style="width:140px">
	账户名称：<input type="text" id="account_name_add" name="account_name_add" style="width:140px">
	<a id="doQueryAccounta" href="javascript:void(0);" onclick="doQueryAccount()">查询</a>
	<a id="doSelectAccounta" href="javascript:void(0);" onclick="doSelectAccount()">确认</a>
	</div>
</div>

<c:datagrid url="/pages/xbuilder/dataset/accountAction.jsp?eaction=accountListForChoice&db_id=${param.db_id}" id="accountTableNoSel" singleSelect="false" style="height:356px;" toolbar="#rltbar">
	<thead>
		<tr>
			<th field="ck" checkbox="true"></th>
			<th field="ACCOUNT_CODE" width="100">账户编码</th>
			<th field="ACCOUNT_NAME" width="100">账户名称</th>
			<th field="ACCOUNT_DESC" width="120">账户描述</th>
		</tr>                          
	</thead>                    
</c:datagrid>