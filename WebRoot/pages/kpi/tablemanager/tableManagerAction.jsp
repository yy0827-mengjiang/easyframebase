<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:switch value="${param.eaction }">
	<e:case value="queryList">
		<c:tablequery>
			<e:sql name="kpi.tableManager.queryList"/>
		</c:tablequery>
	</e:case>
	<e:case value="tableINSERT">
		<e:update sql="kpi.tableManager.tableINSERT">
		</e:update>
	</e:case>
	<e:case value="tableUPDATE">
		<e:update sql="kpi.tableManager.tableUPDATE">
		 </e:update>
	</e:case>
	<e:case value="tableDELETE">
		<e:update sql="kpi.tableManager.tableDELETE">
		</e:update>
	</e:case>
</e:switch>