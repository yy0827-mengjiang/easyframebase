<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4l var="SexList">
	SELECT '1' TYPE_CODE,'男' TYPE_DESC  FROM DUAL UNION ALL SELECT '0' TYPE_CODE,'女' TYPE_DESC  FROM DUAL
</e:q4l>
<e:q4l var="AdminTypeList">
	SELECT '1' TYPE_CODE,'是' TYPE_DESC  FROM DUAL UNION ALL SELECT '0' TYPE_CODE,'否' TYPE_DESC  FROM DUAL
</e:q4l>
<e:q4l var="StateList">
	SELECT '1' TYPE_CODE,'启用' TYPE_DESC  FROM DUAL UNION ALL SELECT '0' TYPE_CODE,'停用' TYPE_DESC  FROM DUAL
</e:q4l>
<e:q4l var="areaNoList">
   <e:if condition="${sessionScope.UserInfo.AREA_CONTROL_FRAME!=null&&sessionScope.UserInfo.AREA_CONTROL_FRAME!=''&&sessionScope.UserInfo.AREA_CONTROL_FRAME!='-1'}" var="isArea">
		select area_no,area_desc,ord from cmcode_area where area_no='${sessionScope.UserInfo.AREA_CONTROL_FRAME}'
	</e:if>
	<e:else condition="isArea">
 	  select '-1' area_no,'全省' area_desc, '0' ord from dual
        union all
      select area_no,area_desc,ord from cmcode_area
      </e:else>
</e:q4l>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>index.jsp</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<c:resources type="easyui"  style="${ThemeStyle }"/>
		<e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/resources/themes/blue/boncBlue.css"/>
		<style type="text/css">
			.panel-tool{
				top:1%;
				height: auto;
			}
			.datagrid .panel-tool A{
				width:auto;
				height: auto;
			}
		</style>
		<script type="text/javascript">
			function doSearch(){
				$("#procLogForm").attr('action','<e:url value="/pages/frame/portal/user/UserManager.jsp"/>');
			    $("#procLogForm").attr('method','post');
			    $("#procLogForm").submit();
			}
			function doDelete(user_id){
				$.messager.confirm('确认框', '是否确认删除此用户及与其相关联的日志，角色等关系?', function(r){  
	                if (r){  
	                    $.post('<e:url value="/pages/frame/portal/user/UserAction.jsp?eaction=delete"/>', {user_id: user_id}, function(){
							$('#userTable').datagrid("load",$("#userTable").datagrid("options").queryParams);
						 });
	                }  
	            });  
			}
			function toEdit(user_id){
				window.location.href='<e:url value="/pages/frame/portal/user/UserEdit.jsp"/>?user_id='+user_id;
			}
			function toAuthor(user_id){
				window.location.href='<e:url value="/pages/frame/portal/user/UserAuthorize.jsp"/>?userIdInput='+user_id;
			}
			function toUserRoles(user_id){
				//window.location.href='<e:url value="/pages/frame/portal/user/UserRoles.jsp"/>?user_id='+user_id;
				window.location.href='<e:url value="/pages/frame/portal/user/UserRolesTree.jsp"/>?user_id='+user_id;
			}
			$(function(){
				$(window).resize(function(){
				 	$('#userTable').datagrid('resize');
				 });
			});
			function formatterCZ(value,rowData){
				var content ='<a href="javascript:void(0);" style="text-decoration: none;margin: 0 5px;" onclick="toEdit(\''+rowData.USER_ID+'\')">编辑</a>'+
				             '<a href="javascript:void(0);" style="text-decoration: none;margin: 0 5px;" onclick="doDelete(\''+rowData.USER_ID+'\')">删除</a>';
				    content +='<a href="javascript:void(0);" style="text-decoration: none;margin: 0 5px;" onclick="toAuthor(\''+rowData.USER_ID+'\')">授权</a>';
				    content +='<a href="javascript:void(0);" style="text-decoration: none;margin: 0 5px;" onclick="toUserRoles(\''+rowData.USER_ID+'\')">角色</a>';
				return content;
				
			}
		</script>
		
	</head>
	<body>
	<div id="tbar" class="newSearchA">
			<h2>用户管理</h2>
			<div class="search-area">
				<form id="procLogForm" name="procLogForm">
				用户登录号：<input type="text" name="loginid" id="loginid" style="width:100px"  value="${param.loginid}" />
				用户姓名：<input type="text" name="username" id="username" style="width:100px"  value="${param.username}" />
				<%-- &nbsp;地市:<e:select id="area_no" name="area_no" style="min-width:100px" items="${areaNoList.list}" label="area_desc" value="area_no" headLabel="全部" headValue="" defaultValue="${param.area_no }"/> --%>
				性别：<e:select id="user_sex" name="user_sex" items="${SexList.list}" style="min-width:60px" label="TYPE_DESC" value="TYPE_CODE" headLabel="全部" headValue=""  defaultValue="${param.user_sex}"/>
				<!-- 如果用户是管理员，才可见，否则 不能更改该属性 -->
				管理员：<e:select id="user_admin" style="min-width:60px" name="user_admin" items="${AdminTypeList.list}" label="TYPE_DESC" value="TYPE_CODE" headLabel="全部" headValue=""  defaultValue="${param.user_admin}"/>
				用户状态：<e:select id="user_state" style="min-width:60px" name="user_state" items="${StateList.list}" label="TYPE_DESC" value="TYPE_CODE" headLabel="全部" headValue=""  defaultValue="${param.user_state}"/>
				<a class="easyui-linkbutton" href="javascript:void(0);" onclick="doSearch();">查询</a>
				<a class="easyui-linkbutton easyui-linkbutton-green" href='<e:url value="/pages/frame/portal/user/UserAdd.jsp"/>'>新增</a>
				</form>
			</div>
		</div>
		
		<c:datagrid url="/pages/frame/portal/user/UserAction.jsp?eaction=list&loginid=${param.loginid}&area_no=${param.area_no }&username=${param.username}&user_sex=${param.user_sex}&user_admin=${param.user_admin}&user_state=${param.user_state}" id="userTable" pageSize="15" fit="true"
					 nowrap="false" border="false" style="width:auto;" toolbar="#tbar">
			<thead>
				<tr>
					<th field="LOGIN_ID" width="110" align="center">
						登录id
					</th>
					<th field="USER_NAME" width="100" align="center">
						用户姓名
					</th>
					<e:description>
						<th field="AREA_DESC" width="50" align="center">
							地市
						</th>
					</e:description>
					<th field="ADMIN" width="75" align="center">
						管理员
					</th>
					<th field="SEX" width="60" align="center">
						性别
					</th>
					<th field="EMAIL" width="100" align="left">
						邮箱地址
					</th>
					<th field="MOBILE" width="140" align="center">
						移动电话
					</th>
					<th field="TELEPHONE" width="100" align="center">
						固定电话
					</th>
					<th field="STATE" width="60" align="center">
						状态
					</th>
					<th field="MEMO" width="100" align="center">
						备注信息
					</th>
					<th field="REG_DATE" width="100" align="center">
						注册时间
					</th>
					<th field="UPDATE_DATE" width="100" align="center">
						更新时间
					</th>
					<th field="REG_USER" width="90" align="center">
						注册人
					</th>
					<th field="UPDATE_USER" width="90" align="center">
						更新人
					</th>
					<th field="CZ" width="320" formatter="formatterCZ" align="center">
						操作
					</th>
				</tr>
			</thead>
		</c:datagrid>
	</body>
</html>