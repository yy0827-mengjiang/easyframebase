<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:set var="treeDataUrl"><e:url value="/pages/kpi/manager/kpiAction.jsp?eaction=kpi"/></e:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
  <head>
    <title>系统菜单管理</title>
    <c:resources type="easyui" style="b"/>
 	<e:style value="resources/themes/common/css/icon.css"/>
 	<script type="text/javascript">
	 	function clickNode(node){
	   		var isleaf = $(this).tree('isLeaf',node.target);
			if(isleaf){
				alert(node.id);
				alert(node.attributes.kpiTypeId);     //当是目录的时候 弹出叶子节点
			}
	   }
 	</script>
  </head>
  <body>
	  	<style>.p-l-5{ padding-right:5px; text-align:right;}</style>
    	<div id="dim-tree" class="easyui-panel" title="kpi" fit="true">
    		<a:tree id="tt" url='${treeDataUrl}' onClick='clickNode'/><!--  onDrop="cutToOthers" -->
    	</div>
  </body>
</html>
