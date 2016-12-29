<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="cn.com.easy.ebuilder.parser.CommonTools"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>

<%
String role_name=request.getParameter("role_name")==null?"":request.getParameter("role_name");
String isMessyCode_role_name = request.getParameter("role_name");

if(isMessyCode_role_name == null || isMessyCode_role_name.equals("") || isMessyCode_role_name.toUpperCase().equals("NULL")){
   isMessyCode_role_name = request.getAttribute("role_name") + "";
}
if(isMessyCode_role_name == null || isMessyCode_role_name.equals("") || isMessyCode_role_name.toUpperCase().equals("NULL")){
   isMessyCode_role_name = request.getSession().getAttribute("role_name") + "";
}
isMessyCode_role_name = isMessyCode_role_name!=null?new String(isMessyCode_role_name.getBytes("ISO-8859-1"),"UTF-8"):"";
String isMessyCode_role_name1 = request.getParameter("role_name");
if(isMessyCode_role_name1 == null || isMessyCode_role_name1.equals("") || isMessyCode_role_name1.toUpperCase().equals("NULL")){
   isMessyCode_role_name1 = request.getAttribute("role_name") + "";
}
if(isMessyCode_role_name1 == null || isMessyCode_role_name1.equals("") || isMessyCode_role_name1.toUpperCase().equals("NULL")){
   isMessyCode_role_name1 = request.getSession().getAttribute("role_name") + "";}
isMessyCode_role_name1 = isMessyCode_role_name1!=null?new String(isMessyCode_role_name1.getBytes("ISO-8859-1"),"gb2312"):"";

if(CommonTools.isMessyCode(role_name)){
	if(!CommonTools.isMessyCode(isMessyCode_role_name)){
		request.setAttribute("role_name",isMessyCode_role_name);
	}
	else if(!CommonTools.isMessyCode(isMessyCode_role_name1)){
		request.setAttribute("role_name",isMessyCode_role_name1);
	}
	
}else{
	
	request.setAttribute("role_name",role_name);
}
%>

<e:switch value="${param.eaction}">
	
		<e:case value="ROLELIST">
		<c:tablequery>
			<e:sql name="frame.role.list"/>
		</c:tablequery>
	</e:case>
	
</e:switch>