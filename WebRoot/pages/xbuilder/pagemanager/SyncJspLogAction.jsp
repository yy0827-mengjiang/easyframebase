<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<e:switch value="${param.eaction}">
	<e:case value="LIST">
		<c:tablequery>
		    <e:if condition="${param.result != null && param.result ne ''}" var="nullResultIf">
			    <e:if condition="${param.result eq '4'}" var="allFailIf">
					 <e:sql name="xbuilder.syncJsp.syncLogQueryAllFail"/>
			    </e:if>
			    <e:else condition="${allFailIf}">
			  	  	 <e:sql name="xbuilder.syncJsp.syncLogQueryFailByReason"/>
			    </e:else>
			</e:if>
			<e:else condition="${nullResultIf}">
			    <e:sql name="xbuilder.syncJsp.syncLogQueryAll"/>
			</e:else>
		</c:tablequery>
	</e:case>
</e:switch>