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
				$form.attr("action","<e:url value='/pages/frame/log/visitLogList.jsp' />");
				$form.submit(); 
			}
		</script>
	
<e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/resources/themes/blue/boncBlue.css"/>
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
		<div id="tb"  class="newSearchA">
			<h2>访问日志</h2>
			<div class="search-area">
				<form id="visitLogForm" method="post" name="visitLogForm"  action="">
					登录ID: <input id="loginId"  style="width:100px;"  type="text" name="loginId" value="${param.loginId }" class="easyui-validatebox" validType="length[0,30]">
					用户名: <input style="width:100px;" id="userName" type="text" name="userName" value="${param.userName }" class="easyui-validatebox" validType="length[0,30]">
					<%-- 地市: <e:select id="area_no" style="width:100px;"  name="area_no" items="${areaNoList.list}" label="area_desc" value="area_no" headLabel="全部" headValue="-1" defaultValue="${param.area_no }"/> --%>
					菜单名称: <input id="menuName" style="width:100px;"  type="text" name="menuName" value="${param.menuName }" class="easyui-validatebox" validType="length[0,50]">
					开始日期: <c:datebox style="width:100px;" id="loginDate" name="loginDate" required="true" format="yyyymmdd" defaultValue='${loginDate_val}'/>
					结束日期: <c:datebox style="width:100px;" id="loginDate1" name="loginDate1" required="true" format="yyyymmdd" defaultValue='${loginDate_val1}'/>
					<%-- 记录条数: <e:select style="width:50px;" id="user_number" name="user_number" items="${NumberList.list}" label="TYPE_DESC" value="TYPE_CODE" headLabel="10" headValue="10"  defaultValue="${param.user_number}"/> --%>
					<a href="javascript:void(0);" class="easyui-linkbutton" onclick="reflushDataGrid()">查询</a>
				</form>
			</div>
		</div>
		<c:datagrid url="/pages/frame/log/logAction.jsp?eaction=visitLog&loginId=${param.loginId }&userName=${param.userName }&area_no=${param.area_no }&menuName=${param.menuName }&loginDate=${loginDate_val}&loginDate1=${loginDate_val1}" id="visitLogListTable" pageSize="${Number_val }"  fit="true" border="false" toolbar="#tb">
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
					<th field="MENU_ID" width="150" sortable="true"> 
						菜单名称
					</th>
					<th field="OPERATE_TYPE_CODE" width="50" align="center" sortable="true">
						操作类型
					</th>
					<th field="OPERATE_RESULT" width="50" align="center" sortable="true">
						操作结果
					</th>
					<th field="CONTENT" width="80" sortable="true">
						操作内容
					</th>
					<th field="CLIENT_IP" width="60" align="center" sortable="true">
						ip地址
					</th>
					<th field="CREATE_DATE" width="90" align="center" sortable="true" formatter="formatDAT_visitLogListTable">
						访问时间
					</th>
				</tr>
			</thead>
		</c:datagrid>
	</body>
</html>