<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%
String uuid=java.util.UUID.randomUUID().toString().replace("-", "");
request.setAttribute("uuid", uuid);
%>
<e:switch value="${param.eaction}">
	<e:case value="LIST">
		<c:tablequery>
			<e:sql name="xbuilder.dimension.LIST"/>			
		</c:tablequery>
	</e:case>
	<e:case value="UPDATE">
		<e:update var="upd_res" sql="xbuilder.dimension.UPDATE">
		</e:update>${upd_res}
	</e:case>
	<e:case value="DELETE">
		<e:update var="del_res" sql="xbuilder.dimension.DELETE">
		</e:update>${del_res}
	</e:case>
	<e:case value="INSERT">
		<e:set var="uuid_id" value="${uuid}"></e:set>
		<e:update var="ins_res" sql="xbuilder.dimension.INSERT">
		</e:update>${ins_res}
	</e:case>
</e:switch>