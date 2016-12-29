<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
		<e:style value="/resources/themes/base/boncBase@links.css"/>
		<script type="text/javascript">
			$(function(){
				$('#dialog_addUser').dialog({
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
					content='<a class="easyui-linkbutton" href="javascript:void(0);" onclick="deleteUser(\''+rowData.USER_ID+'\');">删除</a>';
				return content;
			}
			function doQueryForHasSelect(){
			
		        var params ={};
		        params.loginId=$('#loginIdForHasSelect').val();
				params.userName=$('#userNameForHasSelect').val();
		        var localtionUrl=window.location.href;
		        var paramString="";
		        var tempArray=[];
		        paramString=localtionUrl.substring(localtionUrl.indexOf("?")+1);
		        if(paramString!=""){
		        	tempArray=paramString.split("&");
		        	for(var a=0;a<tempArray.length;a++){
		        		params[tempArray[a].split("=")[0]]=tempArray[a].split("=")[1];
		        	}
		        }
		        $('#hasSelectUsersTable').datagrid("load",params);
			}
			
			function deleteUser(userId){
				var params={};
				var roleCode='${param.currentNodeId}';
				params.userId=userId;
				params.roleCode=roleCode;
				$.post('<e:url value="/pages/frame/portal/role/RoleAction.jsp?eaction=removeUser"/>', params, function(data){
					if($.trim(data)>0){
	             		$('#hasSelectUsersTable').datagrid("load",$("#hasSelectUsersTable").datagrid("options").queryParams);
	             		$('#needSelectUsersTable').datagrid("load",$("#needSelectUsersTable").datagrid("options").queryParams);
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
					content='<a class="easyui-linkbutton" href="javascript:void(0);" onclick="addUser(\''+rowData.USER_ID+'\');">添加</a>';
				return content;
			}
			
			function doQueryForNeedSelect(){
				var params ={};
				params.loginId=$('#loginIdForNeedSelect').val();
				params.userName=$('#userNameForNeedSelect').val();
				
		        var localtionUrl=window.location.href;
		        var paramString="";
		        var tempArray=[];
		        paramString=localtionUrl.substring(localtionUrl.indexOf("?")+1);
		        if(paramString!=""){
		        	tempArray=paramString.split("&");
		        	for(var a=0;a<tempArray.length;a++){
		        		params[tempArray[a].split("=")[0]]=tempArray[a].split("=")[1];
		        	}
		        }
		        $('#needSelectUsersTable').datagrid("load",params);
			
			}
			function addUser(userId){
			
				var params={};
				params.userId=userId;
				params.roleCode='${param.currentNodeId }';
				$.post('<e:url value="/pages/frame/portal/role/RoleAction.jsp?eaction=addUser"/>', params, function(data){
	             	if($.trim(data)=='1'){
	             		$('#hasSelectUsersTable').datagrid("load",$("#hasSelectUsersTable").datagrid("options").queryParams);
	             		$('#needSelectUsersTable').datagrid("load",$("#needSelectUsersTable").datagrid("options").queryParams);
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
			 $(".easyui-linkbutton").linkbutton();
		</script>
	
	<table width="100%">
		<tr>
			<td width="50%">
				<div id="tb1">
					<form id="loginLogForm" method="post" name="loginLogForm"  action="">
						<h2>已选择的用户</h2>
						<div class="search-area">
							登陆ID:<input id="loginIdForHasSelect"  type="text" name="loginIdForHasSelect" value="" class="easyui-validatebox" validType="length[0,30]" style="width: 80px">
							用户姓名:<input id="userNameForHasSelect" type="text" name="userNameForHasSelect" value="" class="easyui-validatebox" validType="length[0,100]" style="width: 80px">
							<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQueryForHasSelect()">查询</a>
						</div>
					</form>
				</div>
				<c:datagrid url="/pages/frame/portal/role/RoleAction.jsp?eaction=getHasSelectUsers&currentNodeId=${param.currentNodeId }" id="hasSelectUsersTable" pageSize="10"  style="width:100%;height:400px;"  toolbar="#tb1">
					<thead>
						<tr>
							<th field="LOGIN_ID" width="30%">
								登陆ID
							</th>
							<th field="USER_NAME" width="30%">
								用户姓名
							</th>
							<th field="CZ1" width="40%" align="center" formatter="formatterCZ1">
								操作
							</th>
						</tr>
					</thead>
				</c:datagrid>
			</td>
			<td width="50%">
				<div id="tb2">
					<form id="loginLogForm" method="post" name="loginLogForm"  action="">
						<h2>未选择的用户</h2>
						<div class="search-area">
							登陆ID:<input id="loginIdForNeedSelect"  type="text" name=""loginIdForNeedSelect"" value="" class="easyui-validatebox" validType="length[0,30]" style="width: 80px">
							用户姓名:<input id="userNameForNeedSelect" type="text" name="userNameForNeedSelect" value="" class="easyui-validatebox" validType="length[0,100]" style="width: 80px">
							<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQueryForNeedSelect()">查询</a>
						</div>
					</form>
				</div>
				<c:datagrid url="/pages/frame/portal/role/RoleAction.jsp?eaction=getNeedSelectUsers&currentNodeId=${param.currentNodeId }" id="needSelectUsersTable" pageSize="5" style="width:100%;height:400px;" title=""  toolbar="#tb2">
					<thead>
						<tr>
							<th field="LOGIN_ID" width="30%">
								登陆ID
							</th>
							<th field="USER_NAME" width="30%">
								用户姓名
							</th>
							<th field="CZ2" width="40%" align="center" formatter="formatterCZ2">
								操作
							</th>
						</tr>
					</thead>
				</c:datagrid>
			</td>
		</tr>
	</table>
