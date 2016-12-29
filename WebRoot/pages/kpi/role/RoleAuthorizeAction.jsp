<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@page import="java.io.File"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:switch value="${param.eaction}">
	<e:case value="getRoleTreeRootNode">
		<e:q4l var="roleMenus">
			SELECT X.KPI_KEY ID, 
		           X.KPI_NAME NAME,
             	   #roleId# ROLE_CODE,
	               NVL(R.A,0) KPI_RADE, 
	               NVL(R.B,0) KPI_CREATE, 
	               NVL(R.C,0) KPI_DEL, 
	               NVL(R.D,0) KPI_UPDATE, 
		           CASE WHEN X.PARENT_ID='' THEN NULL ELSE X.PARENT_ID END "_parentId", 
		           CASE WHEN X.PARENT_ID='0' THEN 'OPEN' WHEN EXISTS(SELECT Z.KPI_KEY FROM (
		           SELECT C.CATEGORY_ID KPI_KEY,C.CATEGORY_PARENT_ID PARENT_ID,'' KPI_CODE,C.CATEGORY_NAME KPI_NAME FROM X_KPI_CATEGORY C
		           UNION
		           SELECT I.KPI_KEY,I.KPI_CATEGORY PARENT_ID,I.KPI_CODE,I.KPI_NAME FROM X_KPI_INFO I WHERE I.KPI_STATUS = 2) Z WHERE Z.PARENT_ID = X.KPI_KEY) then 'closed' else 'open' end "state" , 
             R.A,R.B,R.C,R.D
        FROM (SELECT Z.KPI_KEY, Z.PARENT_ID, Z.KPI_CODE, Z.KPI_NAME
                FROM (SELECT C.ID KPI_KEY,
                             C.PARENT_ID PARENT_ID,
                             C.KPI_CODE,
                             C.NAME KPI_NAME
                        FROM VIEW_KPI C) Z) X,
             (SELECT KPI_KEY, ROLE_CODE, SUM(KPI_RADE) A,SUM(KPI_CREATE) B,SUM(KPI_DEL) C,SUM(KPI_UPDATE) D
            	FROM X_ROLE_KPI WHERE ROLE_CODE=#roleId#
               GROUP BY KPI_KEY, ROLE_CODE) R
       WHERE X.KPI_KEY = R.KPI_KEY(+)
		</e:q4l>{"rows":${e:java2json(roleMenus.list)}}
	</e:case>
	<e:case value="getRoleTreeChildrenNode">
		<e:q4l var="roleMenus">
			  SELECT X.KPI_KEY, 
         X.KPI_NAME, 
         CASE WHEN X.PARENT_ID='0' THEN NULL ELSE X.PARENT_ID END "_parentId", 
         CASE WHEN X.PARENT_ID='0' THEN 'OPEN' WHEN EXISTS(SELECT Z.KPI_KEY FROM (
           SELECT C.CATEGORY_ID KPI_KEY,C.CATEGORY_PARENT_ID PARENT_ID,'' KPI_CODE,C.CATEGORY_NAME KPI_NAME FROM X_KPI_CATEGORY C
           UNION
           SELECT I.KPI_KEY,I.KPI_CATEGORY PARENT_ID,I.KPI_CODE,I.KPI_NAME FROM X_KPI_INFO I WHERE I.KPI_STATUS = 2) Z WHERE Z.PARENT_ID = X.KPI_KEY) then 'closed' else 'open' end "state" , 
         R.A
    FROM (SELECT Z.KPI_KEY, Z.PARENT_ID, Z.KPI_CODE, Z.KPI_NAME
            FROM (SELECT C.CATEGORY_ID KPI_KEY,
                         C.CATEGORY_PARENT_ID PARENT_ID,
                         '' KPI_CODE,
                         C.CATEGORY_NAME KPI_NAME
                    FROM X_KPI_CATEGORY C
                  UNION
                  SELECT I.KPI_KEY,
                         I.KPI_CATEGORY PARENT_ID,
                         I.KPI_CODE,
                         I.KPI_NAME
                    FROM X_KPI_INFO I
                   WHERE I.KPI_STATUS = 2) Z
           WHERE Z.PARENT_ID = 0) X,
         (SELECT KPI_KEY, ROLE_CODE, SUM(KPI_RADE) A,SUM(KPI_CREATE) B,SUM(KPI_DEL) C,SUM(KPI_UPDATE) D
            FROM X_ROLE_KPI
           GROUP BY KPI_KEY, ROLE_CODE) R
   WHERE X.KPI_KEY = R.KPI_KEY(+)

		</e:q4l>{"rows":${e:java2json(roleMenus.list)}}
	</e:case>
	<e:case value="add">
		<e:q4o var="ishave">
			SELECT COUNT(1)||'' A FROM X_ROLE_KPI T WHERE T.ROLE_CODE='${param.roleId}' AND T.KPI_KEY='${param.id}'
		</e:q4o>
		<e:if condition="${ishave.A > 0 }" var="ishas">
			<e:if condition="${param.checked=='checked' }" var="ischeck">
				<e:update var="add">
					begin
						UPDATE X_ROLE_KPI T SET 
							<e:switch value="${param.authType}">
								<e:case value="C">
									T.KPI_CREATE = '1'
								</e:case>
								<e:case value="D">
									T.KPI_DEL = '1'
								</e:case>
								<e:case value="U">
									T.KPI_UPDATE = '1'
								</e:case>
							</e:switch>
							WHERE T.ROLE_CODE='${param.roleId}' AND T.KPI_KEY='${param.id}';
					end;
				</e:update>
			</e:if>
			<e:else condition="${ischeck }">
				<e:update var="add">
					begin
						UPDATE X_ROLE_KPI T SET 
							<e:switch value="${param.authType}">
								<e:case value="C">
									T.KPI_CREATE = '0'
								</e:case>
								<e:case value="D">
									T.KPI_DEL = '0'
								</e:case>
								<e:case value="U">
									T.KPI_UPDATE = '0'
								</e:case>
							</e:switch>
							WHERE T.ROLE_CODE='${param.roleId}' AND T.KPI_KEY='${param.id}';
					end;
				</e:update>
			</e:else>
		</e:if>
		<e:else condition="${ishas }">
				<e:update var="add">
					begin
						INSERT INTO X_ROLE_KPI(ROLE_CODE,KPI_KEY,KPI_RADE
							<e:switch value="${param.authType}">
								<e:case value="C">
									,KPI_CREATE
								</e:case>
								<e:case value="D">
									,KPI_DEL
								</e:case>
								<e:case value="U">
									,KPI_UPDATE
								</e:case>
							</e:switch>
						) VALUES ('${param.roleId}','${param.id}','1'
							<e:switch value="${param.authType}">
								<e:case value="C">
									,'1'
								</e:case>
								<e:case value="D">
									,'1'
								</e:case>
								<e:case value="U">
									,'1'
								</e:case>
							</e:switch>
						);
					end;
				</e:update>
		</e:else>
		${e:java2json(add)}
	</e:case>
</e:switch>