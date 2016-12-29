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
				<e:if condition="${DBSource=='oracle' }">
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
							                  FROM E_MENU T
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
							   AND Y.AUTH_READ>0
						 </e:if>
						 <e:if condition="${sessionScope.UserInfo.ADMIN=='1'}">
						 	SELECT ISLEAF,RESOURCES_ID,RESOURCES_NAME,1 AUTH_CREATE,1 AUTH_READ,1 AUTH_UPDATE,1 AUTH_DELETE FROM (SELECT CONNECT_BY_ISLEAF ISLEAF,LEVEL LEVEL1,RESOURCES_ID,RESOURCES_NAME,ORD FROM E_MENU T start with T.parent_id='${rootObj.RESOURCES_ID }' connect by PRIOR t.resources_id=t.parent_id) TT WHERE TT.LEVEL1=1 ORDER BY TT.ORD
						 </e:if>
					</e:q4l>
					</e:if>
					<e:if condition="${DBSource=='mysql' }">
						<e:update>
							call showTreeByID('${rootObj.RESOURCES_ID }')
						</e:update>
						<e:q4l var="childrenListForRoot">
							<e:if condition="${sessionScope.UserInfo.ADMIN!='1'}">
								SELECT ISLEAF,           
       									RESOURCES_ID,        
       									RESOURCES_NAME,      
       									IFNULL(Y.AUTH_CREATE,0) AUTH_CREATE,   
									    IFNULL(Y.AUTH_READ,0) AUTH_READ,        
									    IFNULL(Y.AUTH_UPDATE,0) AUTH_UPDATE,     
									    IFNULL(Y.AUTH_DELETE,0) AUTH_DELETE      
								FROM ( 
								       SELECT ISLEAF,
								              RESOURCES_ID, 
								              RESOURCES_NAME    
									   FROM (
									           SELECT	(case when resources_id in(select parent_id from(select * from e_menu a,tmpLst b where a.resources_id=b.id order by a.resources_id,b.id) n ) then 0 else 1 end) ISLEAF ,
														nLevel level1,resources_id,resources_name, ORD 
									 			FROM 
								 				(select * from e_menu a,tmpLst b where a.resources_id=b.id) s           
										            ) TT  
										       WHERE TT.LEVEL1 = 1  ORDER BY ORD
										    ) X LEFT JOIN             
										    (
										      SELECT MENU_ID,                      
										             SUM(IFNULL(AUTH_CREATE, 0)) AUTH_CREATE,      
										             SUM(IFNULL(AUTH_READ, 0)) AUTH_READ,          
										             SUM(IFNULL(AUTH_UPDATE, 0)) AUTH_UPDATE,      
										             SUM(IFNULL(AUTH_DELETE, 0)) AUTH_DELETE       
										       FROM (
										             SELECT MENU_ID, 
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
										              FROM E_ROLE_PERMISSION A RIGHT JOIN  E_USER_ROLE B   
										              ON A.ROLE_CODE = B.ROLE_CODE        
										              AND B.USER_ID ='${sessionScope.UserInfo.USER_ID}'
										             ) ALAIS1                 
										             GROUP BY MENU_ID
										      ) Y         
										      ON X.RESOURCES_ID = Y.MENU_ID 
							</e:if>
							<e:if condition="${sessionScope.UserInfo.ADMIN=='1'}">
						 	SELECT ISLEAF,
						 	       RESOURCES_ID,
						 	       RESOURCES_NAME,
						 	       1 AUTH_CREATE,
						 	       1 AUTH_READ,
						 	       1 AUTH_UPDATE,
						 	       1 AUTH_DELETE 
						 	  FROM (
						 	       	SELECT	(case when resources_id in(select parent_id from(select * from e_menu a,tmpLst b where a.resources_id=b.id order by a.resources_id,b.id) n ) then 0 else 1 end) ISLEAF ,
  											nLevel level1,resources_id,resources_name, ORD 
  									FROM 
  									(select * from e_menu a,tmpLst b where a.resources_id=b.id) s          
 	          
						 	        ) TT 
						 	   WHERE TT.LEVEL1=1 ORDER BY TT.ORD
						 	
						 	</e:if>
						 	
						</e:q4l>
						<e:update>
							drop table tmpLst;
						</e:update>
					</e:if>
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
			<e:if condition="${DBSource=='oracle' }">
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
					                  FROM E_MENU T
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
					   AND Y.AUTH_READ>0
				 </e:if>
				 <e:if condition="${sessionScope.UserInfo.ADMIN=='1'}">
				 	SELECT ISLEAF,RESOURCES_ID,RESOURCES_NAME,1 AUTH_CREATE,1 AUTH_READ,1 AUTH_UPDATE,1 AUTH_DELETE FROM (SELECT CONNECT_BY_ISLEAF ISLEAF,LEVEL LEVEL1,RESOURCES_ID,RESOURCES_NAME,ORD FROM E_MENU T start with T.parent_id='${param.id  }' connect by PRIOR t.resources_id=t.parent_id) TT WHERE TT.LEVEL1=1 ORDER BY TT.ORD
				 </e:if>
			
				</e:q4l>
			</e:if>
			<e:if condition="${DBSource=='mysql' }">
				<e:update>
					call showTreeByID('${param.id}');
				</e:update>
				<e:q4l var="childrenListForId">
					<e:if condition="${sessionScope.UserInfo.ADMIN!='1'}">
						SELECT ISLEAF,           
       									RESOURCES_ID,        
       									RESOURCES_NAME,      
       									IFNULL(Y.AUTH_CREATE,0) AUTH_CREATE,   
									    IFNULL(Y.AUTH_READ,0) AUTH_READ,        
									    IFNULL(Y.AUTH_UPDATE,0) AUTH_UPDATE,     
									    IFNULL(Y.AUTH_DELETE,0) AUTH_DELETE      
								FROM ( 
								       SELECT ISLEAF,
								              RESOURCES_ID, 
								              RESOURCES_NAME    
									   FROM (
									           SELECT	(case when resources_id in(select parent_id from(select * from e_menu a,tmpLst b where a.resources_id=b.id order by a.resources_id,b.id) n ) then 0 else 1 end) ISLEAF ,
														nLevel level1,resources_id,resources_name, ORD 
									 			FROM 
								 				(select * from e_menu a,tmpLst b where a.resources_id=b.id) s           
										            ) TT  
										       WHERE TT.LEVEL1 = 1  ORDER BY ORD
										    ) X LEFT JOIN             
										    (
										      SELECT MENU_ID,                      
										             SUM(IFNULL(AUTH_CREATE, 0)) AUTH_CREATE,      
										             SUM(IFNULL(AUTH_READ, 0)) AUTH_READ,          
										             SUM(IFNULL(AUTH_UPDATE, 0)) AUTH_UPDATE,      
										             SUM(IFNULL(AUTH_DELETE, 0)) AUTH_DELETE       
										       FROM (
										             SELECT MENU_ID, 
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
										              FROM E_ROLE_PERMISSION A RIGHT JOIN  E_USER_ROLE B   
										              ON A.ROLE_CODE = B.ROLE_CODE        
										              AND B.USER_ID ='${sessionScope.UserInfo.USER_ID}'
										             ) ALAIS1                 
										             GROUP BY MENU_ID
										      ) Y         
										      ON X.RESOURCES_ID = Y.MENU_ID
					</e:if>
					<e:if condition="${sessionScope.UserInfo.ADMIN=='1'}">
						SELECT ISLEAF,
 	      					   RESOURCES_ID,
 	       					   RESOURCES_NAME,
 	      					   1 AUTH_CREATE,
 	      					   1 AUTH_READ,
 	 					       1 AUTH_UPDATE,
 	 					       1 AUTH_DELETE 
 	 					FROM (
 	       						SELECT	(case when resources_id in(select parent_id from(select * from e_menu a,tmpLst b where a.resources_id=b.id order by a.resources_id,b.id) n ) then 0 else 1 end) ISLEAF ,
  									nLevel level1,resources_id,resources_name, ORD 
  		  					    FROM 
  									(select * from e_menu a,tmpLst b where a.resources_id=b.id) s          
							 )TT WHERE TT.LEVEL1=1 ORDER BY TT.ORD
					</e:if>
				</e:q4l>
				<e:update>
					drop table tmpLst;
				</e:update>
			</e:if>
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
	<e:case value="checkRsourceName">
		<e:q4o var="resourceCount">
			SELECT COUNT(1) RESOURCE_NUM FROM E_MENU T WHERE T.RESOURCES_NAME='${param.resourceName }' AND T.PARENT_ID='${param.parentId }'
		</e:q4o>${resourceCount.RESOURCE_NUM}
	</e:case>
	
	<e:case value="addTreeNode">
		
		<e:set var="filePath"></e:set>
		<e:parseRequest/>
		<e:q4o var="checkAuthCreate">
			<e:if condition="${DBSource=='oracle' }">
			SELECT MENU_ID,
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
	                   AND MENU_ID ='${parentIdForAdd}'
	                UNION ALL
	                SELECT A.MENU_ID,
	                       A.AUTH_CREATE,
	                       A.AUTH_READ,
	                       A.AUTH_UPDATE,
	                       A.AUTH_DELETE
	                  FROM E_ROLE_PERMISSION A, E_USER_ROLE B
	                 WHERE A.ROLE_CODE(+) = B.ROLE_CODE
	                   AND B.USER_ID = '${sessionScope.UserInfo.USER_ID}'
	                   AND A.MENU_ID ='${parentIdForAdd }')
	         GROUP BY MENU_ID
	         </e:if>
	         <e:if condition="${DBSource=='mysql' }">
	         		SELECT MENU_ID,
	               SUM(IFNULL(AUTH_CREATE, 0)) AUTH_CREATE,
	               SUM(IFNULL(AUTH_READ, 0)) AUTH_READ,
	               SUM(IFNULL(AUTH_UPDATE, 0)) AUTH_UPDATE,
	               SUM(IFNULL(AUTH_DELETE, 0)) AUTH_DELETE
	          FROM (SELECT MENU_ID,
	                       AUTH_CREATE,
	                       AUTH_READ,
	                       AUTH_UPDATE,
	                       AUTH_DELETE
	                  FROM E_USER_PERMISSION
	                 WHERE USER_ID = '${sessionScope.UserInfo.USER_ID}'
	                   AND MENU_ID ='${parentIdForAdd}'
	                UNION ALL
	                SELECT A.MENU_ID,
	                       A.AUTH_CREATE,
	                       A.AUTH_READ,
	                       A.AUTH_UPDATE,
	                       A.AUTH_DELETE
	                  FROM E_ROLE_PERMISSION A right JOIN  E_USER_ROLE B
	                 ON A.ROLE_CODE = B.ROLE_CODE
	                   WHERE B.USER_ID = '${sessionScope.UserInfo.USER_ID}'
	                   AND A.MENU_ID ='${parentIdForAdd }') aa
	         GROUP BY MENU_ID
	         </e:if>
		</e:q4o>
		<e:if condition="${attachmentForAdd!=null&&attachmentForAdd!=''}">
			
			<e:set var="fileName"><%=System.currentTimeMillis() %></e:set>
			<e:copy file="${attachmentForAdd}" tofile="/pages/frame/download/${fileName}${attachmentForAdd.suffix}"/>
			<e:set var="filePath">/pages/frame/download/${fileName}${attachmentForAdd.suffix}</e:set>
		</e:if>
		<e:if condition="${checkAuthCreate.AUTH_CREATE>0||sessionScope.UserInfo.ADMIN=='1'}">
			<e:q4l var="parentNodeRolesList">
				<e:if condition="${DBSource=='oracle' }">
					SELECT ROLE_CODE,AUTH_CREATE,AUTH_READ,AUTH_UPDATE,AUTH_DELETE,nvl(AUTH_EXPORT,0) AUTH_EXPORT,MENU_ID FROM E_ROLE_PERMISSION T WHERE T.MENU_ID=#parentIdForAdd#
				</e:if>
				<e:if condition="${DBSource=='mysql' }">
					SELECT ROLE_CODE,AUTH_CREATE,AUTH_READ,AUTH_UPDATE,AUTH_DELETE,ifnull(AUTH_EXPORT,0) AUTH_EXPORT,MENU_ID FROM E_ROLE_PERMISSION T WHERE T.MENU_ID=#parentIdForAdd#
				</e:if>
			</e:q4l>
			<e:q4l var="parentNodeUsersList">
				<e:if condition="${DBSource=='oracle' }">
					SELECT USER_ID,AUTH_CREATE,AUTH_READ,AUTH_UPDATE,AUTH_DELETE,nvl(AUTH_EXPORT,0) AUTH_EXPORT,MENU_ID FROM E_USER_PERMISSION T WHERE T.MENU_ID=#parentIdForAdd#
				</e:if>
				<e:if condition= "${DBSource=='mysql' }">
					SELECT USER_ID,AUTH_CREATE,AUTH_READ,AUTH_UPDATE,AUTH_DELETE,ifnull(AUTH_EXPORT,0) AUTH_EXPORT,MENU_ID FROM E_USER_PERMISSION T WHERE T.MENU_ID=#parentIdForAdd#
				</e:if>
			</e:q4l>
			<e:update var="insertTreeNode">
			 <e:if condition="${DBSource=='oracle' }">
				DECLARE
					SEQ_ID NUMBER;
				BEGIN
					SELECT E_M_SEQ.Nextval INTO SEQ_ID FROM DUAL;
					INSERT INTO E_MENU(RESOURCES_ID,RESOURCES_NAME,RESOURCES_TYPE,PARENT_ID,URL,EXT1,EXT2,EXT3,EXT4,MEMO,ORD,ATTACHMENT,RESOURCE_STATE) VALUES(SEQ_ID,#resourceNameForAdd#,#resourceTypeForAdd#,#parentIdForAdd#,#urlForAdd#,#ext1ForAdd#,#ext2ForAdd#,#ext3ForAdd#,#ext4ForAdd#,#memoForAdd#,#ordForAdd#,'${filePath }',#resourceStateForAdd#);
					INSERT INTO E_USER_PERMISSION(USER_ID,MENU_ID,AUTH_CREATE,AUTH_READ,AUTH_UPDATE,AUTH_DELETE,AUTH_EXPORT) VALUES('${sessionScope.UserInfo.USER_ID}',SEQ_ID,1,1,1,1,1);
					<e:if condition="${MenuFuQuan!='0'}">
						<e:forEach items="${parentNodeUsersList.list}" var="item">
							<e:if condition="${sessionScope.UserInfo.USER_ID!=item.USER_ID }">
								INSERT INTO E_USER_PERMISSION(USER_ID,MENU_ID,AUTH_CREATE,AUTH_READ,AUTH_UPDATE,AUTH_DELETE,AUTH_EXPORT) VALUES('${item.USER_ID }',SEQ_ID,'${item.AUTH_CREATE }','${item.AUTH_READ }','${item.AUTH_UPDATE }','${item.AUTH_DELETE }','${item.AUTH_EXPORT }');
							</e:if>
						</e:forEach>
						<e:forEach items="${parentNodeRolesList.list}" var="item1">
							INSERT INTO E_ROLE_PERMISSION(ROLE_CODE,MENU_ID,AUTH_CREATE,AUTH_READ,AUTH_UPDATE,AUTH_DELETE,AUTH_EXPORT) VALUES('${item1.ROLE_CODE }',SEQ_ID,'${item1.AUTH_CREATE }','${item1.AUTH_READ }','${item1.AUTH_UPDATE }','${item1.AUTH_DELETE }','${item1.AUTH_EXPORT }');
						</e:forEach>
					</e:if>
				END;
			 </e:if>
			 <e:if condition="${DBSource=='mysql' }">
			 	call insertTreeNode(#resourceNameForAdd#,#resourceTypeForAdd#,#parentIdForAdd#,#urlForAdd#,#ext1ForAdd#,#ext2ForAdd#,#ext3ForAdd#,#ext4ForAdd#,#memoForAdd#,#ordForAdd#,'${filePath }',#resourceStateForAdd#,'${sessionScope.UserInfo.USER_ID}','${parentNodeUsersList.list}','${parentNodeRolesList.list}','${MenuFuQuan}')
			 </e:if>
			</e:update>${insertTreeNode }
		</e:if>
		<a:log pageUrl="pages/frame/menu/menuManager.jsp" operate="2" content="添加菜单树结点" result="${insertTreeNode}"/>
	</e:case>
	
	
	<e:case value="getOneResource">
		<e:q4o var="oneResourceObj">
			<e:if condition="${DBSource=='oracle' }">
			SELECT RESOURCES_ID,RESOURCES_NAME,RESOURCES_TYPE,PARENT_ID,URL,EXT1,EXT2,EXT3,EXT4,MEMO,ORD,ATTACHMENT,NVL(RESOURCE_STATE,'3') RESOURCE_STATE FROM E_MENU T WHERE T.RESOURCES_ID='${param.currentIdForEdite }'
			</e:if>
			<e:if condition="${DBSource=='mysql' }">
			SELECT RESOURCES_ID,RESOURCES_NAME,RESOURCES_TYPE,PARENT_ID,URL,EXT1,EXT2,EXT3,EXT4,MEMO,ORD,ATTACHMENT,ifnull(RESOURCE_STATE,'3') RESOURCE_STATE FROM E_MENU T WHERE T.RESOURCES_ID='${param.currentIdForEdite }'
			</e:if>
		</e:q4o>${e:java2json(oneResourceObj)}
	</e:case>
	
	<e:case value="editeTreeNode">
		<e:parseRequest/>
		<e:q4o var="checkAuthEdite">
			<e:if condition="${DBSource=='oracle' }">
			SELECT MENU_ID,
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
	                   AND MENU_ID ='${currentIdForEdite}'
	                UNION ALL
	                SELECT A.MENU_ID,
	                       A.AUTH_CREATE,
	                       A.AUTH_READ,
	                       A.AUTH_UPDATE,
	                       A.AUTH_DELETE
	                  FROM E_ROLE_PERMISSION A, E_USER_ROLE B
	                 WHERE A.ROLE_CODE(+) = B.ROLE_CODE
	                   AND B.USER_ID = '${sessionScope.UserInfo.USER_ID}'
	                   AND A.MENU_ID ='${currentIdForEdite }')
	         GROUP BY MENU_ID
	         </e:if>
	         <e:if condition="${DBSource=='mysql' }">
	         	SELECT MENU_ID,
	               SUM(IFNULL(AUTH_CREATE, 0)) AUTH_CREATE,
	               SUM(IFNULL(AUTH_READ, 0)) AUTH_READ,
	               SUM(IFNULL(AUTH_UPDATE, 0)) AUTH_UPDATE,
	               SUM(IFNULL(AUTH_DELETE, 0)) AUTH_DELETE
	          FROM (SELECT MENU_ID,
	                       AUTH_CREATE,
	                       AUTH_READ,
	                       AUTH_UPDATE,
	                       AUTH_DELETE
	                  FROM E_USER_PERMISSION
	                 WHERE USER_ID = '${sessionScope.UserInfo.USER_ID}'
	                   AND MENU_ID ='${currentIdForEdite}'
	                UNION ALL
	                SELECT A.MENU_ID,
	                       A.AUTH_CREATE,
	                       A.AUTH_READ,
	                       A.AUTH_UPDATE,
	                       A.AUTH_DELETE
	                  FROM E_ROLE_PERMISSION A right join E_USER_ROLE B
	                 on A.ROLE_CODE = B.ROLE_CODE
	                   where B.USER_ID = '${sessionScope.UserInfo.USER_ID}'
	                   AND A.MENU_ID ='${currentIdForEdite }') alisa
	         GROUP BY MENU_ID
	         </e:if>
		</e:q4o>
		<e:if condition="${attachmentForEdite!=null&&attachmentForEdite!=''}">
			<e:set var="fileName"><%=System.currentTimeMillis() %></e:set>
			<e:copy file="${attachmentForEdite}" tofile="/pages/frame/download/${fileName}${attachmentForEdite.suffix}"/>
			<e:set var="filePath">/pages/frame/download/${fileName}${attachmentForEdite.suffix}</e:set>
			<e:if condition="${checkAuthEdite.AUTH_UPDATE>0||sessionScope.UserInfo.ADMIN=='1'}">
				<e:update var="updateTreeNode1">
					UPDATE E_MENU SET RESOURCES_NAME=#resourceNameForEdite#,
									  RESOURCES_TYPE=#resourceTypeForEdite#,
									  URL=#urlForEdite#,
									  EXT1=#ext1ForEdite#,
									  EXT2=#ext2ForEdite#,
									  EXT3=#ext3ForEdite#,
									  EXT4=#ext4ForEdite#,
									  MEMO=#memoForEdite#,
									  ORD=#ordForEdite#,
									  ATTACHMENT='${filePath }',
									  RESOURCE_STATE=#resourceStateForEdite#
					WHERE RESOURCES_ID=#currentIdForEdite#
				</e:update>${updateTreeNode1 }
			</e:if>
			<a:log pageUrl="pages/frame/menu/menuManager.jsp" operate="3" content="编辑菜单树结点" result="${updateTreeNode1}"/>
		</e:if>
		<e:if condition="${attachmentForEdite==null||attachmentForEdite==''}">
			<e:if condition="${checkAuthEdite.AUTH_UPDATE>0||sessionScope.UserInfo.ADMIN=='1'}">
				<e:update var="updateTreeNode">
					UPDATE E_MENU SET RESOURCES_NAME=#resourceNameForEdite#,
									  RESOURCES_TYPE=#resourceTypeForEdite#,
									  URL=#urlForEdite#,
									  EXT1=#ext1ForEdite#,
									  EXT2=#ext2ForEdite#,
									  EXT3=#ext3ForEdite#,
									  EXT4=#ext4ForEdite#,
									  MEMO=#memoForEdite#,
									  ORD=#ordForEdite#,
									  RESOURCE_STATE=#resourceStateForEdite#
					WHERE RESOURCES_ID=#currentIdForEdite#
				</e:update>${updateTreeNode }
			</e:if>
			<a:log pageUrl="pages/frame/menu/menuManager.jsp" operate="3" content="编辑菜单树结点" result="${updateTreeNode}"/>
		</e:if>
	</e:case>
	
	
	<e:case value="deleteTreeNode">
		<e:q4o var="checkAuthDelete">
		<e:if condition="${DBSource=='oracle' }">
			SELECT MENU_ID,
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
	                   AND MENU_ID ='${param.currentNodeId}'
	                UNION ALL
	                SELECT A.MENU_ID,
	                       A.AUTH_CREATE,
	                       A.AUTH_READ,
	                       A.AUTH_UPDATE,
	                       A.AUTH_DELETE
	                  FROM E_ROLE_PERMISSION A, E_USER_ROLE B
	                 WHERE A.ROLE_CODE(+) = B.ROLE_CODE
	                   AND B.USER_ID = '${sessionScope.UserInfo.USER_ID}'
	                   AND A.MENU_ID ='${param.currentNodeId }')
	         GROUP BY MENU_ID
	        </e:if>
	        <e:if condition="${DBSource=='mysql' }">
	        	SELECT MENU_ID,
	               SUM(IFNULL(AUTH_CREATE, 0)) AUTH_CREATE,
	               SUM(IFNULL(AUTH_READ, 0)) AUTH_READ,
	               SUM(IFNULL(AUTH_UPDATE, 0)) AUTH_UPDATE,
	               SUM(IFNULL(AUTH_DELETE, 0)) AUTH_DELETE
	          FROM (SELECT MENU_ID,
	                       AUTH_CREATE,
	                       AUTH_READ,
	                       AUTH_UPDATE,
	                       AUTH_DELETE
	                  FROM E_USER_PERMISSION
	                 WHERE USER_ID = '${sessionScope.UserInfo.USER_ID}'
	                   AND MENU_ID ='${param.currentNodeId}'
	                UNION ALL
	                SELECT A.MENU_ID,
	                       A.AUTH_CREATE,
	                       A.AUTH_READ,
	                       A.AUTH_UPDATE,
	                       A.AUTH_DELETE
	                  FROM E_ROLE_PERMISSION A right join  E_USER_ROLE B
	                 on A.ROLE_CODE = B.ROLE_CODE
	                   where B.USER_ID = '${sessionScope.UserInfo.USER_ID}'
	                   AND A.MENU_ID ='${param.currentNodeId }') alasi
	         GROUP BY MENU_ID
	        </e:if>
		</e:q4o>
		<e:if condition="${checkAuthDelete.AUTH_DELETE>0||sessionScope.UserInfo.ADMIN=='1'}">
			<e:update var="deleteTreeNodeWithChildren">
			<e:if condition="${DBSource=='oracle' }">
				begin
					DELETE FROM E_MENU TTT WHERE EXISTS(SELECT RESOURCES_ID FROM (SELECT RESOURCES_ID,RESOURCES_NAME,ORD FROM E_MENU T start with T.Resources_Id='${param.currentNodeId }' connect by PRIOR t.resources_id=t.parent_id) TT WHERE TT.RESOURCES_ID=TTT.RESOURCES_ID);
					DELETE FROM E_USER_PERMISSION TTT WHERE EXISTS(SELECT RESOURCES_ID FROM (SELECT RESOURCES_ID,RESOURCES_NAME,ORD FROM E_MENU T start with T.Resources_Id='${param.currentNodeId }' connect by PRIOR t.resources_id=t.parent_id) TT WHERE TT.RESOURCES_ID=TTT.MENU_ID); 
					DELETE FROM E_ROLE_PERMISSION TTT WHERE EXISTS(SELECT RESOURCES_ID FROM (SELECT RESOURCES_ID,RESOURCES_NAME,ORD FROM E_MENU T start with T.Resources_Id='${param.currentNodeId }' connect by PRIOR t.resources_id=t.parent_id) TT WHERE TT.RESOURCES_ID=TTT.MENU_ID);
					DELETE FROM e_user_collect TTT WHERE EXISTS(SELECT RESOURCES_ID FROM (SELECT RESOURCES_ID,RESOURCES_NAME,ORD FROM E_MENU T start with T.Resources_Id='${param.currentNodeId }' connect by PRIOR t.resources_id=t.parent_id) TT WHERE TT.RESOURCES_ID=TTT.MENU_ID);
				end;
			</e:if>
			<e:if condition="${DBSource=='mysql' }">
				call delete_menu_treeNode('${param.currentNodeId}');
			</e:if>
			</e:update>		
			${deleteTreeNodeWithChildren}
			
		</e:if>
		<a:log pageUrl="pages/frame/menu/menuManager.jsp" operate="4" content="删除菜单树结点" result="${deleteTreeNodeWithChildren}"/>
	</e:case>
	<e:case value="cutToOthers">
		<e:q4o var="checkAuthUpdateForCut">
			<e:if condition="${DBSource=='oracle' }">
			SELECT MENU_ID,
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
	                   AND MENU_ID ='${param.sourceId}'
	                UNION ALL
	                SELECT A.MENU_ID,
	                       A.AUTH_CREATE,
	                       A.AUTH_READ,
	                       A.AUTH_UPDATE,
	                       A.AUTH_DELETE
	                  FROM E_ROLE_PERMISSION A, E_USER_ROLE B
	                 WHERE A.ROLE_CODE(+) = B.ROLE_CODE
	                   AND B.USER_ID = '${sessionScope.UserInfo.USER_ID}'
	                   AND A.MENU_ID =#sourceId#)
	         GROUP BY MENU_ID
	        </e:if>
	        <e:if condition="${DBSource=='mysql' }">
	        	SELECT MENU_ID,
	               SUM(IFNULL(AUTH_CREATE, 0)) AUTH_CREATE,
	               SUM(IFNULL(AUTH_READ, 0)) AUTH_READ,
	               SUM(IFNULL(AUTH_UPDATE, 0)) AUTH_UPDATE,
	               SUM(IFNULL(AUTH_DELETE, 0)) AUTH_DELETE
	          FROM (SELECT MENU_ID,
	                       AUTH_CREATE,
	                       AUTH_READ,
	                       AUTH_UPDATE,
	                       AUTH_DELETE
	                  FROM E_USER_PERMISSION
	                 WHERE USER_ID = '${sessionScope.UserInfo.USER_ID}'
	                   AND MENU_ID ='${param.sourceId}'
	                UNION ALL
	                SELECT A.MENU_ID,
	                       A.AUTH_CREATE,
	                       A.AUTH_READ,
	                       A.AUTH_UPDATE,
	                       A.AUTH_DELETE
	                  FROM E_ROLE_PERMISSION A right join E_USER_ROLE B
	                 on A.ROLE_CODE = B.ROLE_CODE
	                  where B.USER_ID = '${sessionScope.UserInfo.USER_ID}'
	                   AND A.MENU_ID =#sourceId#) aa
	         GROUP BY MENU_ID
	        </e:if>
		</e:q4o>
		<e:if condition="${checkAuthUpdateForCut.AUTH_DELETE>0||sessionScope.UserInfo.ADMIN=='1'}">
			<e:update var="updateCutToOthers">
				UPDATE E_MENU SET PARENT_ID='${param.targetId }'
					WHERE RESOURCES_ID=#sourceId#
			</e:update>${updateCutToOthers }
		</e:if>
		<a:log pageUrl="pages/frame/menu/menuManager.jsp" operate="3" content="移动菜单树结点" result="${updateCutToOthers}"/>
	</e:case>
	
	<e:case value="LoadLeftTree">
		<e:q4l var="MenuList">
		<e:if condition="${applicationScope.isPortal eq '0'}" var="isPortalMenu">
			<e:if condition="${sessionScope.UserInfo.ADMIN=='1'}">
				select RESOURCES_ID, RESOURCES_NAME RESOURCES_NAME, URL,
					<e:if condition="${DBSource=='oracle' }">
					NVL(RESOURCE_STATE,'3') RESOURCE_STATE,
					NVL(RESOURCES_TYPE,'1') RESOURCES_TYPE,
					</e:if>
					<e:if condition="${DBSource=='mysql' }">
					IFNULL(RESOURCE_STATE,'3') RESOURCE_STATE,
					IFNULL(RESOURCES_TYPE,'1') RESOURCES_TYPE,
					</e:if>
					case when exists(
						select RESOURCES_ID, RESOURCES_NAME, URL
								  FROM e_menu t2
								 where t2.parent_id = t.RESOURCES_ID
					) then 'closed' else 'leaf' end STATE
					  FROM e_menu t
			          <e:if var="ifv" condition="${param.id == null || param.id eq ''}">
			              where t.parent_id = #pid#
			          </e:if>
			          <e:else condition="${ifv}">
			              where t.parent_id = #id#
			          </e:else>
					 order by ord
			</e:if>
			<e:if condition="${sessionScope.UserInfo.ADMIN!='1'}">
				select RESOURCES_ID, RESOURCES_NAME RESOURCES_NAME, URL,
					<e:if condition="${DBSource=='oracle' }">
					NVL(RESOURCE_STATE,'3') RESOURCE_STATE,
					NVL(RESOURCES_TYPE,'1') RESOURCES_TYPE,
					</e:if>
					<e:if condition="${DBSource=='mysql' }">
					IFNULL(RESOURCE_STATE,'3') RESOURCE_STATE,
					IFNULL(RESOURCES_TYPE,'1') RESOURCES_TYPE,
					</e:if>
					case when exists(
						select RESOURCES_ID, RESOURCES_NAME, URL
								  FROM e_menu t2
								 where t2.parent_id = t.RESOURCES_ID
								   and RESOURCES_ID in
								       (select id
								          from (select b.MENU_ID ID
								                  from E_USER_PERMISSION b
								                 where 1 = 1
								                   and b.USER_ID = '${sessionScope.UserInfo.USER_ID}'
								                   and b.AUTH_READ = 1
								                union all
								                select c.MENU_ID
								                  from E_ROLE_PERMISSION c
								                 where 1 = 1
								                   and c.ROLE_CODE in
								                       (select ROLE_CODE
								                          from E_USER_ROLE
								                         where USER_ID = '${sessionScope.UserInfo.USER_ID}')
								                   and c.AUTH_READ = 1) a)
					) then 'closed' else 'leaf' end STATE
					  FROM e_menu t
			          <e:if var="ifv" condition="${param.id == null || param.id eq ''}">
			              where t.parent_id = #pid#
			          </e:if>
			          <e:else condition="${ifv}">
			              where t.parent_id = #id#
			          </e:else>
					   and RESOURCES_ID in
					       (select id
					          from (select b.MENU_ID ID
					                  from E_USER_PERMISSION b
					                 where 1 = 1
					                   and b.USER_ID = '${sessionScope.UserInfo.USER_ID}'
					                   and b.AUTH_READ = 1
					                union all
					                select c.MENU_ID
					                  from E_ROLE_PERMISSION c
					                 where 1 = 1
					                   and c.ROLE_CODE in
					                       (select ROLE_CODE
					                          from E_USER_ROLE
					                         where USER_ID = '${sessionScope.UserInfo.USER_ID}')
					                   and c.AUTH_READ = 1) alias)
					 order by ord
				 </e:if>
		</e:if>
		<e:else condition="${isPortalMenu}">
			<e:set var="lengthSql">(select instr('${sessionScope.userReqIp}','.')-1 from dual)</e:set>
			<e:if condition="${sessionScope.UserInfo.ADMIN=='1'}">
				select 
					T1.RESOURCES_ID,
					T1.RESOURCES_NAME,
					T1.RESOURCE_STATE,
					decode(T1.URL,'','',
				        (case when substr('${sessionScope.userReqIp}',0,${lengthSql}) = substr(T2.subsystem_ip,0,${lengthSql})  then subsystem_address 
		             when substr('${sessionScope.userReqIp}',0,${lengthSql}) = substr(T2.subsystem_ip2,0,${lengthSql})  then subsystem_address2
		             end )||T1.URL) URL,
		            T1.RESOURCES_TYPE,
		            T1.STATE
				  from (
					select RESOURCES_ID, RESOURCES_NAME RESOURCES_NAME, URL,
						<e:if condition="${DBSource=='oracle' }">
						NVL(RESOURCE_STATE,'3') RESOURCE_STATE,
						NVL(RESOURCES_TYPE,'1') RESOURCES_TYPE,
						</e:if>
						<e:if condition="${DBSource=='mysql' }">
						IFNULL(RESOURCE_STATE,'3') RESOURCE_STATE,
						IFNULL(RESOURCES_TYPE,'1') RESOURCES_TYPE,
						</e:if>
						case when exists(
							select RESOURCES_ID, RESOURCES_NAME, URL
									  FROM e_menu t2
									 where t2.parent_id = t.RESOURCES_ID
						) then 'closed' else 'leaf' end STATE, t.ord,t.ext1
						  FROM e_menu t
				          <e:if var="ifv" condition="${param.id == null || param.id eq ''}">
				              where t.parent_id = #pid#
				          </e:if>
				          <e:else condition="${ifv}">
				              where t.parent_id = #id#
				          </e:else>
						 order by ord)t1, d_subsystem t2
					where t1.ext1 = t2.subsystem_id(+)
	 				order by T1.ord
			</e:if>
			<e:if condition="${sessionScope.UserInfo.ADMIN!='1'}">
				select 
					T1.RESOURCES_ID,
					T1.RESOURCES_NAME,
					T1.RESOURCE_STATE,
					decode(T1.URL,'','',
				        (case when substr('${sessionScope.userReqIp}',0,${lengthSql}) = substr(T2.subsystem_ip,0,${lengthSql})  then subsystem_address 
		             when substr('${sessionScope.userReqIp}',0,${lengthSql}) = substr(T2.subsystem_ip2,0,${lengthSql})  then subsystem_address2
		             end )||T1.URL) URL,
		            T1.RESOURCES_TYPE,
		            T1.STATE
				  from (
					select RESOURCES_ID, RESOURCES_NAME RESOURCES_NAME, URL,
						<e:if condition="${DBSource=='oracle' }">
						NVL(RESOURCE_STATE,'3') RESOURCE_STATE,
						NVL(RESOURCES_TYPE,'1') RESOURCES_TYPE,
						</e:if>
						<e:if condition="${DBSource=='mysql' }">
						IFNULL(RESOURCE_STATE,'3') RESOURCE_STATE,
						IFNULL(RESOURCES_TYPE,'1') RESOURCES_TYPE,
						</e:if>
						case when exists(
							select RESOURCES_ID, RESOURCES_NAME, URL
									  FROM e_menu t2
									 where t2.parent_id = t.RESOURCES_ID
									   and RESOURCES_ID in
									       (select id
									          from (select b.MENU_ID ID
									                  from E_USER_PERMISSION b
									                 where 1 = 1
									                   and b.USER_ID = '${sessionScope.UserInfo.USER_ID}'
									                   and b.AUTH_READ = 1
									                union all
									                select c.MENU_ID
									                  from E_ROLE_PERMISSION c
									                 where 1 = 1
									                   and c.ROLE_CODE in
									                       (select ROLE_CODE
									                          from E_USER_ROLE
									                         where USER_ID = '${sessionScope.UserInfo.USER_ID}')
									                   and c.AUTH_READ = 1) a)
						) then 'closed' else 'leaf' end STATE, t.ord,t.ext1
						  FROM e_menu t
				          <e:if var="ifv" condition="${param.id == null || param.id eq ''}">
				              where t.parent_id = #pid#
				          </e:if>
				          <e:else condition="${ifv}">
				              where t.parent_id = #id#
				          </e:else>
						   and RESOURCES_ID in
						       (select id
						          from (select b.MENU_ID ID
						                  from E_USER_PERMISSION b
						                 where 1 = 1
						                   and b.USER_ID = '${sessionScope.UserInfo.USER_ID}'
						                   and b.AUTH_READ = 1
						                union all
						                select c.MENU_ID
						                  from E_ROLE_PERMISSION c
						                 where 1 = 1
						                   and c.ROLE_CODE in
						                       (select ROLE_CODE
						                          from E_USER_ROLE
						                         where USER_ID = '${sessionScope.UserInfo.USER_ID}')
						                   and c.AUTH_READ = 1) alias)
						 order by ord)t1, d_subsystem t2
					where t1.ext1 = t2.subsystem_id(+)
	 				order by T1.ord
 				</e:if>
		</e:else>
		</e:q4l>
        [
            <e:forEach items="${MenuList.list}" var="item">
                <e:if condition="${index>0}">
                    ,
                </e:if>
                {
                	"id":"${item.RESOURCES_ID }",
                    "text":"${item.RESOURCES_NAME }",
                    "state":"${item.STATE}",
                    <e:if condition="${item.STATE eq 'closed'}" var="isLeaf">
                    	"iconCls":"icon-tree01",
                    </e:if>
                    <e:else condition="${isLeaf}">
                    	"iconCls":"icon-tree02",
                    </e:else>
                    "attributes":{
                        "url":"${item.URL}",
                        "menuState":"${item.RESOURCE_STATE}",
                        "menuType":"${item.RESOURCES_TYPE}"
                    }
                }
            </e:forEach>
        ]
	</e:case>
	<e:case value="LoadLeftTreeSub">
	<e:q4l var="SubMenuList">
		select RESOURCES_ID, RESOURCES_NAME, URL,
		<e:if condition="${DBSource=='oracle' }">
		NVL(RESOURCE_STATE,'3') RESOURCE_STATE,
		NVL(RESOURCES_TYPE,'1') RESOURCES_TYPE
		</e:if>
		<e:if condition="${DBSource=='mysql' }">
		ifnull(RESOURCE_STATE,'3') RESOURCE_STATE ,
		ifnull(RESOURCES_TYPE,'1') RESOURCES_TYPE
		</e:if>
		  FROM e_menu t
           where t.parent_id = #id#
		   and RESOURCES_ID in
		       (select id
		          from (select b.MENU_ID ID
		                  from E_USER_PERMISSION b
		                 where 1 = 1
		                   and b.USER_ID = '${sessionScope.UserInfo.USER_ID}'
		                   and b.AUTH_READ = 1
		                union all
		                select c.MENU_ID
		                  from E_ROLE_PERMISSION c
		                 where 1 = 1
		                   and c.ROLE_CODE in
		                       (select ROLE_CODE
		                          from E_USER_ROLE
		                         where USER_ID = '${sessionScope.UserInfo.USER_ID}')
		                   and c.AUTH_READ = 1) alias)
		 order by ord
		</e:q4l>
		<e:forEach items="${SubMenuList.list}" var="item">
		<e:if condition="${index==0}">
		    ${item.RESOURCES_ID}
		    <e:break/>
		</e:if>
		</e:forEach>
	</e:case>
	
	<e:case value="getHasSelectRoles">
		<c:tablequery>
			<e:if condition="${DBSource=='oracle' }">
			SELECT T2.ROLE_CODE, T2.ROLE_NAME, T2.MEMO,
			        REPLACE(REPLACE(
		             DECODE(T1.AUTH_READ,1,'读取','')||','||
		             DECODE(T1.AUTH_CREATE,1,'创建','')||','||
		             DECODE(T1.AUTH_UPDATE,1,'更新','')||','||
		             DECODE(T1.AUTH_DELETE,1,'删除','')||','||
		             DECODE(T1.AUTH_EXPORT ,1,'导出',''),',,',',')
		             ,',,',',') QX
			  FROM E_ROLE_PERMISSION T1, E_ROLE T2
			WHERE T1.ROLE_CODE = T2.ROLE_CODE
			   AND T1.MENU_ID = '${param.currentNodeId }'
			   <e:if condition="${param.roleId!=null&&param.roleId!=''}">
			   		and T2.ROLE_CODE='${param.roleId }'
			   </e:if>
			   <e:if condition="${param.roleName!=null&&param.roleName!=''}">
			   		and T2.ROLE_NAME LIKE '%${param.roleName }%'
			   </e:if>
			 ORDER BY T2.ORD
			</e:if>	
			<e:if condition="${DBSource=='mysql' }">
				SELECT T2.ROLE_CODE, T2.ROLE_NAME, T2.MEMO,
			        REPLACE(REPLACE(
			        concat((case t1.auth_read when 1 then '读取' else '' end),',',
			        	   (case t1.auth_create when 1 then '创建' else '' end),',',
			        	   (case t1.auth_update when 1 then '更新' else '' end),',',
			        	   (case t1.auth_delete when 1 then '删除' else '' end),',',
			        	   (case t1.auth_export when 1 then '导出' else '' end)),',,',',')
		             ,',,',',') QX
			  FROM E_ROLE_PERMISSION T1, E_ROLE T2
			WHERE T1.ROLE_CODE = T2.ROLE_CODE
			   AND T1.MENU_ID = '${param.currentNodeId }'
			   <e:if condition="${param.roleId!=null&&param.roleId!=''}">
			   		and T2.ROLE_CODE='${param.roleId }'
			   </e:if>
			   <e:if condition="${param.roleName!=null&&param.roleName!=''}">
			   		and T2.ROLE_NAME LIKE '%${param.roleName }%'
			   </e:if>
			 ORDER BY T2.ORD
			</e:if>
		</c:tablequery>
	</e:case>
	
	<e:case value="getNeedSelectRoles">
		<c:tablequery>
			SELECT T2.ROLE_CODE, T2.ROLE_NAME, T2.MEMO
			  FROM E_ROLE T2
			 WHERE NOT EXISTS(SELECT 1 FROM E_ROLE_PERMISSION T1 WHERE T1.ROLE_CODE=T2.ROLE_CODE AND T1.MENU_ID='${param.currentNodeId }')
			   <e:if condition="${param.roleId!=null&&param.roleId!=''}">
			   		and T2.ROLE_CODE='${param.roleId }'
			   </e:if>
			   <e:if condition="${param.roleName!=null&&param.roleName!=''}">
			   		and T2.ROLE_NAME LIKE '%${param.roleName }%'
			   </e:if>
			 ORDER BY T2.ORD
		</c:tablequery>
	</e:case>
	
	<e:case value="addRole">
		<e:if condition="${DBSource=='oracle' }">
		<e:q4l var="allMenuList">			
			SELECT RESOURCES_ID
			  FROM (SELECT *
			          FROM E_MENU T
			         START WITH T.RESOURCES_ID = '${param.menuId }'
			        CONNECT BY PRIOR T.RESOURCES_ID = T.PARENT_ID)
			  
		</e:q4l>
		</e:if>
		<e:if condition="${DBSource=='mysql' }">
			<e:update>
				call showTree('${param.menuId }');
			</e:update>
			<e:q4l var="allMenuList">
				SELECT resources_id			FROM 
  				(select * from e_menu a,tmpLst b where a.resources_id=b.id order by a.resources_id,b.id) s                
 	          
			</e:q4l>
			<e:update>
				drop table tmpLst;
			</e:update>
		</e:if>
		<e:update var="insertRoles">
			<e:if condition="${DBSource=='oracle' }">
			BEGIN
				<e:forEach items="${allMenuList.list}" var="item">
					INSERT INTO E_ROLE_PERMISSION(ROLE_CODE,MENU_ID,AUTH_CREATE,AUTH_READ,AUTH_UPDATE,AUTH_DELETE,AUTH_EXPORT) VALUES('${param.roleCode }','${item.RESOURCES_ID }','${param.createQX }','${param.readQX }','${param.updateQX }','${param.deleteQX }','${param.exportQX }');
				</e:forEach>
			END;
			</e:if>
			<e:if condition="${DBSource=='mysql' }">
			 call add_menu_role('${param.roleCode }','${allMenuList.list}',${param.createQX },${param.readQX },${param.updateQX },${param.deleteQX },${param.exportQX });
			</e:if>
		</e:update>${insertRoles }
	</e:case>
	
	<e:case value="removeRole">
	  <e:if condition="${DBSource=='oracle' }">
		<e:update var="deleteRole">
			 DELETE FROM E_ROLE_PERMISSION T2
			 WHERE EXISTS (SELECT 1
			          FROM (SELECT *
			                  FROM E_MENU T
			                 START WITH T.RESOURCES_ID = '${param.menuId }'
			                CONNECT BY PRIOR T.RESOURCES_ID = T.PARENT_ID)
			         WHERE T2.MENU_ID = RESOURCES_ID)
			     AND ROLE_CODE='${param.roleCode }'
		</e:update>${deleteRole }
	  </e:if>
	  <e:if condition="${DBSource=='mysql' }">
	  	<e:update>
	  		call showTree('${param.menuId }');
	  	</e:update>
	  	<e:update var="deleteRole">
	  		delete from E_ROLE_PERMISSION WHERE EXISTS ( 
	  		             SELECT 1      
 	                         FROM (           
 	                        SELECT * FROM (select * from e_menu,tmpLst where e_menu.resources_id=tmpLst.id) a ) b
 	                          WHERE E_ROLE_PERMISSION.MENU_ID = RESOURCES_ID)         
			     AND ROLE_CODE='${param.roleCode }'
	  	</e:update>${deleteRole }
	  	<e:update>
	  		drop table tmpLst;
	  	</e:update>
	  </e:if>
	</e:case>
	
	<e:case value="checkResourceNameAndUrl">
		
		<e:q4o var="resourceCount1">
			SELECT COUNT(1) RESOURCE_NUM FROM 
		     (
		
		        SELECT * FROM E_MENU X WHERE EXISTS(
		
		            SELECT 1 FROM (
		              SELECT T1.MENU_ID FROM E_USER_PERMISSION T1 WHERE T1.USER_ID='${sessionScope.UserInfo.USER_ID }' AND T1.AUTH_READ='1'
		              UNION
		              SELECT T2.MENU_ID FROM E_ROLE_PERMISSION T2 WHERE EXISTS(SELECT 1 FROM E_USER_ROLE A WHERE A.USER_ID='${sessionScope.UserInfo.USER_ID }' AND A.ROLE_CODE=T2.ROLE_CODE) AND T2.AUTH_READ='1'
		            ) Y WHERE Y.MENU_ID=X.RESOURCES_ID 
		
		        )
		      ) T 
		  WHERE T.RESOURCES_NAME='${param.menuName }' 
		        AND T.url='${param.url }'
		</e:q4o>
		<e:if condition="${resourceCount1.RESOURCE_NUM!='0'}">${e:java2json(1)}</e:if>
		<e:if condition="${resourceCount1.RESOURCE_NUM=='0'}">${e:java2json(0)}</e:if>
		
	</e:case>
	
</e:switch>