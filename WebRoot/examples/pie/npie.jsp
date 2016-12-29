<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
   	<head>
   	<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
   	<title></title>
   	<meta http-equiv="pragma" content="no-cache"/>
   	<meta http-equiv="cache-control" content="no-cache"/>
   	<meta http-equiv="expires" content="0"/>
   	<c:resources type="easyui,highchart" style="b"/>
   	<script type="text/javascript">
   		function dataPointClick(){
   			alert('饼图点击事件');
   		}
   	</script>
   	</head>
	<e:style value="resources/themes/base/boncBase@links.css"/>
	<e:style value="resources/themes/blue/boncBlue.css"/>
   	<body>
<e:q4l var="piedata"> select AREA_NO,
		sum(VALUE1) A,
		sum(VALUE2) B,
		sum(VALUE1+VALUE2) C,
		sum(VALUE1*2) D
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
<h1 class="titOne"> 饼图 </h1>
<h1 class="titThree"> 参数 </h1>
<table class="parameters">
	<colgroup>
		<col width="15%" />
		<col width="*" />
	</colgroup>
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
		<td>饼图y轴屬性</td>
	</tr>
	<tr>
		<td>width</td>
		<td>饼图宽度</td>
	</tr>
	<tr>
		<td>height</td>
		<td>饼图高度</td>
	</tr>
	<tr>
		<td>dimension</td>
		<td>维度列</td>
	</tr>
	<tr>
		<td>title</td>
		<td>饼图标题</td>
	</tr>
	<tr>
		<td>subtitle</td>
		<td>饼图子标题</td>
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
		<td>dataLabels</td>
		<td>是否显示数据信息</td>
	</tr>
	<tr>
		<td>distance</td>
		<td>设置datalabel与饼图的距离，负数表示在饼图上显示</td>
	</tr>
	<tr>
		<td>tipfmt</td>
		<td>提示时，小数点格式化位数，默认格式化2位</td>
	</tr>
	<tr>
		<td>dataPointClick</td>
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
		<td>legendAlign</td>
		<td>图例对齐方式left,right</td>
	</tr>
	<tr>
		<td>legendLayout</td>
		<td>图例布局,vertical,horizontal</td>
	</tr>
	<tr>
		<td>legendBorderWidth</td>
		<td>图例边框宽度</td>
	</tr>
	<tr>
		<td>legendVerticalAlign</td>
		<td>图例垂直对齐方式,top,bottom,middle</td>
	</tr>
	</table>
<h1 class="titTwo">异步数据集方法实现</h1>
<c:npie id="pie1" width="600" height="300" title="" unit="个" A="发展用户" dimension="AREA_NO" dataPointClick="dataPointClick" items="${piedata.list}" />
<h1 class="titTwo">同步数据集方法实现</h1>
<c:npie id="pie2" width="600" height="300" title="" unit="元" A="收入" dimension="AREA_NO" dataPointClick="dataPointClick" colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']" url="/examples/nchart_action.jsp?eaction=npie"/>
</table>
</body>
</html>
