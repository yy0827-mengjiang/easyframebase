<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ page import="cn.com.easy.ebuilder.parser.CommonTools"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%
String menuName=request.getParameter("menuName")==null?"":request.getParameter("menuName");
String isMessyCode_menuName = request.getParameter("menuName");

if(isMessyCode_menuName == null || isMessyCode_menuName.equals("") || isMessyCode_menuName.toUpperCase().equals("NULL")){
   isMessyCode_menuName = request.getAttribute("menuName") + "";
}
if(isMessyCode_menuName == null || isMessyCode_menuName.equals("") || isMessyCode_menuName.toUpperCase().equals("NULL")){
   isMessyCode_menuName = request.getSession().getAttribute("menuName") + "";
}
isMessyCode_menuName = isMessyCode_menuName!=null?new String(isMessyCode_menuName.getBytes("ISO-8859-1"),"UTF-8"):"";
String isMessyCode_menuName1 = request.getParameter("menuName");
if(isMessyCode_menuName1 == null || isMessyCode_menuName1.equals("") || isMessyCode_menuName1.toUpperCase().equals("NULL")){
   isMessyCode_menuName1 = request.getAttribute("menuName") + "";
}
if(isMessyCode_menuName1 == null || isMessyCode_menuName1.equals("") || isMessyCode_menuName1.toUpperCase().equals("NULL")){
   isMessyCode_menuName1 = request.getSession().getAttribute("menuName") + "";}
isMessyCode_menuName1 = isMessyCode_menuName1!=null?new String(isMessyCode_menuName1.getBytes("ISO-8859-1"),"gb2312"):"";

if(CommonTools.isMessyCode(menuName)){
	if(!CommonTools.isMessyCode(isMessyCode_menuName)){
		request.setAttribute("menuName",isMessyCode_menuName);
	}
	else if(!CommonTools.isMessyCode(isMessyCode_menuName1)){
		request.setAttribute("menuName",isMessyCode_menuName1);
	}
	
}else{
	
	request.setAttribute("menuName",menuName);
}
%>

<%
String userName=request.getParameter("userName")==null?"":request.getParameter("userName");
String isMessyCode_userName = request.getParameter("userName");

if(isMessyCode_userName == null || isMessyCode_userName.equals("") || isMessyCode_userName.toUpperCase().equals("NULL")){
   isMessyCode_userName = request.getAttribute("userName") + "";
}
if(isMessyCode_userName == null || isMessyCode_userName.equals("") || isMessyCode_userName.toUpperCase().equals("NULL")){
   isMessyCode_userName = request.getSession().getAttribute("userName") + "";
}
isMessyCode_userName = isMessyCode_userName!=null?new String(isMessyCode_userName.getBytes("ISO-8859-1"),"UTF-8"):"";
String isMessyCode_userName1 = request.getParameter("userName");
if(isMessyCode_userName1 == null || isMessyCode_userName1.equals("") || isMessyCode_userName1.toUpperCase().equals("NULL")){
   isMessyCode_userName1 = request.getAttribute("userName") + "";
}
if(isMessyCode_userName1 == null || isMessyCode_userName1.equals("") || isMessyCode_userName1.toUpperCase().equals("NULL")){
   isMessyCode_userName1 = request.getSession().getAttribute("userName") + "";}
isMessyCode_userName1 = isMessyCode_userName1!=null?new String(isMessyCode_userName1.getBytes("ISO-8859-1"),"gb2312"):"";

if(CommonTools.isMessyCode(userName)){
	if(!CommonTools.isMessyCode(isMessyCode_userName)){
		request.setAttribute("userName",isMessyCode_userName);
	}
	else if(!CommonTools.isMessyCode(isMessyCode_userName1)){
		request.setAttribute("userName",isMessyCode_userName1);
	}
	
}else{
	
	request.setAttribute("userName",userName);
}
%>

<e:if condition="${DBSource=='oracle' }">
	<e:switch value="${param.eaction}">
		<e:case value="loginLog">
			<c:tablequery>
				SELECT T.SESSION_ID,
			       DECODE(T.STATE,0,'活动','非活动') STATE,
			       A.LOGIN_ID,
			       C.AREA_DESC,
			       A.USER_NAME,
			       T.CLIENT_IP,
			       TO_CHAR(T.LOGIN_DATE,'YYYY-MM-DD HH24:MI:SS') LOGIN_DATE,
			       TO_CHAR(T.LOGOUT_DATE,'YYYY-MM-DD HH24:MI:SS') LOGOUT_DATE,
			       T.CLIENT_BROWSOR
			  FROM E_LOGIN_LOG T,E_USER A,
			  ( select '-1' area_no,'全省' area_desc, '0' ord from dual
                        union all
                      select area_no,area_desc,ord from cmcode_area
                     ) C,
        		(SELECT X.USER_ID,X.ATTR_VALUE  FROM E_USER_ATTRIBUTE X WHERE X.ATTR_CODE='AREA_NO') E
			  WHERE T.USER_ID=A.USER_ID(+)
			  AND T.USER_ID=E.USER_ID(+)
			  AND NVL(E.ATTR_VALUE,'-1')=C.AREA_NO(+)
			  AND T.USER_ID IN(
			  	SELECT USER_ID FROM E_USER_ACCOUNT WHERE ACCOUNT_CODE IN(select ACCOUNT_CODE from E_USER_ACCOUNT where user_id = '${sessionScope.UserInfo.USER_ID}')
			  )
			  <e:if condition="${param.area_no!=null&&param.area_no!=''&&param.area_no!='-1'}">
			  	AND C.AREA_NO = #area_no#
			  </e:if>
			  <e:if condition="${param.loginId!=null&&param.loginId!=''}">
			  	AND A.LOGIN_ID LIKE '%'||#loginId#||'%'
			  </e:if>
			  <e:if condition="${param.clientIp!=null&&param.clientIp!=''}">
			 	AND T.CLIENT_IP LIKE '%'||#clientIp#||'%'
			  </e:if>
			  <e:if condition="${param.loginDate!=null&&param.loginDate!=''}">
			 	AND TO_CHAR(T.LOGIN_DATE,'YYYYMMDD')>=#loginDate#
			  </e:if>
			  <e:if condition="${param.loginDate1!=null&&param.loginDate1!=''}">
			 	AND TO_CHAR(T.LOGIN_DATE,'YYYYMMDD')<=#loginDate1#
			  </e:if>
			  <e:if condition="${param.loginDate==null||param.loginDate==''}">
			 	AND TO_CHAR(T.LOGIN_DATE,'YYYYMMDD')=TO_CHAR(SYSDATE,'YYYYMMDD')
			  </e:if>
			  ORDER BY LOGIN_DATE DESC
			</c:tablequery>
		</e:case>
		<e:case value="visitLog">
			<c:tablequery>
				SELECT C.LOGIN_ID,
			       C.USER_NAME,
			       CM.AREA_DESC,
			       substr(B.MENU_PATH,2, length(B.MENU_PATH)) MENU_ID,
			       D.OPERATE_TYPE_DESC OPERATE_TYPE_CODE,
			       DECODE(NVL(A.OPERATE_RESULT,0),'1','成功','失败') OPERATE_RESULT,
			       A.CONTENT,
			       A.CLIENT_IP,
			       TO_CHAR(A.CREATE_DATE,'YYYY-MM-DD HH24:MI:SS') CREATE_DATE
			  FROM (SELECT * FROM E_OPERATION_LOG TT
			        WHERE TT.OPERATE_TYPE_CODE='1'
			          <e:if condition="${param.operateTypeCode!=null&&param.operateTypeCode!=''}">
					  	AND TT.OPERATE_TYPE_CODE=#operateTypeCode#
					  </e:if>
			          <e:if condition="${param.loginDate!=null&&param.loginDate!=''}">
					 	AND TO_CHAR(TT.CREATE_DATE,'YYYYMMDD')>=#loginDate#
					  </e:if>
					  <e:if condition="${param.loginDate1!=null&&param.loginDate1!=''}">
					 	AND TO_CHAR(TT.CREATE_DATE,'YYYYMMDD')<=#loginDate1#
					  </e:if>
			       ) A,
			       (SELECT T.RESOURCES_ID,SYS_CONNECT_BY_PATH(T.RESOURCES_NAME, '>') MENU_PATH,T.ORD,EXT1
			               FROM E_MENU T START WITH T.RESOURCES_ID='0'
			        CONNECT BY PRIOR  T.RESOURCES_ID=T.PARENT_ID) B,
			        E_USER C,
			        E_OPERATE_TYPE D,
			        ( select '-1' area_no,'全省' area_desc, '0' ord from dual
                        union all
                      select area_no,area_desc,ord from cmcode_area
                     ) CM,
        		(SELECT X.USER_ID,X.ATTR_VALUE  FROM E_USER_ATTRIBUTE X WHERE X.ATTR_CODE='AREA_NO') E
			  WHERE A.MENU_ID=B.RESOURCES_ID(+)
			    AND A.USER_ID=C.USER_ID(+)
			    AND A.OPERATE_TYPE_CODE=D.OPERATE_TYPE_CODE(+)
			    AND A.USER_ID=E.USER_ID(+)
   				AND NVL(E.ATTR_VALUE,'-1')=CM.AREA_NO(+)
   				AND A.USER_ID IN(
					SELECT USER_ID FROM E_USER_ACCOUNT WHERE ACCOUNT_CODE IN(select ACCOUNT_CODE from E_USER_ACCOUNT where user_id = '${sessionScope.UserInfo.USER_ID}')
				)
			    <e:if condition="${param.area_no!=null&&param.area_no!=''&&param.area_no!='-1'}">
			  		AND CM.AREA_NO = #area_no#
			  	</e:if>
			     <e:if condition="${param.loginId!=null&&param.loginId!=''}">
				  	AND C.LOGIN_ID LIKE '%'||#loginId#||'%'
				  </e:if>
			    <e:if condition="${param.menuName!=null&&param.menuName!=''}">
					AND B.MENU_PATH LIKE '%'||#menuName#||'%'
				</e:if>
				<e:if condition="${param.userName!=null&&param.userName!=''}">
					AND C.USER_NAME LIKE '%'||#userName#||'%'
				</e:if>
				<e:if condition="${param.subSystemId!=null&&param.subSystemId!=''&&param.subSystemId!='-1'}">
					AND B.EXT1=#subSystemId#
				</e:if>
				ORDER BY A.CREATE_DATE DESC
			</c:tablequery>
		</e:case>
		<e:case value="visitMenuLog">
			<c:tablequery>
				SELECT substr(B.MENU_PATH,2, length(B.MENU_PATH)) MENU_ID,count(*) VISIT_NUM
			  FROM (SELECT * FROM E_OPERATION_LOG TT
			        WHERE TT.OPERATE_TYPE_CODE='1'
			          <e:if condition="${param.loginDate!=null&&param.loginDate!=''}">
					 	AND TO_CHAR(TT.CREATE_DATE,'YYYYMMDD')>=#loginDate#
					  </e:if>
					  <e:if condition="${param.loginDate1!=null&&param.loginDate1!=''}">
					 	AND TO_CHAR(TT.CREATE_DATE,'YYYYMMDD')<=#loginDate1#
					  </e:if>
			       ) A,
			       (SELECT T.RESOURCES_ID,SYS_CONNECT_BY_PATH(T.RESOURCES_NAME, '>') MENU_PATH,T.ORD 
			               FROM E_MENU T START WITH T.RESOURCES_ID='0'
			        CONNECT BY PRIOR  T.RESOURCES_ID=T.PARENT_ID) B
			  WHERE A.MENU_ID=B.RESOURCES_ID(+)
			  AND A.USER_ID IN(
				SELECT USER_ID FROM E_USER_ACCOUNT WHERE ACCOUNT_CODE IN(select ACCOUNT_CODE from E_USER_ACCOUNT where user_id = '${sessionScope.UserInfo.USER_ID}')
			  )
			  group by B.MENU_PATH 
			  order by count(*) desc
			</c:tablequery>
		</e:case>
		<e:case value="operationLog">
			<c:tablequery>
				SELECT C.LOGIN_ID,
			       C.USER_NAME,
			       CM.AREA_DESC,
			       substr(B.MENU_PATH,2, length(B.MENU_PATH)) MENU_ID,
			       D.OPERATE_TYPE_DESC OPERATE_TYPE_CODE,
			       DECODE(NVL(A.OPERATE_RESULT,0),'1','成功','失败') OPERATE_RESULT,
			       A.CONTENT,
			       A.CLIENT_IP,
			       TO_CHAR(A.CREATE_DATE,'YYYY-MM-DD HH24:MI:SS') CREATE_DATE
			  FROM (SELECT * FROM E_OPERATION_LOG TT
			        WHERE TT.OPERATE_TYPE_CODE!='1'
			          <e:if condition="${param.operateTypeCode!=null&&param.operateTypeCode!=''}">
					  	AND TT.OPERATE_TYPE_CODE=#operateTypeCode#
					  </e:if>
			          <e:if condition="${param.loginDate!=null&&param.loginDate!=''}">
					 	AND TO_CHAR(TT.CREATE_DATE,'YYYYMMDD')>=#loginDate#
					  </e:if>
					  <e:if condition="${param.loginDate1!=null&&param.loginDate1!=''}">
					 	AND TO_CHAR(TT.CREATE_DATE,'YYYYMMDD')<=#loginDate1#
					  </e:if>
			       ) A,
			       (SELECT T.RESOURCES_ID,SYS_CONNECT_BY_PATH(T.RESOURCES_NAME, '>') MENU_PATH,T.ORD 
			               FROM E_MENU T START WITH T.RESOURCES_ID='0'
			        CONNECT BY PRIOR  T.RESOURCES_ID=T.PARENT_ID) B,
			        E_USER C,
			        E_OPERATE_TYPE D,
			        ( select '-1' area_no,'全省' area_desc, '0' ord from dual
                        union all
                      select area_no,area_desc,ord from cmcode_area
                     ) CM,
                     (SELECT X.USER_ID,X.ATTR_VALUE  FROM E_USER_ATTRIBUTE X WHERE X.ATTR_CODE='AREA_ID') E
			  WHERE A.MENU_ID=B.RESOURCES_ID(+)
			    AND A.USER_ID=C.USER_ID(+)
			    AND A.OPERATE_TYPE_CODE=D.OPERATE_TYPE_CODE(+)
			    AND A.USER_ID=E.USER_ID(+)
   				AND NVL(E.ATTR_VALUE,'-1')=CM.AREA_NO(+)
   				AND A.USER_ID IN(
					SELECT USER_ID FROM E_USER_ACCOUNT WHERE ACCOUNT_CODE IN(select ACCOUNT_CODE from E_USER_ACCOUNT where user_id = '${sessionScope.UserInfo.USER_ID}')
				)
			    <e:if condition="${param.area_no!=null&&param.area_no!=''&&param.area_no!='-1'}">
			  		AND CM.AREA_NO = #area_no#
			  	</e:if>
			    <e:if condition="${param.loginId!=null&&param.loginId!=''}">
				  	AND C.LOGIN_ID LIKE '%'||#loginId#||'%'
				</e:if>
			    <e:if condition="${param.menuName!=null&&param.menuName!=''}">
					AND B.MENU_PATH LIKE '%'||#menuName#||'%'
				</e:if>
				<e:if condition="${param.userName!=null&&param.userName!=''}">
					AND C.USER_NAME LIKE '%'||#userName#||'%'
				</e:if>
				ORDER BY A.CREATE_DATE DESC
			</c:tablequery>
		</e:case>
		<e:case value="writeSelectLog">
			<e:update var="insertSelectLog">
				insert into E_OPERATION_LOG(USER_ID,MENU_ID,OPERATE_TYPE_CODE,OPERATE_RESULT,CONTENT,CLIENT_IP,CREATE_DATE) VALUES('${sessionScope.UserInfo.USER_ID}',#menuId#,'1','1','查询  ${param.menuName }','${sessionScope.UserInfo.IP}',sysdate)
			</e:update>${insertSelectLog }
		</e:case>
		
		<e:case value="userLoginRank">
			<c:tablequery>
				SELECT T.USER_ID, RTA.USER_NAME, RTA.AREA_DESC, COUNT(1) LOGIN_COU
					  FROM (SELECT *
					          FROM E_LOGIN_LOG T
					         WHERE 1=1
					         <e:if condition="${param.loginDate!=null&&param.loginDate!=''}">
							 	AND TO_CHAR(T.LOGIN_DATE,'YYYYMMDD') >= #loginDate#
							  </e:if>
							  <e:if condition="${param.endDate!=null&&param.endDate!=''}">
							 	AND TO_CHAR(T.LOGIN_DATE,'YYYYMMDD') <= #endDate#
							  </e:if>
					         
					         ) T,
					       
					       (SELECT R.USER_ID, R.USER_NAME, TA.AREA_NO, TA.AREA_DESC
					          FROM E_USER R,
					               (SELECT T.USER_ID, T.AREA_NO, A.AREA_DESC
					                  FROM (SELECT T.USER_ID,
					                               CASE
					                                 WHEN T.ATTR_CODE = 'AREA_NO' THEN
					                                  T.ATTR_VALUE
					                               END AREA_NO,
					                               CASE
					                                 WHEN T.ATTR_CODE = 'CITY_NO' THEN
					                                  T.ATTR_VALUE
					                               END CITY_NO
					                          FROM E_USER_ATTRIBUTE T
					                         WHERE T.ATTR_CODE IN ('AREA_NO', 'CITY_NO')) T,
					                       CMCODE_AREA A
					                 WHERE T.AREA_NO = A.AREA_NO) TA
					         WHERE R.USER_ID = TA.USER_ID(+)) RTA
					
					 WHERE T.USER_ID = RTA.USER_ID(+)
					 AND T.USER_ID IN(
						SELECT USER_ID FROM E_USER_ACCOUNT WHERE ACCOUNT_CODE IN(select ACCOUNT_CODE from E_USER_ACCOUNT where user_id = '${sessionScope.UserInfo.USER_ID}')
					 )
					 GROUP BY T.USER_ID, RTA.USER_NAME, RTA.AREA_DESC
					 ORDER BY COUNT(1) DESC
	
			</c:tablequery>
		</e:case>
		
	</e:switch>
</e:if>
<e:if condition="${DBSource=='mysql' }">
	<e:switch value="${param.eaction}">
		<e:case value="loginLog">
			<c:tablequery>
				SELECT T.SESSION_ID,
				   CASE WHEN T.STATE = 0 THEN
				   '活动'
				   ELSE
				   '非活动'
				   END STATE, 
			       A.LOGIN_ID,
			       A.USER_NAME,
			       T.CLIENT_IP,
			       date_format(T.LOGIN_DATE,'%Y-%m-%d %h:%i:%s') LOGIN_DATE,
			       date_format(T.LOGOUT_DATE,'%Y-%m-%d %h:%i:%s') LOGOUT_DATE,
			       T.CLIENT_BROWSOR
			  FROM E_LOGIN_LOG T left join E_USER A
			  on T.USER_ID=A.USER_ID
			  where 1 = 1
			  <e:if condition="${param.loginId!=null&&param.loginId!=''}">
			  	AND A.LOGIN_ID LIKE '%'||#loginId#||'%'
			  </e:if>
			  <e:if condition="${param.clientIp!=null&&param.clientIp!=''}">
			 	AND T.CLIENT_IP LIKE '%'||#clientIp#||'%'
			  </e:if>
			  <e:if condition="${param.loginDate!=null&&param.loginDate!=''}">
			 	AND date_format(T.LOGIN_DATE, '%Y%m%d') =#loginDate#
			  </e:if>
			  <e:if condition="${param.loginDate==null||param.loginDate==''}">
			 	AND date_format(T.LOGIN_DATE, '%Y%m%d') =TO_CHAR(now(),'%Y%m%d')
			  </e:if>
			  ORDER BY LOGIN_DATE DESC
			</c:tablequery>
		</e:case>
		<e:case value="visitMenuLog">
			<c:tablequery>
				SELECT B.MENU_PATH MENU_ID,count(*) VISIT_NUM
			  FROM (SELECT * FROM E_OPERATION_LOG TT
			        WHERE TT.OPERATE_TYPE_CODE='1'
			          <e:if condition="${param.loginDate!=null&&param.loginDate!=''}">
					 	AND date_format(TT.CREATE_DATE, '%Y%m%d') =#loginDate#
					  </e:if>
					  <e:if condition="${param.loginDate==null||param.loginDate==''}">
					 	AND date_format(TT.CREATE_DATE, '%Y%m%d') =TO_CHAR(now(),'%Y%m%d')
					  </e:if>
			       ) A left join 
			       (SELECT T.RESOURCES_ID,getParentList(T.RESOURCES_NAME) MENU_PATH,T.ORD 
			               FROM E_MENU T 
						WHERE FIND_IN_SET(RESOURCES_ID, getChildList(0))) B
			  on A.MENU_ID=B.RESOURCES_ID
			  group by B.MENU_PATH 
			  order by count(*) desc
			</c:tablequery>
		</e:case>
		<e:case value="operationLog">
			<c:tablequery>
				SELECT C.LOGIN_ID,
			       C.USER_NAME,
			       substring(B.MENU_PATH,2, length(B.MENU_PATH)) MENU_ID,
			       D.OPERATE_TYPE_DESC OPERATE_TYPE_CODE,
			       CASE WHEN IFNULL(A.OPERATE_RESULT,0)='1' THEN '成功'
			       ELSE
			       '失败'
			       END OPERATE_RESULT,
			       A.CONTENT,
			       A.CLIENT_IP,
			       date_format(A.CREATE_DATE,'%Y-%m-%d %h:%i:%s') CREATE_DATE
			  FROM (SELECT * FROM E_OPERATION_LOG TT
			        WHERE TT.OPERATE_TYPE_CODE!='1'
			          <e:if condition="${param.operateTypeCode!=null&&param.operateTypeCode!=''}">
					  	AND TT.OPERATE_TYPE_CODE=#operateTypeCode#
					  </e:if>
			          <e:if condition="${param.loginDate!=null&&param.loginDate!=''}">
					 	AND date_format(TT.CREATE_DATE, '%Y%m%d') =#loginDate#
					  </e:if>
					  <e:if condition="${param.loginDate==null||param.loginDate==''}">
					 	AND date_format(TT.CREATE_DATE, '%Y%m%d') =TO_CHAR(now(),'%Y%m%d')
					  </e:if>
			       ) A left join 
			       (SELECT T.RESOURCES_ID,getParentList(T.RESOURCES_NAME) MENU_PATH,T.ORD 
			               FROM E_MENU T 
						WHERE FIND_IN_SET(RESOURCES_ID, getChildList(0))) B
			        on A.MENU_ID=B.RESOURCES_ID
			        left join
			        E_USER C
			        on A.USER_ID=C.USER_ID
			        left join
			        E_OPERATE_TYPE D
			        on A.OPERATE_TYPE_CODE=D.OPERATE_TYPE_CODE
			  WHERE 1 = 1
			    <e:if condition="${param.loginId!=null&&param.loginId!=''}">
				  	AND C.LOGIN_ID LIKE '%'||#loginId#||'%'
				</e:if>
			    <e:if condition="${param.menuName!=null&&param.menuName!=''}">
					AND B.MENU_PATH LIKE '%'||#menuName#||'%'
				</e:if>
				<e:if condition="${param.userName!=null&&param.userName!=''}">
					AND C.USER_NAME LIKE '%'||#userName#||'%'
				</e:if>
				ORDER BY A.CREATE_DATE DESC
			</c:tablequery>
		</e:case>
		
		<e:case value="writeSelectLog">
			<e:update var="insertSelectLog">
				insert into E_OPERATION_LOG(USER_ID,MENU_ID,OPERATE_TYPE_CODE,OPERATE_RESULT,CONTENT,CLIENT_IP,CREATE_DATE) VALUES('${sessionScope.UserInfo.USER_ID}',#menuId#,'1','1','查询  ${param.menuName }','${sessionScope.UserInfo.IP}',now())
			</e:update>${insertSelectLog }
		</e:case>
		
		<e:case value="userLoginRank">
			<c:tablequery>
				SELECT T.USER_ID, RTA.USER_NAME, RTA.AREA_DESC, COUNT(1) LOGIN_COU
					  FROM (SELECT *
					          FROM E_LOGIN_LOG T
					         WHERE 1=1
					         <e:if condition="${param.loginDate!=null&&param.loginDate!=''}">
							 	AND date_format(T.LOGIN_DATE,'%Y%m%d') >= #loginDate#
							  </e:if>
							  <e:if condition="${param.endDate!=null&&param.endDate!=''}">
							 	AND date_format(T.LOGIN_DATE,'%Y%m%d') <= #endDate#
							  </e:if>
					         
					         ) T left join
					       
					       (SELECT R.USER_ID, R.USER_NAME, TA.AREA_NO, TA.AREA_DESC
					          FROM E_USER R left join
					               (SELECT T.USER_ID, T.AREA_NO, A.AREA_DESC
					                  FROM (SELECT T.USER_ID,
					                               CASE
					                                 WHEN T.ATTR_CODE = 'AREA_NO' THEN
					                                  T.ATTR_VALUE
					                               END AREA_NO,
					                               CASE
					                                 WHEN T.ATTR_CODE = 'CITY_NO' THEN
					                                  T.ATTR_VALUE
					                               END CITY_NO
					                          FROM E_USER_ATTRIBUTE T
					                         WHERE T.ATTR_CODE IN ('AREA_NO', 'CITY_NO')) T,
					                       CMCODE_AREA A
					                 WHERE T.AREA_NO = A.AREA_NO) TA
					         on R.USER_ID = TA.USER_ID) RTA
					
					 on T.USER_ID = RTA.USER_ID
					 GROUP BY T.USER_ID, RTA.USER_NAME, RTA.AREA_DESC
					 ORDER BY COUNT(1) DESC
	
			</c:tablequery>
		</e:case>
	</e:switch>
</e:if>
