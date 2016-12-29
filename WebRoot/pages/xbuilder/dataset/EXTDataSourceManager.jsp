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
		<title>扩展数据源管理</title>
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
			 	$('#extDataSourceTable').datagrid('resize');
			});
			 //查询
			function doQuery(){
				var info = {};
				info.OWNER = $("#OWNER").val();
				info.TABLE_NAME = $("#TABLE_NAME").val();
				info.TABLE_DESC = $("#TABLE_DESC").val();
				info.EXT_DATASOURCE = $('#EXT_DATASOURCE').combobox('getValue');
				$('#extDataSourceTable').datagrid('load',info);
			}
			//datagruid格式化操作
			function reportCZ(value,rowData){
				var upd =  '<a href="javascript:void(0);" class="btn-submit1" onclick="updEXTDataSource(\''+rowData.ID+'\')">编辑</a>';
				var del =   '<a href="javascript:void(0);" class="btn-submit2" onclick="delEXTDataSource(\''+rowData.ID+'\')">删除</a>';
				var res = upd+del;
				return  res;
			}
			//修改扩展数据源
			function updEXTDataSource(id){
				$.post(appBase+"/pages/xbuilder/dataset/EXTDataSourceManagertAction.jsp?eaction=SELECTBYID",{id:id},function(data){
					clearForm();
					var jsonData = JSON.parse($.trim(data));
					$("#extDsID").val(id);
					$("#ADD_OWNER").val(jsonData.OWNER);
					$("#ADD_TABLE_NAME").val(jsonData.TABLE_NAME);
					$("#ADD_TABLE_DESC").val(jsonData.TABLE_DESC);
					$('#ADD_EXT_DATASOURCE').combobox('select', jsonData.EXT_DATASOURCE);
					validata();//加载验证
					//打开弹窗
					$('#dlg').dialog({
			            title: '修改扩展数据源',
			            resizable: false,
			            width: 400,
			            height: 300,
			            modal: true,
			            buttons: [{
			            text: '保存',
			            handler: function () {
			            	if(validata()){//通过验证才能提交
					            $.messager.confirm("确认信息", "确认修改该扩展数据源吗？", function (data) {  
						            if (data) {  
						            	saveAndCon("update");
				            			$('#dlg').dialog('close');
						            	return;
						            }  
						            else {  
						            	return;
						            }  
			        			});  
	        				}
			           	}},
			            {
			            text: '关闭',
			            handler: function () {
			            	$('#dlg').dialog('close');
			            }}
			            
			            ]
			        });
				});
				
			}
			//删除扩展数据源
			function delEXTDataSource(id){
				$.messager.confirm('确认信息','确认删除该扩展数据源吗?',function(r){  
					if(r){
						$.post(appBase+"/pages/xbuilder/dataset/EXTDataSourceManagertAction.jsp?eaction=DELETEBYID",{id:id},function(data){
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
			 //初始化扩展数据源下拉框
		   function initDsCombo(){
			    var actionUrl = '<e:url value="/xbuilder/getExtDsInfo.e"/>';
				$.post(actionUrl,{},function(data){
					var datai = data;//重新生命对象用于新增和修改时初始化没有“请选择。。。”的combobox
					data = JSON.parse($.trim(data));
					datai = JSON.parse($.trim(datai));
					$("#EXT_DATASOURCE").combobox({
						valueField: 'DB_SOURCE',
						textField: 'DB_NAME',
						data:data,
						editable:false
					});
					if(data.length > 0) {
					   $('#EXT_DATASOURCE').combobox('select', "-1");
					}
					//新增和修改的时候必填则不显示“请选择。。。。。”
					datai.splice(0,1);
					$("#ADD_EXT_DATASOURCE").combobox({
						valueField: 'DB_SOURCE',
						textField: 'DB_NAME',
						data:datai,
						editable:false
					});
				});
		   }
		   //保存
		   function saveAndCon(state){
		   		var actionUrl = '<e:url value="/EXTDataSource/addEXTdataSource.e"/>';
		   		var info = {};
		   		if(state=='update'){
		   			info.ID=$("#extDsID").val();
		   		}
				info.OWNER = $.trim($("#ADD_OWNER").val());
				info.TABLE_NAME = $.trim($("#ADD_TABLE_NAME").val());
				info.TABLE_DESC = $.trim($("#ADD_TABLE_DESC").val());
				info.EXT_DATASOURCE = $.trim($('#ADD_EXT_DATASOURCE').combobox('getValue'));
			    $.post(actionUrl,info,function(data){
				    var jsonData = $.parseJSON($.trim(data));
				    if(state=='saveAndCon'){
				    	var cor;
				    	if(jsonData.flag=='false')  cor="red";
				    	else cor="green";
					    $('#saveMsgDiv').html("<p style='color:"+cor+";font-size:16px;'>"+jsonData.msg+"</p>");
				    }else if(state=='save'||state=='update'){//新增和修改的提示
				    	var buf;
				    	if(jsonData.flag=='false')  buf="error";
				    	else buf="info";
				    	$.messager.alert("提示信息",jsonData.msg,buf);
				    	reloadGrid();//重新加载
				    }
			    });
		   }
			//添加扩展数据源
			function addEXTDataSource(){
				clearForm();
				validata();//加载验证
				$('#dlg').dialog({
		            title: '添加扩展数据源',
		            resizable: false,
		            width: 400,
		            height: 300,
		            modal: true,
		            buttons: [{
		            text: '保存并继续',
		            handler: function () {
		            	if(validata()){//通过验证才能提交
				            $.messager.confirm("确认信息", "确认保存该扩展数据源吗？", function (data) {  
					            if (data) {  
					            	saveAndCon("save");//保存并继续
					            	return;
					            }  
					            else {  
					            	return;
					            }  
		        			});  
		        		}
		            }},
		            {
		            text: '保存并关闭',
		            handler: function () {
		            	if(validata()){//通过验证才能提交
				            $.messager.confirm("确认信息", "确认保存该扩展数据源吗？", function (data) {  
						    	if (data) {  
					            	saveAndCon("save");//保存
					            	$('#dlg').dialog('close');//关闭对话框
					            	return;
					            }  
					            else {  
					            	return;
					            }  
			        		});  
			        	}
		            	
		            }},
		            {
		            text: '关闭',
		            handler: function () {
		            	reloadGrid();
		            	$('#dlg').dialog('close');
		            }}
		            
		            ]
		        });
			}
			//清空添加区域
		    function clearForm(){
		    	$("#ADD_OWNER").val('');
				$("#ADD_TABLE_NAME").val('');
				$("#ADD_TABLE_DESC").val('');
				//新增是必选，所以添加一个默认的
				var data = $("#ADD_EXT_DATASOURCE").combobox('getData');
 				$("#ADD_EXT_DATASOURCE").combobox("setValue",data[0].DB_SOURCE);
		    }
		    //加载验证
		    function validata(){
		    	return $('#addForm').form('validate');
		    }
			function reloadGrid(){
				$("#extDataSourceTable").datagrid("load",$("#extDataSourceTable").datagrid("options").queryParams);
			}
			$(function (){
				//扩展数据源
				initDsCombo();
			});
	</script>
	</head>
	<body>
		<div id="tbar">
			<h2>扩展数据源管理</h2>
			<div class="search-area">
				用户名称： <input type="text" style="width: 100px" id="OWNER" name="OWNER" />
				数据表名称： <input type="text" style="width: 100px" id="TABLE_NAME" name="TABLE_NAME">
				数据表描述： <input type="text" style="width: 100px" id="TABLE_DESC" name="TABLE_DESC">
				扩展数据源： <input id="EXT_DATASOURCE" name="EXT_DATASOURCE" class="easyui-combobox"/>
				<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQuery()">查询</a>
				<a href="javascript:void(0);" class="easyui-linkbutton" onclick="addEXTDataSource()">新增</a>
			</div>
		</div>
		<c:datagrid
			url="pages/xbuilder/dataset/EXTDataSourceManagertAction.jsp?eaction=LIST" fit="true" border="false"
			id="extDataSourceTable" pageSize="15" style="width:auto;"
			download="true" nowrap="false" toolbar="#tbar">
			<thead frozen="true">
				<tr>
					<th field="OWNER" width="190" align="center">
						用户名称
					</th>
				</tr>
			</thead>
			<thead>
				<tr>
					<th field="TABLE_NAME" width="110" align="center">
						数据表名称
					</th>
					<th field="TABLE_DESC" width="110" align="center">
						数据表描述
					</th>
					<th field="EXT_DATASOURCE" width="160" align="center" hidden="true">//隐藏列
						扩展数据源
					</th>
					<th field="DB_NAME" width="160" align="center">
						扩展数据源
					</th>
					<th field="cz" width="100" align="center" formatter="reportCZ">
						操作
					</th>
				</tr>
			</thead>
		</c:datagrid>
		<!--新增和修改的弹出框-->
		<div id="dlg">
			<div id="indlg" style="margin: 10px;word-break:break-all;">
				<form id="addForm">
					<input id="extDsID" style="display: none"/>
					<div style='margin-top:8px;margin-left:15px;'>
						<span style='width:25%;display:inline-block;text-align:right;'>用户名称&nbsp;&nbsp;</span><input class='easyui-validatebox textbox' id="ADD_OWNER" name='ADD_OWNER' data-options="required:true,validType:'length[1,25]'" style='width:60%;height:22px'/>
					</div>
					<div style='margin-top:8px;margin-left:15px;'>
						<span style='width:25%;display:inline-block;text-align:right;'>数据表名称&nbsp;&nbsp;</span><input class='easyui-validatebox textbox' id="ADD_TABLE_NAME" name='ADD_TABLE_NAME' data-options="required:true,validType:'length[1,25]'" style='width:60%;height:22px'/>
					</div>
					<div style='margin-top:8px;margin-left:15px;'>
						<span style='width:25%;display:inline-block;text-align:right;'>数据表描述&nbsp;&nbsp;</span><input class='easyui-validatebox textbox' id="ADD_TABLE_DESC" name='ADD_TABLE_DESC' data-options="validType:'length[0,25]'" style='width:60%;height:22px'/>
					</div>
					<div style='margin-top:8px;margin-left:15px;'>
						<span style='width:25%;display:inline-block;text-align:right;'>扩展数据源&nbsp;&nbsp;</span><input class='easyui-combobox' id="ADD_EXT_DATASOURCE" name='ADD_EXT_DATASOURCE'/>
					</div>
					<div align="center" id="saveMsgDiv" style='margin-top:8px;margin-left:15px;'>
					</div>
				</form>
			</div>
		</div>
	</body>
</html>