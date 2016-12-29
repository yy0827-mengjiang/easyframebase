<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4l var="cube">select z.cube_code,z.cube_name from (select t.cube_code,t.cube_name, t.account_type,case t.account_type when '1' then '日' when '2' then '月' end type from x_kpi_cube t where t.cube_status ='1') z order by z.cube_code</e:q4l>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>指标管理</title>
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
<!-- 	<e:script value="/pages/kpi/basedim/basedim.js"/> -->
<!-- 	<e:script value="/pages/kpi/formulaKpi/formula.js"/> -->
    <script src="compositeKpi.js" type="text/javascript"></script>
  <script type="text/javascript">
	  var current_node;
	  $(function(){
		  var _code = $('#cube_code').val();
		  var treeUrl = "#"; 
		  if(_code != "") {
			  treeUrl = '<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=kpiManagerListTree&cube_code="/>'+_code;
		  } 
		  $("#tt").tree({
			  url:treeUrl,
			  dnd:true,
			  onContextMenu:rightContextMenu,
			  onDragOver:function(){
				  return false;
			  },
			  onClick:function(node){
// 				  $("#kpi").attr('href','kpiList.jsp?kpi_category='+node.id);
// 				  $("#kpi").panel({href:'kpiList.jsp?kpi_category='+node.id});  
				  $("#kpi").load('kpiList.jsp?kpi_category='+node.id,null,function() {
					  $.parser.parse($("#kpi"));
				  });
				  
			  },
			  onExpand:expandNode,
			  onLoadSuccess:function(){
				  var root=$('#tt').tree('getRoot');
				  $('#tt').tree('expand',root.target);
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
					  $('#tt').tree('reload',current_node.target);
// 					  $('#tt').tree('reload',$('#tt').tree('getParent', current_node.target).target);
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
					  $('#tt').tree('reload',$('#tt').tree('getParent', current_node.target).target);
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
										  $('#tt').tree('reload',$('#tt').tree('getParent', current_node.target).target);
									  }
								  });	 		
					 		}
					 	});
				  }
			  }
		  });
	  }
	  function loadTree(){
		  var _code = $('#cube_code').val();
		  $("#tt").tree("options").url='<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=kpiManagerListTree&cube_code="/>'+_code;
		  $("#tt").tree("reload");
	  }

	  function rightContextMenu(e,node){
	      e.preventDefault();
	      reloadFlag="left";
	      baseKpiNode = node;
	      current_node = node;
	      $('#category_id').val(node.id);
	      $('#edit_category_id').val(node.id); 
	      $("#cube_code_s").val($("#cube_code").val());
	      $('#catalogMenu').menu('show',{left:e.pageX,top:e.pageY});
	      $("#category_type").val("0");
// 	      if(node.attributes.kpi_type == undefined) {
// 	      	$("#category_type").val("0"); //如果是基础数据的则默认给一个0
// 	      } else {
// 	      	$("#category_type").val(node.attributes.kpi_type);
// 	      }
	      if (null != $(this).tree('getParent', node.target)) {
	          $('#category_parent_id').val($(this).tree('getParent', node.target).id);
	      }
	      if(node.attributes.parent_id == "-1") {
        	$('#catalogMenu').menu('show',{left:e.pageX,top:e.pageY});
          } else {
        	$('#compositeKpiCategoryMenu').menu('show',{left:e.pageX,top:e.pageY});
          }
	      $(this).tree('select', node.target);
// 	      if(node.attributes.type=="compositeKpiCategory"){
// 	          if(node.attributes.kpi_parent_id == "-1") {
// 	          	$('#catalogMenu').menu('show',{left:e.pageX,top:e.pageY});
// 	          } else {
// 	          	$('#compositeKpiCategoryMenu').menu('show',{left:e.pageX,top:e.pageY});
// 	          }
// 	      } else {
// 	          $('#compositeKpiNodeMenu').menu('show',{left:e.pageX,top:e.pageY});
// 	      }
	  }
  </script>

<style type="text/css">
.easyui-tabs .tabs-header, .easyui-tabs .tabs-panels{ border:none!important;}
</style>
 </head>
	 <body class="easyui-layout">
		<div data-options="region:'west',split:true" style="width:260px;padding:0px;">
			<div class="editBase_div_child">
				<dl class="ddLine">
					<dd>
						<select id="cube_code" onchange="loadTree()">
<!-- 						 	<option value="">--请选择--</option> -->
						 	<e:forEach items="${cube.list }" var="c">
						 		<option value="${c.cube_code }">${c.cube_name }</option>
						 	</e:forEach>
						 </select>
					</dd>
				</dl>
			</div>
<!-- 		 <div class="easyui-tabs" style="width:258px;height:auto"> -->
			 <div style="padding:10px">
				 <ul id="tt"></ul>
			 </div>
<!-- 		 </div> -->
		</div>
		<div id="kpi" data-options="region:'center'">
<!-- 			<div id="kpi" style="height: 360px;"></div> -->
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
			<div onclick="javascript:createCatalog()">新建分类</div>
		</div>
		<div id="compositeKpiCategoryMenu" class="easyui-menu" style="width: 120px">
			<div onclick="javascript:createCatalog()">新建分类</div>
			<div id="compositeKpiCategoryEdit">编辑分类</div>
			<div id="compositeKpiCategoryDelete">删除分类</div>
		</div>
	 </body>
</html>