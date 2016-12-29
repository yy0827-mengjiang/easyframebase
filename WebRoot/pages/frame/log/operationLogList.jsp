<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4l var="operateTypeList">
	SELECT OPERATE_TYPE_CODE,OPERATE_TYPE_DESC  FROM E_OPERATE_TYPE WHERE OPERATE_TYPE_CODE!='1' ORDER BY ORD
</e:q4l>
<e:q4l var="areaNoList">
 	   select '-1' area_no,'全省' area_desc, '0' ord from dual
        union all
      select area_no,area_desc,ord from cmcode_area
</e:q4l>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>交互性日志</title>
		<c:resources type="easyui" style="${ThemeStyle }"/>
		<script type="text/javascript">
			$(function(){
				$(window).resize(function(){
				 	$('#operationLogListTable').treegrid('resize');
				});
			});
			function reflushDataGrid(){
				var $form = $("#operationLogForm");
				$form.attr("action","<e:url value='/pages/frame/log/operationLogList.jsp' />");
				$form.submit();
			}
		</script>
		
<e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/resources/themes/blue/boncBlue.css"/>
	</head>
	<body>
	 	<div id="tb"  class="newSearchA">
	 	<e:set var="loginDate_val">${e:getDate("yyyyMMdd")}</e:set>
		<e:if condition="${param.loginDate!=null&&param.loginDate!=''&&param.loginDate!='null'}">
			<e:set var="loginDate_val">${param.loginDate}</e:set>
		</e:if>
		<e:set var="loginDate_val1">${e:getDate("yyyyMMdd")}</e:set>
		<e:if condition="${param.loginDate1!=null&&param.loginDate1!=''&&param.loginDate1!='null'}">
			<e:set var="loginDate_val1">${param.loginDate1}</e:set>
		</e:if>
			<h2>操作日志</h2>
			<div class="search-area">
				<form id="operationLogForm" method="post" name="operationLogForm" action="">
				登录ID: <input id="loginId"  style="width:100px" type="text" name="loginId" value="${param.loginId }" class="easyui-validatebox" validType="length[0,30]">
				<%-- 用户名: <input id="userName" style="width:100px" type="text" name="userName" value="${param.userName }" class="easyui-validatebox" validType="length[0,30]">
				地市: <e:select  style="width:100px"  id="area_no" name="area_no" items="${areaNoList.list}" label="area_desc" value="area_no" headLabel="全部" headValue="-1" defaultValue="${param.area_no }"/> --%>
				菜单名称: <input id="menuName"  style="width:100px"  type="text" name="menuName" value="${param.menuName }" class="easyui-validatebox" validType="length[0,50]">
				操作类型: <e:select id="operateTypeCode" style="width:100px" name="operateTypeCode" items="${operateTypeList.list}" label="OPERATE_TYPE_DESC" value="OPERATE_TYPE_CODE" headLabel="全部" headValue="" defaultValue="${param.operateTypeCode}"/>
				开始日期: <c:datebox id="loginDate" style="width:100px" name="loginDate" required="true" format="yyyymmdd" defaultValue='${loginDate_val}'/>
				结束日期: <c:datebox id="loginDate1" style="width:100px" name="loginDate1" required="true" format="yyyymmdd" defaultValue='${loginDate_val1}'/>
				<a href="javascript:void(0);" class="easyui-linkbutton" onclick="reflushDataGrid()">查询</a>
				</form>
			</div>
		</div>
		
		
		
		<c:datagrid url="/pages/frame/log/logAction.jsp?eaction=operationLog&loginId=${param.loginId }&area_no=${param.area_no }&userName=${param.userName }&menuName=${param.menuName }&operateTypeCode=${param.operateTypeCode }&loginDate=${loginDate_val}&loginDate1=${loginDate_val1}" id="operationLogListTable" pageSize="15"  fit="true" border="false" toolbar="#tb">
			<thead>
				<tr>
					<th field="LOGIN_ID" width="50" align="center">
						登录ID
					</th>
					<th field="USER_NAME" width="50" align="center">
						用户名
					</th>
					<th field="AREA_DESC" width="30" align="center" sortable="true">
						地市
					</th>
					<th field="MENU_ID" width="210"> 
						菜单名称
					</th>
					<th field="OPERATE_TYPE_CODE" width="60" align="center">
						操作类型
					</th>
					<th field="OPERATE_RESULT" width="60" align="center">
						操作结果
					</th>
					<th field="CONTENT" width="170">
						操作内容
					</th>
					<th field="CLIENT_IP" width="70" align="center">
						IP地址
					</th>
					<th field="CREATE_DATE" width="130" align="center" formatter="formatDAT_operationLogListTable">
						操作时间
					</th>
				</tr>
			</thead>
		</c:datagrid>
	</body>
</html>