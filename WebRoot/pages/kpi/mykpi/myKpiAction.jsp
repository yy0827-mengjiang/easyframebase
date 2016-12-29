<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:switch value="${param.eaction }">
	<e:case value="query">
		<c:tablequery>
		     SELECT * FROM (
	 			SELECT Y.KPI_KEY       AS V1,
		               Y.KPI_CODE      AS V2,
		               Y.SERVICE_KEY   AS V3,          
		               Y.KPI_NAME      AS V4,
		               TO_CHAR(Y.KPI_VERSION)   AS V5,     
		               X.VIEW_TYPE_NAME     AS V6,
		               Y.KPI_STATUS    AS V7,
		               Y.KPI_CALIBER   AS V8,
		               Y.KPI_EXPLAIN   AS V9,
           			   Y.CUBE_CODE     AS V12,
           			   (SELECT USER_NAME FROM E_USER WHERE USER_ID=Y.CREATE_USER) V13,
				       TO_CHAR(Y.CREATE_DATETIME,'YYYY-MM-DD hh24:mi:ss') V14,
				       (SELECT USER_NAME FROM E_USER WHERE USER_ID=Y.UPDATE_USER) V15,
				       TO_CHAR(Y.UPDATE_DATETIME,'YYYY-MM-DD hh24:mi:ss') V16,
				       '1' AS V19,
				       Z.CUBE_NAME AS V20
		          FROM X_KPI_INFO Y, X_KPI_TYPE X,X_KPI_CUBE Z
		         WHERE Y.KPI_TYPE = X.TYPE_CODE
		           AND Y.CUBE_CODE = Z.CUBE_CODE
		           AND Y.KPI_FLAG != 'D'
 		           AND (Y.KPI_ISCURR ='1' OR Y.KPI_STATUS != '2')
		            <e:if condition="${param.queryFlag == 'user' }">
		           	   <e:if condition="${sessionScope.UserInfo.ADMIN != '1' }">
		  			        AND Y.CREATE_USER = '${sessionScope.UserInfo.USER_ID }'
			           </e:if> 
			        </e:if> 
		            <e:if condition="${param.service_key ne null &&param.service_key ne '' }">
				 		AND UPPER(Y.SERVICE_KEY) LIKE UPPER('%${param.service_key }%')
				   </e:if>
		           <e:if condition="${param.kpi_name ne null &&param.kpi_name ne '' }">
				 		AND UPPER(Y.KPI_NAME) LIKE UPPER('%${param.kpi_name }%')
				   </e:if>
			       <e:if condition="${param.cube_code ne null &&param.cube_code ne ' ' }">
				 		AND Y.CUBE_CODE = '${param.cube_code}'
				   </e:if>
				   <e:if condition="${param.kpi_status ne null &&param.kpi_status ne '' }">
				 		AND Y.KPI_STATUS = '${param.kpi_status}'
				   </e:if>
				   <e:if condition="${param.kpi_category!=0 &&param.kpi_category!=''&&param.kpi_category!=null }">
				  		AND Y.KPI_CATEGORY IN (SELECT X.CATEGORY_ID FROM X_KPI_CATEGORY X START WITH X.CATEGORY_ID=${param.kpi_category } CONNECT BY PRIOR X.CATEGORY_ID = X.CATEGORY_PARENT_ID) 
				  </e:if>
				UNION ALL
					SELECT TO_NUMBER(Y.ID) AS V1,
			               Y.BASE_KEY      AS V2,
			               Y.KPI_CODE      AS V3,          
			               Y.KPI_NAME      AS V4,
			               Y.KPI_VERSION   AS V5,     
			               '基础指标'       AS V6,
			               Y.KPI_STATE    AS V7,
			               Y.KPI_ORIGIN_REGULAR AS V8,
			               Y.KPI_EXPLAIN AS V9,
	           			   Y.CUBE_CODE     AS V12,
	           			   (SELECT USER_NAME FROM E_USER WHERE USER_ID=Y.CREATE_USER_ID) V13,
					       CREATE_TIME V14,
					       (SELECT USER_NAME FROM E_USER WHERE USER_ID=Y.EDIT_USER_ID) V15,
					       EDIT_TIME V16,
					       '2' AS V19,
					       Z.CUBE_NAME AS V20
			          FROM X_BASE_KPI Y,X_KPI_CUBE Z
			          WHERE Y.KPI_STATE = '1'
			           AND Y.CUBE_CODE = Z.CUBE_CODE
			           <e:if condition="${param.queryFlag == 'user' }">
			           	   <e:if condition="${sessionScope.UserInfo.ADMIN != '1' }">
			  			        AND Y.CREATE_USER_ID = '${sessionScope.UserInfo.USER_ID }'
				           </e:if> 
			           </e:if>
			            <e:if condition="${param.service_key ne null &&param.service_key ne '' }">
					 		AND UPPER(Y.KPI_CODE) LIKE UPPER('%${param.service_key }%')
					   </e:if>
			           <e:if condition="${param.kpi_name ne null &&param.kpi_name ne '' }">
					 		AND UPPER(Y.KPI_NAME) LIKE UPPER('%${param.kpi_name }%')
					   </e:if>
				       <e:if condition="${param.cube_code ne null &&param.cube_code ne ' ' }">
					 		AND Y.CUBE_CODE = '${param.cube_code}'
					   </e:if>
					   <e:if condition="${param.kpi_status ne null &&param.kpi_status ne '' }">
					   		<e:if condition="${param.kpi_status == '2' }" var="elsekpiStatus">
					   			AND Y.KPI_STATE = '1'
					   		</e:if>
					   		<e:else condition="${elsekpiStatus }">
					   			AND Y.KPI_STATE = '0'
					   		</e:else>
					   </e:if>
					   <e:if condition="${param.kpi_category!=0 &&param.kpi_category!=''&&param.kpi_category!=null }">
					  		AND Y.KPI_CATEGORY IN (SELECT X.CATEGORY_ID FROM X_KPI_CATEGORY X START WITH X.CATEGORY_ID=${param.kpi_category } CONNECT BY PRIOR X.CATEGORY_ID = X.CATEGORY_PARENT_ID) 
					  </e:if>
				) Y  ORDER BY TO_DATE(Y.V14,'YYYY-MM-DD HH24:MI:SS') DESC
		</c:tablequery>
	</e:case>
	<e:case value="queryAudit">
		<c:tablequery>
			SELECT *
			  FROM (SELECT Y.KPI_KEY       AS V1,
			               Y.KPI_CODE      AS V2,
			               Y.SERVICE_KEY   AS V3,          
			               Y.KPI_NAME      AS V4,
			               Y.KPI_VERSION   AS V5,     
			               X.TYPE_NAME     AS V6,
			               Z.CATEGORY_NAME AS V7,
               			   Y.CUBE_CODE     AS V12
			          FROM X_KPI_INFO_TMP Y, X_KPI_CATEGORY Z, X_KPI_TYPE X
			        WHERE  Y.KPI_STATUS = 3
			           AND Y.KPI_CATEGORY = Z.CATEGORY_ID
			           AND Y.KPI_TYPE = X.TYPE_CODE
			           <e:if condition="${param.kpi_key ne null && param.kpi_key ne '' }">
					 		AND Y.KPI_KEY = '${param.kpi_key }'
					   </e:if>
					   ) A,
			       (SELECT to_char(W.EXAMINE_DATETIME,'YYYY-MM-DD') AS V8,
			               W.KPI_KEY AS V9,
			               W.AUDIT_OPINION AS V10,
			               CASE W.AUDIT_FLAG
			                 WHEN '1' THEN
	                       	 	'指标定义审核'
	                         WHEN '2' THEN
	                        	'指标技术审核'
	                         WHEN '3' THEN
	                        	'指标数据审核'
	                     END AS V11,
                     U.USER_NAME AS V13
                FROM X_KPI_AUDIT W,E_USER U
               WHERE W.AUDIT_RESULT = '3'
               AND W.EXAMINE_USER = U.USER_ID
               ) B
			 WHERE A.V1 = B.V9
			 ORDER BY B.V8
		</c:tablequery>
	</e:case>
	<e:case value="delAudit">
		<e:update var="data">
			begin
				<e:if condition="${param.kpi_status == '2' }">
					UPDATE X_KPI_INFO T SET T.KPI_STATUS='8',T.KPI_FLAG='D',T.EXAMINE_USER='${sessionScope.UserInfo.USER_ID }',EXAMINE_DATETIME=systimestamp WHERE T.KPI_CODE=${param.kpi_code };
				</e:if>		
				UPDATE X_KPI_INFO_TMP T SET T.KPI_STATUS='8',T.KPI_FLAG='D',T.EXAMINE_USER='${sessionScope.UserInfo.USER_ID }',EXAMINE_DATETIME=systimestamp WHERE T.KPI_KEY=${param.kpi_key };
				insert into x_kpi_log
				  (log_key, kpi_key, kpi_code, kpi_version, log_action, log_datetime, log_user, log_userid, log_ip)
				values
				  (X_KPI_LOG_SEQ.Nextval, #${param.kpi_key }#, #${param.kpi_code }#, #${param.kpi_version }#, 'D', systimestamp, #${sessionScope.UserInfo.USER_NAME }#, #${sessionScope.UserInfo.USER_ID }#, #${sessionScope.UserInfo.IP }#);
			end;
		</e:update>
		${e:java2json(data) }
	</e:case>
	<e:case value="audit">
		<c:tablequery>
			SELECT *
			  FROM (SELECT Y.KPI_KEY       AS V1,
			               Y.KPI_CODE      AS V2,
			               Y.SERVICE_KEY   AS V3,          
			               Y.KPI_NAME      AS V4,
			               Y.KPI_VERSION   AS V5,     
			               X.TYPE_NAME     AS V6,
			               Z.CATEGORY_NAME AS V7,
               			   Y.CUBE_CODE     AS V12
			          FROM X_KPI_INFO_TMP Y, X_KPI_CATEGORY Z, X_KPI_TYPE X
			        WHERE Y.KPI_CATEGORY = Z.CATEGORY_ID
			           AND Y.KPI_TYPE = X.TYPE_CODE
			           <e:if condition="${param.kpi_key ne null && param.kpi_key ne '' }">
					 		AND Y.KPI_KEY = '${param.kpi_key }'
					   </e:if>
					   ) A,
			       (SELECT to_char(W.EXAMINE_DATETIME,'YYYY-MM-DD') AS V8,
			               W.KPI_KEY AS V9,
			               W.AUDIT_OPINION AS V10,
			               CASE W.AUDIT_FLAG
			                 WHEN '1' THEN
	                       	 	'指标定义审核'
	                         WHEN '2' THEN
	                        	'指标技术审核'
	                         WHEN '3' THEN
	                        	'指标数据审核'
	                     END AS V11,
	                     CASE W.AUDIT_RESULT
					         WHEN '2' THEN
					          '通过'
					         WHEN '3' THEN
					          '拒绝'
					       END V20,
                     U.USER_NAME AS V13
                FROM X_KPI_AUDIT W,E_USER U
               WHERE W.EXAMINE_USER = U.USER_ID
               ) B
			 WHERE A.V1 = B.V9
			 ORDER BY B.V8
		</c:tablequery>
	</e:case>
</e:switch>