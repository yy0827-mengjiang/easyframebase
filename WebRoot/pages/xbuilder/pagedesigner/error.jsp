<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>错误页面</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<meta http-equiv="X-UA-Compatible" content="IE=11;IE=10;IE=9;" />
		<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
	</head>
	<body class="errorBox">
			<div>
				<p>${sessionScope.ErrorMessage}</p>
				<a href="javscript:void(0)" onclick="window.close()">关闭返回</a>
			</div>
			
	</body>
</html>