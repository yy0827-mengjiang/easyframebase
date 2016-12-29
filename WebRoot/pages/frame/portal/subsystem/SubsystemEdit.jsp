<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4l var="StateList">
	SELECT '1' TYPE_CODE,'有效' TYPE_DESC  FROM DUAL UNION ALL SELECT '0' TYPE_CODE,'无效' TYPE_DESC  FROM DUAL
</e:q4l>
<e:q4o var="user">
SELECT T.SUBSYSTEM_ID,
       T.SUBSYSTEM_NAME,
       T.SUBSYSTEM_ADDRESS,
       T.SUBSYSTEM_IP,
       T.SIMULATION_ADDRESS,
       T.STATE,
       T.ORD,
       T.CONTACTS,
       T.PHONE,
       T.E_MAIL,
       T.SUBSYSTEM_ADDRESS2,
       T.SUBSYSTEM_IP2,
       T.REMARK
  FROM D_SUBSYSTEM T
 WHERE T.SUBSYSTEM_ID = '${param.subsystemId }'
</e:q4o>
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
		function doEdit(){
			if($('#userForm').form('validate')){
				 var queryParam = $('#userForm').serialize();
				$.post('<e:url value="/pages/frame/portal/subsystem/SubsystemAction.jsp?eaction=edit"/>', queryParam, function(data){
					window.location.href='<e:url value="/pages/frame/portal/subsystem/SubsystemManager.jsp"/>';
				});
			}
		}
		</script>
	</head>
	<body>
		<div class="contents-head">
			<h2>子系统编辑</h2>
			<div class="search-area">
				<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doEdit();">保  存</a>
				<a href="<e:url value="/pages/frame/portal/subsystem/SubsystemManager.jsp"/>" class="easyui-linkbutton easyui-linkbutton-gray">取  消</a>
			</div>
		</div>
		<form id="userForm" method="post" action="#">
			<table class="pageTable">
				<colgroup>
					<col width="16%">
					<col width="*">
					<col width="16%">
					<col width="*">
				</colgroup>
				
				<tr>
					<th>子系统编码:</th>
					<td><input type="text" name="subsystemId" id="subsystemId"  value="${user.SUBSYSTEM_ID}" class="easyui-validatebox" size="20" required readonly></td>
					<th>子系统名称:</th>
					<td><input type="text" name="subsystemName" id="subsystemName"  value="${user.SUBSYSTEM_NAME}" class="easyui-validatebox" size="20" required></td>
				</tr>
				<!--<tr>
					<th>子系统部署内网IP:</th>
					<td><input type="text" name="subsystemIp" id="subsystemIp"  value="${user.SUBSYSTEM_IP}" class="easyui-validatebox" size="20" ></td>
				</tr>
				<tr>
					<th>子系统部署外网IP:</th>
					<td><input type="text" name="subsystemIp2" id="subsystemIp2"  value="${user.SUBSYSTEM_IP2}" class="easyui-validatebox" size="20"></td>
				</tr>-->
				<tr>
					<th>子系统内网访问地址:</th>
					<td colspan="3" ><input type="text" name="subsystemAddress" id="subsystemAddress" value="${user.SUBSYSTEM_ADDRESS}" class="easyui-validatebox" size="70" required><span class="easyui-font-gray">格式: http://136.***.***.***:8080/telecom/</span></td>
				</tr>
				<tr>
					<th>子系统外网访问地址:</th>
					<td colspan="3" ><input type="text" name="subsystemAddress2" id="subsystemAddress2" value="${user.SUBSYSTEM_ADDRESS2}" class="easyui-validatebox" size="70"><span class="easyui-font-gray">格式:http://172.***.***.***:8080/telecom/</span></td>
				</tr>
				<!--<tr>
					<th>模拟登录地址:</th>
					<td><input type="text" name="simulationAddress" id="simulationAddress" value="${user.SIMULATION_ADDRESS}" class="easyui-validatebox" size="20" required></td>
				</tr>
				-->
				<tr>
					<th>状态:</th>
					<td><e:select id="state" name="state" items="${StateList.list}" label="TYPE_DESC" value="TYPE_CODE" defaultValue="${user.STATE}"/></td>
					<th>排序:</th>
					<td><input type="text" name="ord" id="ord" value="${user.ORD}" class="easyui-validatebox" size="20"></td>
				</tr>
				
				<tr>
					<th>联系人:</th>
					<td><input type="text" name="contacts" id="contacts" value="${user.CONTACTS}" class="easyui-validatebox" size="20"></td>
					<th>联系电话:</th>
					<td><input type="text" name="phone" id="phone" value="${user.PHONE}" class="easyui-validatebox" size="20"></td>
				</tr>
				<tr>
					<th>电子邮箱:</th>
					<td colspan="3"><input type="text" name="eMail" id="eMail" value="${user.E_MAIL}" class="easyui-validatebox" validType="email" size="20"></td>
				</tr>
				<tr>
					<th>备注:</th>
					<td colspan="3"><input type="text" name="remark" id="remark" value="${user.REMARK}" class="easyui-validatebox" size="70"></td>
				</tr>	
				
			</table>
		</form>
	</body>
</html>