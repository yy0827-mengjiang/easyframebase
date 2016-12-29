<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<e:service/>
<script>
	var lw;
	$(function() {
		lw = screen.width-10;
	});
	function toCvd(dsType){//1：自定义。2：指标库。3：数据集
		if(dsType=='2'){
			window.open(appBase+'/pages/xbuilder/pagedesigner/XBuilder.jsp?dsType='+dsType+'&lw='+lw);
			window.returnValue=false;
		}else if(dsType=='3'){
			var typeExt = dsType;
			window.open(appBase+'/pages/xbuilder/pagedesigner/XBuilder.jsp?dsType=1&lw='+lw+'&typeExt='+typeExt);
			window.returnValue=false;
		}else{
			window.open(appBase+'/pages/xbuilder/pagedesigner/XBuilder.jsp?dsType='+dsType+'&lw='+lw);
			window.returnValue=false;
		}
	}
</script>
<e:script value="/resources/easyResources/component/easyui/jquery.easyui.min.js" />
<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
<e:style value="/pages/xbuilder/resources/themes/base/boncXcommon.css" />
<e:style value="/pages/xbuilder/resources/themes/base/boncXlayout.css" />
 <div class="newDateGuide" style="padding-top:0;">
	<div class="topDateList"><h3>选择数据源类型</h3> <a href="javascript:void(0);" onclick="$('#report_menu_load').window('close')">&times;</a></div>
	<ul class="imgDateList">
		<li class="num1Item"><a href="javascript:void(0);" onclick="toCvd(1);"><span>自定义SQL</span></a></li>
		<li class="num2Item"><a href="javascript:void(0);" onclick="toCvd(2);"><span>指标库</span></a></li>
		<li class="num3Item"><a href="javascript:void(0);" onclick="toCvd(3);"><span>立方体</span></a></li>
	</ul>
</div>