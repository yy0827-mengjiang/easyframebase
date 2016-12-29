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
	<h1 class="titOne">json函数</h1>
	<h1 class="titThree"> e:java2json 将java对象转化为json字符串，并返回</h1>
	<div class="lable1">
		<img src="<e:url value="/examples/function/code1.jpg"/>">
		<e:q4l var="datalist">
			select '合计' V0, '' ID, sum(VALUE1) V1,sum(VALUE2) V2,sum(VALUE3) V3 from E_COMPONENT_EXAMPLE t where t.acct_day='20140102'
		</e:q4l>
		<br/><br/>转化的json为：<br/>
		${e:java2json(datalist.list)}
		
		<e:set var="jsondata" value="${e:java2json(datalist.list)}"/>
	</div>
	<h1 class="titThree">e:json2java 将json字符串，转化为java对象</h1>
	<div class="lable1">
		<img src="<e:url value="/examples/function/code2.jpg"/>"><br/>
		输出的java对象值为：<br/>
		<e:forEach items="${e:json2java(jsondata)}" var="item">
			获得V0的值：${item.V0}<br/>
			获得V1的值：${item.V1}<br/>
			获得V2的值：${item.V2}<br/>
		</e:forEach>
	</div>
</div>
</body>