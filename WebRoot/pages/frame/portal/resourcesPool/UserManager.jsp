<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<e:q4l var="SexList">
	SELECT '1' TYPE_CODE,'男' TYPE_DESC  FROM DUAL UNION ALL SELECT '0' TYPE_CODE,'女' TYPE_DESC  FROM DUAL
</e:q4l>
<e:q4l var="AdminTypeList">
	SELECT '1' TYPE_CODE,'是' TYPE_DESC  FROM DUAL UNION ALL SELECT '0' TYPE_CODE,'否' TYPE_DESC  FROM DUAL
</e:q4l>
<e:q4l var="StateList">
	SELECT '1' TYPE_CODE,'启用' TYPE_DESC  FROM DUAL UNION ALL SELECT '0' TYPE_CODE,'停用' TYPE_DESC  FROM DUAL
</e:q4l>
		<script type="text/javascript">
			function doSearch(){
			    var param=new Object();
			    param.loginid=$("#loginid").val();
			    param.username=$("#username").val();
			    param.user_sex=$("#user_sex").val();
			    param.user_admin=$("#user_admin").val();
				$('#userTable').datagrid('reload',param);
			}
			$(function(){
				$(window).resize(function(){
				 	$('#userTable').datagrid('resize');
				 });
			});
			
			function submitUser(){
				var userArr = [];
				var rows = $('#userTable').datagrid('getSelections');
				if(rows.length==0){
					$.messager.alert('信息提示', '请先选择协同审核人员', 'error');
					return;
				}
				for(var i=0;i<rows.length;i++){
					userArr.push(rows[i].USER_ID);
				}
				
				var url="<e:url value='/pages/frame/portal/resourcesPool/ResPoolAction.jsp?eaction=addTeamwork'/>";
                  $.post(url,{resId:"${param.resId}",userId:userArr.join(",")},function(data){
                	if(parseInt($.trim(data))>0){
                		$('#usersWindow').window('close');
                		$.messager.alert('信息提示', '发送成功', 'info');
                	}
                });  
			}
			
		</script>

	<div id="tbar">
		<div class="topListUser">
			<form id="procLogForm" name="procLogForm">
				<dl>
					<dt>用户登录号：</dt>
					<dd><input type="text" name="loginid" id="loginid" style="width:100px"  value="${param.loginid}"></dd>
					<dt>用户姓名：</dt>
					<dd><input type="text" name="username" id="username" style="width:100px"  value="${param.username}"></dd>
					<dt>性别：</dt>
					<dd><e:select id="user_sex" name="user_sex" items="${SexList.list}" label="TYPE_DESC" value="TYPE_CODE" headLabel="全部" headValue=""  defaultValue="${param.user_sex}"/>
					</dd>
					<dt>管理员：</dt>
					<dd><e:select id="user_admin" name="user_admin" items="${AdminTypeList.list}" label="TYPE_DESC" value="TYPE_CODE" headLabel="全部" headValue=""  defaultValue="${param.user_admin}"/>
					</dd>
					<p>
						<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doSearch();">查询</a>
						<a class="easyui-linkbutton" href='javascript:void(0)' onclick="submitUser()">提交</a>
					</p>
				</dl>
			</form>
		</div>
		</div>
		<c:datagrid url="/pages/frame/portal/resourcesPool/UserAction.jsp?eaction=list&resId=${param.resId}" id="userTable" pageSize="15" fit="true"
					download="true" nowrap="false"singleSelect="false"   title="用户管理" style="width:auto;height:500px;" toolbar="#tbar">
			<thead>
				<tr>
				    <th field="ck_user" checkbox="true"></th>
					<th field="LOGIN_ID" width="140" align="center">
						登录id
					</th>
					<th field="USER_NAME" width="150" align="center">
						用户姓名
					</th>
					<th field="ADMIN" width="60" align="center">
						管理员
					</th>
					<th field="SEX" width="50" align="center">
						性别
					</th>
					<th field="EMAIL" width="150" align="left">
						邮箱地址
					</th>
					<th field="MOBILE" width="130" align="center">
						移动电话
					</th>
					<th field="TELEPHONE" width="100" align="center">
						固定电话
					</th>
					<th field="MEMO" width="100" align="center">
						备注信息
					</th>
				</tr>
			</thead>
		</c:datagrid>
