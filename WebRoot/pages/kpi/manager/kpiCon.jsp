<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:set var="treeDataUrl"><e:url value="/pages/kpi/manager/kpiAction.jsp?eaction=kpi"/></e:set>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<script type="text/javascript">
	  	function clickKpiNode(node){
	  		var row = $('#conditionTable').datagrid('getSelected');
	  		var indexs = $('#conditionTable').datagrid('getRowIndex',row);
			var isleaf = $(this).tree('isLeaf',node.target);
			if(isleaf){
				$('#dim_name'+indexs).val(node.text);
				$('#dimName'+indexs).val(node.id);
				$('#isKpi'+indexs).val("1");
				$('#dim1').html("");
				$('#dim_value1').html("");
				$('#dim1').attr("disabled",true);
				$('#dim_value1').attr("disabled",true);
				$('#constant').attr("checked",true);
				$('#clz0').attr("disabled",false);
				$('#dim-dlg').dialog('close');
			}
			
		}
  	</script>
  </head>
  
  <body>
  	<a:tree id="kpicon" url='${treeDataUrl}' onDblClick='clickKpiNode'/><!--  onDrop="cutToOthers" -->
  </body>
</html>
