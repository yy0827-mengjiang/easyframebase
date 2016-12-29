<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4l var="component_list" sql="xbuilder.component.component_list"></e:q4l>
<script>
var state_comp_list = $('#layoutHtml').attr("data-layouttype");//加载样式类型 附件的属性
if(state_comp_list == 'layout_06'){
	$("div[layout=true]").hover(
	function(){layout_temp_selected_id = $(this).attr("id");},
	function(){layout_temp_selected_id = ""; });
}
</script>

<e:forEach items="${component_list.list}" var="item" indexName="i">
	<e:if condition="${i < 10}"><li class="tIco0${i+1}"><a id="tIco0${i+1}" href="javascript:void(0);" onclick="checkContainer('${item.id}','${item.text}','${item.type}','${item.curl}','${item.propertyUrl}','tIco0${i+1}')" title="${item.title}"><span>${item.text}</span></a></li></e:if>
	<e:else condition="${i < 10}"><li class="tIco${i+1}"><a id="tIco${i+1}" href="javascript:void(0);" onclick="checkContainer('${item.id}','${item.text}','${item.type}','${item.curl}','${item.propertyUrl}','tIco${i+1}')" title="${item.title}"><span>${item.text}</span></a></li></e:else>
</e:forEach> 