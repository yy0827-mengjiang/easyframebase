<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:set var="managerFlag" value="${param.managerFlag}"></e:set>
<e:set var="isViewBaseKpi" value="${param.isViewBaseKpi}"></e:set>
<e:q4l var="cube">select t.cube_code,t.cube_name  from x_kpi_cube t where t.cube_status ='1'
<e:if condition="${param.account_type != null && param.account_type != ''}">
	and account_type = '${param.account_type}'
</e:if>
 order by t.cube_code</e:q4l>
<e:q4l var="kpi_type">select type_code, type_name,used_type,view_rule,server_class,url,icon from x_kpi_type where type_status='1'
<e:if condition="${param.type_code != null && param.type_code != ''}" var="typeCodeisNull">
	and type_code ='${param.type_code}'
</e:if>
<e:else condition="${typeCodeisNull }">
	and type_code != '5'
</e:else>
order by type_ord </e:q4l>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>维度管理</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
 	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<c:resources type="easyui,app"  style="${ThemeStyle }"/>
	<e:style value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
	<e:style value="/resources/easyResources/component/easyui/icon.css" />
	<e:style value="/resources/themes/base/boncBase@links.css"/>
	<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
  <script>
	  var  flag=true ,dimFlag=true , reloadFlag , baseKpiNode , current_node , baseDimNode ;
	  $(function(){
		  var dimUrl = '<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=dimStore"/>';
// 		  $("#kpi").load('<e:url value="/pages/kpi/kpiManager/kpiMain.jsp"/>');
		  $("#dim").tree({
			  url:dimUrl,
			  dnd:true,
// 			  onContextMenu:leftContextMenu,
			  onClick:function(node){
				 
			  },
			  onDragOver:function(){
				  return false;
			  },
			  onLoadSuccess:function(){
				  var root=$('#dim').tree('getRoot');
				  $('#dim').tree('expand',root.target);
			  }
		  });
		  $('#createCatalogDlg').dialog({
			  title:"创建分类",
			  modal:true,
			  closed:true,
			  height:230,
			  width:320,
			  buttons:[{
				  text:"提交",
				  iconCls:"icon-ok",
				  handler:function(){
					  $.messager.confirm('确认信息','您确认要保存当前的分类信息吗?',function(r){
					 		if(r){
					 			$('#createCatalogForm').submit();
					 		}
					  });
				  }
			  }]
		  });

		  $('#createCatalogForm').form({
			  url:'<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=createCategory"/>',
			  onSubmit:function(){
				  var category_name=$('#c_name').val().replace(/[ ]/g,"");
				  var category_id=$('#category_id').val();
				  var result;
				  $.ajax({
					  type:'post',
					  url:'<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=validateName"/>',
					  data:{"category_id":category_id,"category_name":category_name},
					  async : false,
					  success:function(data){
						  result=data;
					  }
				  })
				  if(result!=0){
					  $.messager.alert('提示信息','该分类名称已存在!','info');
					  return false;
				  }
				  return $(this).form('validate');
			  },
			  success:function(data){
				  if(data==1){
					  $.messager.alert('提示信息','分类信息添加成功!','info');
					  $('#createCatalogDlg').dialog('close');
					  if(reloadFlag=="left"){
						  $('#tt').tree('reload',current_node.target);
					  }
					  else if(reloadFlag=="right"){
						  $('#dim').tree('reload',current_node.target);
					  }
				  }
				  else{
					  $.messager.alert('提示信息','分类信息添加失败!','info');
				  }
			  }
		  });

		  $('#editCategoryDlg').dialog({
			  title:"编辑分类",
			  closed:true,
			  modal:true,
			  height:200,
			  width:320,
			  buttons:[{
				  text:"提交",
				  iconCls:"icon-ok",
				  handler:function(){
					  $.messager.confirm('确认信息','您确认要保存当前的分类信息吗?',function(r){
					 		if(r){
					 			$('#editCategoryForm').submit();
					 		}
					  });
				  }
			  }]
		  });

		  $('#editCategoryForm').form({
			  url:'<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=editCategory"/>',
			  onSubmit:function(){
				  var category_name=$('#E_NAME').val().replace(/[ ]/g,"");
				  var category_parent_id=$('#category_parent_id').val();
				  var result;
				  var old_category_name = $("#old_category_name").val();
				  if(category_name != old_category_name) {
					  $.ajax({
						  type:'post',
						  url:'<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=validateName"/>',
						  data:{"category_id":category_parent_id,"category_name":category_name},
						  async : false,
						  success:function(data){
							  result=data;
						  }
					  });
					  if(result!=0){
						  $.messager.alert('提示信息','该分类名称已存在!','info');
						  return false;
					  }
				  }
				  return $(this).form('validate');
			  },
			  success:function(data){
				  if(data==1){
					  $.messager.alert('提示信息','分类信息修改成功!','info');
					  $('#editCategoryDlg').dialog('close');
					  if(reloadFlag=="left"){
						  $('#dim').tree('reload',$('#dim').tree('getParent', current_node.target).target);
					  }
					  else if(reloadFlag=="right"){
						  $('#dim').tree('reload',$('#dim').tree('getParent', current_node.target).target);
					  }
				  }
				  else{
					  $.messager.alert('提示信息','分类信息修改失败!','info');
				  }
			  }
		  });
	  });

	  function createCatalog(){
		  $('#c_name').val("");
		  $('#c_desc').val("");
		  $('#c_ord').val("");
		  $('#createCatalogDlg').dialog('open');
	  }
	  function editCategory(){
		  $('#editCategoryDlg').dialog('open');
		  $.post('<e:url value="pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=beforeEditCategory"/>',{"category_id":current_node.id},function(data){
			  $('#editCategoryForm').form('load',data);
			  $('#old_category_name').val(data.e_name);
		  },'json');
	  }
	  function deleteCategory(){
		  $.ajax({
			  type:'post',
			  url:'<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=beforeDeleteCategory"/>',
			  data:{"category_id":current_node.id},
			  async:false,
			  success:function(data){
				  if(data!=0){
					  $.messager.alert('提示信息','该目录下共有'+data+'个节点,请先删除节点再删除分类!','info');
				  }
				  else{
					  $.messager.confirm('确认信息','您确认要删除当前的分类信息吗?',function(r){
					 		if(r){
					 			$.ajax({
									  type:'post',
									  url:'<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=deleteCategory"/>',
									  data:{"category_id":current_node.id},
									  async:false,
									  success:function(data){
										  $.messager.alert('提示信息','分类信息删除成功!','info');
										  if(reloadFlag=="left"){
											  $('#tt').tree('reload',$('#tt').tree('getParent', current_node.target).target);
										  }
										  else if(reloadFlag=="right"){
											  $('#dim').tree('reload',$('#dim').tree('getParent', current_node.target).target);
										  }
									  }
								  });	 		
					 		}
					 	});
				  }
			  }
		  });
	  }
  </script>
<style type="text/css">
.easyui-tabs .tabs-header, .easyui-tabs .tabs-panels{ border:none!important;}
</style>
 </head>
	 <body class="easyui-layout">
		<div data-options="region:'west',split:true" style="width:270px;padding:0px;">
			<div class="editBase_div_child">
				<dl class="ddLine">
					<dd style="width:100%;">
				     	<input class="inputBox" type="text" class="fromOne"  id="keywords_" style="width:192px"/>
			    		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="queryBtnClick_()">查询</a>
					</dd>
				</dl>
			</div>
			<ul id="dim"></ul>
		</div>
		<div data-options="region:'center'">
			<div id="kpi"></div>
		</div>
		<div id="createCatalogDlg" style="width:450px;height:200px;">
			<form id="createCatalogForm" method="post" >
				<input type="hidden" id="category_id" name="category_id" value=""/>
				<input type="hidden" id="category_type" name="category_type" value=""/>
				<input type="hidden" id="cube_code_s" name="cube_code_s" value=""/>
				<input type="hidden" id="c_leaf" name="c_leaf" value="0"/>
				<div class="messageText">
					<p><span>分类名称: </span><input type="text" id="c_name" name="c_name" class="easyui-validatebox"  required missingMessage="不能为空!"></p>
					<p><span>分类描述: </span><input type="text" id="c_desc" name="c_desc" class="easyui-validatebox"></p>
					<p><span>排序: </span><input type="text" id="c_ord" name="c_ord" class="easyui-validatebox"></p>
<!-- 					<p><span>是否叶子节点: </span><select style="width:150px" id="c_leaf" name="c_leaf"><option value="1">是</option><option selected ="selected" value="0">否</option></select></p> -->
				</div>
			</form>
		</div>
		<div id="editCategoryDlg" style="width:450px;height:200px;">
			<form id="editCategoryForm" method="post" >
				<input type="hidden" id="category_parent_id" name="category_parent_id" value=""/>
				<input type="hidden" id="edit_category_id" name="edit_category_id" value=""/>
				<input type="hidden" id="old_category_name" name="old_category_name" value=""/>
				<div class="messageText">
					<p><span>分类名称:</span><input type="text" id="E_NAME" name="E_NAME" class="easyui-validatebox"  required missingMessage="不能为空!"></p>
					<p><span>分类描述:</span><input type="text" id="E_DESC" name="E_DESC" class="easyui-validatebox"></p>
					<p><span>排序: </span><input type="text" id="E_ORD" name="E_ORD" class="easyui-validatebox"></p>
				</div>
			</form>
		</div>

		<div id="catalogMenu" class="easyui-menu" style="width:120px;">
			<e:if condition="${managerFlag == 'manager' }">
				<div onclick="javascript:createCatalog()" data-options="iconCls:'ico-kpi-new'">新建分类</div>
			</e:if>
	 		<e:forEach items="${kpi_type.list }" var="kpimenu">
				<div data-options="iconCls:'${kpimenu.ICON}'" onclick="javascript:addNewKpi('${kpimenu.type_code}','${kpimenu.used_type}','${kpimenu.view_rule }','${kpimenu.server_class }','${kpimenu.url }')">${kpimenu.type_name}</div>
			</e:forEach>
		</div>
		<div id="compositeKpiCategoryMenu" class="easyui-menu" style="width: 120px">
			<e:if condition="${managerFlag == 'manager' }">
				<div onclick="javascript:createCatalog()"  data-options="iconCls:'ico-kpi-new'">新建分类</div>
				<div id="compositeKpiCategoryEdit"  data-options="iconCls:'ico-kpi-edit'">编辑分类</div>
				<div id="compositeKpiCategoryDelete"  data-options="iconCls:'ico-kpi-delete'">删除分类</div>
			</e:if>
			<div class="menu-sep"></div>
			<e:forEach items="${kpi_type.list }" var="kpimenu">
				<div   data-options="iconCls:'${kpimenu.ICON}'" onclick="javascript:addNewKpi('${kpimenu.type_code}','${kpimenu.used_type}','${kpimenu.view_rule }','${kpimenu.server_class }','${kpimenu.url }')">${kpimenu.type_name}</div>
			</e:forEach>		
		</div>
		<div id="compositeKpiNodeMenu" class="easyui-menu" style="width:120px;">
		    <div id="compositeKpiNodeLook"  data-options="iconCls:'ico-kpi-see'">查看指标</div>
			<div class="compositeKpiNodeEdit"  data-options="iconCls:'ico-kpi-edit'">编辑指标</div>
			<div class="menu-sep"></div>
			<div id="compositeKpiNodeDelete" data-options="iconCls:'ico-kpi-delete'">删除指标</div>
			<e:if condition="${managerFlag == 'manager' }">
				<div class="compositeKpiNodeSibship"  data-options="iconCls:'ico-kpi-blood'">血缘关系</div>
				<!-- <div class="coverage"  data-options="iconCls:'ico-kpi-range'">影响范围</div>
				<div id="compositeKpiNodeHistory">历史版本</div> -->
			</e:if>
		</div>
		<div id="baseKpiNodeMenu" class="easyui-menu" style="width:120px;">
		    <div id="baseKpiNodeLook"  data-options="iconCls:'ico-kpi-see'">查看指标</div>
			<div class="compositeKpiNodeEdit"  data-options="iconCls:'ico-kpi-edit'">编辑指标</div>
			<div class="menu-sep"></div>
			<div id="baseKpiNodeDelete" data-options="iconCls:'ico-kpi-delete'">删除指标</div>
			<e:if condition="${managerFlag == 'manager' }">
				<div class="compositeKpiNodeSibship"  data-options="iconCls:'ico-kpi-blood'">血缘关系</div>
				<!-- <div class="coverage"  data-options="iconCls:'ico-kpi-range'">影响范围</div>
				<div id="compositeKpiNodeHistory">历史版本</div> -->
			</e:if>
		</div>
	 </body>
</html>