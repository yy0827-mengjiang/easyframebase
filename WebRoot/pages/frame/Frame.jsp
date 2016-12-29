<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%
 	String SysMenuType=(String)request.getSession().getServletContext().getAttribute("SysMenuType");
	String isIE8="0";//是否强制为ie8浏览器
	if("float".equals(SysMenuType.trim())){
	%>
		<jsp:include page="/pages/frame/Frame_float.jsp" flush="true">
			<jsp:param name="isIE8" value="<%=isIE8%>"/>
		</jsp:include>
	<%	
	}else if("tree".equals(SysMenuType.trim())){
	%>
		<jsp:include page="/pages/frame/Frame_tree.jsp" flush="true">
			<jsp:param name="isIE8" value="<%=isIE8%>"/>
		</jsp:include>
	<%		
	}else if("dropdown".equals(SysMenuType.trim())){
	%>
		<jsp:include page="/pages/frame/Frame_dropdown.jsp" flush="true">
			<jsp:param name="isIE8" value="<%=isIE8%>"/>
		</jsp:include>
	<%		
	}else if("bootstrap".equals(SysMenuType.trim())){
		
		%>
			<jsp:include page="/pages/frame/Frame_bs.jsp" flush="true">
				<jsp:param name="isIE8" value="<%=isIE8%>"/>
			</jsp:include>
		<%
	}else if("pg".equals(SysMenuType.trim())){
		
		%>
			<jsp:include page="/pages/frame/Frame_pg.jsp" flush="true">
				<jsp:param name="isIE8" value="<%=isIE8%>"/>
			</jsp:include>
		<%
	}
%>