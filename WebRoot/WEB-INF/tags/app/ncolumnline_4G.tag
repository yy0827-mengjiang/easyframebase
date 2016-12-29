<%@ tag body-content="empty" dynamic-attributes="dynattrs" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<%@ attribute name="id" required="true" %>                                                  <e:description>线图id</e:description>
<%@ attribute name="url" required="false" %>                                              	<e:description>数据路径</e:description>
<%@ attribute name="items" required="false" rtexprvalue="true" type="java.lang.Object" %>   <e:description>数据集</e:description>
<%@ attribute name="yaxis" required="true" %>                                             	<e:description>线图y轴屬性</e:description>
<%@ attribute name="width" required="true" %>                                               <e:description>线图宽度</e:description>
<%@ attribute name="height" required="true" %>                                              <e:description>线图高度</e:description>
<%@ attribute name="dimension" required="true" %>                       					<e:description>维度列</e:description>
<%@ attribute name="title" required="false" %>                                              <e:description>线图标题</e:description>
<%@ attribute name="subtitle" required="false" %>                                           <e:description>线图子标题</e:description>
<%@ attribute name="backgroundColor" required="false" %>                                    <e:description>背景颜色</e:description>
<%@ attribute name="borderWidth" required="false" %>                                        <e:description>边框宽度</e:description>
<%@ attribute name="legendBorderWidth" required="false" %>                                  <e:description>图例边框宽度</e:description>
<%@ attribute name="crosshairs" required="false" %>                                         <e:description>是否显示准线</e:description>
<%@ attribute name="legend" required="false" %>                                             <e:description>是否显示图例</e:description>
<%@ attribute name="stacking" required="false" %>                                           <e:description>是否堆叠显示</e:description>
<%@ attribute name="columnDataPointClick" required="false" %>                               <e:description>点击柱图某块执行js方法，参数e</e:description>
<%@ attribute name="colors" required="false" %>											    <e:description>设置图表颜色</e:description>

<%@ attribute name="fontsize" required="false" %>											<e:description>设置字体大小</e:description>

<%@ attribute name="show3D" required="false" %>											    <e:description>是否显示3D效果</e:description>
<%@ attribute name="alpha" required="false" %>      									    <e:description>3D效果展现纵向仰角度数默认为10</e:description>
<%@ attribute name="beta" required="false" %>      									        <e:description>3D效果展现横向度数默认为0</e:description>

<%
String tmpuuid = java.util.UUID.randomUUID().toString().replaceAll("-", "");
%>
<e:set var="TmpUUID" value="<%=tmpuuid%>" />
<e:if condition="${colors==null || colors==''}">
	<e:set var="colors">Highcharts.getOptions().colors</e:set>
</e:if> 
<e:if condition="${(legendBorderWidth==null) || (legendBorderWidth=='')}">
	<e:set var="legendBorderWidth" value="0" />
</e:if>

<e:if condition="${width!=null && width ne '' && width ne 'undefined'}" var="ncolwidth">
	<e:if condition="${e:containsIgnoreCase(e:substring(width,e:length(width)-2,e:length(width)), 'px') }" var="ncolwidthpx">
		<e:set var="width" value="${width}" />
	</e:if>
	<e:else condition="${ncolwidthpx}">
		<e:set var="width" value="${width}px" />
	</e:else>
</e:if>
<e:else condition="${ncolwidth}">
	<e:set var="width" value="auto" />
</e:else>
<e:if condition="${height!=null && height ne '' && height ne 'undefined'}" var="ncolheight">
	<e:if condition="${e:containsIgnoreCase(e:substring(height,e:length(height)-2,e:length(height)), 'px') }" var="ncolheightpx">
		<e:set var="height" value="${height}" />
	</e:if>
	<e:else condition="${ncolheightpx}">
		<e:set var="height" value="${height}px" />
	</e:else>
</e:if>
<e:else condition="${ncolheight}">
	<e:set var="height" value="auto" />
</e:else>

<e:if condition="${fontsize!=null && fontsize ne '' && fontsize ne 'undefined'}" var="ncolfontsize">
	<e:if condition="${e:containsIgnoreCase(e:substring(fontsize,e:length(fontsize)-2,e:length(fontsize)), 'px') }" var="ncolfontsizepx">
		<e:set var="fontsize" value="${fontsize}" />
	</e:if>
	<e:else condition="${ncolfontsizepx}">
		<e:set var="fontsize" value="${fontsize}px" />
	</e:else>
</e:if>
<e:else condition="${ncolfontsize}">
	<e:set var="fontsize" value="13" />
</e:else>
<e:if condition="${alpha==null || alpha==''}">
	<e:set var="alpha">10</e:set>
</e:if> 
<e:if condition="${beta==null || beta==''}">
	<e:set var="beta">0</e:set>
</e:if> 
<e:set var="units" clazz="java.util.ArrayList" />
<div id="${id}" style="width: ${width}; height: ${height}; margin: 0 auto"></div>
<script type="text/javascript">	
	var options_${id}_${TmpUUID} = {
		chart: {
			renderTo: '${id}'
			<e:if condition="${show3D==true}">
				,options3d: {
	               enabled: true,
	               alpha: ${alpha},
	               beta: ${beta},
	               depth: 50,
	               viewDistance: 25
	           }
			</e:if>
		},
		title: {
			text: '${title}',
			x: -20 //center
		},
		subtitle: {
			text: '${subtitle}',
			x: -20
		},
		colors:${colors},
		xAxis: {
			categories: [],
			labels: {
				rotation: 0,
				align: 'right',
				style: {
					 font: 'normal ${fontsize} Verdana, sans-serif'
				}
			}
		},
		yAxis: [
			<e:forEach items="${e:split(yaxis,';')}" var="item">
				<e:set var="easy_yaxis_map" value="${e:str2map(item,':',',')}" />
				<e:invoke object="${units}" method="add">
					<e:param value="${easy_yaxis_map.unit}" />
				</e:invoke>
				<e:if condition="${index>0}">
					,
				</e:if>
				{labels: {
					formatter: function() {
						return this.value +'${easy_yaxis_map.unit}';
					}
					<e:if condition="${easy_yaxis_map.color!=null}">
						,style: {
							color: '${easy_yaxis_map.color}'
						}
					</e:if>
				},
				title: {
					text: '${easy_yaxis_map.title}'
					<e:if condition="${easy_yaxis_map.color!=null}">
						,style: {
							color: '${easy_yaxis_map.color}',
							font: 'normal ${fontsize} Verdana, sans-serif'
						}
					</e:if>
				},
				<e:if condition="${easy_yaxis_map.min!=null}">
					min: ${easy_yaxis_map.min},
				</e:if>
				<e:if condition="${index==0}">
					opposite: false
				</e:if>
				<e:if condition="${index>0}">
					opposite: true
				</e:if>
				}
			</e:forEach>
			],
		tooltip: {
			<e:if condition="${crosshairs==true}">
				crosshairs: true,
			</e:if>
			shared: true
		},
		legend: {
			<e:if condition="${legend==false}">
				enabled: false,
			</e:if>
			align: 'center',
			verticalAlign: 'bottom',
			borderWidth: ${legendBorderWidth}
		},
		plotOptions: {
			series:{
				events: {
					<e:if condition="${columnDataPointClick!=null && columnDataPointClick ne ''}" >
						click: ${columnDataPointClick}
					</e:if>
				}
				<e:if condition="${stacking==true}">
					,stacking: 'normal'
				</e:if>
			}
		},
	    series: []
	};
	
	function getChartOptionInfo${id}_${TmpUUID}(data){
		<e:forEach items="${dynattrs}" var="item">
				<e:set var="easy_map" value="${e:str2map(item.value,':',',')}" />
				var series_${index} = {
					name: '${easy_map.name}',
					<e:if condition="${easy_map.color!=null}">
						color: '${easy_map.color}',
					</e:if>
					<e:if condition="${easy_map.yaxis==null}">
						<e:invoke object="${easy_map}" method="put">
							<e:param value="yaxis" />
							<e:param value="0" />
						</e:invoke>
					</e:if>
					<e:if condition="${easy_map.type!=null && easy_map.type ne ''}" var="charttypecondition">
						type: '${easy_map.type}',
					</e:if>
					<e:else condition="${charttypecondition}">
						<e:if condition="${easy_map.yaxis==0}">
							type: 'column',
						</e:if>
						<e:if condition="${easy_map.yaxis>0}">
							type: 'spline',
						</e:if>
					</e:else>
					<e:if condition="${easy_map.dataLabel == true}">
						dataLabels: {
		                   enabled: true,
		                   style: {
		                       textShadow: '0 0 3px white, 0 0 3px white'
		                   }
		               },
					</e:if>
					<e:if condition="${show3D==true}" var="else3d">
						yAxis: 0,
					</e:if>
					<e:else condition="${else3d}">
						yAxis: ${easy_map.yaxis},
					</e:else>
	                data: [],
	                <e:if condition="${!empty easy_map.visible && easy_map.visible ne ''}">
						visible: false,
					</e:if>
	                tooltip: {
	                    valueSuffix: ' ${units[easy_map.yaxis]}'
	                }
	            };
				$.each(data, function(index, item){
					<e:if condition="${index==0}">
						options_${id}_${TmpUUID}.xAxis.categories.push(item.${dimension});
					</e:if>
					series_${index}.data.push(item.${item.key});
	            });
            	options_${id}_${TmpUUID}.series.push(series_${index});
        	</e:forEach>
        	//var chart_${id} = new Highcharts.Chart(options_${id}_${TmpUUID});
        	new Highcharts.Chart(options_${id}_${TmpUUID});
	}
	$(function(){
		Highcharts.theme = {
		   colors: ['#058DC7', '#50B432', '#ED561B', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#FFF263', '#6AF9C4'],
		   chart: {
		      borderWidth: 0,
		      plotShadow: true,
		      plotBorderWidth: 0
		   }
		};
		<e:if condition="${(url ==null || url eq '') && (items !=null && items ne '')}" var="ncolIf">
			var data = jQuery.parseJSON('${e:java2json(items)}');
			getChartOptionInfo${id}_${TmpUUID}(data);
		</e:if>
		<e:else condition="${ncolIf}">
			$.getJSON((window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+('${url}'.indexOf("/")==0?'${url}':'/${url}'), {echart: "ncolumn"}, function(data) {
				getChartOptionInfo${id}_${TmpUUID}(data);
	        });
		</e:else>
	});
</script>

