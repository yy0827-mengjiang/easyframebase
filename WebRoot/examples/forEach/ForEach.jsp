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
	<h1 class="titOne"> 循环语句语法规则 </h1>
	<h1 class="titThree"> e:forEach </h1>
	<div class="lable1"> 此标签用于迭代操作<br />
		示例代码 <br />
		e:forEach标签有一个子标签e:break，用来终止循环，注意终止是从下次循环开始，并不终止此次循环。user_list 为LIST对象。 <br />
		<img src="<e:url value="/examples/forEach/e_forEach.png"/>"><br />
		迭代对象dynattrs为Map类型，那么Map对象中的每个键值对将转换成一个名为dynattr的对象，键名将存放在dynattr的key中，键值将存放在dynattr的value中。<br />
		<img src="<e:url value="/examples/forEach/e_forEach2.png"/>"><br />
		<e:forEach items="${dynattrs}" var="dynattr"> ${dynattr.key}="${dynattr.value}" </e:forEach>
	</div>
</div>
</body>
</html>