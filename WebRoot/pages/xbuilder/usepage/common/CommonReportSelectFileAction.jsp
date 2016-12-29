<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:switch value="${param.eaction}">
	<e:case value="LIST">
		<c:tablequery>
		SELECT LOG_ID, FILE_PATH, to_char(UPLOAD_DATE,'YYYY-MM-DD hh24:mi:ss') UPLOAD_DATE, UPLOAD_USER, REPORT_ID,FILE_NAME,FILE_FACT_NAME,FIELD_NAME
		  FROM X_REPORT_UPLOAD_DATA_LOG T
		   WHERE T.REPORT_ID = #reportId#
   			AND T.UPLOAD_USER = '${sessionScope.UserInfo.USER_ID}'
   			AND T.FIELD_NAME = '${param.fieldName}'
		ORDER BY UPLOAD_DATE DESC
   		</c:tablequery>
	</e:case>
</e:switch>
