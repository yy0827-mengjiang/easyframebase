<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="org.springframework.web.util.*" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<e:switch value="${param.eaction}">
	<e:case value="list">
		<c:tablequery>
			<e:if condition="${DBSource=='oracle' }">
				SELECT KPI_NAME           KPI_NAME,
				       KPI_ID,
				       KPI_VALUE,
				       COMPARE_VALUE_TYPE,
				       WAVE_VALUE,
				       THRESHOLD_ID,
				       URL,
				       RESOURCES_NAME     RESOURCES_NAME,
				       THRESHOLD_VALUE
				  FROM (SELECT CASE
				                 WHEN Y.COMPARE_VALUE_TYPE = 1 THEN
				                  X.KPI_VALUE
				                 WHEN Y.COMPARE_VALUE_TYPE = 2 AND X.KPI_VALUE_LD <> 0 THEN
				                  (X.KPI_VALUE - X.KPI_VALUE_LD) / (X.KPI_VALUE_LD)
				                 WHEN Y.COMPARE_VALUE_TYPE = 2 AND X.KPI_VALUE_LD = 0 THEN
				                  0
				                 WHEN Y.COMPARE_VALUE_TYPE = 3 AND X.KPI_VALUE_LM <> 0 THEN
				                  (X.KPI_VALUE - X.KPI_VALUE_LM) / (X.KPI_VALUE_LM)
				                 WHEN Y.COMPARE_VALUE_TYPE = 3 AND X.KPI_VALUE_LM = 0 THEN
				                  0
				               END KPI_VALUE,
				               Y.THRESHOLD_VALUE THRESHOLD_VALUE,
				               Y.KPI_NAME KPI_NAME,
				               X.KPI_ID,
				               X.KPI_VALUE KPI_VALUE_D,
				               DECODE(Y.COMPARE_VALUE_TYPE,
				                      '1',
				                      '指标',
				                      '2',
				                      '环比',
				                      '3',
				                      '同比') COMPARE_VALUE_TYPE,
				               Y.WAVE_VALUE,
				               DECODE(Y.THRESHOLD_ID, '1', '向上', '2', '向下') THRESHOLD_ID,
				               Y.URL,
				               Y.RESOURCES_NAME RESOURCES_NAME
				          FROM E_PREDICT_DAY X,
				               (SELECT T.KPI_ID             KPI_ID,
				                       N.KPI_NAME           KPI_NAME,
				                       T.MENU_ID            MENU_ID,
				                       M.URL                URL,
				                       T.COMPARE_VALUE_TYPE COMPARE_VALUE_TYPE,
				                       T.THRESHOLD_ID       THRESHOLD_ID,
				                       M.RESOURCES_NAME     RESOURCES_NAME,
				                       T.THRESHOLD_VALUE    THRESHOLD_VALUE,
				                       T.WAVE_VALUE         WAVE_VALUE
				                  FROM E_USER_PREDICT T,
				                       E_MENU M,
				                       (SELECT DISTINCT KPI_CODE, KPI_NAME
				                          FROM E_HOME_KPI_INFO) N
				                 WHERE T.KPI_ID = N.KPI_CODE(+)
				                   AND T.MENU_ID = M.RESOURCES_ID(+)
				                   AND T.USER_ID = '${sessionScope.UserInfo.USER_ID}') Y
				        
				         WHERE X.KPI_ID = Y.KPI_ID(+)
				           AND Y.THRESHOLD_ID = 1
				           <e:if condition="${sessionScope.UserInfo.AREA_NO==null||sessionScope.UserInfo.AREA_NO==''||sessionScope.UserInfo.AREA_NO=='-1' }">
								AND 1 = 1
							</e:if>
							<e:if condition="${sessionScope.UserInfo.AREA_NO!=null&&sessionScope.UserInfo.AREA_NO!=''&&sessionScope.UserInfo.AREA_NO!='-1' }">
								<e:if condition="${sessionScope.UserInfo.CITY_NO==null||sessionScope.UserInfo.CITY_NO==''||sessionScope.UserInfo.CITY_NO=='-1' }">
									and X.area_no = '${sessionScope.UserInfo.AREA_NO}'
								</e:if>
								<e:if condition="${sessionScope.UserInfo.CITY_NO!=null&&sessionScope.UserInfo.CITY_NO!=''&&sessionScope.UserInfo.CITY_NO!='-1' }">
								    AND X.city_no = '${sessionScope.UserInfo.CITY_NO}'
								</e:if>
							</e:if>
				           AND X.ACCT_DAY =
				               (select DISTINCT t.const_value val
				                  from sys_const_table t
				                 where t.const_name in ('calendar.curdate')))
				 WHERE KPI_VALUE - THRESHOLD_VALUE > WAVE_VALUE
				
				UNION ALL
				
				SELECT KPI_NAME           KPI_NAME,
				       KPI_ID,
				       KPI_VALUE,
				       COMPARE_VALUE_TYPE,
				       WAVE_VALUE,
				       THRESHOLD_ID,
				       URL,
				       RESOURCES_NAME     RESOURCES_NAME,
				       THRESHOLD_VALUE
				  FROM (SELECT CASE
				                 WHEN Y.COMPARE_VALUE_TYPE = 1 THEN
				                  X.KPI_VALUE
				                 WHEN Y.COMPARE_VALUE_TYPE = 2 AND X.KPI_VALUE_LD <> 0 THEN
				                  (X.KPI_VALUE - X.KPI_VALUE_LD) / (X.KPI_VALUE_LD)
				                 WHEN Y.COMPARE_VALUE_TYPE = 2 AND X.KPI_VALUE_LD = 0 THEN
				                  0
				                 WHEN Y.COMPARE_VALUE_TYPE = 3 AND X.KPI_VALUE_LM <> 0 THEN
				                  (X.KPI_VALUE - X.KPI_VALUE_LM) / (X.KPI_VALUE_LM)
				                 WHEN Y.COMPARE_VALUE_TYPE = 3 AND X.KPI_VALUE_LM = 0 THEN
				                  0
				               END KPI_VALUE,
				               Y.THRESHOLD_VALUE THRESHOLD_VALUE,
				               Y.KPI_NAME KPI_NAME,
				               X.KPI_ID,
				               X.KPI_VALUE KPI_VALUE_D,
				               DECODE(Y.COMPARE_VALUE_TYPE,
				                      '1',
				                      '指标',
				                      '2',
				                      '环比',
				                      '3',
				                      '同比') COMPARE_VALUE_TYPE,
				               Y.WAVE_VALUE,
				               DECODE(Y.THRESHOLD_ID, '1', '向上', '2', '向下') THRESHOLD_ID,
				               Y.URL,
				               Y.RESOURCES_NAME RESOURCES_NAME
				          FROM E_PREDICT_DAY X,
				               (SELECT T.KPI_ID             KPI_ID,
				                       N.KPI_NAME           KPI_NAME,
				                       T.MENU_ID            MENU_ID,
				                       M.URL                URL,
				                       T.COMPARE_VALUE_TYPE COMPARE_VALUE_TYPE,
				                       T.THRESHOLD_ID       THRESHOLD_ID,
				                       M.RESOURCES_NAME     RESOURCES_NAME,
				                       T.THRESHOLD_VALUE    THRESHOLD_VALUE,
				                       T.WAVE_VALUE         WAVE_VALUE
				                  FROM E_USER_PREDICT T,
				                       E_MENU M,
				                       (SELECT DISTINCT KPI_CODE, KPI_NAME
				                          FROM E_HOME_KPI_INFO) N
				                 WHERE T.KPI_ID = N.KPI_CODE(+)
				                   AND T.MENU_ID = M.RESOURCES_ID(+)
				                   AND T.USER_ID = '${sessionScope.UserInfo.USER_ID}') Y
				        
				         WHERE X.KPI_ID = Y.KPI_ID(+)
				           AND Y.THRESHOLD_ID = 2
				           <e:if condition="${sessionScope.UserInfo.AREA_NO==null||sessionScope.UserInfo.AREA_NO==''||sessionScope.UserInfo.AREA_NO=='-1' }">
								AND 1 = 1
							</e:if>
							<e:if condition="${sessionScope.UserInfo.AREA_NO!=null&&sessionScope.UserInfo.AREA_NO!=''&&sessionScope.UserInfo.AREA_NO!='-1' }">
								<e:if condition="${sessionScope.UserInfo.CITY_NO==null||sessionScope.UserInfo.CITY_NO==''||sessionScope.UserInfo.CITY_NO=='-1' }">
									and X.area_no = '${sessionScope.UserInfo.AREA_NO}'
								</e:if>
								<e:if condition="${sessionScope.UserInfo.CITY_NO!=null&&sessionScope.UserInfo.CITY_NO!=''&&sessionScope.UserInfo.CITY_NO!='-1' }">
								    AND X.city_no = '${sessionScope.UserInfo.CITY_NO}'
								</e:if>
							</e:if>
				           AND X.ACCT_DAY =
				               (select DISTINCT t.const_value val
				                  from sys_const_table t
				                 where t.const_name in ('calendar.curdate')))
				 WHERE KPI_VALUE - THRESHOLD_VALUE < WAVE_VALUE
			</e:if>
			<e:if condition="${DBSource=='mysql' }">
				SELECT KPI_NAME           KPI_NAME,
				       KPI_ID,
				       KPI_VALUE,
				       COMPARE_VALUE_TYPE,
				       WAVE_VALUE,
				       THRESHOLD_ID,
				       URL,
				       RESOURCES_NAME     RESOURCES_NAME,
				       THRESHOLD_VALUE
				  FROM (SELECT CASE
				                 WHEN Y.COMPARE_VALUE_TYPE = 1 THEN
				                  X.KPI_VALUE
				                 WHEN Y.COMPARE_VALUE_TYPE = 2 AND X.KPI_VALUE_LD <> 0 THEN
				                  (X.KPI_VALUE - X.KPI_VALUE_LD) / (X.KPI_VALUE_LD)
				                 WHEN Y.COMPARE_VALUE_TYPE = 2 AND X.KPI_VALUE_LD = 0 THEN
				                  0
				                 WHEN Y.COMPARE_VALUE_TYPE = 3 AND X.KPI_VALUE_LM <> 0 THEN
				                  (X.KPI_VALUE - X.KPI_VALUE_LM) / (X.KPI_VALUE_LM)
				                 WHEN Y.COMPARE_VALUE_TYPE = 3 AND X.KPI_VALUE_LM = 0 THEN
				                  0
				               END KPI_VALUE,
				               Y.THRESHOLD_VALUE THRESHOLD_VALUE,
				               Y.KPI_NAME KPI_NAME,
				               X.KPI_ID,
				               X.KPI_VALUE KPI_VALUE_D,
				               case when Y.COMPARE_VALUE_TYPE = '1' then '指标'
				                    when Y.COMPARE_VALUE_TYPE = '2' then '环比'
				                    when Y.COMPARE_VALUE_TYPE = '3' then '同比'
				               end COMPARE_VALUE_TYPE,
				               Y.WAVE_VALUE,
				               case when Y.THRESHOLD_ID = '1' then '向上'
				                    when Y.THRESHOLD_ID = '2' then '向下'
				               end THRESHOLD_ID,
				               Y.URL,
				               Y.RESOURCES_NAME RESOURCES_NAME
				          FROM E_PREDICT_DAY X left join 
				               (SELECT T.KPI_ID             KPI_ID,
				                       N.KPI_NAME           KPI_NAME,
				                       T.MENU_ID            MENU_ID,
				                       M.URL                URL,
				                       T.COMPARE_VALUE_TYPE COMPARE_VALUE_TYPE,
				                       T.THRESHOLD_ID       THRESHOLD_ID,
				                       M.RESOURCES_NAME     RESOURCES_NAME,
				                       T.THRESHOLD_VALUE    THRESHOLD_VALUE,
				                       T.WAVE_VALUE         WAVE_VALUE
				                  FROM E_USER_PREDICT T left join 
				                       E_MENU M
				                       on T.MENU_ID = M.RESOURCES_ID
				                       left join 
				                       (SELECT DISTINCT KPI_CODE, KPI_NAME
				                          FROM E_HOME_KPI_INFO) N
				                       on T.KPI_ID = N.KPI_CODE
				                 WHERE T.USER_ID = '${sessionScope.UserInfo.USER_ID}') Y
				        
				         on X.KPI_ID = Y.KPI_ID
				           where Y.THRESHOLD_ID = 1
				           <e:if condition="${sessionScope.UserInfo.AREA_NO==null||sessionScope.UserInfo.AREA_NO==''||sessionScope.UserInfo.AREA_NO=='-1' }">
								AND 1 = 1
							</e:if>
							<e:if condition="${sessionScope.UserInfo.AREA_NO!=null&&sessionScope.UserInfo.AREA_NO!=''&&sessionScope.UserInfo.AREA_NO!='-1' }">
								<e:if condition="${sessionScope.UserInfo.CITY_NO==null||sessionScope.UserInfo.CITY_NO==''||sessionScope.UserInfo.CITY_NO=='-1' }">
									and X.area_no = '${sessionScope.UserInfo.AREA_NO}'
								</e:if>
								<e:if condition="${sessionScope.UserInfo.CITY_NO!=null&&sessionScope.UserInfo.CITY_NO!=''&&sessionScope.UserInfo.CITY_NO!='-1' }">
								    AND X.city_no = '${sessionScope.UserInfo.CITY_NO}'
								</e:if>
							</e:if>
				           AND X.ACCT_DAY =
				               (select DISTINCT t.const_value val
				                  from sys_const_table t
				                 where t.const_name in ('calendar.curdate')))
				 WHERE KPI_VALUE - THRESHOLD_VALUE > WAVE_VALUE
				
				UNION ALL
				
				SELECT KPI_NAME           KPI_NAME,
				       KPI_ID,
				       KPI_VALUE,
				       COMPARE_VALUE_TYPE,
				       WAVE_VALUE,
				       THRESHOLD_ID,
				       URL,
				       RESOURCES_NAME     RESOURCES_NAME,
				       THRESHOLD_VALUE
				  FROM (SELECT CASE
				                 WHEN Y.COMPARE_VALUE_TYPE = 1 THEN
				                  X.KPI_VALUE
				                 WHEN Y.COMPARE_VALUE_TYPE = 2 AND X.KPI_VALUE_LD <> 0 THEN
				                  (X.KPI_VALUE - X.KPI_VALUE_LD) / (X.KPI_VALUE_LD)
				                 WHEN Y.COMPARE_VALUE_TYPE = 2 AND X.KPI_VALUE_LD = 0 THEN
				                  0
				                 WHEN Y.COMPARE_VALUE_TYPE = 3 AND X.KPI_VALUE_LM <> 0 THEN
				                  (X.KPI_VALUE - X.KPI_VALUE_LM) / (X.KPI_VALUE_LM)
				                 WHEN Y.COMPARE_VALUE_TYPE = 3 AND X.KPI_VALUE_LM = 0 THEN
				                  0
				               END KPI_VALUE,
				               Y.THRESHOLD_VALUE THRESHOLD_VALUE,
				               Y.KPI_NAME KPI_NAME,
				               X.KPI_ID,
				               X.KPI_VALUE KPI_VALUE_D,
				               case when Y.COMPARE_VALUE_TYPE = '1' then '指标'
				                    when Y.COMPARE_VALUE_TYPE = '2' then '环比'
				                    when Y.COMPARE_VALUE_TYPE = '3' then '同比'
				               end COMPARE_VALUE_TYPE,
				               Y.WAVE_VALUE,
				               case when Y.THRESHOLD_ID = '1' then '向上'
				                    when Y.THRESHOLD_ID = '2' then '向下'
				               end THRESHOLD_ID,
				               Y.URL,
				               Y.RESOURCES_NAME RESOURCES_NAME
				          FROM E_PREDICT_DAY X left join 
				               (SELECT T.KPI_ID             KPI_ID,
				                       N.KPI_NAME           KPI_NAME,
				                       T.MENU_ID            MENU_ID,
				                       M.URL                URL,
				                       T.COMPARE_VALUE_TYPE COMPARE_VALUE_TYPE,
				                       T.THRESHOLD_ID       THRESHOLD_ID,
				                       M.RESOURCES_NAME     RESOURCES_NAME,
				                       T.THRESHOLD_VALUE    THRESHOLD_VALUE,
				                       T.WAVE_VALUE         WAVE_VALUE
				                  FROM E_USER_PREDICT T left join
				                       E_MENU M
				                       on T.MENU_ID = M.RESOURCES_ID
				                       left join 
				                       (SELECT DISTINCT KPI_CODE, KPI_NAME
				                          FROM E_HOME_KPI_INFO) N
				                       on T.KPI_ID = N.KPI_CODE
				                 WHERE T.USER_ID = '${sessionScope.UserInfo.USER_ID}') Y
				        
				         on X.KPI_ID = Y.KPI_ID
				           where Y.THRESHOLD_ID = 2
				           <e:if condition="${sessionScope.UserInfo.AREA_NO==null||sessionScope.UserInfo.AREA_NO==''||sessionScope.UserInfo.AREA_NO=='-1' }">
								AND 1 = 1
							</e:if>
							<e:if condition="${sessionScope.UserInfo.AREA_NO!=null&&sessionScope.UserInfo.AREA_NO!=''&&sessionScope.UserInfo.AREA_NO!='-1' }">
								<e:if condition="${sessionScope.UserInfo.CITY_NO==null||sessionScope.UserInfo.CITY_NO==''||sessionScope.UserInfo.CITY_NO=='-1' }">
									and X.area_no = '${sessionScope.UserInfo.AREA_NO}'
								</e:if>
								<e:if condition="${sessionScope.UserInfo.CITY_NO!=null&&sessionScope.UserInfo.CITY_NO!=''&&sessionScope.UserInfo.CITY_NO!='-1' }">
								    AND X.city_no = '${sessionScope.UserInfo.CITY_NO}'
								</e:if>
							</e:if>
				           AND X.ACCT_DAY =
				               (select DISTINCT t.const_value val
				                  from sys_const_table t
				                 where t.const_name in ('calendar.curdate')))
				 WHERE KPI_VALUE - THRESHOLD_VALUE < WAVE_VALUE
			</e:if>
		</c:tablequery>
	</e:case> 
</e:switch>