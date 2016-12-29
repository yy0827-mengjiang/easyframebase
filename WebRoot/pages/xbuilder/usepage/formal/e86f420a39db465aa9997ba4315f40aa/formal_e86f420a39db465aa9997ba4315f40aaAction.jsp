<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="cn.com.easy.ebuilder.parser.CommonTools"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="m" uri="http://www.bonc.com.cn/easy/taglib/m" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
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

<e:switch value="${param.eaction}">
  <e:case value="5cc5cfe3_b131_4977_8f14_cf605497bbf9">
    <e:description>收入数据集</e:description>
    <c:tablequery  >
       SELECT "产品名称",SUM(当月收入) as "当月收入",SUM(上月收入) as "上月收入",SUM(去年同月收入) as "去年同月收入" FROM (SELECT bill_month, bw_data_type AS "收入来源类型", bw_data_desc AS "收入来源描述", prod_spec_code AS "产品编码", prod_spec_desc AS "产品名称", chrg_item_catgy_id AS "科目编码", chrg_item_catgy_desc AS "科目名称", cust_code AS "客户编码", cust_name AS "客户名称", root_cust_code AS "根客户编码", root_cust_name AS "根客户名称", cust_manager AS "客户经理", income_thismon/1000000 AS "当月收入", income_lastmon/1000000 AS "上月收入", income_lastyear/1000000 AS "去年同月收入", income_accu_thyr/1000000 AS "当年累计收入", income_accu_layr/1000000 AS "去年同期累计收入", area_id, area_name AS "地址点", adm_branch AS "行政分局", key_cust FROM t_xm_cust_income_month t WHERE 1 = 1 
      <e:if condition="${(((param.bill_month != null)&&(e:trim(param.bill_month) != '')&&(param.bill_month != 'null'))||((bill_month != null)&&(e:trim(bill_month) != '')&&(bill_month != 'null')))}" var="elsev1">
        AND bill_month = #bill_month#
      </e:if>
       
      <e:if condition="${(((param.cust_manager != null)&&(e:trim(param.cust_manager) != '')&&(param.cust_manager != 'null'))||((cust_manager != null)&&(e:trim(cust_manager) != '')&&(cust_manager != 'null')))}" var="elsev3">
        AND cust_manager = #cust_manager#
      </e:if>
      ) inits GROUP BY "产品名称"
    </c:tablequery>
  </e:case>
  <e:case value="1c2a5a9f_4902_45ce_81e9_f913e4885b32">
    <e:description>收入数据集</e:description>
    <e:q4l var="L1c2a5a9f_4902_45ce_81e9_f913e4885b32" >
       SELECT 产品名称, SUM(当月收入) as 当月收入, SUM(上月收入) as 上月收入 FROM (SELECT bill_month, bw_data_type AS "收入来源类型", bw_data_desc AS "收入来源描述", prod_spec_code AS "产品编码", prod_spec_desc AS "产品名称", chrg_item_catgy_id AS "科目编码", chrg_item_catgy_desc AS "科目名称", cust_code AS "客户编码", cust_name AS "客户名称", root_cust_code AS "根客户编码", root_cust_name AS "根客户名称", cust_manager AS "客户经理", income_thismon/1000000 AS "当月收入", income_lastmon/1000000 AS "上月收入", income_lastyear/1000000 AS "去年同月收入", income_accu_thyr/1000000 AS "当年累计收入", income_accu_layr/1000000 AS "去年同期累计收入", area_id, area_name AS "地址点", adm_branch AS "行政分局", key_cust FROM t_xm_cust_income_month t WHERE 1 = 1 
      <e:if condition="${(((param.bill_month != null)&&(e:trim(param.bill_month) != '')&&(param.bill_month != 'null'))||((bill_month != null)&&(e:trim(bill_month) != '')&&(bill_month != 'null')))}" var="elsev1">
        AND bill_month = #bill_month#
      </e:if>
       
      <e:if condition="${(((param.cust_manager != null)&&(e:trim(param.cust_manager) != '')&&(param.cust_manager != 'null'))||((cust_manager != null)&&(e:trim(cust_manager) != '')&&(cust_manager != 'null')))}" var="elsev3">
        AND cust_manager = #cust_manager#
      </e:if>
      ) ct  GROUP BY 产品编码,产品名称 ORDER BY 产品编码 asc
    </e:q4l>${e:java2json(L1c2a5a9f_4902_45ce_81e9_f913e4885b32.list)}
  </e:case>
</e:switch>
