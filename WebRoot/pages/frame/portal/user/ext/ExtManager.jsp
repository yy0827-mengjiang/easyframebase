<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:q4l var="types">
select t.type_code,t.type_desc from e_user_extvalue_type t
</e:q4l>
<e:q4l var="models">
select t.model_code,t.model_desc from e_user_ext_model t
</e:q4l>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<c:resources type="easyui,app" style="${ThemeStyle }"></c:resources>
<e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/resources/themes/blue/boncBlue.css"/>
<script type="text/javascript"> 
	$(window).resize(function(){
	 	$('#ext_table').treegrid('resize');
	});
	function doQuery(){  
 		$("#procLogForm").attr('action','<e:url value="/pages/frame/portal/user/ext/ExtManager.jsp"/>');
	    $("#procLogForm").attr('method','post');
	    $("#procLogForm").submit();
	}
	function addExt(){
		window.location.href="<e:url value='/pages/frame/portal/user/ext/ExtAdd.jsp'/>";
	}
	//删除扩展信息
	function delExt(id){
		var info ={};
		info.eaction="DELETE";
		info.attrCode=id;
		var postUrl = "<e:url value='/pages/frame/portal/user/ext/ExtAction.jsp'/>";
		$.messager.confirm("删除信息提示","确定要删除所选扩展属性吗？",function(r){
			if(r){
				$.post(postUrl,info,function(data){
					if(data>0){
						$.messager.alert("提示信息","删除成功！","info");
						$('#ext_table').datagrid("load",$("#ext_table").datagrid("options").queryParams);
					} else {
						$.messager.alert("提示信息","删除过程中出现错误，请联系管理员！","error");
					}
				});
			}
		});
	}
	function updExt(id){
		var managerForm = $("#managerForm");
		$("#attrCode").val(id);
		managerForm.attr("action","<e:url value='/pages/frame/portal/user/ext/ExtUpdate.jsp'/>");
		managerForm.submit();
		//window.location.href="<e:url value='/pages/frame/portal/user/ext/ExtUpdate.jsp'/>?attrCode="+id;
	}
	function formatterExt(value,rowData){
		var res = '<a href="javascript:void(0);" style="text-decoration: none;margin:0 2px;" onclick="updExt(\''+rowData.ATTR_CODE+'\')">修改</a>'+
				  '<a href="javascript:void(0);" style="text-decoration: none;margin:0 2px;" onclick="delExt(\''+rowData.ATTR_CODE+'\')">删除</a>';				 
				 // '<a href="javascript:void(0);" style="text-decoration: none;margin:0 2px;" onclick="setSubSystem(\''+rowData.ATTR_CODE+'\')">子系统</a>';
		return res;
	}
	function setSubSystem(id){
		var managerForm = $("#managerForm");
		$("#attrCode").val(id);
		managerForm.attr("action","<e:url value="/pages/frame/portal/user/ext/ExtSubSystemManager.jsp"/>");
		managerForm.submit();
	}
</script>
</head>
<body>
	<div id="toobars" class="newSearchA" >
		<h2>扩展属性管理</h2>
		<div class="search-area">
			<form id="procLogForm" name="procLogForm">
				扩展属性编码： <input type="text" id="attr_code"  style="width:120px" name="attr_code" value="${param.attr_code}"></dd>
				扩展属性名称： <input type="text" id="attr_name"  style="width:120px" name="attr_name" value="${param.attr_name}"></dd>
				属性值类型： <e:select items="${types.list}" id="value_type"  name="value_type" label="type_desc" value="type_code" headLabel="全部" headValue=""  defaultValue="${param.value_type}" style="width:80px;"/></dd>
				展现模式 <e:select items="${models.list}" id="model_type" name="model_type" label="model_desc" value="model_code" headLabel="全部" headValue=""  defaultValue="${param.model_type}" style="width:80px;"/></dd>
				<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQuery()">查询</a>
				<a href="javascript:void(0);" class="easyui-linkbutton easyui-linkbutton-green"  onclick="addExt()" style="text-decoration: none;" >新增</a>
			</form>
		</div>
	</div>

<form action="" method="post" id="managerForm">
	<input id="attrCode" name="attrCode" type="hidden" />
</form>
<c:datagrid url="/pages/frame/portal/user/ext/ExtAction.jsp?eaction=LIST&attr_code=${param.attr_code}&attr_name=${param.attr_name}&value_type=${param.value_type}&model_type=${param.model_type}" id="ext_table" pageSize="15" fit="true"
					 nowrap="false" style="width:auto;height:500px;" toolbar="#toobars" border="false">
	<thead>
		<tr>
			<th field="ATTR_CODE" width="100"  sortable="true" align="center">属性编码</th>
			<th field="ATTR_NAME" width="100"  sortable="true" align="center">属性名称</th>
			<th field="ATTR_DESC" width="100"  sortable="true" align="center">属性描述</th>
			<th field="DATA_TYPE" width="100"  sortable="true" align="center">属性值类型</th>
			<th field="SHOW_MODE" width="100"  sortable="true" align="center">展现模式</th>
			<th field="MULTI" width="100"  sortable="true" align="center">多选</th>
			<th field="IS_NULL" width="100"  sortable="true" align="center">可以为空</th>
			<th field="DEFAULT_VALUE" width="100"  sortable="true" align="center">默认值</th>
			<th field="DEFAULT_DESC" width="100"  sortable="true" align="center">默认描述</th>
			<th field="SUBSYSTEM_NAME" width="100"  sortable="true" align="center">所属子系统</th>
			<th field="CZ" width="130"  formatter="formatterExt" align="center">操作</th>
		</tr>                          
	</thead>                    
</c:datagrid>
</body>
</html>