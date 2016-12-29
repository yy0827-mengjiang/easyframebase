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
	<e:case value="LIST">
		<c:tablequery>
			<e:sql name="frame.account.LIST"/>
		</c:tablequery>
	</e:case>
	
	<e:case value="INSERT">
		<e:q4o var="checkE">
			select ACCOUNT_CODE from OCT_ACCOUNT where ACCOUNT_CODE=#account_code#
		</e:q4o>
		<e:if condition="${checkE.ACCOUNT_CODE eq '' || checkE.ACCOUNT_CODE == null }" var="isHave">
			<e:update var="insert" sql="frame.account.INSERT">
			</e:update>${insert }
		</e:if>
		<e:else condition="${isHave }">
			isHave
		</e:else>
	</e:case>
	
	<e:case value="ACCOUNTRELOAD">
		<e:q4l var="getAccount">	
			select ACCOUNT_CODE "account_code_old",ACCOUNT_CODE "account_code_upd", ACCOUNT_NAME "account_name_upd",
				   ACCOUNT_DESC "account_desc_upd" from OCT_ACCOUNT where ACCOUNT_CODE=#account_code#
		</e:q4l>${e:java2json(getAccount.list) }
	</e:case>
	
	<e:case value="UPDATE">
			<e:update var="update" sql="frame.account.UPDATE">
			</e:update>${update}
	</e:case>
	
	<e:case value="DELETE">
		<e:update var="del" transaction="true"  sql="frame.account.DELETE">
		</e:update>${del }
	</e:case>
	
	<e:case value="SHOWLIST">
		<c:tablequery>
		  <e:sql name="frame.account.SHOWLIST" />
		</c:tablequery>
	</e:case>
	
	<e:case value="AccUser">
	   <c:tablequery>
		 <e:sql name="frame.account.AccUser" />
	   </c:tablequery>
	</e:case>
	
	<e:case value="ADDUSER">
		 <e:update var="addUsers" transaction="true" sql="frame.account.ADDUSER">
		</e:update>${addUsers}
	</e:case>
	
	<e:case value="DELUSER">
		<e:update var="res_del_user" sql="frame.account.DELUSER" >
		</e:update>${res_del_user}
	</e:case>
</e:switch>