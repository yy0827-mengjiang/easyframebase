<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources> 
<e:style value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
		<e:style value="/resources/easyResources/component/easyui/icon.css" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    
    <title>My JSP 'kpiView.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<script type="text/javascript">
		$(function(){
		 	addTabs("历史版本","../version/kpi_version.jsp?kpi_code=${param.kpi_code}",true);
			addTabs("血缘关系","sibship.jsp?kpi_key=${param.kpi_key}&kpi_name=${param.kpi_name}",false);
			addTabs("操作日志","operateLog.jsp?kpi_key=${param.kpi_key}",false);
		});
		function addTabs(text,url,sel) {
			if ($("#tt").tabs('exists', text)) {
				$("#tt").tabs('close', text);
			} 
			if (url && url.length > 0) {
				$("#tt").tabs('add', {
					selected: sel,
					title : text,
					closable : false,
					fit:true,
					border : false,
					content : '<iframe src="' + url + '" frameborder="0" style="border:0;width:100%;height:92%;"></iframe>'
				});
			} 
		}
	</script>
  </head>	
  		
  <body>
    <div id="tt" class="easyui-tabs">
    </div>
  </body>
</html>
