<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="cn.com.easy.taglib.function.Functions"%>
<%@ page import="cn.com.easy.ebuilder.parser.CommonTools"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<e:switch value="${param.eaction}">
	<e:case value="list">
		<c:tablequery>
		 	<e:sql name="kpi.dim.list"/>
		</c:tablequery>
	</e:case>
	<e:case value="addDim">
		<e:q4o var="dimInfo" sql="kpi.dim.beforeAddDim"/>
		<e:if condition="${dimInfo.DIM_CODE eq '' || dimInfo.DIM_CODE == null }" var="isHave">
			<e:update var="insert" sql="kpi.dim.insertDim"/>${insert }
		</e:if>
		<e:else condition="${isHave }">
			isHave
		</e:else>
	</e:case>
	<e:case value="editDim">
		<e:update var="updateDim" sql="kpi.dim.updateDim"/>${updateDim}
	</e:case>
	<e:case value="delDim">
		<e:update var="deleteDim" sql="kpi.dim.deleteDim"/>${deleteDim}
	</e:case>
</e:switch>