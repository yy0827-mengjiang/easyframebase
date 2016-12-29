<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<div class="loadBox">
<c:datagrid url="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=queryAudit&kpi_key=${param.kpi_key}" id="kpiQueryAuditTable" singleSelect="true" nowrap="true" fit="true" >
  	<thead>
  		<tr>
  			<th field="V2" width="15%">审核步骤</th>
  			<th field="V3" width="15%">审核结果</th>
  			<th field="V1" width="40%">审核意见</th>
			<th field="V4" width="15%">审核人</th>
  			<th field="V5" width="15%">审核时间</th>
  		</tr>
  	</thead>
</c:datagrid>
</div>