<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="cn.com.easy.ebuilder.parser.CommonTools"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="m" uri="http://www.bonc.com.cn/easy/taglib/m"%>
<e:if condition="${pcWaterMark eq '1' }" >
	<a:watermark id="${tableid}"/>
</e:if>
<div id="${tableid}"></div>
<script type="text/javascript" charset="utf-8">
	${script}
	
	var jsonData = ${jsonData};
	webix.ready(function(){
		grida = webix.ui({
			container:"${tableid}",
			view:"treetable",
			columns:[
				{ id:"${rowsData}",header:"${rowsData}",	width:250,template:"{common.treetable()} #value#" },
				${columns}
			],
			autoheight:true,
			autowidth:true,
			data: jsonData.rows
		});	
	});
</script>