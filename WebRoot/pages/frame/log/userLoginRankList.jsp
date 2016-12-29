<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>用户登录排名</title>
		<c:resources type="easyui" style="${ThemeStyle }"/>
		<script type="text/javascript">
			$(function(){
				$(window).resize(function(){
				 	$('#visitLogListTable').treegrid('resize');
				});
			});
			function reflushDataGrid(){
				var $form = $("#visitLogForm");
				$form.attr("action","<e:url value='/pages/frame/log/userLoginRankList.jsp' />");
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
	<e:set var="endDate_val">${e:getDate("yyyyMMdd")}</e:set>
	<e:if condition="${param.endDate!=null&&param.endDate!=''&&param.endDate!='null'}">
		<e:set var="endDate_val">${param.endDate}</e:set>
	</e:if>
		<div id="tb" class="newSearchA">
			<h2>用户登录排名</h2>
			<div class="search-area">
				<form id="visitLogForm" method="post" name="visitLogForm"  action="">
					 起始时间: <c:datebox id="loginDate" style="width:100px" name="loginDate" required="true" format="yyyymmdd" defaultValue='${loginDate_val}'/>
					结束时间: <c:datebox id="endDate" style="width:100px" name="endDate" required="true" format="yyyymmdd" defaultValue='${endDate_val}'/>
					<a href="javascript:void(0);" class="easyui-linkbutton" onclick="reflushDataGrid()">查询</a>
				</form>
			</div>
		</div>
		<c:datagrid url="/pages/frame/log/logAction.jsp?eaction=userLoginRank&loginDate=${loginDate_val}&endDate=${endDate_val}" id="visitLogListTable" pageSize="15"  fit="true" border="false" toolbar="#tb">
			<thead>
				<tr>
					<th field="USER_ID" width="25%" align="center">
						用户ID
					</th>
					<th field="USER_NAME" width="25%" align="center">
						用户姓名
					</th>
					<th field="AREA_DESC" width="25%" align="center"> 
						地市
					</th>
					<th field="LOGIN_COU" width="25%" align="center">
						登录次数
					</th>
				</tr>
			</thead>
		</c:datagrid>
	</body>
</html>