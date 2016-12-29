<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@page import="java.io.File"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:switch value="${param.eaction}">
	<e:case value="getRoleTreeRootNode">
		<e:q4l var="roleMenus">
			SELECT 
				CONCAT(I.RESOURCES_ID,'') AS "RESOURCES_ID",
				I.RESOURCES_NAME AS "RESOURCES_NAME",
				${param.roleId} AS "ROLE_CODE",
				(case when I.AUTH_CREATE is NULL then 0 else I.AUTH_CREATE end)  AS "AUTH_CREATE",
				(case when I.AUTH_READ  is NULL then 0 else I.AUTH_READ end)  AS "AUTH_READ",
				(case when I.AUTH_UPDATE is NULL then 0 else I.AUTH_UPDATE end)  AS "AUTH_UPDATE",
				(case when I.AUTH_DELETE is NULL then 0 else I.AUTH_DELETE end)  AS "AUTH_DELETE",
				(case when I.AUTH_EXPORT is NULL then 0 else I.AUTH_EXPORT end)  AS "AUTH_EXPORT",
				(case when I.AUTH_ISSUED is NULL then 0 else I.AUTH_ISSUED end)  AS "AUTH_ISSUED",
				case when I.parent_id = '-1' then null else I.parent_id end "_parentId",
				case when I.parent_id = '-1' then 'open' when exists (select resources_id from e_menu where e_menu.parent_id=i.resources_id) then 'closed' else 'open' end "state" 
			FROM (SELECT X.*,Y.* FROM 
						(SELECT A.RESOURCES_ID,A.RESOURCES_NAME,A.PARENT_ID,A.ORD,A.URL FROM E_MENU A WHERE (PARENT_ID='-1' or PARENT_ID='0')
							<e:if condition="${sessionScope.UserInfo.ADMIN!='1'}">
								AND A.RESOURCES_ID IN(
						             SELECT MENU_ID FROM (SELECT Q.MENU_ID,SUM(Q.AUTH_READ) AUTH_READ FROM E_ROLE_PERMISSION Q WHERE Q.ROLE_CODE IN (SELECT ROLE_CODE FROM E_USER_ROLE WHERE USER_ID='${sessionScope.UserInfo.USER_ID}') GROUP BY Q.MENU_ID ) ee WHERE AUTH_READ>0
						             UNION ALL        
						             SELECT MENU_ID FROM (SELECT P.MENU_ID,SUM(P.AUTH_READ) AUTH_READ FROM E_USER_PERMISSION P WHERE P.USER_ID ='${sessionScope.UserInfo.USER_ID}' GROUP BY P.MENU_ID) pp WHERE AUTH_READ>0
						
						         )
					         </e:if>
						) X LEFT JOIN 
						(SELECT Q.MENU_ID,SUM(Q.AUTH_CREATE) AUTH_CREATE,SUM(Q.AUTH_READ) AUTH_READ,SUM(Q.AUTH_UPDATE) AUTH_UPDATE,SUM(Q.AUTH_DELETE) AUTH_DELETE,SUM(Q.AUTH_EXPORT) AUTH_EXPORT,SUM(Q.AUTH_ISSUED) AUTH_ISSUED
						FROM E_ROLE_PERMISSION Q WHERE Q.ROLE_CODE=#roleId# GROUP BY Q.MENU_ID) Y
			 			ON X.RESOURCES_ID = Y.MENU_ID
			 	  ) I order by I.ORD
		</e:q4l>{"rows":${e:java2json(roleMenus.list)}}
	</e:case>
	<e:case value="getRoleTreeChildrenNode">
		<e:q4l var="roleMenus">
			SELECT 
				CONCAT(I.RESOURCES_ID,'') AS "RESOURCES_ID",
				I.RESOURCES_NAME AS "RESOURCES_NAME",
				${param.roleId} AS "ROLE_CODE",
				(case when I.AUTH_CREATE is NULL then 0 else I.AUTH_CREATE end)  AS "AUTH_CREATE",
				(case when I.AUTH_READ  is NULL then 0 else I.AUTH_READ end)  AS "AUTH_READ",
				(case when I.AUTH_UPDATE is NULL then 0 else I.AUTH_UPDATE end)  AS "AUTH_UPDATE",
				(case when I.AUTH_DELETE is NULL then 0 else I.AUTH_DELETE end)  AS "AUTH_DELETE",
				(case when I.AUTH_EXPORT is NULL then 0 else I.AUTH_EXPORT end)  AS "AUTH_EXPORT",
				(case when I.AUTH_ISSUED is NULL then 0 else I.AUTH_ISSUED end)  AS "AUTH_ISSUED",
				case when I.parent_id = '-1' then null else I.parent_id end "_parentId",
				case when exists (select resources_id from e_menu where e_menu.parent_id=i.resources_id) then 'closed' else 'open' end "state" 
			FROM (SELECT X.*,Y.* FROM 
						(SELECT A.RESOURCES_ID,A.RESOURCES_NAME,A.PARENT_ID,A.ORD,A.URL FROM E_MENU A WHERE PARENT_ID=#nodeId#
							<e:if condition="${sessionScope.UserInfo.ADMIN!='1'}">
								AND A.RESOURCES_ID IN(
						             SELECT MENU_ID FROM (SELECT Q.MENU_ID,SUM(Q.AUTH_READ) AUTH_READ FROM E_ROLE_PERMISSION Q WHERE Q.ROLE_CODE IN (SELECT ROLE_CODE FROM E_USER_ROLE WHERE USER_ID='${sessionScope.UserInfo.USER_ID}') GROUP BY Q.MENU_ID) ee WHERE AUTH_READ>0
						             UNION ALL        
						             SELECT MENU_ID FROM (SELECT P.MENU_ID,SUM(P.AUTH_READ) AUTH_READ FROM E_USER_PERMISSION P WHERE P.USER_ID ='${sessionScope.UserInfo.USER_ID}' GROUP BY P.MENU_ID) pp WHERE AUTH_READ>0
						
						         )
					         </e:if>
						) X LEFT JOIN 
						(SELECT Q.MENU_ID,SUM(Q.AUTH_CREATE) AUTH_CREATE,SUM(Q.AUTH_READ) AUTH_READ,SUM(Q.AUTH_UPDATE) AUTH_UPDATE,SUM(Q.AUTH_DELETE) AUTH_DELETE,SUM(Q.AUTH_EXPORT) AUTH_EXPORT,SUM(Q.AUTH_ISSUED) AUTH_ISSUED
						FROM E_ROLE_PERMISSION Q WHERE Q.ROLE_CODE=#roleId# GROUP BY Q.MENU_ID) Y
			 			ON X.RESOURCES_ID = Y.MENU_ID
			 	  ) I order by I.ORD
		</e:q4l>{"rows":${e:java2json(roleMenus.list)}}
	</e:case>
</e:switch>