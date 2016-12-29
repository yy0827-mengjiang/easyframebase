<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>">

		<title>旋转组件示例</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
	</head>
	<c:resources type="easyui"  style="${ThemeStyle }"/>
	<e:style value="resources/themes/base/boncBase@links.css"/>
<e:style value="resources/themes/blue/boncBlue.css"/>
	<script type="text/javascript">
  
  </script>
	<body style="">
		<div class="exampleWarp">
		
<h1 class="titOne">旋转组件<em>c:datagrid</em></h1>
<h1 class="titThree">参数(旋转组件是在datagrid表格组件上的扩展功能，此处只列出了旋转相关的属性，其他属性请参考datagrid标签)</h1>
<table class="parameters">
	<colgrounp>
		<col width="15%" />
		<col width="*" />
	</colgrounp>
	<tr>
		<td>dimCol</td>
		<td>旋转表格的维度列(纵向的维度列)</td>
	</tr>
	<tr>
		<td>kpiCol</td>
		<td>指标列</td>
	</tr>
	<tr>
		<td>rotaCol</td>
		<td>旋转列(横向的为旋转列)</td>
	</tr>
	<tr>
		<td>rotaColOrder</td>
		<td>旋转列排序方式:asc、desc</td>
	</tr>
	<tr>
		<td>rotaDimTable</td>
		<td>以码表旋转时的码表名</td>
	</tr>
	<tr>
		<td>rotaDimCode</td>
		<td>以码表旋转时码表的编码列</td>
	</tr>
	<tr>
		<td>rotaDimDesc</td>
		<td>以码表旋转时码表的描述列</td>
	</tr>
	<tr>
		<td>rotaOrdCode</td>
		<td>以码表旋转时码表的排序列</td>
	</tr>
	<tr>
		<td>rotaOrdType</td>
		<td>以码表旋转时码表的排序方式:asc、desc</td>
	</tr>
	
</table>
		
			<h1 class="titThree">
			    以SQL查询的数据旋转
			</h1>
			    <c:datagrid
					url="/examples/rotate/action.jsp?eaction=rotaTable"
					id="tag_divhtml01_ROTABLE_1425001251123" 
					sortName="地市编码" sortOrder="asc"
					style="width:auto;height:auto;" download="旋转表格" pagination="true" pageSize="10" 
					dimCol="地市名称" rotaCol="时间" kpiCol="TARGET_VALUE" 
					rotaColOrder="asc">
				</c:datagrid>


			<h1 class="titThree">
				以码表旋转
			</h1>
			<c:datagrid 
					url="/examples/rotate/action.jsp?eaction=rotaTable2"
					id="tag_divhtml01_ROTABLE_1425001903710" sortName="时间" sortOrder="desc"
					style="width:auto;height:auto;" download="码表旋转测试" pagination="true"
					pageSize="10" 
					dimCol="时间"   rotaCol="地市名称"  kpiCol="TARGET_VALUE" 
					rotaDimTable="CMCODE_AREA"   rotaDimCode="AREA_NO"   rotaDimDesc="AREA_DESC" 
					rotaOrdCode="ORD"  rotaOrdType="asc">
			</c:datagrid>
			
		</div>
	</body>
</html>
