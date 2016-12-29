<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">
<title>My JSF 'judge.jsp' starting page</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<e:style value="resources/themes/base/boncBase@links.css"/>
<e:style value="resources/themes/blue/boncBlue.css"/>
</head>
<body>
<div class="exampleWarp">
	<h1 class="titOne"> Join函数 </h1>
	<h1 class="titThree"> 将一个给定的数组array用给定的间隔符separator串在一起，组成一个新的字符串并返回 </h1>
	<div class="lable1">
	示例代码<br />
	<img src="<e:url value="/examples/function/join.png"/>"><br />
	 显示结果<br />
	
		<e:set var ="tmpString" value="aa,bb,cc,dd,ee"/>
		<e:set var ="joinString" value="${e:join(e:split(tmpString,','),',')}"/>
		${joinString } <br />
	</div>
</div>
</body>
</html>