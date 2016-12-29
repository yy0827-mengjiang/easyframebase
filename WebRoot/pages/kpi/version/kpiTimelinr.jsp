<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
  <head>
    <title>指标库版本查询</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
 	<meta http-equiv="X-UA-Compatible" content="IE=edge">
 	<e:q4l var="kpiHis">
 		SELECT TO_CHAR(T.CREATE_DATETIME,'MM-DD') CREATEDATE,T.KPI_VERSION,T.KPI_NAME||'[V'||T.KPI_VERSION||']' KPINAME,T.KPI_CALIBER FROM X_KPI_INFO_TMP T WHERE T.KPI_CODE='${param.kpi_code }' ORDER BY T.CREATE_DATETIME,T.KPI_VERSION
 	</e:q4l>
 	<e:q4o var="kpiInfo">
 		SELECT DISTINCT T.KPI_NAME KPINAME FROM X_KPI_INFO_TMP T WHERE T.KPI_CODE='${param.kpi_code }' AND T.KPI_STATUS = '2'
 	</e:q4o>
 	<e:q4o var="startAt">
 		SELECT COUNT(1) STARTAT FROM X_KPI_INFO_TMP T WHERE T.KPI_CODE='${param.kpi_code }'
 	</e:q4o>
 	<style type="text/css">
		#timeline {width: 75%;height: 75%;overflow: hidden;margin: 100px auto;position: relative;background: url('dot.gif') left 45px repeat-x;}
		#dates {width: 760px;height: 60px;overflow: hidden;}
		#dates li {list-style: none;float: left;width: 100px;height: 50px;font-size: 24px;text-align: center;background: url('biggerdot.png') center bottom no-repeat;}
		#dates a {line-height: 38px;padding-bottom: 10px; color:#f30;}
		#dates .selected {font-size: 35px;}
		#issues {width: 760px;height: 300px;overflow: hidden;}	
		#issues li {width: 760px;height: 300px;list-style: none;float: left;}
		#issues li h1 {color: #ffcc00;font-size: 42px;margin: 20px 0;text-shadow: #000 1px 1px 2px;}
		#issues li p {font-size: 14px;margin-right: 70px; margin:10px; font-weight: normal;line-height: 22px;}
	</style>

	<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources> 
	<e:script value="/pages/kpi/jOrgChart/jquery.min.js"/>
	<e:script value="/pages/kpi/version/jquery.timelinr-0.9.53.js"/>
 	<script type="text/javascript">
	 	$(function(){
	 	    $().timelinr({
	 			orientation: 	'horizontal',
	 			issuesSpeed: 	300,
	 			datesSpeed: 	100,
	 			arrowKeys: 		'true',
	 			startAt:		${startAt.STARTAT}
	 		});
	 	});
 	</script>
  </head>
  
  <body>
	<h3 style="padding:8px 16px;">${kpiInfo.KPINAME } 历史</h3>
	<div id="timeline">
	   <ul id="dates">
	      <e:forEach items="${kpiHis.list }" var="kpi">
	      		<li><a href="#${kpi.CREATEDATE }">${kpi.CREATEDATE }</a></li>
	      </e:forEach>
	   </ul>
	   <ul id="issues">
	      <e:forEach items="${kpiHis.list }" var="kpi">
	      		<li id="${kpi.CREATEDATE }">
					<h1>${kpi.KPINAME }</h1>
	      			<p>&nbsp;&nbsp;&nbsp;&nbsp;${kpi.KPI_CALIBER }</p>
	      		</li>
	      </e:forEach>
	   </ul>
	   <a href="javascript:void(0)" id="next"></a> <!-- optional -->
	   <a href="javascript:void(0)" id="prev"></a> <!-- optional -->
	</div>
  </body>
</html>
