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
	<h1 class="titOne"> 判断语句语法规则 </h1>
	<h1 class="titThree"> e:if </h1>
	<div class="lable1"> 此标签用于进行条件判断，如果它的condition属性为true，那么就计算它的Body <br />
		示例代码 <br />
		<e:if var="test"condition="${1==2}"> 如果条件成立执行此段代码 </e:if>
		<br />
		<img src="<e:url value="/examples/ejudge/e_if.png"/>"><br />
		显示结果<br />
		空 </div>
	<h1 class="titThree"> e:else </h1>
	<div class="lable1"> 此标签配合if标签使用，当if标签condition属性为false，那么就计算它的Body <br />
		示例代码<br />
		<img src="<e:url value="/examples/ejudge/e_else.png"/>"><br />
		显示结果<br />
		否则执行此段代码<br />
	</div>
	<h1 class="titThree"> e:switch </h1>
	<div class="lable1"> 此标签用于多分支选择，常用来根据表达式的值选择要执行的语句。和e:case配合使用 </div>
	<h1 class="titThree"> e:case </h1>
	<div class="lable1"> 此标签用于分支条件判断, 和e:switch配合使用。如果它的value属性值等于父标签e:switch的value属性值，那么就计算它的Body。<br />
		示例代码<br />
		<img src="<e:url value="/examples/ejudge/e_witch.png"/>" > <br />
		显示结果 <br />
		1、当action 值为 aaa 执行“分支一”<br/>
		2、当action 值为 bbb 执行“分支二”<br/>
		3、当action 值为 ccc 执行“分支三”<br/>
	</div>
</div>
</body>
</html>