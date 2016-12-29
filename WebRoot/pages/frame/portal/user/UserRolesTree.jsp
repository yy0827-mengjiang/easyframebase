<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:set var="treeDataUrl"><e:url value="/pages/frame/portal/user/UserRolesTreeAction.jsp?eaction=loardTree&userId=${param.user_id}"/></e:set>
<e:q4o var="rolesOfUserObj" sql="frame.user.rolesOfUserObj"></e:q4o>
<e:q4o var="getUserName">
	SELECT coalesce(T.USER_NAME,'') "USER_NAME" FROM E_USER T WHERE T.USER_ID = '${param.user_id }'
</e:q4o>
<e:q4l var="subsystems">
	SELECT SUBSYSTEM_ID "SUBSYSTEM_ID", SUBSYSTEM_NAME "SUBSYSTEM_NAME" FROM D_SUBSYSTEM WHERE SUBSYSTEM_ID IN(SELECT SUBSYSTEM_ID  FROM E_ROLE T WHERE T.ROLE_CODE IN(SELECT ROLE_CODE FROM E_USER_ROLE  WHERE USER_ID=#user_id#)) ORDER BY ORD
</e:q4l>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
  <head>
    <title>系统菜单管理</title>
    <c:resources type="easyui" style="${ThemeStyle }"/>
 	<e:style value="/resources/themes/base/boncBase@links.css"/>
    <script type="text/javascript">
    $(function(){
    	
    	$('#dialog_subSysRoleOpt').dialog({
			title:"dilog",
			width:600,
			height:300,
			closed: true,
			modal: true,
			buttons:[{
				id:"subSysRoleOptBtn",
				text:'提交',
				iconCls:'icon-ok',
				handler:function(){
					$("#subSysRoleOptBtn").linkbutton("disable");
					var userIds=$("#userIdsForSubSysRoleOpt").val();
					var subSystemId=$("#subSystemIdForSubSysRoleOpt").val();
					if(userIds==null||userIds==''){
						$.messager.alert("提示信息","请至少选择一个用户！","info");
						$("#subSysRoleOptBtn").linkbutton("enable");
						return false;
					}
					if(subSystemId==null||subSystemId==''||subSystemId=='-1'){
						$.messager.alert("提示信息","请选择子系统！","info");
						$("#subSysRoleOptBtn").linkbutton("enable");
						return false;
					}
					$('#form_subSysRoleOpt').submit();
				}
			}]
		});
	
    	 $('#form_subSysRoleOpt').form({
			 url:'<e:url value="/pages/frame/portal/user/UserRolesTreeAction.jsp"/>',
	    	 success:function(data){
	    	 	var dataStr=$.trim(data);
	    	 	alert(dataStr);
	    	 	if(dataStr>0){
    				$.messager.alert('信息提示', '操作成功', 'info');
    				doSearchForUsersSelect();
    				$('#dialog_subSysRoleOpt').dialog('close');
    				window.location.href='<e:url value="/pages/frame/portal/user/UserManager.jsp"/>';
    			}else if(dataStr==-1){
					$.messager.alert('信息提示', '操作失败,原因为：复制到的用户中有相关扩展属性的值为空', 'error');
					$("#subSysRoleOptBtn").linkbutton("enable");
    			}else{
    				$.messager.alert('信息提示', '操作失败,请联系管理人员', 'error');
    				$("#subSysRoleOptBtn").linkbutton("enable");
    			}
		       	 
	    	 }
		});
		
		$('#dialog_usersSelect').dialog({
			title:"用户选择",
			width:800,
			height:400,
			closed: true,
			modal: true,
			//closable:false
		});
    
    });
    
    function goToSelectUsers(){
    	$('#userNamesForSubSysRoleOpt').blur();
    	$('#dialog_usersSelect').dialog("open");
    }
    function doSearchForUsersSelect(){
    	var params={};
    	params.loginId=$("#loginIdForUsersSelect").val();
    	params.userName=$("#userNameForUsersSelect").val();
    	$("#userTableForUsersSelect").datagrid("load",params);
    	 
    }
    function selectUsersForUsersSelect(){
    	var selectRows=$("#userTableForUsersSelect").datagrid("getChecked");
		if(selectRows.length==0){
			$.messager.alert("提示信息","请至少选择一个用户！","info");
			return false;
		}
		var userIds='';
		var userNames='';
		for(var a=0;a<selectRows.length-1;a++){
			userIds=userIds+selectRows[a]["USER_ID"]+",";
			userNames=userNames+selectRows[a]["USER_NAME"]+",";
		}
		userIds=userIds+selectRows[selectRows.length-1]["USER_ID"]
		userNames=userNames+selectRows[selectRows.length-1]["USER_NAME"]
		$("#userIdsForSubSysRoleOpt").val(userIds);
		$("#userNamesForSubSysRoleOpt").val(userNames);
		$('#dialog_usersSelect').dialog("close");
    }
    
    
    var currentLevel=1;
    var extendLevel=2;//树初始展开级数
    var rolesOfUser=[];//用户当前已有的角色
    var rolesOfAdd=[];//要添加的角色
    var rolesOfDelete=[];//要删除的角色
    var tempSelectRole=[];
    rolesOfUser='${rolesOfUserObj.ROLES}'.split(',');
    
    var isAdmin='${sessionScope.UserInfo.ADMIN}';
    var isRoot=0;
    
    $(function(){
    	//当浏览器改变大小时自动适应
		$(window).resize(function(){
		 	$('#tree_panel').panel('resize');
		});
    });
   	
   	
   	function clickNode(node){
   		var isleaf = $(this).tree('isLeaf',node.target);
		if(!isleaf){
			$(this).tree('toggle',node.target);     //当是目录的时候 弹出叶子节点
		}
   }
   
   function beforeExpandNode(node){
   		tempSelectRole=[];
   		for(var i=0;i<rolesOfUser.length;i++){
			var isExistFlagInDelete=false;
			for(var a=0;a<rolesOfDelete.length;a++){
	   			if(rolesOfDelete[a]!='-1'&&rolesOfUser[i]==rolesOfDelete[a]){
	   				isExistFlagInDelete=true;
	           	}
	   		}
	   		if(!isExistFlagInDelete){
	   			tempSelectRole.push(rolesOfUser[i]);
	   		}
           	
        }
        
         for(var a=0;a<rolesOfAdd.length;a++){
         	tempSelectRole.push(rolesOfAdd[a]);
         }
         
        
   }
   
   	//展开时执行
   	function expandNode(node){
   		/*初始化已选择的角色*/
       	for(var i=0;i<tempSelectRole.length;i++){
       		if(tempSelectRole[i]!='-1'){
       			var node1 = $('#tt').tree('find',tempSelectRole[i]);
	           	//if(node1!=null && node1.length != 0&&node1.checked==false){
	           	if(node1!=null && node1.length != 0&&node1.checkState=="unchecked"){
	           		$('#tt').tree('check',node1.target);//节点复选框默认选中
	           	}
       		}
       		
           	for(var a=0;a<rolesOfDelete.length;a++){
	   			if(rolesOfDelete[a]!='-1'&&rolesOfDelete[a]==tempSelectRole[i]){
	   				rolesOfDelete[a]='-1';
	   				tempSelectRole[i]='-1';
	           	}
	   		}
       	}
        
        
        for(var a=0;a<rolesOfDelete.length;a++){
	   			if(rolesOfDelete[a]!='-1'){
	   				var node1 = $('#tt').tree('find',rolesOfAdd[a]);
		           //if(node1!=null && node1.length != 0&&node1.checked==false){
		           if(node1!=null && node1.length != 0&&node1.checkState=="unchecked"){
		           		$('#tt').tree('uncheck',node1.target);//节点复选框默认选中
		           }
	           	}
	   		}
        var treeOnlyExpandOneNode='${treeOnlyExpandOneNode}';
   		if(treeOnlyExpandOneNode!='0'){
   			if(node!=null && node.length != 0&&node.target){
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
	   					for(var a=0;a<extendLevel;a++){
	   						tempchildrenNodes=$(this).tree('getChildren',firstchildrenNode.target);
	   						if(tempchildrenNodes!=null&&tempchildrenNodes.length>0){
	   							firstchildrenNode=tempchildrenNodes[0];
	   							$(this).tree('expand',firstchildrenNode.target);
	   							beforeExpandNode(firstchildrenNode.target);//---------------升级了easyui后，需手动调用这一句
	   							expandNode(firstchildrenNode.target);//---------------升级了easyui后，需手动调用这一句		
	   						}else{
	   							break;
	   						}
	   					}
	   					
	   					
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
   		
   		$('#layout_main').css("overflow","");
		$('#layout_main').css("overflow","auto");
   	}
   	//保存已经选中的节点
   	function getChecked(){
   		$("#saveButton").linkbutton("disable");
	    var cdInfo={};
		var postUrl="<e:url value='/pages/frame/portal/user/UserRolesTreeAction.jsp'/>"
		cdInfo={};
		cdInfo.eaction="getAttrInfo";
		cdInfo.userId="${param.user_id }";
		cdInfo.addRoleIds=$.toJSON(rolesOfAdd);
		$.post(postUrl,cdInfo,function(data){
			var dataJson=$.parseJSON($.trim(data));
			var continueFlag=true;
			var continueMsg='';
			for(var a=0;a<dataJson.length;a++){
				if(dataJson[a]['ATTR_VALUE']==null||dataJson[a]['ATTR_VALUE']==''){
					continueFlag=false;
					continueMsg=continueMsg+'添加角色失败！<br/>原因为:该用户新增的角色中，角色‘'+dataJson[a]['ROLE_NAME']+'’对应的子系统‘'+dataJson[a]['SUBSYSTEM_NAME']+'’对应的扩展属性‘'+dataJson[a]['ATTR_NAME']+'’的值为空;';
					break;					
				}
			}
			
			if(!continueFlag){
				$.messager.alert("提示信息",continueMsg,"info");
				$("#saveButton").linkbutton("enable");
				return false;
			}
			cdInfo={};
			cdInfo.eaction="edit";
			cdInfo.userId="${param.user_id }";
			cdInfo.addRoleIds=$.toJSON(rolesOfAdd);
			cdInfo.removeRoleIds=$.toJSON(rolesOfDelete);
			$.post(postUrl,cdInfo,function(data){
				if(data == 1){
					$.messager.alert("提示信息","保存成功！","info");
					window.location = '<e:url value="/pages/frame/portal/user/UserManager.jsp"/>';
				} else{
					$("#saveButton").linkbutton("enable");
					$.messager.alert("提示信息","保存过程中出现错误，请联系管理员！","error");
				}
			});       
			
			  
		});
            
     }
     
     
     function checkNode(node,checked){
    	if(checked){
    		var isExistFlagInAdd=false;
    		for(var a=0;a<rolesOfAdd.length;a++){
    			if(rolesOfAdd[a]==node.id){
    				isExistFlagInAdd=true;
    				break;
    			}	
    		}
    		
    		var isExistFlagInUser=false;
    		for(var b=0;b<rolesOfUser.length;b++){
    			if(rolesOfUser[b]==node.id){
    				isExistFlagInUser=true;
    				break;
    			}	
    		}
    		if((!isExistFlagInAdd)){
    			if((!isExistFlagInUser)){
	    			rolesOfAdd.push(node.id);
	    			for(var c=0;c<rolesOfDelete.length;c++){
	    				if(rolesOfDelete[c]==node.id){
	    					rolesOfDelete[c]='-1';
	    					break;
	    				}
	    			}
    			}
    		}
     		
     	}else{
     		var isExistFlagInDelete=false;
    		for(var a=0;a<rolesOfDelete.length;a++){
    			if(rolesOfDelete[a]==node.id){
    				isExistFlagInDelete=true;
    				break;
    			}	
    		}
    		
    		var isExistFlagInUser=false;
    		for(var b=0;b<rolesOfUser.length;b++){
    			if(rolesOfUser[b]==node.id){
    				isExistFlagInUser=true;
    				break;
    			}	
    		}
    		for(var c=0;c<rolesOfAdd.length;c++){
   				if(rolesOfAdd[c]==node.id){
   					rolesOfAdd[c]='-1';
   					break;
   				}
   			}
    		if((!isExistFlagInDelete)){
    			if(isExistFlagInUser){
    				rolesOfDelete.push(node.id);
    			}
    			
    			
    		}
    		
     	}
     }
     
    </script>
  </head>
  
<body id="userSelectRole">
	<div id="layout_head" >
		<div class="contents-head">
			<h2>用户名:${getUserName.USER_NAME}</h2>
			<div class="search-area">
				<a href="javascript:void(0);" id="saveButton" class="easyui-linkbutton" onclick="getChecked();">保存</a>
				<a href="<e:url value="/pages/frame/portal/user/UserManager.jsp"/>" class="easyui-linkbutton easyui-linkbutton-gray">返回</a>
			</div> 
		</div>
	</div>
	<div id="layout_main" border="false">		
    	<a:tree id="tt" url='${treeDataUrl}' checkbox="true" cascadeCheck="false" onBeforeExpand="beforeExpandNode" onExpand="expandNode" onLoadSuccess="extendAll" onCheck="checkNode"/>
	</div>
</body>
</html>
