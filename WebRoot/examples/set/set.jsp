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
	<h1 class="titOne"> 变量存储 </h1>
	<h1 class="titThree"> e:set </h1>
	<div class="lable1"> 此标签用于将变量存储至JSP的作用域中。<br />
		示例代码<br />
		变量存储有三种方式，第一种是存储value中的值，第二种是存储clazz指定类实例化的对象，第三种是存储标签体的内容，具体如下<br/>
		1、	存储value属性中的值：<br/>
		<img src="<e:url value="/examples/set/e_set1.png"/>" style="margin: 5px 0 10px 20px;"><br/>
		2、	存储clazz指定类实例化的对象：<br/>
		<img src="<e:url value="/examples/set/e_set2.png"/>" style="margin: 5px 0 10px 20px;"><br/>
		3、	存储标签体的内容：<br/>
		<img src="<e:url value="/examples/set/e_set3.png"/>" style="margin: 5px 0 10px 20px;"><br/>
		<
		显示结果<br />
		1、结果为“回车换行\n”<br/>
		2、结果为LIST对象,并且对其调用<br/>
		3、结果为：“Insert into table values()”<br/>
	</div>
</div>
</body>
</html>