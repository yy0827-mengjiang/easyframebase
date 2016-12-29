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
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>菜单访问日志</title>
		<c:resources type="easyui" style="${ThemeStyle }"/>
<e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/resources/themes/blue/boncBlue.css"/>
		<script type="text/javascript">
			$(function(){
				$(window).resize(function(){
				 	$('#visitLogListTable').treegrid('resize');
				});
			});
			function reflushDataGrid(){
				var $form = $("#visitLogForm");
				$form.attr("action","<e:url value='/pages/frame/log/menuLogList.jsp' />");
				$form.submit(); 
			}
		</script>
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
		<div id="tb" class="newSearchA">
			<h2>菜单访问排名</h2>
			<form id="visitLogForm" method="post" name="visitLogForm" action="">
				<div class="search-area">
					开始日期: <c:datebox style="width:100px" id="loginDate" name="loginDate" required="true" format="yyyymmdd" defaultValue='${loginDate_val}'/>
					结束日期: <c:datebox style="width:100px" id="loginDate1" name="loginDate1" required="true" format="yyyymmdd" defaultValue='${loginDate_val1}'/>
					记录条数: <e:select id="user_number" name="user_number" items="${NumberList.list}" label="TYPE_DESC" value="TYPE_CODE" headLabel="10" headValue="10"  defaultValue="${param.user_number}"/>
					<a href="javascript:void(0);" class="easyui-linkbutton" onclick="reflushDataGrid()">查询</a>
				</div>
			</form>
		</div>
		<c:datagrid url="/pages/frame/log/logAction.jsp?eaction=visitMenuLog&loginDate=${loginDate_val}&loginDate1=${loginDate_val1}" id="visitLogListTable" pageSize="${Number_val }"  fit="true" border="false" toolbar="#tb">
			<thead>
				<tr>
					<th field="MENU_ID" width="240" sortable="true"> 
						菜单名称
					</th>
					<th field="VISIT_NUM" width="20" align="center" sortable="true">
						访问次数
					</th>
				</tr>
			</thead>
		</c:datagrid>
	</body>
</html>