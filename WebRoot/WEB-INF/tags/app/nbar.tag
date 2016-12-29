<%@ tag body-content="empty" dynamic-attributes="dynattrs" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<%@ attribute name="id" required="true" %>                                                  <e:description>条形id</e:description>
<%@ attribute name="url" required="false" %>                                              	<e:description>数据路径</e:description>
<%@ attribute name="items" required="false" rtexprvalue="true" type="java.lang.Object" %>   <e:description>数据集</e:description>
<%@ attribute name="yaxis" required="true" %>                                             	<e:description>条形y轴屬性</e:description>
<%@ attribute name="width" required="true" %>                                               <e:description>条形宽度</e:description>
<%@ attribute name="height" required="true" %>                                              <e:description>条形高度</e:description>
<%@ attribute name="dimension" required="true" %>                       					<e:description>维度列</e:description>
<%@ attribute name="title" required="false" %>                                              <e:description>条形标题</e:description>
<%@ attribute name="subtitle" required="false" %>                                           <e:description>条形子标题</e:description>
<%@ attribute name="backgroundColor" required="false" %>                                    <e:description>背景颜色</e:description>
<%@ attribute name="borderWidth" required="false" %>                                        <e:description>边框宽度</e:description>
<%@ attribute name="legendBorderWidth" required="false" %>                                  <e:description>图例边框宽度</e:description>
<%@ attribute name="crosshairs" required="false" %>                                         <e:description>是否显示准线</e:description>
<%@ attribute name="legend" required="false" %>                                             <e:description>是否显示图例</e:description>
<%@ attribute name="colors" required="false" %>											    <e:description>设置图表颜色</e:description>

<%@ attribute name="fontsize" required="false" %>											<e:description>设置字体大小</e:description>
<%@ attribute name="dataLabel" required="false" %>      									<e:description>是否显示数据标签true or false</e:description>
<%@ attribute name="rotation" required="false" %>      									    <e:description>横坐标倾斜角度</e:description>
<%@ attribute name="isper" required="false" %>      									    <e:description>是否为百分比</e:description>

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
		
	</e:if>
	<e:else condition="${ncolfontsizepx}">
		<e:set var="fontsize" value="${fontsize}px" />
	</e:else>
</e:if>
<e:else condition="${ncolfontsize}">
	<e:set var="fontsize" value="13" />
</e:else>
<e:if condition="${rotation!=null && rotation ne '' && rotation ne 'undefined'}" var="nrotation">
	<e:set var="rotationlen" value="${rotation}" />
</e:if>
<e:else condition="${nrotation}">
	<e:set var="rotationlen" value="0" />
</e:else>
<e:set var="units" clazz="java.util.ArrayList" />
<div id="${id}" style="width: ${width}; height: ${height}; margin: 0 auto"></div>
<script type="text/javascript">	
	var options_${id} = {
		chart: {
			renderTo: '${id}'
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
				rotation: ${rotationlen},
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
							color: '${easy_yaxis_map.color}',
							font: 'normal ${fontsize} Verdana, sans-serif'
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
                stackLabels: {
                    enabled: true,
                    style: {
                        color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
                    }
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
            plotOptions: {
                series: {
                    stacking: 'normal'
                }
            },
		tooltip: {
			<e:if condition="${crosshairs==true}">
				crosshairs: true,
			</e:if>
			<e:if condition="${isper eq 'true'}">
				pointFormat: '<span>{series.name}</span>: <b>{point.y}%</b>',
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
					type: 'bar',
					<e:if condition="${dataLabel == true}">
						dataLabels: {
		                   enabled: true,
		                   style: {
		                       textShadow: '0 0 3px white, 0 0 3px white'
		                   }
		               },
					</e:if>
					yAxis: ${easy_map.yaxis},
	                data: [],
	                tooltip: {
	                    valueSuffix: ' ${units[easy_map.yaxis]}'
	                }
	            };
				$.each(data, function(index, item){
					<e:if condition="${index==0}">
						options_${id}.xAxis.categories.push(item.${dimension});
					</e:if>
					series_${index}.data.push(item.${item.key});
	            });
            	options_${id}.series.push(series_${index});
        	</e:forEach>
        	var chart_${id} = new Highcharts.Chart(options_${id});
	}
	$(function(){
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