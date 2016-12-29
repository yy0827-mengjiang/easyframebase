<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ page import="cn.com.easy.ebuilder.parser.CommonTools"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%
String menuName=request.getParameter("menuName")==null?"":request.getParameter("menuName");
String isMessyCode_menuName = request.getParameter("menuName");

if(isMessyCode_menuName == null || isMessyCode_menuName.equals("") || isMessyCode_menuName.toUpperCase().equals("NULL")){
   isMessyCode_menuName = request.getAttribute("menuName") + "";
}
if(isMessyCode_menuName == null || isMessyCode_menuName.equals("") || isMessyCode_menuName.toUpperCase().equals("NULL")){
   isMessyCode_menuName = request.getSession().getAttribute("menuName") + "";
}
isMessyCode_menuName = isMessyCode_menuName!=null?new String(isMessyCode_menuName.getBytes("ISO-8859-1"),"UTF-8"):"";
String isMessyCode_menuName1 = request.getParameter("menuName");
if(isMessyCode_menuName1 == null || isMessyCode_menuName1.equals("") || isMessyCode_menuName1.toUpperCase().equals("NULL")){
   isMessyCode_menuName1 = request.getAttribute("menuName") + "";
}
if(isMessyCode_menuName1 == null || isMessyCode_menuName1.equals("") || isMessyCode_menuName1.toUpperCase().equals("NULL")){
   isMessyCode_menuName1 = request.getSession().getAttribute("menuName") + "";}
isMessyCode_menuName1 = isMessyCode_menuName1!=null?new String(isMessyCode_menuName1.getBytes("ISO-8859-1"),"gb2312"):"";

if(CommonTools.isMessyCode(menuName)){
	if(!CommonTools.isMessyCode(isMessyCode_menuName)){
		request.setAttribute("menuName",isMessyCode_menuName);
	}
	else if(!CommonTools.isMessyCode(isMessyCode_menuName1)){
		request.setAttribute("menuName",isMessyCode_menuName1);
	}
	
}else{
	
	request.setAttribute("menuName",menuName);
}
%>

<%
String userName=request.getParameter("userName")==null?"":request.getParameter("userName");
String isMessyCode_userName = request.getParameter("userName");

if(isMessyCode_userName == null || isMessyCode_userName.equals("") || isMessyCode_userName.toUpperCase().equals("NULL")){
   isMessyCode_userName = request.getAttribute("userName") + "";
}
if(isMessyCode_userName == null || isMessyCode_userName.equals("") || isMessyCode_userName.toUpperCase().equals("NULL")){
   isMessyCode_userName = request.getSession().getAttribute("userName") + "";
}
isMessyCode_userName = isMessyCode_userName!=null?new String(isMessyCode_userName.getBytes("ISO-8859-1"),"UTF-8"):"";
String isMessyCode_userName1 = request.getParameter("userName");
if(isMessyCode_userName1 == null || isMessyCode_userName1.equals("") || isMessyCode_userName1.toUpperCase().equals("NULL")){
   isMessyCode_userName1 = request.getAttribute("userName") + "";
}
if(isMessyCode_userName1 == null || isMessyCode_userName1.equals("") || isMessyCode_userName1.toUpperCase().equals("NULL")){
   isMessyCode_userName1 = request.getSession().getAttribute("userName") + "";}
isMessyCode_userName1 = isMessyCode_userName1!=null?new String(isMessyCode_userName1.getBytes("ISO-8859-1"),"gb2312"):"";

if(CommonTools.isMessyCode(userName)){
	if(!CommonTools.isMessyCode(isMessyCode_userName)){
		request.setAttribute("userName",isMessyCode_userName);
	}
	else if(!CommonTools.isMessyCode(isMessyCode_userName1)){
		request.setAttribute("userName",isMessyCode_userName1);
	}
	
}else{
	
	request.setAttribute("userName",userName);
}
%>

<e:switch value="${param.eaction}">
	<e:case value="loginLog">
		<c:tablequery>
			<e:sql name="frame.log.loginLog"/>
		</c:tablequery>
	</e:case>
	
	<e:case value="visitLog">
		<c:tablequery>
			<e:sql name="frame.log.visitLog" />
		</c:tablequery>
	</e:case>
	
	<e:case value="visitMenuLog">
		<c:tablequery>
			<e:sql name="frame.log.visitMenuLog"/>
		</c:tablequery>
	</e:case>
	
	<e:case value="operationLog">
		<c:tablequery>
			<e:sql name="frame.log.operationLog"/>
		</c:tablequery>
	</e:case>
	
	<e:case value="userLoginRank">
		<c:tablequery>
			<e:sql name="frame.log.userLoginRank" />
		</c:tablequery>
	</e:case>
	
</e:switch>

