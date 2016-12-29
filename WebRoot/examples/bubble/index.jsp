<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
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
	    
});
</script>
</head>
<body>
<e:q4l var="testList">
	select 30 x,90 y,120 z,'济南' extra from dual union 
	select 20 x,80 y,100 z,'青岛' extra from dual union 
	select 30 x,40 y,100 z,'菏泽' extra from dual union 
	select 25 x,35 y,60 z,'枣庄' extra from dual union 
	select 90 x,90 y,180 z,'潍坊' extra from dual union 
	select 55 x,55 y,110 z,'烟台' extra from dual union 
	select 45 x,25 y,70 z,'日照' extra from dual union 
	select 15 x,45 y,50 z,'临沂' extra from dual union 
	select 70 x,40 y,110 z,'莱芜' extra from dual
</e:q4l>
<!-- 计算平均值 -->
<e:set var="xavg">80</e:set>
<e:set var="yavg">50</e:set>

<!-- 给个偏移量，暂时这样配置，平均值线有偏差 -->
<e:set var="xtmp">0.87</e:set>
<e:set var="ytmp">0.66</e:set>

<e:set var="series">
	[{data:[<e:forEach items="${testList.list}" var="item">
		{x:${item.x}, y:${item.y}, z:${item.z}, extra:'${item.extra}'},
		<e:if condition="${index==3}">
		],name:'多的'},{data:[
		</e:if>
		<e:if condition="${index==6}">
		],name:'少的'},{data:[
		</e:if>
	</e:forEach>],name:'一般般'}]
</e:set>
<a:bubble id="b1" width="600px" height="400px" title="气泡图标题" series="${series}"
	xtitle="发展增长率" ytitle="收入增长率" 
	xmin="0" xmax="100" 
	ymin="0" ymax="100" 
	xtick="20" ytick="20" 
	xavg="${xavg}" yavg="${yavg}" xtmp="${xtmp}" ytmp="${ytmp}"></a:bubble>
</body>
<!-- 
[
 	{data: [
 		{x:10, y:80, z:51, extra:'济南'},
 		{x:50, y:66, z:43, extra:'青岛'},
 		{x:60, y:40, z:66, extra:'菏泽'}
 	],name : '多的'},
 	{data: [
 		{x:55, y:77, z:22, extra:'枣庄'},
 		{x:33, y:44, z:88, extra:'潍坊'},
 		{x:66, y:55, z:66, extra:'烟台'}
 	],name : '少的'},
 	{data: [
 		{x:65, y:77, z:22, extra:'枣庄'},
 		{x:33, y:44, z:88, extra:'潍坊'},
 		{x:76, y:55, z:66, extra:'烟台'}
 	],name : '少的111'}
]
-->
</html>