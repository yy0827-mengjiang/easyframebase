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
  	var text = "";
  	function chooseKpiFromTree(node) {
  		var isleaf = $(this).tree('isLeaf',node.target);
		if(isleaf){
			var result=node.text;
			var resId = node.id;
			var tmp = "{" + result + "}";
			var tmpId ="{" + resId + "}";
			var row = $("#formTable").datagrid('getData').rows[0];
			var forms = $('#hidForms').val();
			if($('#kpi_formula').val() == "") {
				$('#isFormula').val("0");
				$('#kpiCode').val(","+node.id);
			} else { 
				$('#isFormula').val("1");
				if(row.kpi_forms.indexOf("{kpi}")!=-1){
					text = kpicode(text,node.id);
				}
				tmp = replaceKpiFormula(tmp,row.kpi_forms);
				tmpId = replaceKpiFormula(tmpId,forms);
			}
			var param = {"index": 0, "row":{"kpi_forms":tmp}};
			$("#formTable").datagrid('updateRow',param);
			$('#hidForms').val(tmpId);
			
		}
	}
	function replaceKpiFormula(kpi,kpi_forms){
		var i = kpi_forms.indexOf("{kpi}");
		var tmp =  kpi_forms;
		if(i != -1) {
			tmp = kpi_forms.substring(0,i) + kpi + kpi_forms.substring(i+5);
		}
		return tmp;
	}
	function kpicode(text,id){
		text = text+","+id;
		$('#kpiCode').val(text);
		return text;
	}
  	
  	</script>
  </head>
  
  <body>
  	<a:tree id="kpit" url='${treeDataUrl}' onDblClick='chooseKpiFromTree'/><!--  onDrop="cutToOthers" -->
  </body>
</html>
