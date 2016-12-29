<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<e:q4l var="ind_type">
	select IND_TYPE_CODE ind_code, IND_TYPE_DESC ind_desc from E_IND_TYPE
</e:q4l>
<e:q4o var="indInfo" sql="frame.ind.indInfo"/>



<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<base href="<%=basePath%>">
		<title>修改指标</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<c:resources type="easyui,app"  style="${ThemeStyle }"/>
		<e:style value="/resources/themes/base/boncBase@links.css"/>
		<script>
		$(function(){
		$("#ord").numberspinner('setValue', '${indInfo.ORD}');
			$.extend($.fn.validatebox.defaults.rules, {
			     ind_name: {
			         validator: function(value, param){
					 var spaceEmpty = $.trim(value);
					 if(spaceEmpty=='' || spaceEmpty==null){
					 	return false;
					 }
					 return true;
			         },
			     message: '{0}'
			     }
			 });
			  $("#depTreeDialog").dialog({
			 	width:200,
				height:400,
				modal:true,
				closed:true,
				top:100
			 });
		}); 
		
		function getInfo(){
			var info = {};
			info.id = '${indInfo.ID}';
			info.ind_id = '${indInfo.IND_ID}';
			info.ind_code = $("#ind_code").val();
			info.ind_name = $("#ind_name").val();
			info.ind_type_code = $("#ind_type_code").val();
			info.bus_exp = $("#bus_exp").val();
			info.skill_exp = $("#skill_exp").val();
			info.other_exp = $("#other_exp").val();
			info.department_code = $("#department_code").val();
			info.factory_con = $("#factory_con").val();
			info.mainte_man = $("#mainte_man").val();
			info.ord = $("#ord").val();
			info.create_man = '${sessionScope.UserInfo.USER_ID}';
			info.update_man = '${sessionScope.UserInfo.USER_ID}';
			return info;
		}
		
		function doQuery(){
			var info = getInfo();
			if(!$("#form2").form('validate')){
				return;
			}
			var postUrl="<e:url value='/pages/frame/ind/ind_expAction.jsp'/>?eaction=UPDATE";
			$.post(postUrl,info,function(data){
				var temp = $.trim(data);
				if(temp == "BEINGIND"){
					$.messager.alert("指标","该指标已经存在！","info");
				}else if(temp>0) {
					$.messager.alert("指标","指标修改成功！","info");
					window.location.href="<e:url value='/pages/frame/ind/ind_exp.jsp'/>";
				} else {
					$.messager.alert("指标","指标修改过程中出现错误，请联系管理员！","info");
				}
			});
		}
		
		function doPublish(){
			var info = getInfo();
			if(!$("#form2").form('validate')){
				return;
			}
			var postUrl="<e:url value='/pages/frame/ind/ind_expAction.jsp'/>?eaction=PUBLISH";
			$.post(postUrl,info,function(data){
				var temp = $.trim(data);
				if(temp == "BEINGIND"){
					$.messager.alert("指标","该指标已经存在！","info");
				}else if(temp>0) {
					$.messager.alert("指标","指标发布成功！","info");
					window.location.href="<e:url value='/pages/frame/ind/ind_exp.jsp'/>";
				} else {
					$.messager.alert("指标","指标发布过程中出现错误，请联系管理员！","info");
				}
			});
		}
		
		function doBack(){
			var path = '<e:url value="/pages/frame/ind/ind_exp.jsp"/>';
			window.location.href = path;
		}
		function getDepName(){
			 $("#depTreeDialog").dialog('open');
		}
		function slectDep(node){
			$("#department_code").val(node.id);
			$("#department_desc").val(node.text);
			$("#depTreeDialog").dialog('close');
		}
	</script>
</head>
<body style="overflow-x:hidden;">
<form id="form2" name="form2" action="">
	<div class="contents-head">
		<h2>修改指标</h2>
		<div class="search-area">
			<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQuery()">修改</a>
			<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doPublish()">发布</a>
			<a href="javascript:void(0);" class="easyui-linkbutton easyui-linkbutton-gray" onclick="doBack()">返回</a>
		</div>
	</div>
	<table class="pageTable">
	<colgrounp>
	<col width="10%">
	<col width="20%">
	<col width="10%">
	<col width="20%">
	<col width="10%">
	<col width="*">
	</colgrounp>
		<tr>
			<th>指标编号<font color="red">*</font></th>
			<td><input type="text" name="ind_code" id="ind_code" class="easyui-validatebox" value="${indInfo.IND_CODE}" required validType="ind_code['该输入项不能为空格!']"></td>
			<th>指标名称<font color="red">*</font></th>
			<td><input type="text" name="ind_name" id="ind_name" class="easyui-validatebox" value="${indInfo.IND_NAME}" required validType="ind_name['该输入项不能为空格!']"></td>
			<th>指标类型</th>
			<td><e:select id="ind_type_code" name="ind_type_code" items="${ind_type.list}" label="ind_desc" value="ind_code" defaultValue="${indInfo.ind_type_code}"/></td>
		</tr>
		<tr>
			<th>业务解释</th>
			<td colspan="5"><textarea id="bus_exp" name="bus_exp" style="height: 50px; width:100%;">${indInfo.BUS_EXP}</textarea></td>
		</tr>
		<tr>
			<th>技术解释</th>
			<td colspan="5"><textarea id="skill_exp" name="skill_exp" style="height: 50px; width:100%;">${indInfo.SKILL_EXP}</textarea></td>
		</tr>
		<tr>
			<th>其他解释</th>
			<td colspan="5"><textarea id="other_exp" name="other_exp" style="height: 50px; width:100%;">${indInfo.OTHER_EXP}</textarea></td>
		</tr>
		<tr>
			<th>局方提出部门<font color="red">*</font></th>
			<td>
			<input type="hidden" name="department_code" id="department_code" value="${indInfo.DEPARTMENT_CODE}">
			<input type="text" readonly="readonly" name="department_desc" id="department_desc" value="${indInfo.depart_desc}" onclick="getDepName()"></td>
			<th>厂家确认人<font color="red">*</font></th>
			<td><input type="text" name="factory_con" id="factory_con" required class="easyui-validatebox" value="${indInfo.FACTORY_CON}"></td>
			<th>维护人<font color="red">*</font></th>
			<td><input type="text" name="mainte_man" id="mainte_man" required class="easyui-validatebox" value="${indInfo.MAINTE_MAN}"></td>
		</tr>
		<tr>
			<th>创建人<font color="red">*</font></th>
			<td><input type="text" name="create_man" id="create_man" disabled value="${indInfo.CREATE_MAN}"></td>
			<th>创建时间<font color="red">*</font></th>
			<td><input type="text" name="create_time" id="create_time" disabled  value="${indInfo.CREATE_TIME}"></td>
			<th>修改人<font color="red">*</font></th>
			<td ><input type="text" name="update_man" id="update_man" disabled value="${indInfo.UPDATE_MAN}"></td>
		</tr>
		<tr>
			<th>修改时间<font color="red">*</font></th>
			<td><input type="text" name="update_time" id="update_time" disabled  value="${indInfo.UPDATE_TIME}"></td>
			<th>排序</th>
			<td colspan="3"><input id="ord" name="ord" class="easyui-numberspinner" min="0" value="0" required="true" style="width: 142px;"></input></td>
		</tr>
	</table>
</form>
<div id="depTreeDialog" title="局方部门">
	<a:tree id="depTree" url="pages/frame/ind/ind_expAction.jsp?eaction=DEPTREE" onSelect="slectDep"/>
</div>
</body>
</html>