<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@page import="java.io.File"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="rootObj">
	SELECT COUNT(1) IS_ROOT FROM X_USER_ROLE TTT WHERE TTT.USER_ID='${sessionScope.UserInfo.USER_ID}' AND TTT.ROLE_CODE='0'
</e:q4o>
<%-- <e:q4o var="AreaNoExt">
	 select COLUMN_NAME AREA_CONTROL_FRAME_COLUMN  from X_USER_EXT_COLUMN_ATTR t where ATTR_CODE='AREA_CONTROL_FRAME'
</e:q4o>
 --%><e:switch value="${param.eaction}">
	<e:case value="loardTree">
		<e:if condition="${param.id==null||param.id==''}">
			<e:q4o var="rootNum">
				SELECT COUNT(1) ROOTNUM FROM X_ROLE T WHERE T.ROLE_CODE='0'
			</e:q4o>
			<e:if condition="${rootNum.ROOTNUM<1}">
				<e:update>
					INSERT INTO X_ROLE(ROLE_CODE,PARENT_CODE,ROLE_NAME,MEMO,ORD) VALUES('0','-1','root','',0)
				</e:update>
			</e:if>
			<e:q4o var="nullNumObj">
				SELECT COUNT(1) ROOTNUM FROM X_ROLE T WHERE T.PARENT_CODE IS NULL
			</e:q4o>
			<e:if condition="${nullNumObj.ROOTNUM>0}">
				<e:update>
					UPDATE X_ROLE T SET T.PARENT_CODE='0' WHERE T.PARENT_CODE IS NULL
				</e:update>
			</e:if>
			
			<e:q4o var="rootObj">
				SELECT ROLE_CODE ,ROLE_NAME  FROM X_ROLE T WHERE T.ROLE_CODE ='0'
			</e:q4o>
			[
				{
				"id":${rootObj.ROLE_CODE},
				"text":"${rootObj.ROLE_NAME}",
				"attributes":{
							},
				"children":[
					<e:q4l var="childrenListForRoot">
					
						<e:if condition="${sessionScope.UserInfo.ADMIN!='1'&&rootObj.IS_ROOT=='0'}">
							    
							SELECT ISLEAF,
							       role_code,
							       role_name
							FROM(
							
							      SELECT CONNECT_BY_ISLEAF ISLEAF,
							                   LEVEL LEVEL1,
							                   role_code,
							                   role_name,
							                   ORD
							              FROM (
							                       select distinct role_code, role_name, parent_code ,ORD from (
							                          SELECT role_code, role_name, parent_code ,ORD
							                            FROM X_role T
							                           start with T.role_code in(SELECT ROLE_CODE FROM x_USER_ROLE WHERE USER_ID='${sessionScope.UserInfo.USER_ID}')
							                          connect by PRIOR t.parent_code = t.role_code
							                          union all
							                          SELECT role_code, role_name,parent_code, ORD
							                            FROM X_role T
							                           start with T.parent_code in(SELECT ROLE_CODE FROM X_USER_ROLE WHERE USER_ID='${sessionScope.UserInfo.USER_ID}')
							                          connect by PRIOR t.role_code = t.parent_code
							                      )
							              
							                  ) T
							             where level=1
							             start with T.parent_code = '${rootObj.ROLE_CODE }'
							            connect by PRIOR t.role_code = t.parent_code 
							            ORDER BY ORD
							)
						 </e:if>
						 <e:if condition="${sessionScope.UserInfo.ADMIN=='1'||rootObj.IS_ROOT!='0'}">
								SELECT ISLEAF,
								       ROLE_CODE ,
								       ROLE_NAME
								  FROM (SELECT CONNECT_BY_ISLEAF ISLEAF,
								               LEVEL LEVEL1,
								               ROLE_CODE ,
								               ROLE_NAME ,
								               ORD
								          FROM X_ROLE T
								         START WITH T.PARENT_CODE  = '${rootObj.ROLE_CODE }'
								        CONNECT BY PRIOR T.ROLE_CODE  = T.PARENT_CODE ) TT
								 WHERE TT.LEVEL1 = 1
								 ORDER BY TT.ORD
						 </e:if>
					</e:q4l>
					<e:forEach items="${childrenListForRoot.list}" var="item">
						<e:if condition="${index>0}">
							,
						</e:if>
						{
							"id":${item.ROLE_CODE },
							"text":"${item.ROLE_NAME }",
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
		<e:if condition="${param.id!=null&&param.id!=''}">
			<e:q4l var="childrenListForId">
				
				 <e:if condition="${sessionScope.UserInfo.ADMIN=='1'||rootObj.IS_ROOT=='0'}">
				 	SELECT ISLEAF,
					       ROLE_CODE ,
					       ROLE_NAME
					  FROM (SELECT CONNECT_BY_ISLEAF ISLEAF,
					               LEVEL LEVEL1,
					               ROLE_CODE,
					               ROLE_NAME,
					               ORD
					          FROM (select distinct ROLE_CODE, ROLE_NAME, ORD, PARENT_CODE
					                  from (select *
					                          from X_role
					                         where role_code in
					                               (SELECT ROLE_CODE
					                                  FROM X_ROLE T
					                                 START WITH T.ROLE_CODE IN
					                                            (SELECT ROLE_CODE
					                                               FROM X_USER_ROLE
					                                              WHERE USER_ID = '${sessionScope.UserInfo.USER_ID}')
					                                CONNECT BY T.ROLE_CODE = PRIOR T.PARENT_CODE
					                                union all
					                                SELECT ROLE_CODE
					                                  FROM X_ROLE T
					                                 START WITH T.ROLE_CODE IN
					                                            (SELECT ROLE_CODE
					                                               FROM X_USER_ROLE
					                                              WHERE USER_ID = '${sessionScope.UserInfo.USER_ID}')
					                                CONNECT BY PRIOR T.ROLE_CODE = T.PARENT_CODE))) T
					         START WITH T.PARENT_CODE = '${param.id }'
					        CONNECT BY PRIOR T.ROLE_CODE = T.PARENT_CODE) TT
					
					 WHERE TT.LEVEL1 = 1
					 ORDER BY TT.ORD
				</e:if>
				<e:if condition="${sessionScope.UserInfo.ADMIN!='1'&&rootObj.IS_ROOT!='0'}">
					SELECT ISLEAF,
					       role_code,
					       role_name
					FROM(
								SELECT CONNECT_BY_ISLEAF ISLEAF,
					                   LEVEL LEVEL1,
					                   role_code,
					                   role_name,
					                   ORD
					              FROM (
					                       select distinct role_code, role_name, parent_code ,ORD from (
					                          SELECT role_code, role_name, parent_code ,ORD
					                            FROM X_role T
					                           start with T.role_code in(SELECT ROLE_CODE FROM X_USER_ROLE WHERE USER_ID='${sessionScope.UserInfo.USER_ID}')
					                          connect by PRIOR t.parent_code = t.role_code
					                          union all
					                          SELECT role_code, role_name,parent_code, ORD
					                            FROM X_role T
					                           start with T.parent_code in(SELECT ROLE_CODE FROM X_USER_ROLE WHERE USER_ID='${sessionScope.UserInfo.USER_ID}')
					                          connect by PRIOR t.role_code = t.parent_code
					                      )
					              
					                  ) T
					             where level=1
					             start with T.parent_code = '${param.id }'
					            connect by PRIOR t.role_code = t.parent_code ORDER BY ORD
					)
				 </e:if>
			
			</e:q4l>
			[
				<e:forEach items="${childrenListForId.list}" var="item">
					<e:if condition="${index>0}">
						,
					</e:if>
					{
						"id":${item.ROLE_CODE },
						"text":"${item.ROLE_NAME }",
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
	
	<e:case value="checkRoleName">
		<e:q4o var="roleNameCount">
			SELECT COUNT(1) ROLE_NAME_NUM FROM X_ROLE T WHERE T.ROLE_NAME='${param.roleName }' AND T.PARENT_CODE='${param.parentId }'
		</e:q4o>${roleNameCount.ROLE_NAME_NUM}
	</e:case>
	
	<e:case value="addTreeNode">
		<e:q4o var="seqIdObj">
			SELECT X_ROLE_SEQ.Nextval SEQ_ID FROM DUAL
		</e:q4o>
		<e:update var="insertTreeNode">
			INSERT INTO X_ROLE(ROLE_CODE,PARENT_CODE,ROLE_NAME,MEMO,ORD,SUBSYSTEM_ID) VALUES('${seqIdObj.SEQ_ID }',#parentIdForAdd#,'${param.roleNameForAdd }','${param.memoForAdd }',#ordForAdd#,#subSystemIdForAdd#)
		</e:update>${insertTreeNode }
	</e:case>
	
	
	<e:case value="deleteTreeNode">
		<e:q4o var="treeNodeObj">
			SELECT ROLE_CODE,ROLE_NAME FROM X_ROLE WHERE ROLE_CODE = '${param.currentNodeId }'
		</e:q4o>
		<e:update var="deleteTreeNodeWithChildren">
			begin
				DELETE FROM X_USER_ROLE TTT WHERE EXISTS(
				SELECT 1 FROM E_ROLE T
				        WHERE T.ROLE_CODE=TTT.ROLE_CODE
				       START WITH T.ROLE_CODE = '${param.currentNodeId }'
				      CONNECT BY PRIOR T.ROLE_CODE = T.PARENT_CODE
				); 
				
				DELETE FROM X_ROLE_KPI TTT WHERE EXISTS(
				SELECT 1 FROM X_ROLE T
				        WHERE T.ROLE_CODE=TTT.ROLE_CODE
				       START WITH T.ROLE_CODE = '${param.currentNodeId }'
				      CONNECT BY PRIOR T.ROLE_CODE = T.PARENT_CODE
				); 
				
				DELETE FROM X_ROLE TTT WHERE EXISTS(
					SELECT 1 FROM X_ROLE T
				        WHERE T.ROLE_CODE=TTT.ROLE_CODE
				       START WITH T.ROLE_CODE = '${param.currentNodeId }'
				      CONNECT BY PRIOR T.ROLE_CODE = T.PARENT_CODE
				); 
			end;
		</e:update>${deleteTreeNodeWithChildren }
	</e:case>
	
	<e:case value="getOneTreeNode">
		<e:q4o var="oneTreeNodeObj">
			SELECT ROLE_CODE, PARENT_CODE, ROLE_NAME, NVL(MEMO,'') MEMO , ORD,nvl(SUBSYSTEM_ID,'-1') SUBSYSTEM_ID FROM X_ROLE WHERE ROLE_CODE='${param.currentIdForEdite }'
		</e:q4o>${e:java2json(oneTreeNodeObj)}
	</e:case>
	
	<e:case value="editeTreeNode">
		<e:update var="updateTreeNode">
			BEGIN
				UPDATE X_ROLE T SET T.ROLE_NAME=#roleNameForEdite#,
				                    T.MEMO=#memoForEdite#,
				                    T.ORD=#ordForEdite#,
				              		T.SUBSYSTEM_ID=#subSystemIdForEdite#
				WHERE T.ROLE_CODE=#currentIdForEdite#;
			END;
		</e:update>${updateTreeNode }
	</e:case>
	
	<e:case value="cutToOthers">
		<e:q4o var="targetObj">
			SELECT ROLE_CODE, PARENT_CODE, ROLE_NAME, NVL(MEMO,'') MEMO , ORD FROM X_ROLE WHERE ROLE_CODE='${param.targetId }'
		</e:q4o>
		<e:update var="updateCutToOthers">
			UPDATE X_ROLE SET PARENT_CODE='${param.targetId }' WHERE ROLE_CODE='${param.sourceId }'
		</e:update>${updateCutToOthers }
	</e:case>
	
	
	
	<e:case value="getHasSelectUsers">
		<%
		String userName = request.getParameter("userName"); 
		userName = userName!=null?new String(request.getParameter("userName").getBytes("ISO-8859-1"),"GBK"):""; 
		request.setAttribute("userName",userName); 
		%>
		<c:tablequery>
			SELECT T.USER_ID, T.LOGIN_ID, T.USER_NAME
			  FROM (SELECT DISTINCT T1.USER_ID, T1.LOGIN_ID, T1.USER_NAME
			          FROM e_USER T1,
			               (SELECT A1.USER_ID, A2.*
			                  FROM X_USER_ROLE A1, X_ROLE A2
			                 WHERE A1.ROLE_CODE = A2.ROLE_CODE) T2
			         WHERE T1.USER_ID = T2.USER_ID(+)
			           <e:if condition="${sessionScope.UserInfo.AREA_ID!=null&&sessionScope.UserInfo.AREA_ID!=''&&sessionScope.UserInfo.AREA_ID=='-1'}">
					   AND 1 = 1
					   </e:if>
					    <e:if condition="${sessionScope.UserInfo.AREA_CONTROL_FRAME!=null&&sessionScope.UserInfo.AREA_CONTROL_FRAME!=''&&sessionScope.UserInfo.AREA_CONTROL_FRAME!='-1'}">
						   <e:if condition="${AreaNoExt.AREA_CONTROL_FRAME_COLUMN!=null&&AreaNoExt.AREA_CONTROL_FRAME_COLUMN!=null&&AreaNoExt.AREA_CONTROL_FRAME_COLUMN!=''}">
						    	and t1.${AreaNoExt.AREA_CONTROL_FRAME_COLUMN} = '${sessionScope.UserInfo.AREA_CONTROL_FRAME}'
						   		and t1.${AreaNoExt.AREA_CONTROL_FRAME_COLUMN} != '-1'
						    </e:if>
						   
					   </e:if>
			        ) T
			 WHERE EXISTS (SELECT 1
			          FROM X_USER_ROLE A
			         WHERE A.ROLE_CODE = '${param.currentNodeId }'
			           AND A.USER_ID = T.USER_ID)
			       <e:if condition="${param.loginId!=null&&param.loginId!=''}">
				   		and LOGIN_ID like '%${param.loginId }%'
				   </e:if>
				   <e:if condition="${param.userName!=null&&param.userName!=''}">
				   		and USER_NAME LIKE '%'||'${param.userName }'||'%'
				   </e:if>
			 ORDER BY LOGIN_ID
		</c:tablequery>
	</e:case>
	<e:case value="removeUser">
		<e:q4o var="userAndRoleObj">
			SELECT T1.USER_ID, T1.LOGIN_ID, T1.USER_NAME, T2.ROLE_CODE, T2.ROLE_NAME
			  FROM X_USER_ROLE T, X_USER T1, X_ROLE T2
			 WHERE T.USER_ID = T1.USER_ID(+)
			   AND T.ROLE_CODE = T2.ROLE_CODE(+)
			   AND T.ROLE_CODE = #roleCode#
			   AND T.USER_ID = #userId#
			   AND ROWNUM < 2
						
		</e:q4o>
		<e:update var="deleteUser">
			DELETE FROM X_USER_ROLE WHERE ROLE_CODE=#roleCode# AND USER_ID=#userId#
		</e:update>${deleteUser }
		
	</e:case>
	
	<e:case value="getNeedSelectUsers">
		<%
		String userName = request.getParameter("userName"); 
		userName = userName!=null?new String(request.getParameter("userName").getBytes("ISO-8859-1"),"UTF-8"):""; 
		request.setAttribute("userName",userName); 
		%>
		<c:tablequery>
			SELECT T.USER_ID, T.LOGIN_ID, T.USER_NAME
			  FROM (SELECT DISTINCT T1.USER_ID, T1.LOGIN_ID, T1.USER_NAME
			          FROM E_USER T1,
			               (SELECT A1.USER_ID, A2.*
			                  FROM X_USER_ROLE A1, X_ROLE A2
			                 WHERE A1.ROLE_CODE = A2.ROLE_CODE) T2
			         WHERE T1.USER_ID = T2.USER_ID(+)
			         <e:if condition="${sessionScope.UserInfo.AREA_ID!=null&&sessionScope.UserInfo.AREA_ID!=''&&sessionScope.UserInfo.AREA_ID=='-1'}">
					   AND 1 = 1
					   </e:if>
					   <e:if condition="${sessionScope.UserInfo.AREA_CONTROL_FRAME!=null&&sessionScope.UserInfo.AREA_CONTROL_FRAME!=''&&sessionScope.UserInfo.AREA_CONTROL_FRAME!='-1'}">
					    <e:if condition="${AreaNoExt.AREA_CONTROL_FRAME_COLUMN!=null&&AreaNoExt.AREA_CONTROL_FRAME_COLUMN!=null&&AreaNoExt.AREA_CONTROL_FRAME_COLUMN!=''}">
					    	and t1.${AreaNoExt.AREA_CONTROL_FRAME_COLUMN} = '${sessionScope.UserInfo.AREA_CONTROL_FRAME}'
					   		and t1.${AreaNoExt.AREA_CONTROL_FRAME_COLUMN} != '-1'
					    </e:if>
					 </e:if>
			        ) T
			 WHERE NOT EXISTS (SELECT 1
			          FROM X_USER_ROLE A
			         WHERE A.ROLE_CODE = '${param.currentNodeId }'
			           AND A.USER_ID = T.USER_ID)
			       <e:if condition="${param.loginId!=null&&param.loginId!=''}">
				   		and LOGIN_ID like '%${param.loginId }%'
				   </e:if>
				   <e:if condition="${param.userName!=null&&param.userName!=''}">
				   		and USER_NAME LIKE '%'||'${param.userName }'||'%'
				   </e:if>
			 ORDER BY LOGIN_ID
		</c:tablequery>
	</e:case>
	<e:case value="addUser">
		
		<e:update var="insertUser">
			INSERT INTO X_USER_ROLE(ROLE_CODE,USER_ID) VALUES(#roleCode#,#userId#)
		</e:update>${insertUser }
		<e:q4o var="userAndRoleObj">
			SELECT T1.USER_ID, T1.LOGIN_ID, T1.USER_NAME, T2.ROLE_CODE, T2.ROLE_NAME
			  FROM x_USER_ROLE T, e_USER T1, x_ROLE T2
			 WHERE T.USER_ID = T1.USER_ID(+)
			   AND T.ROLE_CODE = T2.ROLE_CODE(+)
			   AND T.ROLE_CODE = #roleCode#
			   AND T.USER_ID = #userId#
			   AND ROWNUM < 2
						
		</e:q4o>
	</e:case>
	
	
	
	<e:case value="authOpera">
		<e:if condition="${sessionScope.UserInfo.ADMIN!='1'&&rootObj.IS_ROOT=='0'}">
			<e:q4l var="roleMenus">
				select * from (
					SELECT I.RESOURCES_ID,
					       I.RESOURCES_NAME,
					       #roleId# ROLE_CODE,
					       NVL(I.AUTH_CREATE,0) AUTH_CREATE,
					       NVL(I.AUTH_READ,0) AUTH_READ,
					       NVL(I.AUTH_UPDATE,0) AUTH_UPDATE,
					       NVL(I.AUTH_DELETE,0) AUTH_DELETE,
					       NVL(I.AUTH_EXPORT,0) AUTH_EXPORT,
					       NVL(I.AUTH_ISSUED,0) AUTH_ISSUED,
					       case
					         when I.parent_id = '-1' then
					          null
					         else
					          I.parent_id
					       end "_parentId",
					       DECODE(CONNECT_BY_ISLEAF, '0', 'closed', 'open') "state",
					       level level_num,
					       I.ORD
					FROM
					    ( 
					      SELECT X.*,Y.* FROM (
					                        SELECT A.RESOURCES_ID,A.RESOURCES_NAME,A.PARENT_ID,A.ORD FROM E_MENU A WHERE EXISTS ( 
					                                 SELECT 1 FROM (SELECT DISTINCT T.MENU_ID FROM E_ROLE_PERMISSION T WHERE EXISTS(SELECT 1 FROM x_USER_ROLE T1 WHERE T1.USER_ID='${sessionScope.UserInfo.USER_ID }' AND T1.ROLE_CODE=T.ROLE_CODE) AND T.AUTH_ISSUED='1') WHERE MENU_ID=A.RESOURCES_ID
					                         
					                        )
					                     ) X,
					                     (SELECT Q.MENU_ID,SUM(Q.AUTH_CREATE) AUTH_CREATE,SUM(Q.AUTH_READ) AUTH_READ,SUM(Q.AUTH_UPDATE) AUTH_UPDATE,SUM(Q.AUTH_DELETE) AUTH_DELETE,SUM(Q.AUTH_EXPORT) AUTH_EXPORT,SUM(Q.AUTH_ISSUED) AUTH_ISSUED FROM E_ROLE_PERMISSION Q WHERE Q.ROLE_CODE=#roleId# GROUP BY Q.MENU_ID) Y
					      WHERE X.RESOURCES_ID = Y.MENU_ID(+)     
					    )  I  start with I.resources_id = '0'
					connect by PRIOR I.resources_id = I.parent_id
				) W1 where W1.RESOURCES_ID='0' OR EXISTS(SELECT 1 FROM (SELECT RESOURCES_ID FROM E_MENU START WITH RESOURCES_ID='${param.defaultFirstLevelMenu }' connect by PRIOR resources_id = parent_id) W2 WHERE W1.RESOURCES_ID=W2.RESOURCES_ID)
 				order by ORD
				
			</e:q4l>{"rows":${e:java2json(roleMenus.list)}}
		</e:if>
		<e:if condition="${sessionScope.UserInfo.ADMIN=='1'||rootObj.IS_ROOT!='0'}">
			<e:q4l var="roleMenus">
				select * from (
					SELECT I.RESOURCES_ID,
					       I.RESOURCES_NAME,
					       #roleId# ROLE_CODE,
					       NVL(I.AUTH_CREATE,0) AUTH_CREATE,
					       NVL(I.AUTH_READ,0) AUTH_READ,
					       NVL(I.AUTH_UPDATE,0) AUTH_UPDATE,
					       NVL(I.AUTH_DELETE,0) AUTH_DELETE,
					       NVL(I.AUTH_EXPORT,0) AUTH_EXPORT,
					       NVL(I.AUTH_ISSUED,0) AUTH_ISSUED,
					       case
					         when I.parent_id = '-1' then
					          null
					         else
					          I.parent_id
					       end "_parentId",
					       DECODE(CONNECT_BY_ISLEAF, '0', 'closed', 'open') "state",
					       level level_num,
					       I.ORD
					FROM
					    ( 
					      SELECT X.*,Y.* FROM (
					                        SELECT A.RESOURCES_ID,A.RESOURCES_NAME,A.PARENT_ID,A.ORD FROM E_MENU A
					                     ) X,
					                     (SELECT Q.MENU_ID,SUM(Q.AUTH_CREATE) AUTH_CREATE,SUM(Q.AUTH_READ) AUTH_READ,SUM(Q.AUTH_UPDATE) AUTH_UPDATE,SUM(Q.AUTH_DELETE) AUTH_DELETE,SUM(Q.AUTH_EXPORT) AUTH_EXPORT,SUM(Q.AUTH_ISSUED) AUTH_ISSUED FROM E_ROLE_PERMISSION Q WHERE Q.ROLE_CODE=#roleId# GROUP BY Q.MENU_ID) Y
					      WHERE X.RESOURCES_ID = Y.MENU_ID(+)     
					    )  I  start with I.resources_id = '0'
					connect by PRIOR I.resources_id = I.parent_id
				) W1 where W1.RESOURCES_ID='0' OR EXISTS(SELECT 1 FROM (SELECT RESOURCES_ID FROM E_MENU START WITH RESOURCES_ID='${param.defaultFirstLevelMenu }' connect by PRIOR resources_id = parent_id) W2 WHERE W1.RESOURCES_ID=W2.RESOURCES_ID)
 				order by ORD
			</e:q4l>{"rows":${e:java2json(roleMenus.list)}}
		</e:if>
		
	</e:case>
</e:switch>