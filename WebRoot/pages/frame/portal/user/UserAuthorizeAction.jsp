<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@page import="java.io.File"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:switch value="${param.eaction}">
	<e:case value="getRoleTreeRootNode">
		<e:q4l var="roleMenus">
			SELECT
			
			    M.RESOURCES_ID "RESOURCES_ID",
			    M.RESOURCES_NAME "RESOURCES_NAME",
			    '${param.userId}' "USER_ID",
			    CASE WHEN R.MENU_ID IS NOT NULL AND (coalesce(R.AUTH_READ,0)+coalesce(R.AUTH_UPDATE,0)+coalesce(R.AUTH_DELETE,0)+coalesce(R.AUTH_EXPORT,0)>0) THEN 'ROLE' ELSE 'USER' END "FLAG",
                CASE WHEN R.MENU_ID IS NOT NULL AND coalesce(R.AUTH_CREATE,0) > 0 THEN coalesce(R.AUTH_CREATE,0) ELSE coalesce(U.AUTH_CREATE,0) END "AUTH_CREATE",
                CASE WHEN R.MENU_ID IS NOT NULL AND coalesce(R.AUTH_READ,0) > 0 THEN coalesce(R.AUTH_READ,0)   ELSE coalesce(U.AUTH_READ,0) END "AUTH_READ",
                CASE WHEN R.MENU_ID IS NOT NULL AND coalesce(R.AUTH_UPDATE,0) > 0 THEN coalesce(R.AUTH_UPDATE,0) ELSE coalesce(U.AUTH_UPDATE,0) END "AUTH_UPDATE",
                CASE WHEN R.MENU_ID IS NOT NULL AND coalesce(R.AUTH_DELETE,0) > 0 THEN coalesce(R.AUTH_DELETE,0) ELSE coalesce(U.AUTH_DELETE,0) END "AUTH_DELETE",
                CASE WHEN R.MENU_ID IS NOT NULL AND coalesce(R.AUTH_EXPORT,0) > 0 THEN coalesce(R.AUTH_EXPORT,0) ELSE coalesce(U.AUTH_EXPORT,0) END "AUTH_EXPORT",
			    CASE WHEN M.PARENT_ID = '-1' THEN NULL ELSE M.PARENT_ID END "_parentId",
			    CASE WHEN M.PARENT_ID = '-1' THEN 'open' WHEN EXISTS (SELECT RESOURCES_ID FROM E_MENU WHERE E_MENU.PARENT_ID=M.RESOURCES_ID) THEN 'closed' ELSE 'open' END "state" 
			 FROM 
			    (SELECT A.RESOURCES_ID,A.RESOURCES_NAME,A.PARENT_ID,A.ORD,A.URL FROM E_MENU A WHERE PARENT_ID='-1' OR PARENT_ID='0'
			    	<e:if condition="${sessionScope.UserInfo.ADMIN!='1'}">
				    	AND A.RESOURCES_ID IN(
				             SELECT MENU_ID FROM (SELECT Q.MENU_ID,SUM(Q.AUTH_READ) AUTH_READ FROM E_ROLE_PERMISSION Q WHERE Q.ROLE_CODE IN (SELECT ROLE_CODE FROM E_USER_ROLE WHERE USER_ID='${sessionScope.UserInfo.USER_ID}') GROUP BY Q.MENU_ID) ERP1 WHERE AUTH_READ>0
				             UNION ALL        
				             SELECT MENU_ID FROM (SELECT P.MENU_ID,SUM(P.AUTH_READ) AUTH_READ FROM E_USER_PERMISSION P WHERE P.USER_ID ='${sessionScope.UserInfo.USER_ID}' GROUP BY P.MENU_ID) EUP1 WHERE AUTH_READ>0
				
				         )
			         </e:if>
			    ) M 
			    LEFT JOIN 
			    (SELECT Q.MENU_ID,SUM(Q.AUTH_CREATE) AUTH_CREATE,SUM(Q.AUTH_READ) AUTH_READ,SUM(Q.AUTH_UPDATE) AUTH_UPDATE,SUM(Q.AUTH_DELETE) AUTH_DELETE,SUM(Q.AUTH_EXPORT) AUTH_EXPORT 
			    FROM E_ROLE_PERMISSION Q WHERE Q.ROLE_CODE IN (SELECT ROLE_CODE FROM E_USER_ROLE WHERE USER_ID='${param.userId}') GROUP BY Q.MENU_ID) R
			    ON M.RESOURCES_ID = R.MENU_ID
			    LEFT JOIN 
			    (SELECT P.MENU_ID,SUM(P.AUTH_CREATE) AUTH_CREATE,SUM(P.AUTH_READ) AUTH_READ,SUM(P.AUTH_UPDATE) AUTH_UPDATE,SUM(P.AUTH_DELETE) AUTH_DELETE,SUM(P.AUTH_EXPORT) AUTH_EXPORT 
			    FROM E_USER_PERMISSION P WHERE P.USER_ID ='${param.userId}' GROUP BY P.MENU_ID) U    
			    ON M.RESOURCES_ID = U.MENU_ID
			    ORDER BY M.RESOURCES_ID
		</e:q4l>{"rows":${e:java2json(roleMenus.list)}}
	</e:case>
	<e:case value="getRoleTreeChildrenNode">
		<e:q4l var="roleMenus">
			SELECT
			    M.RESOURCES_ID "RESOURCES_ID",
			    M.RESOURCES_NAME "RESOURCES_NAME",
			    '${param.userId}' "USER_ID",
			    CASE WHEN R.MENU_ID IS NOT NULL AND (coalesce(R.AUTH_READ,0)+coalesce(R.AUTH_UPDATE,0)+coalesce(R.AUTH_DELETE,0)+coalesce(R.AUTH_EXPORT,0)>0) THEN 'ROLE' ELSE 'USER' END "FLAG",
                CASE WHEN R.MENU_ID IS NOT NULL AND coalesce(R.AUTH_CREATE,0) > 0 THEN coalesce(R.AUTH_CREATE,0) ELSE coalesce(U.AUTH_CREATE,0) END "AUTH_CREATE",
                CASE WHEN R.MENU_ID IS NOT NULL AND coalesce(R.AUTH_READ,0) > 0 THEN coalesce(R.AUTH_READ,0)   ELSE coalesce(U.AUTH_READ,0) END "AUTH_READ",
                CASE WHEN R.MENU_ID IS NOT NULL AND coalesce(R.AUTH_UPDATE,0) > 0 THEN coalesce(R.AUTH_UPDATE,0) ELSE coalesce(U.AUTH_UPDATE,0) END "AUTH_UPDATE",
                CASE WHEN R.MENU_ID IS NOT NULL AND coalesce(R.AUTH_DELETE,0) > 0 THEN coalesce(R.AUTH_DELETE,0) ELSE coalesce(U.AUTH_DELETE,0) END "AUTH_DELETE",
                CASE WHEN R.MENU_ID IS NOT NULL AND coalesce(R.AUTH_EXPORT,0) > 0 THEN coalesce(R.AUTH_EXPORT,0) ELSE coalesce(U.AUTH_EXPORT,0) END "AUTH_EXPORT",
			    CASE WHEN M.PARENT_ID = '-1' THEN NULL ELSE M.PARENT_ID END "_parentId",
			    CASE WHEN EXISTS (SELECT RESOURCES_ID FROM E_MENU WHERE E_MENU.PARENT_ID=M.RESOURCES_ID) THEN 'closed' ELSE 'open' END "state" 
			 FROM 
			    (SELECT A.RESOURCES_ID,A.RESOURCES_NAME,A.PARENT_ID,A.ORD,A.URL FROM E_MENU A WHERE PARENT_ID=#nodeId#
			    	<e:if condition="${sessionScope.UserInfo.ADMIN!='1'}">
				    	AND A.RESOURCES_ID IN(
				             SELECT MENU_ID FROM (SELECT Q.MENU_ID,SUM(Q.AUTH_READ) AUTH_READ FROM E_ROLE_PERMISSION Q WHERE Q.ROLE_CODE IN (SELECT ROLE_CODE FROM E_USER_ROLE WHERE USER_ID='${sessionScope.UserInfo.USER_ID}') GROUP BY Q.MENU_ID) ERP WHERE AUTH_READ>0
				             UNION ALL        
				             SELECT MENU_ID FROM (SELECT P.MENU_ID,SUM(P.AUTH_READ) AUTH_READ FROM E_USER_PERMISSION P WHERE P.USER_ID ='${sessionScope.UserInfo.USER_ID}' GROUP BY P.MENU_ID) EUP WHERE AUTH_READ>0
				
				         )
			         </e:if>
			    ) M 
			    LEFT JOIN
			    (SELECT Q.MENU_ID,SUM(Q.AUTH_CREATE) AUTH_CREATE,SUM(Q.AUTH_READ) AUTH_READ,SUM(Q.AUTH_UPDATE) AUTH_UPDATE,SUM(Q.AUTH_DELETE) AUTH_DELETE,SUM(Q.AUTH_EXPORT) AUTH_EXPORT 
			    FROM E_ROLE_PERMISSION Q WHERE Q.ROLE_CODE IN (SELECT ROLE_CODE FROM E_USER_ROLE WHERE USER_ID=#userId#) GROUP BY Q.MENU_ID) R 
			    ON M.RESOURCES_ID = R.MENU_ID
			    LEFT JOIN 
			    (SELECT P.MENU_ID,SUM(P.AUTH_CREATE) AUTH_CREATE,SUM(P.AUTH_READ) AUTH_READ,SUM(P.AUTH_UPDATE) AUTH_UPDATE,SUM(P.AUTH_DELETE) AUTH_DELETE,SUM(P.AUTH_EXPORT) AUTH_EXPORT 
			    FROM E_USER_PERMISSION P WHERE P.USER_ID =#userId# GROUP BY P.MENU_ID) U 
			    ON M.RESOURCES_ID = U.MENU_ID
			    ORDER BY M.RESOURCES_ID
		</e:q4l>{"rows":${e:java2json(roleMenus.list)}}
	</e:case>

</e:switch>