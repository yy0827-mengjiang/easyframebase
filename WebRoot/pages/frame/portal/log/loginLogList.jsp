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
		<title>登陆日志</title>
		<c:resources type="easyui" style="${ThemeStyle }"/>
		<script type="text/javascript">
			$(function(){
				$(window).resize(function(){
				 	$('#loginLogListTable').treegrid('resize');
				});
			});
			function reflushDataGrid(){
				var $form = $("#loginLogForm");
				$form.attr("action","<e:url value='/pages/frame/portal/log/loginLogList.jsp' />");
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
			<form id="loginLogForm" method="post" name="loginLogForm" style="display: inline;" action="">
				<div class="topListUser">
					<dl>
						<dt>登录ID:</dt>
						<dd><input id="loginId"  type="text" name="loginId" value="${param.loginId }" class="easyui-validatebox" validType="length[0,30]"></dd>
						<dt>用户客户端IP:</dt>
						<dd><input id="clientIp" type="text" name="clientIp" value="${param.clientIp }" class="easyui-validatebox" validType="length[0,50]"></dd>
						<dt>地市:</dt>
						<dd><e:select id="area_no" name="area_no" items="${areaNoList.list}" label="area_desc" value="area_no" headLabel="全部" headValue="-1" defaultValue="${param.area_no }"/></dd>
						<dt>开始时间:</dt>
						<dd><c:datebox id="loginDate" name="loginDate" required="true" format="yyyymmdd" defaultValue='${loginDate_val}'/></dd>
						<dt>结束时间:</dt>
						<dd><c:datebox id="loginDate1" name="loginDate1" required="true" format="yyyymmdd" defaultValue='${loginDate_val1}'/></dd>
						<dt>记录条数:</dt>
						<dd><e:select id="user_number" name="user_number" items="${NumberList.list}" label="TYPE_DESC" value="TYPE_CODE" headLabel="10" headValue="10"  defaultValue="${param.user_number}"/>
					</dl>
					<p><a href="javascript:void(0);" class="easyui-linkbutton" onclick="reflushDataGrid()">查询</a><p>
				</div>
			</form>
		</div>
		<c:datagrid url="/pages/frame/portal/log/logAction.jsp?eaction=loginLog&loginId=${param.loginId }&area_no=${param.area_no }&clientIp=${param.clientIp }&loginDate=${loginDate_val}&loginDate1=${loginDate_val1}" id="loginLogListTable" nowrap="false" pageSize="${Number_val }" fit="true" download="登陆日志" sortName="LOGIN_DATE" sortName="LOGOUT_DATE" sortOrder="desc" fit="true" border="false" title="登陆日志" toolbar="#tb">
			<thead>
				<tr>
				    <th field="LOGIN_ID" width="80" align="center" sortable="true">
						登录ID
					</th>
					<th field="STATE" width="30" align="center" sortable="true">
						状态
					</th>
					<th field="AREA_DESC" width="30" align="center" sortable="true">
						地市
					</th>
					<th field="USER_NAME" width="50" align="center" sortable="true">
						用户名
					</th>
					<th field="CLIENT_IP" width="80" align="center" sortable="true">
						用户客户端IP
					</th>
					<th field="LOGIN_DATE" width="110" align="center" sortable="true">
						登录时间
					</th>
					<th field="LOGOUT_DATE" width="110" align="center" sortable="true">
						登出时间
					</th>
					<th field="CLIENT_BROWSOR" width="230" sortable="true">
						客户端浏览器
					</th>
				</tr>
			</thead>
		</c:datagrid>
	</body>
</html>