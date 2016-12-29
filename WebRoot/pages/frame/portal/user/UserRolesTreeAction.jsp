<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@page import="java.io.File"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="rootObj">
	SELECT COUNT(1) IS_ROOT FROM E_USER_ROLE TTT WHERE TTT.USER_ID='${sessionScope.UserInfo.USER_ID}' AND TTT.ROLE_CODE='0'
</e:q4o>
<e:switch value="${param.eaction}">
	<e:case value="loardTree">
		<e:if condition="${param.id==null||param.id==''}">
			<e:q4o var="rootNum">
				SELECT COUNT(1) ROOTNUM FROM E_ROLE T WHERE T.ROLE_CODE='0'
			</e:q4o>
			<e:if condition="${rootNum.ROOTNUM<1}">
				<e:update>
					INSERT INTO E_ROLE(ROLE_CODE,PARENT_CODE,ROLE_NAME,MEMO,ORD) VALUES('0','-1','root','',0)
				</e:update>
			</e:if>
			<e:q4o var="nullNumObj">
				SELECT COUNT(1) ROOTNUM FROM E_ROLE T WHERE T.PARENT_CODE IS NULL
			</e:q4o>
			<e:if condition="${nullNumObj.ROOTNUM>0}">
				<e:update>
					UPDATE E_ROLE T SET T.PARENT_CODE='0' WHERE T.PARENT_CODE IS NULL
				</e:update>
			</e:if>
			
			<e:q4o var="rootObj1">
				SELECT ROLE_CODE ,ROLE_NAME  FROM E_ROLE T WHERE T.ROLE_CODE ='0'
			</e:q4o>
			[ 
				{
				"id":${rootObj1.ROLE_CODE},
				"text":"${rootObj1.ROLE_NAME}",
				"attributes":{
							},
				"children":[
					<e:q4l var="childrenListForRoot">
						<e:if condition="${sessionScope.UserInfo.ADMIN=='1'||rootObj.IS_ROOT!='0'}">
								SELECT ISLEAF,
								       ROLE_CODE ,
								       ROLE_NAME
								  FROM (SELECT '0' ISLEAF, ROLE_CODE , ROLE_NAME , ORD
								          FROM E_ROLE T
								         WHERE T.PARENT_CODE  = '${rootObj1.ROLE_CODE }') TT
								 ORDER BY TT.ORD
						</e:if>						
						<e:if condition="${sessionScope.UserInfo.ADMIN!='1'&&rootObj.IS_ROOT=='0'}">
							SELECT ISLEAF, role_code, role_name FROM(
							      SELECT '0' ISLEAF, role_code, role_name, ORD, parent_code
							              FROM (
							                       select distinct role_code, role_name, parent_code ,ORD from (
							                          SELECT role_code, role_name, parent_code, ORD FROM e_role 
							                           where role_code in(
							                           				SELECT ROLE_CODE FROM E_USER_ROLE WHERE USER_ID in (
							                           						select USER_ID from E_USER_ACCOUNT WHERE ACCOUNT_CODE IN
								       													(select ACCOUNT_CODE from E_USER_ACCOUNT where user_id = '${sessionScope.UserInfo.USER_ID}'))
								       									 )
							                          union all
							                          SELECT role_code, role_name,parent_code, ORD FROM e_role 
							                           where parent_code in(SELECT ROLE_CODE FROM E_USER_ROLE WHERE USER_ID in (
							                           						select USER_ID from E_USER_ACCOUNT WHERE ACCOUNT_CODE IN
								       													(select ACCOUNT_CODE from E_USER_ACCOUNT where user_id = '${sessionScope.UserInfo.USER_ID}')))
								       				) T1
							              
							                  ) T2
							             where parent_code = '${rootObj1.ROLE_CODE }' ORDER BY ORD
							) T3
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
				 <e:if condition="${sessionScope.UserInfo.ADMIN=='1'||rootObj.IS_ROOT!='0'}">
				 	SELECT (CASE WHEN SUB_COUNT>0 THEN '0' ELSE '1' END )ISLEAF,ROLE_CODE,ROLE_NAME FROM (
					  	 SELECT (SELECT count(1) from E_ROLE R where R.PARENT_CODE=T.ROLE_CODE) SUB_COUNT,ROLE_CODE,ROLE_NAME,ORD
					     FROM (select distinct ROLE_CODE, ROLE_NAME, ORD, PARENT_CODE from E_ROLE) T
					     WHERE T.PARENT_CODE = '${param.id }') TT
					 ORDER BY TT.ORD
				</e:if>					
				<e:if condition="${sessionScope.UserInfo.ADMIN!='1'&&rootObj.IS_ROOT=='0'}">
					SELECT (CASE WHEN SUB_COUNT>0 THEN '0' ELSE '1' END )ISLEAF,role_code,role_name FROM(
								SELECT (SELECT count(1) from E_ROLE R where R.PARENT_CODE=T2.ROLE_CODE) SUB_COUNT,role_code,role_name,parent_code,ORD FROM (
					                       select distinct role_code, role_name, parent_code ,ORD from (
					                          SELECT role_code, role_name, parent_code ,ORD FROM e_role WHERE role_code in
					                          	(SELECT ROLE_CODE FROM E_USER_ROLE WHERE USER_ID in
					                            	(select USER_ID from E_USER_ACCOUNT WHERE ACCOUNT_CODE IN
								       					(select ACCOUNT_CODE from E_USER_ACCOUNT where user_id = '${sessionScope.UserInfo.USER_ID}')))
					                          union all
					                          SELECT role_code, role_name,parent_code, ORD
					                            FROM e_role T WHERE T.parent_code in
					                            (SELECT ROLE_CODE FROM E_USER_ROLE WHERE USER_ID in 
					                            	(select USER_ID from E_USER_ACCOUNT WHERE ACCOUNT_CODE IN
								       					(select ACCOUNT_CODE from E_USER_ACCOUNT where user_id = '${sessionScope.UserInfo.USER_ID}')))
					                      ) T1
					                  ) T2
					             where  parent_code = '${param.id }'  ORDER BY ORD
					) T3
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
	
	<e:case value="edit">
	
	<% 
	String datetime=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(java.util.Calendar.getInstance().getTime()); //获取系统时间 
	request.setAttribute("currentTime",datetime);
	%>
	
		<e:q4o var="userMenuId" sql="frame.user.userMenuId" />
		<e:q4o var="userInfo" sql="frame.user.userInfo" />
		<e:if condition="param.removeRoleIds!='[]'">
			<e:forEach items="${e:json2java(param.removeRoleIds)}" var="itemDelRoleId">
				<e:set var="strDelRoleIds" value="'${strDelRoleIds}','${itemDelRoleId}'"/>
			</e:forEach>
			<e:q4l var="deleteRoles" >
				select ROLE_CODE, ROLE_NAME from e_role where role_code in (${strDelRoleIds})
			</e:q4l>
		</e:if>
		<e:if condition="param.addRoleIds!='[]'">
			<e:forEach items="${e:json2java(param.addRoleIds)}" var="itemAddRoleId">
				<e:set var="strAddRoleIds" value="'${strAddRoleIds}','${itemAddRoleId}'"/>
			</e:forEach>		
			<e:q4l var="addRoles" >
				select ROLE_CODE, ROLE_NAME from e_role where role_code in (${strAddRoleIds})
			</e:q4l>
		</e:if>

		<e:update var="perm_res" transaction="true" sql="frame.user.editUserRole"></e:update>1
	</e:case>
	<e:case value="getAttrInfo">
		<e:q4l var="allAttrInfo">
			SELECT X1.ROLE_CODE, X3.ROLE_NAME, X2.SUBSYSTEM_ID,X4.SUBSYSTEM_NAME,X2.ATTR_CODE,X2.ATTR_NAME,X2.ATTR_VALUE
			  FROM (SELECT DISTINCT A.SUBSYSTEM_ID, A.ROLE_CODE
			          FROM E_ROLE A
			         WHERE coalesce(A.SUBSYSTEM_ID,'-1')!='-1' and A.ROLE_CODE IN (
			         <e:if condition="${e:length(e:json2java(param.addRoleIds))==0}">
			         	''
			         </e:if>
			         <e:set var="isFirstRole">1</e:set>
			         <e:forEach items="${e:json2java(param.addRoleIds)}" var="item">
						<e:if condition="${item!=-1&&item!='-1'}">
							
							<e:if condition="${isFirstRole=='1'}">
								<e:set var="isFirstRole">0</e:set>
								'${item }'
							</e:if>
							<e:if condition="${isFirstRole!='1'}">
								,'${item }'
							</e:if>
						</e:if>
					</e:forEach>
			         )) X1 
				   LEFT JOIN (SELECT T1.SUBSYSTEM_ID, T2.ATTR_CODE, T2.ATTR_NAME, coalesce(T3.ATTR_VALUE,'') ATTR_VALUE FROM 
			          (SELECT * FROM E_USER_ATTR_DIM A2 WHERE A2.IS_NULL = 0) T2 
			          INNER JOIN (SELECT ATTR_CODE, SUBSYSTEM_ID FROM E_USER_ATTR_SUBSYSTEM A1) T1 ON T1.ATTR_CODE = T2.ATTR_CODE
			          LEFT JOIN  (SELECT A3.USER_ID, A3.ATTR_CODE, A3.ATTR_VALUE FROM E_USER_ATTRIBUTE A3 WHERE A3.USER_ID = #userId#) T3 ON T2.ATTR_CODE = T3.ATTR_CODE
			       ) X2 ON X1.SUBSYSTEM_ID = X2.SUBSYSTEM_ID
			       LEFT JOIN E_ROLE X3 ON X1.ROLE_CODE = X3.ROLE_CODE
			       LEFT JOIN D_SUBSYSTEM X4 ON X1.SUBSYSTEM_ID=X4.SUBSYSTEM_ID
		</e:q4l>${e:java2json(allAttrInfo.list) }
	</e:case>
</e:switch>