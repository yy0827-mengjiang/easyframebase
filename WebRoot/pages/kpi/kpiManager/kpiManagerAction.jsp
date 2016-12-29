<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:switch value="${param.action}">
	<e:case value="loadTree">
		<e:if condition="${param.id==null||param.id==''}">
			<e:q4o var="root">
				select t.category_id id,
				       t.category_name || '[' ||
				       (SELECT COUNT(0)
				          FROM X_KPI_INFO_TMP
				         WHERE kpi_iscurr ='1'
				           AND KPI_FLAG!='D'
				         and KPI_CATEGORY IN
				               (SELECT CATEGORY_ID
				                  FROM X_KPI_CATEGORY
				                 START WITH CATEGORY_ID = '0'
				                CONNECT BY PRIOR CATEGORY_ID = CATEGORY_PARENT_ID)) || ']' text
				  from x_kpi_category t
				 where t.category_parent_id = '-1'			
			</e:q4o>
			[{
				"id":${root.id},
				"text":"${root.text}",
				"state":"closed",
				"children":[
					<e:q4l var="children">
						select t.category_id id,
						       t.category_name || '[' ||
						       (SELECT COUNT(0)
						          FROM X_KPI_INFO_TMP
						          WHERE kpi_iscurr ='1'
						            AND KPI_FLAG!='D'
						         and KPI_CATEGORY IN
						               (SELECT CATEGORY_ID
						                  FROM X_KPI_CATEGORY
						                 START WITH CATEGORY_ID = t.category_id
						                CONNECT BY PRIOR CATEGORY_ID = CATEGORY_PARENT_ID)) || ']' text
						  from x_kpi_category t
						 where t.category_parent_id = '${root.id}'
					</e:q4l>
					<e:forEach items="${children.list}" var="item">
						<e:if condition="${index>0}">,</e:if>	
						{
							"id":${item.id},
							"text":"${item.text}"
							<e:if condition="${item.is_leaf!='1'}">
								,"state":"closed"
							</e:if>
						}
					</e:forEach>
				]
			}]
		</e:if>
		<e:if condition="${param.id!=null&&param.id!=''}">
			<e:q4l var="expandChild">
						select t.category_id id,
						       t.category_name || '[' ||
						       (SELECT COUNT(0)
						          FROM X_KPI_INFO_TMP
						          WHERE kpi_iscurr ='1'
						          AND KPI_FLAG!='D'
						         and KPI_CATEGORY IN
						               (SELECT CATEGORY_ID
						                  FROM X_KPI_CATEGORY
						                 START WITH CATEGORY_ID = t.category_id
						                CONNECT BY PRIOR CATEGORY_ID = CATEGORY_PARENT_ID)) || ']' text
						  from x_kpi_category t
						 where t.category_parent_id = '${param.id}'
			</e:q4l>
				[<e:forEach items="${expandChild.list}" var="item">
					<e:if condition="${index>0}">,</e:if>	
					{
						"id":${item.id},
						"text":"${item.text}"
						<e:if condition="${item.is_leaf!='1'}">
						,"state":"closed"
						</e:if>
					}
				</e:forEach>]
		</e:if>	
	</e:case>
	<e:case value="kpiList">
		<e:if condition="${param.id!=null&&param.id!=''}">
			<c:tablequery>
				SELECT T.KPI_KEY V0,T.KPI_NAME V1,T.KPI_CATEGORY V2,C.CATEGORY_NAME V9,T.KPI_NUIT V3,T.KPI_VERSION V4,DECODE(KPI_ISCURR,'1','是','0','否') V5,DECODE(KPI_FLAG,'I','新增','U','修改','D','删除') V6,DECODE(KPI_STATUS,'0','待发布','1','待审核','2','审核通过','3','审核未通过','4','编辑模式')V7,KPI_CODE V8,T.KPI_ISCURR V10,T.KPI_CALIBER V11,U.USER_NAME V12,TO_CHAR(T.CREATE_DATETIME,'YYYY-MM-DD') V13, T.KPI_STATUS V14 FROM X_KPI_INFO_TMP T, X_KPI_CATEGORY C,E_USER U WHERE 1=1
					AND T.CREATE_USER=U.USER_ID
					AND T.KPI_CATEGORY=C.CATEGORY_ID
					AND T.KPI_ISCURR='1' AND T.KPI_FLAG!='D'
					AND T.KPI_CATEGORY IN (SELECT CATEGORY_ID FROM X_KPI_CATEGORY START WITH CATEGORY_ID = '${param.id}' CONNECT BY PRIOR CATEGORY_ID = CATEGORY_PARENT_ID)
					<e:if condition="${param.name!=''&&param.name!=null}">
						AND T.KPI_NAME LIKE '%${param.name}%'
					</e:if>
					<e:if condition="${null!=param.status&&''!=param.status}">
						AND T.KPI_STATUS='${param.status}'
					</e:if>
					ORDER BY T.CREATE_DATETIME DESC
			</c:tablequery>
		</e:if>
	</e:case>
	<e:case value="createCategory">
		<e:update var="insert">
			begin 
				insert into x_kpi_category (category_id,category_parent_id,category_isleaf,category_name,category_desc,category_createtime,category_createuser) values(
				X_KPI_INFO_SEQ.nextval,'${param.category_id}','${param.c_leaf}','${param.c_name}','${param.c_desc}',sysdate,'${sessionScope.UserInfo.USER_ID}');
			end;
		</e:update>${insert}
	</e:case>
	<e:case value="validateName">
		<e:q4o var="count">
			select count(0) num from x_kpi_category t where t.category_parent_id='${param.category_id}' and  t.category_name='${param.category_name}'
		</e:q4o>${count.num}
	</e:case>
	<e:case value="deleteKpi">
		<e:update var="delete">
			begin
				DELETE FROM X_KPI_INFO WHERE KPI_KEY='${param.kpi_key}'; 
				update x_kpi_info_tmp t set t.kpi_flag='D' where t.kpi_key='${param.kpi_key}';
			end;
		</e:update>${delete}
	</e:case>
	<e:case value="beforeEditCategory">
		<e:q4o var="bec">
			select category_name e_name,category_desc e_desc from x_kpi_category where category_id='${param.category_id}'
		</e:q4o>${e:java2json(bec)}
	</e:case>
	<e:case value="editCategory">
		<e:update var="ec">
			begin 
				update x_kpi_category set category_name='${param.E_NAME}',category_desc='${param.E_DESC}' where category_id='${param.ec_id}';
			end;
		</e:update>${ec}
	</e:case>
	<e:case value="beforePublishKpi">
		<e:q4o var="bpk">
			select count(0) num from x_kpi_info_tmp where kpi_status='1' and kpi_key='${param.kpi_key}'
		</e:q4o>${bpk.num}
	</e:case>	
	<e:case value="pubKpi">
		<e:update var="pk">
			begin 
				update x_kpi_info_tmp set kpi_status='1' where kpi_key='${param.kpi_key}';
			end;
		</e:update>${e:java2json(pk)}
	</e:case>
	<e:case value="log">
		<c:tablequery>
		SELECT Z.V0,Z.V1,Z.V2,Z.V3,Z.V4,Z.V5,Z.V6,Z.V7,Z.V8,Z.V9,Z.V10 FROM (
			SELECT TT.SERVICE_KEY V0, T.LOG_KEY V1,T.KPI_VERSION V2, DECODE(T.LOG_ACTION,'U','更新','I','新增','D','删除') V3, T.LOG_USER V4,TT.KPI_NAME V5,T.LOG_USER V6,TO_CHAR(T.LOG_DATETIME,'YYYY-MM-DD hh24:mi:ss') V7,T.LOG_IP V8,T.KPI_CODE V9,TT.KPI_KEY||'' V10  FROM X_KPI_LOG T,X_KPI_INFO_TMP TT WHERE  T.KPI_CODE=TT.KPI_CODE AND T.KPI_VERSION=TT.KPI_VERSION 
			<e:if condition="${param.kpi_key !=null && param.kpi_key != ''}">
				AND T.KPI_KEY='${param.kpi_key}' 
			</e:if>
			<e:if condition="${param.cube_code != null && param.cube_code != ' ' }">
				AND TT.CUBE_CODE = '${param.cube_code}'
			</e:if>
			<e:if condition="${param.kpi_name != null && param.kpi_name != '' }">
				AND TT.KPI_NAME LIKE '%${param.kpi_name}%'
			</e:if>
			<e:if condition="${param.log_action != null && param.log_action != ' ' }">
				AND T.LOG_ACTION = '${param.log_action}'
			</e:if>
			<e:if condition="${param.kpi_category!=0 &&param.kpi_category!=''&&param.kpi_category!=null }">
		  		AND TT.KPI_CATEGORY IN (SELECT X.CATEGORY_ID FROM X_KPI_CATEGORY X START WITH X.CATEGORY_ID=${param.kpi_category } CONNECT BY PRIOR X.CATEGORY_ID = X.CATEGORY_PARENT_ID) 
		 	</e:if>
			union all
			SELECT TT.KPI_CODE V0, T.LOG_KEY V1,T.KPI_VERSION V2, DECODE(T.LOG_ACTION,'U','更新','I','新增','D','删除') V3, T.LOG_USER V4,TT.KPI_NAME V5,T.LOG_USER V6,TO_CHAR(T.LOG_DATETIME,'YYYY-MM-DD hh24:mi:ss') V7,T.LOG_IP V8,T.KPI_CODE V9,TT.ID V10  FROM X_KPI_LOG T,X_BASE_KPI TT WHERE  T.KPI_CODE=TT.BASE_KEY AND T.KPI_VERSION=TT.KPI_VERSION
			<e:if condition="${param.kpi_key !=null && param.kpi_key != ''}">
				AND T.KPI_KEY='${param.kpi_key}' 
			</e:if>
			<e:if condition="${param.cube_code != null && param.cube_code != ' ' }">
				AND TT.CUBE_CODE = '${param.cube_code}'
			</e:if>
			<e:if condition="${param.kpi_name != null && param.kpi_name != '' }">
				AND TT.KPI_NAME LIKE '%${param.kpi_name}%'
			</e:if>
			<e:if condition="${param.log_action != null && param.log_action != ' ' }">
				AND T.LOG_ACTION = '${param.log_action}'
			</e:if>
			<e:if condition="${param.kpi_category!=0 &&param.kpi_category!=''&&param.kpi_category!=null }">
		  		AND TT.KPI_CATEGORY IN (SELECT X.CATEGORY_ID FROM X_KPI_CATEGORY X START WITH X.CATEGORY_ID=${param.kpi_category } CONNECT BY PRIOR X.CATEGORY_ID = X.CATEGORY_PARENT_ID) 
		  	</e:if>
		  	) Z
		  	ORDER BY Z.V7 DESC
		</c:tablequery>
	</e:case>
	<e:case value="beforeDeleteCategory">
		<e:q4o var="bdc">
			select count(0) num from x_kpi_info_tmp where kpi_category='${param.category_id}' and kpi_flag!='D'
		</e:q4o>${bdc.num}
	</e:case>
	<e:case value="deleteCategory">
		<e:update var="dc">
			begin 
				update x_kpi_category t set category_flag='D' where t.category_id='${param.category_id}';
			end;
		</e:update>${dc}
	</e:case>			
</e:switch>	