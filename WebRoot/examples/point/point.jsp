<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">
<title>My JSF 'point.jsp' starting page</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<e:style value="resources/themes/base/boncBase@links.css"/>
<e:style value="resources/themes/blue/boncBlue.css"/>
<c:resources type="highchart" />
</head>
<e:q4l var="testList">select AREA_NO,
	sum(VALUE1) a,
	sum(VALUE2) b,
	sum(VALUE1+VALUE2) c,
	sum(VALUE1*2) d,
	'指标1' ser
	from (
	SELECT '431' AREA_NO,'长春' AREA_DESC,111 VALUE1, 334 VALUE2 FROM DUAL
	UNION ALL
	SELECT '432' AREA_NO,'吉林' AREA_DESC,121 VALUE1, 327 VALUE2 FROM DUAL
	UNION ALL
	SELECT '437' AREA_NO,'辽源' AREA_DESC,331 VALUE1, 533 VALUE2 FROM DUAL
	
	)
	group by AREA_NO
	order by AREA_NO</e:q4l>
<body>
<div class="exampleWarp">
<h1 class="titOne">散点图<em>c:point</em></h1>
<h1 class="titThree">参数</h1>
<table class="parameters">
	<colgrounp>
		<col width="15%" />
		<col width="*" />
	</colgrounp>
	<tr>
		<td>id</td>
		<td>线图id</td>
	</tr>
	<tr>
		<td>width</td>
		<td>线图宽度</td>
	</tr>
	<tr>
		<td>height</td>
		<td>线图高度</td>
	</tr>
	<tr>
		<td>items</td>
		<td>数据集</td>
	</tr>
	<tr>
		<td>indicator</td>
		<td>指标列</td>
	</tr>
	<tr>
		<td>dimension</td>
		<td>维度列</td>
	</tr>
	<tr>
		<td>value</td>
		<td>数据列</td>
	</tr>
	<tr>
		<td>color</td>
		<td>颜色列</td>
	</tr>
	<tr>
		<td>title</td>
		<td>线图标题</td>
	</tr>
	<tr>
		<td>subtitle</td>
		<td>线图子标题</td>
	</tr>
	<tr>
		<td>ytitle</td>
		<td>线图y轴标题</td>
	</tr>
	<tr>
		<td>unit</td>
		<td>单位名称</td>
	</tr>
	<tr>
		<td>backgroundColor</td>
		<td>背景颜色</td>
	</tr>
	<tr>
		<td>borderWidth</td>
		<td>边框宽度</td>
	</tr>
	<tr>
		<td>legendBorderWidth</td>
		<td>图例边框宽度</td>
	</tr>
	<tr>
		<td>crosshairs</td>
		<td>是否显示准线</td>
	</tr>
	<tr>
		<td>legend</td>
		<td>是否显示图例</td>
	</tr>
	<tr>
		<td>functionName</td>
		<td>拖动事件名称</td>
	</tr>
	<tr>
		<td>functionIsParam</td>
		<td>拖动事件函数是否加参数</td>
	</tr>
	<tr>
		<td>xstep</td>
		<td>X轴设置步长</td>
	</tr>
	<tr>
		<td>ystep</td>
		<td>Y轴设置步长</td>
	</tr>
	<tr>
		<td>xmin</td>
		<td>X轴最小刻度</td>
	</tr>
	<tr>
		<td>xmax</td>
		<td>X轴最大刻度</td>
	</tr>
	<tr>
		<td>ymin</td>
		<td>Y轴最小刻度</td>
	</tr>
	<tr>
		<td>ymax</td>
		<td>Y轴最大刻度</td>
	</tr>
</table>
<h1 class="titTwo"> 方法实现 </h1>
<c:point id="col4" width="600px" height="320px" items="${testList.list}" indicator="ser" dimension='AREA_NO' value="a"/>
</body>
</html>