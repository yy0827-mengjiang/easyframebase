<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4l var="NumberList">
	SELECT '15' TYPE_CODE,'15' TYPE_DESC  FROM DUAL UNION ALL
	SELECT '20' TYPE_CODE,'20' TYPE_DESC  FROM DUAL UNION ALL 
	SELECT '25' TYPE_CODE,'25' TYPE_DESC  FROM DUAL UNION ALL
	SELECT '30' TYPE_CODE,'30' TYPE_DESC  FROM DUAL UNION ALL 
	SELECT '40' TYPE_CODE,'40' TYPE_DESC  FROM DUAL UNION ALL 
	SELECT '50' TYPE_CODE,'50' TYPE_DESC  FROM DUAL
</e:q4l>
<e:q4l var="subsystems">
	SELECT SUBSYSTEM_ID, SUBSYSTEM_NAME FROM D_SUBSYSTEM T ORDER BY ORD
</e:q4l>
<e:set var="Number_val">10</e:set>
	<e:if condition="${param.user_number!=null&&param.user_number!=''&&param.user_number!='null'}">
		<e:set var="Number_val">${param.user_number}</e:set>
	</e:if>
<e:q4l var="areaNoList">
 	   select '-1' area_no,'全省' area_desc, '0' ord from dual
        union all
      select area_no,area_desc,ord from cmcode_area 
</e:q4l>	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>访问日志</title>
		<c:resources type="easyui" style="${ThemeStyle }"/>
		<script type="text/javascript">
			$(function(){
				$(window).resize(function(){
				 	$('#visitLogListTable').treegrid('resize');
				});
			});
			function reflushDataGrid(){
				var $form = $("#visitLogForm");
				$form.attr("action","<e:url value='/pages/frame/portal/log/visitLogList.jsp' />");
				$form.submit(); 
			}
		</script>
	<link rel="stylesheet" type="text/css" href="<e:url value="/resources/themes/common/css/links.css"/>">
	</head>
	<body>
	<e:set var="loginDate_val">${e:getDate("yyyyMMdd")}</e:set>
	<e:if condition="${param.loginDate!=null&&param.loginDate!=''&&param.loginDate!='null'}">
		<e:set var="loginDate_val">${param.loginDate}</e:set>
	</e:if>
	<e:set var="loginDate_val1">${e:getDate("yyyyMMdd")}</e:set>
	<e:if condition="${param.loginDate1!=null&&param.loginDate1!=''&&param.loginDate1!='null'}">
		<e:set var="loginDate_val1">${param.loginDate1}</e:set>
	</e:if>
		<div id="tb">
			<form id="visitLogForm" method="post" name="visitLogForm"  style="display: inline;" action="">
				<div class="form topListUser">
					<dl>
						<dt>登录ID:</dt>
						<dd><input id="loginId"  type="text" name="loginId" value="${param.loginId }" class="easyui-validatebox" validType="length[0,30]" style="width: 100px;"></dd>
						<dt>用户名:</dt>
						<dd><input id="userName" type="text" name="userName" value="${param.userName }" class="easyui-validatebox" validType="length[0,30]" style="width: 100px;"></dd>
						<dt>地市:</dt>
						<dd><e:select id="area_no" name="area_no" items="${areaNoList.list}" label="area_desc" value="area_no" headLabel="全部" headValue="-1" defaultValue="${param.area_no }"/></dd>
						<dt>菜单名称:</dt>
						<dd><input id="menuName" type="text" name="menuName" value="${param.menuName }" class="easyui-validatebox" validType="length[0,50]" style="width: 100px;"></dd>
						<dt>开始日期:</dt>
						<dd><c:datebox id="loginDate" name="loginDate" required="true" format="yyyymmdd" defaultValue='${loginDate_val}'/></dd>
						<dt>结束日期:</dt>
						<dd><c:datebox id="loginDate1" name="loginDate1" required="true" format="yyyymmdd" defaultValue='${loginDate_val1}'/></dd>
						<dt>记录条数:</dt>
						<dd><e:select id="user_number" name="user_number" items="${NumberList.list}" label="TYPE_DESC" value="TYPE_CODE" headLabel="10" headValue="10"  defaultValue="${param.user_number}"/></dd>
						<dt>子系统:</dt>
						<dd><e:select id="subSystemId" name="subSystemId" items="${subsystems.list}" label="SUBSYSTEM_NAME" value="SUBSYSTEM_ID" style="width:100px" headValue="-1" headLabel="请选择" defaultValue="${param.subSystemId}"/></dd>
					</tr>
					</dl>
					<p>
						<a href="javascript:void(0);" class="easyui-linkbutton" onclick="reflushDataGrid()">查询</a>
					</p>
				</div>
			</form>
		</div>
		<c:datagrid url="/pages/frame/portal/log/logAction.jsp?eaction=visitLog&loginId=${param.loginId }&userName=${param.userName }&area_no=${param.area_no }&menuName=${param.menuName }&loginDate=${loginDate_val}&loginDate1=${loginDate_val1}&subSystemId=${param.subSystemId }" id="visitLogListTable" pageSize="${Number_val }" download="访问日志" title="访问日志" fit="true" border="false" toolbar="#tb">
			<thead>
				<tr>
					<th field="LOGIN_ID" width="50" align="center" sortable="true">
						登录ID
					</th>
					<th field="USER_NAME" width="50" align="center" sortable="true">
						用户名
					</th>
					<th field="AREA_DESC" width="30" align="center" sortable="true">
						地市
					</th>
					<th field="MENU_ID" width="250" sortable="true"> 
						菜单名称
					</th>
					<th field="OPERATE_TYPE_CODE" width="50" align="center" sortable="true">
						操作类型
					</th>
					<th field="OPERATE_RESULT" width="50" align="center" sortable="true">
						操作结果
					</th>
					<th field="CONTENT" width="100" sortable="true">
						操作内容
					</th>
					<th field="CLIENT_IP" width="100" align="center" sortable="true">
						ip地址
					</th>
					<th field="CREATE_DATE" width="150" align="center" sortable="true">
						访问时间
					</th>
				</tr>
			</thead>
		</c:datagrid>
	</body>
</html>