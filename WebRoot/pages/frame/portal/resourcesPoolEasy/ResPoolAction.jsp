<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="cn.com.easy.taglib.function.Functions"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%System.out.println(request.getParameter("eaction")); %>
<e:switch value="${param.eaction}">	
	<e:case value="resList">
		<c:tablequery>
			select a.ID,a.RES_NAME,
		             a.RES_STATE,
		             a.URL,
		             a.RES_DESC,
		             a.MODIFY_USER,
		             a.MODIFY_TIME,
		             a.SUB_SYSTEM_ID,
		             a.REJECT_REASON,
		             a.AUDIT_TIME,
		             a.CREATE_TIME,
		             a.CREATE_USER CREATE_USER_ID,
		             a.MENU_POSITION,
		             a.MENU_POSITION_EXT,
		             a.SUBSYSTEM_NAME,
		             b.user_name create_user,
		             c.user_name audit_user,
		             a.SUBSYSTEM_ADDRESS,
		             a.SUBSYSTEM_ADDRESS2
		             from (SELECT d.*,s.SUBSYSTEM_NAME,s.SUBSYSTEM_ADDRESS,s.SUBSYSTEM_ADDRESS2
						       FROM D_RESOURCE_POOL d,D_SUBSYSTEM s
						       WHERE d.SUB_SYSTEM_ID=s.SUBSYSTEM_ID(+)
						       and d.RES_STATE='0'
						   <e:if condition="${param.qName!=null&&param.qName!=''}">
								AND d.RES_NAME like '%${param.qName}%' 
							</e:if> 
							<e:if condition="${param.qSubSys!=null&&param.qSubSys!=''}">
								AND d.SUB_SYSTEM_ID = '${param.qSubSys}' 
							</e:if> 
			 ORDER BY d.CREATE_TIME DESC) a,E_USER b,E_USER c
       where a.CREATE_USER=b.user_id(+) and a.audit_user=c.user_id(+) 
   		</c:tablequery>
	</e:case>	
</e:switch>