<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources> 
<e:q4l var="cube">select t.cube_code,t.cube_name  from x_kpi_cube t where t.cube_status ='1' order by t.cube_code</e:q4l>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    
    <title>指标查询</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<e:style value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
	<e:style value="/resources/easyResources/component/easyui/icon.css" />
	<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
	<e:script value="/pages/xbuilder/resources/scripts/base64.js"/>
	<script type="text/javascript">
		function query(){
			var params={};
			params.service_key = $("#service_key").val();
			params.kpi_name=$('#kpi_name').val();
			params.cube_code =$("#cube_code").combobox("getValue");
			params.kpi_status = $("#kpi_status").combobox("getValue");
			params.kpi_category = $("#kpi_category").combotree("getValue");
			$('#kpiTable').datagrid('options').queryParams=params;
			$('#kpiTable').datagrid('reload');
		}
		function fr(value,row,index){
			var edit = ''; 
			var del = '';
			if(row.V19 == "1") {
				if(row.V7 == '3') {
					edit = '&nbsp;&nbsp;<a href="javascript:void(0)" class="btn-submit1" style="color:green" onclick="openDlg(\'' + row.V1 + '\',\'' + row.V12 + '\',\'' + row.V19 + '\')">编辑</a>';
				} else if (row.V7 == '8') {
					del = '&nbsp;&nbsp;--';
	 			} else if (row.V7 == '2') {
	 				del = '<a id="kpi_status_1" href="javascript:void(0)" class="btn-submit1" style="color:green" onclick="delKpi(\'' + row.V1 + '\',\'' + row.V2 + '\',\'' + row.V5 + '\',\'' + row.V7 + '\',\'' + row.V19 + '\')">删除</a>';
	 			} 
				if(del == '') {
					if(edit == '') {
						return '&nbsp;&nbsp;&nbsp;&nbsp;--';
					} else {
						return edit;
					}
				} else { 
					return edit + '&nbsp;&nbsp;' + del;
				}
			} else {
				edit = '<a href="javascript:void(0)" class="btn-submit1" style="color:green" onclick="openDlg(\'' + row.V1 + '\',\'' + row.V12 + '\',\'' + row.V19 + '\')">编辑</a>&nbsp;';
 				del =  '<a id="kpi_status_2" href="javascript:void(0)" class="btn-submit1" style="color:green" onclick="delKpi(\'' + row.V1 + '\',\'' + row.V2 + '\',\'' + row.V5 + '\',\'' + row.V7 + '\',\'' + row.V19 + '\')">删除</a>';
				return  '&nbsp;&nbsp;' +del;
			}
		}
		function fkpiStatus(value, row, index) {
			if(value == "0" && row.V19 == "1") {
				return "指标定义审核";
			} else if (value == "1" && row.V19 == "1") {
				return "指标技术审核";
			} else if (value == "2" && row.V19 == "1" ) {
				return "在线指标";
			} else if (value == "3" && row.V19 == "1") {
				return "审核不通过";
			} else if (value == "8" && row.V19 == "1") {
				return "下线指标";
			} else if (value == "9" && row.V19 == "1") {
				return "指标数据审核";
			} else if (value== "1" && row.V19 == "2") {
				return "在线指标";
			}
		}
		function openDlg(kpi_key,cube_code){
			window.location.href='newKpiManager.jsp?kpi_key='+kpi_key+'&cube_code='+cube_code + '&managerFlag=manager';
		}
		function delKpi(kpi_key,kpi_code,kpi_version,kpi_status,kpi_flag){
			$.messager.confirm('提示信息', "确认删除所选择的指标信息吗？", function(r){
				if (r){
					var url = '<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=deleteKpi"/>';
					if(kpi_flag == "2") {
						url = '<e:url value="/deleteBaseKpi.e"/>';
					}  
					$.ajax({
		 				type:'post',
					    url:'<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=vaildDelKpi"/>',
						data:{kpi_code:kpi_code,kpi_version:kpi_version,kpi_key:kpi_key},
						async : false,
						success:function(data){
							var _data = $.parseJSON($.trim(data));
							if(_data.length>0){
								var _text ="";
								for(var i = 0;i<_data.length;i++){
									if(i == _data.length-1) {
										_text += "["+_data[i].KPI_NAME+"]";
									} else {
										_text += "["+_data[i].KPI_NAME+"],";
									}
								}
								$.messager.alert("提示信息！", _text +" 等指标依赖于当前指标,不允许删除！", "info");
		    	        		return false;
							}else{
								$.ajax({
					 				type:'post',
					 				url: url,
									data:{"kpi_key":kpi_key,"kpi_code":kpi_code},
									success:function(data){
// 										var _data = $.parseJSON($.trim(data));
										 if(data==1){
											  $.messager.alert('提示信息','指标信息删除成功!','info');
											  $('#kpiTable').datagrid('reload');
										  } else {
											  $.messager.alert('提示信息','指标信息删除失败!','info');
										  }
									}
								});
							}
							
						}
					});
				}
			});
		}
		function frhis(value,row,index) {
			return '<a href="javascript:void(0)" onclick="hisView(\''+ row.V2 +'\')">'+value+'</a>';
		}
		function hisView(kpi_code) {
	        window.open('../version/kpi_version.jsp?kpi_code='+kpi_code,'历史版本', 'height=480, width=800, top=60, left=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');

		}
		function currView(value,row,index){
			if(value != null && value != "" && value !="null"){
				return '<a href="javascript:void(0)" onclick="winView(\''+row.V1+'\',\''+ row.V19 +'\',\''+ row.V12 +'\')">'+value+'</a>';
			} else {
				return "";
			}
		}		
		function winView(kpi_key,kpi_flag,cube_code){
			if(kpi_flag == "1") {
				window.open('../../../formulaKpiLook.e?kpi_key='+kpi_key);
			} else {
				window.open('../../../lookBaseKpi.e?id='+kpi_key+'&cube_code='+cube_code);
			}
		}
		function explainView(value,row,index) {
			if(value != null && value != null && value !="null") {
				return '<a href="javascript:void(0)" onclick="openDlg(\'1\',\''+ base64encode(utf16to8(row.V8)) +'\')">'+value+'</a>';
			} else {
				return '';
			}
		}
		function explainViewFr(value,row,index) {
			if(value != null && value != null && value !="null") {
				return '<a href="javascript:void(0)" onclick="openDlg(\'2\',\''+ base64encode(utf16to8(row.V9)) +'\')">'+value+'</a>';
			} else {
				return "";
			}
		}
		function openDlg(explain_flag,kpi_explain){
 			if(explain_flag == '1') {
				$("#other_data_dialog").dialog({title:"技术口径"});
			} else {
				$("#other_data_dialog").dialog({title:"业务口径"});
			}
			$('#other_data_dialog').dialog('open');
			$('#other_data_load').html(utf8to16(base64decode(kpi_explain)));
// 			$("#other_data_load").load('<e:url value="/pages/kpi/kpiManager/kpiQueryAudit.jsp"/>',{"kpi_key":kpi_key},function(data){
// 				$.parser.parse($("#other_data_load"));
// 			});
		}
		$(function(){
			$('#cube_code').combobox({
				editable : false,
// 				width : 200,
				url : '<e:url value="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=queryCube"/>',
				valueField : 'CUBE_CODE',
				textField : 'CUBE_NAME',
				value :' ',
				onSelect : function(_value) {
					if(_value == null || _value.CUBE_CODE == ' ') {
						$('#kpi_category').combotree('setValue', 0); 
					}  
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
			    	$('#kpi_category').combotree("tree").tree("options").url = '<e:url value="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=queryCategory&cube_code="/>'+_cube_code+'&id='+node.id;
			    }
			}); 
			$('#kpi_status').combobox({
				editable : false
			});
		});
	</script>
  </head>
  
  <body>
  	<div id="tb">
  		<h2>我的指标</h2>
  		<div class="search-area">
  		            指标编码：<input type="text" id="service_key"/>
  		            数据魔方：<input id="cube_code">
  		            指标分类：<input id="kpi_category">
		            指标状态：<select id="kpi_status">
                 		<option value="">--全部--</option>
               			<option value="2">在线指标</option>
        				<option value="0">指标定义审核</option>
						<option value="1">指标技术审核</option>
<!-- 						<option value="9">指标数据审核</option> -->
						<option value="3">审核不通过</option>
<!-- 						<option value="8">下线指标</option> -->
		           </select>
  			指标名称： <input type="text" id="kpi_name"/>
  			<a class="easyui-linkbutton" onclick="query()">查询</a>
  		</div>
  	</div>
    <c:datagrid url="pages/kpi/mykpi/myKpiAction.jsp?eaction=query&queryFlag=all" id="kpiTable" singleSelect="true" nowrap="true" fit="true" toolbar="#tb" pageSize="20">
    	<thead> 
    		<tr> 
				<th field="V3" width="80" formatter="currView">指标编码</th>
    			<th field="V20" width="100">指标魔方</th>
    			<th field="V4" width="100" formatter="currView">指标名称</th>
<!--     			<th field="V5" width="40" formatter="frhis">指标版本</th> -->
    			<th field="V8" width="100" formatter="explainView">技术口径</th>
    			<th field="V9" width="100" formatter="explainViewFr">业务口径</th>
    			<th field="V6" width="50">指标类型</th>
<!--    				<th field="V7" width="13%">指标分类</th> -->
   				<th field="V7" width="50" formatter="fkpiStatus">指标状态</th>
<!--     			<th field="V10" width="50">审核意见</th> -->
  	 			<th field="V13" width="40">创建人</th> 
		    	<th field="V14" width="80">创建时间</th>
  	 			<th field="V15" width="40">修改人</th> 
 			    <th field="V16" width="80">修改时间</th> 
<!--  			    <th field="V17" width="40">删除人</th>  -->
<!--     			<th field="V18" width="80">删除时间</th> -->
<!--     			<th field="V100" width="50" formatter="fr">操作</th> -->
    		</tr>
    	</thead>
    </c:datagrid>
    <div id="other_data_dialog" class="easyui-dialog" title="口径解释" data-options="closed:true,modal:true,top:80" style="width:350px; height:230px;">
			<div id="other_data_load" data-options="region:'center',fit:true">
			</div>
	</div> 
  </body>
</html>
