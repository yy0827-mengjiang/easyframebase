<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
	<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
<div class="core-panel" onmouseover="LayOutUtil.setComponent('${param.containerId}','${param.componentId}','${param.ispop}');">
<div id="comp_${param.componentId}" data-fun_edit="weblate_web_edit"></div>
<div id="weblate_panel_${param.componentId}" style="width:auto;height:auto;padding:0px;margin: 0px;overflow:hidden;" >
<div id="weblate_${param.componentId}" style="width: auto; height:100%; margin:0 auto 10px auto;">
<div class="addUrl"></div>
</div>
	<script type="text/javascript">	
		var pheight = parseInt( $("#div_area_${param.containerId}").css("height"));
		$("#weblate_panel_${param.componentId}").css("height",(pheight-40)+"px");
		$("#weblate_panel_${param.componentId}").css("width",$("#div_area_${param.containerId}").css("width"));
	</script>
	
</div>
</div>