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
<script type="text/javascript">
	$(window).resize(function(){
		 	$('#authOrization').treegrid('resize');
	});
	$(function(){
			$('#authOrization').treegrid({
				title:'指标角色授权>>当前角色：${curRole.role_name}',
				iconCls:'icon-edit',
				
				nowrap: false,
				rownumbers: false,
				animate:true,
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
							{field:'KPI_RADE',title:'使用权限',width:100,formatter:formatterR},
							{field:'KPI_CREATE',title:'创建权限',width:100,formatter:formatterC},
							{field:'KPI_UPDATE',title:'修改权限',width:100,formatter:formatterU},
							{field:'KPI_DEL',title:'删除权限',width:100,formatter:formatterD},
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
		return "<input type='checkbox' id='X_"+kpiId+"_R' onclick=clickNode('"+kpiId+"','${param.roleIdInput}','R') "+isChecked+"/>";
	}
	function formatterC(value,rowData){
		var kpiId= rowData.ID;
		var roleId = rowData.ROLE_CODE;
		var isChecked ="checked='checked'";
		if(value=='0'){
			isChecked="";
		}
		return "<input type='checkbox' id='X_"+kpiId+"_C' onclick=clickNode('"+kpiId+"','${param.roleIdInput}','C') "+isChecked+"/>";
	}
	function formatterD(value,rowData){
		var kpiId= rowData.ID;
		var roleId = rowData.ROLE_CODE;
		var isChecked ="checked='checked'";
		if(value=='0'){
			isChecked="";
		}
		return "<input type='checkbox' id='X_"+kpiId+"_D' onclick=clickNode('"+kpiId+"','${param.roleIdInput}','D') "+isChecked+"/>";
	}
	function formatterU(value,rowData){
		var kpiId= rowData.ID;
		var roleId = rowData.ROLE_CODE;
		var isChecked ="checked='checked'";
		if(value=='0'){
			isChecked="";
		}
		return "<input type='checkbox' id='X_"+kpiId+"_U' onclick=clickNode('"+kpiId+"','${param.roleIdInput}','U') "+isChecked+"/>";
	}
	
	function clickNode(id,role_id,type){
		setParentNode(id,type,role_id,true);
		setChildrenNode(id,type,role_id,true,null);
		
		add(id,role_id,type);
	}
	function add(id,role_id,type){
		$.ajax({  
	          type : "post", 
	          url:'<e:url value="/pages/kpi/role/RoleAuthorizeAction.jsp"/>?eaction=add',
	          data : {"roleId":role_id, authType:type, "id":id, checked:$("#X_"+id+"_"+type).attr("checked")},
	          async : false,  
	          success : function(data){
	          }  
     });
	}
	
	function setParentNode(id,type,role_id,isStartFlag){
		
		var selectNodeChecked=$("#X_"+id+"_"+type).attr("checked");
		if(!isStartFlag){
			$("#X_"+id+"_"+type).attr("checked","checked");
		}
		if(type == 'R'){
			if(selectNodeChecked!=true&&selectNodeChecked!='true'&&selectNodeChecked!='checked'){
				$("#_X"+id+"_R").removeAttr("checked");
			}
		}
		if(type != 'R'){
			$("#X_"+id+"_R").attr("checked","checked");
		}
		
		var parentNode = $('#authOrization').treegrid('getParent',id);
		if(parentNode!=null&&parentNode.ID != ''){
			add(id,role_id,type);
			setParentNode(parentNode.ID,type,role_id,false);
		}
	}
	
	function setChildrenNode(id,type,role_id,isStartFlag,isChecked){
		if(!isStartFlag){
			if(isChecked){
				$("#X_"+id+"_"+type).attr("checked","checked");
			}else{
				$("#X_"+id+"_"+type).removeAttr("checked");
			}
		}
		
		var selectNodeChecked=$("#X_"+id+"_"+type).attr("checked");
		
		if(type == 'R'){
			if(selectNodeChecked!=true&&selectNodeChecked!='true'&&selectNodeChecked!='checked'){
				$("#X_"+id+"_R").removeAttr("checked");
			}
		}
		if(type != 'R'){
			if(selectNodeChecked==true||selectNodeChecked=='true'||selectNodeChecked=='checked'){
				$("#X_"+id+"_R").attr("checked","checked");
			}
		}
		var children = $('#authOrization').treegrid('getChildren',id);
		if(children!=null&&children.length>0){
			for(var a=0;a<children.length;a++){
				if(selectNodeChecked=='checked'||selectNodeChecked==true){
					setChildrenNode(children[a].ID,type,role_id,false,true);
				}else{
					setChildrenNode(children[a].ID,type,role_id,false,false);
				}
				add(children[a].ID,role_id,type);
			}
		}
	}
</script>
<link rel="stylesheet" type="text/css" href="<e:url value="/resources/themes/common/css/links.css"/>">
</head>
<body style="overflow-x:hidden;">
	<div id="treedigridTools">
		<div class="topListUser">
			<p style="color:red">
				注意：直接勾选将自动保存
			</p>
		</div>
	</div>
	<div style="width: 1000px">
		<table id="authOrization" style="width: auto"></table>
	</div>
</body>
</html>