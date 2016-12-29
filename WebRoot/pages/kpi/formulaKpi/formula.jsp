<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:set var="treeDataUrl"><e:url value="/pages/kpi/formulaKpi/formulaAction.jsp?eaction=formula"/></e:set>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<e:script value="/pages/kpi/formulaKpi/easyui-lang-zh_CN.js" />
  <head>
  </head>
  
  <body>
	  <div style="border:1px #aeadab solid; margin:4px; width: 45%; padding:10px; height:420px; overflow:auto;float: left;">
	  		<h4><span>公式</span></h4>
	  	<a:tree id="baseformula" url='${treeDataUrl}' onClick="clickFormula" onDblClick="dbFormula" onContextMenu="formulaContextMenu"/><!--  onDrop="cutToOthers" -->
	  </div>
  	  <div style="border:1px #aeadab solid; margin:4px; width: 45%; padding:10px; height:420px;float: right;">
	  		<h4><span>公式说明</span></h4>
	  		<div id="diaExplain">
	  		</div>
  	  </div>
  	  <div id="formulaNodeMenu" class="easyui-menu" style="width:120px;">
			<div  data-options="iconCls:'ico-kpi-delete'" onclick="formulaNodeDelete();">删除公式</div>
		</div>
  </body>
</html>
