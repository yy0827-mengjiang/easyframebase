<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<%
	/*
	 <e:forEach items="${pageContext.request.parameterNames}" var="item">
	 <e:if condition="${e:startsWith(item,'dim_')}">
	 <e:set var="values" value="${paramValues[item]}"/>
	 <e:if condition="${e:length(values)>1}">
	 ${e:replace(item,'dim_','')}=${e:join(values,',')} 
	 </e:if>
	 <e:if condition="${e:length(values)==1}">
	 ${e:replace(item,'dim_','')}=${values[0]} 
	 </e:if>
	 </e:if>
	 </e:forEach>
	 */
%>
<e:q4o var="post" sql="frame.notice.shownotice"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>公告</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<c:resources type="easyui,app" style="${ThemeStyle }" />
		<e:style value="/resources/themes/base/boncBase@links.css"/>
		<script type="text/javascript">
		</script>
	</head>
	<body class="easyui-layout">
    <div data-options="region:'north', border:false" style="height:62px">
    	<div class="contents-head">
    		<h2>${post.TITLE }</h2>
			<div class="search-area">
				<span class="easyui-font-red">时间:${post.BEGIN_DATE } | 发布人:${post.USER_NAME }</span>
				<a href="javascript:history.back();" class="easyui-linkbutton easyui-linkbutton-gray">返  回</a>
			</div>
    	</div>
    </div>
    <div data-options="region:'center', border:false">
    	<p class="easyui-text-normal"> ${e:toString(post.CC) } </p>
    </div>
		
	</body>
</html>
