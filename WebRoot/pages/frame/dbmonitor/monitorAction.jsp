<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<c:tablequery>
select USERNAME,MACHINE,STATUS,OSUSER,PROGRAM,MODULE,to_char(LOGON_TIME,'YYYY-MM-DD HH24:MI:SS') LOGON_TIME,STATE,SERVICE_NAME from v$session where username =UPPER('${dss}')
  <e:if condition="${param.status!=null && param.status ne ''}">
	  <e:if condition="${param.status eq '999'}">
	 	AND program not in ('INACTIVE','ACTIVE')
	  </e:if>
	  <e:if condition="${param.status!='999'}">
	 	AND status = #status#
	  </e:if>
  </e:if>
  <e:if condition="${param.program!=null && param.program ne ''}">
	  <e:if condition="${param.program ne '999' && param.program eq 'JDBC Thin Client'}">
	 	AND program = 'JDBC Thin Client'
	  </e:if>
	  <e:if condition="${param.program eq '999'}">
	 	AND program != 'JDBC Thin Client'
	  </e:if>
  </e:if>
  ORDER BY LOGON_TIME DESC
</c:tablequery>