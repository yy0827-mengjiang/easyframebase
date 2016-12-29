<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>维度管理1</title>
		<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources>
		<e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/resources/themes/blue/boncBlue.css"/>
		<e:script value="/pages/xbuilder/resources/scripts/base64.js"/>
		<script type="text/javascript">
			var index = 0;
			$.extend($.fn.validatebox.defaults.rules, {
			     test: {
			         validator: function(value, param){
			         var temp = /[A-Za-z0-9_]/g;
					 var spaceEmpty = value;
					 return temp.test(spaceEmpty);
			         },
			     message: '{0}格式为用户名.表名且用户名表名只能由（A-Za-z0-9_@）组成。'
			     }
			 });
			$(function(){
				$('#dim_tree_grid').treegrid({
					fit :true,
					nowrap: false,
					border:false,
					rownumbers: true,
					animate:true,
					collapsible:false,
					url:appBase+'/pages/xbuilder/pagemanager/dimension/action.jsp?eaction=loadDim',
					idField:'DIM_ID',
					treeField:'DIM_NAME',
					columns:[[
						{field:'DIM_NAME',title:'维度名称',width:280},
						{field:'DIM_ID',title:'维度编号',width:180},
						{field:'DIM_VAR_DESC',title:'显示名称',width:300},
						{field:'DIM_DESC',title:'维度描述',width:300}
					]],
					onContextMenu: function(e,row){
						e.preventDefault();
						$(this).treegrid('unselectAll');
						$(this).treegrid('select', row.DIM_ID);
						
						if(row.DIM_ID==-1){
							$("#cm").menu("disableItem",$("#cm_remove")[0]); 
							$("#cm").menu("disableItem",$("#cm_edit")[0]);
							$("#cm").menu("enableItem",$("#cm_append_dim")[0]);
							$("#cm").menu("enableItem",$("#cm_append_dim_category")[0]);
						}else if(row.TYPE == 'folder'){
							$("#cm").menu("enableItem",$("#cm_remove")[0]); 
							$("#cm").menu("enableItem",$("#cm_edit")[0]);
							$("#cm").menu("enableItem",$("#cm_append_dim")[0]);
							$("#cm").menu("disableItem",$("#cm_append_dim_category")[0]);
						}else if(row.TYPE == 'leaf'){
							$("#cm").menu("enableItem",$("#cm_remove")[0]); 
							$("#cm").menu("enableItem",$("#cm_edit")[0]);
							$("#cm").menu("disableItem",$("#cm_append_dim")[0]);
							$("#cm").menu("disableItem",$("#cm_append_dim_category")[0]);
						}
						$('#cm').menu('show', {
							left: e.pageX,
							top: e.pageY
						});
					},
					onLoadSuccess:function (row,data){
						if(index++<1){
							$('#dim_tree_grid').treegrid('expandAll');
						}
					}
				});
			});

			getSelected=function(){
				return $('#dim_tree_grid').treegrid('getSelected');
			}
			
			append=function(flag){
				var node = getSelected();
				$("#dlg").remove();
				if(flag == 1){
					$('#dim_win').load(appBase+'/pages/xbuilder/pagemanager/dimension/dimCategoryCreator.jsp',null,function (data){
						$.parser.parse($('#dim_win'));
					});
				}else{
					$('#dim_win').load(appBase+'/pages/xbuilder/pagemanager/dimension/dimCreator.jsp',null,function (data){
						$.parser.parse($('#dim_win'));
					});
				}
			}
			
			/* 2014-05-22 董一伯 修改删除异常， 关键字冲突修改方法名*/
			remo=function(){
				var node = getSelected();
				var info = {};
				info.id = node.DIM_ID;
				var message='';
				if(node.TYPE=='folder'){
					info.eaction = "removeDimCategory";
					message="此操作将会删除该分类下的所有维度，确定要删除该维度分类吗？";
				}else{
					info.eaction = "removeDim";
					message="确定要删除该维度吗？";
				}
				$.messager.confirm('确认信息',message,function(r){  
				    if (r){  
				        $.post(appBase+'/pages/xbuilder/pagemanager/dimension/action.jsp',info,function (data){
							$('#dim_tree_grid').treegrid('reload',getSelected().PARENT_DIM_ID);
						});
				    }  
				}); 
			}
			
			edit=function(){
				var node = getSelected();
				$("#dlg").remove();
				if(node.DIM_ID!=-1){
					if(node.TYPE=='folder'){
						$('#dim_win').load(appBase+'/pages/xbuilder/pagemanager/dimension/dimCategoryEditor.jsp',null,function (data){
							$.parser.parse($('#dim_win'));
						});
					}else{
						$('#dim_win').load(appBase+'/pages/xbuilder/pagemanager/dimension/dimEditor.jsp',{id:node.DIM_ID},function (data){
							$.parser.parse($('#dim_win'));
						});
					}
				}else{
					$.messager.alert('提示信息', "不能编辑！", 'error');
				}
			}
			
			
		</script>
	</head>
	<body class="easyui-layout">
		<div region="center" border="false" style="overflow: hidden;">
			<div class="contents-head">
				<h2>模版管理</h2>
			</div>
			<div id="dim_tree_grid"></div>
			<div id="cm" class="easyui-menu" style="width: 120px; display: none;">
				<div id="cm_append_dim" onclick="append(2)" iconCls="icon-add">
					添加维度
				</div> 
				<div class="menu-sep"></div>
				<div id="cm_append_dim_category" onclick="append(1)"
					iconCls="icon-add">
					添加维度分类
				</div>
				<div class="menu-sep"></div>
				<div id="cm_remove" onclick="javascript:remo()" iconCls="icon-remove">
					删除
				</div>
				<div id="cm_edit" onclick="edit()" iconCls="icon-edit">
					编辑
				</div>
			</div>
		</div>
		<div id="dim_win"></div>
	</body>
</html>