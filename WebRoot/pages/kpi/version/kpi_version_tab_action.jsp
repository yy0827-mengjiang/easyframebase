<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:switch value="${param.action}">
	<e:case value="list">
		<c:tablequery>
			<%-- SELECT T.KPI_NAME V1,
			       T.KPI_CATEGORY V2,
			       T.KPI_NUIT V3,
			       T.KPI_VERSION V4,
			       T.KPI_ISCURR V5,
			       T.KPI_CALIBER V6,
			       T.KPI_EXPLAIN V7,
			       DECODE(T.KPI_FLAG,'I','新增','U','修改','D','删除') V8,
			       DECODE(T.KPI_STATUS,'0','待发布','1','待审核','2','审核通过','3','审核未通过','4','编辑模式') V9,
			       T.CREATE_USER V10,
			       T.KPI_CODE V11,
			       T.KPI_KEY V12
			  FROM X_KPI_INFO_TMP T
			WHERE T.KPI_CODE='${param.kpi_code}' AND T.KPI_ISCURR='0' AND t.KPI_STATUS='2' --%>
			SELECT Z.V1,Z.V2,Z.V3,Z.V4,Z.V5,Z.V6,Z.V7,Z.V8,Z.V9,Z.V10,Z.V11,Z.V12 FROM(
					SELECT T.KPI_NAME V1,
					       T.KPI_CATEGORY V2,
					       T.KPI_NUIT V3,
					       T.KPI_VERSION V4,
					       T.KPI_ISCURR V5,
					       T.KPI_CALIBER V6,
					       T.KPI_EXPLAIN V7,
					       DECODE(T.KPI_FLAG,'I','新增','U','修改','D','删除') V8,
		      		 DECODE(T.KPI_STATUS,'0','指标定义审核中','1','技术规范审核中','2','审核通过','3','审核未通过','4','编辑模式','9','数据审核中') V9,
		             T.CREATE_USER V10,
		             T.KPI_CODE V11,
		             T.KPI_KEY V12
		        FROM X_KPI_INFO_TMP T
		      WHERE T.KPI_CODE='${param.kpi_code }' AND T.KPI_ISCURR='1'
		      UNION
		      SELECT T.KPI_NAME V1,
		             T.KPI_CATEGORY V2,
		             T.KPI_NUIT V3,
		             T.KPI_VERSION V4,
		             T.KPI_ISCURR V5,
		             T.KPI_CALIBER V6,
		             T.KPI_EXPLAIN V7,
		             DECODE(T.KPI_FLAG,'I','新增','U','修改','D','删除') V8,
		      		 DECODE(T.KPI_STATUS,'0','指标定义审核中','1','技术规范审核中','2','审核通过','3','审核未通过','4','编辑模式','9','数据审核中') V9,
		             T.CREATE_USER V10,
		             T.KPI_CODE V11,
		             T.KPI_KEY V12
		        FROM X_KPI_INFO_TMP T
		      WHERE T.KPI_CODE='${param.kpi_code }' AND T.KPI_ISCURR='0' AND (t.KPI_STATUS='2' OR t.KPI_STATUS='8') ) Z ORDER BY Z.V4 DESC
		</c:tablequery>
	</e:case>
	<e:case value="pub">
		<e:update var="pb">
			begin 
				UPDATE X_KPI_INFO_TMP SET KPI_ISCURR='0',KPI_STATUS='1' WHERE KPI_KEY='${param.kpi_key}';
			end;
		</e:update>${pb}
	</e:case>
</e:switch>
