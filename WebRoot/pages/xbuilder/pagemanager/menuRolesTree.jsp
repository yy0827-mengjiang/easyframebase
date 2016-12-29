<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<e:set var="treeDataUrl"><e:url value="/xbuilder/loadMenuTreeData.e?userId=${sessionScope.UserInfo.USER_ID}"/></e:set>
<e:q4l var="rolesOfUserList">
	SELECT CASE WHEN ROLE_CODE IS NULL THEN '' ELSE ROLE_CODE END "ROLE_CODE" FROM E_ROLE_PERMISSION WHERE MENU_ID in (SELECT min(MENU_ID) FROM X_REPORT_MENU_REL WHERE REPORT_ID='${param.formID }')
</e:q4l>
<e:q4o var="getUserName">
	SELECT ID "ID", NAME "NAME" FROM X_REPORT_INFO where ID='${param.formID }'
</e:q4o>
    <script type="text/javascript">
    var currentLevel=1;
    var extendLevel=2;//树初始展开级数
    var rolesOfUser=[];//用户当前已有的角色
    var rolesOfAdd=[];//要添加的角色
    var rolesOfDelete=[];//要删除的角色
    var tempSelectRole=[];
    var isAdmin='${sessionScope.UserInfo.ADMIN}';
    var isRoot=0;
    
    $(function(){
    	var roleList=$.parseJSON('${e:java2json(rolesOfUserList.list)}');
    	for(var i=0;i<roleList.length;i++){
    		rolesOfUser.push(roleList[i]['ROLE_CODE']);
    	}
    	$('#saveB').linkbutton();
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
	           	if(node1!=null && node1.length != 0&&node1.checked!=true){
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
		           if(node1!=null && node1.length != 0&&node1.checked!=true){
		           		$('#tt').tree('uncheck',node1.target);//节点复选框默认选中
		           }
	           	}
	   		}
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
        $('#tt').tree('check',node1.target);//节点复选框默认选中
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
   		
   		$('#layout_main').css("overflow","");
		$('#layout_main').css("overflow","auto");
   		
   	}
   	//保存已经选中的节点
   	function getChecked(){
   		$("#saveB").linkbutton("disable");
	    var cdInfo={};
		var postUrl="<e:url value='/xbuilder/editReportMenuRole.e'/>"
			cdInfo={};
			cdInfo.formId='${param.formID }';
			cdInfo.formName='${getUserName.NAME}';
			cdInfo.addRoleIds=$.toJSON(rolesOfAdd);
			cdInfo.removeRoleIds=$.toJSON(rolesOfDelete);
			$.post(postUrl,cdInfo,function(data){
				if(data == 1){
					$.messager.alert("提示信息","保存成功！","info");
					$("#formRoleA").dialog('close');
					//window.location = '<e:url value="/pages/frame/portal/user/UserManager.jsp"/>';
				} else{
					$("#saveButton").linkbutton("enable");
					$.messager.alert("提示信息","保存过程中出现错误，请联系管理员！","error");
				}
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
	<div region="north" id="layout_head" border="false">
		<div class="contents-head">
			<h2>报表:${getUserName.NAME}</h2>
			<div class="search-area">
				<a href="javascript:void(0);" id="saveB" onclick="getChecked();">保存</a>
			</div> 
		</div>
	</div>
	<div region="center" id="layout_main" border="false">		
    	<a:tree id="tt" url='${treeDataUrl}' checkbox="true" cascadeCheck="false" onBeforeExpand="beforeExpandNode" onExpand="expandNode" onLoadSuccess="extendAll" onCheck="checkNode"/>
	</div>
