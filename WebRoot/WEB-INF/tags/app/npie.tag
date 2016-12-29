<%@ tag body-content="empty" dynamic-attributes="dynattrs" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<%@ attribute name="id" required="true" %>                                                  <e:description>饼图id</e:description>
<%@ attribute name="url" required="false" %>                                              	<e:description>数据路径</e:description>
<%@ attribute name="items" required="false" rtexprvalue="true" type="java.lang.Object"%>     <e:description>数据</e:description>
<%@ attribute name="width" required="true" %>                                               <e:description>饼图宽度</e:description>
<%@ attribute name="height" required="true" %>                                              <e:description>饼图高度</e:description>
<%@ attribute name="dimension" required="true" %>                                           <e:description>维度列</e:description>
<%@ attribute name="title" required="false" %>                                              <e:description>饼图标题</e:description>
<%@ attribute name="unit" required="false" %>                                               <e:description>显示单位</e:description>
<%@ attribute name="backgroundColor" required="false" %>                                    <e:description>背景颜色</e:description>
<%@ attribute name="borderWidth" required="false" %>                                        <e:description>边框宽度</e:description>
<%@ attribute name="dataLabels" required="false" %>                                         <e:description>是否显示数据信息</e:description>
<%@ attribute name="legend" required="false" %>                                             <e:description>是否显示图例</e:description>
<%@ attribute name="datalablecolor" required="false" %>                                   	<e:description>数据文字颜色</e:description>
<%@ attribute name="percentage" required="false" %>                                         <e:description>是否显示百分比</e:description>
<%@ attribute name="tipfmt" required="false" %>                                   	        <e:description>提示时，小数点格式化位数，默认不格式化</e:description>
<%@ attribute name="dataPointClick" required="false" %>                                     <e:description>点击饼图某块执行js方法，参数e</e:description>
<%@ attribute name="distance" required="false" %>                                   		<e:description>label距离饼图距离，负数表示在饼图上显示</e:description>
<%@ attribute name="fontsize" required="false" %>											<e:description>设置字体大小</e:description>
<%@ attribute name="colors" required="false" %>											    <e:description>设置图表颜色</e:description>

<%@ attribute name="show3D" required="false" %>											    <e:description>是否显示3D效果</e:description>
<%@ attribute name="alpha" required="false" %>      									    <e:description>3D效果展现纵向仰角度数默认为10</e:description>
<%@ attribute name="beta" required="false" %>      									        <e:description>3D效果展现横向度数默认为0</e:description>

<%@ attribute name="legendAlign" required="false" %>      									<e:description>图例对齐方式left,right</e:description>
<%@ attribute name="legendLayout" required="false" %>      									<e:description>图例布局,vertical,horizontal</e:description>
<%@ attribute name="legendBorderWidth" required="false" %>      							<e:description>图例边框宽度</e:description>
<%@ attribute name="legendVerticalAlign" required="false" %>      							<e:description>图例垂直对齐方式,top,bottom,middle</e:description>

<e:if condition="${percentage==null||percentage==''}">
	<e:set var="percentage" value="true"></e:set>
</e:if>
<e:if condition="${tipfmt ==null && tipfmt == ''}">
	<e:set var="tipfmt" value="2"></e:set>
</e:if>
<e:if condition="${colors==null || colors==''}">
	<e:set var="colors">Highcharts.getOptions().colors</e:set>
</e:if>
<e:if condition="${alpha==null || alpha==''}">
	<e:set var="alpha" value="30"></e:set>
</e:if>
<e:if condition="${beta==null || beta==''}">
	<e:set var="beta" value="0"></e:set>
</e:if>

<e:if condition="${legendAlign==null || legendAlign == ''}">
	<e:set var="legendAlign" value="center"></e:set>   	
</e:if>
<e:if condition="${legendLayout==null || legendLayout==''}">
	<e:set var="legendLayout" value="horizontal"></e:set>
</e:if>
<e:if condition="${legendBorderWidth==null || legendBorderWidth==''}">
	<e:set var="legendBorderWidth" value="0"></e:set>
</e:if>
<e:if condition="${legendVerticalAlign==null || legendVerticalAlign==''}">
	<e:set var="legendVerticalAlign" value="bottom"></e:set>
</e:if>

<e:if condition="${!e:endsWith(width,'px')&&!e:endsWith(width,'pt')&&!e:endsWith(width,'em')&&!e:endsWith(width,'%')&&width!='auto'}">
	<e:set var="width" value="${width}px" />
</e:if>
<e:if condition="${!e:endsWith(height, 'px')&&!e:endsWith(height,'pt')&&!e:endsWith(height,'em')&&!e:endsWith(height,'%')&&height!='auto'}">
	<e:set var="height" value="${height}px" />
</e:if>
<div id="${id}" style="width: ${width}; height: ${height}; margin: 0 auto"></div>
<script type="text/javascript">
	var options_${id} ={
	    chart: {
			renderTo: '${id}'
			<e:if condition="${backgroundColor !=null && backgroundColor ne ''}">
			,plotBackgroundColor: '${backgroundColor}'
			</e:if>
			<e:if condition="${borderWidth !=null && borderWidth ne ''}">
			,plotBorderWidth: '${borderWidth}'
			</e:if>
			,plotShadow: false
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
			text: '${title}'
		},
		colors:${colors},
		tooltip: {
			<e:if condition="${percentage==true}">
				pointFormat: '{series.name}: <b>{point.percentage:.${tipfmt}f}%</b>'
			</e:if>
			<e:if condition="${percentage==false}">
				pointFormat: '{series.name}: <b>{point.y}</b>',
			</e:if>
			<e:if condition="${percentage eq 'all'}">
				pointFormat: '<b>数值：{point.y}</b><br/><b>比例:{point.percentage:.${tipfmt}f}%</b>',
			</e:if>
		},
		legend: {
            itemStyle: {
			<e:if condition="${fontsize!=null && fontsize!=''}">
				fontSize: '${fontsize}'
			</e:if>
			},
		   align: '${legendAlign}',
           layout:'${legendLayout}',
           verticalAlign:'${legendVerticalAlign}',
           itemMarginTop:5,
           borderWidth:${legendBorderWidth}
		},
		plotOptions: {
			pie: {
				allowPointSelect: true,
				cursor: 'pointer',
				<e:if condition="${show3D==true}">
				depth: 30,
				</e:if>
				dataLabels: {
					<e:if condition="${dataLabels==true}">
						enabled: true,
					</e:if>
					<e:if condition="${dataLabels==false}">
						enabled: false,
					</e:if>
					<e:if condition="${datalablecolor!=null && datalablecolor ne ''}" var="cconn">
						color: '${datalablecolor}',
					</e:if>
					<e:else condition="${cconn}">
						color: '#000000',
					</e:else>
					<e:if condition="${distance!=null&&distance!=''}">
						distance:${distance},
					</e:if>
					connectorColor: '#000000',
					formatter: function() {
						<e:if condition="${percentage==true}">
							return this.point.name +': '+ this.point.y +' ${unit}';
						</e:if>
						<e:if condition="${percentage==false}">
							return this.point.name +': '+ (this.percentage).toFixed(${tipfmt}) +' %';
						</e:if>
						<e:if condition="${percentage eq 'all'}">
							return this.point.name +': '+ this.point.y+","+(this.percentage).toFixed(${tipfmt}) +' %';
						</e:if>
					}
				},
				events: {
					<e:if condition="${dataPointClick!=null && dataPointClick ne ''}" >
						click: ${dataPointClick}
					</e:if>
				}
				<e:if condition="${legend==true}">
					,showInLegend: true
				</e:if>
			}
		},
	    series: [{
	    	type: 'pie',
	        data: []
		}]
	};
	$(function(){
		<e:set var="initscript">
			<e:forEach items="${dynattrs}" var="item">
				<e:if condition="${index==0}">
					data_${id} = [];
					$.each(data, function(index, item){
						if(index==0){
							data_${id}.push({name:item.${dimension},y:item.${item.key},sliced:true,selected:true});
						}else{
            				data_${id}.push([item.${dimension},item.${item.key}]);
            			}
            		});
            		options_${id}.series[0].name = '${item.value}';
	        		options_${id}.series[0].data = data_${id};
	        	</e:if>
	        </e:forEach>
	        var chart_${id} = new Highcharts.Chart(options_${id});
		</e:set>
		<e:if var="flag" condition="${items!=null}">
		var data = jQuery.parseJSON('${e:java2json(items)}');
			${initscript}
		</e:if>
		<e:else condition="${flag}">
		$.getJSON((window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+('${url}'.indexOf("/")==0?'${url}':'/${url}'), {echart: "npie"}, function(data) {
			${initscript}
		});
		</e:else>
	});
</script>