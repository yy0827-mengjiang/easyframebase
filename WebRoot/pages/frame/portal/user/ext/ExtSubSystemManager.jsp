<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>扩展属性配置子系统</title>
		<c:resources type="easyui" style="${ThemeStyle }"/>
		<e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/resources/themes/blue/boncBlue.css"/>
		<script type="text/javascript">
			function formatterCZ1(value,rowData){
				var content="--";
				if(rowData.INFLUENCE_TYPE!='1')
					content='<a class="easyui-linkbutton" href="javascript:void(0);" onclick="deleteSubSystem(\''+rowData.SUBSYSTEM_ID+'\');">删除</a>';
				return content;
			}
			function doQueryForHasSelect(){
			
		        var params ={};
		        params.id=$('#subSystemIdForHasSelect').val();
				params.name=$('#subSystemNameForHasSelect').val();
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
		        $('#hasSelectSubSystemsTable').datagrid("load",params);
			}
			
			function deleteSubSystem(subSystemId){
				var params={};
				params.attrCode='${param.attrCode }';
				params.subSystemId=subSystemId;
				$.post(appBase + '/pages/frame/portal/user/ext/ExtAction.jsp?eaction=removeSubSystem', params, function(data){
					if($.trim(data)>0){
	             		$('#hasSelectSubSystemsTable').datagrid("load",$("#hasSelectSubSystemsTable").datagrid("options").queryParams);
	             		$('#needSelectSubSystemsTable').datagrid("load",$("#needSelectSubSystemsTable").datagrid("options").queryParams);
	             	}else{
	             		$.messager.alert("提示信息","<br/>删除失败！",'info');
						return false;
	             	}
				
				});
			
			}
			function formatterCZ2(value,rowData){
				var content="--";
				if(rowData.INFLUENCE_TYPE!='1')
					content='<a class="easyui-linkbutton" href="javascript:void(0);" onclick="addSubSystem(\''+rowData.SUBSYSTEM_ID+'\');">添加</a>';
				return content;
			}
			
			function doQueryForNeedSelect(){
				var params ={};
				
				params.id=$('#subSystemIdForNeedSelect').val();
				params.name=$('#subSystemNameForNeedSelect').val();
				
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
		        $('#needSelectSubSystemsTable').datagrid("load",params);
			
			}
			function addSubSystem(subSystemId){
			
				var params={};
				params.attrCode='${param.attrCode }';
				params.subSystemId=subSystemId;
				$.post(appBase + '/pages/frame/portal/user/ext/ExtAction.jsp?eaction=addSubSystem', params, function(data){
	             	if($.trim(data)>0){
	             		$('#hasSelectSubSystemsTable').datagrid("load",$("#hasSelectSubSystemsTable").datagrid("options").queryParams);
	             		$('#needSelectSubSystemsTable').datagrid("load",$("#needSelectSubSystemsTable").datagrid("options").queryParams);
	             	}else{
	             		$.messager.alert("提示信息","<br/>添加失败！",'info');
						return false;
	             	}
	             	
	             });
			
			}
			
			function goExtManager(){
				window.location.href=appBase + '/pages/frame/portal/user/ext/ExtManager.jsp';
			}
		</script>
	</head>
	<body>
		<div style="width:50%; height:500px; float:left; border-right:1px solid #ddd">
			<c:datagrid url="/pages/frame/portal/user/ext/ExtAction.jsp?eaction=getHasSelectSubSystems&attrCode=${param.attrCode }" id="hasSelectSubSystemsTable" pageSize="10" fit="true" border="flase" toolbar="#tb1" >
				<thead>
					<tr>
						<th field="SUBSYSTEM_ID" width="200">
							子系统ID
						</th>
						<th field="SUBSYSTEM_NAME" width="200">
							子系统名称
						</th>
						<th field="CZ1" width="60" align="center" formatter="formatterCZ1">
							操作
						</th>
					</tr>
				</thead>
			</c:datagrid>
		</div>
		<div style="width:49%; height:500px; float:left;">	
			<c:datagrid url="/pages/frame/portal/user/ext/ExtAction.jsp?eaction=getNeedSelectSubSystems&attrCode=${param.attrCode }" id="needSelectSubSystemsTable" pageSize="10" fit="true" toolbar="#tb2">
				<thead>
					<tr>
						<th field="SUBSYSTEM_ID" width="200">
							子系统ID
						</th>
						<th field="SUBSYSTEM_NAME" width="200">
							子系统名称
						</th>
						<th field="CZ2" width="60" align="center" formatter="formatterCZ2">
							操作
						</th>
					</tr>
				</thead>
			</c:datagrid>
		</div>
		<div id="tb1">
			<form id="loginLogForm" method="post" name="loginLogForm" action="">
				<h2>已选择的子系统</h2>
				<div class="search-area">
					ID:<input id="subSystemIdForHasSelect"  type="text" name="subSystemIdForHasSelect" value="" class="easyui-validatebox" validType="length[0,30]" style="width: 80px">
					名称:<input id="subSystemNameForHasSelect" type="text" name="subSystemNameForHasSelect" value="" class="easyui-validatebox" validType="length[0,100]" style="width: 80px">
					<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQueryForHasSelect()">查询</a>
				</div>
			</form>
		</div>
		<div id="tb2">
			<form id="loginLogForm" method="post" name="loginLogForm" action="">
				<h2>未选择的子系统</h2>
				<div class="search-area">
					ID:<input id="subSystemIdForNeedSelect"  type="text" name="subSystemIdForNeedSelect" value="" class="easyui-validatebox" validType="length[0,30]" style="width: 80px">
					名称:<input id="subSystemNameForNeedSelect" type="text" name="subSystemNameForNeedSelect" value="" class="easyui-validatebox" validType="length[0,100]" style="width: 80px">
					<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQueryForNeedSelect()">查询</a>
					<a href="javascript:void(0);" class="easyui-linkbutton easyui-linkbutton-gray" onclick="goExtManager()">返回</a>
				</div>
			</form>
		</div>
	</div>
</body>
</html>