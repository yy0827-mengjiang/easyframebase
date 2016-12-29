<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:set var="managerFlag" value="${param.managerFlag}"></e:set>
<e:set var="isViewBaseKpi" value="${param.isViewBaseKpi}"></e:set>
<e:q4l var="cube" sql="kpi.view.cubeDetail"/>
<e:q4l var="kpi_type" sql="kpi.view.typeInfo"/>
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
	<e:script value="/pages/kpi/basedim/basedim.js"/>
	<e:script value="/pages/kpi/formulaKpi/formula.js"/>
	<e:script value="/pages/kpi/jOrgChart/jquery_format.js"/>
	<e:script value="/pages/kpi/relationship/js/jit.js"/>
	<e:script value="/pages/kpi/relationship/js/example4.js"/>

    <script src="compositeKpi.js"></script>
  <script><!--
	  var  flag=true ,dimFlag=true , reloadFlag , baseKpiNode , current_node , baseDimNode,expandFlag="2", curr_targetNode;
	  var timer;
  	  $(function(){
		  var _code = $('#cube_code').val();
		  var treeUrl = "#";
		  var dimUrl = "#";
		  var attrUrl = "#";
		  if(_code != "") {
			  treeUrl = '<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=querynewLoadTree&cube_code="/>'+_code +'&isViewBaseKpi=${isViewBaseKpi}';
			  dimUrl = '<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=baseDimStore&cube_code="/>'+_code;
			  attrUrl = '<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=baseAttrStore&cube_code="/>'+_code;
		  } 
		  $("#kpi").load('<e:url value="/pages/kpi/kpiManager/kpiMain.jsp?kpi_category=&cube_code="/>' + $("#cube_code").val());
		  $("#tt").tree({
			  url:treeUrl,
			  dnd:true,
			  onContextMenu:leftContextMenu,
			  onClick:function(node){
				  	$("#kpi").html("");
					if(node.attributes.data_type == '2') {
						  $("#kpi").load('<e:url value="formulaKpiLook.e?kpi_key="/>' + node.id + '&lookUpFlag=1','',function(){
						  		kpiDivTitle();
						  });
					} else if(node.attributes.data_type == '3'){
						  $("#kpi").load('<e:url value="lookBaseKpi.e?id="/>' + node.id +'&cube_code='+$('#cube_code').val()+ '&lookUpFlag=1','',function(){
							  kpiDivTitle();
						  });
					} else {
						 $("#kpi").load('<e:url value="/pages/kpi/kpiManager/kpiMain.jsp"/>?kpi_category='+ node.id +'&cube_code=' + $("#cube_code").val());
					}  
			  },
			  onDragOver:function(target,source){
				  var targetNode= $(this).tree('getNode', target);
				  if(targetNode.attributes.data_type == "1") {
					  return false;
				  }
			  }, 
			  onStartDrag:function(node){
				  expandFlag = "1";
				  curr_targetNode = $("#tt").tree('getParent', node.target);
			  },
			  onDrop:function(target,source,point) {
				  var param = {};
				  var targetNode= $(this).tree('getNode', target);
				  if(targetNode.attributes.data_type == "1") {
					  return false;
				  }
				  var parentNode = $(this).tree('getParent', targetNode.target);
				  var childrenNode = $(this).tree('getChildren',parentNode.target);
				  var preOrd = 0;
				  var nextOrd = targetNode.attributes.kpi_ord;
				  var ord = 1;
				  if (childrenNode.length > 0) {
					  for(var i = 0; i < childrenNode.length; i++) {
						  if(childrenNode[i].id == targetNode.id) {
							  if(i != 0) {
								  preOrd = childrenNode[i-1].attributes.kpi_ord;
							  } else {
								  preOrd = 0;
							  }
							  break;
						  }
					  }
				  }
				  if(preOrd == 0) {
					  ord = nextOrd*1 -1;
				  } else {
					  ord = (nextOrd*1-preOrd*1)/2==0?0.5:(nextOrd*1-preOrd*1)/2;
					  ord = nextOrd*1 - ord;
				  }
				  param.kpi_source_id = source.id;
				  param.kpi_source_datatype = source.attributes.data_type;
				  param.kpi_ord = ord;
				  $.post('<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=editKpiOrder"/>',param,function(data){
					  $(this).tree('reload',$(this).tree('getParent', targetNode.target).target);
				  },'json');
			  },
			  onExpand:expandNode,
			  onLoadSuccess:function(){
				  if(expandFlag != "1") {
					  var root=$('#tt').tree('getRoot');
					  var children = $('#tt').tree('getChildren',root.target);
					  var loopFlag = true;
					  if(root.state != "open") {
						  $('#tt').tree('expand',root.target);
					  }
					  if(children != null && children.length > 0) {
						  if(children[0].attributes.data_type == '1') {
							  if(children[0].state != "open") {
								  $('#tt').tree('expand',children[0].target);
							  }
							  while(loopFlag) {
								  children = $('#tt').tree('getChildren',children[0].target);
								  if(children != null && children.length > 0) {
									  if(children[0].attributes.data_type == '1') {
										  if(children[0].state != "open") {
											  $('#tt').tree('expand',children[0].target);
										  }
									  }else {
										  loopFlag = false;
									  }
								  }else {
									  loopFlag = false;
								  }
							  }
						  } 
					  } 
				  } else {
					  if(curr_targetNode != null) {
						  if(curr_targetNode != "open") {
							  $('#tt').tree('expand',curr_targetNode.target);
						  }
					  }
				  }
			  }
		  });
		  <e:if condition="${managerFlag == 'manager' }">
			  $("#dim").tree({
				  url:dimUrl,
				  dnd:true,
				  onDragOver:function(target,source){
					  return false;
				  },
				  onLoadSuccess:function(){
					  var root=$('#dim').tree('getRoot');
					  var children = $('#dim').tree('getChildren',root.target);
					  var loopFlag = true;
					  if(root.state != "open") {
						  $('#dim').tree('expand',root.target);
					  }
					  if(children != null && children.length > 0) {
						  if(children[0].attributes.data_type == '1') {
							  if(children[0].state != "open") {
								  $('#dim').tree('expand',children[0].target);
							  }
							  while(loopFlag) {
								  children = $('#dim').tree('getChildren',children[0].target);
								  if(children != null && children.length > 0) {
									  if(children[0].attributes.data_type == '1') {
										  if(children[0].state != "open") {
											  $('#dim').tree('expand',children[0].target);
										  }
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
			  $("#attr").tree({
				  url:attrUrl,
				  dnd:true,
				  onDragOver:function(target,source){
					  return false;
				  },
				  onLoadSuccess:function(){
					  var root=$('#attr').tree('getRoot');
					  $('#attr').tree('expand',root.target);
				  }
	 		  });
		  </e:if>
		  $('#createCatalogDlg').dialog({
			  title:"创建分类",
			  modal:true,
			  closed:true,
			  height:260,
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
		  timer = setInterval('loadFirstNode()',100);
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
				  });
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
			  height:260,
			  width:340,
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
						  $('#tt').tree('reload',$('#tt').tree('getParent', current_node.target).target);
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
		  $("#baseKpiNodeAdd").on("click",function(){
			  $("#kpi").html("");
			  $("#kpi").load('<e:url value="addBaseKpi.e?parentId="/>'+baseKpiNode.id,'',function(){
				  kpiDivTitle();
			  });
		  });

		  $("#baseKpiNodeEdit").on("click",function(){
			  $("#kpi").html("");
			  $("#kpi").load('<e:url value="editBaseKpi.e?id="/>'+baseKpiNode.id,'',function(){
				  kpiDivTitle();
			  });
		  });

		  $("#baseLabelNodeAdd").on("click",function(){
			  $("#kpi").html("");
			  $("#kpi").load('<e:url value="addBaseKpi.e?parentId="/>'+baseKpiNode.id+"&type=2");
		  });

		  $("#baseLabelNodeEdit").on("click",function(){
			  $("#kpi").html("");
			  $("#kpi").load('<e:url value="editBaseKpi.e?id="/>'+baseKpiNode.id);
		  });

		  $("#baseDimNodeAdd").on("click",function(){
			  $("#kpi").html("");
			  $("#kpi").load('<e:url value="/pages/kpi/basedim/basedim.jsp?parentId="/>'+baseDimNode.id);
		  });

		  $("#baseDimNodeEdit").on("click",function(){
			  $("#kpi").html("");
			  $("#kpi").load('<e:url value="/pages/kpi/basedim/editBasedim.jsp?ID="/>'+baseDimNode.id);
		  });

		  $("#compositeKpiNodeAdd").on("click",function(){
			  var _cubeCode = $('#cube').val();
			  $("#kpi").html("");
			  $("#kpi").load('<e:url value="/pages/kpi/formulaKpi/formulaNewKpi.jsp?kpi_category="/>'+current_node.id + '&cubeCode='+_cubeCode+'&kpi_type=' + current_node.attributes.kpi_type +'&managerFlag=${param.managerFlag}','',function(){
				  kpiDivTitle();
// 				  $.parser.parse("#kpi");
			  });
		  });
		  $(".compositeKpiCategoryFlush").on("click",function (){
			  var selected=$('#tt').tree('getSelected');
			  $('#tt').tree('reload',$('#tt').tree('getParent', selected.target).target);
		  });
		  $(".compositeKpiNodeEdit").on("click",function (){
			  var selected=$('#tt').tree('getSelected');
			  $("#kpi").html("");
			  if(selected.attributes.data_type=='2'	){
				  $("#kpi").load('<e:url value="formulaKpiList.e?kpi_key="/>' + selected.id + '&managerFlag=${param.managerFlag}','',function(){
					  kpiDivTitle();
					  $.parser.parse("#kpi");
				  });
			  }else{
				  $("#kpi").load('<e:url value="/editBaseKpi.e?id="/>'+selected.id+'&cube_code='+$('#cube_code').val(),'',function(){
					  kpiDivTitle();
					  $.parser.parse("#kpi");
				  });
			  }
		  });
		  $("#compositeMoveTo").on("click",function (){
			  openCategoryDialog();
		  });
		  $("#baseKpiMoveTo").on("click",function (){
			  openCategoryDialog();
		  });
		  $("#compositeKpiNodeLook").on("click",function (){
			  var selected=$('#tt').tree('getSelected');
			  $("#kpi").html("");
			  if(selected){
				  $("#kpi").load('<e:url value="formulaKpiLook.e?kpi_key="/>' + selected.id + '&lookUpFlag=1','',function(){
					    $.parser.parse("#kpi");
					    kpiDivTitle();
				  });
			  }
		  });
		  $("#baseKpiNodeLook").on("click",function (){
			  var selected=$('#tt').tree('getSelected');
			  $("#kpi").html("");
			  if(selected){
				  $("#kpi").load('<e:url value="lookBaseKpi.e?id="/>' + selected.id +'&cube_code='+$('#cube_code').val()+ '&lookUpFlag=1','',function(){
					  $.parser.parse("#kpi");
					  kpiDivTitle();
				  });
			  }
		  });
		  $("#compositeKpiNodeDelete").on("click",function (){
			  var selected=$('#tt').tree('getSelected');
			  if(selected) {
				  delKpi(selected.id,current_node.attributes.code,current_node.attributes.version,current_node.attributes.data_type);
			  }
		  });
		  $("#baseKpiNodeDelete").on("click",function (){
			  var selected=$('#tt').tree('getSelected');
			  if(selected) {
				  delKpi(selected.id,current_node.attributes.code,current_node.attributes.version,current_node.attributes.data_type);
			  }		  
		  });
	  });
  	  function compositeSibship(){
  	    var selected=$('#tt').tree('getSelected');
  	    if(selected){
  	    	$("#kpi").html("");
  		    $("#kpi").load('<e:url value="pages/kpi/relationship/relationshipFrame.jsp"/>?kpi_key='+selected.attributes.code+'&kpi_version='+selected.attributes.version+'&cube_code='+$("#cube_code").val(),'',function(){
  			   kpiDivTitle();
  		    });
//  	        window.open('../relationship/relationshipFrame.jsp?kpi_key='+selected.attributes.code+"&kpi_name="+selected.text+"&kpi_version="+selected.attributes.version+"&kpiId="+selected.id+"&kpi_type="+selected.attributes.kpi_type);
  	    }  
  	 }
  	function compositeHistory(){
  	    var selected=$('#tt').tree('getSelected');
  	    if(selected){
  	    	$("#kpi").html("");
  		    $("#kpi").load('<e:url value="pages/kpi/version/kpi_version.jsp"/>?kpi_code='+selected.attributes.code,'',function(){
  		    	kpiDivTitle();
  		    });
//   	    window.open('../version/kpi_version.jsp?kpi_code='+selected.attributes.code,'历史版本', 'height=480, width=800, top=60, left=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');
  	    }
  	}
	 function kpiDivTitle(){
			var browser_width;
			browser_width = $(".kpi_guide").eq(0).width();
			$('.tit_div1').css({'width':browser_width,'left':'281px' });
			$(window).resize(function() { 
					$('.tit_div1').css({'width':browser_width,'left':'281px' });
			}); 
	  }
	  function openCategoryDialog() {
		  $("#category_tree").tree("options").url='<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=kpitree&cube_code="/>'+$("#cube_code").val();
		  $("#category_tree").tree("reload");
		  $("#category_tree_dialog").dialog("open");
	  }
	  function extendRoot(node,data){
		  var root = $('#category_tree').tree('getRoot');
		  $('#category_tree').tree('expandAll',root.target);
	  }
	  function moveToCategory(node) {
		  var selected=$('#tt').tree('getSelected');
		  var param = {};
		  if(node.id == "0") {
			  $.messager.alert('提示信息','不允许移到根目录下！','info',function(){});
			  return false;
		  }
		  $.messager.confirm('确认信息','您确认要移到此目录下吗?',function(r){
			  if(r){
				  param.kpi_datatype = selected.attributes.data_type;
				  param.kpi_key = selected.id;
				  param.kpi_category = node.id;
				  $.post('<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=editKpiCategory"/>',param,function(data){
					  $.messager.alert('提示信息','已成功移到此目录下！','info',function(){
						  $("#category_tree_dialog").dialog("close");
						  $('#tt').tree('reload',$('#tt').tree('getParent', selected.target).target);
					  });
				  },'json');
			  }
		  });
	  }
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
	  function loadFirstNode() {
		  var root=$('#tt').tree('getRoot');
		  var children = $('#tt').tree('getChildren',root.target);
		  var loopFlag = true;
		  var viewFlag = true;
		  if(root.state != "open") {
			  viewFlag = false;
 		  }
		  if(children != null && children.length > 0) {
			  if(children[0].attributes.data_type == '1') {
				  if(children[0].state != "open") {
					  viewFlag = false;
 				  }
				  while(loopFlag) {
					  children = $('#tt').tree('getChildren',children[0].target);
					  if(children != null && children.length > 0) {
						  if(children[0].attributes.data_type == '1') {
							  if(children[0].state != "open") {
								  viewFlag = false;
 							  }
						  }
					  } else {
						  loopFlag = false;
					  }
				  }
			  } 
		  }  
		  if(viewFlag) {
			  expandFlag = "1";
			  clearInterval(timer);
		  }
	  }
	  function loadTree(){
		  var _code = $('#cube_code').val();
		  var sel_cube_code = $("#SEL_CUBE_CODE");
		  if(sel_cube_code != undefined && sel_cube_code.val() != "") {
			  if(_code != sel_cube_code) {
				  $.messager.confirm('确认信息','切换数据魔方将清除当前的信息，您确定要进行此操作吗?',function(r){
				 		if(r){
				 			      expandFlag = "2";
							   	  $("#kpi").load('<e:url value="/pages/kpi/kpiManager/kpiMain.jsp"/>?kpi_category=&cube_code=' + _code,'',function(){
								  $("#tt").tree("options").url='<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=querynewLoadTree&cube_code="/>'+_code+'&isViewBaseKpi=${isViewBaseKpi}';
								  $("#tt").tree("reload");
								  $("#dim").tree("options").url='<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=baseDimStore&cube_code="/>'+_code;
								  $("#dim").tree("reload");
								  $("#attr").tree("options").url='<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=baseAttrStore&cube_code="/>'+_code;
								  $("#attr").tree("reload");
								  timer = setInterval('loadFirstNode()',100);
							  });
				 		} else {
				 			$('#cube_code').val(sel_cube_code.val());
				 		}
				  });
			  }
		  } else {
			  expandFlag = "2";
			  $("#kpi").load('<e:url value="/pages/kpi/kpiManager/kpiMain.jsp"/>?kpi_category=&cube_code=' + $("#cube_code").val());
			  $("#tt").tree("options").url='<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=querynewLoadTree&cube_code="/>'+_code+'&isViewBaseKpi=${isViewBaseKpi}';
			  $("#tt").tree("reload");
			  $("#dim").tree("options").url='<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=baseDimStore&cube_code="/>'+_code;
			  $("#dim").tree("reload");
			  $("#attr").tree("options").url='<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=baseAttrStore&cube_code="/>'+_code;
			  $("#attr").tree("reload");
			  timer = setInterval('loadFirstNode()',100);
 		  }
	  }
	  function addNewKpi(kpi_code,used_kpi,view_rule,server_class,url) {
		  var _cubeCode = $('#cube_code').val();
		  //$("#kpi").html("");
		  $("#kpi").load('<e:url value="'+url+'?kpi_category="/>'+current_node.id + '&cube_code='+_cubeCode+'&baseType=' + kpi_code+'&server_class='+server_class,'',function(){
			  $.parser.parse("#kpi");
			    var browser_width = $(".kpi_guide").eq(0).width();
				$('.tit_div1').css({'width':browser_width,'left':'281px' });
				$(window).resize(function() { 
					$('.tit_div1').css({'width':browser_width,'left':'281px' });
				}); 
		  });
	  } 
	  function queryBtnClick_(){
		  expandFlag = "2";
		  var keywords = $("#keywords_").val();
		  var _cubeCode = $('#cube_code').val();
		  var selectTabTitle = $('#treeTabs').tabs('getSelected').panel("options").title;
		  if(selectTabTitle == "指标") {
			  $("#tt").tree("options").url='<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=querynewLoadTree&cube_code="/>'+_cubeCode+'&isViewBaseKpi=${isViewBaseKpi}'+'&keywords=' + keywords;
			  $("#tt").tree("reload");
			  timer = setInterval('loadFirstNode()',100);
		  } else if(selectTabTitle == "维度"){
			  $("#dim").tree("options").url='<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=baseDimStore&cube_code="/>'+_cubeCode+'&keywords=' + keywords;
			  $("#dim").tree("reload");
		  } else {
			  $("#attr").tree("options").url='<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=baseAttrStore&cube_code="/>'+_cubeCode+'&keywords=' + keywords;
			  $("#attr").tree("reload");
		  }
	  }
	  function delKpi(kpi_key,kpi_code,kpi_version,kpi_flag){
		  
			$.messager.confirm('提示信息', "确认删除所选择的指标信息吗？", function(r){
				if (r){
					var url = '<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=deleteKpi"/>';
					if(kpi_flag == "3") {
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
//										var _data = $.parseJSON($.trim(data));
										 if(data==1){
											  $.messager.alert('提示信息','指标信息删除成功!','info');
// 											  $('#kpiTable').datagrid('reload');
			  								  $("#kpi").html("");
											  $('#tt').tree('reload',$('#tt').tree('getParent', current_node.target).target);
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
  --></script>
<style type="text/css">
.easyui-tabs .tabs-header, .easyui-tabs .tabs-panels{ border:none!important;}
</style>
 </head>
	 <body class="easyui-layout">
		<div data-options="region:'west',split:false" style="width:270px;padding:0px;">
			<div class="editBase_div_child">
				<dl class="ddLine">
					<dd style="width:100%;" class="searchDate">
				     	<input class="inputBox" type="text" class="fromOne"  id="keywords_" style="width:192px"/>
			    		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="queryBtnClick_()">查询</a>
					</dd>
					<dd>
						<span class="first-child">
						<select id="cube_code" onchange="loadTree()">
<!-- 						 	<option value="">--请选择--</option> -->
						 	<e:forEach items="${cube.list }" var="c">
						 		<option value="${c.CUBE_CODE }">${c.CUBE_NAME }</option>
						 	</e:forEach>
						 </select>
						 </span>
					</dd>
				</dl>
			</div>
			<e:if condition="${managerFlag == 'manager' }" var="elseManager">
				<div id="treeTabs" class="easyui-tabs kpi-easyui-tabs" style="width:267px;height:auto">
					 <div title="指标">
						 <ul id="tt"></ul>
					 </div>
					 <div title="维度">
						 <ul id="dim"></ul>
					 </div>
		 			 <div title="属性">
						 <ul id="attr"></ul>
					 </div>
				 </div>
			</e:if>
			<e:else condition="${elseManager}">
			 	 <div id="treeTabs" class="easyui-tabs kpi-easyui-tabs" style="width:267px;height:auto">
					<div title="指标">
					<ul id="tt"></ul>
					</div>
				 </div>
			</e:else>
		</div>
		<div data-options="region:'center'">
			<div id="kpi"></div>
		</div>
		<div id="createCatalogDlg" style="width:470px;height:210px;">
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
		<div id="editCategoryDlg" style="width:470px;height:210px;">
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
				<div class="compositeKpiCategoryFlush" data-options="iconCls:'ico-kpi-reflush'">刷新分类</div>
				<div onclick="javascript:createCatalog()" data-options="iconCls:'ico-kpi-new'">新建分类</div>
			</e:if>
		</div>
		<div id="compositeKpiCategoryMenu" class="easyui-menu" style="width: 120px">
			<e:if condition="${managerFlag == 'manager' }">
				<div class="compositeKpiCategoryFlush" data-options="iconCls:'ico-kpi-reflush'">刷新分类</div>
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
			<div id="compositeMoveTo" class="compositeKpiNodeMove" data-options="iconCls:'ico-kpi-move'">移动至...</div>
			<e:if condition="${managerFlag == 'manager' }">
				<div class="compositeKpiNodeSibship"  data-options="iconCls:'ico-kpi-blood'">血缘关系</div>
				<!-- <div class="coverage"  data-options="iconCls:'ico-kpi-range'">影响范围</div>-->
				<div class="compositeKpiNodeHistory" data-options="iconCls:'ico-kpi-his'">历史版本</div> 
			</e:if>
		</div>
		<div id="baseKpiNodeMenu" class="easyui-menu" style="width:120px;">
		    <div id="baseKpiNodeLook"  data-options="iconCls:'ico-kpi-see'">查看指标</div>
			<div class="compositeKpiNodeEdit"  data-options="iconCls:'ico-kpi-edit'">编辑指标</div>
			<div class="menu-sep"></div>
			<div id="baseKpiNodeDelete" data-options="iconCls:'ico-kpi-delete'">删除指标</div>
			<div id="baseKpiMoveTo" class="compositeKpiNodeMove" data-options="iconCls:'ico-kpi-move'">移动至...</div>
			<e:if condition="${managerFlag == 'manager' }">
				<div class="compositeKpiNodeSibship"  data-options="iconCls:'ico-kpi-blood'">血缘影响</div>
				<!-- <div class="coverage"  data-options="iconCls:'ico-kpi-range'">影响范围</div>-->
				<div class="compositeKpiNodeHistory" data-options="iconCls:'ico-kpi-his'">历史版本</div> 
			</e:if>
		</div>
		<div class="easyui-dialog" id="category_tree_dialog"
			title="双击目录即可移动此目录下"
			data-options="closed:true,top:30,modal:true"
			style="width: 330px; height: 380px; padding: 5px;">
			<a:tree id="category_tree" url="#" onLoadSuccess="extendRoot" onDblClick="moveToCategory"/>
		</div>
	 </body>
</html>