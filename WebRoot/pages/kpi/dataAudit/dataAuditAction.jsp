<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:switch value="${param.eaction }">
	<e:case value="query">
			<c:tablequery>
				<e:sql name="kpi.dataAudit.dataQuery"/>
			</c:tablequery>
		</e:case>
		<e:case value="queryData">
			<c:tablequery>
				<e:sql name="kpi.dataAudit.queryData"/>
			</c:tablequery>
		</e:case>
		<e:case value="audit">
			<e:update sql="kpi.dataAudit.audit" />
			<e:if condition="${param.kpi_status==3}">
				<e:update sql="kpi.dataAudit.update3Status"/>
			</e:if>
			<e:if condition="${param.kpi_status==2}">
				<e:update sql="kpi.dataAudit.update2Status"/>
			</e:if>
			${at}
		</e:case>
</e:switch>