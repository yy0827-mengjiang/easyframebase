<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:set var="treeDataUrl"><e:url value="/pages/kpi/manager/kpiAction.jsp?eaction=dimension"/></e:set>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<script type="text/javascript">
	  	function clickDimNode(node){
	  		var row = $('#conditionTable').datagrid('getSelected');
	  		var indexs = $('#conditionTable').datagrid('getRowIndex',row);
			var isleaf = $(this).tree('isLeaf',node.target);
			if(isleaf){
				$('#dim_name'+indexs).val(node.text);
				$('#dimName'+indexs).val(node.id);
				$('#tableCode'+indexs).val(node.attributes.tablecode);
				$('#dim_value1').html("");
				$('#isKpi'+indexs).val("0");
				$('#clz0').attr("disabled",true);
				$('#dim1').attr("disabled",false);
				$('#dim_value1').attr("disabled",false);
				$('#constant').attr("checked",false);
				$('#dim-dlg').dialog('close');
				var tableName=node.attributes.tablename;
				var tableCode=node.attributes.tablecode;
				$.ajax({
		             type: "POST",
		             url: "<e:url value='/pages/kpi/manager/kpiAction.jsp?eaction=dimensionForOid'/>&oid="+tableCode+"&tableName="+tableName,
		             dataType: "json",
		             success: function(data){
		                  var dim1 =$('#dim1');
		                  dim1.html("");
		                  for(var i=0;i<data.length;i++){
		                  	dim1.append("<option value='"+data[i].KEY+"'>"+data[i].VALUE+"</option>");
		                  }
		                  $('#clz0').val("");
		             }
		         });
			}
			
		}
  	
  	</script>
  </head>
  
  <body>
  	<a:tree id="dimt" url='${treeDataUrl}' onDblClick='clickDimNode'/><!--  onDrop="cutToOthers" -->
  </body>
</html>
