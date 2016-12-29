<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@page import="java.io.File"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:switch value="${param.eaction}">
	<e:case value="kpi">
	<e:if condition="${param.id==null||param.id==''}">
		<e:q4o var="KPIObj" extds="java:/comp/env/jndi/initdb">
				SELECT OID ,NAME  FROM X_KPI_VIEW T WHERE T.OID ='t5'
			</e:q4o>
				[
				{
				"id":"${KPIObj.OID}",
				"text":"${KPIObj.NAME}",
				"attributes":{
							},
				"children":[
					<e:q4l var="childrenListForKPI"  extds="java:/comp/env/jndi/initdb">
				        SELECT TT.*
				          FROM (SELECT CONNECT_BY_ISLEAF ISLEAF, LEVEL LEVEL1, t.*
				                  FROM x_kpi_view T
				                 START WITH T.PARENT_oid = 't5'
				                CONNECT BY PRIOR T.OID = T.PARENT_OID) TT
				         WHERE TT.LEVEL1 = 1
					</e:q4l>
					<e:forEach items="${childrenListForKPI.list}" var="item">
						<e:if condition="${index>0}">
							,
						</e:if>
						{
							"id":"${item.OID }",
							"text":"${item.NAME }",
							<e:if condition="${item.ISLEAF==0}">
							"state":"closed",
							</e:if>
							"attributes":{
								"oid":"${item.OID }",
								"parentId":"${item.PARENT_OID }",
								"name":"${item.NAME }",
								"code":"${item.CODE }",
								"kpiId":"${item.KPI_ID }",
								"typeOid":"${item.TYPEOID }",
								"delFlag":"${item.DELETE_FLAG }",
								"kpiTypeId":"${item.KPI_TYPE_ID }",
								"kpiUnit":"${item.KPI_UNIT }",
								"kpiAttribute":"${item.KPI_ATTRIBUTE }",
								"depName":"${item.DEPNAME }",
								"calRule":"${item.CAL_RULE }",
								"ruleDesc":"${item.RULE_DESC }",
								"formatValue":"${item.VALUE_FORMAT }",
								"uniqueCode":"${item.UNIQUE_CODE }",
								"kpiVersion":"${item.KPI_VERSION }",
								"securityLevel":"${item.SECURITY_LEVEL }",
								"balacnceFormula":"${item.BALACNCE_FORMULA }",
								"srcInterface":"${item.SRC_INTERFACE }",
								"kpiSrc":"${item.KPI_SRC }",
								"adjustment":"${item.ADJUSTMENT }",
								"pubTime":"${item.PUB_TIME }",
								"areaBelongs":"${item.AREA_BELONGS }",
								"srcType":"${item.SRC_TYPE }",
								"isCalc":"${item.IS_CALC }",
								"calcFormula":"${item.CALC_FORMULA }",
								"lineUpTime":"${item.LINE_UP_TIME }",
								"standKpiId":"${item.STAND_KPI_ID }",
								"kpiPeriod":"${item.KPI_PERIOD }",
								"kpiSpec":"${item.KPI_SPEC }",
								"kpiGroupId":"${item.KPI_GROUP_ID }",
								"kpiQuateId":"${item.KPI_QUATE_ID }",
								"fieldCode":"${item.FIELD_CODE }",
								"fieldName":"${item.FIELD_NAME }",
								"tableName":"${item.TABLENAME }"
								
							}
						}
					</e:forEach>
				]
				}
			]
			</e:if>
			<e:if condition="${param.id!=null&&param.id!=''}" >
			<e:q4l var="childrenListForId"   extds="java:/comp/env/jndi/initdb">
				 	SELECT *
					  FROM (SELECT CONNECT_BY_ISLEAF ISLEAF, LEVEL LEVEL1, T.*
					          FROM (SELECT DISTINCT *
					                  FROM (SELECT *
					                          FROM X_KPI_VIEW
					                         WHERE OID IN
					                               (SELECT OID
					                                  FROM X_KPI_VIEW T
					                                 START WITH T.OID IN
					                                            (SELECT OID FROM X_KPI_VIEW)
					                                CONNECT BY T.OID = PRIOR T.PARENT_OID
					                                UNION ALL
					                                SELECT OID
					                                  FROM X_KPI_VIEW T
					                                 START WITH T.OID IN
					                                            (SELECT OID FROM X_KPI_VIEW)
					                                CONNECT BY PRIOR T.OID = T.PARENT_OID))) T
					         START WITH T.PARENT_OID = '${param.id }'
					        CONNECT BY PRIOR T.OID = T.PARENT_OID) TT
					 WHERE TT.LEVEL1 = 1
			
			</e:q4l>
			[
				<e:forEach items="${childrenListForId.list}" var="item">
					<e:if condition="${index>0}">
						,
					</e:if>
					{
						"id":"${item.OID }",
						"text":"${item.NAME }",
						<e:if condition="${item.ISLEAF==0}">
						"state":"closed",
						</e:if>
						"attributes":{
							"oid":"${item.OID }",
							"parentId":"${item.PARENT_OID }",
							"name":"${item.NAME }",
							"code":"${item.CODE }",
							"kpiId":"${item.KPI_ID }",
							"typeOid":"${item.TYPEOID }",
							"delFlag":"${item.DELETE_FLAG }",
							"kpiTypeId":"${item.KPI_TYPE_ID }",
							"kpiUnit":"${item.KPI_UNIT }",
							"kpiAttribute":"${item.KPI_ATTRIBUTE }",
							"depName":"${item.DEPNAME }",
							"calRule":"${item.CAL_RULE }",
							"ruleDesc":"${item.RULE_DESC }",
							"formatValue":"${item.VALUE_FORMAT }",
							"uniqueCode":"${item.UNIQUE_CODE }",
							"kpiVersion":"${item.KPI_VERSION }",
							"securityLevel":"${item.SECURITY_LEVEL }",
							"balacnceFormula":"${item.BALACNCE_FORMULA }",
							"srcInterface":"${item.SRC_INTERFACE }",
							"kpiSrc":"${item.KPI_SRC }",
							"adjustment":"${item.ADJUSTMENT }",
							"pubTime":"${item.PUB_TIME }",
							"areaBelongs":"${item.AREA_BELONGS }",
							"srcType":"${item.SRC_TYPE }",
							"isCalc":"${item.IS_CALC }",
							"calcFormula":"${item.CALC_FORMULA }",
							"lineUpTime":"${item.LINE_UP_TIME }",
							"standKpiId":"${item.STAND_KPI_ID }",
							"kpiPeriod":"${item.KPI_PERIOD }",
							"kpiSpec":"${item.KPI_SPEC }",
							"kpiGroupId":"${item.KPI_GROUP_ID }",
							"kpiQuateId":"${item.KPI_QUATE_ID }",
							"fieldCode":"${item.FIELD_CODE }",
							"fieldName":"${item.FIELD_NAME }",
							"tableName":"${item.TABLENAME }"
								}
					}
				</e:forEach>
			]
		</e:if>
	</e:case>
	
	<e:case value="dimension">
	<e:if condition="${param.id==null||param.id==''}">
		<e:q4o var="KPIObj" extds="java:/comp/env/jndi/initdb">
				SELECT OID ,NAME  FROM X_DIMENSION_VIEW T WHERE T.OID ='t4'
			</e:q4o>
				[
				{
				"id":"${KPIObj.OID}",
				"text":"${KPIObj.NAME}",
				"attributes":{
							},
				"children":[
					<e:q4l var="childrenListForKPI"  extds="java:/comp/env/jndi/initdb">
				        SELECT *
				          FROM (SELECT CONNECT_BY_ISLEAF ISLEAF, LEVEL LEVEL1, t.*
				                  FROM X_DIMENSION_VIEW T
				                 START WITH T.PARENT_oid = 't4'
				                CONNECT BY PRIOR T.OID = T.PARENT_OID) TT
				         WHERE TT.LEVEL1 = 1
					</e:q4l>
					<e:forEach items="${childrenListForKPI.list}" var="item">
						<e:if condition="${index>0}">
							,
						</e:if>
						{
							"id":"${item.OID }",
							"text":"${item.NAME }",
							<e:if condition="${item.ISLEAF==0}">
							"state":"closed",
							</e:if>
							"attributes":{
								"oid":"${item.OID }",
								"parentId":"${item.PARENT_OID }",
								"name":"${item.NAME }",
								"code":"${item.CODE }",
								"dimensionid":"${item.DIMENSIONID }",
								"dimensionname":"${item.DIMENSIONNAME }",
								"dimensioncode":"${item.DIMENSIONCODE }",
								"is_valid":"${item.IS_VALID }",
								"obj_status":"${item.OBJ_STATUS }",
								"delete_flag":"${item.DELETE_FLAG }",
								"dimension_type_id":"${item.DIMENSION_TYPE_ID }",
								"menu_name":"${item.MENU_NAME }",
								"time_format":"${item.TIME_FORMAT }",
								"query_condition":"${item.QUERY_CONDITION }",
								"is_cascade":"${item.IS_CASCADE }",
								"dimension_name":"${item.DIMENSION_NAME }",
								"cascade_rank":"${item.CASCADE_RANK }",
								"cascadename":"${item.CASCADENAME }",
								"valuename":"${item.VALUENAME }",
								"vvalue":"${item.VVALUE }",
								"parent_id":"${item.PARENT_ID }",
								"tablename":"${item.TABLENAME }",
								"field_code":"${item.FIELD_CODE }",
								"field_name":"${item.FIELD_NAME }",
								"field_alias":"${item.FIELD_ALIAS }"
							}
						}
					</e:forEach>
				]
				}
			]
			</e:if>
			<e:if condition="${param.id!=null&&param.id!=''}" >
			<e:q4l var="childrenListForId"   extds="java:/comp/env/jndi/initdb">
				 	SELECT TT.*
						  FROM (SELECT CONNECT_BY_ISLEAF ISLEAF, LEVEL LEVEL1, T.*
						          FROM (SELECT DISTINCT *
						                  FROM (SELECT *
						                          FROM X_DIMENSION_VIEW
						                         WHERE OID IN
						                               (SELECT OID
						                                  FROM X_DIMENSION_VIEW T
						                                 START WITH T.OID IN
						                                            (SELECT OID FROM X_DIMENSION_VIEW)
						                                CONNECT BY T.OID = PRIOR T.PARENT_OID
						                                UNION ALL
						                                SELECT OID
						                                  FROM X_DIMENSION_VIEW T
						                                 START WITH T.OID IN
						                                            (SELECT OID FROM X_DIMENSION_VIEW)
						                                CONNECT BY PRIOR T.OID = T.PARENT_OID))) T
						         START WITH T.PARENT_OID = '${param.id }'
						        CONNECT BY PRIOR T.OID = T.PARENT_OID) TT
						 WHERE TT.LEVEL1 = 1
			
			</e:q4l>
			[
				<e:forEach items="${childrenListForId.list}" var="item">
					<e:if condition="${index>0}">
						,
					</e:if>
					{
						"id":"${item.OID }",
						"text":"${item.NAME }",
						<e:if condition="${item.ISLEAF==0}">
						"state":"closed",
						</e:if>
						"attributes":{
							"oid":"${item.OID }",
							"parentId":"${item.PARENT_OID }",
							"name":"${item.NAME }",
							"code":"${item.CODE }",
							"dimensionid":"${item.DIMENSIONID }",
							"dimensionname":"${item.DIMENSIONNAME }",
							"dimensioncode":"${item.DIMENSIONCODE }",
							"is_valid":"${item.IS_VALID }",
							"obj_status":"${item.OBJ_STATUS }",
							"delete_flag":"${item.DELETE_FLAG }",
							"dimension_type_id":"${item.DIMENSION_TYPE_ID }",
							"menu_name":"${item.MENU_NAME }",
							"time_format":"${item.TIME_FORMAT }",
							"query_condition":"${item.QUERY_CONDITION }",
							"is_cascade":"${item.IS_CASCADE }",
							"dimension_name":"${item.DIMENSION_NAME }",
							"cascade_rank":"${item.CASCADE_RANK }",
							"cascadename":"${item.CASCADENAME }",
							"valuename":"${item.VALUENAME }",
							"vvalue":"${item.VVALUE }",
							"parent_id":"${item.PARENT_ID }",
							"tablecode":"${item.TABLECODE }",
							"tablename":"${item.TABLENAME }",
							"field_code":"${item.FIELD_CODE }",
							"field_name":"${item.FIELD_NAME }",
							"field_alias":"${item.FIELD_ALIAS }"
								}
					}
				</e:forEach>
			]
		</e:if>
	</e:case>
	
	<e:case value="complexKpi">
	<e:if condition="${param.id==null||param.id==''}">
		<e:q4o var="KPIObj">
				SELECT CATEGORY_ID ,CATEGORY_NAME  FROM X_KPI_CATEGORY T WHERE T.CATEGORY_ID ='0'
			</e:q4o>
				[
				{
				"id":"${KPIObj.CATEGORY_ID}",
				"text":"${KPIObj.CATEGORY_NAME}",
				"attributes":{
							},
				"children":[
					<e:q4l var="childrenListForKPI">
				        SELECT CONNECT_BY_ISLEAF ISLEAF, LEVEL LEVEL1,A.* FROM(
								SELECT T.CATEGORY_ID        ID,
								       T.CATEGORY_PARENT_ID PARENT_ID,
								       T.CATEGORY_NAME      NAME
								  FROM X_KPI_CATEGORY T
								UNION
								SELECT T1.KPI_KEY ID,
								       T1.KPI_CATEGORY PARENT_ID, 
								       T1.KPI_NAME NAME  
								  FROM X_KPI_INFO T1
								 WHERE T1.KPI_STATUS = '2') A
								START WITH A.PARENT_ID = '0'
								CONNECT BY PRIOR A.ID = A.PARENT_ID
					</e:q4l>
					<e:forEach items="${childrenListForKPI.list}" var="item">
						<e:if condition="${index>0}">
							,
						</e:if>
						{
							"id":"${item.ID }",
							"text":"${item.NAME }",
							<e:if condition="${item.ISLEAF==0}">
							"state":"closed",
							</e:if>
							"attributes":{
								
							}
						}
					</e:forEach>
				]
				}
			]
			</e:if>
			<e:if condition="${param.id!=null&&param.id!=''}" >
			<e:q4l var="childrenListForId">
				 	SELECT CONNECT_BY_ISLEAF ISLEAF, LEVEL LEVEL1,A.* FROM(
							SELECT T.CATEGORY_ID        ID,
							       T.CATEGORY_PARENT_ID PARENT_ID,
							       T.CATEGORY_NAME      NAME
							  FROM X_KPI_CATEGORY T
							UNION
							SELECT T1.KPI_KEY ID,
							       T1.KPI_CATEGORY PARENT_ID, 
							       T1.KPI_NAME NAME  
							  FROM X_KPI_INFO T1
							 WHERE T1.KPI_STATUS = '2') A
							START WITH A.PARENT_ID = '${param.id }'
							CONNECT BY PRIOR A.ID = A.PARENT_ID
			
			</e:q4l>
			[
				<e:forEach items="${childrenListForId.list}" var="item">
					<e:if condition="${index>0}">
						,
					</e:if>
					{
						"id":"${item.ID }",
						"text":"${item.NAME }",
						<e:if condition="${item.ISLEAF==0}">
						"state":"closed",
						</e:if>
						"attributes":{
							
								}
					}
				</e:forEach>
			]
		</e:if>
	</e:case>
	
	<e:case value="dimensionField">
		<e:set var="key">''</e:set>
		<e:set var="value">''</e:set>
		<e:set var="tableName">${param.tableName }</e:set>
		<e:q4l var="dimInfo"  extds="java:/comp/env/jndi/initdb">
			select T.FIELD_CODE,T.TABLENAME,T.FIELD_ALIAS from X_FILELD_VIEW t where t.TABLEID='${param.oid }'
		</e:q4l>	
		<e:forEach items="${dimInfo.list }" var="info">
			<e:if condition="${'CODE' eq info.FIELD_ALIAS }">
				<e:set var="key">${info.FIELD_CODE}</e:set>
			</e:if>
			<e:if condition="${'CODE_NAME' eq info.FIELD_ALIAS }">
				<e:set var="value">${info.FIELD_CODE}</e:set>
			</e:if>
		</e:forEach>
		{
			"key":"${key }",
			"name":"${vlaue }",
			"sql": "select distinct ${key} key,${value } value from ${tableName }"
		
		}
	</e:case>
	
	<e:case value="dimensionForOid">
		<e:set var="key">''</e:set>
		<e:set var="value">''</e:set>
		<e:set var="tableName">${param.tableName }</e:set>
		<e:q4l var="dimInfo"  extds="java:/comp/env/jndi/initdb">
			select T.FIELD_CODE,T.TABLENAME,T.FIELD_ALIAS from X_FILELD_VIEW t where t.TABLEID='${param.oid }'
		</e:q4l>	
		<e:forEach items="${dimInfo.list }" var="info">
			<e:if condition="${'CODE' eq info.FIELD_ALIAS }">
				<e:set var="key">${info.FIELD_CODE}</e:set>
			</e:if>
			<e:if condition="${'CODE_NAME' eq info.FIELD_ALIAS }">
				<e:set var="value">${info.FIELD_CODE}</e:set>
			</e:if>
		</e:forEach>
		<e:q4l var="tableValue" extds="java:/comp/env/jndi/datasource3">
			select distinct ${key} key,${value } value from ${tableName }
		</e:q4l>
		${e:java2json(tableValue.list)  }
	</e:case>
	
	<e:case value="dimensionForId">
		<e:q4o var="dimInfo"  extds="java:/comp/env/jndi/initdb">
			SELECT T.OID,T.TABLECODE,T.LINKTABLE FROM X_DIMENSION_VIEW T WHERE T.OID='${param.oid}'
		</e:q4o>
		<e:set var="tableCode">${dimInfo.TABLECODE }</e:set>
		<e:set var="LINKTABLE">${dimInfo.LINKTABLE }</e:set>
		<e:q4l var="dim"   extds="java:/comp/env/jndi/initdb">
			select T.FIELD_CODE,T.TABLENAME,T.FIELD_ALIAS from X_FILELD_VIEW t where t.TABLEID='${tableCode }'
		</e:q4l>
		<e:forEach items="${dim.list }" var="info">
			<e:if condition="${'CODE' eq info.FIELD_ALIAS }">
				<e:set var="key">${info.FIELD_CODE}</e:set>
			</e:if>
			<e:if condition="${'CODE_NAME' eq info.FIELD_ALIAS }">
				<e:set var="value">${info.FIELD_CODE}</e:set>
			</e:if>
			<e:set var="tableName">${info.TABLENAME}</e:set>
		</e:forEach>
		<e:q4l var="tableValue" extds="java:/comp/env/jndi/datasource3">
			select distinct ${key} key,${value } value from ${tableName } t where 1=1
			<e:if condition="${null ne param.tjzId && '' ne param.tjzId}">
				and t.${key} not in(
					<e:forEach items="${e:split(param.tjzId,',') }" var="id">
						'${id }',
					</e:forEach>
					' '
				)
			</e:if>
			 
		</e:q4l>
		${e:java2json(tableValue.list)  }
	</e:case>
</e:switch>