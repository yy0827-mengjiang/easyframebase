<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>定制指标</title>
		<c:resources type="easyui" style="${ThemeStyle }"/>
		<e:style value="/resources/themes/base/boncBase@links.css"/>
		<script type="text/javascript">
			$(function(){
				$('#dialog_addRole').dialog({
					title:"添加角色",
					closed: true,
					modal: true,
					buttons:[{
						text:'提交',
						iconCls:'icon-ok',
						handler:function(){
							//$('#form_menuAdd').submit();
							
						}
					}]
				});
				
			});
			function formatterCZ1(value,rowData){
				var content="--";
				if(rowData.INFLUENCE_TYPE!='1')
					content='<a class="easyui-linkbutton" href="javascript:void(0);" onclick="deleteRole(\''+rowData.ROLE_CODE+'\');">删除</a>';
				return content;
			}
			function doQueryForHasSelect(){
			
		        var params ={};
		        params.roleId=$('#roleIdForHasSelect').val();
				params.roleName=$('#roleNameForHasSelect').val();
		        var localtionUrl=window.location.href;
		        var paramString="";
		        var tempArray=[];
		        paramString=localtionUrl.substring(localtionUrl.indexOf("?")+1);
		        if(paramString!=""){
		        	tempArray=paramString.split("&");
		        	for(var a=0;a<tempArray.length;a++){
		        		if(tempArray[a].split("=")[0] != 'currentNodeId'){
		        			params[tempArray[a].split("=")[0]]=tempArray[a].split("=")[1];
		        		}
		        	}
		        }
		        
		        var url = '<e:url value="pages/frame/portal/menu/menuAction.jsp?eaction=getHasSelectRoles&"/>';
	        	url = url + paramString + '&roleId=' + $('#roleIdForHasSelect').val() + '&roleName=' + $('#roleNameForHasSelect').val();
	        	$('#hasSelectRolesTable').datagrid({ url : url });
		        
		        //$('#hasSelectRolesTable').datagrid('options').queryParams=params;
		        //$('#hasSelectRolesTable').datagrid('reload');
		        //$('#hasSelectRolesTable').datagrid("load",params);
			}
			
			function deleteRole(roleCode){
				var params={};
				var menuId='${param.currentNodeId}';
				params.menuId=menuId;
				params.roleCode=roleCode;
				$.post('<e:url value="/menu/menuRemoveRole.e"/>', params, function(data){
					if($.trim(data)>0){
	             		$('#hasSelectRolesTable').datagrid("load",$("#hasSelectRolesTable").datagrid("options").queryParams);
	             		$('#needSelectRolesTable').datagrid("load",$("#needSelectRolesTable").datagrid("options").queryParams);
	             	}else{
	             		$.messager.alert("提示信息","<br/>删除失败！",'info');
						return false;
	             	}
				
				});
			
			}
			function checkSelectQx(roleCode,QXType){
				if(QXType=='R'){
					$("#readQX_"+roleCode).attr("checked","checked");
					$.messager.alert("提示信息","<br/>读取权限是基础，必须选择！",'info');
				}
			}
			
			function formatterQX(value,rowData){
				var content='';
				content+='<input type="checkbox" id="createQX_'+rowData.ROLE_CODE+'" name="createQX" value="1" checked="checked" />创建';
				content+='<input type="checkbox" id="readQX_'+rowData.ROLE_CODE+'" name="readQX" value="1" checked="checked" onclick="checkSelectQx(\''+rowData.ROLE_CODE+'\',\'R\')"/>读取<br/>';
				content+='<input type="checkbox" id="updateQX_'+rowData.ROLE_CODE+'" name="updateQX" value="1" checked="checked" />更新';
				content+='<input type="checkbox" id="deleteQX_'+rowData.ROLE_CODE+'" name="deleteQX" value="1" checked="checked" />删除<br/>';
				content+='<input type="checkbox" id="exportQX_'+rowData.ROLE_CODE+'" name="exportQX" value="1" checked="checked" />导出';
				return content;
			
			}
			
			function formatterCZ2(value,rowData){
				var content="--";
				if(rowData.INFLUENCE_TYPE!='1')
					content='<a class="easyui-linkbutton" href="javascript:void(0);" onclick="addRole(\''+rowData.ROLE_CODE+'\');">添加</a>';
				return content;
			}
			
			function doQueryForNeedSelect(){
				var params ={};
				params.roleId=$('#roleIdForNeedSelect').val();
				params.roleName=$('#roleNameForNeedSelect').val();
				
		        var localtionUrl=window.location.href;
		        var paramString="";
		        var tempArray=[];
		        paramString=localtionUrl.substring(localtionUrl.indexOf("?")+1);
		        if(paramString!=""){
		        	tempArray=paramString.split("&");
		        	for(var a=0;a<tempArray.length;a++){
		        		if(tempArray[a].split("=")[0] != 'currentNodeId'){
		        			params[tempArray[a].split("=")[0]]=tempArray[a].split("=")[1];
		        		}
		        	}
		        }
		        //$('#needSelectRolesTable').datagrid('options').queryParams=params;
		        console.log(params);
		        $('#needSelectRolesTable').datagrid("load",params);
			
			}
			
			function showAddRoleDialog(roleId){
				$("#currentRoleId").val(roleId);
				$('#dialog_addRole').dialog("open");
			}
			function addRole(roleCode){
			
				var params={};
				var menuId='${param.currentNodeId}';
				var createQX=$("#createQX_"+roleCode).attr("checked");
				var readQX=$("#readQX_"+roleCode).attr("checked");
				var updateQX=$("#updateQX_"+roleCode).attr("checked");
				var deleteQX=$("#deleteQX_"+roleCode).attr("checked");
				var exportQX=$("#exportQX_"+roleCode).attr("checked");
				if(createQX=='checked'||createQX==true)
				{
					createQX='1';
				}else{
					createQX='0';
				}
				if(readQX=='checked'||readQX==true)
				{
					readQX='1';
				}else{
					readQX='0';
				}
				if(updateQX=='checked'||updateQX==true)
				{
					updateQX='1';
				}else{
					updateQX='0';
				}
				if(deleteQX=='checked'||deleteQX==true)
				{
					deleteQX='1';
				}else{
					deleteQX='0';
				}
				if(exportQX=='checked'||exportQX==true)
				{
					exportQX='1';
				}else{
					exportQX='0';
				}
				params.menuId=menuId;
				params.roleCode=roleCode;
				params.createQX=createQX;
				params.readQX=readQX;
				params.updateQX=updateQX;
				params.deleteQX=deleteQX;
				params.exportQX=exportQX;
				$.post('<e:url value="/menu/menuAddRole.e"/>', params, function(data){
	             	if($.trim(data)=='1'){
	             		$('#hasSelectRolesTable').datagrid("load",$("#hasSelectRolesTable").datagrid("options").queryParams);
	             		$('#needSelectRolesTable').datagrid("load",$("#needSelectRolesTable").datagrid("options").queryParams);
	             	}else{
	             		$.messager.alert("提示信息","<br/>添加失败！",'info');
						return false;
	             	}
	             	
	             });
			
			}
			window.onunload = onClose;
			 function onClose()
			 {
			   /**/
			  	//var args = window.dialogArguments;
 			  	//args.views[args.$AssociationsView].reload();
			 }
			
		</script>
	</head>
	<body> 		
	<table>
		<tr>
			<td width="50%">
				<div id="tb1">
					<form id="loginLogForm" method="post" name="loginLogForm" action="">
						<h2>已选择的角色</h2>
						<div class="search-area">
							角色编码:<input id="roleIdForHasSelect"  type="text" name="roleIdForHasSelect" value="" class="easyui-validatebox" validType="length[0,30]" style="width: 80px">
							角色名称:<input id="roleNameForHasSelect" type="text" name="roleNameForHasSelect" value="" class="easyui-validatebox" validType="length[0,100]" style="width: 80px">
							<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQueryForHasSelect()">查询</a>
							
						</div>
					</form>
				</div>
				<c:datagrid url="/pages/frame/portal/menu/menuAction.jsp?eaction=getHasSelectRoles&currentNodeId=${param.currentNodeId }" id="hasSelectRolesTable" pageSize="10" style=" width:100%;height:420px;" title="" toolbar="#tb1">
					<thead>
						<tr>
							<th field="ROLE_CODE" width="80">
								角色编码
							</th>
							<th field="ROLE_NAME" width="100">
								角色名称
							</th>
							<th field="MEMO" width="100"> 
								角色描述
							</th>
							<th field="QX" width="140"> 
								权限
							</th>
							<th field="CZ1" width="60" align="center" formatter="formatterCZ1">
								操作
							</th>
						</tr>
					</thead>
				</c:datagrid>
			</td>
			<td width="49%" style="border-left:1px solid #ddd;">
				<div id="tb2">
					<form id="loginLogForm" method="post" name="loginLogForm" style="display: inline;" action="">
						<h2>未选择的角色</h2>
						<div class="search-area">
							角色编码:<input id="roleIdForNeedSelect"  type="text" name=""roleIdForNeedSelect"" value="" class="easyui-validatebox" validType="length[0,30]" style="width: 80px">
							角色名称:<input id="roleNameForNeedSelect" type="text" name="roleNameForNeedSelect" value="" class="easyui-validatebox" validType="length[0,100]" style="width: 80px">
							<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQueryForNeedSelect()">查询</a>
						</div>
					</form>
				</div>
				<c:datagrid url="/pages/frame/portal/menu/menuAction.jsp?eaction=getNeedSelectRoles&currentNodeId=${param.currentNodeId }" id="needSelectRolesTable" pageSize="5" style=" width:100%;height:420px;" title=""  toolbar="#tb2">
					<thead>
						<tr>
							<th field="ROLE_CODE" width="80">
								角色编码
							</th>
							<th field="ROLE_NAME" width="140">
								角色名称
							</th>
							<th field="MEMO" width="160"> 
								角色描述
							</th>
							<th field="QX" width="140" formatter="formatterQX"> 
								权限选择
							</th>
							<th field="CZ2" width="60" align="center" formatter="formatterCZ2">
								操作
							</th>
						</tr>
					</thead>
				</c:datagrid>
			</td>
		</tr>
	</table>
	
		<div id="dialog_addRole" style="width:280px;height:200px;top: 10px">
			<input type="hidden" id="currentRoleId" name="currentRoleId" value=""/>
			<table style="margin-left: 10px;margin-top: 10px">
				<tr>
					<td>
						菜单权限：
					</td>
					<td>
						<input type="checkbox" id="createQX" name="createQX" value="1" checked="checked" />创建<br/>
						<input type="checkbox" id="readQX" name="readQX" value="1" checked="checked"/>读取<br/>
						<input type="checkbox" id="updateQX" name="updateQX" value="1" checked="checked" />更新<br/>
						<input type="checkbox" id="deleteQX" name="deleteQX" value="1" checked="checked" />删除
					</td>
				</tr>
			</table>
			
		</div>
</body>
</html>