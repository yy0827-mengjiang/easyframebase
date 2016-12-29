<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:q4o var="curRole">
	select role_name from e_role where role_code=#roleIdInput#
</e:q4o>
<e:q4l var="FirstLevelMenuList">
	 SELECT RESOURCES_ID,RESOURCES_NAME FROM (
		select RESOURCES_ID,
		               RESOURCES_NAME,
		               PARENT_ID,
		               ord
		          FROM e_menu t
		         where RESOURCES_ID in
		               (select ID
		                  from (select b.MENU_ID ID
		                          from E_USER_PERMISSION b
		                         where b.USER_ID = '${sessionScope.UserInfo.USER_ID}'
		                           and b.AUTH_READ = 1
		                        union all
		                        select c.MENU_ID
		                          from E_ROLE_PERMISSION c
		                         where c.ROLE_CODE in
		                               (select ROLE_CODE
		                                  from E_USER_ROLE
		                                 where USER_ID = '${sessionScope.UserInfo.USER_ID}')
		                           and c.AUTH_READ = 1
					) Z)  	    
	) WHERE PARENT_ID='0' ORDER BY  ORD
	
</e:q4l>
<e:set var="defaultFirstLevelMenu"></e:set>
<e:if condition="${e:length(FirstLevelMenuList.list)!=0}">
	<e:set var="defaultFirstLevelMenu">${FirstLevelMenuList.list[0].RESOURCES_ID}</e:set>
</e:if>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>角色授权（菜单）</title>
<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources>
<script type="text/javascript">
	$(window).resize(function(){
		 	$('#authOrization').treegrid('resize');
	});
	$(function(){
			
			$('#authOrization').treegrid({
				title:'角色授权>>当前角色：${curRole.role_name}',
				iconCls:'icon-edit',
				
				nowrap: false,
				rownumbers: false,
				animate:true,
				collapsible:false,
				url:'<e:url value="/pages/frame/portal/role/RoleAction.jsp"/>?eaction=authOpera&roleId=${param.roleIdInput}&defaultFirstLevelMenu=${defaultFirstLevelMenu}',
				idField:'RESOURCES_ID',
				treeField:'RESOURCES_NAME',
				frozenColumns:[[
	                {title:'模块名称',field:'RESOURCES_NAME',width:300}
				]],
				columns:[[
					{field:'AUTH_READ',title:'读取权限',width:100,formatter:formatterR},
					{field:'AUTH_CREATE',title:'创建权限',width:100,formatter:formatterC},
					{field:'AUTH_UPDATE',title:'修改权限',width:100,formatter:formatterU},
					{field:'AUTH_DELETE',title:'删除权限',width:100,formatter:formatterD},
					{field:'AUTH_EXPORT',title:'导出权限',width:100,formatter:formatterE},
					{field:'AUTH_ISSUED',title:'下发权限',width:100,formatter:formatterI}
				]],
				toolbar: '#treedigridTools',
				onLoadSuccess:loadNodeSuccess,
				onExpand:expandNode,
				onClickCell:clickCell
			});
		});
		
		
   	function loadNodeSuccess(row, data){
   		
   		var rootNodes=$(this).treegrid("getRoots");
   		var childrenNodes=$(this).treegrid("getChildren",rootNodes[0].RESOURCES_ID);
   		$(this).treegrid("expand",rootNodes[0].RESOURCES_ID);
   		$(this).treegrid("expand",childrenNodes[0].RESOURCES_ID);
   		
   	}
   	function expandNode(row){
   		var treeOnlyExpandOneNode='${treeOnlyExpandOneNode}';
   		if(treeOnlyExpandOneNode!='0'){
	   		var parentNode=$(this).treegrid('getParent',row.RESOURCES_ID);
	   		var childrenNode=null;
	   		if(parentNode!=null){
	   			childrenNode=$(this).treegrid('getChildren',parentNode.RESOURCES_ID);
	   		}else{
	   			childrenNode=$(this).treegrid('getRoots',row.RESOURCES_ID);
	   		}
	   		if(childrenNode!=null){
	   			for(var i=0;i<childrenNode.length;i++){
	   				if(childrenNode[i].RESOURCES_ID!=row.RESOURCES_ID){
	   					$(this).treegrid('collapse',childrenNode[i].RESOURCES_ID);
	   				}
	   			}
	   		}
   		}
   	}
   	function clickCell(field,row){
   		if(field=='RESOURCES_NAME'){
   			var isleaf = $(this).treegrid('isLeaf',row.RESOURCES_ID);
			if(!isleaf){
				$(this).treegrid('toggle',row.RESOURCES_ID);     //当是目录的时候 弹出叶子节点
			}
   			
   		}
   	}
	function formatterR(value,rowData){
		var menuId = rowData.RESOURCES_ID;
		var roleId = rowData.ROLE_CODE;
		var isChecked ="checked='checked'";
		if(value=='0'){
			isChecked="";
		}
		return "<input type='checkbox' id='C_"+menuId+"_R' onclick=clickNodeCheck('"+menuId+"','R') name='curdcheck' value='R:::"+menuId+":::"+roleId+"' "+isChecked+"/>";
	}
	function formatterC(value,rowData){
		var menuId = rowData.RESOURCES_ID;
		var roleId = rowData.ROLE_CODE;
		var isChecked ="checked='checked'";
		if(value=='0'){
			isChecked="";
		}
		return "<input type='checkbox' id='C_"+menuId+"_C' onclick=clickNodeCheck('"+menuId+"','C') name='curdcheck' value='C:::"+menuId+":::"+roleId+"' "+isChecked+"/>";
	}
	function formatterU(value,rowData){
		var menuId = rowData.RESOURCES_ID;
		var roleId = rowData.ROLE_CODE;
		var isChecked ="checked='checked'";
		if(value=='0'){
			isChecked="";
		}
		return "<input type='checkbox' id='C_"+menuId+"_U' onclick=clickNodeCheck('"+menuId+"','U') name='curdcheck' value='U:::"+menuId+":::"+roleId+"' "+isChecked+"/>";
	}
	function formatterD(value,rowData){
		var menuId = rowData.RESOURCES_ID;
		var roleId = rowData.ROLE_CODE;
		var isChecked ="checked='checked'";
		if(value=='0'){
			isChecked="";
		}
		return "<input type='checkbox' id='C_"+menuId+"_D' onclick=clickNodeCheck('"+menuId+"','D') name='curdcheck' value='D:::"+menuId+":::"+roleId+"' "+isChecked+"/>";
	}
	function formatterE(value,rowData){
		var menuId = rowData.RESOURCES_ID;
		var roleId = rowData.ROLE_CODE;
		var isChecked ="checked='checked'";
		if(value=='0'){
			isChecked="";
		}
		return "<input type='checkbox' id='C_"+menuId+"_E' onclick=clickNodeCheck('"+menuId+"','E') name='curdcheck' value='E:::"+menuId+":::"+roleId+"' "+isChecked+"/>";
	}
	function formatterI(value,rowData){
		var menuId = rowData.RESOURCES_ID;
		var roleId = rowData.ROLE_CODE;
		var isChecked ="checked='checked'";
		if(value=='0'){
			isChecked="";
		}
		return "<input type='checkbox' id='C_"+menuId+"_I' onclick=clickNodeCheck('"+menuId+"','I') name='curdcheck' value='I:::"+menuId+":::"+roleId+"' "+isChecked+"/>";
	}
	
	function clickNodeCheck(id,type){
		setParentNode(id,type,true);
		setChildrenNode(id,type,true,null);
	}
	function setParentNode(id,type,isStartFlag){
		
		var selectNodeChecked=$("#C_"+id+"_"+type).attr("checked");
		if(!isStartFlag){
			$("#C_"+id+"_"+type).attr("checked","checked");
		}
		if(type == 'R'){
			if(selectNodeChecked!=true&&selectNodeChecked!='true'&&selectNodeChecked!='checked'){
				$("#C_"+id+"_C").removeAttr("checked");
				$("#C_"+id+"_U").removeAttr("checked");
				$("#C_"+id+"_D").removeAttr("checked");
				$("#C_"+id+"_E").removeAttr("checked");
				$("#C_"+id+"_I").removeAttr("checked");
			}
		}
		if(type != 'R'){
			$("#C_"+id+"_R").attr("checked","checked");
		}
		var parentNode = $('#authOrization').treegrid('getParent',id);
		if(parentNode!=null&&parentNode.RESOURCES_ID != ''){
			setParentNode(parentNode.RESOURCES_ID,type,false);
		}
	}
	
	function setChildrenNode(id,type,isStartFlag,isChecked){
		if(!isStartFlag){
			if(isChecked){
				$("#C_"+id+"_"+type).attr("checked","checked");
			}else{
				$("#C_"+id+"_"+type).removeAttr("checked");
			}
		}
		
		var selectNodeChecked=$("#C_"+id+"_"+type).attr("checked");
		
		if(type == 'R'){
			if(selectNodeChecked!=true&&selectNodeChecked!='true'&&selectNodeChecked!='checked'){
				$("#C_"+id+"_C").removeAttr("checked");
				$("#C_"+id+"_U").removeAttr("checked");
				$("#C_"+id+"_D").removeAttr("checked");
				$("#C_"+id+"_E").removeAttr("checked");
				$("#C_"+id+"_I").removeAttr("checked");
			}
		}
		if(type != 'R'){
			if(selectNodeChecked==true||selectNodeChecked=='true'||selectNodeChecked=='checked'){
				$("#C_"+id+"_R").attr("checked","checked");
			}
		}
		var children = $('#authOrization').treegrid('getChildren',id);
		if(children!=null&&children.length>0){
			for(var a=0;a<children.length;a++){
				if(selectNodeChecked=='checked'||selectNodeChecked==true){
					setChildrenNode(children[a].RESOURCES_ID,type,false,true);
				}else{
					setChildrenNode(children[a].RESOURCES_ID,type,false,false);
				}
			}
		
			
		}
		
		
	}
	
	
	function saveRole(){
	    var selects = [];
	    var info = {};
	    info.rea=0,info.cre=0,info.upd=0,info.del=0,info.exports=0,info.issued=0;
	    var temp_count=0;
		$("input[name=curdcheck]:checked").each(function(index,obj){
			var temp = obj.value.split(':::');
			var temp_index = temp[0];
			if(index==0){
			    info.resources_id=temp[1];
				info.role_code=temp[2];
				temp_count++;
			}
			if(info.resources_id!=temp[1]){
				selects.push(info);
				info={};
				info.rea=0,info.cre=0,info.upd=0,info.del=0,info.exports=0,info.issued=0;
				info.resources_id=temp[1];
				info.role_code=temp[2];
			}
			if(temp_index=='R'){
				info.rea=1;
			}
			if(temp_index=='C'){
				info.cre=1;
			}
			if(temp_index=='U'){
				info.upd=1;
			}
			if(temp_index=='D'){
				info.del=1;
			}
			if(temp_index=='E'){
				info.exports=1;
			}
			if(temp_index=='I'){
				info.issued=1;
			}
		});
		if(temp_count>0){
			selects.push(info);
		}
		var cdInfo={};
		cdInfo.roleId="${param.roleIdInput}";
		cdInfo.selects=$.toJSON(selects);
		cdInfo.firstLevelMenu=$("#firstLevelMenu").combobox("getValue");
		//alert($("#firstLevelMenu").combobox("getValue"));
		//return false;
		var postUrl="<e:url value='/pages/frame/portal/role/RoleAction.jsp'/>?eaction=saveRolePermission"
		$.post(postUrl,cdInfo,function(data){
			if(isEmpty(data)){
				$.messager.alert("提示信息","保存过程中出现错误，请联系管理员！","error");
			} else{
				$.messager.alert("提示信息","保存成功！","info");
				 $.ajax({ 
			    	 url:'<e:url value="/pages/frame/portal/role/RoleAction.jsp"/>?eaction=authOpera&roleId=${param.roleIdInput}&defaultFirstLevelMenu='+cdInfo.firstLevelMenu, 
			    	 type:"post", 
			    	 data:{}, 
			    	 dataType:"json", 
			    	 success:function(json){ 
			    	     $("#authOrization").treegrid("loadData",json); 
			    	 } 
			    }); 
				//$('#authOrization').treegrid('reload');
			}
		});
	}
	
	//判断是否为空
	function isEmpty(obj){
		if(obj==null || obj=='' ){
			return true;
		} else {
			var spaceEmpty = obj.replace(/\s/g,'');
			if(spaceEmpty == ''){
				return true;
			}
		}
		return false;
	}
	
	function selectFirstLevelMenu(record){
		 $.ajax({ 
	    	 url:'<e:url value="/pages/frame/portal/role/RoleAction.jsp"/>?eaction=authOpera&roleId=${param.roleIdInput}&defaultFirstLevelMenu='+record.RESOURCES_ID, 
	    	 type:"post", 
	    	 data:{}, 
	    	 dataType:"json", 
	    	 success:function(json){ 
	    	     $("#authOrization").treegrid("loadData",json); 
	    	 } 
	    }); 
	
	}
</script>
<link rel="stylesheet" type="text/css" href="<e:url value="/resources/themes/common/css/links.css"/>">
</head>
<body style="overflow-x:hidden;">
	<div id="treedigridTools">
		<div class="topListUser">
			<div style="text-align: right;padding-right: 10px">
				<span>一级菜单：
					<input style="width:150px" id="firstLevelMenu"  name="firstLevelMenu" class="easyui-combobox" 
					data-options='valueField:"RESOURCES_ID", textField:"RESOURCES_NAME",data: ${e:java2json(FirstLevelMenuList.list) },multiple:false,value:${defaultFirstLevelMenu },editable:false,onSelect:selectFirstLevelMenu'>
				</span>
				<span style="margin-right: 0px"><a href="javascript:void(0);" class="easyui-linkbutton" onclick="saveRole()">保存</a><span>
			</div>
		</div>
	</div>
	<div style="width: 1000px">
		<table id="authOrization" style="width: auto"></table>
	</div>
	
</body>
</html>