<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<a:base />
		<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources>
		<title>全局数据集管理</title>
		<link rel="stylesheet" href="pages/xbuilder/resources/component/gridster/jquery.gridster.min.css"/>
		<link rel="stylesheet" href="pages/xbuilder/resources/component/gridster/style.css"/>
		<e:style value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
		<e:style value="/resources/easyResources/component/easyui/icon.css" />
		<e:script value="/resources/easyResources/component/easyui/jquery.easyui.min.js" />
		<e:script value="/resources/easyResources/component/easyui/locale/easyui-lang-zh_CN.js" />
		<e:script value="/resources/easyResources/component/easyui/plugins/datagrid-detailview.js" />
	    <e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/resources/themes/blue/boncBlue.css"/>
		<e:style value="/pages/xbuilder/resources/component/jqueryui/themes/base/jquery.ui.selectable.css"/>
	    <e:style value="/pages/xbuilder/resources/component/icheck/icheck.css"/>
		<script type="text/javascript">
			$(window).resize(function(){
			 	$('#datasetTable').datagrid('resize');
			});
			 //查询
			function doQuery(){
				var info = {};
				info.glbdataset_name = $("#glbdataset_name").val();
				info.glbdataset_type = $("#glbdataset_type").val();
				info.create_user = $("#create_user").val();
				info.create_time_start = $('#create_time_start').datebox('getValue');
				info.create_time_end = $('#create_time_end').datebox('getValue');
		    	info.modify_time_start = $("#modify_time_start").datebox('getValue');
		    	info.modify_time_end = $("#modify_time_end").datebox('getValue');
				$('#datasetTable').datagrid('load',info);
			}
			function reportCZ(value,rowData){
				var upd =  '<a href="javascript:void(0);" class="btn-submit1" style="margin:0 5px;" onclick="updGlbDataSet(\''+rowData.GLBDATASET_ID+'\')">编辑</a>';
				var del =   '<a href="javascript:void(0);" class="btn-submit2" style="margin:0 5px;" onclick="delGlbDataSet(\''+rowData.GLBDATASET_ID+'\')">删除</a>';
<!--				var show =  '<a href="javascript:void(0);" class="btn-submit1" onclick="showSQL(\''+rowData.GLBDATASET_ID+'\')"><div id="div_'+rowData.GLBDATASET_ID+'" style="display:none">'+rowData.GLBDATASET_SQL+'</div>查看SQL</a>';-->
				var res = upd+del;
				return  res;
			}
			function updGlbDataSet(id){
				window.open(appBase + "/pages/xbuilder/dataset/GlobalDataSetSQL.jsp?id="+id+"&state=upd");
			}
			function addGlbDataSet(){
				window.open(appBase + "/pages/xbuilder/dataset/GlobalDataSetSQL.jsp");
			}
			function showSQL(rowIndex, field, value){
				if(field=='GLBDATASET_SQL'){
					$('#indlg').html('');
					var sql = value
					$('#indlg').text(sql);
					$('#dlg').dialog({
			            title: '查看SQL',
			            resizable: true,
			            width:815,
			            modal: true,
			            top:120
	       			});	
	       		}		
			}
			//格式化显示的sql，超过一定字符则截取字符
			function formattSql(value,rowData){
				value=value.length>70?(value.substr(0,70)+'...'):value;
				if(value!=null){
				    return '<div style="color:#199ed8;" class="sqlText" title="点击显示具体SQL">'+value+'</div>';
				}else{
				    return '';		
				}
			}
			function delGlbDataSet(id){
				$.messager.confirm('确认信息','确认删除该数据集吗?',function(r){  
					if(r){
						$.post(appBase+"/pages/xbuilder/dataset/GlobalDataSetManagertAction.jsp?eaction=DELETEBYID",{id:id},function(data){
							if(parseInt($.trim(data))>0){
								$.messager.alert("提示信息","删除成功","info");
								reloadGrid();
							}else{
								$.messager.alert("提示信息","删除失败","error");
							}
						});
					}
				});
			}
			function reloadGrid(){
				$("#datasetTable").datagrid("load",$("#datasetTable").datagrid("options").queryParams);
			}
			
	</script>
	</head>
	<body>
		<div id="tbar">
			<h2>全局数据集管理</h2>
			<div class="search-area">
				数据集名称：<input type="text" style="width: 100px" id="glbdataset_name" name="glbdataset_name" />
				创建时间：<c:datebox style="width:100px" id="create_time_start" name="create_time_start" required="false" format="yyyymmdd"/>—<c:datebox style="width:100px" id="create_time_end" name="create_time_end" required="false" format="yyyymmdd"/>
				修改时间：<c:datebox style="width:100px" id="modify_time_start" name="modify_time_start" required="false" format="yyyymmdd"/>—<c:datebox style="width:100px" id="modify_time_end" name="modify_time_end" required="false" format="yyyymmdd"/>
				<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQuery()">查询</a>
				<a href="javascript:void(0);" class="easyui-linkbutton easyui-linkbutton-green" onclick="addGlbDataSet()">新增</a>
			</div>
		</div>
		<c:datagrid
			url="pages/xbuilder/dataset/GlobalDataSetManagertAction.jsp?eaction=LIST" fit="true" border="false"
			id="datasetTable" pageSize="15" style="width:auto;" onClickCell="showSQL" nowrap="false"
			download="true" toolbar="#tbar">
			<thead frozen="true">
				<tr>
					<th field="GLBDATASET_NAME" width="190" align="center">
						数据集名称
					</th>
				</tr>
			</thead>
			<thead>
				<tr>
					<th field="DB_NAME" width="110" align="center">
						扩展数据源
					</th>
					<th field="GLBDATASET_SQL" width="210" align="center" nowrap="false" formatter="formattSql">
						SQL
					</th>
					<th field="CREATE_USER_NAME" width="60" align="center">
						创建人
					</th>
					<th field="CREATE_TIME" width="110" align="center" formatter="formatDAT_datasetTable">
						创建时间
					</th>
					<th field="MODIFY_USER_NAME" width="60" align="center">
						修改人
					</th>
					<th field="MODIFY_TIME" width="110" align="center" formatter="formatDAT_datasetTable">
						修改时间
					</th>
					<th field="cz" width="80" align="center" formatter="reportCZ">
						操作
					</th>
				</tr>
			</thead>
		</c:datagrid>
<!--		查看sql的弹出框-->
		<div id="dlg">
			<div id="indlg" style="margin: 10px;word-break:break-all;"></div>
		</div>
	</body>
</html>