<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="org.springframework.web.util.*" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%
//页面查询条件汉字转换编码


//获取子系统URL中的IP地址

String subsystemIp = "";
String subsystemAddress = request.getParameter("subsystemAddress");
if(subsystemAddress!=null&&subsystemAddress!=""){
	java.util.regex.Matcher m = java.util.regex.Pattern.compile("(\\d{1,3})[.](\\d{1,3})[.](\\d{1,3})[.](\\d{1,3})").matcher(subsystemAddress);
	if (m.find()){
		subsystemIp = m.group();
	}else{
		subsystemIp = "";
	}
	request.setAttribute("subsystemIp",subsystemIp);
}

String subsystemIp2 = "";
String subsystemAddress2 = request.getParameter("subsystemAddress2");
if(subsystemAddress2!=null&&subsystemAddress2!=""){
	java.util.regex.Matcher m = java.util.regex.Pattern.compile("(\\d{1,3})[.](\\d{1,3})[.](\\d{1,3})[.](\\d{1,3})").matcher(subsystemAddress2);
	if (m.find()){
		subsystemIp2 = m.group();
	}else{
		subsystemIp2 = "";
	}
	request.setAttribute("subsystemIp2",subsystemIp2);
}

%>
<e:switch value="${param.eaction}">
	<e:case value="list">
		<c:tablequery>
			<e:sql name="frame.subsystem.list"/>
		</c:tablequery>
	</e:case>
	<e:case value="add">
		<e:q4o var="loginIdSum">
			SELECT COUNT(1) C FROM D_SUBSYSTEM WHERE SUBSYSTEM_ID = #subsystemId#
		</e:q4o>
		<e:if condition="${loginIdSum.c eq 0 || loginIdSum.c eq'0'}" var="isHaveLoginId">
			<e:update transaction="true" sql="frame.subsystem.add" />
		</e:if>
		<e:else condition="${isHaveLoginId}">HAVINGLOGINID</e:else>
	</e:case>
	<e:case value="edit">
		<e:update transaction="true" sql="frame.subsystem.edit" />
	</e:case>
	<e:case value="delete">
		<e:update>
				DELETE from D_SUBSYSTEM WHERE SUBSYSTEM_ID = '${param.subsystemId}'
		</e:update>
	</e:case>
	
</e:switch>