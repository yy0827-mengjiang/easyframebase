<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:switch value="${param.eaction}">
	<e:case value="loadDim">
		<e:description>加载维度数据</e:description>
		<e:q4l var="dataList">
		<c:treetablesql dimField="all">
				SELECT '-1' C1,
					   '-1' ID,
				       '合计' C2,
				       to_char(nvl(SUM(DEV_USERS),0),'999,999,999') C3,
				       to_char(nvl(SUM(DEV_USERS_LD),0),'999,999,999')  C4,
				       to_char(nvl(SUM(DEV_USERS_ACCU),0),'999,999,999')  C5,
				       TO_CHAR(DECODE(SUM(DEV_USERS_ACCU_LM),0,0,(SUM(DEV_USERS_ACCU)-SUM(DEV_USERS_ACCU_LM))/SUM(DEV_USERS_ACCU_LM)),'FM990.00')||'%' C6,
		               to_char(nvl(SUM(DEV_USERS_ACCU_LM),0),'999,999,999') C61,
		               to_char(nvl(SUM(TOTAL_FEE),0),'999,999,990.00') C7,
		               to_char(nvl(SUM(TOTAL_FEE_LD),0),'999,999,990.00') C8,
		               to_char(nvl(SUM(TOTAL_FEE_ACCT),0),'999,999,990.00') C9,
		               to_char(nvl(SUM(TOTAL_FEE_ACCT_LM),0),'999,999,990.00') C10,
		               TO_CHAR(DECODE(SUM(TOTAL_FEE_ACCT_LM),0,0,(SUM(TOTAL_FEE_ACCT)-SUM(TOTAL_FEE_ACCT_LM))/SUM(TOTAL_FEE_ACCT_LM)),'FM990.00')||'%' C11
				  FROM example_table3 T
				 WHERE T.ACCT_DAY = #acct_day#
				   <e:if condition = "${(param.all!=null) && (param.all!='') && (param.all!='-1')}" >
	           		  AND T.AREA_NO = #all#
				 </e:if>
				 <e:if condition = "${(param.area!=null) && (param.area!='') && (param.area!='-1')}" >
	           		  AND T.AREA_NO = #area#
				 </e:if>
				 <e:if condition = "${(param.city!=null) && (param.city!='') && (param.city!='-1')}" >
	           		  AND T.CITY_NO = #city#
				 </e:if>
		</c:treetablesql>
	
		<c:treetablesql dimField="area">
				SELECT T.AREA_NO C1,
					   T.AREA_NO ID,
				       T.AREA_NO C2,
				       to_char(nvl(SUM(DEV_USERS),0),'999,999,999') C3,
				       to_char(nvl(SUM(DEV_USERS_LD),0),'999,999,999')  C4,
				       to_char(nvl(SUM(DEV_USERS_ACCU),0),'999,999,999')  C5,
				       TO_CHAR(DECODE(SUM(DEV_USERS_ACCU_LM),0,0,(SUM(DEV_USERS_ACCU)-SUM(DEV_USERS_ACCU_LM))/SUM(DEV_USERS_ACCU_LM)),'FM990.00')||'%' C6,
		               to_char(nvl(SUM(DEV_USERS_ACCU_LM),0),'999,999,999') C61,
		               to_char(nvl(SUM(TOTAL_FEE),0),'999,999,990.00') C7,
		               to_char(nvl(SUM(TOTAL_FEE_LD),0),'999,999,990.00') C8,
		               to_char(nvl(SUM(TOTAL_FEE_ACCT),0),'999,999,990.00') C9,
		               to_char(nvl(SUM(TOTAL_FEE_ACCT_LM),0),'999,999,990.00') C10,
		               TO_CHAR(DECODE(SUM(TOTAL_FEE_ACCT_LM),0,0,(SUM(TOTAL_FEE_ACCT)-SUM(TOTAL_FEE_ACCT_LM))/SUM(TOTAL_FEE_ACCT_LM)),'FM990.00')||'%' C11
				  FROM example_table3 T
				 WHERE T.ACCT_DAY = #acct_day#
				  <e:if condition = "${(param.all!=null) && (param.all!='') && (param.all!='-1')}" >
	           		  AND T.AREA_NO = #all#
				 </e:if>
				 <e:if condition = "${(param.area!=null) && (param.area!='') && (param.area!='-1')}" >
	           		  AND T.AREA_NO = #area#
				 </e:if>
				 <e:if condition = "${(param.city!=null) && (param.city!='') && (param.city!='-1')}" >
	           		  AND T.CITY_NO = #city#
				 </e:if>
				 GROUP BY T.AREA_NO
				 ORDER BY T.AREA_NO
		</c:treetablesql>
		
		<c:treetablesql dimField="city">
				SELECT T.city_no C1,
					   T.city_no ID,
				       T.city_no C2,
				       to_char(nvl(SUM(DEV_USERS),0),'999,999,999') C3,
				       to_char(nvl(SUM(DEV_USERS_LD),0),'999,999,999')  C4,
				       to_char(nvl(SUM(DEV_USERS_ACCU),0),'999,999,999')  C5,
				       TO_CHAR(DECODE(SUM(DEV_USERS_ACCU_LM),0,0,(SUM(DEV_USERS_ACCU)-SUM(DEV_USERS_ACCU_LM))/SUM(DEV_USERS_ACCU_LM)),'FM990.00')||'%' C6,
		               to_char(nvl(SUM(DEV_USERS_ACCU_LM),0),'999,999,999') C61,
		               to_char(nvl(SUM(TOTAL_FEE),0),'999,999,990.00') C7,
		               to_char(nvl(SUM(TOTAL_FEE_LD),0),'999,999,990.00') C8,
		               to_char(nvl(SUM(TOTAL_FEE_ACCT),0),'999,999,990.00') C9,
		               to_char(nvl(SUM(TOTAL_FEE_ACCT_LM),0),'999,999,990.00') C10,
		               TO_CHAR(DECODE(SUM(TOTAL_FEE_ACCT_LM),0,0,(SUM(TOTAL_FEE_ACCT)-SUM(TOTAL_FEE_ACCT_LM))/SUM(TOTAL_FEE_ACCT_LM)),'FM990.00')||'%' C11
				  FROM example_table3 T
				 WHERE T.ACCT_DAY = #acct_day#
				 <e:if condition = "${(param.all!=null) && (param.all!='') && (param.all!='-1')}" >
	           		  AND T.AREA_NO = #all#
				 </e:if>
				 <e:if condition = "${(param.area!=null) && (param.area!='') && (param.area!='-1')}" >
	           		  AND T.AREA_NO = #area#
				 </e:if>
				 <e:if condition = "${(param.city!=null) && (param.city!='') && (param.city!='-1')}" >
	           		  AND T.CITY_NO = #city#
				 </e:if>
				 GROUP BY T.city_no
				 ORDER BY T.city_no
		</c:treetablesql>
		</e:q4l>
		${e:replace(e:java2json(dataList.list),'ICONCLS','iconCls')}
	</e:case>
</e:switch>