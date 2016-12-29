<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<% System.out.println(request.getParameter("eaction")); %>
<e:switch value="${param.eaction}">
	<e:case value="default">
		<c:tablequery>
		SELECT CITY_NO, SUM(VALUE1)VALUE1, SUM(VALUE2)VALUE2, SUM(VALUE3)VALUE3, SUM(VALUE4)VALUE4, SUM(VALUE5)VALUE5
		  FROM E_COMPONENT_EXAMPLE T WHERE ROWNUM<21
		 GROUP BY CITY_NO
		 ORDER BY CITY_NO
		</c:tablequery>
	</e:case>
	<e:case value="all">
		<c:tablequery>
		SELECT t.ACCT_HOUR||'时' ACCT_DATE,
		       T.AREA_NO,
		       T.AREA_NAME,
		       SUM(T.TARGET_VALUE) TARGET_VALUE
		  FROM M_YXIN_H_IMPORTANT_POINT T
		 WHERE T.TARGET_ID = 'YD01'
		   AND T.AREA_NO IS NOT NULL
		 GROUP BY t.ACCT_HOUR , T.AREA_NO, T.AREA_NAME
		 ORDER BY t.ACCT_HOUR

		</c:tablequery>
	</e:case>

</e:switch>

