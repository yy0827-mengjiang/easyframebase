<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<e:style value="resources/themes/base/boncBase@links.css"/>
<e:style value="resources/themes/blue/boncBlue.css"/>
</head>
<body>
<div class="exampleWarp">
	<h1 class="titOne">ls标签</h1>
	<h1 class="titThree"> ls 用于列出目录下的所有文件</h1>
	<div class="lable1"> <img src="<e:url value="/examples/ls/ls.jpg"/>">
		<e:ls var="flies" dir="/examples/ls" suffix=".jsp"/>
		<br/>
		结果：${flies} </div>
</div>
</body>