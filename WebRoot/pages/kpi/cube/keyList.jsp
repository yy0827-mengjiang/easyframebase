<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="cube" sql="kpi.view.cubeDetail"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>主键列表</title>
		<c:resources type="easyui"  style="${ThemeStyle }"/>
		<e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/resources/themes/blue/boncBlue.css"/>
	<script type="text/javascript">
	  function doSearch(){
		  var params = {};
	    	params.key_code=$('#key_code').val();
	    	params.table_name=$('#table_name').val();
	        params.table_column=$('#table_column').val();
	        $('#keyTable').datagrid('options').queryParams=params;
			$('#keyTable').datagrid('load');
	  }
	  
	  function dyKpiCube(){
		  $('#ACTION').val('insert');
		  $('#ID').val('');
		  $('#TABLE_NAME').val('');
		  $('#COLUMN_NAME').val('');
		  $('#COLUMN_DESC').val('');
		  $('#COLUMN_IDX').val('');
		  $('#f-dlg').dialog('open');  
	  }
	  function attrAgree(){
		  var _param = {};
		  _param.ID = $('#ID').val();
		  _param.CUBE_CODE = $('#CUBE_CODE').val();
		  _param.TABLE_NAME = $('#TABLE_NAME').val();
		  _param.COLUMN_NAME = $('#COLUMN_NAME').val();
		  _param.COLUMN_DESC = $('#COLUMN_DESC').val();
		  _param.COLUMN_IDX = $('#COLUMN_IDX').val();
		  _param.ATTR_TYPE = $('#ATTR_TYPE').val();
		  var _url = '<e:url value="/pages/kpi/cube/listAction.jsp?eaction=addKey"/>';
		  var _info= '关联成功！';
		  if($('#ACTION').val()=='update'){
			  _url = '<e:url value="/pages/kpi/cube/listAction.jsp?eaction=updateKey"/>'; 
			  _info= '修改成功！';
		  }
		  $.messager.confirm('提示信息', "确认建立属性与魔方的关联吗？", function(r){
				if (r){
				  $.ajax({
						type:'post',
						url:_url,
						data:_param,
						async : false,
						success:function(data){
							var _data= $.parseJSON(data);
							if(_data!=0){
								$.messager.alert("提示信息！", _info, "info",function(){
									$('#f-dlg').dialog('close');
									$('#keyTable').datagrid('load');
								});
							}
						}
					  });
				  }
		  });
	  }
	  function formatterCZ(value,rowData){
		  return '<a href="javascript:void(0);" onclick="editKey(\''+rowData.ID+'\')">编辑</a>&nbsp;&nbsp;<a href="javascript:void(0);" onclick="delKey(\''+rowData.ID+'\')">删除</a>';
	  }
	  function editKey(id){
		  var _param = {};
		  _param.id = id;
		  $.ajax({
				type:'post',
				url:'<e:url value="/pages/kpi/cube/listAction.jsp?eaction=editKey"/>',
				data:_param,
				async : false,
				success:function(data){
					var _data= $.parseJSON(data);
					$('#ACTION').val('update');
					$('#ID').val($(_data).attr('ID'));
					$('#TABLE_NAME').val($(_data).attr('TABLE_NAME'));
					$('#COLUMN_NAME').val($(_data).attr('COLUMN_CODE'));
					$('#COLUMN_DESC').val($(_data).attr('COLUMN_DESC'));
					$('#COLUMN_IDX').val($(_data).attr('COLUMN_IDX'));
					$('#f-dlg').dialog('open'); 
				}
			  });
	  }
	  function delKey(id){
		  $.messager.confirm('提示信息', "确认解除属性与魔方的关联吗？", function(r){
				if (r){
					 var _param = {};
					  _param.ID = id;
					  $.ajax({
						type:'post',
						url:'<e:url value="/pages/kpi/cube/listAction.jsp?eaction=delKey"/>',
						data:_param,
						async : false,
						success:function(data){
							var _data= $.parseJSON(data);
							if(_data!=0){
								$.messager.alert("提示信息！", "关系解除成功！", "info",function(){
									$('#keyTable').datagrid('load');
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
		<input type="hidden" name="doc_type" value="key_r">
    </form>
		<div id="tbar">
		<h2>主键列表</h2>
			<div class="search-area">
<!-- 					主键编码: <input id="key_code" type="text" name="key_code"  style="width:15%"/> -->
					表名: <input id="table_name" type="text" name="table_name"  style="width:15%"/>
					字段名:<input id="table_column" type="text" name="table_column"  style="width:15%"/>
					<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doSearch();">查询</a>
				<a id="dyKpiCube" class="easyui-linkbutton"  href="javascript:void(0);" onclick="dyKpiCube();">设置关联</a>
				<a id="download" class="easyui-linkbutton"  href="javascript:void(0);" onclick="javascript:$('#downloadExcel_R').submit();">Excel模版</a>
				<a class="easyui-linkbutton" href='<e:url value="/pages/kpi/cube/CubeManager.jsp"/>'>返回</a>
			</div>
		</div>
		<c:datagrid url="/pages/kpi/cube/listAction.jsp?eaction=keylist&cube_code=${param.cube_code }" id="keyTable" style="width:auto;" pagination="true" fit="true" download="false" nowrap="false" border="false" toolbar="#tbar">
			<thead>
				<tr>
<!-- 					<th field="ID" width="70" align="center"> -->
<!-- 						主键编码 -->
<!-- 					</th> -->
					<th field="TABLE_NAME" width="100" align="center">
						表名
					</th>
					<th field="COLUMN_CODE" width="100" align="center">
						主键列
					</th>
					<th field="COLUMN_DESC" width="100" align="center">
						主键列描述
					</th>
					<th field="CZ" width="80" align="center" formatter="formatterCZ">
						操作
					</th>
				</tr>
			</thead>
		</c:datagrid>
		<div id="f-dlg" class="easyui-dialog" title="关联主键" style="width:600px;height:280px;" data-options="closed:true,modal:true"  buttons="#dlg-buttons1">
			<table class="windowsTable">
			<colgroup>
			<col width="20%" />
			<col width="30%" />
			<col width="20%" />
			<col width="30%" />
			</colgroup>
				<tr>
					<th>魔方：</th>
					<td colspan="3">${cube.CUBE_NAME }
						<input type="hidden" name="ACTION" id="ACTION" value="insert">
						<input  type="hidden" name="ID" id="ID" value="">
						<input type="hidden" name="CUBE_CODE" id="CUBE_CODE" value="${param.cube_code }">
					</td>
				</tr>
				<tr>
					<th>表名：</th>
					<td><input type="text" name="TABLE_NAME" id="TABLE_NAME" value="" style="width: 90%"></td>
					<th>对应列名：</th>
					<td><input type="text" name="COLUMN_NAME" id="COLUMN_NAME" value="" style="width: 90%"><B style="color: red;">&nbsp;*</B></td>
					
				</tr>
				<tr>
					<th>对应列描述：</th>
					<td><input type="text" name="COLUMN_DESC" id="COLUMN_DESC" value="" style="width: 90%"><B style="color: red;">&nbsp;*</B></td>
					<th>主键排序：</th>
					<td>
					<input name="COLUMN_IDX" id="COLUMN_IDX" type="text" class="easyui-numberbox"  style="width: 90%"/><B style="color: red;">&nbsp;*</B>
					</td>
				</tr>
			</table>
		</div>
		<div id="dlg-buttons1"><a href="javascript:void(0);" class="easyui-linkbutton" onclick="attrAgree()">确认</a></div>
	</body>
</html>