<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
	<div id="other_bar">
		<div class="search-area" style="padding-left:0;">
			报表名称：<input type="text" style="width:240px;" id="other_report_name" name="other_report_name">
			数据集名称：<input type="text" style="width:290px;" id="other_data_name" name="other_data_name">
			<a href="javascript:void(0);" id="other_query" class="easyui-linkbutton" onclick="doOtherQuery()">查询</a>
		</div>
	</div>
    <c:datagrid url="pages/xbuilder/dataset/ReportSqlAction.jsp?eaction=OTHERDATA&reportId=${param.reportId}" id="dataOtherTable" pageSize="10" fit="true"  onClickCell="showDetailSql" border="false" toolbar="#other_bar" download="" nowrap="false" >
			<thead>
				<th field="NAME" width="130">报表名称</th>
				<th field="REPORT_SQL_NAME" width="130">数据集名称</th>
				<th field="REPORT_SQL" width="380" formatter="formattSql">数据集SQL</th>
				<th field="CZ" width="60" formatter="data_select" align="center">操作</th>
			</thead>
	</c:datagrid>
