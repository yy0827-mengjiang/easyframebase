<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
	<div id="global_bar">
		<div class="search-area" style="padding-left:0;">
			数据集名称：<input type="text" style="width:100px;" id="GLBDATASET_NAME" name="GLBDATASET_NAME">
			创建人：<input type="text" style="width:100px;" id="CREATE_USER_NAME" name="CREATE_USER_NAME">
			创建时间： <c:datebox style="width:100px" id="START_TIME" name="START_TIME" required="false" format="yyyymmdd"/>&nbsp;—
			<c:datebox style="width:100px" id="END_TIME" name="END_TIME" required="false" format="yyyymmdd"/>
			<a href="javascript:void(0);" id="other_query" class="easyui-linkbutton" onclick="doGlobalQuery()">查询</a>
		</div>
	</div>
    <c:datagrid url="pages/xbuilder/dataset/ReportSqlAction.jsp?eaction=GLOBALDATA&reportId=${param.reportId}" id="dataGlobalTable" pageSize="10" fit="true" border="false" onClickCell="showDetailSql" toolbar="#global_bar" download="" nowrap="false" >
			<thead>
				<th field="GLBDATASET_NAME" width="230" align="center">数据集名称</th>
				<th field="DB_NAME" width="200" align="center">数据源名称</th>
				<th field="GLBDATASET_SQL" width="300" align="center" formatter="formattSql">数据集SQL</th>
				<th field="CREATE_USER_NAME" width="150" align="center">创建人</th>
				<th field="CREATE_TIME" width="200" align="center" formatter="formatDAT_dataGlobalTable">创建时间</th>
				<th field="CZ" width="90" formatter="data_select_glb" align="center">操作</th>
			</thead>
	</c:datagrid>