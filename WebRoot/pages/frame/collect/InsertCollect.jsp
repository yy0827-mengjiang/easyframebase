<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<e:q4o var="pages">
	select RESOURCES_NAME from e_menu where RESOURCES_ID = #menuId#
</e:q4o>

<script type="text/javascript">
function insCol(){
	var info = {};
	info.menuId = '${param.menuId}';
	info.userId = '${sessionScope.UserInfo.USER_ID}';
	info.ord = $("#ord").numberspinner('getValue');
	var postUrl="<e:url value='/pages/frame/collect/CollectAction.jsp?eaction=INSERT'/>";
	$.post(postUrl,info,function(data){
		var temp = $.trim(data);
		if(temp>0) {
			$.messager.alert('系统提示','页面收藏成功！');
			$("#insColDialog").dialog('close');
		} else {
			$.messager.alert('系统提示','页面收藏过程中出现错误，请联系管理员！');  
		}
	});
}
</script>
<form id="collectForm" action="" method="post">
	<table border="0" cellspacing="" cellpadding="0" style="margin:0 auto;">
		<tr>
			<td style="padding-top:10px;" align="right">页面名称：</td>
			<td style="padding-top:10px;">
				<input type="text" id="page_name" name="page_name" disabled value="${pages.RESOURCES_NAME}" style="width: 142px;">
			</td>
		</tr>
		<tr>
			<td style="padding-top:10px;" align="right">排 &nbsp; &nbsp; 序：</td>
			<td style="padding-top:10px;">
				<input id="ord" name="ord" class="easyui-numberspinner" min="0" value="0" required="true" style="width: 142px;"/>
			</td>
		</tr>
	</table>
</form>
