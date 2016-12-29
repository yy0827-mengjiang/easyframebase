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
   			alert('线图点击事件');
   		}
   	</script>
	<e:style value="resources/themes/base/boncBase@links.css"/>
	<e:style value="resources/themes/blue/boncBlue.css"/>
   	</head>
   	<body>
<e:q4l var="testList"> select AREA_NO,
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
		order by AREA_NO </e:q4l>
<div class="exampleWarp">
	<h1 class="titOne"> 线图 </h1>
	<h1 class="titThree"> 参数 </h1>
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
			<td>dataPointClick</td>
			<td>点击柱图某块执行js方法，参数e</td>
		</tr>
		<tr>
			<td>fontsize</td>
			<td>设置字体大小</td>
		</tr>
		<tr>
			<td>colors</td>
			<td>设置颜色</td>
		</tr>
		</table>
	<h1 class="titTwo"> 异步数据集方法实现 </h1>
	<c:nline id="line1" width="600" height="300" dimension="AREA_NO"
			yaxis="title:一轴,unit:元,min:0;title:二轴,unit:戶;title:三轴,unit:万"
			A="name:指标一" B="name:指标二,yaxis:1" C="name:指标三" D="name:指标四,yaxis:2" 
			title="线形图" dataPointClick="dataPointClick" colors="['#e7ebe9','#a7d2e7','#74bfdf','#15b0db','#0097c7','#0073b6','#005a8d','#00acdb','#adc9d2','#bbd3da']" url="/examples/nchart_action.jsp?eaction=ncolumn" />
	<h1 class="titTwo"> 同步数据集方法实现 </h1>
	<c:nline id="line2" width="600" height="300" dimension="AREA_NO"
			yaxis="title:一轴,unit:元,min:0;title:二轴,unit:戶;title:三轴,unit:万"
			A="name:指标一" B="name:指标二,yaxis:1" C="name:指标三" D="name:指标四,yaxis:2" 
			title="线形图" dataPointClick="dataPointClick" colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']" items="${testList.list}" />
</div>
</body>
</html>
