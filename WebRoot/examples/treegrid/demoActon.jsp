<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:switch value="${param.eaction}">
	<e:case value="loadDim">
		<c:treegridquery dimField="all">
			select '合计' V0, '-1' ID, sum(VALUE1) V1,sum(VALUE2) V2,sum(VALUE3) V3 from E_COMPONENT_EXAMPLE t where t.acct_day='20140102'
		</c:treegridquery>
		
		<c:treegridquery dimField="area">
			select t.area_no V0, t.area_no ID,sum(VALUE1) V1,sum(VALUE2) V2,sum(VALUE3) V3 from E_COMPONENT_EXAMPLE t where 1=1
			<e:if condition="${param.area ne '' && param.area != null}">
			and t.area_no='${param.area}'
			</e:if>
			<e:if condition="${param.day ne '' && param.day != null}">
			and t.acct_day='${param.day}'
			</e:if>
			group by t.area_no order by t.area_no
		</c:treegridquery>
		
		<c:treegridquery dimField="city">
			select t.city_no V0, t.city_no ID,sum(VALUE1) V1,sum(VALUE2) V2,sum(VALUE3) V3 from E_COMPONENT_EXAMPLE t where 1=1
			<e:if condition="${param.area ne '' && param.area != null}">
			and t.area_no='${param.area}'
			</e:if>
			<e:if condition="${param.city ne '' && param.city != null}">
			and t.city_no='${param.city}'
			</e:if>
			<e:if condition="${param.day ne '' && param.day != null}">
			and t.acct_day='${param.day}'
			</e:if>
			group by t.city_no order by t.city_no
		</c:treegridquery>
		
		<c:treegridquery dimField="day">
			select t.acct_day V0, t.acct_day ID,sum(VALUE1) V1,sum(VALUE2) V2,sum(VALUE3) V3 from E_COMPONENT_EXAMPLE t where t.acct_day like '201402%' and t.acct_day <= '20140210'
			<e:if condition="${param.area ne '' && param.area != null}">
			and t.area_no='${param.area}'
			</e:if>
			<e:if condition="${param.city ne '' && param.city != null}">
			and t.city_no='${param.city}'
			</e:if>
			group by t.acct_day order by t.acct_day
		</c:treegridquery>
	</e:case>
</e:switch>