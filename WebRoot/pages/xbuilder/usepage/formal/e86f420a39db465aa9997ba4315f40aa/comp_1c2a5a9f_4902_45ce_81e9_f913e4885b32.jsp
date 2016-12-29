
<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="cn.com.easy.ebuilder.parser.CommonTools"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir='/WEB-INF/tags/app'%>
<%
boolean isMuti_bill_month=false;
CommonTools commontools_bill_month = new CommonTools();
String isMessyCode_bill_month = request.getParameter("bill_month");
if(isMessyCode_bill_month == null || isMessyCode_bill_month.equals("") || isMessyCode_bill_month.toUpperCase().equals("NULL")){
   isMessyCode_bill_month = request.getAttribute("bill_month") + "";
}
if(isMessyCode_bill_month == null || isMessyCode_bill_month.equals("") || isMessyCode_bill_month.toUpperCase().equals("NULL")){
   isMessyCode_bill_month = "-1".equals(request.getSession().getAttribute("BILL_MONTH"))?"":request.getSession().getAttribute("BILL_MONTH") + "";
}
isMessyCode_bill_month = isMessyCode_bill_month!=null?new String(isMessyCode_bill_month.getBytes("ISO-8859-1"),"UTF-8"):"";
String isMessyCode_bill_month_bill_month = request.getParameter("bill_month");
if(isMessyCode_bill_month_bill_month == null || isMessyCode_bill_month_bill_month.equals("") || isMessyCode_bill_month_bill_month.toUpperCase().equals("NULL")){
   isMessyCode_bill_month_bill_month = request.getAttribute("bill_month") + "";
}
if(isMessyCode_bill_month_bill_month == null || isMessyCode_bill_month_bill_month.equals("") || isMessyCode_bill_month_bill_month.toUpperCase().equals("NULL")){
   isMessyCode_bill_month_bill_month = "-1".equals(request.getSession().getAttribute("BILL_MONTH"))?"":request.getSession().getAttribute("BILL_MONTH") + "";
}
isMessyCode_bill_month_bill_month = isMessyCode_bill_month_bill_month!=null?new String(isMessyCode_bill_month_bill_month.getBytes("ISO-8859-1"),"gb2312"):"";
if(!commontools_bill_month.isMessyCode(isMessyCode_bill_month)){
if(isMuti_bill_month){
String dimvarname = isMessyCode_bill_month;
dimvarname = dimvarname.replaceAll(",", "','");
	request.setAttribute("bill_month",dimvarname);
}else{
	request.setAttribute("bill_month",isMessyCode_bill_month);
}
}
else if(!commontools_bill_month.isMessyCode(isMessyCode_bill_month_bill_month)){
if(isMuti_bill_month){
String dimvarname = isMessyCode_bill_month_bill_month;
dimvarname = dimvarname.replaceAll(",", "','");
	request.setAttribute("bill_month",dimvarname);
}else{
	request.setAttribute("bill_month",isMessyCode_bill_month_bill_month);
}
}
%>
<%
boolean isMuti_cust_manager=false;
CommonTools commontools_cust_manager = new CommonTools();
String isMessyCode_cust_manager = request.getParameter("cust_manager");
if(isMessyCode_cust_manager == null || isMessyCode_cust_manager.equals("") || isMessyCode_cust_manager.toUpperCase().equals("NULL")){
   isMessyCode_cust_manager = request.getAttribute("cust_manager") + "";
}
if(isMessyCode_cust_manager == null || isMessyCode_cust_manager.equals("") || isMessyCode_cust_manager.toUpperCase().equals("NULL")){
   isMessyCode_cust_manager = "-1".equals(request.getSession().getAttribute("CUST_MANAGER"))?"":request.getSession().getAttribute("CUST_MANAGER") + "";
}
isMessyCode_cust_manager = isMessyCode_cust_manager!=null?new String(isMessyCode_cust_manager.getBytes("ISO-8859-1"),"UTF-8"):"";
String isMessyCode_cust_manager_cust_manager = request.getParameter("cust_manager");
if(isMessyCode_cust_manager_cust_manager == null || isMessyCode_cust_manager_cust_manager.equals("") || isMessyCode_cust_manager_cust_manager.toUpperCase().equals("NULL")){
   isMessyCode_cust_manager_cust_manager = request.getAttribute("cust_manager") + "";
}
if(isMessyCode_cust_manager_cust_manager == null || isMessyCode_cust_manager_cust_manager.equals("") || isMessyCode_cust_manager_cust_manager.toUpperCase().equals("NULL")){
   isMessyCode_cust_manager_cust_manager = "-1".equals(request.getSession().getAttribute("CUST_MANAGER"))?"":request.getSession().getAttribute("CUST_MANAGER") + "";
}
isMessyCode_cust_manager_cust_manager = isMessyCode_cust_manager_cust_manager!=null?new String(isMessyCode_cust_manager_cust_manager.getBytes("ISO-8859-1"),"gb2312"):"";
if(!commontools_cust_manager.isMessyCode(isMessyCode_cust_manager)){
if(isMuti_cust_manager){
String dimvarname = isMessyCode_cust_manager;
dimvarname = dimvarname.replaceAll(",", "','");
	request.setAttribute("cust_manager",dimvarname);
}else{
	request.setAttribute("cust_manager",isMessyCode_cust_manager);
}
}
else if(!commontools_cust_manager.isMessyCode(isMessyCode_cust_manager_cust_manager)){
if(isMuti_cust_manager){
String dimvarname = isMessyCode_cust_manager_cust_manager;
dimvarname = dimvarname.replaceAll(",", "','");
	request.setAttribute("cust_manager",dimvarname);
}else{
	request.setAttribute("cust_manager",isMessyCode_cust_manager_cust_manager);
}
}
%>
<e:set var="urlParam" value="&bill_month=${requestScope.bill_month}&cust_manager=${requestScope.cust_manager}&condtype=${param.condtype}"/>
<div>
<c:ncolumn stacking="false" id="1c2a5a9f_4902_45ce_81e9_f913e4885b32" downParams="参数(bill_month)=${requestScope.bill_month},参数(cust_manager)=${requestScope.cust_manager}" title="柱图" url="/pages/xbuilder/usepage/formal/e86f420a39db465aa9997ba4315f40aa/formal_e86f420a39db465aa9997ba4315f40aaAction.jsp?eaction=1c2a5a9f_4902_45ce_81e9_f913e4885b32${urlParam}" width="100%" height="260" dimension="产品名称" legend="true" legendAlign="center" legendValign="bottom" legendLayout="horizontal" yaxis="title:,unit:,color:#000" 当月收入="name:当月收入,yaxis:0,type:column" 上月收入="name:上月收入,yaxis:0,type:column" colors="['#1ea3d5','#d34737','#3b5998','#1ea3d5','#d34737','#3b5998','#1ea3d5','#d34737','#3b5998','#1ea3d5']" />
</div>
