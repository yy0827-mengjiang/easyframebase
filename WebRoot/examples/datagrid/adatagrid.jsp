<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>表格组件实例</title>
		<c:resources type="easyui"  style="${ThemeStyle }"/>
		<e:script value="/resources/themes/common/js/download.js"/>
		<e:script value="/resources/themes/common/js/downloadpage.js"/>
		<e:style value="/resources/themes/common/css/examples.css"/>
		</head>
<body>
<div class="exampleWarp">
<h1 class="titThree">表格数据导出</h1>
<a:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table10" download="表格" downArgs="&A=33&b=44" style="width:800px;height:400px;">
	<thead>
		<tr>
			<th field="AREA_NO" width="100">地市编号</th>
			<th field="CITY_NO" width="100">区县编号</th>
			<th field="VALUE1" width="100">指标1</th>
			<th field="VALUE2" width="100">指标2</th>
			<th field="VALUE3" width="200">指标3</th>
			<th field="VALUE4" width="200">指标4</th>
		</tr>
	</thead>
</a:datagrid>
</div>

</body>
</html>