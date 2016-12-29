<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:set var="treeDataUrl"><e:url value="/menu/loardTree.e"/></e:set>
<e:q4l var="resourceTypeList" sql="frame.menuManager.resourceTypeList"/>
<e:q4l var="subsystems" sql="frame.menuManager.subsystemList"></e:q4l>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <title>系统菜单管理</title>
    <c:resources type="easyui" style="${ThemeStyle }"/>
    <e:style value="/resources/themes/base/boncBase@links.css"/>
    <script type="text/javascript">
    var currentLevel=1;
    var extendLevel=2;//树初始展开级数
    $(function(){
    	$("#tt").addClass("group").css("padding-bottom","100px");
		$(window).resize(function(){
		 	$('#tree_panel').panel('resize');
		});
    	$("#onContextMenuDiv").hide();
    	/*新建*/
    	$('#form_menuAdd').form({
			 url:'<e:url value="/pages/frame/portal/menu/menuAction.jsp?eaction=addTreeNode"/>',
			 onSubmit: function(){   
			 	var parentIdForAdd=$("#parentIdForAdd").val().replace(/[ ]/g,"");
			 	var resourceNameForAdd=$("#resourceNameForAdd").val().replace(/[ ]/g,"");
			 	var ajaxResult;
			 	$.ajax({  
			          type : "post",  
			          url : '<e:url value="/pages/frame/portal/menu/menuAction.jsp?eaction=checkRsourceName"/>',  
			          data : {"resourceName":resourceNameForAdd,"parentId":parentIdForAdd},  
			          async : false,  
			          success : function(data){  
			           ajaxResult=data;
			          }  
		         }); 
		         if(ajaxResult!=0) {
		         	$.messager.alert('信息提示', '该目录下已有该系统菜单名称！', 'info');
					return false;
		         }
		         return $(this).form('validate');  
		         
		    },   
	    	 success:function(data){
	    	 	$('#dialog_menuAdd').dialog('close');
	    	 	if(data == 1){
    				$.messager.alert('信息提示', '添加成功', 'info');
    				var sourceNode=$("#tt").tree('find',$("#currentIdForEdite").val());
					var sourceParentNode=$("#tt").tree('getParent',sourceNode.target);
    				if(sourceParentNode==null){
						$('#tt').tree('reload',sourceNode.target);
					}else{
						$('#tt').tree('reload',sourceParentNode.target);
					}
    				$('#form_menuAdd')[0].reset()
    				//功能资源池挂载功能菜单页面变量addFlag，记录管理员是否已挂载菜单
    				var addFlag=parent.document.getElementById('addFlag');
    				if(typeof(addFlag)!="undefined"){
    				   addFlag.value="added";
    				}
    			}else{
    				$('#dialog_menuAdd').dialog('open');
					$.messager.alert('信息提示', '添加失败', 'error');
    			}
		       	 
	    	 }
		});
		$('#dialog_menuAdd').dialog({
			title:"新增系统菜单",
			closed: true,
			modal: true,
			buttons:[{
				text:'提交',
				iconCls:'icon-ok',
				handler:function(){
					$('#form_menuAdd').submit();
					
				}
			}]
		});
		$('#ordForAdd').numberbox();
    	 /*新建结束*/
    	 
    	 /*修改*/
    	 
    	 $('#form_menuEdite').form({
			 url:'<e:url value="/pages/frame/portal/menu/menuAction.jsp?eaction=editeTreeNode"/>',
			 onSubmit: function(){   
			 	var parentIdForEdite=$("#parentIdForEdite").val().replace(/[ ]/g,"");
			 	var resourceNameForEdite=$("#resourceNameForEdite").val().replace(/[ ]/g,"");
			 	var resourceNameOldForEdite=$("#resourceNameOldForEdite").val().replace(/[ ]/g,"");
			 	if(resourceNameForEdite!=resourceNameOldForEdite){
				 	var ajaxResult;
				 	$.ajax({  
				          type : "post",  
				          url : '<e:url value="/pages/frame/portal/menu/menuAction.jsp?eaction=checkRsourceName"/>',  
				          data : {"resourceName":resourceNameForEdite,"parentId":parentIdForEdite},  
				          async : false,  
				          success : function(data){  
				           ajaxResult=data;
				          }  
			         }); 
			         if(ajaxResult!=0) {
			         	$.messager.alert('信息提示', '该目录下已有该系统菜单名称！', 'info');
						return false;
			         }
		         }
		         return $(this).form('validate');  
		         
		    },   
	    	 success:function(data){
	    	 	$('#dialog_menuEdite').dialog('close');
	    	 	if(data == 1){
    				$.messager.alert('信息提示', '修改成功', 'info');
					var sourceNode=$("#tt").tree('find',$("#currentIdForEdite").val());
					var sourceParentNode=$("#tt").tree('getParent',sourceNode.target);
    				$('#tt').tree('reload',sourceParentNode.target);
    				$('#form_menuEdite')[0].reset()
    			}else{
    				$('#dialog_menuEdite').dialog('open');
					$.messager.alert('信息提示', '修改失败', 'error');
    			}
		       	 
	    	 }
		});
		
    	$('#dialog_menuEdite').dialog({
			title:"修改系统菜单",
			closed: true,
			modal: true,
			buttons:[{
				text:'提交',
				iconCls:'icon-ok',
				handler:function(){
					$('#form_menuEdite').submit();
				}
			}]
		});
		$('#ordForEdite').numberbox();
		
		$('#dialog_selectRole').dialog({
			title:"菜单授权",
			closed: true,
			modal: true
		});
		
    	 /*修改结束*/
    	 
    	 /*选择角色开始*/
    	/* $('#window_SelectRoleForMenu').dialog({
			title:"选择角色",
			closed: true,
			modal: true,
			buttons:[{
				text:'提交',
				iconCls:'icon-ok',
				handler:function(){
					//$('#form_menuEdite').submit();
				}
			}]
		});
		*/
		/*选择角色结束*/
    	 
    	 
    	 
	});
   	function showContextMenu(e,node){
   		e.preventDefault();
		$(this).tree('select',node.target);
		$("#parentIdForAdd").val(node.id);
		$("#currentIdForEdite").val(node.id);
		//alert(node.attributes.authCreate>0);
		if(node.id!=0){
			$("#parentIdForEdite").val($('#tt').tree('getParent', node.target).id);
		}
		/*权限设置 开始*/
		if(node.attributes.authCreate>0){
			$("#onContextMenuDiv").menu("enableItem",$("#addButton")[0]); 
		}else{
			$("#onContextMenuDiv").menu("disableItem",$("#addButton")[0]);
		}
		if(node.attributes.authUpdate>0){
			$("#onContextMenuDiv").menu("enableItem",$("#editeButton")[0]);
			if($("#selectRoleButton").length!=0){
				$("#onContextMenuDiv").menu("enableItem",$("#selectRoleButton")[0]);
			}
		}else{
			$("#onContextMenuDiv").menu("disableItem",$("#editeButton")[0]);
			if($("#selectRoleButton").length!=0){
				$("#onContextMenuDiv").menu("disableItem",$("#selectRoleButton")[0]);
			}
		}
		
		if(node.attributes.authDelete>0){
			$("#onContextMenuDiv").menu("enableItem",$("#deleteButton")[0]);
		}else{
			$("#onContextMenuDiv").menu("disableItem",$("#deleteButton")[0]);
		}
		/*权限设置 结束*/
		
		$('#onContextMenuDiv').menu('show',{
			left: e.pageX,
			top: e.pageY
		});
   	}
   	function cutToOthers(targetNode, source, point){
   		 var tempTargetNode= $(this).tree('getNode', targetNode);
   		var targetId=tempTargetNode.id;
        var sourceId = source.id;
		var i=0;
		if(source.attributes.authUpdate==0){
			$.messager.alert('提示框','不能移动！您没有修改菜单‘'+source.text+'’的权限!',function(){ 
				 	currentLevel=1;
					$("#tt").tree('reload');
			});
			
		}else{
	        $.messager.confirm('确认提示框','是否将‘'+source.text+'’移动到‘'+tempTargetNode.text+'’，请确认！',function(r){   
			      if (r){   
			          $.ajax({  
				          type : "post",  
				          url : '<e:url value="/pages/frame/portal/menu/menuAction.jsp?eaction=cutToOthers"/>',  
				          data : {"sourceId":sourceId,"targetId":targetId},  
				          async : false,  
				          success : function(data){ 
				         	if(data == 1){
			    				$.messager.alert('信息提示', '移动成功', 'info');
			    				
			    			}else{
								$.messager.alert('信息提示', '移动失败', 'error');
								currentLevel=1;
								$("#tt").tree('reload');
			    			}
			    			
				          }  
			         });  
			      }else{
			      	currentLevel=1;
			      	$("#tt").tree('reload');
			    			
			      	 /*
				      	 $("#tt").tree('reload',tempTargetNode.target);
				      	 var sourceNode=$("#tt").tree('find',source.id);
						 var sourceParentNode=$("#tt").tree('getParent',sourceNode.target);
				      	 $("#tt").tree('reload',sourceParentNode.target);
			      	 */
			      	 
			      }
			
			  });  
		}
   	
   	}
   	var hasExtenFirstFlag=false;
   	function extendAll(node,data){
   		if(extendLevel==2){//当默认展开两级的时候，只展开第2级的第一个目录
   			if(currentLevel<extendLevel){
	   			$(this).tree('expandAll');
	   			currentLevel++;
	  			if((extendLevel-currentLevel)==1){//是否是要展开的最后一级
	   				if(!hasExtenFirstFlag){
	   					hasExtenFirstFlag=true;
	   					var rootNodes=$(this).tree('getRoots');
	   					var tempchildrenNodes=rootNodes;
	   					var firstchildrenNode = rootNodes[0];
	   					for(var a=0;a<extendLevel;a++){
	   						tempchildrenNodes=$(this).tree('getChildren',firstchildrenNode.target);
	   						if(tempchildrenNodes!=null&&tempchildrenNodes.length>0){
	   							firstchildrenNode=tempchildrenNodes[0];
	   							$(this).tree('expand',firstchildrenNode.target);
	   						}else{
	   							break;
	   						}
	   					}
	   					//alert(firstchildrenNode.text);
	   					
	   					
	   				}
	   			}else{
	   				$(this).tree('expandAll');
	   				currentLevel++;
	   			}
	   			
	   		}
   		}else{
   			if(currentLevel<extendLevel){
   				$(this).tree('expandAll');
	   			currentLevel++;
   			}
   			
   		}
   		
   		
   	}
   function clickNode(node){
   		var isleaf = $(this).tree('isLeaf',node.target);
		if(!isleaf){
			$(this).tree('toggle',node.target);     //当是目录的时候 弹出叶子节点
		}
   }
   	/*展开 只展开一个目录*/
   	function expandNode(node){
   		var treeOnlyExpandOneNode='${treeOnlyExpandOneNode}';
   		if(treeOnlyExpandOneNode!='0'){
	   		var parentNode=$(this).tree('getParent',node.target);
	   		var childrenNode=null;
	   		if(parentNode!=null){
	   			childrenNode=$(this).tree('getChildren',parentNode.target);
	   		}else{
	   			childrenNode=$(this).tree('getRoots');
	   		}
	   		if(childrenNode!=null){
	   			for(var i=0;i<childrenNode.length;i++){
	   				if(childrenNode[i].id!=node.id){
	   					$(this).tree('collapse',childrenNode[i].target);
	   				}
	   			}
	   		}
   		}
   	}
   	/**新建*/
   	function addMenu(){
   		$('#dialog_menuAdd').dialog('open');
   	}
   	/**修改*/
   	function updateMenu(){
   		var currentIdForEdite=$("#currentIdForEdite").val();
   		 $.post('<e:url value="/pages/frame/portal/menu/menuAction.jsp?eaction=getOneResource"/>',{"currentIdForEdite":currentIdForEdite},function(data){
   			 $("#resourceNameForEdite").val(data.RESOURCES_NAME);
   			 $("#resourceNameOldForEdite").val(data.RESOURCES_NAME);
   			 $("#resourceTypeForEdite").val(data.RESOURCES_TYPE);
   			 $("#urlForEdite").val(data.URL);
   			// alert('<e:url value="'+data.ATTACHMENT+'"/>');
   			 $("#attachmentFileShow").attr("src",'<e:url value="'+data.ATTACHMENT+'"/>');
   			 $("#ext1ForEdite").val(data.EXT1);
   			 $("#ext2ForEdite").val(data.EXT2);
   			 $("#ext3ForEdite").val(data.EXT3);
   			 $("#ext4ForEdite").val(data.EXT4);
   			 $("#memoForEdite").val(data.MEMO);
   			 $("#ordForEdite").numberbox("setValue",data.ORD);
   			 $("#resourceStateForEdite").val(data.RESOURCE_STATE);
   			 
   			 //attachmentFileShow
		},"json");
   		$('#dialog_menuEdite').dialog('open');
   	}
    /**删除*/
   	function deleteMenu(){
	   	var currentNodeId=$("#currentIdForEdite").val();
	   	var currentNode=$("#tt").tree('find',currentNodeId);
		var currentParentNode=$("#tt").tree('getParent',currentNode.target);
	   	$.messager.confirm("操作提示", "将删除该结点及子结点,您确定要执行操作吗？", function (data) {
	        if (data) {
                $.ajax({  
			          type : "post",  
			          url : '<e:url value="/menu/removeTreeNode.e"/>',  
			          data : {"currentNodeId":currentNodeId},  
			          async : false,  
			          success : function(data){
			          	  if(data != 0){
			    				$.messager.alert('信息提示', '删除成功', 'info');
			    				$('#tt').tree('reload',currentParentNode.target);
			    			}else{
								$.messager.alert('信息提示', '删除失败', 'error');
			    			}
			          }  
		         }); 
            }
        });
   	}
   	/*选择角色*/
   	function selectRoleForMenu(){
   		var currentIdForSelectRole=$("#currentIdForEdite").val();
		$("#iframe_selectRole").attr("src",'<e:url value="/pages/frame/portal/menu/menuRoleManager.jsp"/>?currentNodeId='+currentIdForSelectRole);
		$('#dialog_selectRole').dialog("open");
		/*
   		var iWidth = 1020;
		var iHeight = 480;
		var iTop = (window.screen.availHeight - 30 - iHeight) / 2;
		var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;
		var win = window.open('<e:url value="/pages/frame/portal/menu/menuRoleManager.jsp"/>?currentNodeId='+currentIdForSelectRole, "弹出窗口", "width=" + iWidth + ", height=" + iHeight + ",top=" + iTop + ",left=" + iLeft + ",toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no,alwaysRaised=yes,depended=yes");
		*/
		   		
   	}
   	function menuHandler(item){
		if(item.id!=null&&item.id!=undefined){
			if(item.id=='addButton'){
				addMenu();
			}else if(item.id=='editeButton'){
				updateMenu();
			}else if(item.id=='deleteButton'){
				deleteMenu();
			}else if(item.id=='selectRoleButton'){
				selectRoleForMenu();
			}
		}
	}
	
   	
   	/*选择角色
   	function selectRoleForMenu(){
   		var currentIdForSelectRole=$("#currentIdForEdite").val();
   		window.showModalDialog('<e:url value="/pages/frame/portal/menu/menuRoleManager.jsp"/>?currentNodeId='+currentIdForSelectRole,window,'dialogWidth=1020px;dialogHeight=480px;center:yes;help:no;scroll:yes;status:no;resizable:no;minimize:no;maximize:no;');
   	}*/
    </script>
  </head>
  
  <body>
  		<div class="contents-head" id="tb">
  			<h2>菜单维护</h2>
  		</div>
    	<div id="tree_panel" class="easyui-panel" title="" fit="true" border="false" data-options="fit:true, border:false,toolbar:'#tb'">
    		<a:tree id="tt" url='${treeDataUrl}' checkbox="false" onContextMenu="showContextMenu" dnd="true" onDrop="cutToOthers" onLoadSuccess="extendAll" onExpand="expandNode" onClick="clickNode"/>
    	</div>
    	<!--//右键弹出  -->
    	<div id="onContextMenuDiv" class="easyui-menu" style="width:120px;" data-options="onClick:menuHandler">
			<div id="addButton" data-options="iconCls:'icon-add'">新增</div>
			<div id="editeButton" data-options="iconCls:'icon-edit'">修改</div>
			<div id="deleteButton" data-options="iconCls:'icon-cancel'">删除</div>
			<e:if condition="${MenuFuQuan!='0'}">
				<!-- 是否可以为菜单授权 -->
				<div id="selectRoleButton" data-options="iconCls:'icon-man'">授权</div>
			</e:if>
		</div>
		<!-- //新建 -->
		<div id="dialog_menuAdd" style="width:800px;height:380px;top: 40px">
			<form id="form_menuAdd" name="form_menuAdd" method="post" enctype="multipart/form-data">
				<input type="hidden" id="parentIdForAdd" name="parentIdForAdd" value=""/>
				<table class="windowsTable">
					<colgroup>
						<col width="16%" />
						<col width="*" />
						<col width="16%" />
						<col width="*" />
					</colgroup>
					<tr>
						<th>系统菜单状态：</th>
						<td>
							<select id="resourceStateForAdd" name="resourceStateForAdd" style="width:165px;">
									<option value="1">数据开发中</option>
									<option value="2">程序开发中</option>
									<option value="3" selected="selected">开放</option>
							</select>
						</td>
						<th>系统菜单名称：</th>
						<td><input type="text" style="width:165px;" id="resourceNameForAdd" name="resourceNameForAdd" class="easyui-validatebox"  required validType="length[1,50]" missingMessage="不能为空"/></td>
					</tr>
					<tr>
						<th>系统菜单类型：</th>
						<td>
							<select id="resourceTypeForAdd" name="resourceTypeForAdd" style="width:165px;">
								<e:forEach items="${resourceTypeList.list}" var="item">
									<option value="${item.RESOURCES_TYPE_ID }">${item.RESOURCES_TYPE_NAME }</option>
								</e:forEach>
							</select>
						</td>
						<th>系统菜单路径：</th>
						<td><input type="text" id="urlForAdd" name="urlForAdd" class="easyui-validatebox" style="width:165px;"  validType="length[1,500]"/></td>
					</tr>
					
					<tr>
						<th>系统菜单图标：</th>
						<td>
							<input type="file"  id="attachmentForAdd" name="attachmentForAdd"/>
						</td>
						<th>子系统：</th>
						<td>
						<e:select id="ext1ForAdd" style="width:165px;" name="ext1ForAdd" items="${subsystems.list}"
								label="SUBSYSTEM_NAME" value="SUBSYSTEM_ID" headValue="" headLabel="请选择"/>
						<!--<input type="text"   id="ext1ForAdd" name="ext1ForAdd" class="easyui-validatebox"  validType="length[1,500]"/>
						-->
						</td>
					</tr>
					<tr>
						<th>扩展字段2：</th>
						<td><input type="text" id="ext2ForAdd" name="ext2ForAdd" class="easyui-validatebox"  validType="length[1,500]"/></td>
						<th>扩展字段3：</th>
						<td><input type="text" id="ext3ForAdd" name="ext3ForAdd" class="easyui-validatebox"  validType="length[1,500]"/></td>
					</tr>
					
					<tr>
						<th>扩展字段4：</th>
						<td><input type="text" id="ext4ForAdd" name="ext4ForAdd" class="easyui-validatebox" validType="length[1,500]"/></td>
						<th>排序：</th>
						<td>
							<input type="text" id="ordForAdd" name="ordForAdd" value="1" class="easyui-numberbox" required missingMessage="不能为空"/>
						</td>
					</tr>
					<tr>
						<th>系统菜单描述：</th>
						<td>
							<textarea  id="memoForAdd" name="memoForAdd" rows="2" cols="38"></textarea>
						</td>
					</tr>
				</table>
			</form>
		</div>
		
		<!-- //修改-->
		<div id="dialog_menuEdite" style="width:800px;height:380px;top: 40px">
			<form id="form_menuEdite" name="form_menuEdite" method="post" enctype="multipart/form-data">
				<input type="hidden" id="currentIdForEdite" name="currentIdForEdite" value=""/>
				<input type="hidden" id="parentIdForEdite" name="parentIdForEdite" value=""/>
				<table class="windowsTable">
				<colgroup>
						<col width="16%" />
						<col width="*" />
						<col width="16%" />
						<col width="*" />
					</colgroup>
					<tr>
						<th>系统菜单状态：</th>
						<td>
							<select id="resourceStateForEdite" style="width:165px;" name="resourceStateForEdite" >
									<option value="1">数据开发中</option>
									<option value="2">程序开发中</option>
									<option value="3">开放</option>
							</select>
						</td>
						<th>系统菜单名称：</th>
						<td>
							<input type="text" style="width:165px;" id="resourceNameForEdite" name="resourceNameForEdite" class="easyui-validatebox"  required validType="length[1,50]" missingMessage="不能为空"/>
							<input type="hidden" id="resourceNameOldForEdite" name="resourceNameOldForEdite"/>
						</td>
					</tr>
					<tr>
						<th>系统菜单类型：</th>
						<td>
							<select id="resourceTypeForEdite" style="width:165px;" name="resourceTypeForEdite">
								<e:forEach items="${resourceTypeList.list}" var="item">
									<option value="${item.RESOURCES_TYPE_ID }">${item.RESOURCES_TYPE_NAME }</option>
								</e:forEach>
							</select>
						</td>
						<th>系统菜单路径：</th>
						<td><input type="text" id="urlForEdite" name="urlForEdite" class="easyui-validatebox"  validType="length[1,500]"/></td>
						
					</tr>
					<tr>
						<th>系统菜单图标：</th>
						<td>
							<img id="attachmentFileShow" name="attachmentFileShow" height="20" style="vertical-align: bottom;margin-right: 5px"><input type="file"   style="width:230px;" id="attachmentForEdite" name="attachmentForEdite"/>
						</td>
						<th>子系统：</th>
						<td>
						<e:select id="ext1ForEdite"   style="width:165px;" name="ext1ForEdite" items="${subsystems.list}"
								label="SUBSYSTEM_NAME" value="SUBSYSTEM_ID" headValue="" headLabel="请选择"/>
						
						<!--<input type="text"  id="ext1ForEdite" name="ext1ForEdite" class="easyui-validatebox"  validType="length[1,500]"/>
						-->
						</td>
					</tr>
					<tr>
						<th>扩展字段2：</th>
						<td><input type="text"  id="ext2ForEdite" name="ext2ForEdite" class="easyui-validatebox"  validType="length[1,500]"/></td>
						<th>扩展字段3：</th>
						<td><input type="text"  id="ext3ForEdite" name="ext3ForEdite" class="easyui-validatebox"  validType="length[1,500]"/></td>
					</tr>
					<tr>
						<th>扩展字段4：</th>
						<td><input type="text"  id="ext4ForEdite" name="ext4ForEdite" class="easyui-validatebox"  validType="length[1,500]"/></td>
						<th>排序：</th>
						<td>
							<input type="text" id="ordForEdite" name="ordForEdite" value="1" class="easyui-numberbox"  required missingMessage="不能为空"/>
						</td>
					</tr>
					<tr>
						<th>系统菜单描述：</th>
						<td>
							<textarea  id="memoForEdite" name="memoForEdite" rows="2" cols="38"  style="width:240px;" ></textarea>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<!-- //修改-->
		<div id="dialog_selectRole" style="width:1200px;height:468px;top:90px">
			<iframe id="iframe_selectRole" src="" width="100%" height="100%" frameBorder="0"></iframe>
		</div>
		
  </body>
</html>
