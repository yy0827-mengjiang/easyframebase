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
		<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
		<c:resources type="easyui,highchart,app" style="${ThemeStyle }"/>
	<script>
		$(window).resize(function(){
		 	$('#tt').datagrid('resize');
		 });
		 
		function doQuery(){
			var params = {};
			params.ind_name=$("#ind_name").val();
			params.ind_type_code=$("#ind_type_code").val();
			//$('#tt').datagrid('options').queryParams=params;
			$('#tt').datagrid("load",params);
		}
		
		function doAdd(){
			var ids = [];
			var rows = $('#tt').datagrid('getSelections');
			if(rows.length<1){
				$.messager.alert("指标","请选择您要添加的指标!","info");
				return;
			}
			for(var i=0;i<rows.length;i++){
				ids.push(rows[i].IND_ID);
			}
			var info = {};
			info.ids = $.toJSON(ids);
			info.page_id = '${param.page_id}';
			$.messager.confirm('指标添加', '您确定要添加所选指标吗?', function(r){
			if (r){
					var postUrl="<e:url value='/pages/frame/menuind/menuindAction.jsp'/>?eaction=INSERT";
					$.post(postUrl,info,function(data){
							if(data>0){
									$.messager.alert("指标","指标添加成功!","info");
									var page_id = '${param.page_id}';
									var path = '<e:url value="/pages/frame/menuind/menuindOper.jsp"/>';
									window.location.href = path+"?page_id="+page_id;
								} else {
									$.messager.alert("指标","指标添加过程中出现错误，请联系管理员！","error");
							}
					});	
				}
			});
		}
			
		function doBack(){
			var page_id = '${param.page_id}';
			var path = '<e:url value="/pages/frame/menuind/menuindOper.jsp"/>';
			window.location.href = path+"?page_id="+page_id;
		}
	</script>
</head>
<body>
<form id="indoperation" name="indoperation" action="">
	<div id="table_toobar">
		<h2>页面名称：${pageName.resources_name}</h2>
		<div class="search-area">
			指标名称：<input type="text" name="ind_name" id="ind_name">
			指标类型：<e:select id="ind_type_code" name="ind_type_code" items="${ind_type.list}" label="ind_desc" value="ind_code" headLabel="全部" headValue="" defaultValue="${param.ind_type_code}"/>&nbsp;&nbsp;
			<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQuery()">查询</a>
			<input type="hidden" id="page_id" name="page_id" value="${param._id}"/>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doBack();">返回编辑</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doAdd();">增加指标</a>
		</div>
	</div>
</form>
	<c:datagrid id="tt" url="/pages/frame/menuind/menuindAction.jsp?eaction=INDSELECT&page_id=${param.page_id}"
			fitColumns="false" download="true" toolbar="#table_toobar" singleSelect="false" nowrap="false" fit="true" border="false">
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