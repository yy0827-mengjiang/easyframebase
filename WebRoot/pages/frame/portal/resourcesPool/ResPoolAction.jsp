<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="cn.com.easy.taglib.function.Functions"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%System.out.println(request.getParameter("eaction")); %>
<e:switch value="${param.eaction}">
	
	<e:case value="add">
	    <e:q4o var="next">select D_RES_SEQ.Nextval ID from dual</e:q4o>
		<e:update var="addRes">
			insert into D_RESOURCE_POOL(ID,RES_NAME,RES_STATE,URL,RES_DESC,SUB_SYSTEM_ID,CREATE_TIME,CREATE_USER) 
			values(${next.ID},#resName#,0,#url#,#resDesc#,#subSysId#,sysdate,${UserInfo.USER_ID})
		</e:update>${addRes},${next.ID}
	</e:case>
	
	<e:case value="edit">
		<e:update var="editRes">
			update D_RESOURCE_POOL set RES_NAME=#resName#,URL=#url#,RES_DESC=#resDesc#,SUB_SYSTEM_ID=#subSysId#,
			MODIFY_USER=${UserInfo.USER_ID},MODIFY_TIME=sysdate where ID=#resID# 
		</e:update>${editRes}
	</e:case>
	
	<e:case value="resList">
	     <e:if condition="${param.auditState eq '' }">
					<e:set var="auditIdSql">AND d.ID in (select RES_ID from D_RESOURCE_TEAMWORK t where t.USER_ID = '${param.userId}') </e:set>		      
		 </e:if>
	     <e:if condition="${param.auditState eq '0' }">
					<e:set var="auditIdSql">AND d.ID in (select RES_ID from D_RESOURCE_TEAMWORK t where t.USER_ID = '${param.userId}' and t.COMMENT_TIME is null)</e:set>		       
		 </e:if>
		 <e:if condition="${param.auditState eq '1' }">
				<e:set var="auditIdSql">AND d.ID in (select RES_ID from D_RESOURCE_TEAMWORK t where t.USER_ID = '${param.userId}'  and t.COMMENT_TIME is not null)</e:set>			       
		 </e:if>
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
		             a.comm_count,
		             (case when a.comm_count=0 then '未审' else '已审' end ) IS_AUDIT ,
		             b.user_name create_user,
		             c.user_name audit_user,
		             a.SUBSYSTEM_ADDRESS,
		             a.SUBSYSTEM_ADDRESS2
		             from (SELECT d.*,s.SUBSYSTEM_NAME,s.SUBSYSTEM_ADDRESS,
						s.SUBSYSTEM_ADDRESS2, nvl(w.comm_count, 0) comm_count FROM D_RESOURCE_POOL d,
					    D_SUBSYSTEM s,(select res_id, count(res_id) comm_count from D_RESOURCE_TEAMWORK
						where comment_time is not null 
						<e:if condition="${param.auditState !=null }">
						  and user_id='${UserInfo.USER_ID}'
						</e:if>
						group by res_id) w
						WHERE d.SUB_SYSTEM_ID = s.SUBSYSTEM_ID(+) and d.id = w.res_id(+)
						   <e:if condition="${param.qName!=null&&param.qName!=''}">
								AND d.RES_NAME like '%${param.qName}%' 
							</e:if> 
							<e:if condition="${param.qState!=null&&param.qState!=''}">
								AND d.RES_STATE = '${param.qState}' 
							</e:if> 
							<e:if condition="${param.qSubSys!=null&&param.qSubSys!=''}">
								AND d.SUB_SYSTEM_ID = '${param.qSubSys}' 
							</e:if> 
							<e:if condition="${param.userId!=null&&param.userId!=''}">
							   ${auditIdSql}
							</e:if>
							
			 ) a,E_USER b,E_USER c
       where a.CREATE_USER=b.user_id(+) and a.audit_user=c.user_id(+)  ORDER BY a.CREATE_TIME DESC
   		</c:tablequery>
	</e:case>
	
	<e:case value="delete">
		<e:update var="deleteRes">
			delete from D_RESOURCE_POOL where ID=#resId#
		</e:update>${deleteRes}
	</e:case>
	
	<e:case value="audit">
		<e:update var="auditRes">
			update D_RESOURCE_POOL set RES_STATE=2,MENU_POSITION=#position#,MENU_POSITION_EXT=#positionExt#,SUB_SYSTEM_ID=#subSysId2#,REJECT_REASON=#rejectReason#,
			AUDIT_USER=${UserInfo.USER_ID},AUDIT_TIME=sysdate,MODIFY_USER=${UserInfo.USER_ID},MODIFY_TIME=sysdate where ID=#resID2#
		</e:update>${auditRes}
	</e:case>
	<e:case value="teamAudit">
		<e:update var="teamAuditCount">
			update D_RESOURCE_TEAMWORK set COMMENTS=#comments#,COMMENT_TIME=sysdate where RES_ID=#resId# and USER_ID=#userId#
		</e:update>${teamAuditCount}
	</e:case>
	
	<e:case value="getTeamwork">
	    <e:q4o var="getTeamworkObj">
	        select comments from D_RESOURCE_TEAMWORK where RES_ID=#resId# and USER_ID=#userId#
	    </e:q4o>${getTeamworkObj.COMMENTS}
	</e:case>
	
	<e:case value="teamworkList">
	    <c:tablequery>
	        select t.COMMENTS,t.COMMENT_TIME,u.USER_NAME from D_RESOURCE_TEAMWORK t,E_USER u where RES_ID=#resId# and t.user_id=u.user_id(+)
	    </c:tablequery>
	</e:case>
	
	
	<e:case value="reject">
		<e:update var="rejectRes">
		    update D_RESOURCE_POOL set RES_STATE=1,MENU_POSITION=#position#,MENU_POSITION_EXT=#positionExt#,SUB_SYSTEM_ID=#subSysId2#,REJECT_REASON=#rejectReason#,
		    AUDIT_USER=${UserInfo.USER_ID},AUDIT_TIME=sysdate,MODIFY_USER=${UserInfo.USER_ID},MODIFY_TIME=sysdate  where ID=#resID2#
		</e:update>${rejectRes}
	</e:case>
	
	<e:case value="launch">
		<e:update var="launchRes">
		    update D_RESOURCE_POOL set RES_STATE=0,MODIFY_USER=${UserInfo.USER_ID},MODIFY_TIME=sysdate  where ID=#resId#
		</e:update>${launchRes}
	</e:case>
	
	<e:case value="publish">
		<e:update var="publishRes">
			update D_RESOURCE_POOL set RES_STATE=3 where ID=#resId#
		</e:update>${publishRes}
	</e:case>
	<e:case value="getUserEmail">
		<e:q4o var="userEmail">
			select EMAIL from E_USER e where e.user_id='${param.userId}'
		</e:q4o>${userEmail.EMAIL}
	</e:case>
	
	<e:case value="getUserMobile">
		<e:q4o var="userMobile">
			select MOBILE from E_USER e where e.user_id='${param.userId}'
		</e:q4o>${userMobile.MOBILE}
	</e:case>
	
	<e:case value="addMsg">
		<e:update var="addMsgCount">
		  declare
			v_id varchar2(30);
		   begin
		   <e:forEach items="${e:split(param.msgTo,',')}" var="mobile">
		      select D_MESSAGE_SEQ.Nextval  into v_id from dual;
		      insert into D_SMS_SENDING(MSG_ID,DEST_TERMID,MSG_CONTENT,CREATE_TIME,SEND_COUNT) values(v_id,${mobile},#content#,sysdate,0);
		   </e:forEach>
		   end;
		   --update D_RESOURCE_POOL set MESSAGE_ID=v_id where ID=trim(${param.resId});
		</e:update>${addMsgCount}
	</e:case>
	
	<e:case value="addTeamwork">
	    <e:update var="addCount">
		   begin
		   <e:forEach items="${e:split(param.userId,',')}" var="userId">
		      insert into D_RESOURCE_TEAMWORK(USER_ID,RES_ID,CREATE_TIME) values('${userId}','${param.resId}',sysdate);
		   </e:forEach>
		   end;
		</e:update>${addCount}
	</e:case>

</e:switch>