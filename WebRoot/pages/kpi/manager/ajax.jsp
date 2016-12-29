<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@page import="java.io.File"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:switch value="${param.eaction}">
	<e:case value="name">
		<e:q4o var="co">
			SELECT COUNT(*) C FROM X_KPI_INFO_TMP T WHERE T.KPI_STATUS<>'D' AND T.KPI_ISCURR='1' AND T.KPI_NAME='${param.name }'
		</e:q4o>
		${e:java2json(co) }
	</e:case>
</e:switch>