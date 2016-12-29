<%@ tag body-content="scriptless" import="java.text.SimpleDateFormat,java.util.Calendar,java.util.Date" dynamic-attributes="dynattrs" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<%@ attribute name="bindingtype" required="false" %>		<e:description>动态表头类型（1：与系统常量表绑定，2：与查询条件绑定），默认为1</e:description>
<%@ attribute name="datatype" required="false" %>			<e:description>数据类型（1：日，2：月），默认为1</e:description>
<%@ attribute name="dimsionname" required="false" %>		<e:description>查询条件英文名称，默认为空字符，如acct_day</e:description>
<%@ attribute name="yearstep" required="false" %>			<e:description>年偏移量，整数，默认为0</e:description>
<%@ attribute name="monthstep" required="false" %>			<e:description>月偏移量，整数，默认为0</e:description>
<%@ attribute name="daystep" required="false" %>			<e:description>日偏移量，整数，默认为0</e:description>
<%@ attribute name="prefixstr" required="false" %>			<e:description>前缀，在生成的动态值前面添加的字符串，默认为空字符</e:description>
<%@ attribute name="suffixstr" required="false" %>			<e:description>后缀，在生成的动态值后面添加的字符串，默认为空字符</e:description>
<%

String CONST_TYPE = "var.dss"; //
String MAXMONTH = "calendar.maxmonth";//
String CURDATE = "calendar.curdate";//

%>

<e:set var="const_type" value="<%=CONST_TYPE%>" />
<e:set var="maxmonth" value="<%=MAXMONTH%>" />
<e:set var="curdate" value="<%=CURDATE%>" />

<e:if condition="${bindingtype=='1'}" var="isType" >
	<e:q4o var="objVaue" >
		SELECT t.const_value FROM sys_const_table t WHERE 1=1 and t.const_type = '${const_type}'
		<e:if condition="${datatype=='2'}" var="isDat" >
		and t.const_name = '${maxmonth}'
		</e:if>
		<e:else condition="${isDat }">
		and t.const_name = '${curdate}' 
		</e:else>
	</e:q4o>
	<e:set var="dateValue" scope="request" value="${objVaue.const_value}" />
</e:if>
<e:else condition="${isType }">
	<e:set var="dateValue" scope="request" value="${dimsionname}" />
</e:else>

<e:set var="yearstep" scope="request" value="${yearstep}" />
<e:set var="monthstep" scope="request" value="${monthstep}" />
<e:set var="daystep" scope="request" value="${daystep}" />
<e:set var="datatype" scope="request" value="${datatype}" />
<e:set var="prefixstr" scope="request" value="${prefixstr}" />
<e:set var="suffixstr" scope="request" value="${suffixstr}" />


<%
String datatype = request.getAttribute("datatype")+"";
String dateValue = request.getAttribute("dateValue")+"";
int yearstep = Integer.valueOf(request.getAttribute("yearstep")+"");
int monthstep = Integer.valueOf(request.getAttribute("monthstep")+"");
int daystep = Integer.valueOf(request.getAttribute("daystep")+"");
String prefixstr = "";
String suffixstr = "";
if(!"".equals(request.getAttribute("prefixstr"))&&request.getAttribute("prefixstr")!=null){
	prefixstr = request.getAttribute("prefixstr")+"";
}
if(!"".equals(request.getAttribute("suffixstr"))&&request.getAttribute("suffixstr")!=null){
	suffixstr = request.getAttribute("suffixstr")+"";
}

String dateCalendar = "";
if("1".equals(datatype)){
	dateCalendar="yyyyMMdd";
	if(dateValue.length()==6){
		dateValue += "01";
	}
	
}else if("2".equals(datatype)){
	dateCalendar = "yyyyMM";
	if(dateValue.length()==8){
		dateValue = dateValue.substring(0,6);
	}
}
SimpleDateFormat sdf=new SimpleDateFormat(dateCalendar);
Date dt=sdf.parse(dateValue);
Calendar rightNow = Calendar.getInstance();
rightNow.setTime(dt);
rightNow.add(Calendar.YEAR,yearstep);
if("1".equals(datatype)){
	rightNow.add(Calendar.MONTH,monthstep);
	rightNow.add(Calendar.DAY_OF_YEAR,daystep);
}else if("2".equals(datatype)){
	rightNow.add(Calendar.MONTH,monthstep);
}
Date dt1=rightNow.getTime();
String reStr = sdf.format(dt1);
if(reStr.length()==8){
	reStr=reStr.substring(0,4)+"年"+reStr.substring(4,6)+"月"+reStr.substring(6,8)+"日";
}else if(reStr.length()==6){
	reStr=reStr.substring(0,4)+"年"+reStr.substring(4,6)+"月";
}else if(reStr.length()==4){
	reStr=reStr.substring(0,4)+"年";
}
reStr = prefixstr+reStr+suffixstr;
out.print(reStr);
%>

