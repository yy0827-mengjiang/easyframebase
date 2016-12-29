<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>纬度管理</title>
		<c:resources type="easyui"  style="${ThemeStyle }"/>
		<e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/resources/themes/blue/boncBlue.css"/>
	<script type="text/javascript">
	  function doSearch(){
	        $('#dimTable').datagrid('options').queryParams=getParams();
			$('#dimTable').datagrid('load');
	  }
	  function getParams(){
		  var params = {};
	    	params.dim_code=$('#dim_code').val();
	    	params.table_name=$('#table_name').val();
	        params.table_desc=$('#table_desc').val();
	        params.table_column=$('#table_column').val();
	       return params;
	  }
	  function reportCZ(value,rowData){
			var upd =  '<a href="javascript:void(0);" class="btn-submit1" onclick="updDim(\''+rowData.DIM_CODE+'\')">编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;';
			var del =  '<a href="javascript:void(0);" class="btn-submit2" onclick="delDim(\''+rowData.DIM_CODE+'\')">删除</a>';
			var res = upd+del;
			return  res;
		}
	  
	  function delDim(dim_code){
		  $.messager.confirm('操作确认', '您确定删除此纬度吗？', function(r){
			  if (r){
				  $.post('<e:url value="/pages/kpi/basedim/dimAction.jsp?eaction=delDim"/>',{dim_code:dim_code}, function(data){
			            var temp = $.trim(data);
			           // alert(temp);
			            if(temp=='1'){
			            	$.messager.alert("信息","删除纬度成功","info");
			            	$('#dimTable').datagrid('options').queryParams=getParams();
			    			$('#dimTable').datagrid('load');
			            }else{
			            	$.messager.alert("信息","删除纬度失败，请联系管理员","error");
			            }
					});
			  }
		   });
	  }
	  function updDim(dim_code){
			window.location.href='<e:url value="/pages/kpi/basedim/cude_dimEdit.jsp"/>?dim_code='+dim_code;
		}
	  function returnTable(value,rowData){
		  var tmp = value;
		  if(tmp != null && tmp !="" && tmp != "null"){
			  return '<div title="'+tmp+'">'+tmp+'</div>';
		  } else {
			  return ""; 
		  }
	  }
	  
	</script>
	</head>
	<body>
	<form id="downloadExcel_R" method="post" action="<e:url value="downloadExcelFile.e"/>">
		<input type="hidden" name="doc_type" value="dim_r">
    </form>
   		
		<div id="tbar">
		<h2>纬度管理</h2>
			<div class="search-area">
<!-- 					纬度编码: <input id="dim_code" type="text" name="dim_code"  style="width:15%"/> -->
					维度名称: <input id="table_desc" type="text" name="table_desc"  style="width:15%"/>
					维表表名: <input id="table_name" type="text" name="table_name"  style="width:15%"/>
<!-- 					维表编码列:<input id="table_column" type="text" name="table_column"  style="width:15%"/> -->
					<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doSearch();">查询</a>
					<a href='<e:url value="/pages/kpi/basedim/cude_basedimAdd.jsp"/>' class="easyui-linkbutton">新增</a>
				<!--  
				<a id="download" class="easyui-linkbutton"  href="javascript:void(0);" onclick="javascript:$('#downloadExcel_R').submit();">下载Excel模版</a>
				-->
			</div>
		</div>
		<c:datagrid url="/pages/kpi/basedim/dimAction.jsp?eaction=list" id="dimTable" style="width:auto;" pagination="true" pageSize="20" fit="true" download="true" nowrap="false" border="false"
		toolbar="#tbar">
			<thead>
				<tr>
					<th field="DIM_CODE" width="90" align="center">
						维度编码
					</th>
					<th field="CODE_TABLE_DESC" width="100" align="center">
						维度名称
					</th>
					<th field="CODE_TABLE" width="140" align="center" formatter="returnTable">
						维表表名
					</th>
					<th field="COLUMN_CODE" width="70" align="center">
						维表编码列
					</th>
					<th field="COLUMN_DESC" width="80" align="center">
						维表描述列
					</th>
					<th field="COLUMN_ORD" width="100" align="center">
						维表排序列
					</th>
					<th field="CONF_TYPE" width="80" align="center">
						纬度配置类型
					</th>
					<th field="cz" width="80" align="center" formatter="reportCZ">
						操作
					</th>
				</tr>
			</thead>
		</c:datagrid>
	</body>
</html>