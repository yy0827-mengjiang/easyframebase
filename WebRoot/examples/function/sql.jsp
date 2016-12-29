<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>
<e:style value="resources/themes/base/boncBase@links.css"/>
<e:style value="resources/themes/blue/boncBlue.css"/>
</head>
<body>
<div class="exampleWarp">
	<h1 class="titOne">sql标签</h1>
	<h1 class="titThree">e:q4l 数据库查询，返回List列表</h1>
	<div class="lable1">
		<img src="<e:url value="/examples/function/q4l.jpg"/>">
		<br/>返回的list：datalist
	</div>
	
	<h1 class="titThree">e:q4o 数据库查询，返回一个Map对象</h1>
	<div class="lable1">
		<img src="<e:url value="/examples/function/q4o.jpg"/>">
		<br/>返回的map：obj，map的key是数据表的字段名，value是字段值
	</div>
	
	
	<h1 class="titThree">e:update 数据库更新，返回int数值(更新的条数)</h1>
	<div class="lable1">
	<img src="<e:url value="/examples/function/update.jpg"/>">
	<br/>
	返回的条数：updateres
	</div>
</div>
</body>