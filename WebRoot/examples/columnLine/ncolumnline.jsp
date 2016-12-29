<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>My JSP 'index.jsp' starting page</title>
		<c:resources type="highchart" />
		<script>
   		function dataPointClick(){
   			alert('柱线图点击事件');
   		}
   	</script>
   	<e:style value="resources/themes/base/boncBase@links.css"/>
	<e:style value="resources/themes/blue/boncBlue.css"/>
	</head>
	<body>
		<e:q4l var="testList">
  	select AREA_NO,
	       sum(VALUE1) a,
	       sum(VALUE2) b,
	       sum(VALUE1+VALUE2) c,
	       sum(VALUE1*2) d
	  from (
	 	SELECT '431' AREA_NO,'长春' AREA_DESC,111 VALUE1, 334 VALUE2 FROM DUAL
		UNION ALL
		SELECT '432' AREA_NO,'吉林' AREA_DESC,121 VALUE1, 327 VALUE2 FROM DUAL
		UNION ALL
		SELECT '437' AREA_NO,'辽源' AREA_DESC,331 VALUE1, 533 VALUE2 FROM DUAL
	  
	  )
	 group by AREA_NO
	 order by AREA_NO
  </e:q4l>
		<div class="exampleWarp">
			<h1 class="titOne">柱线组合图<em>c:ncolumnline</em></h1>
			<h3 class="titThree">参数</h3>
			<table class="parameters">
			<colgrounp>
			<col width="15%" />
			<col width="*" />
			</colgrounp>
				<tr>
					<td>id</td>
					<td>id</td>
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
					<td>stacking</td>
					<td>是否堆叠显示</td>
				</tr>
				<tr>
					<td>columnDataPointClick</td>
					<td>点击柱图某块执行js方法，参数e</td>
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
					<td>show3D</td>
					<td>是否显示3D效果</td>
				</tr>
				<tr>
					<td>beta</td>
					<td>3D效果展现横向度数默认为0</td>
				</tr>
				<tr>
					<td>alpha</td>
					<td>3D效果展现纵向仰角度数默认为10</td>
				</tr>
			</table>
			<h1 class="titTwo">异步数据集方法实现</h1>
			<c:ncolumnline id="COLUMNLINE1" width="600px" height="400"
				yaxis="title:一轴,unit:单位;title:二轴,unit:单位,color:#AA4643"
				A="name:指标1,type:column" B="name:指标二,yaxis:1,type:spline"
				C="name:指标三,yaxis:1,type:spline" dimension="AREA_NO"
				url="/examples/nchart_action.jsp?eaction=ncolumn" title="柱线组合图"
				columnDataPointClick="dataPointClick"
				colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']" />
			<h1 class="titTwo">同步数据集方法实现</h1>
			<c:ncolumnline id="COLUMNLINE2" width="600px" height="400"
				yaxis="title:一轴,unit:单位;title:二轴,unit:单位,color:#AA4643"
				A="name:指标1,type:column" B="name:指标二,yaxis:1,type:spline"
				C="name:指标三,yaxis:1,type:spline" dimension="AREA_NO"
				items="${testList.list}" title="柱线组合图"
				colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']" />
			
		</div>
	</body>
</html>
