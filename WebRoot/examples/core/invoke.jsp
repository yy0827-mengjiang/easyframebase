<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>表格组件实例</title>
		<e:style value="/resources/themes/common/css/examples.css"/>
	</head>
	<body>
	<div class="exampleWarp">
		<h1 class="titOne">调用对象的方法</h1>
		<div class="lable">
			如果调用的方法无返回值，是void类型，那面invoke标签不用添加var属性。反之如果调用的方法有返回值，那么当页面要调用这个返回值时，就应该在invoke标签中添加var属性。
		</div>
		<e:set var="valueList" clazz="java.util.ArrayList" />
		<e:invoke object="${valueList}" method="add">
			<e:param value="数据一" />
		</e:invoke>
		<e:invoke object="${valueList}" method="add">
			<e:param value="数据二" />
		</e:invoke>
		<e:invoke object="${valueList}" method="add">
			<e:param value="数据三" />
		</e:invoke>
		<e:forEach items="${valueList}" var="item">
			${item}<br />
		</e:forEach>
		
		<h1 style="margin-top: 50px">调用静态方法</h1>
		<div style="margin:10px 0;">
			<span style="color: red">
				在cn.com.easy.taglib.function.Functions类中，有个静态方法public static String[] split(String input, String delimiters)，此方法返回一个数组，以参数delimiters为分割符分割参数input，分割后的每一部分就是数组的一个元素。
			</span>
		</div>
		<e:invoke var="valueList2" objectClass="cn.com.easy.taglib.function.Functions" method="split">
			<e:param value="数据一,数据二,数据三" />
			<e:param value="," />
		</e:invoke>
		<e:forEach items="${valueList2}" var="item">
			${item}<br />
		</e:forEach>
	</div>
	</body>
</html>