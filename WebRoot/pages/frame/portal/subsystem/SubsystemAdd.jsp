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
		<e:style value="/resources/themes/base/boncBase@links.css"/>
		<script type="text/javascript">
			$(function(){		
				$('#ord').numberbox();
			});
			function doAdd(){
				if($('#userForm').form('validate')){
					 var queryParam = $('#userForm').serialize();
					$.post('<e:url value="/pages/frame/portal/subsystem/SubsystemAction.jsp?eaction=add"/>', queryParam, function(data){
						if($.trim(data)=='HAVINGLOGINID'){
							$.messager.alert("提示信息","该子系统编码已经存在！","info");
						}else{
							window.location.href='<e:url value="/pages/frame/portal/subsystem/SubsystemManager.jsp"/>';
						}
					});
				}
			}
		</script>
	</head>
	<body>
		<div class="contents-head">
			<h2>子系统添加</h2>
			<div class="search-area">
				<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doAdd();">保  存</a>
				<a href="<e:url value="/pages/frame/portal/subsystem/SubsystemManager.jsp"/>" class="easyui-linkbutton easyui-linkbutton-gray">取  消</a>
			</div>
		</div>
		<form id="userForm" method="post" action="#">
			<table class="pageTable">
				<colgroup>
					<col width="20%">
					<col width="*">
				</colgroup>
				<tr>
					<th>子系统编码:</th>
					<td><input type="text" name="subsystemId" id="subsystemId" class="easyui-validatebox" size="50" required></td>
				</tr>
				<tr>
					<th>子系统名称:</th>
					<td><input type="text" name="subsystemName" id="subsystemName" class="easyui-validatebox" size="50" required></td>
				</tr>
				<!--<tr>
					<th>子系统部署内网IP:</th>
					<td><input type="text" name="subsystemIp" id="subsystemIp" class="easyui-validatebox" size="50"></td>
				</tr>
				<tr>
					<th>子系统部署外网IP:</th>
					<td><input type="text" name="subsystemIp2" id="subsystemIp2" class="easyui-validatebox" size="50"></td>
				</tr>-->
				<tr>
					<th>子系统内网访问地址:</th>
					<td><input type="text" name="subsystemAddress" id="subsystemAddress" class="easyui-validatebox" size="50" required><span class="easyui-font-gray">格式:  http://136.***.***.***:8080/telecom/</span></td>
				</tr>
				<tr>
					<th>子系统外网访问地址:</th>
					<td><input type="text" name="subsystemAddress2" id="subsystemAddress2" class="easyui-validatebox" size="50"><span class="easyui-font-gray">格式:  http://172.***.***.***:8080/telecom/</span></td>
				</tr>
				
				<!--<tr>
					<th>模拟登录地址:</th>
					<td><input type="text" name="simulationAddress" id="simulationAddress" class="easyui-validatebox" size="50" required></td>
				</tr>
				-->
				<tr>
					<th>状态:</th>
					<td><e:select id="state" name="state" items="${StateList.list}" label="TYPE_DESC" value="TYPE_CODE"/></td>
				</tr>
				<tr>
					<th>排序:</th>
					<td><input type="text" name="ord" id="ord" class="easyui-validatebox" size="50"></td>
				</tr>
				<tr>
					<th>联系人:</th>
					<td><input type="text" name="contacts" id="contacts" class="easyui-validatebox" size="50"></td>
				</tr>
				<tr>
					<th>联系电话:</th>
					<td><input type="text" name="phone" id="phone" class="easyui-validatebox" size="50"></td>
				</tr>
				<tr>
					<th>电子邮箱:</th>
					<td><input type="text" name="eMail" id="eMail" class="easyui-validatebox" validType="email" size="50"></td>
				</tr>
				
				<tr>
					<th>备注:</th>
					<td><input type="text" name="remark" id="remark" class="easyui-validatebox" size="50"></td>
				</tr>
			</table>
				
		</form>
	</body>
</html>