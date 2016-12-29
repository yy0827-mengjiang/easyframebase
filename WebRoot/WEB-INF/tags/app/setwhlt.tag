<%@ tag body-content="empty" import="cn.com.easy.xbuilder.service.XBaseService" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ attribute name="xid" required="true" %>
<%@ attribute name="lwidth" required="true" %>
<e:q4o var="conts_o">
	select CONTJSON from x_report_info where id='${xid}'
</e:q4o>
$(function(){
	var containers = $.parseJSON('${conts_o.CONTJSON}');
	for(var c=0;c<containers.length;c++){
		var container = containers[c];
		var width = (container.width/(${lwidth}+14))*100;
		var height = container.height;
		var left = (container.left/(${lwidth}+14))*100;
		var top = container.top;
		$('#'+container.id).css({"position":"absolute","width":width+"%","height":height+"px","left":left+"%","top":top+"px"});
	}