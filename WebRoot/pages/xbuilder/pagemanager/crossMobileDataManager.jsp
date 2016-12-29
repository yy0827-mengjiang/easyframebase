<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="cn.com.easy.ebuilder.parser.CommonTools"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="m" uri="http://www.bonc.com.cn/easy/taglib/m"%>
<%@ taglib prefix="a" tagdir='/WEB-INF/tags/app'%>
<div>
<script language="javascript">
${script}
</script>
<e:if condition="${pcWaterMark eq '1' }" >
	<a:watermark id="${tableid}"/>
</e:if>
<a:mdatagrid id="${tableid}" jsonUrl="${jsonData}" url="" height="${height}" select="row"   >
 ${title }
</a:mdatagrid>
</div>