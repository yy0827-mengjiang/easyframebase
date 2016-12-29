<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:set var="managerFlag" value="${param.managerFlag}"></e:set>
<e:set var="isViewBaseKpi" value="${param.isViewBaseKpi}"></e:set>
<e:q4l var="cube">select t.cube_code,t.cube_name  from x_kpi_cube t where t.cube_status ='1'
<e:if
		condition="${param.account_type != null && param.account_type != ''}">
	and account_type = '${param.account_type}'
</e:if>
 order by t.cube_code</e:q4l>
<e:q4l var="kpi_type">select type_code, type_name,used_type,view_rule,server_class,url,icon from x_kpi_type where type_status='1'
<e:if condition="${param.type_code != null && param.type_code != ''}"
		var="typeCodeisNull">
	and type_code ='${param.type_code}'
</e:if>
	<e:else condition="${typeCodeisNull }">
	and type_code != '5'
</e:else>
order by type_ord </e:q4l>
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
<e:style
	value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
<e:style value="/resources/easyResources/component/easyui/icon.css" />
<e:style value="/resources/themes/base/boncBase@links.css" />
<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
<e:script value="/pages/kpi/basedim/dimOper.js" />
<script>
	var flag = true, dimFlag = true, reloadFlag, baseKpiNode, current_node, baseDimNode, expandFlag = "2", curr_targetNode;
	$(function() {
		$("#kpi").load('<e:url value="/pages/kpi/kpiManager/kpiMain.jsp"/>?kpi_category=&cube=' + _code, '', function(){});
		var _code = $('#cube_code').val();
		var dimUrl = "#";
		if (_code != "") {
			dimUrl = '<e:url value="pages/kpi/basedim/dimManagerAction.jsp?eaction=baseDimStore&cube_code="/>'
					+ _code;
			console.log('dimUrl=' + dimUrl);
		}
		$("#dim").tree({
			url : dimUrl,
			dnd : true,
			onContextMenu : leftContextMenu,
			onExpand:expandNode,
			onDragOver : function(target, source) {
				return false;
			},
			onLoadSuccess : function() {
				var root=$('#dim').tree('getRoot');
				  var children = $('#dim').tree('getChildren',root.target);
				  var loopFlag = true;
				  $('#dim').tree('expand',root.target);
				  if(children != null && children.length > 0) {
					  if(children[0].attributes.data_type == '1') {
						  $('#dim').tree('expand',children[0].target);
						  while(loopFlag) {
							  children = $('#dim').tree('getChildren',children[0].target);
							  if(children != null && children.length > 0) {
								  if(children[0].attributes.data_type == '1') {
									  $('#dim').tree('expand',children[0].target);
								  }else {
									  loopFlag = false;
								  }
							  }else {
								  loopFlag = false;
							  }
						  }
					  }
				  }
			}
		});
		$('#createCatalogDlg').dialog({
			  title:"创建分类",
			  modal:true,
			  closed:true,
			  height:210,
			  width:340,
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
			  url:'<e:url value="/pages/kpi/basedim/dimManagerAction.jsp"/>',
			  onSubmit:function(){
				  var category_name=$('#c_name').val().replace(/[ ]/g,"");
				  var category_id=$('#category_id').val();
				  var result;
				  $.ajax({
					  type:'post',
					  url:'<e:url value="/pages/kpi/basedim/dimManagerAction.jsp?eaction=validateName"/>',
					  data:{"category_id":category_id,"category_name":category_name},
					  async : false,
					  success:function(data){
						  result=data;
					  }
				  });
				  if(result!=0){
					  $.messager.alert('提示信息','该分类名称已存在!','info');
					  return false;
				  }
				  return $(this).form('validate');
			  },
			  success:function(data){
				  var _action = $('#eaction').val();
				  if(data==1){
					  if(_action=='createCategory'){
						  $.messager.alert('提示信息','分类信息添加成功!','info');  
					  }else{
						  $.messager.alert('提示信息','分类信息修改成功!','info');
					  }
					  $('#createCatalogDlg').dialog('close');
				      $('#dim').tree('reload');
				  }
				  else{
					  if(_action=='createCategory'){
					  	  $.messager.alert('提示信息','分类信息添加失败!','info');
					  }else{
						  $.messager.alert('提示信息','分类信息修改失败!','info');
					  }
				  }
			  }
		  });
	});
	function loadTree() {
		var _code = $('#cube_code').val();
		var sel_cube_code = $("#SEL_CUBE_CODE");
		if (sel_cube_code != undefined && sel_cube_code.val() != "") {
			if (_code != sel_cube_code) {
				$.messager .confirm('确认信息','切换数据魔方将清除当前的信息，您确定要进行此操作吗?', function(r) {
					if (r) {
						$("#kpi").load('<e:url value="/pages/kpi/kpiManager/kpiMain.jsp"/>?kpi_category=&cube=', '', function() {
							$("#dim").tree("options").url = '<e:url value="/pages/kpi/basedim/dimManagerAction.jsp?eaction=baseDimStore&cube_code="/>' + _code;
							$("#dim").tree( "reload");
						});
					} else {
						$('#cube_code').val(sel_cube_code.val());
					}
				});
			}
		} else {
			$("#dim").tree("options").url = '<e:url value="/pages/kpi/basedim/dimManagerAction.jsp?eaction=baseDimStore&cube_code="/>' + _code;
			$("#dim").tree("reload");
		}
	}
	function queryBtnClick_(){
		  var keywords = $("#keywords_").val();
		  $("#dim").tree("options").url='<e:url value="/pages/kpi/basedim/dimManagerAction.jsp?eaction=baseDimStore&keywords="/>' + keywords;
		  $("#dim").tree("reload");
	}
	
</script>
<style type="text/css">
.easyui-tabs .tabs-header,.easyui-tabs .tabs-panels {
	border: none !important;
}
</style>
</head>
<body class="easyui-layout">
	<div data-options="region:'west',split:false" style="width:270px;padding:0px;">
		<div class="editBase_div_child">
			<dl class="ddLine">
				<dd style="width:100%;" class="searchDate">
					<input class="inputBox" type="text" class="fromOne" id="keywords_" style="width:192px" /> <a href="javascript:void(0)" class="easyui-linkbutton" onclick="queryBtnClick_()">查询</a>
				</dd>
			</dl>
		</div>
		<div id="treeTabs" class="easyui-tabs kpi-easyui-tabs"
			style="width:267px;height:auto">
			<div title="维度">
				<ul id="dim"></ul>
			</div>
		</div>
	</div>
	<div data-options="region:'center'">
		<div id="kpi"></div>
	</div>
	<div id="createCatalogDlg" style="width:470px;height:210px;">
		<form id="createCatalogForm" method="post">
			<input type="hidden" id="eaction" name="eaction" value="createCategory"/>
			<input type="hidden" id="category_id" name="category_id" value="" />
			<input type="hidden" id="category_parent_id" name="category_parent_id" value="" />
			<input type="hidden" id="category_type" name="category_type" value="6" />
			<input type="hidden" id="cube_code_s" name="cube_code_s" value="" />
			<input type="hidden" id="c_leaf" name="c_leaf" value="0" />
			<div class="messageText">
				<p>
					<span>分类名称: </span><input type="text" id="c_name" name="c_name" class="easyui-validatebox" required missingMessage="不能为空!">
				</p>
				<p>
					<span>分类描述: </span><input type="text" id="c_desc" name="c_desc" class="easyui-validatebox">
				</p>
				<p>
					<span>排序: </span><input type="text" id="c_ord" name="c_ord" class="easyui-validatebox">
				</p>
			</div>
		</form>
	</div>

	<div id="catalogMenu" class="easyui-menu" style="width:120px;">
		<div class="compositeKpiCategoryFlush" data-options="iconCls:'ico-kpi-reflush'">刷新</div>
		<div class="menu-sep"></div>
		<div class="newDimCategory" data-options="iconCls:'ico-kpi-new'">新建分类</div>
	</div>
	<div id="dimCatalogMenu" class="easyui-menu" style="width:120px;">
		<div class="compositeKpiCategoryFlush" data-options="iconCls:'ico-kpi-reflush'">刷新</div>
		<div class="menu-sep"></div>
		<div class="newDimCategory" data-options="iconCls:'ico-kpi-new'">新建分类</div>
		<div class="editDimCategory" data-options="iconCls:'ico-kpi-edit'">编辑分类</div>
		<div class="delDimCategory" data-options="iconCls:'ico-kpi-delete'">删除分类</div>
		<div class="menu-sep"></div>
		<div class="createDim" data-options="iconCls:'ico10_kpi'">新建维度</div>
	</div>
	<div id="dimMenu" class="easyui-menu" style="width:120px;">
		<div class="compositeKpiCategoryFlush" data-options="iconCls:'ico-kpi-reflush'">刷新</div>
		<div class="menu-sep"></div>
		<!-- <div class="lookDim" data-options="iconCls:'ico-kpi-see'">查看维度</div> -->
		<div class="editDim" data-options="iconCls:'ico-kpi-edit'">编辑维度</div>
		<div class="delDim" data-options="iconCls:'ico-kpi-delete'">删除维度</div>
	</div>
</body>
</html>