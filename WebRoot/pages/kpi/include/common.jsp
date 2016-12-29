<%@ page language="java" import="java.util.*,java.text.*" pageEncoding="UTF-8"%>
<%
String sysCode= getCode();
request.setAttribute("sysCode", sysCode);
%>
<%!
public static String getCode() {
	TimeZone tz = TimeZone.getTimeZone("Asia/Shanghai"); 
	TimeZone.setDefault(tz);
	Date date = new Date();
	Format format = new SimpleDateFormat("yyyyMMddHHmmssSSS",Locale.CHINA);
	String code = format.format(date); 
	return code;
}
%>