<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">
<title>下钻组件，下钻为新表格demo</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<c:resources type="easyui,app,highchart" style="b" />
<title>drillsubgrid</title>
<script>
function onClickRow(rowIndex, rowData){
	alert("主表行单击事件"+rowIndex+rowData.ACCT_MONTH);
}
function subonClickRow(rowIndex, rowData){
	alert("从表行单击事件"+rowIndex+rowData.DIM);
}
function onDblClickRow(rowIndex, rowData){
	alert("主表行双击击事件"+rowIndex+rowData.ACCT_MONTH);
}
function subonDblClickRow(rowIndex, rowData){
	alert("从表行双击击事件"+rowIndex+rowData.DIM);
}
function subonClickCell(rowIndex, field, value){
	alert("从表单元格单击事件"+rowIndex+value);
}
function onDblClickCell(rowIndex, field, value){
	alert("主表单元格双击事件"+rowIndex+value);
}
function subonDblClickCell(rowIndex, field, value){
	alert("从表单元格双击事件"+rowIndex+value);
}
</script>
<e:style value="resources/themes/base/boncBase@links.css"/>
<e:style value="resources/themes/blue/boncBlue.css"/>
</head>
<body>
<div class="exampleWarp">
	<h1 class="titOne">下钻子表格</h1>
	<table id="dg1" style="width:800px;height:180px" title="1、基础表格">
		<thead>
			<tr>
				<th field="ACCT_MONTH" width="100">账期月</th>
				<th field="V1" width="100">指标1</th>
				<th field="V2" width="100">指标2</th>
				<th field="V3" width="100">指标3</th>
				<th field="V4" width="100">指标4</th>
			</tr>
		</thead>
	</table>
	<table id="subdg1" style="display:none">
		<thead>
			<tr>
				<th field="DIM" width="200">维度</th>
				<th field="V1" width="100">指标1</th>
				<th field="V2" width="100">指标2</th>
				<th field="V3" width="100">指标3</th>
				<th field="V4" width="100">指标4</th>
			</tr>
		</thead>
	</table>
	<c:drillsubgrid 
		id="dg1"
		subid="subdg1" 
		url="examples/drillsubgrid/drillsubgrid_action.jsp?SubField=mainList" 
		suburl="examples/drillsubgrid/drillsubgrid_action.jsp" 
		drillfield="ACCT_MONTH" 
		pagination="false"
		subpagination="false"
		>
		<c:dimension label="账期日" field="ACCT_DAY"></c:dimension>
		<c:dimension label="地市" field="AREA_NO"></c:dimension>
		<c:dimension label="区县" field="CITY_NO"></c:dimension>
	</c:drillsubgrid>
	<br>
	<br>
	<table id="dg2" style="width:800px;height:180px" title="2、分页表格">
		<thead>
			<tr>
				<th field="ACCT_MONTH" width="100">账期月</th>
				<th field="V1" width="100">指标1</th>
				<th field="V2" width="100">指标2</th>
				<th field="V3" width="100">指标3</th>
				<th field="V4" width="100">指标4</th>
			</tr>
		</thead>
	</table>
	<table id="subdg2" style="display:none">
		<thead>
			<tr>
				<th field="DIM" width="200">维度</th>
				<th field="V1" width="100">指标1</th>
				<th field="V2" width="100">指标2</th>
				<th field="V3" width="100">指标3</th>
				<th field="V4" width="100">指标4</th>
			</tr>
		</thead>
	</table>
	<c:drillsubgrid 
		id="dg2"
		subid="subdg2" 
		url="examples/drillsubgrid/drillsubgrid_action.jsp?SubField=mainList" 
		suburl="examples/drillsubgrid/drillsubgrid_action.jsp" 
		drillfield="ACCT_MONTH" 
		pagination="true"
		pageSize="20"
		pageList="10,20,30"
		subpagination="true"
		subpageSize="20"
		subpageList="10,20,30"
		>
		<c:dimension label="账期日" field="ACCT_DAY"></c:dimension>
		<c:dimension label="地市" field="AREA_NO"></c:dimension>
		<c:dimension label="区县" field="CITY_NO"></c:dimension>
	</c:drillsubgrid>
	<br>
	<br>
	<table id="dg3" style="width:800px;height:180px" title="3、分页+导出表格">
		<thead>
			<tr>
				<th field="ACCT_MONTH" width="100">账期月</th>
				<th field="V1" width="100">指标1</th>
				<th field="V2" width="100">指标2</th>
				<th field="V3" width="100">指标3</th>
				<th field="V4" width="100">指标4</th>
			</tr>
		</thead>
	</table>
	<table id="subdg3" style="display:none">
		<thead>
			<tr>
				<th field="DIM" width="200">维度</th>
				<th field="V1" width="100">指标1</th>
				<th field="V2" width="100">指标2</th>
				<th field="V3" width="100">指标3</th>
				<th field="V4" width="100">指标4</th>
			</tr>
		</thead>
	</table>
	<c:drillsubgrid 
		id="dg3"
		subid="subdg3" 
		url="examples/drillsubgrid/drillsubgrid_action.jsp?SubField=mainList" 
		suburl="examples/drillsubgrid/drillsubgrid_action.jsp" 
		drillfield="ACCT_MONTH" 
		pagination="true"
		pageSize="20"
		pageList="10,20,30"
		subpagination="true"
		subpageSize="20"
		subpageList="10,20,30"
		download="导出的表格1"
		subdownload="导出的表格2"
		>
		<c:dimension label="账期日" field="ACCT_DAY"></c:dimension>
		<c:dimension label="地市" field="AREA_NO"></c:dimension>
		<c:dimension label="区县" field="CITY_NO"></c:dimension>
	</c:drillsubgrid>
	<br>
	<br>
	<table id="dg4" style="width:800px;height:180px" title="4、事件">
		<thead>
			<tr>
				<th field="ACCT_MONTH" width="100">账期月</th>
				<th field="V1" width="100">指标1</th>
				<th field="V2" width="100">指标2</th>
				<th field="V3" width="100">指标3</th>
				<th field="V4" width="100">指标4</th>
			</tr>
		</thead>
	</table>
	<table id="subdg4" style="display:none">
		<thead>
			<tr>
				<th field="DIM" width="200">维度</th>
				<th field="V1" width="100">指标1</th>
				<th field="V2" width="100">指标2</th>
				<th field="V3" width="100">指标3</th>
				<th field="V4" width="100">指标4</th>
			</tr>
		</thead>
	</table>
	<c:drillsubgrid 
		id="dg4"
		subid="subdg4" 
		url="examples/drillsubgrid/drillsubgrid_action.jsp?SubField=mainList" 
		suburl="examples/drillsubgrid/drillsubgrid_action.jsp" 
		drillfield="ACCT_MONTH" 
		pagination="false"
		subpagination="false"
		onClickRow="onClickRow"
		subonClickRow="subonClickRow"
		>
		<c:dimension label="账期日" field="ACCT_DAY"></c:dimension>
		<c:dimension label="地市" field="AREA_NO"></c:dimension>
		<c:dimension label="区县" field="CITY_NO"></c:dimension>
	</c:drillsubgrid>
	<br>
	<br>
	<table id="dg5" style="width:800px;height:180px" title="5、冰冻列">
		<thead>
			<tr>
				<th field="V1" width="500">指标1</th>
				<th field="V2" width="500">指标2</th>
				<th field="V3" width="500">指标3</th>
				<th field="V4" width="500">指标4</th>
			</tr>
		</thead>
	</table>
	<table id="subdg5" style="display:none">
		<thead>
			<tr>
				<th field="V1" width="500">指标1</th>
				<th field="V2" width="500">指标2</th>
				<th field="V3" width="500">指标3</th>
				<th field="V4" width="500">指标4</th>
			</tr>
		</thead>
	</table>
	<c:drillsubgrid 
		id="dg5"
		subid="subdg5" 
		url="examples/drillsubgrid/drillsubgrid_action.jsp?SubField=mainList" 
		suburl="examples/drillsubgrid/drillsubgrid_action.jsp" 
		drillfield="ACCT_MONTH" 
		frozenColumns="[[{field:'ACCT_MONTH',title:'账期月',width:'100',align:'center'}]]"
		subfrozenColumns="[[{field:'DIM',title:'维度',width:'100',align:'center'}]]"
		>
		<c:dimension label="账期日" field="ACCT_DAY"></c:dimension>
		<c:dimension label="地市" field="AREA_NO"></c:dimension>
		<c:dimension label="区县" field="CITY_NO"></c:dimension>
	</c:drillsubgrid>
</div>
</body>
</html>