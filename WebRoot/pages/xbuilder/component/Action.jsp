<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:switch value="${param.eaction}">
		<e:case value="DATA">
			<e:q4l var="datas">
				select report_sql_id "id",  report_sql_name "text", report_sql "desc" from sys_report_sql where report_id=#report_id#
			</e:q4l>${e:java2json(datas.list) }
		</e:case>
		<e:case value="COLUMN">
			<e:q4l var="columns">
				select column_kpi_name "id", column_name "text" from sys_report_columns where report_sql_id=#report_sql_id# order by ord
			</e:q4l>${e:java2json(columns.list) }
		</e:case>
</e:switch>