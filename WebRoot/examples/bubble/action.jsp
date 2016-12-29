<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4l var="testList">
	select 10 x,80 y,51 z,'济南' extra from dual union 
	select 50 x,66 y,43 z,'青岛' extra from dual union 
	select 60 x,40 y,66 z,'菏泽' extra from dual union 
	select 55 x,77 y,22 z,'枣庄' extra from dual union 
	select 33 x,44 y,88 z,'潍坊' extra from dual union 
	select 66 x,55 y,66 z,'烟台' extra from dual union 
	select 65 x,77 y,22 z,'枣庄' extra from dual union 
	select 33 x,66 y,44 z,'潍坊' extra from dual union 
	select 76 x,55 y,66 z,'烟台' extra from dual
</e:q4l>
[{data:[<e:forEach items="${testList.list}" var="item">
	{x:${item.x}, y:${item.y}, z:${item.z}, extra:'${item.extra}'},
	<e:if condition="${index==3}">
	],name:'多的'},{data:[
	</e:if>
	<e:if condition="${index==6}">
	],name:'少的'},{data:[
	</e:if>
</e:forEach>],name:'一般般'}]