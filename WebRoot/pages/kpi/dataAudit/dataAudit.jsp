<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!--/eframe_oracle/src/sqlmap/db2/kpi/dataAudit.xml  -->
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources> 
<e:q4o var="auditStep">select STEP_ID,STEP_NAME,CURR_STATUS,NEXT_STATUS from X_KPI_AUDIT_STEP where step_id='3'</e:q4o>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    
    <title>数据定义审核</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<e:style value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
	<e:style value="/resources/easyResources/component/easyui/icon.css" />
	<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
	<script type="text/javascript">
		function query(){
			var params={};
			params.kpi_name=$('#kpi_name').val();
			params.cube_code = $("#cube_code").combobox("getValue");
			params.kpi_category = $("#kpi_category").combotree("getValue");
			$('#kpiTable').datagrid('options').queryParams=params;
			$('#kpiTable').datagrid('reload');
		}
		function fr(value,row,index){
				return '<a id="kpi_status_1" href="javascript:void(0)" class="btn-submit1" style="color:green" onclick="openDlg(\'' + row.V1 + '\',\'' + row.V5 + '\',\'' + row.V0 + '\')">查看数据并审核</a>';
		}
		function audit(){
			var _isData = $('#kpiData').datagrid('getRows').length;
			/* if(_isData == 0){
				$.messager.alert('提示信息','指标数据末生成，不能进行审核!','info');
				return false;
			} */
			$.messager.confirm('审核','您确认要进行当前操作吗?',function(r){
				if(r){
					var _kpi_code = $('#kpiCode').val();
					var _kpi_version = $('#kpiVersion').val();
					var kpiKey = $('#kpiKey').val();
					var _kpi_status = $('#a_status').find("option:selected").val();
					var _audit_opinion = $('#audit_opinion').val();
					var _audit_flag = $('#audit_flag').val();
					$('#a_dlg').dialog('close');
					$.post("../kpiManager/kpiQueryAndAuditAction.jsp?eaction=audit",{"kpi_code":_kpi_code,"kpi_version":_kpi_version,"kpi_key":kpiKey,"kpi_status":_kpi_status,"audit_opinion":_audit_opinion,"audit_flag":_audit_flag,"currStatus":"${auditStep.CURR_STATUS}","nextStatus":"${auditStep.NEXT_STATUS}"},function(){
						$('#kpiTable').datagrid('reload');
						$.messager.alert('提示信息','指标数据审核完成!','info');
					}).error(function(){
						$.messager.alert('提示信息','指标数据审核失败!','info');
					});
				}
			});
		}
		function openDlg(kpi_code,kpi_version,kpi_key){
			$('#kpiCode').val(kpi_code);
			$('#kpiVersion').val(kpi_version);
			$('#kpiKey').val(kpi_key);
			$('#kpiData').datagrid('options').url = 'dataAuditAction.jsp?eaction=queryData&kpi_code='+kpi_code+'&kpi_version='+kpi_version;
			$('#kpiData').datagrid('reload');
			$('#a_dlg').dialog('open');
		}
		$(function(){
			$('#a_dlg').dialog({
				title:"审核",
				closed:true,
				modal:true,
				height:360,
				top:100,
				buttons:[{
					text:"确认",
					id:"aDlgButtons",
					handler:function(){
						audit();
					}
				}]
			});
			$('#cube_code').combobox({
				editable : false,
// 				width : 200,
				url : '<e:url value="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=queryCube"/>',
				valueField : 'CUBE_CODE',
				textField : 'CUBE_NAME',
				value :'',
				onSelect : function(_value) {
// 					$('#kpi_category').combotree({
// 					    url: '<e:url value="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=queryCategory&cube_code="/>'+_value,
// 					    required: true
// 					});
					$('#kpi_category').combotree('reload');
				}
			});
			$('#kpi_category').combotree({
			    url: '<e:url value="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=queryCategory"/>',
			    required: true,
			    value:'0',
			    onBeforeExpand:function(node) {
			    	var _cube_code = $('#cube_code').combobox("getValue");
			    	if(_cube_code==null ||_cube_code==' '){
			    		return false;
			    	}
			    	$('#kpi_category').combotree("tree").tree("options").url = '<e:url value="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=queryCategory&cube_code="/>'+_cube_code;
			    }
			}); 
		});
		function fView(value,row,index){
			return '<a href="javascript:void(0)" onclick="winView('+row.V0+')">'+value+'</a>';
		}		
		function winView(kpi_key){
			window.open('../../../formulaKpiLook.e?kpi_key='+kpi_key);
		}
		function hisView(kpi_code) {
	        window.open('../version/kpi_version.jsp?kpi_code='+kpi_code,'历史版本', 'height=480, width=800, top=60, left=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');

		}
		function frhis(value,row,index) {
			return '<a id="kpi_status_1" href="javascript:void(0)" onclick="hisView(\''+ row.V1 +'\')">'+value+'</a>';
		}
	</script>
  </head>
  
  <body>
  	<div id="tb">
  		<h2>指标数据审核</h2>
  		<div class="search-area">
			 数据魔方：<input id="cube_code">
			 指标分类：<input id="kpi_category">
  			 指标名称： <input type="text" id="kpi_name"/>
  			<a class="easyui-linkbutton" onclick="query()">查询</a>
  		</div>
  	</div>
    <c:datagrid url="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=query&queryFlag=4" id="kpiTable" singleSelect="true" nowrap="true" fit="true" toolbar="#tb" pageSize="20">
    	<thead>
    		<tr>
				<th field="V19" width="20%" formatter="fView">指标编码</th>
    			<th field="V2" width="20%" formatter="fView">指标名称</th>
    			<th field="V5" width="6%" formatter="frhis">指标版本</th>
    			<th field="V18" width="13%">指标类型</th>
   				<th field="V11" width="13%">指标分类</th>
    			<th field="V12" width="10%">创建人</th>
    			<th field="V13" width="10%">创建时间</th>
    			<th field="V14" width="10%">修改人</th>
    			<th field="V15" width="10%">修改时间</th>
    			<th field="V10" width="12%" formatter="fr">操作</th>
    		</tr>
    	</thead>
    </c:datagrid>

    <div id="a_dlg" style="width:600px;height:500px;">		
    	<input type="hidden" id="kpiKey">
		<input type="hidden" id="kpiCode">
		<input type="hidden" id="kpiVersion">
		<input type="hidden" id="audit_flag" VALUE="3">
	    <div style="height:100px;">
			<c:datagrid url="" id="kpiData" singleSelect="false" fit="true"  pagination="false">
				<thead>
				<tr>
					<th field="KPI_NAME" width="30%">指标名称</th>
					<th field="KPI_VERSION" width="10%">指标版本</th>
					<th field="ACCT" width="20%">指标账期</th>
					<th field="KPI_RECORDS" width="20%">指标值</th>
				</tr>
				</thead>
			</c:datagrid>
	    </div>
	    <div class="messageText">
	    <p><span>审核结果：</span><select id="a_status" style="width: 45%;">
	    		<option value="2">审核通过</option>
	    		<option value="3">审核未通过</option>
	    	</select></p>
	    	<p><span>审核意见：</span><textarea rows="5" cols="60" id="audit_opinion" name="audit_opinion"></textarea>
	    	</p>
	    	</div>
    </div>
  </body>
</html>
