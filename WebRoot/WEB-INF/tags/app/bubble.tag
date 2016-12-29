<%@ tag body-content="empty" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<%@ attribute name="id" required="true" %>                                               	<e:description>图形id</e:description>
<%@ attribute name="series" required="true" %>                                              <e:description>数据指标</e:description>
<%@ attribute name="width" required="true" %>                                               <e:description>图形宽度</e:description>
<%@ attribute name="height" required="true" %>                                              <e:description>图形高度</e:description>
<%@ attribute name="title" required="false" %>                                              <e:description>图形标题</e:description>
<%@ attribute name="xtitle" required="false" %>                                             <e:description>x轴标题</e:description>
<%@ attribute name="ytitle" required="false" %>                                             <e:description>y周标题</e:description>
<%@ attribute name="xmin" required="false" %>                                             	<e:description>x轴最小刻度</e:description>
<%@ attribute name="xmax" required="false" %>                                             	<e:description>x轴最大刻度</e:description>
<%@ attribute name="xtick" required="false" %>                                             	<e:description>x轴间隔</e:description>
<%@ attribute name="xavg" required="false" %>                                             	<e:description>x轴平均值线</e:description>
<%@ attribute name="xtmp" required="false" %>                                             	<e:description>x轴偏移像素%</e:description>
<%@ attribute name="ymin" required="false" %>                                             	<e:description>y轴最小刻度</e:description>
<%@ attribute name="ymax" required="false" %>                                             	<e:description>y轴最大刻度</e:description>
<%@ attribute name="ytick" required="false" %>                                             	<e:description>y轴间隔</e:description>
<%@ attribute name="yavg" required="false" %>                                             	<e:description>y轴平均值线</e:description>
<%@ attribute name="ytmp" required="false" %>                                             	<e:description>y轴偏移像素%</e:description>
<%@ attribute name="formatter" required="false" %>                                             	<e:description>格式化函数</e:description>
<jsp:doBody var="bodyRes" />
<e:set var="xTitle" value="" />
<e:set var="yTitle" value="" />
<e:if condition="${xtitle!=null && xtitle!=''}">
	<e:set var="xTitle" value="${xtitle}" />
</e:if>
<e:if condition="${ytitle!=null && ytitle!=''}">
	<e:set var="yTitle" value="${ytitle}" />
</e:if>
<div id="${id}" style="width: ${width}; height: ${height}; margin: 0 auto"></div>
<script type="text/javascript">
$(function () {
	$('#${id}').highcharts({
        chart : {type: 'bubble',zoomType: 'xy'},
        title : {text: '${title}'},
        <e:if condition="${formatter!=null && formatter!=''}">
		    tooltip: {
	            formatter: ${formatter}
	        },
		</e:if>
        xAxis : [
        	{
        		title: {text: '${xTitle}'},
        		<e:if condition="${xmin!=null && xmin!=''}">
					min : ${xmin},
				</e:if>
	        	<e:if condition="${xmax!=null && xmax!=''}">
					max : ${xmax},
				</e:if>
	        	<e:if condition="${xtick!=null && xtick!=''}">
					tickInterval : ${xtick},
				</e:if>
		        gridLineWidth : 0,
		        lineWidth : 1,
	        },
	        <e:if condition="${yavg!=null && yavg!=''}">
	        {
	        	offset : -${e:replace(height,'px','')/((ymax)-(ymin)) * ((yavg)-(ymin)) * ytmp},
	        	lineWidth : 1,
	        	title: {text: ''},
	        	labels: {enabled: false}
	        }
	        </e:if>
	        
        ],
        yAxis : [
        	{
        		title: {text: '${yTitle}'},
	        	<e:if condition="${ymin!=null && ymin!=''}">
					min : ${ymin},
				</e:if>
	        	<e:if condition="${ymax!=null && ymax!=''}">
					max : ${ymax},
				</e:if>
	        	<e:if condition="${ytick!=null && ytick!=''}">
					tickInterval : ${ytick},
				</e:if>
	        	gridLineWidth : 0,
	        	lineWidth : 1,
	        },
	        <e:if condition="${xavg!=null && xavg!=''}">
	        {
	        	offset : -${e:replace(width,'px','')/((xmax)-(xmin)) * ((xavg)-(xmin)) * xtmp},
	        	lineWidth : 1,
	        	title: {text: ''},
	        	labels: {enabled: false}
	        }
	        </e:if>
        ],
        
        series: ${series},
        
        plotOptions: {
            series: {
                cursor: 'pointer',
                dataLabels:{
                     enabled:true,
                     formatter: function() {
                        return this.point.extra;
                     },
                     style:{
                    	 color:'#fff',
                    	 fontSize: '12px',
                    	 textShadow:'1px 1px 1px #000'
                     }
                }
            }
        }
	});
});
</script>