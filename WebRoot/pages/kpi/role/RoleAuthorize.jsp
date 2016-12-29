<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:q4o var="curRole">
	select role_name from x_role where role_code=#roleIdInput#
</e:q4o>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>角色授权（菜单）</title>
<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources>
<script type="text/javascript">
	$(function(){
			$('#authOrization').treegrid({
				nowrap: false,
				rownumbers: false,
				animate:true,
				fit:true,
				collapsible:false,
				url:'<e:url value="/pages/kpi/role/RoleAuthorizeAction.jsp"/>?eaction=getRoleTreeRootNode&roleId=${param.roleIdInput}',
				onBeforeExpand:function(node,param){
					if (node){
                    	$('#authOrization').treegrid('options').url = '<e:url value="/pages/kpi/role/RoleAuthorizeAction.jsp"/>?eaction=getRoleTreeChildrenNode&roleId=${param.roleIdInput}&nodeId=' + node.ID;
					}else{
					}
                }, 
				idField:'ID',
				treeField:'NAME',
				frozenColumns:[[
				                {title:'模块名称',field:'NAME',width:500}
							]],
				columns:[[
							{field:'CATEGORY_ID',title:'权限',width:100,formatter:formatterR},
						]],
				toolbar: '#treedigridTools',
			});
			
		});
	function formatterR(value,rowData){
		var kpiId= rowData.ID;
		var roleId = rowData.ROLE_CODE;
		var isChecked ="checked='checked'";
		if(value=='0'){
			isChecked="";
		}
		return "<input type='checkbox' id='X_"+kpiId+"' onclick=clickNode('"+kpiId+"','${param.roleIdInput}') "+isChecked+"/>";
	}
	function clickNode(id,role_id){
		var eaction  = 'add';
		if(!$('#X_'+id).attr('checked')){
			eaction = 'remove';
		}
		$.ajax({  
	          type : "post", 
	          url:'<e:url value="/pages/kpi/role/RoleAuthorizeAction.jsp"/>?eaction='+eaction,
	          data : {"roleId":role_id,"id":id},  
	          async : false,  
	          success : function(data){
	          }  
       });
	}
	
</script>
</head>
<body >
	<div id="treedigridTools">
		<h2>角色授权 > 当前角色：${curRole.role_name}</h2>
		<div class="search-area">
			<span style="color:#c00; display:block; padding-top:10px;">
				注意：直接勾选将自动保存
			</span>
		</div>
	</div>
	<div id="authOrization"></div>
</body>
</html>