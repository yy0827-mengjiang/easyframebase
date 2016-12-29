<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources> 
<html>
  <head>
    <title>血缘关系</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<e:style value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
	<e:style value="/resources/easyResources/component/easyui/icon.css" />
	<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
    <link rel="stylesheet" href="../jOrgChart/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="../jOrgChart/css/jquery.jOrgChart.css"/>
    <link rel="stylesheet" href="../jOrgChart/css/custom.css"/>
    <link href="../jOrgChart/css/prettify.css" type="text/css" rel="stylesheet" />
        <script src="../jOrgChart/jquery.jOrgChart.js"></script>
    <script>
    $(function() {
 	   $.getJSON("../../../sibshipJson.e",{"kpiKey":'${param.kpi_key}',"kpiName":'${param.kpi_name}'},function(data){
	 	   		sib(data,'org')
		        $("#org").jOrgChart({
		            chartElement : '#chart',
		            dragAndDrop  : false
		        }); 	   		
 	   		});
 	   })
	 function sib(data,ele){
		$.each(data,function(i,v){
			if($.type(this.children)!='undefined'){
				$('#'+ele).append('<li id='+this.id+' class='+this.style+'>'+this.text+'<ul id="ul_'+this.id+'"></ul></li>');
				sib(this.children,"ul_"+this.id);
			}
			else{
				$('#'+ele).append('<li id='+this.id+' class='+this.style+'>'+this.text+'</li>');
			}
		})	
	 }
    </script>
  </head>
  <body>
    <ul id="org" style="display:none">
	</ul>
    <div id="msg" style="border:3px solid #bdbdbd;width:180px;height:300px;position:absolute;top:100px;left:10px;display:none;background-color:#808080;">msg....</div>
    <div id="chart" class="orgChart"></div>
</body>
</html>