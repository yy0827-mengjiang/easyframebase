<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="cn.com.easy.ebuilder.parser.CommonTools"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir='/WEB-INF/tags/app'%>
<div>
<script>
${script}
</script>
  <a:xdatagrid id="${tableid}" fitColumns="false" downParams="${downParams}" jsonData="${jsonData}"  pagination="${tablepagi}" alwaysAllowDown="${allowDown}" style="${style}" pageSize="${pageSize}" pageList="${pageList}" download="${download}" mergerFields="${rowsData}"  >
    <thead>
	 ${title }
	</thead>
  </a:xdatagrid>
</div>
