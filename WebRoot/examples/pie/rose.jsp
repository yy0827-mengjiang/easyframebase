<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:q4l var="piedata"> 
	select AREA_NO,
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
	order by AREA_NO 
</e:q4l>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
	<meta http-equiv="pragma" content="no-cache"/>
	<meta http-equiv="cache-control" content="no-cache"/>
	<meta http-equiv="expires" content="0"/>
	<title></title>
	<c:resources type="easyui" style="b"/>
	<e:script value="/pages/4greport_sd/js/echarts-all.js"/>
	<e:style value="/resources/themes/common/css/examples.css"/>
</head>
<body>
	<div class="exampleWarp">
	<h1 class="titOne">南丁格尔玫瑰图</h1>
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
			<td>width</td>
			<td>宽度</td>
		</tr>
		<tr>
			<td>height</td>
			<td>高度</td>
		</tr>
		<tr>
			<td>items</td>
			<td>数据集</td>
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
			<td>divStyle</td>
			<td>容器div样式,不包括width和height属性</td>
		</tr>
		
		<tr>
			<td>centerX</td>
			<td>圆心横坐标,支持绝对值（px）和百分比,默认为"50%",百分比计算min(width, height) * 50%. </td>
		</tr>
		<tr>
			<td>centerY</td>
			<td>圆心纵坐标,支持绝对值（px）和百分比,默认为"50%",百分比计算min(width, height) * 50%.</td>
		</tr>
		<tr>
			<td>radiusInner</td>
			<td>内半径，支持绝对值（px）和百分比，,默认为"10%",百分比计算比，min(width, height) / 2 * 10%</td>
		</tr>
		<tr>
			<td>radiusOuter</td>
			<td>外半径，支持绝对值（px）和百分比，,默认为"75%",百分比计算比，min(width, height) / 2 * 75%</td>
		</tr>
		<tr>
			<td>title</td>
			<td>标题</td>
		</tr>
		<tr>
			<td>titleStyle</td>
			<td>标题样式(注意:各属性间以","分隔),可设置的属性有:(1){color} color 颜色 (2){string} decoration 修饰，仅对tooltip.textStyle生效 (3){string} align 水平对齐方式，可选为：'left' | 'right' | 'center' (4){string} baseline 垂直对齐方式，可选为：'top' | 'bottom' | 'middle' (5){string} fontFamily  字体系列 (6){number} fontSize  字号 ，单位px (7){string} fontStyle 样式，可选为：'normal' | 'italic' | 'oblique' (8){string | number} fontWeight 粗细，可选为：'normal' | 'bold' | 'bolder' | 'lighter' | 100 | 200 |... | 900 </td>
		</tr>
		<tr>
			<td>tooltip</td>
			<td>是否显示提示框(true/false),默认为显示(true)</td>
		</tr>
		<tr>
			<td>unit</td>
			<td>显示单位,是否显示提示框(tooltip)为true时才有效</td>
		</tr>
		<tr>
			<td>labelPosition</td>
			<td>标签显示位置(outer/inner),默认为外部(outer)</td>
		</tr>
		<tr>
			<td>labelStyle</td>
			<td>文本样式(注意:各属性间以","分隔),可设置的属性有:(1){color} color 颜色 (2){string} decoration 修饰，仅对tooltip.textStyle生效 (3){string} align 水平对齐方式，可选为：'left' | 'right' | 'center' (4){string} baseline 垂直对齐方式，可选为：'top' | 'bottom' | 'middle' (5){string} fontFamily  字体系列 (6){number} fontSize  字号 ，单位px (7){string} fontStyle 样式，可选为：'normal' | 'italic' | 'oblique' (8){string | number} fontWeight 粗细，可选为：'normal' | 'bold' | 'bolder' | 'lighter' | 100 | 200 |... | 900</td>
		</tr>
		<tr>
			<td>legend</td>
			<td>是否显示图例(true/false),默认为显示(true)</td>
		</tr>
		<tr>
			<td>legendOrient</td>
			<td>布局方式(horizontal/vertical),默认为水平布局(horizontal)</td>
		</tr>
		<tr>
			<td>legendX</td>
			<td>水平安放位置，默认为居中(center)，可选为：'center' | 'left' | 'right' | {number}（x坐标，单位px）</td>
		</tr>
		<tr>
			<td>legendY</td>
			<td>垂直安放位置，默认为底部(bottom)，可选为：'top' | 'bottom' | 'center' | {number}（y坐标，单位px）</td>
		</tr>
	</table>
	<h1 class="titTwo">基础</h1>
	<a:rose id="pieChart10" items="${piedata.list}" width="100%" height="328px" dimension="AREA_NO" value="A"/>
	<h1 class="titTwo">全部属性</h1>
	<a:rose id="pieChart20" items="${piedata.list}" width="80%" height="328px" dimension="AREA_NO" value="A"
	divStyle="margin-left:100px" centerX="50%" centerY="50%"
	radiusInner="10%" radiusOuter="60%" title="南丁格尔玫瑰图" 
	titleStyle="color:'red',align:'center'" tooltip="true" unit="元"
	labelPosition="inner" labelStyle="color:'#ff0000',align:'center'"
	legend="true" legendOrient="vertical" legendX="left" legendY="center"
	legendPadding="5,5,5,200"
	
	/>
</body>
</html>
