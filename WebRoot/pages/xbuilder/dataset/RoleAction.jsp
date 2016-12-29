<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%
	String firstDbName = "";
	java.util.Map <String, cn.com.easy.core.sql.EasyDataSource> extds= cn.com.easy.core.EasyContext.getContext().getExtDataSource();
	int i = 0;
	for(String key:extds.keySet()){
		if(i==0){
			firstDbName = key;
			break;
		}
		i++;
	}
%>
<e:set var="defaultDbName" value="<%=firstDbName%>"/>
<e:switch value="${param.eaction}">
	
		<e:case value="XBROLELIST">
		<c:tablequery>
			select a.ROLE_CODE, parent_code, ROLE_NAME, MEMO, ord from e_role a,x_db_role b
			where a.role_code=b.role_code 
			<e:if condition="${param.db_name ne '' && param.db_name != null}" var="dbelsev">
				and b.DB_NAME=#db_name#
			</e:if>
			<e:else condition="${dbelsev}">
				and b.DB_NAME='${defaultDbName}'
			</e:else>
			
			<e:if condition="${param.role_code ne '' && param.role_code != null}">
			and a.role_code like '%'||#role_code#||'%'
				
			</e:if>
			<e:if condition="${param.role_name ne '' && param.role_name != null}">
			and a.role_name like '%'||#role_name#||'%'
			</e:if>
			order by ord
		</c:tablequery>
	</e:case>
		<e:case value="XBROLELISTNO">
		<c:tablequery>
			select a.ROLE_CODE, parent_code, ROLE_NAME, MEMO, ord from e_role a
			where a.role_code not in(
						select a.ROLE_CODE from e_role a,x_db_role b
			where a.role_code=b.role_code 
			<e:if condition="${param.db_name ne '' && param.db_name != null}" var="dbelsev">
				and b.DB_NAME=#db_name#
			</e:if>
			<e:else condition="${dbelsev}">
				and b.DB_NAME='${defaultDbName}'
			</e:else>
			
			<e:if condition="${param.role_code ne '' && param.role_code != null}">
			and a.role_code like '%'||#role_code#||'%'
				
			</e:if>
			<e:if condition="${param.role_name ne '' && param.role_name != null}">
			and a.role_name like '%'||#role_name#||'%'
			</e:if>
			)
			<e:if condition="${param.role_code ne '' && param.role_code != null}">
			and a.role_code like '%'||#role_code#||'%'
			</e:if>
			<e:if condition="${param.role_name ne '' && param.role_name != null}">
			and a.role_name like '%'||#role_name#||'%'
			</e:if>
			order by ord
		</c:tablequery>
	</e:case>
	<e:case value="XBADDROLE">
	 <e:update var="res_add_user">
		begin 
			<e:forEach items="${e:json2java(param.roleIds)}" var="roleId">
				delete from x_db_role where db_name=#db_name# and role_code='${roleId}';
				insert into x_db_role (role_code, db_name) values ('${roleId}',#db_name#);
			</e:forEach>
		end;
		</e:update>${res_add_user}
	</e:case>
	<e:case value="XBDELETE">
		<e:update var="del_res">
			delete from x_db_role where role_code=#roleId# and db_name=#db_name#
		</e:update>${del_res }
	</e:case>
</e:switch>