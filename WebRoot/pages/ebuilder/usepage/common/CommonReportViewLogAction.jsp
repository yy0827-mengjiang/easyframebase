<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:switch value="${param.eaction}">
	<e:case value="viewLogList">
		<c:tablequery>
			 SELECT USER_ID, VIEW_TIME
			  FROM SYS_REPORT_VIEW_LOG
			 WHERE SYSDATE - VIEW_TIME < 7
			   AND MENU_ID IN (SELECT MENU_ID
			                     FROM SYS_REPORT_MENU_REL
			                    WHERE REPORT_ID = '${param.reportid}')
			 ORDER BY VIEW_TIME DESC
   		</c:tablequery>
	</e:case>

<e:if condition="${DBSource=='oracle' }">
	<e:case value="addViewLog">
		<e:update var="addViewLog">
			INSERT INTO SYS_REPORT_VIEW_LOG(ID,MENU_ID,USER_ID,VIEW_TIME) VALUES
			('${e:getDate("yyyyMMddHHmmssSSSS")}','${param.menuid}','${sessionScope.UserInfo.LOGIN_ID}',sysdate)
		</e:update>${addViewLog}
	</e:case>
</e:if>
<e:if condition="${DBSource=='mysql' }">
	<e:case value="addViewLog">
		<e:update var="addViewLog">
			INSERT INTO SYS_REPORT_VIEW_LOG(ID,MENU_ID,USER_ID,VIEW_TIME) VALUES
			('${e:getDate("yyyyMMddHHmmssSSSS")}','${param.menuid}','${sessionScope.UserInfo.LOGIN_ID}',now())
		</e:update>${addViewLog}
	</e:case>
</e:if>	
	
</e:switch>