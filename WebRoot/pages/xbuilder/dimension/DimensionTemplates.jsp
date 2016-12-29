<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="cn.com.easy.xbuilder.element.*,cn.com.easy.xbuilder.*"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<script>
toolsAddHideEvent();
function toolsAddHideEvent(){
	$(".propertiesPane h4").click(function(){
    	$(this).next("div.ppInterArea").slideToggle("fast");
    	$(this).toggleClass("ot");
    })
}
</script>
<div class="propertiesPane">
	<h4>维度模板</h4>
	<div class="ppInterArea">
	<input type="hidden" id="dimtemplate_varname" value="${param.varname }"/>
	<a:tree url="pages/xbuilder/dimension/DimensionAction.jsp?eaction=VARDIMTREE" id="var_select_load" onLoadSuccess="dimNodeextendAll" onDblClick="dimdbSelect"/>
	</div>
</div>