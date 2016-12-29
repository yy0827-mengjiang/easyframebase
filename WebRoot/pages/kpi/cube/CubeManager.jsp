<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources>
		<title>数据魔方管理</title>
<!-- /eframe_oracle/src/sqlmap/db2/kpi/cube.xml -->
<!-- 		<link rel="stylesheet" href="pages/xbuilder/resources/component/gridster/jquery.gridster.min.css"/> -->
<!-- 		<link rel="stylesheet" href="pages/xbuilder/resources/component/gridster/style.css"/> -->
		<e:style value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
		<e:style value="/resources/easyResources/component/easyui/icon.css" />
		<e:script value="/resources/easyResources/component/easyui/jquery.easyui.min.js" />
		<e:script value="/resources/easyResources/component/easyui/locale/easyui-lang-zh_CN.js" />
		<e:script value="/resources/easyResources/component/easyui/plugins/datagrid-detailview.js" />
	    <e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/resources/themes/blue/boncBlue.css"/>
		<e:style value="/pages/xbuilder/resources/component/jqueryui/themes/base/jquery.ui.selectable.css"/>
	    <e:style value="/pages/xbuilder/resources/component/icheck/icheck.css"/>
		<e:script value="/pages/xbuilder/resources/component/icheck/icheck.min.js"/>
		<script type="text/javascript">
			$(function() {
				$('input.checkN').iCheck({
				    labelHover : false,
				    cursor : true,
				    checkboxClass : 'icheckbox_square-blue',
				    radioClass : 'iradio_square-blue',
				    increaseArea : '20%'
				}).on('ifClicked', function(event){
					 
				});
			});
			$(window).resize(function(){
			 	$('#kpiCubeTable').datagrid('resize');
			});
			$.extend($.fn.validatebox.defaults.rules, {
			     ename: {
			         validator: function(value, param){
			         var temp = /^[A-Za-z0-9]\w{0,24}$/;
					 var spaceEmpty = value;
					 return temp.test(spaceEmpty);
			         },
			     message: '魔方编码只能由数字、字母、下划线组成(不能以下划线开头，最大长度25)。'
			     }
			 });
			 //查询
			function doQuery(){
				var info = {};
				info.CUBE_CODE = $("#CUBE_CODE").val().trim();
				info.CUBE_NAME = $("#CUBE_NAME").val().trim();
				$('#kpiCubeTable').datagrid('load',info);
			}
			//datagruid格式化操作
			function reportCZ(value,rowData){
				var upd =  '<a href="javascript:void(0);" class="btn-submit1" onclick="updKpiCube(\''+rowData.CUBE_CODE+'\')">编辑</a>&nbsp;&nbsp;';
				var del =   '<a href="javascript:void(0);" class="btn-submit2" onclick="delKpiCube(\''+rowData.CUBE_CODE+'\')">删除</a>&nbsp;&nbsp;';
				var dy =   '<a href="javascript:void(0);" class="btn-submit2" onclick="dyKpiCube(\'1\',\''+rowData.CUBE_CODE+'\')">主键</a>&nbsp;&nbsp;';
				var dim = '<a href="javascript:void(0);" class="btn-submit2" onclick="dyKpiCube(\'2\',\''+rowData.CUBE_CODE+'\')">维度</a>&nbsp;&nbsp;';
				var attr = '<a href="javascript:void(0);" class="btn-submit2" onclick="dyKpiCube(\'3\',\''+rowData.CUBE_CODE+'\')">属性</a>&nbsp;&nbsp;';
				var res = upd+del+dy + dim +attr;
				return  res; 
			}
			function dyKpiCube(attr,cubecode){
				if(attr=='1'){
					window.location.href='<e:url value="/pages/kpi/cube/keyList.jsp"/>?cube_code='+cubecode;
				}else if(attr=='2'){
					window.location.href='<e:url value="/pages/kpi/cube/dimList.jsp"/>?cube_code='+cubecode;
				}else if(attr=='3'){
					window.location.href='<e:url value="/pages/kpi/cube/attrList.jsp"/>?cube_code='+cubecode;
				}
			}
			//修改数据魔方
			function updKpiCube(cube_code){
				$.post(appBase+"/pages/kpi/cube/CubeManagertAction.jsp?eaction=SELECTOBJBYCODE",{cube_code:cube_code},function(data){
					clearForm();
					var jsonData = JSON.parse($.trim(data));
					$("#ADD_CUBE_CODE").val(jsonData.CUBE_CODE).attr('readonly',true);;
					$("#ADD_CUBE_NAME").val(jsonData.CUBE_NAME);
					$("#ADD_CUBE_DESC").val(jsonData.CUBE_DESC);
					$('#ADD_CUBE_DATASOURCE').combobox('select',jsonData.CUBE_DATASOURCE);
					$('input[name="ADD_CUBE_ATTR"]').each(function(){    
						if($(this).val()==jsonData.CUBE_ATTR){
					   		$(this).iCheck('check');
					    }
					});  
					$('input[name="ADD_CUBE_FLAG"]').each(function(){    
						if($(this).val()==jsonData.CUBE_FLAG){
					   		$(this).iCheck('check');
					    }
					});
					$('input[name="ADD_ACCOUNT_TYPE"]').each(function(){    
						if($(this).val()==jsonData.ACCOUNT_TYPE){
					   		$(this).iCheck('check');
					    }
					});
// 					$('input[name="ADD_CUBE_STATUS"]').each(function(){    
// 						if($(this).val()==jsonData.CUBE_STATUS){
// 					   		$(this).iCheck('check');
// 					    }
// 					});
					validata();//加载验证
					//打开弹窗
					$('#dlg').dialog({
			            title: '修改数据魔方',
			            resizable: false,
			            width: 540,
			            height: 350,
			            modal: true,
			            buttons: [{
			            text: '保存',
			            handler: function () {
			            	if(validata()){//通过验证才能提交
					            $.messager.confirm("操作提示", "确认修改该数据魔方吗？", function (data) {  
						            if (data) {
						           		saveAndCon('update');
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
			function delKpiCube(cube_code){
				$.messager.confirm('确认信息','确认删除该数据魔方吗?',function(r){  
					if(r){
						$.post(appBase+"/pages/kpi/cube/CubeManagertAction.jsp?eaction=DELETEBYID",{cube_code:cube_code},function(data){
							if(parseInt($.trim(data))>0){
								$.messager.alert("提示信息","删除成功","info");
								reloadGrid();
							}else{
								$.messager.alert("提示信息","删除失败","info");
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
					$("#CUBE_DATASOURCE").combobox({
						valueField: 'DB_SOURCE',
						textField: 'DB_NAME',
						data:data,
						editable:false
					});
					if(data.length > 0) {
					   $('#CUBE_DATASOURCE').combobox('select', "-1");
					}
					//新增和修改的时候必填则不显示“请选择。。。。。”
					datai.splice(0,1);
					$("#ADD_CUBE_DATASOURCE").combobox({
						required:true,
						valueField: 'DB_SOURCE',
						textField: 'DB_NAME',
						data:datai,
						editable:false
					});
				});
		   }
		   //修改保存
		   function saveAndCon(state){
		   		var actionUrl = '<e:url value="/KpiCubeManager/updateKpiCube.e"/>';
		   		var info = {};
				info.CUBE_CODE = $.trim($("#ADD_CUBE_CODE").val());
				info.CUBE_NAME = $.trim($("#ADD_CUBE_NAME").val());
				info.CUBE_DESC = $.trim($("#ADD_CUBE_DESC").val());
				info.CUBE_DATASOURCE = $.trim($('#ADD_CUBE_DATASOURCE').combobox('getValue'));
				info.CUBE_ATTR = $('input[name="ADD_CUBE_ATTR"]:checked').val();
				info.CUBE_FLAG = $('input[name="ADD_CUBE_FLAG"]:checked').val();
			    info.ACCOUNT_TYPE = $('input[name="ADD_ACCOUNT_TYPE"]:checked').val();
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
		   
			//添加数据魔法
			function addEXTDataSource(){
				clearForm();//清理添加区域
				$('#dlg').dialog({
		            title: '添加数据魔方',
		            resizable: false,
		            width: 540,
		            height: 350,
		            modal: true,
		            buttons: [{
		            text: '保存',
		            handler: function () {
		            	if(validata()){//通过验证才能提交
				            $.messager.confirm("操作提示", "确认保存该数据魔方吗？", function (data) {  
					            if (data) {  
					            	$('#addForm').submit();
					            	reloadGrid();
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
		        var timestamp = (new Date()).valueOf();//时间戳
				$("#ADD_CUBE_CODE").val(timestamp);
				validata();//加载验证
			}
			//清空添加区域
		    function clearForm(){
		    	$("#ADD_CUBE_CODE").val('').attr('readonly',false);
				$("#ADD_CUBE_NAME").val('');
				$("#ADD_CUBE_DESC").val('');
				$("input[name=ADD_CUBE_ATTR]:eq(0)").attr("checked",'checked'); 
				$("input[name=ADD_ACCOUNT_TYPE]:eq(0)").attr("checked",'checked'); 
				$("input[name=ADD_CUBE_FLAG]:eq(0)").attr("checked",'checked'); 
				var data = $("#ADD_CUBE_DATASOURCE").combobox('getData');
				if(data != null && data.length > 0)
 					$("#ADD_CUBE_DATASOURCE").combobox("setValue",data[0].DB_SOURCE);
		    }
		    //加载验证
		    function validata(){
		    	return $('#addForm').form('validate');
		    }
		    //重载datagrid
			function reloadGrid(){
				$("#kpiCubeTable").datagrid("load",$("#kpiCubeTable").datagrid("options").queryParams);
			}
			$(function (){
				//扩展数据源
				initDsCombo();
				//easy from
				$('#addForm').form({
					url:'<e:url value="/KpiCubeManager/addKpiCube.e"/>',
					onSubmit:function(param){
					   param.CUBE_ATTR = $('input[name="ADD_CUBE_ATTR"]:checked').val();
					   param.ACCOUNT_TYPE = $('input[name="ADD_ACCOUNT_TYPE"]:checked').val();
					   var cube_code = $("#ADD_CUBE_CODE").val().trim();
						var result;
						$.ajax({
							type:'post',
							url:'<e:url value="/pages/kpi/cube/CubeManagertAction.jsp?eaction=SELECTBYCODE"/>',
							data:{"cube_code":cube_code},
							async : false,
							success:function(data){
								result=data;
							}
						})
						if(parseInt($.trim(result))>0){
							$.messager.alert('提示信息','该魔方编码已存在!','info');
							return false;
						}
					   return $(this).form('validate');
					},
					success:function(data){
				  		jsondata = JSON.parse(data);
						var buf;
				    	if(jsondata.flag=='false')  buf="error";
				    	else buf="info";
				    	$.messager.alert("提示信息",jsondata.msg,buf);
				    	reloadGrid();
				    	$('#dlg').dialog('close');
					}
				});
			});
	</script>
	</head>
	<body>
		<div id="tbar">
			<h2>数据魔方管理</h2>
			<div class="search-area">
				魔方编码： <input type="text" style="width: 100px" id="CUBE_CODE" name="CUBE_CODE" />
				魔方名称： <input type="text" style="width: 100px" id="CUBE_NAME" name="CUBE_NAME">
				<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQuery()">查询</a>
				<a href="javascript:void(0);" class="easyui-linkbutton" onclick="addEXTDataSource()">新增</a>
			</div>
		</div>
		<c:datagrid
			url="pages/kpi/cube/CubeManagertAction.jsp?eaction=LIST" fit="true" border="false"
			id="kpiCubeTable" pageSize="15" style="width:auto;"
			download="true" nowrap="false" toolbar="#tbar">
			<thead frozen="true">
				<tr>
					<th field="CUBE_CODE" width="150" align="center">
						魔方编码
					</th>
				</tr>
			</thead>
			<thead>
				<tr>
					<th field="CUBE_NAME" width="110" align="center">
						魔方名称
					</th>
					<th field="CUBE_DESC" width="110" align="center" hidden="true">
						魔方简称
					</th>
					<th field="CUBE_DATASOURCE" width="160" align="center" hidden="true">
						魔方数据源
					</th>
					<th field="DB_NAME" width="160" align="center">
						魔方数据源
					</th>
					<th field="CUBE_FLAG" width="160" align="center">
						是否取数
					</th>
					<th field="CUBE_ATTR" width="100" align="center">
						魔方属性
					</th>
					<th field="ACCOUNT_TYPE" width="100" align="center">
						账期类型
					</th>
					<th field="CUBE_STATUS" width="160" align="center" hidden="true">
						魔方状态
					</th>
					<th field="CUBE_CREATETIME" width="160" align="center">
						创建时间
					</th>
					<th field="CUBE_CREATEUSER" width="100" align="center">
						创建人
					</th>
<!-- 					<th field="CUBE_UPDATETIME" width="160" align="center"> -->
<!-- 						修改时间 -->
<!-- 					</th> -->
<!-- 					<th field="CUBE_UPDATEUSER" width="100" align="center"> -->
<!-- 						修改人 -->
<!-- 					</th> -->
					<th field="cz" width="320" align="center" formatter="reportCZ">
						操作
					</th>
				</tr>
			</thead>
		</c:datagrid>
		<!--新增和修改的弹出框-->
		<div id="dlg">
			<div id="indlg" style="margin: 10px;word-break:break-all;">
				<form id="addForm">
					<div style='margin-top:8px;margin-left:15px;'>
						<span style='width:25%;display:inline-block;text-align:right;'>魔方编码：&nbsp;&nbsp;</span><input class='easyui-validatebox textbox' id="ADD_CUBE_CODE" name='ADD_CUBE_CODE' data-options="required:true,validType:'ename'" style='width:42%;height:22px'/>
					</div>
					<div style='margin-top:8px;margin-left:15px;'>
						<span style='width:25%;display:inline-block;text-align:right;'>魔方名称：&nbsp;&nbsp;</span><input class='easyui-validatebox textbox' id="ADD_CUBE_NAME" name='ADD_CUBE_NAME' data-options="required:true,validType:'length[1,25]'" style='width:42%;height:22px'/>
					</div>
					<div style='margin-top:8px;margin-left:15px;'>
						<span style='width:25%;display:inline-block;text-align:right;'>魔方简称：&nbsp;&nbsp;</span><input class='easyui-validatebox textbox' id="ADD_CUBE_DESC" name='ADD_CUBE_DESC' data-options="required:true,validType:'length[1,12]'" style='width:42%;height:22px'/>
					</div>
					<div style='margin-top:8px;margin-left:15px;'>
						<span style='width:25%;display:inline-block;text-align:right;'>魔方数据源：&nbsp;&nbsp;</span><input class='easyui-combobox' id="ADD_CUBE_DATASOURCE" name='ADD_CUBE_DATASOURCE' style='width:220px;height:22px'/>
					</div>
					<div style='margin-top:8px;margin-left:15px;'>
						<span style='width:25%;display:inline-block;text-align:right;'>魔方属性：&nbsp;&nbsp;</span><input id="ADD_CUBE_ATTR1" name="ADD_CUBE_ATTR" class="checkN" type="radio" value="1" checked="checked"/>主键&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="ADD_CUBE_ATTR2" name="ADD_CUBE_ATTR" class="checkN" type="radio" value="2"/>维度&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="ADD_CUBE_ATTR3" name="ADD_CUBE_ATTR" class="checkN" type="radio" value="3"/>属性
					</div>
					<div style='margin-top:8px;margin-left:15px;'>
						<span style='width:25%;display:inline-block;text-align:right;'>账期类型：&nbsp;&nbsp;</span><input id="ADD_ACCOUNT_TYPE1" name='ADD_ACCOUNT_TYPE' class="checkN" type="radio" value="1" checked="checked" />日账期&nbsp;&nbsp;&nbsp;&nbsp;<input class="checkN" id="ADD_ACCOUNT_TYPE2" name='ADD_ACCOUNT_TYPE' type="radio" value="2"/>月账期
					</div>
					<div style='margin-top:8px;margin-left:15px;'>
						<span style='width:25%;display:inline-block;text-align:right;'>是否取数：&nbsp;&nbsp;</span><input id="ADD_CUBE_FLAG1" name='ADD_CUBE_FLAG' class="checkN" type="radio" value="1" checked="checked" />是&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input class="checkN" id="ADD_CUBE_FLAG2" name='ADD_CUBE_FLAG' type="radio" value="0" />否
					</div>
<!--					<div style='margin-top:8px;margin-left:15px;'>-->
<!--						<span style='width:25%;display:inline-block;text-align:right;'>魔方状态&nbsp;&nbsp;</span><input id="ADD_CUBE_STATUS1" name='ADD_CUBE_STATUS' type="radio" value="1" checked="checked"/>有效&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input class='textbox' id="ADD_CUBE_STATUS2" name='ADD_CUBE_STATUS' type="radio" value="0"/>无效-->
<!--					</div>-->
					<div align="center" id="saveMsgDiv" style='margin-top:8px;margin-left:15px;'>
					</div>
				</form>
			</div>
		</div>
	</body>
</html>