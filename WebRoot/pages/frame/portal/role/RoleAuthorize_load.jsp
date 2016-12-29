<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:q4o var="curRole">
	select role_name from e_role where role_code=#roleIdInput#
</e:q4o>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>角色授权（菜单）</title>
<e:style value="/resources/themes/base/boncBase@links.css"/>
<script type="text/javascript">
	$(window).resize(function(){
		 	$('#authOrization').treegrid('resize');
	});
	$(function(){
			$('#authOrization').treegrid({
				nowrap: false,
				rownumbers: false,
				animate:true,
				collapsible:false,
				url:'<e:url value="/pages/frame/portal/role/RoleAuthorizeAction.jsp"/>?eaction=getRoleTreeRootNode&roleId=${param.roleIdInput}',
				onBeforeExpand:function(node,param){  
                    $('#authOrization').treegrid('options').url = '<e:url value="/pages/frame/portal/role/RoleAuthorizeAction.jsp"/>?eaction=getRoleTreeChildrenNode&roleId=${param.roleIdInput}&nodeId=' + node.RESOURCES_ID;
                }, 
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
			});
			
		});
		
		
	function formatterR(value,rowData){
		var menuId = rowData.RESOURCES_ID;
		var roleId = rowData.ROLE_CODE;
		var isChecked ="checked='checked'";
		if(value=='0'){
			isChecked="";
		}
		return "<input type='checkbox' id='C_"+menuId+"_R' onclick=clickNodeCheck('"+menuId+"','R') "+isChecked+"/>";
	}
	function formatterC(value,rowData){
		var menuId = rowData.RESOURCES_ID;
		var roleId = rowData.ROLE_CODE;
		var isChecked ="checked='checked'";
		if(value=='0'){
			isChecked="";
		}
		return "<input type='checkbox' id='C_"+menuId+"_C' onclick=clickNodeCheck('"+menuId+"','C') "+isChecked+"/>";
	}
	function formatterU(value,rowData){
		var menuId = rowData.RESOURCES_ID;
		var roleId = rowData.ROLE_CODE;
		var isChecked ="checked='checked'";
		if(value=='0'){
			isChecked="";
		}
		return "<input type='checkbox' id='C_"+menuId+"_U' onclick=clickNodeCheck('"+menuId+"','U') "+isChecked+"/>";
	}
	function formatterD(value,rowData){
		var menuId = rowData.RESOURCES_ID;
		var roleId = rowData.ROLE_CODE;
		var isChecked ="checked='checked'";
		if(value=='0'){
			isChecked="";
		}
		return "<input type='checkbox' id='C_"+menuId+"_D' onclick=clickNodeCheck('"+menuId+"','D') "+isChecked+"/>";
	}
	function formatterE(value,rowData){
		var menuId = rowData.RESOURCES_ID;
		var roleId = rowData.ROLE_CODE;
		var isChecked ="checked='checked'";
		if(value=='0'){
			isChecked="";
		}
		return "<input type='checkbox' id='C_"+menuId+"_E' onclick=clickNodeCheck('"+menuId+"','E') "+isChecked+"/>";
	}
	function formatterI(value,rowData){
		var menuId = rowData.RESOURCES_ID;
		var roleId = rowData.ROLE_CODE;
		var isChecked ="checked='checked'";
		if(value=='0'){
			isChecked="";
		}
		return "<input type='checkbox' id='C_"+menuId+"_I' onclick=clickNodeCheck('"+menuId+"','I') "+isChecked+"/>";
	}
	
	function clickNodeCheck(id,type){
		setParentNode(id,type,true);
		setChildrenNode(id,type,true,null);
		
		$.ajax({ 
		     type: "POST",
		     url: '<e:url value="role/roleTreeGridCheckNode.e"/>', 
		     data: {menuId:id, authType:type, roleId:${param.roleIdInput}, checked:$("#C_"+id+"_"+type).attr("checked")},
		     dataType: "json",
		     success:function(msg){
			     if(msg == 'success'){
			     }else{
			     }
		     } 
		}); 
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
</script>
</head>
<body>
	<div id="treedigridTools" class="contents-head">
		<h2>角色授权 > 当前角色：${curRole.role_name}</h2>
		<div class="search-area">
			<p class="easyui-font-red" style="line-height:2.4;">注意：直接勾选将自动保存</p>
		</div>
	</div>
	<div style="width: 1000px">
		<table id="authOrization" style="width: auto"></table>
	</div>
</body>
</html>