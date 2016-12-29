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
				$form.attr("action","<e:url value='/pages/frame/portal/log/operationLogList.jsp' />");
				$form.submit();
			}
		</script>
		<link rel="stylesheet" type="text/css" href="<e:url value="/resources/themes/common/css/links.css"/>">
	</head>
	<body>
	 	<div id="tb">
	 	<e:set var="loginDate_val">${e:getDate("yyyyMMdd")}</e:set>
		<e:if condition="${param.loginDate!=null&&param.loginDate!=''&&param.loginDate!='null'}">
			<e:set var="loginDate_val">${param.loginDate}</e:set>
		</e:if>
		<e:set var="loginDate_val1">${e:getDate("yyyyMMdd")}</e:set>
		<e:if condition="${param.loginDate1!=null&&param.loginDate1!=''&&param.loginDate1!='null'}">
			<e:set var="loginDate_val1">${param.loginDate1}</e:set>
		</e:if>
			<form id="operationLogForm" method="post" name="operationLogForm"  style="display: inline;" action="">
				<div class="form topListUser">
					<dl>
						<dt>登录ID:</dt>
						<dd><input id="loginId"  type="text" name="loginId" value="${param.loginId }" class="easyui-validatebox" validType="length[0,30]"></dd>
						<dt>用户名:</dt>
						<dd><input id="userName" type="text" name="userName" value="${param.userName }" class="easyui-validatebox" validType="length[0,30]"></dd>
						<dt>地市:</dt>
						<dd><e:select id="area_no" name="area_no" items="${areaNoList.list}" label="area_desc" value="area_no" headLabel="全部" headValue="-1" defaultValue="${param.area_no }"/></dd>
						<dt>菜单名称:</dt>
						<dd><input id="menuName" type="text" name="menuName" value="${param.menuName }" class="easyui-validatebox" validType="length[0,50]"></dd>
						<dt>操作类型:</dt>
						<dd style=" position:relative; top:2px;"><e:select id="operateTypeCode" name="operateTypeCode" items="${operateTypeList.list}" label="OPERATE_TYPE_DESC" value="OPERATE_TYPE_CODE" headLabel="全部" headValue="" defaultValue="${param.operateTypeCode}"/></dd>
						<dt>开始日期:</dt>
						<dd><c:datebox id="loginDate" name="loginDate" required="true" format="yyyymmdd" defaultValue='${loginDate_val}'/></dd>
						<dt>结束日期:</dt>
							<dd><c:datebox id="loginDate1" name="loginDate1" required="true" format="yyyymmdd" defaultValue='${loginDate_val1}'/></dd>
						</dl>
					<p><a href="javascript:void(0);" class="easyui-linkbutton" onclick="reflushDataGrid()">查询</a></p>
				</div>
			</form>
		</div>
		
		
		
		<c:datagrid url="/pages/frame/portal/log/logAction.jsp?eaction=operationLog&loginId=${param.loginId }&area_no=${param.area_no }&userName=${param.userName }&menuName=${param.menuName }&operateTypeCode=${param.operateTypeCode }&loginDate=${loginDate_val}&loginDate1=${loginDate_val1}" id="operationLogListTable" pageSize="15" download="交互性日志" fit="true" border="false" title="交互性日志" toolbar="#tb">
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
					<th field="CREATE_DATE" width="130" align="center">
						操作时间
					</th>
				</tr>
			</thead>
		</c:datagrid>
	</body>
</html>