<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:q4l var="col_list" sql="frame.collect.col_list"/>
<script>
$("#insert_collect").bind("click", function(){
	$("#insColLoad").load("pages/frame/collect/InsertCollect.jsp",{menuId:currentId},function(){
		$("#ord").numberspinner();
		$("#insColDialog").dialog('open');
	});
});
</script>
<div>
	<b class="triangleDown"><span></span></b>
	<ul>
		<li><a href="javascript:void(0)" class="easyui-linkbutton" id="insert_collect">添加至收藏夹</a></li>
		<e:forEach items="${col_list.list}" var="item">
			<e:if condition="${item.ID!=null && item.ID ne ''}">
				<li><a href="javascript:void(0);" onclick="openMenu('${item.MENU_ID}','${item.RESOURCES_NAME}','${item.URL}')">${item.RESOURCES_NAME}</a><a class="close" href="javascript:void(0);" onclick="delCol('${item.ID}')">×</a></li>
			</e:if>
		</e:forEach>
	</ul>
</div>
