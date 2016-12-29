<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@page import="java.io.File"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:switch value="${param.eaction}">
	<e:case value="loardTree">
		<e:if condition="${param.id==null||param.id==''}">
			<e:q4o var="rootNum">
				select count(1) ROOTNUM from e_menu t where t.resources_id='0'
			</e:q4o>
			<e:if condition="${rootNum.ROOTNUM<1}">
				<e:update>
					insert into e_menu(resources_id,resources_name,resources_type,ord) values('0','菜单管理','1',0)
				</e:update>
			</e:if>
			<e:q4o var="rootObj">
				SELECT RESOURCES_ID,RESOURCES_NAME FROM E_MENU T WHERE T.RESOURCES_ID='0'
			</e:q4o>
			[
				{
				"id":${rootObj.RESOURCES_ID},
				"text":"${rootObj.RESOURCES_NAME}",
				"attributes":{
								"authCreate":1,
								"authUpdate":0,
								"authDelete":0
							},
				"children":[
					<e:q4l var="childrenListForRoot">
					
						<e:if condition="${sessionScope.UserInfo.ADMIN!='1'}">
							SELECT ISLEAF,
							       RESOURCES_ID,
							       RESOURCES_NAME,
							       NVL(Y.AUTH_CREATE,0) AUTH_CREATE,
							       NVL(Y.AUTH_READ,0) AUTH_READ,
							       NVL(Y.AUTH_UPDATE,0) AUTH_UPDATE,
							       NVL(Y.AUTH_DELETE,0) AUTH_DELETE
							  FROM (SELECT ISLEAF, RESOURCES_ID, RESOURCES_NAME
							          FROM (SELECT CONNECT_BY_ISLEAF ISLEAF,
							                       LEVEL LEVEL1,
							                       RESOURCES_ID,
							                       RESOURCES_NAME,
							                       ORD
							                  FROM E_MENU T where T.EXT1='${param.subSysId}'
							                 start with T.parent_id = '${rootObj.RESOURCES_ID }'
							                connect by PRIOR t.resources_id = t.parent_id) TT
							         WHERE TT.LEVEL1 = 1  ORDER BY ORD) X,
							       (SELECT MENU_ID,
							               SUM(NVL(AUTH_CREATE, 0)) AUTH_CREATE,
							               SUM(NVL(AUTH_READ, 0)) AUTH_READ,
							               SUM(NVL(AUTH_UPDATE, 0)) AUTH_UPDATE,
							               SUM(NVL(AUTH_DELETE, 0)) AUTH_DELETE
							          FROM (SELECT MENU_ID,
							                       AUTH_CREATE,
							                       AUTH_READ,
							                       AUTH_UPDATE,
							                       AUTH_DELETE
							                  FROM E_USER_PERMISSION
							                 WHERE USER_ID = '${sessionScope.UserInfo.USER_ID}'
							                UNION ALL
							                SELECT A.MENU_ID,
							                       A.AUTH_CREATE,
							                       A.AUTH_READ,
							                       A.AUTH_UPDATE,
							                       A.AUTH_DELETE
							                  FROM E_ROLE_PERMISSION A, E_USER_ROLE B
							                 WHERE A.ROLE_CODE(+) = B.ROLE_CODE
							                   AND B.USER_ID = '${sessionScope.UserInfo.USER_ID}')
							         GROUP BY MENU_ID) Y
							 WHERE X.RESOURCES_ID = Y.MENU_ID
						 </e:if>
						 <e:if condition="${sessionScope.UserInfo.ADMIN=='1'}">
						 	SELECT ISLEAF,RESOURCES_ID,RESOURCES_NAME,1 AUTH_CREATE,1 AUTH_READ,1 AUTH_UPDATE,1 AUTH_DELETE FROM (SELECT CONNECT_BY_ISLEAF ISLEAF,LEVEL LEVEL1,RESOURCES_ID,RESOURCES_NAME,ORD FROM E_MENU  T where T.EXT1='${param.subSysId}' start with T.parent_id='${rootObj.RESOURCES_ID }' connect by PRIOR t.resources_id=t.parent_id) TT WHERE TT.LEVEL1=1 ORDER BY TT.ORD
						 </e:if>
					</e:q4l>
					<e:forEach items="${childrenListForRoot.list}" var="item">
						<e:if condition="${index>0}">
							,
						</e:if>
						{
							"id":${item.RESOURCES_ID },
							"text":"${item.RESOURCES_NAME }",
							<e:if condition="${item.ISLEAF==0}">
							"state":"closed",
							</e:if>
							"attributes":{
								"authCreate":${item.AUTH_CREATE },
								"authUpdate":${item.AUTH_UPDATE },
								"authDelete":${item.AUTH_DELETE }
							}
						}
					</e:forEach>
					
					
				]
				}
			]
		</e:if>
		<e:if condition="${param.id!=null&&param.id!=''}">
			<e:q4l var="childrenListForId">
				<e:if condition="${sessionScope.UserInfo.ADMIN!='1'}">
					SELECT ISLEAF,
					       RESOURCES_ID,
					       RESOURCES_NAME,
					       NVL(Y.AUTH_CREATE,0) AUTH_CREATE,
					       NVL(Y.AUTH_READ,0) AUTH_READ,
					       NVL(Y.AUTH_UPDATE,0) AUTH_UPDATE,
					       NVL(Y.AUTH_DELETE,0) AUTH_DELETE
					  FROM (SELECT ISLEAF, RESOURCES_ID, RESOURCES_NAME
					          FROM (SELECT CONNECT_BY_ISLEAF ISLEAF,
					                       LEVEL LEVEL1,
					                       RESOURCES_ID,
					                       RESOURCES_NAME,
					                       ORD
					                  FROM E_MENU T where T.EXT1='${param.subSysId}'
					                 start with T.parent_id = '${param.id }'
					                connect by PRIOR t.resources_id = t.parent_id) TT
					         WHERE TT.LEVEL1 = 1 ORDER BY ORD) X,
					       (SELECT MENU_ID,
					               SUM(NVL(AUTH_CREATE, 0)) AUTH_CREATE,
					               SUM(NVL(AUTH_READ, 0)) AUTH_READ,
					               SUM(NVL(AUTH_UPDATE, 0)) AUTH_UPDATE,
					               SUM(NVL(AUTH_DELETE, 0)) AUTH_DELETE
					          FROM (SELECT MENU_ID,
					                       AUTH_CREATE,
					                       AUTH_READ,
					                       AUTH_UPDATE,
					                       AUTH_DELETE
					                  FROM E_USER_PERMISSION
					                 WHERE USER_ID = '${sessionScope.UserInfo.USER_ID}'
					                UNION ALL
					                SELECT A.MENU_ID,
					                       A.AUTH_CREATE,
					                       A.AUTH_READ,
					                       A.AUTH_UPDATE,
					                       A.AUTH_DELETE
					                  FROM E_ROLE_PERMISSION A, E_USER_ROLE B
					                 WHERE A.ROLE_CODE(+) = B.ROLE_CODE
					                   AND B.USER_ID = '${sessionScope.UserInfo.USER_ID}')
					         GROUP BY MENU_ID) Y
					 WHERE X.RESOURCES_ID = Y.MENU_ID
				 </e:if>
				 <e:if condition="${sessionScope.UserInfo.ADMIN=='1'}">
				 	SELECT ISLEAF,RESOURCES_ID,RESOURCES_NAME,1 AUTH_CREATE,1 AUTH_READ,1 AUTH_UPDATE,1 AUTH_DELETE FROM (SELECT CONNECT_BY_ISLEAF ISLEAF,LEVEL LEVEL1,RESOURCES_ID,RESOURCES_NAME,ORD FROM E_MENU T where T.EXT1='${param.subSysId}' start with T.parent_id='${param.id  }' connect by PRIOR t.resources_id=t.parent_id) TT WHERE TT.LEVEL1=1 ORDER BY TT.ORD
				 </e:if>
			
			</e:q4l>
			[
				<e:forEach items="${childrenListForId.list}" var="item">
					<e:if condition="${index>0}">
						,
					</e:if>
					{
						"id":${item.RESOURCES_ID },
						"text":"${item.RESOURCES_NAME }",
						<e:if condition="${item.ISLEAF==0}">
						"state":"closed",
						</e:if>
						"attributes":{
									"authCreate":${item.AUTH_CREATE },
									"authUpdate":${item.AUTH_UPDATE },
									"authDelete":${item.AUTH_DELETE }
								}
					}
				</e:forEach>
			]
			
		</e:if>
	</e:case>
	
	
	
</e:switch>