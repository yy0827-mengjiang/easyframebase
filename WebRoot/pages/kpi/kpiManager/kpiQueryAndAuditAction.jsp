<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<%
	//内蒙更新要把注释打开
	String audit_flag = (String)request.getParameter("audit_flag");
	if("2".equals(audit_flag)) {
		String kpiId = (String) request.getParameter("kpiId");
		//cn.com.easy.kpi.parser.GenerateKpiRule kpiRule = new cn.com.easy.kpi.parser.GenerateKpiRule(kpiId);
		String sql = "";//kpiRule.parseKpi();
		String rule_column = "";//kpiRule.parseExpression();
		String formula_column = "";//kpiRule.parseFormulas();
		String user_table = "";//kpiRule.getUseTables();
		request.setAttribute("kpi_sql", sql);
		request.setAttribute("rule_column", rule_column);
		request.setAttribute("formula_column", formula_column);
		request.setAttribute("user_table", user_table);
	}
%>
<e:switch value="${param.eaction}">
	<e:case value="query">
		<e:if condition="${param.kpi_category!=0&&param.kpi_category!=''&&param.kpi_category!=null }">
			<e:q4l var="CATEGORY_ID">
				WITH N (CATEGORY_ID, CATEGORY_PARENT_ID, CUBE_CODE)
				     AS (SELECT CATEGORY_ID, CATEGORY_PARENT_ID, CUBE_CODE
				           FROM X_KPI_CATEGORY
				          WHERE CATEGORY_ID = #kpi_category#
				         UNION ALL
				         SELECT X.CATEGORY_ID, X.CATEGORY_PARENT_ID, X.CUBE_CODE
				           FROM X_KPI_CATEGORY X, N
				          WHERE X.CATEGORY_PARENT_ID = N.CATEGORY_ID)
				SELECT CATEGORY_ID
				  FROM (SELECT CATEGORY_ID FROM N)
			</e:q4l>
		</e:if>
		<c:tablequery>
			SELECT 
				   T.KPI_KEY AS "V0",
				   T.KPI_CODE AS "V1",
			       T.KPI_NAME AS "V2",
			       T.KPI_CATEGORY AS "V3",
			       T.KPI_NUIT AS "V4",
			       T.KPI_VERSION AS "V5",
			       T.ACCTTYPE AS "V55",
			       CASE T.KPI_ISCURR
			       WHEN '1' THEN '是'
			       WHEN '0' THEN '否'
			       END AS "V6",
			       T.KPI_CALIBER AS "V7",
			       T.KPI_EXPLAIN AS "V8",
			       CASE T.KPI_FLAG
			       WHEN 'I' THEN '新增'
			       WHEN 'U' THEN '修改'
			       WHEN 'D' THEN '下线'
			       END AS "V9",
			       CASE T.KPI_STATUS
			       WHEN '0' THEN '指标定义审核中'
			       WHEN '1' THEN '指标技术审核中'
			       WHEN '2' THEN '审核通过'
			       WHEN '3' THEN '审核未通过'
			       WHEN '4' THEN '编辑模式'
			       WHEN '9' THEN '指标数据审核中'
			       END AS "V10",
			       TT.CATEGORY_NAME AS "V11",
			       (SELECT USER_NAME FROM E_USER WHERE USER_ID=T.CREATE_USER) AS "V12",
			       CONCAT(CONCAT(CAST(T.CREATE_DATETIME AS DATE),' '),CAST(T.CREATE_DATETIME AS TIME)) AS "V13",
			       (SELECT USER_NAME FROM E_USER WHERE USER_ID=T.UPDATE_USER) AS "V14",
			       CONCAT(CONCAT(CAST(T.UPDATE_DATETIME AS DATE),' '),CAST(T.UPDATE_DATETIME AS TIME)) AS "V15",
			       (SELECT USER_NAME FROM E_USER WHERE USER_ID=T.EXAMINE_USER) "V16",
			       CONCAT(CONCAT(CAST(T.EXAMINE_DATETIME AS DATE),' '),CAST(T.EXAMINE_DATETIME AS TIME)) AS "V17",
			       CONCAT(CONCAT(CONCAT(CASE T.KPI_TYPE
			       	WHEN '1' THEN '基础指标'
			       	WHEN '2' THEN '复合指标'
			       	ELSE '衍生指标'
			       	END,'('),CASE T.ACCTTYPE
			       			 WHEN '1' THEN '日'
			       			 ELSE '月'
			       			 END ),')') AS "V18",
			       SERVICE_KEY  AS "V19",
			       KPI_TYPE AS "V20",
			       TTT.view_type_name as "V21"
			  FROM X_KPI_INFO_TMP T join X_KPI_CATEGORY TT ON T.KPI_CATEGORY=TT.CATEGORY_ID 
									join X_KPI_TYPE TTT ON T.KPI_TYPE = TTT.TYPE_CODE 
			  WHERE 1=1
			 	<e:if condition="${param.queryFlag=='1' }">
			  		AND ((T.KPI_ISCURR ='0' and T.KPI_STATUS in ('0','1','3')) or (T.KPI_ISCURR ='1' and T.KPI_STATUS='2'))
			  	</e:if>
			    <e:if condition="${param.queryFlag=='2' }">
			  		AND T.KPI_STATUS='0'	AND T.KPI_ISCURR='0'
			  	</e:if>
			 	<e:if condition="${param.queryFlag=='3' }">
			  		AND T.KPI_STATUS='1'	AND T.KPI_ISCURR='0'
			  	</e:if>
			  	<e:if condition="${param.queryFlag=='4' }">
			  		AND T.KPI_STATUS='9'	AND T.KPI_ISCURR='0'
			  	</e:if>
			  	<e:if condition="${param.kpi_name ne ''&&param.kpi_name ne null }">
			  		AND T.KPI_NAME LIKE CONCAT(CONCAT('%','${param.kpi_name}'),'%')
			  	</e:if>
			  	<e:if condition="${param.kpiFlag ne ''&&param.kpiFlag ne null }">
			  		AND T.KPI_FLAG='${param.kpiFlag}'
			  	</e:if>
			  	<e:if condition="${param.kpi_iscurr ne ''&&param.kpi_iscurr ne null }">
			  		AND T.KPI_ISCURR='${param.kpi_iscurr}'
			  	</e:if>
			  	<e:if condition="${param.cube_code ne ''&&param.cube_code ne null }">
			  		AND T.CUBE_CODE='${param.cube_code}'
			  	</e:if>
			  	<e:if condition="${param.service_key ne ''&&param.service_key ne null }">
			  		AND T.SERVICE_KEY LIKE CONCAT(CONCAT('%','${param.service_key}'),'%')
			  	</e:if>
			  <e:if condition="${param.kpi_category!=0&&param.kpi_category!=''&&param.kpi_category!=null}">
			   	AND T.KPI_CATEGORY IN (
			   		<e:forEach items="${CATEGORY_ID.list }" var="cat" indexName="ind">
			   			<e:if condition="${ind>0 }">
			   			 ,
			   			</e:if>
			   			${cat.CATEGORY_ID }
			   		</e:forEach>
			   		)
			  </e:if>
			  ORDER BY T.CREATE_DATETIME DESC
		</c:tablequery>
	</e:case>
	<e:case value="queryAudit">
		<c:tablequery>
			<e:sql name="kpi.kpiQueryAndAudit.queryAudit"/>
		</c:tablequery>
	</e:case>
	<e:case value="audit">
		<e:update sql="kpi.kpiQueryAndAudit.saveaudit"/>
		<e:if condition="${param.kpi_status==3}">
			<e:update sql="kpi.kpiQueryAndAudit.update3KPIINFOTMP"/>
		</e:if>
		<e:if condition="${param.kpi_status==2}">
			<e:update sql="kpi.kpiQueryAndAudit.update2KPIINFOTMP"/>
			<e:if condition="${param.audit_flag=='2'}">
				<e:update sql="kpi.kpiQueryAndAudit.update2audit" transaction="true"/>
			</e:if>
		</e:if>
		<e:if condition="${param.nextStatus =='2' }">
			<e:update sql="kpi.kpiQueryAndAudit.update2nextStatus" transaction="true"/>
		</e:if>
		${at}
	</e:case>
	<e:case value="queryTab">
		<e:q4l var="tabInfo" sql="kpi.kpiQueryAndAudit.queryTab"/>
		${e:java2json(tabInfo.list) }
	</e:case>
	<e:case value="queryKpiDetail">
		<e:q4o var="kpiInfo" sql="kpi.kpiQueryAndAudit.queryKpiDetail"/>
		${e:java2json(kpiInfo) }
	</e:case>
	<e:case value="queryCube">
		<e:q4l var="cube"  sql="kpi.kpiQueryAndAudit.queryCube"/>
		${e:java2json(cube.list) }
	</e:case>
	<e:case value="queryCategory">
		<e:if condition="${param.cube_code eq null || param.cube_code eq ''}">
				[{
					"id":"0",
					"text":"指标库",
					"state":"closed"
				}]
		</e:if>
		<e:if condition="${param.cube_code ne null && param.cube_code ne ''}">
			<e:if condition="${param.id!=null&&param.id!=''}">
				<e:q4l var="category" sql="kpi.kpiQueryAndAudit.queryCategory">
				</e:q4l>
				[<e:forEach items="${category.list }" var="item">
					<e:if condition="${index>0}">,</e:if>	
					{
						"id":${item.id},
						"text":"${item.name}",
						"state":"closed"
					}
				</e:forEach>
				]
			</e:if>
		</e:if>
	</e:case>
	<e:case value="queryFlag">
		<e:q4l var="qFlag" sql="kpi.kpiQueryAndAudit.queryFlag"/>
		${e:java2json(qFlag.list) }
	</e:case>
</e:switch>