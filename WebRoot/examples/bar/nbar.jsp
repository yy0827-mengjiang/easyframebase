<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>My JSP 'index.jsp' starting page</title>
<c:resources type="highchart" />
<e:style value="resources/themes/base/boncBase@links.css"/>
<e:style value="resources/themes/blue/boncBlue.css"/>
</head>
<body>
<e:q4l var="testList"> select AREA_NO,
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
	order by AREA_NO </e:q4l>
<div class="exampleWarp">
	<h1 class="titOne">条形图<em>c:nbar</em></h1>
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
			<td>url</td>
			<td>数据路径</td>
		</tr>
		<tr>
			<td>items</td>
			<td>数据集</td>
		</tr>
		<tr>
			<td>yaxis</td>
			<td>线图y轴屬性</td>
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
			<td>dimension</td>
			<td>维度列</td>
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
			<td>fontsize</td>
			<td>设置字体大小</td>
		</tr>
		<tr>
			<td>dataLabel</td>
			<td>是否显示数据标签true or false</td>
		</tr>
		<tr>
			<td>colors</td>
			<td>设置颜色</td>
		</tr>
		<tr>
			<td>rotation</td>
			<td>横坐标倾斜角度</td>
		</tr>
	</table>
	<h1 class="titTwo"> 异步数据集方法实现 </h1>
	<c:nbar id='bar1' width='600' height='300' A="name:指标一,type:spline"
				B="name:指标二,yaxis:0,type:column" C="name:指标三,type:column"
				D="name:指标四,yaxis:0" dimension="AREA_NO"
				url='/examples/nchart_action.jsp?eaction=ncolumn'
				yaxis='title:一轴,unit:元,min:0'
				colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']" />
	<h1 class="titTwo"> 同步数据集方法实现 </h1>
	<c:nbar id='bar2' width='600' height='300' A="name:指标一,type:spline"
				B="name:指标二,yaxis:0,type:column" C="name:指标三,type:column"
				D="name:指标四,yaxis:0" dimension="AREA_NO" items="${testList.list}"
				yaxis='title:一轴,unit:元,min:0' 
				colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']" />
	<h1 class="titOne"> 原始条形图标签<em>c:bar</em> </h1>
	<h1 class="titThree"> 参数 </h1>
	<table class="parameters">
	<colgrounp>
		<col width="15%" />
		<col width="*" />
	</colgrounp>
		<tr>
			<td>id</td>
			<td>条形图id</td>
		</tr>
		<tr>
			<td>width</td>
			<td>条形图宽度</td>
		</tr>
		<tr>
			<td>height</td>
			<td>条形图高度</td>
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
			<td>title</td>
			<td>条形图标题</td>
		</tr>
		<tr>
			<td>subtitle</td>
			<td>条形图子标题</td>
		</tr>
		<tr>
			<td>ytitle</td>
			<td>条形图y轴标题</td>
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
			<td>legend</td>
			<td>是否显示图例</td>
		</tr>
		<tr>
			<td>stacking</td>
			<td>是否堆叠显示</td>
		</tr>
	</table>
	<h1 class="titTwo"> 方法实现 </h1>
	<c:bar legend="true" dimension="AREA_NO" height="320px" id="col2" items="${testList.list}" indicator="ser" value="a" width="600px" unit="" title="排名分析" />
</div>
</body>
</html>