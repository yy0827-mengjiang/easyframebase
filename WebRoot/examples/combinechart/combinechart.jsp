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
	       sum((VALUE1+VALUE2)) c,
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
  <h1 class="titOne">多图表组合图(柱图、线图、饼图、堆积柱图任意组合)<em>c:combinechart</em></h1>
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
					<td>pieUrl</td>
					<td>饼图数据路径</td>
				</tr>
				<tr>
					<td>pieItems</td>
					<td>饼图数据集</td>
				</tr>
				<tr>
					<td>pieDim</td>
					<td>饼图维度</td>
				</tr>
				<tr>
					<td>pieKpi</td>
					<td>饼图指标列名</td>
				</tr>
				<tr>
					<td>pieCenter</td>
					<td>饼图xy坐标,格式:x,y</td>
				</tr>
				<tr>
					<td>pieKpiDesc</td>
					<td>饼图指标名称描述</td>
				</tr>
				<tr>
					<td>pieSize</td>
					<td>饼图大小</td>
				</tr>
				
			</table>
			
         <h1 class="titTwo">柱、线、饼图组合</h1>
			<c:combinechart id="COLUMNLINE1" width="600px" height="400"
				yaxis="title:一轴,unit:单位1,color:#CB4443;title:二轴,unit:单位2,color:#86d438"
				A="name:指标一,type:column,color:#01d6ff" 
				B="name:指标二,type:column,color:#ff8500"
				C="name:指标三,type:spline,color:#ffcf13" 
				D="name:指标四,type:spline,yaxis:1,color:#86d438" 
				dimension="AREA_NO" 
				items="${testList.list}"
				pieItems="${testList.list}"
				pieDim="AREA_NO" pieKpi="A" stacking="false" 
				title="柱、线、饼图组合" dataLabel="false" pieCenter="100,20" pieKpiDesc="总值"
				columnDataPointClick="dataPointClick"
				colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']" />  
			
			
				
			<h1 class="titTwo">柱图、线图组合</h1>	
			<c:combinechart id="COLUMNLINE2" width="600px" height="400"
				yaxis="title:一轴,unit:单位1,color:#CB4443;title:二轴,unit:单位2,color:#86d438"
				A="name:指标一,type:column,color:#01d6ff" 
				B="name:指标二,type:column,color:#ff8500"
				C="name:指标三,type:spline,yaxis:1,color:#ffcf13" 
				D="name:指标四,type:spline,yaxis:1,color:#86d438" 
				dimension="AREA_NO" 
				items="${testList.list}"
				title="柱图、线图组合"
				columnDataPointClick="dataPointClick"
				colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']" />
				
				
				
				
		  <h1 class="titTwo">线图、饼图组合</h1>	
			<c:combinechart id="COLUMNLINE3" width="600px" height="400"
				yaxis="title:一轴,unit:单位1,color:#CB4443;title:二轴,unit:单位2,color:#86d438"
				A="name:指标一,type:spline,color:#01d6ff" 
				B="name:指标二,type:spline,color:#ff8500"
				dimension="AREA_NO" 
				items="${testList.list}"
				pieItems="${testList.list}"
				pieDim="AREA_NO" pieKpi="A" stacking="false" 
				title="线图、饼图组合" dataLabel="false" pieCenter="100,20" pieKpiDesc="总值"
				columnDataPointClick="dataPointClick"
				colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']" />	
				
			<h1 class="titTwo">柱图、饼图组合</h1>	
			<c:combinechart id="COLUMNLINE4" width="600px" height="400"
				yaxis="title:一轴,unit:单位1,color:#CB4443;title:二轴,unit:单位2,color:#86d438"
				A="name:指标一,type:column,color:#CB4443" 
				B="name:指标二,type:column,color:#86d438,yaxis:1"
				dimension="AREA_NO" 
				items="${testList.list}"
				pieItems="${testList.list}"
				pieDim="AREA_NO" pieKpi="A" stacking="false" 
				title="柱图、饼图组合" dataLabel="true" pieCenter="70,40" pieKpiDesc="总值"
				columnDataPointClick="dataPointClick"
				colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']" />		
				
				
			<h1 class="titTwo">堆积柱图、饼图、线图组合</h1>	
			<c:combinechart id="COLUMNLINE5" width="600px" height="400"
				yaxis="title:一轴,unit:单位1,color:#CB4443;title:二轴,unit:单位2,color:#86d438"
				A="name:指标一,type:column,yaxis:0,color:#01d6ff" 
				B="name:指标二,type:column,yaxis:0,color:#ff8500"
				C="name:指标三,type:column,yaxis:0,color:#ffcf13" 
				D="name:指标四,type:spline,yaxis:1,color:#86d438" 
				dimension="AREA_NO" 
				items="${testList.list}"
				pieItems="${testList.list}"
				pieDim="AREA_NO" pieKpi="A" stacking="true" 
				title="堆积柱图、饼图、线图组合" dataLabel="false" pieCenter="100,20" pieKpiDesc="总值"
				columnDataPointClick="dataPointClick"
				colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']" />
				
			
			
			
			<h1 class="titTwo">同步数据集方法实现</h1>
			<c:combinechart id="COLUMNLINE6" width="600px" height="400"
				yaxis="title:一轴,unit:单位1,color:#CB4443;title:二轴,unit:单位2,color:#86d438"
				A="name:指标一,type:column,color:#01d6ff" 
				B="name:指标二,type:column,color:#ff8500"
				C="name:指标三,type:column,color:#ffcf13" 
				D="name:指标四,type:spline,yaxis:1,color:#86d438" 
				dimension="AREA_NO" 
				items="${testList.list}"
				pieItems="${testList.list}"
				pieDim="AREA_NO" pieKpi="A" stacking="false" 
				title="同步数据集方法实现多图组合图" dataLabel="false" pieCenter="100,20" pieKpiDesc="总值"
				columnDataPointClick="dataPointClick"
				colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']" />
			
			
			
			
			<h1 class="titTwo">异步数据集方法实现</h1>
			<c:combinechart id="COLUMNLINE7" width="600px" height="400"
				yaxis="title:一轴,unit:单位1,color:#CB4443;title:二轴,unit:单位2,color:#86d438"
				A="name:指标一,type:column,color:#01d6ff" 
				B="name:指标二,type:column,color:#ff8500"
				C="name:指标三,type:column,color:#ffcf13" 
				D="name:指标四,type:spline,yaxis:1,color:#86d438" 
				dimension="AREA_NO" 
				url="/examples/nchart_action.jsp?eaction=ncolumn" 
				pieUrl="/examples/nchart_action.jsp?eaction=npie"
				pieDim="AREA_NO" pieKpi="A" stacking="false" 
				title="异步数据集方法实现多图组合图" dataLabel="false" pieCenter="100,20" pieKpiDesc="总值"
				columnDataPointClick="dataPointClick"
				colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']" />  
	</div>
	</body>
</html>
