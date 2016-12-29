<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>

<e:q4o var="dateId">
select distinct t.const_value val
  from sys_const_table t
 where t.const_name in ('calendar.maxmonth')
</e:q4o>

<e:q4o var="quryDate">
	select nvl(max(t.const_value), to_char(sysdate - 1, 'yyyymmdd')) const_value  
	from sys_const_table t where t.const_name = 'calendar.curdate' 
	and t.const_type = 'var.dss' 
</e:q4o>
<e:switch value="${param.eaction}">
  <e:case value="all"> 
    <c:tablequery> 
    	SELECT ACCT_DAY,
		       ACCT_MONTH,
		       AREA_NO,
		       CITY_NO,
		       VALUE1,
		       VALUE2,
		       VALUE3,
		       VALUE4,
		       VALUE5
		  FROM E_COMPONENT_EXAMPLE T
		 WHERE 1 = 1
		 <e:if condition="${param.acct_nmonth == null || param.acct_nmonth == ''}">
		   AND T.ACCT_MONTH in(${dateId.val }) 
		 </e:if>
		 <e:if condition="${param.acct_nmonth != null && param.acct_nmonth ne ''}">
		   AND T.ACCT_MONTH IN (${param.acct_nmonth }) 
		 </e:if>
    </c:tablequery>
    
  </e:case>
  <e:case value="all_month"> 
    <c:tablequery> 
    	SELECT ACCT_DAY,
		       ACCT_MONTH,
		       AREA_NO,
		       CITY_NO,
		       VALUE1,
		       VALUE2,
		       VALUE3,
		       VALUE4,
		       VALUE5
		  FROM E_COMPONENT_EXAMPLE T
		 WHERE 1 = 1
		 <e:if condition="${param.acct_month == null || param.acct_month == ''}">
		   AND T.ACCT_MONTH = '${dateId.val }' 
		 </e:if>
		 <e:if condition="${param.acct_month != null && param.acct_month ne ''}">
		   AND T.ACCT_MONTH = '${param.acct_month }' 
		 </e:if>
    </c:tablequery>
    
  </e:case>
</e:switch>
