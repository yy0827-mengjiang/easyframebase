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
	<h1 class="titOne">其他函数</h1>
	<h1 class="titThree">e:replace(string, before, after)</h1>
	<div class="lable1"> <img src="<e:url value="/examples/function/replace.jpg"/>"> <br>
		返回一个String对象。用参数after字符串替换参数string中所有出现参数before字符串的地方，并返回替换后的结果 <br>
		列子：${e:replace('abcde','c','cc')} </div>
	<h1 class="titThree">e:startsWith(string, prefix)</h1>
	<div class="lable1"> <img src="<e:url value="/examples/function/startwith.jpg"/>"> <br>
		如果参数string以参数prefix开头，返回true <br>
		列子：${e:startsWith('abcde', 'abc')} </div>
	<h1 class="titThree">e:substring(string, begin, end)</h1>
	<div class="lable1"> <img src="<e:url value="/examples/function/substring.jpg"/>"> <br>
		返回参数string部分字符串, 从参数begin开始到参数end位置，包括end位置的字符 <br>
		列子：${e:substring('abcdefg', 2, 5)} </div>
	<h1 class="titThree">e:toLowerCase(string)</h1>
	<div class="lable1"> <img src="<e:url value="/examples/function/tolowercase.jpg"/>"> <br>
		将参数string所有的字符变为小写，并将其返回 <br>
		列子：${e:toLowerCase('aBCDe')} </div>
	<h1 class="titThree">e:toUpperCase(string)</h1>
	<div class="lable1"> <img src="<e:url value="/examples/function/touppercase.jpg"/>"> <br>
		将参数string所有的字符变为大写，并将其返回 <br>
		列子：${e:toUpperCase('aBCDe')} </div>
	<h1 class="titThree">e:trim(string)</h1>
	<div class="lable1"> <img src="<e:url value="/examples/function/trim.jpg"/>"> <br>
		去除参数string 首尾的空格，并将其返回 <br>
		列子：${e:trim(' abcde ')} </div>
	<h1 class="titThree">e:getDate(string)</h1>
	<div class="lable1"> <img src="<e:url value="/examples/function/getdate.jpg"/>"> <br>
		返回参数format格式的时间 <br>
		列子：${e:getDate('yyyyMMddHHmmss')} </div>
</div>
</body>
