<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:set var="treeDataUrl"><e:url value="role/getRoleTree.e"/></e:set>
<e:q4l var="subsystems" sql="frame.roleManager.subsystems"></e:q4l>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <title>系统菜单管理</title>
    <c:resources type="easyui" style="${ThemeStyle }"/>
    <e:style value="/resources/themes/base/boncBase@links.css"/>
    <script type="text/javascript">
    var currentLevel=1;
    var extendLevel=2;//树初始展开级数
    var rolesOfUser=[];
    var isAdmin='${sessionScope.UserInfo.ADMIN}';
    var isRoot=0;
    $(function(){
    	 $.ajax({  
    	        type : "post",  
    	        url : '<e:url value="role/getRolesOfUsers.e"/>',  
    	        data : {},  
    	        async : false,  
    	        success : function(data){  
    	        	rolesOfUser = $.trim(data).split(",");
    	        }  
    	 });
    	 
    	 for(var i=0;i<rolesOfUser.length;i++){
			if(rolesOfUser[i]=='0'){
				isRoot=1;
			}
		}
		$(window).resize(function(){
		 	$('#tree_panel').panel('resize');
		});
    	$("#onContextMenuDiv").hide();
    	$("#roleU").dialog({
			width:1100,
			height:450,
			modal:true,
			closed:true,
			top:90
		});
    	$("#roleA").dialog({
			width:'92%',
			height:'97%',
			modal:true,
			closed:true,
			top:5
		});
    	
    	
    	/*新建*/
    	$('#form_roleAdd').form({
			 url:'<e:url value="/pages/frame/portal/role/RoleAction.jsp?eaction=addTreeNode"/>',
			 onSubmit: function(){   
			 	var parentIdForAdd=$("#parentIdForAdd").val().replace(/[ ]/g,"");
			 	var roleNameForAdd=$("#roleNameForAdd").val().replace(/[ ]/g,"");
			 	var ajaxResult;
			 	$.ajax({  
			          type : "post",  
			          url : '<e:url value="/pages/frame/portal/role/RoleAction.jsp?eaction=checkRoleName"/>',  
			          data : {"roleName":roleNameForAdd,"parentId":parentIdForAdd},  
			          async : false,  
			          success : function(data){  
			           ajaxResult=data;
			          }  
		         }); 
		         if($.trim(ajaxResult)!=0) {
		         	$.messager.alert('信息提示', '该目录下已有该角色名称！', 'info');
					return false;
		         }
		         return $(this).form('validate');
		    },   
	    	 success:function(data){
	    	 	$('#dialog_roleAdd').dialog('close');
	    	 	if(data == 1){
    				$.messager.alert('信息提示', '添加成功', 'info');
    				var sourceNode=$("#tt").tree('find',$("#parentIdForAdd").val());
					var sourceParentNode=$("#tt").tree('getParent',sourceNode.target);
					if(sourceParentNode==null){
						$('#tt').tree('reload',null);
					}else{
						$('#tt').tree('reload',sourceParentNode.target);
					}
    				
    				$('#form_roleAdd')[0].reset()
    			}else{
    				$('#dialog_roleAdd').dialog('open');
					$.messager.alert('信息提示', '添加失败', 'error');
    			}
		       	 
	    	 }
		});
		$('#dialog_roleAdd').dialog({
			title:"新增角色",
			closed: true,
			modal: true,
			buttons:[{
				text:'提交',
				iconCls:'icon-ok',
				handler:function(){
					$('#form_roleAdd').submit();
					
				}
			}]
		});
		$('#ordForAdd').numberbox();
    	 /*新建结束*/
    	
    	
    	
    	/*修改*/
    	 $('#form_roleEdite').form({
			 url:'<e:url value="/pages/frame/portal/role/RoleAction.jsp?eaction=editeTreeNode"/>',
			 onSubmit: function(){   
			 	var parentIdForEdite=$("#parentIdForEdite").val().replace(/[ ]/g,"");
			 	var roleNameForEdite=$("#roleNameForEdite").val().replace(/[ ]/g,"");
			 	var roleNameOldForEdite=$("#roleNameOldForEdite").val().replace(/[ ]/g,"");
			 	if(roleNameForEdite!=roleNameOldForEdite){
				 	var ajaxResult=0;
				 	$.ajax({  
				          type : "post",  
				          url : '<e:url value="/pages/frame/portal/role/RoleAction.jsp?eaction=checkRoleName"/>',  
				          data : {"roleName":roleNameForEdite,"parentId":parentIdForEdite},  
				          async : false,  
				          success : function(data){  
				           ajaxResult=data;
				          }  
			         });
			         if(ajaxResult!=0) {
			         	$.messager.alert('信息提示', '该目录下已有该角色名称！', 'info');
						return false;
			         }
		         }
		         return $(this).form('validate');  
		         
		    },   
	    	 success:function(data){
	    	 	$('#dialog_roleEdite').dialog('close');
	    	 	if(data == 1){
    				$.messager.alert('信息提示', '修改成功', 'info');
					var sourceNode=$("#tt").tree('find',$("#currentIdForEdite").val());
					var sourceParentNode=$("#tt").tree('getParent',sourceNode.target);
    				$('#tt').tree('reload',sourceParentNode.target);
    				$('#form_roleEdite')[0].reset()
    			}else{
    				$('#dialog_roleEdite').dialog('open');
					$.messager.alert('信息提示', '修改失败', 'error');
    			}
		       	 
	    	 }
		});
		
    	$('#dialog_roleEdite').dialog({
			title:"修改角色",
			closed: true,
			modal: true,
			buttons:[{
				text:'提交',
				iconCls:'icon-ok',
				handler:function(){
					$('#form_roleEdite').submit();
				}
			}]
		});
		$('#ordForEdite').numberbox();
    	 /*修改结束*/
	});
	
	/*是否具有操作访结点的权限*/
	function hasOporateAble(nodeId){
			var canEditeFlag=false;
			var node=$("#tt").tree('find',nodeId);
			var tempParentNode=$('#tt').tree('getParent', node.target);
			while(tempParentNode!=null){
				for(var i=0;i<rolesOfUser.length;i++){
					if(rolesOfUser[i]==tempParentNode.id){
						canEditeFlag=true;
					}
				}
				tempParentNode=$('#tt').tree('getParent', tempParentNode.target);
			}
			if(isAdmin=='1'||isRoot=='1'){//系统管理员，可以修改
				canEditeFlag=true;
			}
			return canEditeFlag;
	}
	
	/*是否 当前结点为当前用户所属角色，可以增加子结点*/
	function hasOporateAbleForAdd(nodeId){
			var canAdd=false;
			for(var i=0;i<rolesOfUser.length;i++){
				if(rolesOfUser[i]==nodeId){
					canAdd=true;
				}
			}
			if(isAdmin=='1'||isRoot=='1'){//系统管理员，可以修改
				canAdd=true;
			}
			return canAdd;
	}
	
   	function showContextMenu(e,node){
   		e.preventDefault();
		$(this).tree('select',node.target);
		$("#parentIdForAdd").val(node.id);
		$("#currentIdForEdite").val(node.id);
		$("#currentIdForSubSystem").val(node.id);
		
		var canAdd=hasOporateAbleForAdd(node.id);//选中结点为当前用户所属角色，可以增加子结点
		
		/*控制是否可修改*/
		var canEditeFlag=hasOporateAble(node.id);
		
		if(node.id!=0){
			var parentNode = $('#tt').tree('getParent', node.target);
			if(parentNode!=null){
				$("#parentIdForEdite").val(parentNode.id);
			}else{
				$.ajax({  
			          type : "post",  
			          url : '<e:url value="/pages/frame/portal/role/RoleAction.jsp?eaction=getParentId"/>',  
			          data : {"currentRoleCode":node.id},  
			          async : false,  
			          success : function(data){ 
			        	  data = $.trim(data);
			        	  $("#parentIdForEdite").val(data);
			          }  
		         });
			}
			
		}
		
		/*权限设置 开始*/
		if(canEditeFlag){
			$("#onContextMenuDiv").menu("enableItem",$("#addButton")[0]); 
			$("#onContextMenuDiv").menu("enableItem",$("#editeButton")[0]); 
			$("#onContextMenuDiv").menu("enableItem",$("#deleteButton")[0]); 
			//$("#onContextMenuDiv").menu("enableItem",$("#subSystemButton")[0]);
			$("#onContextMenuDiv").menu("enableItem",$("#userButton")[0]); 
			$("#onContextMenuDiv").menu("enableItem",$("#menuButton")[0]); 
		}else{
			$("#onContextMenuDiv").menu("disableItem",$("#addButton")[0]); 
			$("#onContextMenuDiv").menu("disableItem",$("#editeButton")[0]); 
			$("#onContextMenuDiv").menu("disableItem",$("#deleteButton")[0]); 
			//$("#onContextMenuDiv").menu("disableItem",$("#subSystemButton")[0]); 
			$("#onContextMenuDiv").menu("disableItem",$("#userButton")[0]); 
			$("#onContextMenuDiv").menu("disableItem",$("#menuButton")[0]); 
		}
		
		if(canAdd){
			$("#onContextMenuDiv").menu("enableItem",$("#addButton")[0]); 
		}
		/*权限设置 结束*/
		
		$('#onContextMenuDiv').menu('show',{
			left: e.pageX,
			top: e.pageY
		});
   	}
   	
   function menuHandler(item){
		if(item.id!=null&&item.id!=undefined){
			if(item.id=='addButton'){
				addRole();
			}else if(item.id=='editeButton'){
				updateRole();
			}else if(item.id=='deleteButton'){
				deleteRole();
			//}else if(item.id=='subSystemButton'){
			//	editeSubSystem();	
			}else if(item.id=='userButton'){
				updateUser();
			}else if(item.id=='menuButton'){
				updateMenu();
			}
		}
	}
	
	/*获取结点所在级别 不用了*/
	function getNodeLevel(nodeId){
		var currentNode=$("#tt").tree('find',nodeId);
		var levelNume=1;
	   	var tempParentNode=$('#tt').tree('getParent', currentNode.target);
		while(tempParentNode!=null){
			levelNume++;
			tempParentNode=$('#tt').tree('getParent', tempParentNode.target);
		}
		return levelNume;
	}
	
	/**新建*/
   	function addRole(){
	   	$("#roleNameForAdd").val("");
	   	$("#memoForAdd").val("");
	   	$("#ordForAdd").numberbox("setValue",1);
   		$('#dialog_roleAdd').dialog('open');
   	}
   	/**修改*/
   	function updateRole(){
   		var currentIdForEdite=$("#currentIdForEdite").val();
   		 $.post('<e:url value="/pages/frame/portal/role/RoleAction.jsp?eaction=getOneTreeNode"/>',{"currentIdForEdite":currentIdForEdite},function(data){
   		 		$("#roleNameForEdite").val(data.ROLE_NAME);
   		 		$("#subSystemIdForEdite").val(data.SUBSYSTEM_ID);
   		 		$("#roleNameOldForEdite").val(data.ROLE_NAME);
			   	$("#memoForEdite").val(data.MEMO);
			   	$("#ordForEdite").numberbox("setValue",data.ORD);
			   
		},"json");
   		$('#dialog_roleEdite').dialog('open');
   		
   		
   	}
    /**删除*/
   	function deleteRole(){
	   	var currentNodeId=$("#parentIdForAdd").val();
	   	var currentNode=$("#tt").tree('find',currentNodeId);
		var currentParentNode=$("#tt").tree('getParent',currentNode.target);
	   	$.messager.confirm("操作提示", "将删除该结点及子结点,您确定要执行操作吗？", function (data) {
	        if (data) {
                $.ajax({  
			          type : "post",  
			          url : '<e:url value="role/deleteRole.e"/>',  
			          data : {"currentNodeId":currentNodeId},  
			          async : false,  
			          success : function(data){
			          	  if(data != "0"){
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
   	
 	/*用户*/	
	function updateUser(){
		var currentIdForSelectUser=$("#currentIdForEdite").val();
		if(window.navigator.userAgent.indexOf("Chrome") !== -1) {
			
			$("#roleU").dialog('open');
			$('#roleUwin').load('<e:url value="/pages/frame/portal/role/RoleUserManager_load.jsp"/>',{width:1000,height:620,currentNodeId:currentIdForSelectUser},function (data){});
		  //window.open('<e:url value="/pages/frame/portal/role/RoleUserManager.jsp"/>?currentNodeId='+currentIdForSelectUser);
		}else{
			window.showModalDialog('<e:url value="/pages/frame/portal/role/RoleUserManager.jsp"/>?currentNodeId='+currentIdForSelectUser,window,'dialogWidth=1020px;dialogHeight=480px;center:yes;help:no;scroll:yes;status:no;resizable:no;minimize:no;maximize:no;');
		}
   		//window.showModalDialog('<e:url value="/pages/frame/portal/role/RoleUserManager.jsp"/>?currentNodeId='+currentIdForSelectUser,window,'dialogWidth=1020px;dialogHeight=480px;center:yes;help:no;scroll:yes;status:no;resizable:no;minimize:no;maximize:no;');
	}			
		
	/*授权*/
	function updateMenu(){
		var currentIdForSelectUser=$("#currentIdForEdite").val();
   		//window.showModalDialog('<e:url value="/pages/frame/portal/role/RoleAuthOrization.jsp"/>?roleIdInput='+currentIdForSelectUser,window,'dialogWidth=1020px;dialogHeight=480px;center:yes;help:no;scroll:yes;status:no;resizable:no;minimize:no;maximize:no;');
		if(window.navigator.userAgent.indexOf("Chrome") !== -1) {
			$("#roleA").dialog('open');
			$('#roleAwin').load('<e:url value="/pages/frame/portal/role/RoleAuthorize_load.jsp"/>',{width:1000,height:580,roleIdInput:currentIdForSelectUser},function (data){});
		 
			//window.open('<e:url value="/pages/frame/portal/role/RoleAuthorize.jsp"/>?roleIdInput='+currentIdForSelectUser);
		}else{
			window.showModalDialog('<e:url value="/pages/frame/portal/role/RoleAuthorize.jsp"/>?roleIdInput='+currentIdForSelectUser,window,'dialogWidth=1020px;dialogHeight=480px;center:yes;help:no;scroll:yes;status:no;resizable:no;minimize:no;maximize:no;');
		}
   		
   		//window.showModalDialog('<e:url value="/pages/frame/portal/role/RoleAuthorize.jsp"/>?roleIdInput='+currentIdForSelectUser,window,'dialogWidth=1020px;dialogHeight=480px;center:yes;help:no;scroll:yes;status:no;resizable:no;minimize:no;maximize:no;');
		
	}
	function cutToOthers(targetNode, source, point){
   		 var tempTargetNode= $(this).tree('getNode', targetNode);
   		var targetId=tempTargetNode.id;
        var sourceId = source.id;
		var i=0;
		var canAddForTarget=hasOporateAbleForAdd(targetId);
		var canEditeFlagForTarget=hasOporateAble(targetId);
		var canEditeFlagForSource=hasOporateAble(sourceId);
		if(!canAddForTarget&&!canEditeFlagForTarget){
			$.messager.alert('提示框','不能移动！您对菜单‘'+tempTargetNode.text+'’没有添加的的权限!');
			currentLevel=1;
			$("#tt").tree('reload');
			return false;
			
		}
		if(!canEditeFlagForSource){
			$.messager.alert('提示框','不能移动！您对菜单‘'+source.text+'’没有修改的权限!');
			currentLevel=1;
			$("#tt").tree('reload');
			return false;
			
		}
        $.messager.confirm('确认提示框','是否将‘'+source.text+'’移动到‘'+tempTargetNode.text+'’，请确认！',function(r){   
		      if (r){
		      		$.ajax({  
				          type : "post",  
				          url : '<e:url value="/pages/frame/portal/role/RoleAction.jsp?eaction=cutToOthers"/>',  
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
		    			
		      }
		
		  });  
		
   	
   	}		
   	var hasExtenFirstFlag=false;
   	function extendAll(node,data){
   		if(extendLevel==2){//当默认展开两级的时候，只展开第2级的第一个目录
   			if(currentLevel<extendLevel){
	  			if((extendLevel-currentLevel)==1){//是否是要展开的最后一级
	   				if(!hasExtenFirstFlag){
	   					hasExtenFirstFlag=true;
	   					var rootNodes=$(this).tree('getRoots');
	   					var tempchildrenNodes=rootNodes;
	   					var firstchildrenNode = rootNodes[0];
	   					$(this).tree('expand',firstchildrenNode.target);
	   					/* for(var a=0;a<extendLevel;a++){
	   						tempchildrenNodes=$(this).tree('getChildren',firstchildrenNode.target);
	   						if(tempchildrenNodes!=null&&tempchildrenNodes.length>0){
	   							firstchildrenNode=tempchildrenNodes[0];
	   							$(this).tree('expand',firstchildrenNode.target);
	   						}else{
	   							break;
	   						}
	   					} */
	   					
	   					
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
	   			childrenNode=$(this).tree('getRoots',parentNode.target);
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
   	
    </script>
  </head>
  
  <body>
  		<div class="contents-head" id="tb">
  			<h2>角色维护</h2>
  		</div>
    	<div id="tree_panel" class="easyui-panel" title="" fit="true" border="false">
    		<a:tree id="tt" url='${treeDataUrl}' checkbox="false" onContextMenu="showContextMenu" dnd="true" onDrop="cutToOthers" onLoadSuccess="extendAll" onExpand="expandNode" onClick="clickNode"/><!--  onDrop="cutToOthers" -->
    	</div>
    	<!--//右键弹出  -->
    	<div id="onContextMenuDiv" class="easyui-menu" style="width:120px;"  data-options="onClick:menuHandler">
			<div id="addButton" data-options="iconCls:'icon-add'">新增</div>
			<div id="editeButton" data-options="iconCls:'icon-edit'">修改</div>
			<div class="menu-sep"></div>
			<div id="deleteButton" data-options="iconCls:'icon-cancel'">删除</div>
			<!--<div id="subSystemButton" data-options="iconCls:'icon-print'">子系统</div>
			<div class="menu-sep"></div>
			--><div id="userButton" data-options="iconCls:'icon-tip'">用户</div>
			<div id="menuButton" data-options="iconCls:'icon-man'">授权</div>
			
		</div>
		
		<!-- //新建 -->
		<div id="dialog_roleAdd" style="width:500px;height:320px;top:90px">
			<form id="form_roleAdd" name="form_roleAdd" method="post">
				<input type="hidden" id="parentIdForAdd" name="parentIdForAdd" value=""/>
				<table class="windowsTable">
					<tr>
						<th>角色名称：</th>
						<td><input type="text" id="roleNameForAdd" name="roleNameForAdd" class="easyui-validatebox"  required validType="length[1,50]" missingMessage="不能为空"/></td>
					</tr>
					<tr>
						<th>子系统：</th>
						<td>
							<e:select id="subSystemIdForAdd" name="subSystemIdForAdd" style="width:168px" items="${subsystems.list}" label="SUBSYSTEM_NAME" value="SUBSYSTEM_ID" headValue="-1" headLabel="请选择"/>
						</td>
					</tr>
					<tr>
						<th>排序：</th>
						<td>
							<input type="text" id="ordForAdd" name="ordForAdd" value="1" class="easyui-validatebox" style="width:168px" required missingMessage="不能为空"/>
						</td>
					</tr>
					<tr>
						<th>系统菜单描述：</th>
						<td>
							<textarea  id="memoForAdd" name="memoForAdd" rows="4" cols="38"></textarea>
						</td>
					</tr>
					
				</table>
			</form>
		</div>
		
		
		<!-- //修改-->
		<div id="dialog_roleEdite" style="width:500px;height:320px;top:90px;">
			<form id="form_roleEdite" name="form_roleEdite" method="post">
				<input type="hidden" id="currentIdForEdite" name="currentIdForEdite" value=""/>
				<input type="hidden" id="parentIdForEdite" name="parentIdForEdite" value=""/>
				<table class="windowsTable">
					<tr>
						<th>角色名称：</th>
						<td>
							<input type="text" id="roleNameForEdite" name="roleNameForEdite" class="easyui-validatebox" required validType="length[1,50]" missingMessage="不能为空"/>
							<input type="hidden" id="roleNameOldForEdite" name="roleNameOldForEdite" class="easyui-validatebox"  required validType="length[1,50]" missingMessage="不能为空"/>
						</td>
					</tr>
					<tr>
						<th>子系统：</th>
						<td>
							<e:select id="subSystemIdForEdite" name="subSystemIdForEdite" items="${subsystems.list}" style="width:168px"  label="SUBSYSTEM_NAME" value="SUBSYSTEM_ID" headValue="-1" headLabel="请选择"/>
						</td>
					</tr>
					<tr>
						<th>排序：</th>
						<td>
							<input type="text" id="ordForEdite" name="ordForEdite" value="1" class="easyui-validatebox" style="width:168px" required missingMessage="不能为空"/>
						</td>
					</tr>
					<tr>
						<th>系统菜单描述：</th>
						<td>
							<textarea  id="memoForEdite" name="memoForEdite"  rows="4" cols="38"></textarea>
						</td>
					</tr>
					
				</table>
			</form>
		</div>
			<div id="roleU" title="用户管理">
			<div id="roleUwin"></div>
		</div>
		<div id="roleA" title="角色授权">
			<div id="roleAwin"></div>
		</div>
  </body>
</html>
