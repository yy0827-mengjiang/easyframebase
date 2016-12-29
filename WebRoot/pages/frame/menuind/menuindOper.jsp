<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<e:q4o var="pageName">
	select t.resources_name from e_menu t where t.resources_id = #page_id#
</e:q4o>

<e:q4l var="ind_type">
	select IND_TYPE_CODE ind_code, IND_TYPE_DESC ind_desc from E_IND_TYPE
</e:q4l>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<base href="<%=basePath%>">
		<title>菜单对指标操作</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<c:resources type="easyui"  style="${ThemeStyle }"/>
		<e:style value="/resources/themes/base/boncBase@links.css"/>
	<script>
		$(window).resize(function(){
		 	$('#oper').datagrid('resize');
		 });
		 
		function doQuery(){
			var params = {};
			params.ind_name=$("#ind_name").val();
			params.ind_type_code=$("#ind_type_code").val();
			//$('#oper').datagrid('options').queryParams=params;
			$('#oper').datagrid("load",params);
		}
		
		function doAdd(page_id){
			var page_id = '${param.page_id}';
			var path = '<e:url value="/pages/frame/menuind/indOperation.jsp"/>';
			window.location.href = path+"?page_id="+page_id;
		}
		
		function doDelete(){
			var ids = [];
			var rows = $('#oper').datagrid('getSelections');
			if(rows.length<1){
				$.messager.alert("指标","请选择您要删除的指标!","info");
				return;
			}
			for(var i=0;i<rows.length;i++){
				ids.push(rows[i].IND_ID);
			}
			var info = {};
			info.ids = $.toJSON(ids);
			info.page_id = '${param.page_id}';
			$.messager.confirm('指标删除', '您确认删除页面指标的关联关系吗?', function(r){
			if (r){
					var postUrl="<e:url value='/pages/frame/menuind/menuindAction.jsp'/>?eaction=MENUDELETE";
					$.post(postUrl,info,function(data){
							if(data>0){
									$.messager.alert("指标","指标删除成功！","info");
									var page_id = '${param.page_id}';
									var path = '<e:url value="/pages/frame/menuind/menuindOper.jsp"/>';
									window.location.href = path+"?page_id="+page_id;
								} else {
									$.messager.alert("指标","指标删除过程中出现错误，请联系管理员！","error");
							}
					});	
				}
			});
		}
		
		function doBack(){
			var path = '<e:url value="/pages/frame/menuind/menuindManager.jsp"/>';
			window.location.href = path;
		}
	</script>
</head>
<body>
<form id="menu" name="menu" action="">
	<div id="table_toobar">
		<h2>页面名称：${pageName.resources_name}</h2>
		<div class="search-area">
				指标名称：<input type="text" name="ind_name" id="ind_name">
				指标类型：<e:select id="ind_type_code" name="ind_type_code" items="${ind_type.list}" label="ind_desc" value="ind_code" headLabel="全部" headValue="" defaultValue="${param.ind_type_code}"/>
				<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQuery()">查询</a>
				<a href="javascript:void(0)" class="easyui-linkbutton easyui-linkbutton-green" onclick="doAdd(${param.page_id});">增加</a>
				<a href="javascript:void(0)" class="easyui-linkbutton easyui-linkbutton-red" onclick="doDelete();">删除</a>
				<a href="javascript:void(0)" class="easyui-linkbutton easyui-linkbutton-gray" onclick="doBack();">返回</a>
		</div>
	</div>
</form>
	<c:datagrid id="oper" fit="true" border="false"
			url="/pages/frame/menuind/menuindAction.jsp?eaction=MENUINDSELECT&page_id=${param.page_id}"
			fitColumns="false" download="true" toolbar="#table_toobar" singleSelect="false" nowrap="false" >
			<thead frozen="true">
				<tr>
					<th field="ck" checkbox="true"></th>
					<th field="IND_CODE" width="15%" align="center">指标编号</th>
					<th field="IND_NAME" width="15%" align="center">指标名称</th>
				</tr>
			</thead>
			<thead>
				<tr>
					<th field="IND_TYPE_DESC" width="10%" align="center">指标类型</th>
					<th field="BUS_EXP" width="20%" align="left">业务解释</th>
					<th field="SKILL_EXP" width="20%" align="left">技术解释</th>
					<th field="OTHER_EXP" width="20%" align="left">其他解释</th>
				</tr>
			</thead>
		</c:datagrid>
</body>
</html>