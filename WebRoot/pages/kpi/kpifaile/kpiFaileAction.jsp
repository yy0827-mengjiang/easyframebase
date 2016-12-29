<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:switch value="${param.eaction }">
	<e:case value="query">
		<c:tablequery>
			<e:sql name="kpi.kpiFaile.query"/>
		</c:tablequery>
	</e:case>
	<e:case value="queryAudit">
		<c:tablequery>
			<e:sql name="kpi.kpiFaile.queryAudit"/>
		</c:tablequery>
	</e:case>
	<e:case value="delAudit">
		<e:update var="data" sql="kpi.kpiFaile.delAudit">
		</e:update>
		${e:java2json(data) }
	</e:case>
	<e:case value="audit">
		<c:tablequery>
			<e:sql name="kpi.kpiFaile.audit"/>
		</c:tablequery>
	</e:case>
</e:switch>