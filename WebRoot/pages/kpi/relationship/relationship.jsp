<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    
    <title>血缘关系</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	
	<e:style value="/pages/kpi/relationship/css/base.css"/>
	<e:style value="/pages/kpi/relationship/css/Spacetree.css"/>
	<!--[if IE]><e:script value="/pages/kpi/relationship/js/excanvas.js"/><![endif]-->
	<e:script value="/pages/kpi/relationship/js/jit.js"/>
	<e:script value="/pages/kpi/relationship/js/example4.js"/>
	<script type="text/javascript">
	$.getJSON("../../../ship.e",{"kpi_key":'${param.kpi_key}',"kpi_version":'${param.kpi_version}'},function(data){
		 console.log(data[0]);
		 init(data[0]);
		});
	</script>
  </head>
  
  <body>
	<div id="container">
		<div id="center-container">
		    <div id="infovis"></div>    
		</div>
	</div>
</body>
</html>