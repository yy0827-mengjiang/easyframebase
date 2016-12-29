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

	var xavg = 60;
	var xtmp = 0.85;
	
    $('#container').highcharts({
        chart : {
            type: 'bubble',
            zoomType: 'xy'
        },
        title : {
        	text: '我是气泡图'
        },
        xAxis : [
        	{
	        	min : 0, 
	        	max : 100, 
	        	title: {text: '发展增长率'},
	        	tickInterval : 10,
		        gridLineWidth : 0,
		        lineWidth : 1,
	        },
	        {
	        	lineWidth : 1,
	        	title: {text: ''},
	        	offset : -${400 * 20 / 100 * 0.66},
	        	labels: {enabled: false}
	        }
        ],
        yAxis : [
        	{
	        	min : 0, 
	        	max : 100,
	        	title: {text: '收入增长率1'},
	        	tickInterval : 10,
	        	gridLineWidth : 0,
	        	lineWidth : 1,
	        },
	        {
	        	lineWidth : 1,
	        	title: {text: ''},
	        	offset : -${600 * 80 / 100 * 0.86},
	        	labels: {enabled: false}
	        }
        ],
        series: [
        	{data: [
        		{x:30, y:90, z:120, extra:'济南'},
        		{x:20, y:80, z:100, extra:'青岛'},
        		{x:30, y:40, z:70, extra:'菏泽'}
        	],name : '多的'},
        	{data: [
        		{x:25, y:35, z:60, extra:'枣庄'},
        		{x:90, y:90, z:180, extra:'潍坊'},
        		{x:55, y:55, z:110, extra:'烟台'}
        	],name : '少的'},
        	{data: [
        		{x:45, y:25, z:70, extra:'日照'},
        		{x:15, y:45, z:50, extra:'临沂'},
        		{x:70, y:40, z:110, extra:'莱芜'}
        	],name : '一般般'},
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
<div id="container" style="width:600px; height:400px; margin:0 auto"></div>
</body>
</html>