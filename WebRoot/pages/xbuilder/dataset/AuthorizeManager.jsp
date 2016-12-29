<%@page import="java.util.HashSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>

<e:q4o var="FirstDBSource" sql="xbuilder.authorize.FirstDBSource"/>
<e:q4l var="sqlSources">
	SELECT DB_ID, DB_NAME, DB_SOURCE
			   FROM X_EXT_DB_SOURCE  ORDER BY ORD
</e:q4l>
<e:set var="sqlSourcesList">${sqlSources.list }</e:set>
<%
	Object sourcesList=pageContext.getAttribute("sqlSourcesList");
	java.util.Map <String, cn.com.easy.core.sql.EasyDataSource> extds= cn.com.easy.core.EasyContext.getContext().getExtDataSource();
	java.util.Set<String> key = extds.keySet();
	HashSet<String> dataSources= new HashSet();
	for(String s:key){
		if(sourcesList.toString().indexOf(s)==-1){
			dataSources.add(s);
		}
	}
	pageContext.setAttribute("newSet",dataSources);
	//pageContext.setAttribute("dsSet", key);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<c:resources type="easyui" style="${ThemeStyle }"></c:resources>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>数据集授权管理</title>

<e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/resources/themes/blue/boncBlue.css"/>
<script type="text/javascript">
	var curdbname = '${FirstDBSource.DB_NAME}';
	var curdbID = '${FirstDBSource.DB_ID}';
	//alert(curdbname);
	var flag = true;
	
	$(function(){
		
		$("#userWinDialog").dialog({
			width:800,
			height:410,
			modal:true,
			closed:true,
			top:60
		});
		
		//定义新增表单
		$('#addSourceForm').form({  
			url:appBase + "/pages/xbuilder/dataset/accountAction.jsp?eaction=INSERTSOURCE",
		    onSubmit: function(){  
		        return $(this).form('validate');
		    },
		    success:function(data){  
		        var temp = $.trim(data);
				if(temp == "isHave"){
					$.messager.alert("提示信息","数据源编码已经存在！","error");
				}else if(temp>0) {
					$.messager.alert("提示信息","增添成功！","info");
					$("#sourceAddDialog").dialog("close");
					//window.location.href="<e:url value='/pages/frame/role/RoleManager.jsp'/>";
					window.location.reload();
					//$('#dbTable').datagrid("reload");
				} else {
					alert("扩展数据源保存过程中出现错误，请联系管理员！");
				}
			}
		}); 
		//定义新增弹出框
		$("#sourceAddDialog").dialog({
			width:540,
			height:280,
			modal:true,
			closed:true,
			top:60,
			buttons:[{
				text:'提交',
				handler:saveSource
			}]
		});	
		
		$('#sourceEditForm').form({  
			url:appBase + "/pages/xbuilder/dataset/accountAction.jsp?eaction=UPDATESource",
		    onSubmit: function(){
		        return $(this).form('validate');
		    },
		    success:function(data){  
		       var temp = $.trim(data);
		      	if(temp>0) {
					$.messager.alert("提示信息","更新成功！","info");
					$("#sourceEidtDialog").dialog("close");
					//window.location.href="<e:url value='/pages/frame/role/RoleManager.jsp'/>";
					$('#dbTable').datagrid("load",$("#dbTable").datagrid("options").queryParams);
				} else {
					alert("数据源保存过程中出现错误，请联系管理员！");
				}
			}
		}); 
	//编辑弹出窗
		$("#sourceEidtDialog").dialog({
			width:540,
			height:280,
			modal:true,
			closed:true,
			top:60,
			buttons:[{
				text:'提交',
				handler:saveUpdSource
			}]
		});

	});
	//编辑数据源
	function saveUpdSource(){
		$('#sourceEditForm').submit();
	}
	//新增账户提交按钮事件
	function saveSource(){
		$("#addSourceForm").submit();
	}
	
	function loadData(data){
		//alert(1);
		$('#dbTable').datagrid('selectRow','0');
		var obj=$('#dbTable').datagrid('getSelected');
		curdbID=obj.DB_ID;
		refreshDataGrid();
	}
	function delAccount(Id){
		var info = {};
		info.eaction="XBDELETE";
		info.account_code = Id;
		info.db_id = curdbID;
		var postUrl=appBase + "/pages/xbuilder/dataset/accountAction.jsp";
		$.messager.confirm("确认信息","您确定要删除账户吗？",function(r){
			if(r){
				$.post(postUrl,info,function(data){
					if(!isEmpty($.trim(data))){
						$.messager.alert("提示信息","删除成功！","info");
						refreshDataGrid();
					}else {
						$.messager.alert("提示信息","删除账户过程中出现错误，请联系管理员！","error");
					}
				});
			}
		});
	}
	function addAccount(){
		$("#userWinDialog").dialog('open');
		$('#userWinLoad').load(appBase + '/pages/xbuilder/dataset/accountList.jsp?db_id＝'+curdbID,{width:500,height:380},function (data){
			$("#doQueryAccounta").linkbutton();
			$("#doSelectAccounta").linkbutton();
		});
	}
	function doSelectAccount(){
		var rows = $('#accountTableNoSel').datagrid('getSelections');
		if(rows.length>0){
			var list = [];
			$(rows).each(function(){
				list.push(this.ACCOUNT_CODE);
			});
			$.post(appBase + '/pages/xbuilder/dataset/accountAction.jsp?eaction=XBADDACCOUNT',{db_id:curdbID,accountIds:$.toJSON(list)}, function(){
				$('#userWinDialog').dialog('close'); 
				refreshDataGrid();
				$.messager.alert('消息','添加账户成功','info'); 
			});
		}
	}
	function refreshDataGrid(){
		var params = {db_id:curdbID,account_code:$.trim($('#account_code').val()),account_name:$.trim($('#account_name').val())};
		$('#dbAccountTable').datagrid('options').queryParams=params;
		$('#dbAccountTable').datagrid('reload');
	}
	
	function onQueryAccount(index,row){
		if(flag){
			curdbID = row.DB_ID;
			refreshDataGrid();
		}else{
			flag = true;
		}
		
	}
	function formatterCZ(value,rowData){
		return '<a href="javascript:void(0);" style="text-decoration: none;margin:0 5px;" onclick="delAccount(\''+rowData.ACCOUNT_CODE+'\')">删除</a>';
	}
	//数据源操作
	function formatterSZ(value,rowData){
		var content ='<a href="javascript:void(0);" style="text-decoration: none;margin: 0 5px;" onclick="toEditSource(\''+rowData.DB_ID+'\')">编辑</a>'+
       				 '<a href="javascript:void(0);" style="text-decoration: none;margin: 0 5px;" onclick="doDeleteSource(\''+rowData.DB_ID+'\')">删除</a>';
		return content;
	}
	//编辑数据源
	function toEditSource(DB_ID){
		var info = {};
		info.DB_ID=DB_ID;
		info.eaction="SOURCERELOAD";
		$("#sourceEidtDialog").dialog("open");
		var postUrl=appBase + "/pages/xbuilder/dataset/accountAction.jsp";
		$.post(postUrl,info,function(data){
			if(data!=null){
				$("#sourceEditForm").form("load",data[0]);
			}
		},"json");
	}
	
	function doDeleteSource(DB_ID){
		var info = {};
		info.eaction="DELETESource";
		info.DB_ID = DB_ID;
		var postUrl=appBase + "/pages/xbuilder/dataset/accountAction.jsp";
		$.messager.confirm("确认信息","您确定要删除数据源吗？",function(r){
			if(r){
				$.post(postUrl,info,function(data){
					var temp = $.trim(data);
					if(!isEmpty(temp)){
						$.messager.alert("提示信息","删除成功！","info");
						//window.location.href="<e:url value='/pages/frame/role/RoleManager.jsp'/>";
						$('#dbTable').datagrid("reload");
					
					}else {
						$.messager.alert("提示信息","数据源删除过程中出现错误，请联系管理员！","error");
					}
				});
			}
		});
	}
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
	
	
	function addSource(){
		setFormDataNull();
		$("#sourceAddDialog").dialog("open");
	}
	
	//将form表单内容初始化
	function setFormDataNull(){
		$("#dbID").val("");
		$("#db_name").val("");
		$("#db_source").val("");
		$("#db_ord").numberspinner('setValue', 0);
	}
</script>
</head>
<body>
<div style="width:39.5%;height:100%; float:left; border-right:1px solid #ddd">
	<div id="tb1" class="unBorder">
		<h2>数据源授权管理</h2>
		<!-- {e:length(newSet)}
		 <e:forEach items="${newSet}" var="ds">
			                  <option value ="${ds}">${ds}</option>	
			               </e:forEach>	
		 -->
		<div class="search-area">
			<a href="javascript:void(0);" class="easyui-linkbutton easyui-linkbutton-green" onclick="addSource()">新增<e:if condition="${e:length(newSet)>0 }">(${e:length(newSet)})</e:if></a>
		</div>
	</div>
	<c:datagrid url="/pages/xbuilder/dataset/accountAction.jsp?eaction=DBLIST" id="dbTable" singleSelect="true"  onClickRow="onQueryAccount" nowrap="false" border="false" style="height:360px;" onLoadSuccess="loadData" toolbar="#tb1" pageSize="15">
		<thead>
			<tr>
				<!--  
				<th field="DB_ID" width="10" sortable="true" align="center">编码</th>
				-->
				<th field="DB_NAME" width="20" sortable="true" align="center">数据源名称</th>
				<th field="DB_SOURCE" width="40" sortable="true" align="center">数据源描述</th>
				<th field="cz" width="18" formatter="formatterSZ" align="center">操作</th>
			</tr>
		</thead>                    
	</c:datagrid>
</div>
	
<div style="height:100%; float:left; width:60%;">
	<div id="tb2" class="unBorder">
		<form action="" method="post" id="procLogForm" style="margin:0; padding:0; border:0;">
			<h2>账户信息列表</h2>
			<div class="search-area">
				账户编码：<input type="text" id="account_code" name="account_code" style="width:120px;"  value="${param.account_code}" />
				账户名称：<input type="text" id="account_name" name="account_name" style="width:120px;" value="${param.account_name}" />
				<a href="javascript:void(0);" class="easyui-linkbutton" onclick="refreshDataGrid()">查询</a>
				<a href="javascript:void(0);" class="easyui-linkbutton easyui-linkbutton-green" onclick="addAccount()">新增</a>
			</div>
		</form>
	</div>
	<c:datagrid url="/pages/xbuilder/dataset/accountAction.jsp?eaction=accountList" id="dbAccountTable" singleSelect="true" nowrap="false" pagination="true" style="height:360px;" toolbar="#tb2" pageSize="15">
	<thead>
		<tr>
			<th field="ACCOUNT_CODE" width="40" sortable="true" align="center">账户编码</th>
			<th field="ACCOUNT_NAME" width="40" sortable="true" align="center">账户名称</th>
			<th field="ACCOUNT_DESC" width="200" sortable="true" align="left">账户描述</th>
			<th field="cz" width="80" formatter="formatterCZ" align="center">操作</th>
		</tr>
	</thead>                    
</c:datagrid>
</div>
<div id="userWinDialog" title="添加账户">
	<div id="userWinLoad"></div>
</div>
<div id="sourceAddDialog" title="新增扩展数据源">
		<form action="" method="post" id="addSourceForm">
			<table width="100%" class="windowsTable">
			<colgrounp>
			<col width="24%"/>
			<col width="*"/>
			</colgrounp>
				<tr>
					<th>扩展数据源编码：</th>
					<td>
						<input type="text" id="dbID" name="dbID" style="width:75%;"  class="easyui-validatebox" required validType="test[/[^A-Za-z0-9_]/g]">
					</td>
				</tr>
				<tr>
					<th>扩展数据源名称：</th>
					<td >
						<input type="text" id="db_name" name="db_name" style="width:75%;"  class="easyui-validatebox" required>
					</td>
				</tr>
				<tr>
					<th>扩展数据源描述：</th>
					<td>
						<!-- 
						<input type="text" id="db_source" name="db_source" style="width:75%;"  class="easyui-validatebox" required>
						 -->
						 <select id="db_source" name="db_source">
						 	<e:forEach items="${newSet}" var="ds">
			                  <option value ="${ds}">${ds}</option>	
			               </e:forEach>	
						 </select>
					</td>
				</tr>
				<tr>
					<th>排序：</th>
					<td>
						<input id="db_ord" name="db_ord" class="easyui-numberspinner" min="0" value="0" required="true" style="width:78%"></input>
					</td>
				</tr>
			</table>
		</form>
	</div>
	<div id="sourceEidtDialog" title="编辑扩张数据源">
		<form action="" method="post" id="sourceEditForm">
			<table width="100%" class="windowsTable" >
			<colgrounp>
			<col width="24%"/>
			<col width="*"/>
			</colgrounp>
				<tr>
					<th>扩展数据源编码：</th>
					<td>
						<input type="hidden" id="db_id_old"  name="db_id_old">
						<input type="text" id="db_id_upd" name="db_id_upd" style="width:75%;" disabled="disabled">
					</td>
				</tr>
				<tr>
					<th>扩展数据源名称：</th>
					<td >
						<input type="text" id="db_name_upd" name="db_name_upd" style="width:75%;"  class="easyui-validatebox" required>
					</td>
				</tr>
				<tr>
					<th>扩展数据源描述：</th>
					<td>
					
						<input type="text" id="db_source_upd" name="db_source_upd" style="width:75%;"  class="easyui-validatebox" required>
					</td>
				</tr>
				<tr>
					<th>排序：</th>
					<td>
						<input id="db_ord_upd" name="db_ord_upd" class="easyui-numberspinner" min="0" value="0" required="true" style="width:20%"></input>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>