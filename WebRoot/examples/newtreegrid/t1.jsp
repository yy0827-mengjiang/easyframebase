<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ request.getContextPath() + "/"%>">
<title>下钻表格</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<c:resources type="highchart" />
<c:resources type="easyui"  style="${ThemeStyle }"/>
<script type="text/javascript" src="examples/newtreegrid/jquery.pagination.js"></script>

<link rel="stylesheet" type="text/css" href="examples/newtreegrid/pagination.css"/>

</head>
<body>

 <table id="tt2" style="width: 790px; height: 400px;">
	<thead>
	<tr>
		<th field="V1" align="center" width="200" editor="text"> 指标1 </th>
		<th field="V2" align="center" width="200" editor="text"> 指标2 </th>
		<th field="V3" align="center" width="200" editor="text"> 指标3 </th>
	</tr>
	</thead>
</table>

<a:treegrid id="tt2" idField="ID" treeField="V0" treeFieldTitle="维度"
			treeFieldWidth="150" pagination="true" pageSize="5" drillRowHeight="250"
			url="/examples/newtreegrid/demoActon.jsp?eaction=loadDim"
			defaultDim="all,area" menuWidth="170" download="下钻示例2">
			<a:dimension label="日期" field="day" group="area_group" level="0" showChart="true"></a:dimension>
			<a:dimension label="地市" field="area" group="area_group" level="0" showChart="true"></a:dimension>
			<a:link url="examples/newtreegrid/userCreditChart2.jsp" label="业务类型柱线图"></a:link>
			<a:link url="examples/newtreegrid/ndonutpie.jsp" label="分区县发展饼图"></a:link>
</a:treegrid> 		
</body>
</html>