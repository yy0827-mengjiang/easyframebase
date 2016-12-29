<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4l var="StateList">
	SELECT '1' TYPE_CODE,'有效' TYPE_DESC  FROM DUAL UNION ALL SELECT '0' TYPE_CODE,'无效' TYPE_DESC  FROM DUAL
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
				//$("#procLogForm").attr('action','<e:url value="/pages/frame/portal/subsystem/SubsystemManager.jsp"/>');
			    //$("#procLogForm").attr('method','post');
			    //$("#procLogForm").submit();
				var params = {};
		    	params.subsystemId=$('#subsystemId').val();
		    	params.subsystemName=$('#subsystemName').val();
		    	params.state=$('#state').val();
				$('#userTable').datagrid('options').queryParams=params;
				$('#userTable').datagrid('reload');
			}
			function doDelete(subsystemId){
				$.messager.confirm('确认框', '是否确认删除子系统?', function(r){  
	                if (r){  
	                    $.post('<e:url value="/pages/frame/portal/subsystem/SubsystemAction.jsp?eaction=delete"/>', {subsystemId: subsystemId}, function(){
							$('#userTable').datagrid("load",$("#userTable").datagrid("options").queryParams);
						 });
	                }  
	            });  
			}
			function toEdit(subsystemId){
				window.location.href='<e:url value="/pages/frame/portal/subsystem/SubsystemEdit.jsp"/>?subsystemId='+subsystemId;
			}
			$(function(){
				$(window).resize(function(){
				 	$('#userTable').datagrid('resize');
				 });
			});
			function formatterCZ(value,rowData){
				var content ='<a href="javascript:void(0);" style="text-decoration: none;margin: 0 5px;" onclick="toEdit(\''+rowData.SUBSYSTEM_ID+'\')">编辑</a>'+
				             '<a href="javascript:void(0);" style="text-decoration: none;margin: 0 5px;" onclick="doDelete(\''+rowData.SUBSYSTEM_ID+'\')">删除</a>';
				return content;
			}
		</script>
	</head>
	<body>
	<div id="tbar">
		<h2>子系统管理</h2>
		<div class="search-area">
			<form id="procLogForm" name="procLogForm">
					子系统编码: <input type="text" name="subsystemId" id="subsystemId" style="width:120px"  value="${param.subsystemId}">
					子系统名称: <input type="text" name="subsystemName" id="subsystemName" style="width:120px"  value="${param.subsystemName}">
					状态:<e:select id="state" name="state" items="${StateList.list}" label="TYPE_DESC" value="TYPE_CODE" headLabel="全部" headValue=""  defaultValue="${param.state}"/>
					<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doSearch();">查询</a>
					<a class="easyui-linkbutton easyui-linkbutton-green" href='<e:url value="/pages/frame/portal/subsystem/SubsystemAdd.jsp"/>'>新增</a>
			</form>
		</div>
		</div>
		<c:datagrid url="/pages/frame/portal/subsystem/SubsystemAction.jsp?eaction=list" 
			id="userTable" pageSize="15" fit="true" download="true" nowrap="false" border="false" title="" style="width:auto;" toolbar="#tbar">
			<thead>
				<tr>
					<th field="SUBSYSTEM_ID" width="10%" align="center">
						子系统编码
					</th>
					<th field="SUBSYSTEM_NAME" width="10%" align="center">
						子系统名称
					</th>
					<!--<th field="SUBSYSTEM_IP" width="5%" align="center">
						子系统部署内网IP
					</th>
					<th field="SUBSYSTEM_IP2" width="5%" align="center">
						子系统部署外网IP
					</th>
					-->
					<th field="SUBSYSTEM_ADDRESS" width="25%" align="left">
						子系统内网访问地址
					</th>
					<th field="SUBSYSTEM_ADDRESS2" width="25%" align="left">
						子系统外网访问地址
					</th>
					<!--<th field="SIMULATION_ADDRESS" width="8%" align="left">
						模拟登录地址
					</th>
					-->
					<th field="STATE" width="10%" align="center">
						状态
					</th>
					<th field="ORD" width="10%" align="center">
						排序
					</th>
					<!--
					<th field="CONTACTS" width="5%" align="left">
						联系人
					</th>
					<th field="PHONE" width="5%" align="left">
						联系电话
					</th>
					<th field="E_MAIL" width="5%" align="left">
						电子邮箱
					</th>					
					<th field="REMARK" width="5%" align="left">
						备注
					</th>
					-->
					<th field="CZ" width="10%" formatter="formatterCZ" align="center">
						操作
					</th>
				</tr>
			</thead>
		</c:datagrid>
	</body>
</html>