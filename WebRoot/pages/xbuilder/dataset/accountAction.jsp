<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:switch value="${param.eaction}">
	<e:case value="DBLIST">
		<c:tablequery>
			SELECT DB_ID as "DB_ID", DB_NAME as "DB_NAME", DB_SOURCE as "DB_SOURCE"
			   FROM X_EXT_DB_SOURCE  ORDER BY ORD
		</c:tablequery>
	</e:case>
	<e:case value="accountList">
		<c:tablequery>
			<e:sql name="xbuilder.account.accountList"/>
		</c:tablequery>
	</e:case>
	<e:case value="accountListForChoice">
		<c:tablequery>
			<e:sql name="xbuilder.account.accountListForChoice"/>
		</c:tablequery>
	</e:case>
	<e:case value="XBADDACCOUNT">
		<e:set var="accountId" value="${e:json2java(param.accountIds)}"></e:set>
		<e:set var="DB_ID" value="${param.db_id}"></e:set>
		<e:update var="add_account" transaction="true" sql="xbuilder.account.add_account"/>${add_account}
	</e:case>
	<e:case value="XBDELETE">
		<e:update var="del" sql="xbuilder.account.XBDELETE"></e:update>${del}
	</e:case>
	<e:case value="INSERTSOURCE">
		<e:q4o var="checkE">
			select DB_ID from X_EXT_DB_SOURCE where DB_ID=#dbID#
		</e:q4o>
		<e:if condition="${checkE.DB_ID eq '' || checkE.DB_ID == null }" var="isHave">
			<e:update var="insertS">
				insert into X_EXT_DB_SOURCE(DB_ID, DB_NAME, DB_SOURCE,ORD)
				                     values(#dbID#,#db_name#,#db_source#,#db_ord#)
			</e:update>${insertS }
		</e:if>
		<e:else condition="${isHave }">
			isHave
		</e:else>
	</e:case>
	<e:case value="SOURCERELOAD">
		<e:q4l var="source" sql="xbuilder.account.SOURCERELOAD"></e:q4l>${e:java2json(source.list) }
	</e:case>
	<e:case value="UPDATESource">
		<e:update var="updSource" sql="xbuilder.account.updSource"/>${updSource }
	</e:case>
	<e:case value="DELETESource">
		<e:update var="delSource" transaction="true" sql="xbuilder.account.delSource"/>${delSource }
	</e:case>
</e:switch>