<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<e:q4l var="ind_type">
	SELECT IND_TYPE_CODE AS "IND_CODE", IND_TYPE_DESC AS "IND_DESC" FROM E_IND_TYPE
</e:q4l>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<base href="<%=basePath%>">
		<title>指标解释</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<c:resources type="easyui,app"  style="${ThemeStyle }"/>
	<script>
		$(window).resize(function(){
		 	$('#tt').datagrid('resize');
		 });

		function doQuery(){
			//var $form = $("#form1");
			//$form.attr("action","<e:url value='/pages/frame/ind/ind_exp.jsp' />");
			//$form.submit();
			//&ind_name=${param.ind_name }&ind_type_code=${param.ind_type_code}
			var params = {};
	    	params.ind_name=$('#ind_name').val();
	    	params.ind_type_code=$('#ind_type_code').val();
			$('#tt').datagrid('options').queryParams=params;
			$('#tt').datagrid('reload');
		}
		
		function myInd(value,rowData){
			var ind_id = rowData.IND_ID;
			var rs='<form id="indLink" method="post"><a href="javascript:void(0);" onclick="selectInd(\''+ind_id+'\')">'+value+'</a></form>';
			return rs;
		}
		
		function selectInd(ind_id){
			var $form = $("#indLink");
			$form.attr("action","<e:url value='/pages/frame/ind/ind_exp_select.jsp?' />"+"ind_id="+ind_id);
			$form.submit();
		}
		function myFormatt(value){
			if(value.length<=7){
				return value;
			}else{
				var str = value.substr(0,7);
				return str+'...';
			}
		}
		function doInsert(){
			var $form = $("#form1");
			$form.attr("action","<e:url value='/pages/frame/ind/ind_exp_insert.jsp' />");
			$form.submit();
		}
		
		function formattInd(value,rowData){
			var ind_id = rowData.IND_ID;
			var rs='<form id="indUpdate" method="post"><a href="javascript:void(0);" style="text-decoration:none;" onclick="updateInd(\''+ind_id+'\')">'+value+'</a></form>';
			return rs;
		}
		function updateInd(ind_id){
			var $form = $("#indUpdate");
			$form.attr("action","<e:url value='/pages/frame/ind/ind_exp_update.jsp?' />"+"ind_id="+ind_id);
			$form.submit();
		}
		
		function getSelectionsAndDelete(){
				var ids = [];
				var rows = $('#tt').datagrid('getSelections');
				if(rows.length<1){
					alert("请选择一项进行编辑!");
					return;
				}
				for(var i=0;i<rows.length;i++){
					ids.push(rows[i].IND_ID);
				}
				var info = {};
				info.ids = $.toJSON(ids);
				$.messager.confirm('指标删除', '确定删除所选指标?', function(r){
				if (r){
						var postUrl="<e:url value='/pages/frame/ind/ind_expAction.jsp'/>?eaction=DELETE";
						$.post(postUrl,info,function(data){
								if(data>0){
										$.messager.alert("指标","指标删除成功！","info");
										$('#tt').datagrid('reload');
									} else {
										$.messager.alert("指标","指标删除过程中出现错误，请联系管理员！","error");
								}
								
						});	
					}
				});
			}
	</script>
	<e:style value="/resources/themes/base/boncBase@links.css"/>
	<e:style value="/resources/themes/blue/boncBlue.css"/>
</head>
<body>
<div id="table_toobar"  class="newSearchA">
	<h2>指标解释管理</h2>
	<div class="search-area">
		<form id="form1" name="form1" style="display: inline;" method="post">
			指标名称：<input type="text" name="ind_name" id="ind_name" value="${param.ind_name }">
			指标类型：<e:select id="ind_type_code" name="ind_type_code" items="${ind_type.list}" label="ind_desc" value="ind_code" headLabel="全部" headValue="" defaultValue="${param.ind_type_code}"/>
			<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQuery()">查询</a>
			<a href="javascript:void(0)" class="easyui-linkbutton easyui-linkbutton-green" onclick="doInsert();">增加指标</a>
			<a href="javascript:void(0)" class="easyui-linkbutton easyui-linkbutton-red" onclick="getSelectionsAndDelete();">删除指标</a>
		</form>
	</div>
</div>
	<c:datagrid id="tt" url="/pages/frame/ind/ind_expAction.jsp?eaction=SELECT" fit="true"
			    fitColumns="false" download="true" toolbar="#table_toobar" singleSelect="false" nowrap="false" border="false">
			<thead frozen="true">
				<tr>
					<th field="ck" checkbox="true">全选</th>
					<th field="IND_CODE"  align="center" sortable="true" >指标编号</th>
					<th field="IND_NAME"  align="left" formatter="myInd"sortable="true" width="150">指标名称</th>
				</tr>
			</thead>
			<thead>
				<tr>
					<th field="IND_TYPE_DESC" width="90" align="center"sortable="true">指标类型</th>
					<th field="BUS_EXP" width="130" align="left" formatter="myFormatt"> 业务解释</th>
					<th field="SKILL_EXP" width="150" align="left" formatter="myFormatt">技术解释</th>
					<th field="OTHER_EXP" width="150" align="left" formatter="myFormatt">其他解释</th>
					<th field="DEPART_DESC" width="120" align="center" sortable="true">局方提出部门</th>
					<th field="FACTORY_CON" width="100" align="center" sortable="true">厂家确认人</th>
					<th field="MAINTE_MAN" width="100" align="center" sortable="true">维护人</th>
					<th field="UPDATE_TIME" width="200" align="center" formatter="formatDAT_tt">最近更新时间</th>
					<th field="ORD" width="50" align="center">排序</th>
					<th field="UPDATE_IND" width="100" align="center" formatter="formattInd">修改指标</th>
				</tr>
			</thead>
		</c:datagrid>
</body>
</html>