<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:switch value="${param.eaction }">
	<e:case value="query">
		<c:tablequery>
			<%-- SELECT T5.SERVICE_KEY,
			       T5.KPI_NAME,
			       T5.KPI_VERSION,
			       '指标库' SYS_NAME,
			       T1.NAME REPORT_NAME,
			       T1.CREATE_USER,
			       TO_CHAR(T1.CREATE_TIME,'YYYY-MM-DD') CREATE_TIME
			  FROM X_REPORT_INFO  T1,
			       X_META_INFO    T2,
			       X_META_DETAILS T3,
			       X_META_KPI     T4,
			       X_KPI_INFO     T5
			 WHERE T1.ID = T2.REPORT_ID
			   AND T1.ID = T3.REPORT_ID
			   AND T1.ID = T4.REPORT_ID
			   AND T4.KPI_ID = T5.KPI_CODE
			   AND T5.KPI_CODE = '${param.code }'
			   AND T5.KPI_VERSION='${param.version }'
			   <e:if condition="${param.reportName ne '' && param.reportName ne null}">
			   		AND T1.NAME LIKE '%${params.reportName }%'
			   </e:if>
			   <e:if condition="${param.start ne '' && param.start ne null}">
			   		AND T1.CREATE_TIME > TO_DATE('${param.start}','YYYY-MM-DD')
			   </e:if>
			    <e:if condition="${param.end ne '' && param.end ne null}">
			   		AND T1.CREATE_TIME <= TO_DATE('${param.end}','YYYY-MM-DD')
			   </e:if>
			UNION --%>
			SELECT T1.USEAREA_ID,
				   T.SERVICE_KEY,
			       T.KPI_NAME,
			       T.KPI_VERSION,
			       T1.SYS_NAME,
			       T1.REPORT_NAME,
			       T2.USER_NAME CREATE_USER,
			       TO_CHAR(T1.REPORT_CREATE_DATE,'YYYY-MM-DD') CREATE_TIME
			  FROM X_KPI_INFO T, X_KPI_USEAREA T1,E_USER T2
			 WHERE T.KPI_CODE = T1.KPI_CODE
			  	AND T1.REPORT_CREATE_USER = T2.USER_ID
			  AND T1.KPI_CODE = '${param.code }'
			  AND T1.KPI_VERSION='${param.version }'
			   <e:if condition="${param.reportName ne '' && param.reportName ne null}">
			   		AND T1.REPORT_NAME LIKE '%${param.reportName }%'
			   </e:if>
			   <e:if condition="${param.start ne '' && param.start ne null}">
			   		AND T1.REPORT_CREATE_DATE > TO_DATE('${param.start}','YYYY-MM-DD')
			   </e:if>
			    <e:if condition="${param.end ne '' && param.end ne null}">
			   		AND T1.REPORT_CREATE_DATE <= TO_DATE('${param.end}','YYYY-MM-DD')
			   </e:if>
		   </c:tablequery>
	</e:case>
	<e:case value="INSERT">
		<e:update var="data">
			INSERT INTO X_KPI_USEAREA
			  (USEAREA_ID,
			   KPI_CODE,
			   KPI_VERSION,
			   REPORT_NAME,
			   SYS_NAME,
			   REPORT_CREATE_DATE,
			   REPORT_CREATE_USER,
			   KPI_OTHER_CODE)
			VALUES
			  (X_KPI_USEAREA_SEQ.NEXTVAL, '${param.kpi_code }', '${param.kpi_version }', '${param.report_name }', '${param.sys_name }',sysdate,'${UserInfo.USER_ID }','${param.service_key }')
		</e:update>
		${e:java2json(data)}
	</e:case>
	<e:case value="UPDATE">
		<e:update var="data">
			UPDATE X_KPI_USEAREA T
			   SET T.REPORT_NAME = '${param.report_name }', T.SYS_NAME = '${param.sys_name }'
			WHERE T.USEAREA_ID = '${param.usearea_id }'
		</e:update>
		${e:java2json(data)}
	</e:case>
	<e:case value="DELETE">
		<e:update var="data">
			DELETE FROM X_KPI_USEAREA T WHERE T.USEAREA_ID = '${param.usearea_id }'
		</e:update>
		${e:java2json(data)}
	</e:case>
	<e:case value="querylist">
	<c:tablequery>
			SELECT T5.SERVICE_KEY,
			       T5.KPI_NAME,
			       T5.KPI_VERSION,
			       '指标库' SYS_NAME,
			       T1.NAME REPORT_NAME,
			       T1.CREATE_USER,
			       TO_CHAR(T1.CREATE_TIME,'YYYY-MM-DD') CREATE_TIME,
			       '0' OPER
			  FROM X_REPORT_INFO  T1,
			       X_META_INFO    T2,
			       X_META_DETAILS T3,
			       X_META_KPI     T4,
			       X_KPI_INFO     T5
			 WHERE T1.ID = T2.REPORT_ID
			   AND T1.ID = T3.REPORT_ID
			   AND T1.ID = T4.REPORT_ID
			   AND T4.KPI_ID = T5.KPI_CODE
			   AND T5.KPI_CODE = '${param.code }'
			   AND T5.KPI_VERSION='${param.version }'
			   <e:if condition="${param.reportName ne '' && param.reportName ne null}">
			   		AND T1.NAME LIKE '%${params.reportName }%'
			   </e:if>
			   <e:if condition="${param.start ne '' && param.start ne null}">
			   		AND T1.CREATE_TIME > TO_DATE('${param.start}','YYYY-MM-DD')
			   </e:if>
			    <e:if condition="${param.end ne '' && param.end ne null}">
			   		AND T1.CREATE_TIME <= TO_DATE('${param.end}','YYYY-MM-DD')
			   </e:if>
			UNION
			SELECT T.SERVICE_KEY,
			       T.KPI_NAME,
			       T.KPI_VERSION,
			       T1.SYS_NAME,
			       T1.REPORT_NAME,
			       T2.USER_NAME CREATE_USER,
			       TO_CHAR(T1.REPORT_CREATE_DATE,'YYYY-MM-DD') CREATE_TIME,
			       '1' OPER
			  FROM X_KPI_INFO T, X_KPI_USEAREA T1,E_USER T2
			 WHERE T.KPI_CODE = T1.KPI_CODE
			  	AND T1.REPORT_CREATE_USER = T2.USER_ID
			  AND T1.KPI_CODE = '${param.code }'
			  AND T1.KPI_VERSION='${param.version }'
			   <e:if condition="${param.reportName ne '' && param.reportName ne null}">
			   		AND T1.REPORT_NAME LIKE '%${param.reportName }%'
			   </e:if>
			   <e:if condition="${param.start ne '' && param.start ne null}">
			   		AND T1.REPORT_CREATE_DATE > TO_DATE('${param.start}','YYYY-MM-DD')
			   </e:if>
			    <e:if condition="${param.end ne '' && param.end ne null}">
			   		AND T1.REPORT_CREATE_DATE <= TO_DATE('${param.end}','YYYY-MM-DD')
			   </e:if>
		   </c:tablequery>
	</e:case>
</e:switch>