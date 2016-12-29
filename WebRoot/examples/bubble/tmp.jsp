<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="m" uri="http://www.bonc.com.cn/easy/taglib/m"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>bubble</title>
<e:script value="/resources/easyResources/scripts/jquery-1.8.3.min.js" />
<e:script value="/resources/easyResources/scripts/jquery.json-2.3.min.js" />
<e:script value="/resources/easyResources/component/highcharts/highcharts.js" />
<e:script value="/resources/easyResources/component/highcharts/highcharts-more.js" />

<script type="text/javascript">
$(function () {
    $('#container').highcharts({
        chart : {
            type: 'bubble',
            zoomType: 'xy'
        },
        title : {
        	text: '我是气泡图'
        },
        xAxis : {
        	min : 0, 
        	max : 100, 
        	title: {text: '发展增长率'}
        },
        yAxis : [
        	{
	        	min : 0, 
	        	max : 100,
	        	title: {text: '收入增长率1'},
	        	gridLineWidth: 0,
	        	gridLineColor: '#FFF',
	        	lineWidth : 1,
	        },
	        {
	        	min : 0, 
	        	max : 100,
	        	lineWidth : 1,
	        	title: {text: ''},
	        	offset : -90,
	        	labels: {enabled: false}
	        }
        ],
        series: [
        	{data: [
        		{x:10,y:80,z:51,extra:'济南'},
        		{x:50,y:66,z:43,extra:'青岛'},
        		{x:60,y:40,z:66,extra:'菏泽'}
        	]},
        	{data: [
        		{x:55,y:77,z:22,extra:'枣庄'},
        		{x:33,y:44,z:88,extra:'潍坊'},
        		{x:66,y:55,z:66,extra:'烟台'}
        	]}
        ],
        plotOptions: {
            series: {
                cursor: 'pointer',
                dataLabels:{
                     enabled:true,
                     formatter: function() {
                        return this.point.extra;
                     }
                }
            }
        }});
    
});
</script>
</head>
<body>
<div id="container" style="height: 400px; min-width: 310px; max-width: 600px; margin: 0 auto"></div>
</body>
</html>