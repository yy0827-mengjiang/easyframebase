<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:switch value="${param.SubField}">
	<e:case value="mainList">
		<c:tablequery>
			SELECT ACCT_MONTH,
			       SUM(VALUE1) V1,
			       SUM(VALUE2) V2,
			       SUM(VALUE3) V3,
			       SUM(VALUE4) V4
			  FROM E_COMPONENT_EXAMPLE
			 GROUP BY ACCT_MONTH
			 ORDER BY ACCT_MONTH
		</c:tablequery>
	</e:case>
	
	<e:case value="ACCT_DAY">
		<c:tablequery>
			SELECT ACCT_DAY DIM,
			       SUM(VALUE1) V1,
			       SUM(VALUE2) V2,
			       SUM(VALUE3) V3,
			       SUM(VALUE4) V4
			  FROM E_COMPONENT_EXAMPLE
			  WHERE ACCT_MONTH=#ACCT_MONTH#
			 GROUP BY ACCT_DAY
			 ORDER BY ACCT_DAY
		</c:tablequery>
	</e:case>
	
	<e:case value="AREA_NO">
		<c:tablequery>
			SELECT AREA_NO DIM,
			       SUM(VALUE1) V1,
			       SUM(VALUE2) V2,
			       SUM(VALUE3) V3,
			       SUM(VALUE4) V4
			  FROM E_COMPONENT_EXAMPLE
			  WHERE ACCT_MONTH=#ACCT_MONTH#
			 GROUP BY AREA_NO
			 ORDER BY AREA_NO
		</c:tablequery>
	</e:case>
	
	<e:case value="CITY_NO">
		<c:tablequery>
			SELECT CITY_NO DIM,
			       SUM(VALUE1) V1,
			       SUM(VALUE2) V2,
			       SUM(VALUE3) V3,
			       SUM(VALUE4) V4
			  FROM E_COMPONENT_EXAMPLE
			  WHERE ACCT_MONTH=#ACCT_MONTH#
			 GROUP BY CITY_NO
			 ORDER BY CITY_NO
		</c:tablequery>
	</e:case>
	
	
	
</e:switch>