<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:set var="treeDataUrl"><e:url value="/pages/kpi/manager/kpiAction.jsp?eaction=complexKpi"/></e:set>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<script type="text/javascript">
  	var comtext = "";
  	function chooseKpiFromTree(node) {
  		var isleaf = $(this).tree('isLeaf',node.target);
  		if(isleaf){
			var result=node.text;
			var resId = node.id;
			var tmp = "{" + result + "}";
			var tmpId ="{" + resId + "}";
			var row = $("#formTable").datagrid('getData').rows[0];
			var forms = $('#hidForms').val();
			if(row.kpi_forms == "") { 
				$('#isFormula').val("0");
				$('#complexkpiCode').val(node.id);
			} else { 
				$('#isFormula').val("1");
				comtext = complexKpicode(comtext,node.id);
				tmp = replaceKpiFormula(tmp,row.kpi_forms);
				tmpId = replaceKpiFormula(tmpId,forms);
			}
			var param = {"index": 0, "row":{"kpi_forms":tmp}};
			$("#formTable").datagrid('updateRow',param);
			$('#hidForms').val(tmpId);
  		}
	}
	function  replaceKpiFormula(kpi,kpi_forms){
		var i = kpi_forms.indexOf("{kpi}");
		var tmp =  kpi_forms;
		if(i != -1) {
			tmp = kpi_forms.substring(0,i) + kpi + kpi_forms.substring(i+5);
		}
		return tmp;
	}
	
	function complexKpicode(text,id){
		text = text+","+id;
		$('#complexkpiCode').val(text);
		return text;
	}
  	</script>
  </head>
  
  <body>
  	<a:tree id="ckpi" url='${treeDataUrl}' onDblClick='chooseKpiFromTree'/><!--  onDrop="cutToOthers" -->
  </body>
</html>
