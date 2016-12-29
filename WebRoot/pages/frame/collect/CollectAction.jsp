<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:switch value="${param.eaction}">
	<e:case value="INSERT">
		<e:q4o var="col_id" sql="frame.collect.col_id"/>
			
		<e:if condition="${col_id.id eq '' || col_id.id == null}" var="isCol">
			
				<e:update var="col_insert" sql="frame.collect.insertCollect" />${col_insert }
			
			<e:description>
				<a:log pageUrl="pages/frame/Frame.jsp" operate="2" content="收藏夹>>新增收藏" result="${col_insert }"/>
			</e:description>
		</e:if>
		
		<e:else condition="${isCol}">
			<e:update var="col_update" sql="frame.collect.updateCollect"/>${col_update }
			<e:description>
				<a:log pageUrl="pages/frame/Frame.jsp" operate="2" content="收藏夹>>新增收藏" result="${col_update }"/>
			</e:description>
		</e:else>
	</e:case>
	
	<e:case value="DELETE">
			<e:update var="col_delete" sql="frame.collect.deleteCollect"/>${col_delete }
			<e:description>
				<a:log pageUrl="pages/frame/Frame.jsp" operate="4" content="收藏夹>>删除收藏" result="${col_delete }"/>
			</e:description>
	</e:case>
</e:switch>