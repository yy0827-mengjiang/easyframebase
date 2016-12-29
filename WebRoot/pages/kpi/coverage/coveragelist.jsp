<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources>
<e:q4o var="kpiInfo">
	SELECT * FROM X_KPI_INFO T WHERE T.KPI_KEY = '${param.kpi_key }'
</e:q4o>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>影响范围</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<e:style
	value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
<e:style value="/resources/easyResources/component/easyui/icon.css" />
<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
<script type="text/javascript">
	$(function() {
		var data = getDate();
		var options = {
			required : "true",
			formatter : function(date) {
				var y = date.getFullYear();
				var m = date.getMonth() + 1;
				var d = date.getDate();
				return y + "-" + (m < 10 ? ("0" + m) : m) + "-" + d;
			},
			
		};

		$("#start").datebox(options);
		$("#end").datebox(options);
		
		$('#dlg').dialog({
			title:"新增",
			closed:true,
			modal:true,
			height:240,
			width:300,
			top:100,
			buttons:[{
				text:"确认",
				handler:function(){
					addUsearea();
				}
			}]
		});
	});

	function getDate() {
		var date = new Date();
		var day = date.getDate();
		var month = date.getMonth() + 1;
		var year = date.getFullYear();
		if (month >= 10) {
			month += 1;
		} else {
			month = "0" + month;
		}
		return year + "年" + month + "月";

	}
	
	function query(){
		var _params = {};
		_params.reportName = $("#reportName").val();
		_params.start = $("#start").datebox("getValue");
		_params.end = $("#end").datebox("getValue");
		_params.code = $("#kpiCode").val();
		_params.version = $("#kpiVersion").val();
		$("#coverage").datagrid("options").queryParams=_params;
		$("#coverage").datagrid("reload");
	}
	
	function add(){
		$("#eaction").val("INSERT");
		$("#sys_name").val("");
		$("#report_name").val("");
		$("#dlg").dialog('open');
	}
	
	function addUsearea(){
		$.messager.confirm('提示信息', '是否保存信息?', function(r){
			if (r){
				var _param={};
				_param.eaction=$("#eaction").val();
				_param.kpi_code=$("#kpi_code").val();
				_param.service_key=$("#service_key").val();
				_param.kpi_name=$("#kpi_name").val();
				_param.kpi_version=$("#kpi_version").val();
				_param.sys_name=$("#sys_name").val();
				_param.report_name=$("#report_name").val();
				_param.usearea_id=$("#usearea_id").val();
				$.get('coverageAction.jsp',_param,function(data){
					//alert($.trim(data));
					query();	
				});
				$("#dlg").dialog('close');
			}
		});
	}
	
	function oper(value,rowData){
		console.log(rowData);
		return '<a href="javascript:void(0)" onclick="update(\''+rowData.SYS_NAME+'\',\''+rowData.REPORT_NAME+'\',\''+rowData.USEAREA_ID+'\')">编辑</a>&nbsp;&nbsp;<a href="javascript:void(0)" onclick="del(\''+rowData.USEAREA_ID+'\')">删除</a>';
	}
	
	function update(sysName,reportName,id){
		$("#eaction").val("UPDATE");
		$("#sys_name").val(sysName);
		$("#report_name").val(reportName);
		$("#usearea_id").val(id);
		$("#dlg").dialog('open');
	}
	function del(id){
		$.messager.confirm('提示信息', '确定删除吗?', function(r){
			if (r){
				var _param={};
				_param.usearea_id=id;
				_param.eaction='DELETE';
				$.get('coverageAction.jsp',_param,function(data){
					query();	
				});
			}
		});
	}
</script>
</head>

<body>
	<input type="hidden" id="kpiCode" value="${kpiInfo.KPI_CODE }">
	<input type="hidden" id="kpiVersion" value="${kpiInfo.KPI_VERSION }">
	<div id="tb">
		<h2>影响范围</h2>
		<div class="search-area">
			报表名称：<input type="text" id="reportName">&nbsp;&nbsp;&nbsp;&nbsp;
			创建时间：<input type="text" id="start"> - <input type="text" id="end">&nbsp;&nbsp;
				   <a href="javascript:void(0)" class="easyui-linkbutton" onclick="query()">查询</a>
		</div>
	</div>
	<c:datagrid
		url="/pages/kpi/coverage/coverageAction.jsp?eaction=querylist&code=${kpiInfo.KPI_CODE }&version=${kpiInfo.KPI_VERSION }"
		id="coverage" singleSelect="true" nowrap="true" fit="true"
		toolbar="#tb">
		<thead>
			<tr>
				<th field="SERVICE_KEY" width=15% " align="left">指标编码</th>
				<th field="KPI_NAME" width="18%" align="left">指标名称</th>
				<th field="KPI_VERSION" width="15%" align="left">指标版本</th>
				<th field="SYS_NAME" width="20%" align="left">系统名称</th>
				<th field="REPORT_NAME" width="15%" align="left">报表名称</th>
				<th field="CREATE_TIME" width="12%" align="left">创建时间</th>
				<th field="CREATE_USER" width="10%" align="left">创建人</th>
			</tr>
		</thead>
	</c:datagrid>
	
</body>
</html>
