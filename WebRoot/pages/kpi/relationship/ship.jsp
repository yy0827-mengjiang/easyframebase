<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    
    <title>${param.kpi_name}</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<c:resources type="easyui,app"  style="${ThemeStyle }"/>
	<e:style value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
	<e:style value="/resources/easyResources/component/easyui/icon.css" />
	<e:style value="/resources/themes/base/boncBase@links.css"/>
	<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
	<e:style value="/pages/kpi/relationship/css/base.css"/>
	<e:style value="/pages/kpi/relationship/css/Spacetree.css"/>
	<link rel="stylesheet" href="../jOrgChart/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="../jOrgChart/css/jquery.jOrgChart.css"/>
    <link rel="stylesheet" href="../jOrgChart/css/custom.css"/>
    <link href="../jOrgChart/css/prettify.css" type="text/css" rel="stylesheet" />
	<!--[if IE]><e:script value="/pages/kpi/relationship/js/excanvas.js"/><![endif]-->
	<e:script value="/pages/kpi/relationship/js/jit.js"/>
	<e:script value="/pages/kpi/relationship/js/example4.js"/>
	<script src="../jOrgChart/jquery.jOrgChart.js"></script>
	<script type="text/javascript">
		$(function(){
			$.getJSON("../../../ship.e",{"kpi_key":'${param.kpi_key}',"kpi_version":'${param.kpi_version}',"kpi_type":'${param.kpi_type}'},function(data){
				console.log(data[0]); 
				init(data[0]);
			}); 
// 			$.getJSON("../../../sibshipJson.e",{"kpiKey":'${param.kpiId}',"kpiName":'${param.kpi_name}'},function(data){
// 	 	   		sib(data,'org');
// 		        $("#org").jOrgChart({
// 		            chartElement : '#chart',
// 		            dragAndDrop  : false
// 		        }); 	   		
//  	   		});
		});
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
  	<div>
	  	<div id="container">
			<div id="center-container">
			    <div id="infovis"></div>    
			</div>
		</div>
		<div id="info" class="shipArea" style="display: none;">
			<table class="shipTable">
			<colgroup>
			<col width="40%" />
			<col width="*" />
			</colgroup>
				<tr>
					<th class="tha1">名称</th>
					<td id="kpiName"></td>
				</tr>
				<tr>
					<th class="tha2">版本</th>
					<td id="kpiVersion"></td>
				</tr>
				<tr>
					<th class="tha3">类型</th>
					<td id="kpiType"></td>
				</tr>
				<tr>
					<th class="tha4">说明</th>
					<td id="comment"></td>
				</tr>
			</table>
		</div>
	</div>
  </body>
</html>
