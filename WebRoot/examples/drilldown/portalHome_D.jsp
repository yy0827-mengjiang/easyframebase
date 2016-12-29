<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<e:set var="defual_day" value="20130418" />
<e:set var="areaNo" value="432" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>门户</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
	<c:resources type="easyui" style="b" />
	</head>
	<body>
		<table id="tt" style="width: auto; height: 400px">
			<thead>
				<tr>
					<th align="center" colspan="3">
						发展
					</th>
					<th align="center" colspan="3">
						收入
					</th>
				</tr>
				<tr>
					<th field="C3" align="center" width="100" editor="text">
						当日发展
					</th>
					<th field="C5" align="center" width="100" editor="text">
						月累计发展
					</th>
					<th field="C6" align="center" width="100" editor="text">
						月累计环比
					</th>
					<th field="C7" align="center" width="100" editor="text">
						当日收入
					</th>
					<th field="C9" align="center" width="100" editor="text">
						月累计收入
					</th>
					<th field="C11" align="center" width="100" editor="text">
						累计收入环比
					</th>
				</tr>
			</thead>
		</table>
		<c:treetable id="tt" idField="ID" treeField="C2" treeFieldTitle="分析对像"
			treeFieldWidth="170"
			url="/examples/drilldown/portalActonD.jsp?eaction=loadDim&acct_day=${defual_day}&areano=${areaNo }"
			defaultDim="all" menuWidth="170">
			<c:dimension label="地市" field="area"></c:dimension>
			<c:dimension label="区县" field="city"></c:dimension>
		</c:treetable>
	</body>
</html>