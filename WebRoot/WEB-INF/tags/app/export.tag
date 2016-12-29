<%@ tag body-content="empty" pageEncoding="UTF-8"%>
<%@ attribute name="module_id" required="false" %>
<%@ attribute name="id" required="true" %>
<%@ attribute name="fileName" required="true" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<script type="text/javascript">
function downExcel${id}(epath){
	if(!downApp.waiting){
		downApp.waiting = true;
		setTimeout(function() {
			downApp.waiting = false;
		}, 2000);
	}else{
		return;
	}
	//判断是否拥有导出权限
	var cmenuid = '';
	try{
		if('${module_id}' != '' && '${module_id}' != null){
			cmenuid = '${module_id}';
		}else if(top.window.currentId != '' && top.window.currentId != undefined){
			cmenuid = top.window.currentId;
		}else if('${param.currentId}' != '' && '${param.currentId}' != null){
			cmenuid = '${param.currentId}';
		}else{
			cmenuid = '';
		}
	}catch(err){
		cmenuid = '';
	}
	$.post('<e:url value="/export2Log.e"/>',{menuid:cmenuid,content:epath});
	//if(cmenuid != null && cmenuid != ''){
	if('${applicationScope.AuthExport}' == 'false' || '${applicationScope.AuthExport}' == '' || '${applicationScope.AuthExport}' == 'null'){
		downApp.downTreeGridJson('${id}',epath,cmenuid,'${downArgs}','${fileName}');
	}else{
		$.post('<e:url value="/auth2Export.e"/>',{menuid:cmenuid},function(authflag){
			if(authflag == '1'){
				downApp.downTreeGridJson('${id}',epath,cmenuid,'${downArgs}','${fileName}');
			}else{
				$.messager.alert('下载提示','您没有导出权限！','warning');
			}
		});
	}
	//}else{
	//	$.messager.alert('下载提示','请您正确选择菜单，然后在点击导出！','warning');
	//}
}
</script>
<a href="javascript:void(0)" class="easyui-linkbutton" onclick="downExcel${id}('excel')" data-options="plain:true,iconCls:'icon-downexcel'"></a>
<span style="padding-left:2px;"></span>
<a href="javascript:void(0)" class="easyui-linkbutton" onclick="downExcel${id}('pdf')" data-options="plain:true,iconCls:'icon-downpdf'"></a>