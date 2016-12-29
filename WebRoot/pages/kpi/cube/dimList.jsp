<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>纬度列表理</title>
		<c:resources type="easyui"  style="${ThemeStyle }"/>
		<e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/resources/themes/blue/boncBlue.css"/>
		<style>
			.windowsTable.dialogForm th{text-align:right; padding:8px;}
			.windowsTable.dialogForm td{padding:8px 4px;}
			.windowsTable.dialogForm td input.dimInputStyle{height:24px;}
		</style>
	<script type="text/javascript">
	  $(function(){
		  $('#f-dlg').dialog({
			    onClose:function(){
			    	$('#dimTable').datagrid('load');
			    }
			}); 
	  });
	  function doSearch(){
		  var params = {};
	    	params.dim_code=$('#dim_code').val();
	    	params.table_name=$('#table_name').val();
	        $('#dimTable').datagrid('options').queryParams=params;
			$('#dimTable').datagrid('load');
	  }
	  function doQueryForHasSelect(){
		  var _param = {};
		  _param.dim_code = $('#hasDimCode').val();
		  _param.table_name = $('#hasDimName').val();
		  $('#hasSelectDimTable').datagrid('options').queryParams=_param;
		  $('#hasSelectDimTable').datagrid('load');
	  }
	  function doQueryForNeedSelect(){
		  var _param = {};
		  _param.dim_code = $('#needDimCode').val();
		  _param.table_name = $('#needDimName').val();
		  $('#needSelectDimTable').datagrid('options').queryParams=_param;
		  $('#needSelectDimTable').datagrid('load');
	  }
	  function dyKpiCube(){
		  $('#f-dlg').dialog('open');  
	  }
	  function formatterCZ2(value,rowData){
		  return '<a href="javascript:void(0);" onclick="confirm(\''+${param.cube_code}+'\',\''+rowData.DIM_CODE+'\',\''+rowData.COLUMN_CODE+'\')">' + '关联' + '</a>';
	  }
	  function formatterCZ(value,rowData){
		  return '<a href="javascript:void(0);" onclick="del(\''+${param.cube_code}+'\',\''+rowData.DIM_CODE+'\')">' + '解除' + '</a>';
	  }
	 function add(cube_code,dim_code,dim_colmun){
		 var _param={};
		 var dim_table = $('#dim_table').val();
		 _param.cube_code = cube_code;
		 _param.dim_code = dim_code;
		 _param.dim_colmun = dim_colmun;
		 _param.dim_table = dim_table;
		 _param.dim_ord =  $('#dim_ord').val();
		 $.messager.confirm('提示信息', "确认关联所选维度与魔方吗？", function(r){
			if (r){
			  $.ajax({
				type:'post',
				url:'<e:url value="/pages/kpi/cube/listAction.jsp?eaction=addDim"/>',
				data:_param,
				async : false,
				success:function(data){
					var _data= $.parseJSON(data);
					if(_data!=0){
						$.messager.alert("提示信息！", "关联成功！", "info",function(){
							$('#hasSelectDimTable').datagrid('load');
							$('#needSelectDimTable').datagrid('load');
							$('#d-dlg').dialog('close');
						});
					}
				}
			  });
			}
		 });
	  }
	  function confirm(cube_code,dim_code,dim_colmun){
		 $('#d-dlg').dialog({
			 title: "关联维度信息",   //一些属性
			 width: 420,
             height: 260,
             modal:true,
             onBeforeOpen:function() {
    			 if(dim_colmun =="null")
    	 			 dim_colmun = "";
    			 $('#dim_colmun').val(dim_colmun);
            	 $("#dim_table").val("");
            	 $("#dim_ord").val("");
             },
             buttons: [{
            	 text:'确认',
            	 iconCls: "icon-ok",
            	 handler: function () {
            		 var _dim_colmun = $('#dim_colmun').val();
            		 add(cube_code,dim_code,_dim_colmun);
                 }
             },{
            	 text:'取消',
            	 iconCls: "icon-cancel",
            	 handler: function () {
            		 $('#d-dlg').dialog('close');
                 }
             }
             ]
		 });
	  }
	  function del(cube_code,dim_code){
		  $.messager.confirm('提示信息', "确认解除所选维度与魔方的关联吗？", function(r){
				if (r){
				  var _param={};
				 _param.cube_code = cube_code;
				 _param.dim_code = dim_code;
				  $.ajax({
					type:'post',
					url:'<e:url value="/pages/kpi/cube/listAction.jsp?eaction=delDim"/>',
					data:_param,
					async : false,
					success:function(data){
						var _data= $.parseJSON(data);
						if(_data!=0){
							$.messager.alert("提示信息！", "解除关联成功！", "info",function(){
								$('#hasSelectDimTable').datagrid('load');
								$('#needSelectDimTable').datagrid('load');
								$('#dimTable').datagrid('load');
							});
						}
					}
				  }); 
				}
		  });
	  }
	  function formateCubeDimCz(value,rowData) {
			var upd =  '<a href="javascript:void(0);" class="btn-submit1" onclick="editDlg(\''+rowData.DIM_CODE+'\',\''+rowData.TABLE_NAME+'\',\''+rowData.COLUMN_CODE+'\',\''+rowData.DIM_ORD+'\')">编辑</a>&nbsp;&nbsp;';
			var del =  '<a href="javascript:void(0);" class="btn-submit2" onclick="del(\'${param.cube_code }\',\''+rowData.DIM_CODE+'\')">删除</a>';
			var res = upd+del;
			return  res;
	  }
	  function editDlg(dim_code,table_name,column_code,dim_ord) {
		  $('#d-dlg').dialog({
				 title: "关联维度信息",   //一些属性
				 width: 420,
	             height: 260,
	             modal:true,
	             onBeforeOpen:function() {
	            	 if(table_name == null || table_name =="null"){
	            		 table_name = "";
	            	 }
	            	 if(dim_ord == null || dim_ord =="null"){
	            		 dim_ord = "";
	            	 }
	            	 $("#dim_table").val(table_name);
	            	 $("#dim_colmun").val(column_code);
	            	 $("#dim_ord").val(dim_ord);
	             },
	             buttons: [{
	            	 text:'确认',
	            	 iconCls: "icon-ok",
	            	 handler: function () {
	            		 edit(dim_code);
	                 }
	             },{
	            	 text:'取消',
	            	 iconCls: "icon-cancel",
	            	 handler: function () {
	            		 $('#d-dlg').dialog('close');
	                 }
	             }
	             ]
			 });
	  }
	  function edit(dim_code){
			 var _param={};
			 _param.dim_table = $('#dim_table').val();
			 _param.cube_code = '${param.cube_code }';
			 _param.dim_code = dim_code;
			 _param.column_code = $('#dim_colmun').val();
			 _param.dim_ord =  $('#dim_ord').val();
			 $.messager.confirm('提示信息', "确认修改维度的关联信息吗？", function(r){
				if (r){
				  $.ajax({
					type:'post',
					url:'<e:url value="/pages/kpi/cube/listAction.jsp?eaction=uptDim"/>',
					data:_param,
					async : false,
					success:function(data){
						var _data= $.parseJSON(data);
						if(_data!=0){
							$.messager.alert("提示信息！", "关联信息修改成功！", "info",function(){
								$('#d-dlg').dialog('close');
								$('#dimTable').datagrid('load');
							});
						}
					}
				  });
				}
			 });
		  }
	</script>
	</head> 
	<body>
	<form id="downloadExcel_R" method="post" action="<e:url value="downloadExcelFile.e"/>">
		<input type="hidden" name="doc_type" value="dim_r">
    </form>
   
		<div id="tbar">
		<h2>维度列表</h2>
			<div class="search-area">
<!-- 					纬度编码: <input id="dim_code" type="text" name="dim_code"  style="width:15%"/> -->
					维表表名: <input id="table_name" type="text" name="table_name"  style="width:15%"/>
					维表编码列:<input id="table_column" type="text" name="table_column"  style="width:15%"/>
					<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doSearch();">查询</a>
					<a id="dyKpiCube" class="easyui-linkbutton"  href="javascript:void(0);" onclick="dyKpiCube();">添加维度</a>
					<a id="download" class="easyui-linkbutton"  href="javascript:void(0);" onclick="javascript:$('#downloadExcel_R').submit();">Excel模版</a>
					<a class="easyui-linkbutton" href='<e:url value="/pages/kpi/cube/CubeManager.jsp"/>'>返回</a>
			</div>
		</div>
		<c:datagrid url="/pages/kpi/cube/listAction.jsp?eaction=dimlist&cube_code=${param.cube_code }" id="dimTable" style="width:auto;" pagination="true" fit="true" download="false" nowrap="false" border="false" toolbar="#tbar">
			<thead>
				<tr>
					<th field="DIM_CODE" width="70" align="center">
						纬度编码
					</th>
					<th field="TABLE_NAME" width="100" align="center">
						数据表名
					</th>
					<th field="COLUMN_CODE" width="100" align="center">
						数据表维度字段
					</th>
					<th field="COLUMN_DESC" width="80" align="center">
						数据表维度字段描述
					</th>
					<th field="cz" width="80" align="center" formatter="formateCubeDimCz">
						操作
					</th>
				</tr>
			</thead>
		</c:datagrid>
		<div id="f-dlg" class="easyui-dialog" title="关联维度" style="width:1000px;height:500px;" data-options="closed:true,modal:true">
			<div style="width:50%; height:100%;float:left;">
				<div id="tb2">
					<h2>未关联维度</h2>
					<form id="loginLogForm" method="post" name="loginLogForm" action="">
						<div class="search-area">
<!-- 							 维度编码: <input  type="text" name="needDimCode" id="needDimCode" value="" class="easyui-validatebox" validType="length[0,30]" style="width: 80px"> -->
							 维表表名: <input  type="text" name="needDimName" id="needDimName" value="" class="easyui-validatebox" validType="length[0,100]" style="width: 120px">
							<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQueryForNeedSelect()">查询</a>
						</div>
					</form>
				</div>
				<c:datagrid url="/pages/kpi/cube/listAction.jsp?eaction=dimNotlist&cube_code=${param.cube_code }" id="needSelectDimTable" pageSize="5" fit="true" toolbar="#tb2">
					<thead>
						<tr>
							<th field="DIM_CODE" width="70" align="center">
								纬度编码
							</th>
							<th field="CODE_TABLE" width="100" align="center">
								维表表名
							</th>
<!-- 							<th field="COLUMN_CODE" width="100" align="center"> -->
<!-- 								维表编码列 -->
<!-- 							</th> -->
							<th field="CODE_TABLE_DESC" width="80" align="center">
								维表描述列
							</th>
							<th field="CZ2" width="80" align="center" formatter="formatterCZ2">
								操作
							</th>
						</tr>
					</thead>
				</c:datagrid>
			</div>
			<div style="width:50%; height:100%;float:left;">
				<div id="tb1">
					<h2>己关联维度</h2>
					<form id="loginLogForm" method="post" name="loginLogForm" action="">
						<div class="search-area">
<!-- 							维度编码:<input  type="text" name="hasDimCode" id="hasDimCode" value="" class="easyui-validatebox" validType="length[0,30]" style="width: 80px"> -->
							维表表名：<input  type="text" name="hasDimName" id="hasDimName" value="" class="easyui-validatebox" validType="length[0,100]" style="width: 120px">
							<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQueryForHasSelect()">查询</a>
						</div>
					</form>
				</div>
				<c:datagrid url="/pages/kpi/cube/listAction.jsp?eaction=dimlist&cube_code=${param.cube_code }" id="hasSelectDimTable" pageSize="10" toolbar="#tb1" fit="true" border="false">
					<thead>
						<tr>
							<th field="DIM_CODE" width="70" align="center">
								纬度编码
							</th>
<!-- 							<th field="TABLE_NAME" width="100" align="center"> -->
<!-- 								维表表名 -->
<!-- 							</th> -->
							<th field="COLUMN_CODE" width="100" align="center">
								维度字段
							</th>
							<th field="COLUMN_DESC" width="80" align="center">
								维度字段描述
							</th>
							<th field="CZ" field="CZ" width="80" align="center" formatter="formatterCZ">
								操作
							</th>
						</tr>
					</thead>
				</c:datagrid>
			</div>
		</div>
		<div id="d-dlg" title="关联维度" >
			<table class="windowsTable dialogForm">
				<tr>
					<th>数据表名</th>
					<td><input name="dim_table" class="dimInputStyle" id="dim_table"></td>
				</tr>
				<tr>
					<th>数据表维度字段</th>
					<td><input name="dim_colmun" class="dimInputStyle"  id="dim_colmun"></td>
				</tr>
				<tr>
					<th>展现顺序</th>
					<td><input name="dim_ord" class="dimInputStyle"  id="dim_ord"></td>
				</tr>
			</table>
		</div>
	</body>
</html>