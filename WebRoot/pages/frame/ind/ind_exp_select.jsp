<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<e:q4l var="ind_list">
	select id from E_IND_EXP_DETAILS where ind_id = '${param.ind_id}' order by UPDATE_TIME desc
</e:q4l>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<base href="<%=basePath%>">
		<title>指标解释查看</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<c:resources type="easyui,app"  style="${ThemeStyle }"/>
		<e:style value="/resources/themes/base/boncBase@links.css"/>
	<script>
		$(window).resize(function(){
		 	$('#uu').panel('resize');
		 });
		 
		function doBack(){
			var path = '<e:url value="/pages/frame/ind/ind_exp.jsp"/>';
			window.location.href = path;
		}
	</script>
</head>
<body>
	<div id="table_toobar" class="datagrid-toolbar">
		<h2>指标解释详情查看</h2>
		<div class="search-area">
			<a href="javascript:void(0);" class="easyui-linkbutton easyui-linkbutton-gray" onclick="doBack()">返回</a>
		</div>
	</div>
	<e:forEach items="${ind_list.list}" var="id">
		<e:q4o var="ind" sql="frame.ind.listind"/>
	<table width="100%" class="pageTable" toolbar="#table_toobar">
	<colgrounp>
	<col width="10%">
	<col width="*">
	</colgrounp>
		<tr>
			<th>指标编号</th>
			<td>${ind.IND_CODE}</td>
		</tr>
		<tr>
			<th>指标名称</th>
			<td>${ind.IND_NAME}</td>
		</tr>
		<tr>
			<th>指标类型</th>
			<td>${ind.ind_type_desc}</td>
		</tr>
		<tr>
			<th>业务解释</th>
			<td>${ind.BUS_EXP}</td>
		</tr>
		<tr>
			<th>技术解释</th>
			<td>${ind.SKILL_EXP}</td>
		</tr>
		<tr>
			<th>其他解释</th>
			<td>${ind.OTHER_EXP}</td>
		</tr>
		<tr>
			<th>局方提出部门</th>
			<td>${ind.depart_desc}</td>
		</tr>
		<tr>
			<th>厂家确认人</th>
			<td>${ind.FACTORY_CON}</td>
		</tr>
		<tr>
			<th>维护人</th>
			<td>${ind.MAINTE_MAN}</td>
		</tr>
		<tr>
			<th>创建人</th>
			<td>${ind.CREATE_MAN}</td>
		</tr>
		<tr>
			<th>创建时间</th>
			<td>${ind.CREATE_TIME}</td>
		</tr>
		<tr>
			<th>修改人</th>
			<td>${ind.UPDATE_MAN}</td>
		</tr>
		<tr>
			<th>更新时间</th>
			<td>${ind.UPDATE_TIME}</td>
		</tr>
		<tr>
			<th>排序</th>
			<td>${ind.ORD}</td>
		</tr>
	</table>
</e:forEach>
</body>
</html>