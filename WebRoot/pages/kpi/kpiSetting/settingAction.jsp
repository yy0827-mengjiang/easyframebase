<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:switch value="${param.eaction }">
	<e:case value="querySetting">
		<c:tablequery>
			<e:sql name="kpi.setting.querySetting"/>
		</c:tablequery>
	</e:case>
	<e:case value="status">
		<e:update var="data" sql="kpi.setting.status">
		</e:update>
		${data }
	</e:case>
	<e:case value="queryData">
		<e:q4o var="type" sql="kpi.setting.queryData">
		</e:q4o>
		${e:java2json(type) }
	</e:case>
	<e:case value="settingupdate">
		<e:update var="data" sql="kpi.setting.settingupdate">
		</e:update>
		${data }
	</e:case>
	<e:case value="formulaInfo">
		<c:tablequery>
			<e:sql name="kpi.setting.formulaInfo"/>
		</c:tablequery>
	</e:case>
	<e:case value="delFormula">
		<e:update var="data" sql="kpi.setting.delFormula">
		</e:update>
		${e:java2json(data)}
	</e:case>
</e:switch>