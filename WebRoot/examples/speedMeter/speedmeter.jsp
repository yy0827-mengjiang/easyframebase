<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>仪表盘组件</title>
<c:resources type="highchart" />
<e:style value="resources/themes/base/boncBase@links.css"/>
<e:style value="resources/themes/blue/boncBlue.css"/>
<script type="text/javascript">
   		function getNewValue(){
   			var random=30+Math.floor(Math.random()*20);
   			return random;
   		}
</script>
</head>
<body>

<e:q4o var="cpu">
	select floor(dbms_random.value(0,100)) used,100 total from dual
</e:q4o>

<div class="exampleWarp">
	<h1 class="titOne">仪表盘<em>c:speedmeter</em></h1>
	<h1 class="titThree">参数</h1>
	<table class="parameters">
	<colgrounp>
		<col width="15%" />
		<col width="*" />
	</colgrounp>
		<tr>
			<td>id</td>
			<td>仪表盘组件id</td>
		</tr>
		<tr>
			<td>tooltip</td>
			<td>鼠标移入的提示信息及表盘上显示的信息</td>
		</tr>
		<tr>
			<td>unit</td>
			<td>刻度单位</td>
		</tr>
		<tr>
			<td>width</td>
			<td>组件宽度</td>
		</tr>
		<tr>
			<td>height</td>
			<td>组件高度</td>
		</tr>
		<tr>
			<td>title</td>
			<td>仪表盘标题</td>
		</tr>
		<tr>
			<td>min</td>
			<td>刻度最小值</td>
		</tr>
		<tr>
			<td>max</td>
			<td>刻度最大值</td>
		</tr>
		<tr>
			<td>value</td>
			<td>表针当前指向的刻度值,同步方式实现时必须设置该属性</td>
		</tr>
		<tr>
			<td>url</td>
			<td>数据来源路径，异步方式实现时必须设置该属性</td>
		</tr>
		<tr>
			<td>angle</td>
			<td>刻度开始和结束位置相对于垂直方向的偏移角度</td>
		</tr>
		<tr>
			<td>segment</td>
			<td>刻度分段值，以逗号隔开,不同的段可显示不同的颜色，配合colors属性使用</td>
		</tr>
		<tr>
			<td>colors</td>
			<td>刻度分段颜色值，以逗号隔开,不同的段可显示不同的颜色，配合segment属性使用</td>
		</tr>
		<tr>
			<td>fontColor</td>
			<td>仪表盘上刻度文字的颜色</td>
		</tr>
		<tr>
			<td>updateInterval</td>
			<td>数据更新频率，单位为毫秒,(如果同时设置了"url"属性和"updateFun"属性，则优先使用"updateFun"方法更新数据，如果未设置"updateFun"属性，则从"url"更新数据)</td>
		</tr>
		<tr>
			<td>updateFun</td>
			<td>用于数据更新的js方法，返回新的刻度值</td>
		</tr>
	</table>
	<p>备注：value属性和url属性都是非必须属性，但是两者必须最少设置一个，否则表盘无指针显示。</p>
	
	<h1 class="titTwo"> 属性设置示例 </h1>
	<table class="parameters">
	   <tr>
	      <td>表盘刻度显示角度：<font color="#DF5353">angle=100</font></td>
	      <td>表盘刻度分段显示：<font color="#DF5353">segment="0,30,60,85,100" colors="#01d6ff,#ff8500,#ffcf13,#86d438"</font></td>
	      <td>刻度不分段显示：<font color="#DF5353">不设置segment和colors</font></td>
	      <td>数据不刷新：<font color="#DF5353">不设置updateInterval和updateFun</font></td>
	   </tr>
	   <tr>
	      <td>
	           <c:speedmeter id="speedDiv3" width="300" height="300" min="0" max="${cpu.total}" value="${cpu.used}"
			    title="CPU使用情况" updateInterval="3000" segment="0,50,75,100" 
		    	tooltip="CPU使用率(%)" unit="%" angle="100" updateFun="getNewValue()" fontColor="#F00"></c:speedmeter>
		  </td>
		  <td>
	           <c:speedmeter id="speedDiv4" width="300" height="300" min="0" max="${cpu.total}" value="${cpu.used}"
			    title="CPU使用情况" updateInterval="3000" segment="0,30,60,85,100" colors="#01d6ff,#ff8500,#ffcf13,#86d438"
		    	tooltip="CPU使用率(%)" unit="%" angle="150" updateFun="getNewValue()"></c:speedmeter>
		  </td>
		  <td>
	           <c:speedmeter id="speedDiv5" width="300" height="300" min="0" max="${cpu.total}" value="${cpu.used}"
			    title="CPU使用情况" updateInterval="3000"
		    	tooltip="CPU使用率(%)" unit="%" angle="150" updateFun="getNewValue()"></c:speedmeter>
		  </td>
		  <td>
	           <c:speedmeter id="speedDiv6" width="300" height="300" min="0" max="${cpu.total}" value="${cpu.used}"
			    title="CPU使用情况" segment="0,50,75,100" 
		    	tooltip="CPU使用率(%)" unit="%" angle="150"></c:speedmeter>
		  </td>
	   </tr>
	</table>
	
	<h1 class="titTwo"> 异步数据集方法实现 </h1>
	<c:speedmeter id="speedDiv1" width="350" height="300" min="0" max="${cpu.total}" 
	        url="/examples/nchart_action.jsp?eaction=speedometer"
	        title="CPU使用情况" segment="0,50,75,100" colors="#55BF3B,#DDDF0D,#DF5353" 
	    	tooltip="CPU使用率(%)" unit="%" angle="120" 
	    	updateInterval="3000" >
	</c:speedmeter>
	
	<h1 class="titTwo"> 同步数据集方法实现 </h1>
	<c:speedmeter id="speedDiv2" width="350" height="300" min="0" max="${cpu.total}" value="${cpu.used}"
	    title="CPU使用情况" updateInterval="3000" segment="0,50,75,100" 
    	tooltip="CPU使用率(%)" unit="%" angle="150" updateFun="getNewValue()">
	</c:speedmeter>
	
</div>
</body>
</html>