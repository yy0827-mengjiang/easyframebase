<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:set var="treeDataUrl"><e:url value="/menu/loardTree.e"/></e:set>
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
		$(window).resize(function(){
		 	$('#tree_panel').panel('resize');
		});
    	$("#onContextMenuDiv").hide();   
	});
   	function showContextMenu(e,node){
   		e.preventDefault();
		$("#tt").tree('select',node.target);
		$("#parentIdForAdd").val(node.id);
		$("#currentIdForEdite").val(node.id);
		//alert(node.attributes.authCreate>0);
		if(node.id!=0){
			$("#parentIdForEdite").val($('#tt').tree('getParent', node.target).id);
		}
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
   	/**用户*/
   	function userMenu(){ 
   		var nodeId=$("#currentIdForEdite").val();
   		$("#tableUser").load('<e:url value="/pages/frame/portal/menu/UserLoad.jsp?type=1&menu_id="/>'+nodeId,function (data){ 
   		});
   	}
   	/**角色*/
   	function roleMenu(){ 
   		var nodeId=$("#currentIdForEdite").val();
   		$("#tableUser").load('<e:url value="/pages/frame/portal/menu/UserLoad.jsp?type=0&menu_id="/>'+nodeId,function (data){ 
   		});
   	} 
   	function menuHandler(item){
		if(item.id!=null&&item.id!=undefined){
			if(item.id=='userButton'){
				userMenu();
			}else if(item.id=='roleButton'){
				roleMenu();
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
  	   <div class="easyui-layout" data-options="fit:true,border:false">
            <div data-options="region:'west'" title="菜单下用户与角色查看"  style="width:30%;">
	            <input type="hidden" id="parentIdForAdd" name="parentIdForAdd" value=""/>
				<input type="hidden" id="currentIdForEdite" name="currentIdForEdite" value=""/>
	            <a:tree id="tt" url='${treeDataUrl}' checkbox="false" onContextMenu="showContextMenu" dnd="true" onDrop="cutToOthers" onLoadSuccess="extendAll" onExpand="expandNode" onClick="clickNode"/>
	            	<!--//右键弹出  -->
		    	<div id="onContextMenuDiv" class="easyui-menu" style="width:120px;" data-options="onClick:menuHandler">
					<div id="userButton" data-options="iconCls:'icon-add'">用户</div>
					<div id="roleButton" data-options="iconCls:'icon-edit'">角色</div>
				</div>
            </div>
            <div data-options="region:'center', border:false">
            	<div id="tableUser" style="height:100%"></div>
            </div>
        </div>
	    	
	    	


  </body>
</html>
