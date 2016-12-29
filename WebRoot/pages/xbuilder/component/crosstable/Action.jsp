<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:switch value="${param.eaction}">
	<e:case value="DataReportList">
		<c:tablequery>
			<e:sql name="xbuilder.component.crossTable.DataReportList"/>
   		</c:tablequery>
	</e:case>
</e:switch>