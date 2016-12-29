<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ request.getContextPath() + "/"%>">
		<title>下钻表格</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<c:resources type="easyui"  style="${ThemeStyle }"/>
		<e:script value="/resources/themes/common/js/download.js"/>
		<e:script value="/resources/themes/common/js/downloadpage.js"/>
	</head>
	<body style="padding-left:20px;">
	<h1 >示例8：自由下钻表格，level参数，都为0，地市、日期可以任意下钻。复杂表头</h1>
		<table id="tt8" style="width: 800px; height: auto;">
			<thead>
				<tr>
					<th align="center" width="140" colspan="3">
						指标列
					</th>
				</tr>
				<tr>
					<th field="V1" align="center" width="140" editor="text">
						指标1
					</th>
					<th field="V2" align="center" width="140" editor="text">
						指标2
					</th>
					<th field="V3" align="center" width="140" editor="text">
						指标3
					</th>
				</tr>
			</thead>
		</table>
		
		<a:treegrid id="tt8" idField="ID" treeField="V0" treeFieldTitle="维度"
			treeFieldWidth="170"
			url="/examples/treegrid/demoActon.jsp?eaction=loadDim"
			defaultDim="all,day" menuWidth="170" download="下钻示例8">
				<c:dimension label="日期" field="day" group="area_group" level="0"></c:dimension>
				<c:dimension label="地市" field="area" group="area_group" level="0"></c:dimension>
		</a:treegrid>
		<a:export id="tt8" fileName="下钻示例8"/>
	</body>
</html>