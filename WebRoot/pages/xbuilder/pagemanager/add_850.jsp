<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<script>
	var lw;
	$(function() {
		lw = screen.width-10;
	});
	function toCvd(dsType){
		window.open(appBase+'/pages/xbuilder/pagedesigner/XBuilder.jsp?dsType='+dsType+'&lw='+lw);
		window.returnValue=false;
	}
</script>
<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
<e:style value="/pages/xbuilder/resources/themes/base/boncXcommon.css" />
<e:style value="/pages/xbuilder/resources/themes/base/boncXlayout.css" />
 <div class="newDateGuide" style="padding-top:0px;">
	<div class="topDateList"><h3>选择数据源类型</h3> <a href="javascript:void(0);" onclick="$('#report_menu_load').window('close')">&times;</a></div>
	<ul class="imgDateList twoItem">
		<li class="num1Item"><a href="javascript:void(0);" onclick="toCvd(1);" style="width:320px;"><span>自定义SQL</span></a></li>
		<li class="num2Item"><a href="javascript:void(0);" onclick="toCvd(2);" style="width:320px;"><span>指标库1</span></a></li>
		<!-- <li class="num3Item"><a href="javascript:void(0);" style="cursor: url('<e:url value="/pages/xbuilder/resources/themes/base/images/icons/unset.png"/>'),default;"><span>立方体</span></a></li> -->
	</ul>
</div>