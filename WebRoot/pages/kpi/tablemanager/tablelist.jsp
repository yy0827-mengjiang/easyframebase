<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!--/eframe_oracle/src/sqlmap/db2/kpi/tableManager.xml-->
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>影响范围</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<e:style value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
<e:style value="/resources/easyResources/component/easyui/icon.css" />
<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
<script type="text/javascript">
	$(function() {
		$('#dlg').dialog({
			title : "新增",
			closed : true,
			modal : true,
			height : 280,
			width : 300,
			top : 100,
			buttons : [ {
				text : "确认",
				handler : function() {
					addTable();
				}
			} ]
		});
	});
	function openDialog() {
		$("#eaction").val('tableINSERT');
		$("#tableName0").val('');
		$("#tableDes0").val('');
		$("#acctType0").val('');
		$("#kpiType0").val('');
		$("#dlg").dialog('open');
	}
	function addTable(){
		var _param={};
		_param.eaction=$("#eaction").val();
		_param.id=$("#id").val();
		_param.tableName=$("#tableName0").val();
		_param.tableDes=$("#tableDes0").val();
		_param.acctType=$("#acctType0").val();
		_param.kpiType=$("#kpiType0").val();
		
		if(_param.tableName==null||_param.tableName==''){
			$.messager.alert('提示信息！', '请输入表名', 'info',function(){
				_param={};
			});
			return false;
		}
		if(_param.acctType==null||_param.acctType==''){
			$.messager.alert('提示信息！', '请选择账期类型', 'info',function(){
				_param={};
			});
			return false;
		}
		if(_param.kpiType==null||_param.kpiType==''){
			$.messager.alert('提示信息！', '请选择指标类型', 'info',function(){
				_param={};
			});
			return false;
		}
		$.messager.confirm('提示信息', '是否保存信息?', function(r){
			if (r){
				$.get('tableManagerAction.jsp',_param,function(data){
					query();	
				});
				$("#dlg").dialog('close');
			}
		});
	}
	
	function query(){
		var _params = {};
		_params.tableName = $("#tabName").val();
		_params.acctType = $("#acctType").val();
		_params.kpiType = $("#kpiType").val();
		$("#tableList").datagrid("options").queryParams=_params;
		$("#tableList").datagrid("reload");
	}
	function oper(value,rowData){
		return '<a href="javascript:void(0)" onclick="update(\'' + rowData.ID + '\',\'' + rowData.TABLENAME + '\',\'' + rowData.TABLEDES + '\',\'' + rowData.ACCTTYPE + '\',\'' + rowData.KPI_TYPE + '\')">编辑</a>&nbsp;&nbsp;<a href="javascript:void(0)" onclick="del(\'' + rowData.ID + '\')">删除</a>';
	}
	
	function update(id,tabName,tabDes,acctType,kpiType){
		$("#eaction").val('tableUPDATE');
		$('#id').val(id);
		$('#tableName0').val(tabName);
		$('#tableDes0').val(tabDes);
		$('#acctType0').val(acctType);
		$('#kpiType0').val(kpiType);
		$("#dlg").dialog('open');
	}
	
	function del(id){
		$.messager.confirm('提示信息', '确定删除吗?', function(r){
			if (r){
				var _param={};
				_param.id=id;
				_param.eaction='tableDELETE';
				$.get('tableManagerAction.jsp',_param,function(data){
					query();	
				});
			}
		});
	}
</script>
</head>

<body>
	<div id="tb">
		<h2>指标结果目标表管理</h2>
		<div class="search-area">
			表名：<input type="text" id="tabName">&nbsp;&nbsp;&nbsp;&nbsp;
			账期类型：<select id="acctType">
						<option value=''>--请选择--
						<option value='1'>日账期
						<option value='2'>月账期
				   </select> 
			指标类型：<select id="kpiType">
						<option value=''>--请选择--
						<option value='1'>基础指标
						<option value='2'>复合指标
				   </select>
			<a href="#" class="easyui-linkbutton" onclick="query()">查询</a>&nbsp;&nbsp; 
			<a href="#" class="easyui-linkbutton" onclick="openDialog()">新增</a>
		</div>
	</div>
	<c:datagrid
		url="/pages/kpi/tablemanager/tableManagerAction.jsp?eaction=queryList"
		id="tableList" singleSelect="true" nowrap="true" fit="true"
		toolbar="#tb">
		<thead>
			<tr>
				<th field="TABLENAME" width="20%" align="left">表名</th>
				<th field="TABLEDES" width="20%" align="left">中文表名</th>
				<th field="ACCTTYPEDES" width="20%" align="left">账期类型</th>
				<th field="KPITYPEDES" width="20%" align="left">指标类型</th>
				<th field="OPER" width="20%" align="left" formatter="oper">指标类型</th>
			</tr>
		</thead>
	</c:datagrid>
	<div id="dlg">
		<input type="hidden" name="eaction" id="eaction">
		<input type="hidden" name="id" id="id">
		<table class="windowsTable">
			<tr>
				<td>目标表名：</td>
				<td><input type="text" id="tableName0" name="tableName0"></td>
			</tr>
			<tr>
				<td>目标表中文名：</td>
				<td><input type="text" id="tableDes0" name="tableDes0"></td>
			</tr>
			<tr>
				<td>账期类型：</td>
				<td><select id="acctType0">
						<option value=''>--请选择--
						<option value='1'>日账期
						<option value='2'>月账期
					</select>
				</td>
			</tr>
			<tr>
				<td>指标类型：</td>
				<td><select id="kpiType0">
						<option value=''>--请选择--
						<option value='1'>基础指标
						<option value='2'>复合指标
				   </select>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>
