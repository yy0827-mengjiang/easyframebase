<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>

<e:switch value="${param.eaction}">
	<e:case value="LIST">
		<c:tablequery>
				select table_name id,table_name table_name,table_desc table_desc,ext_datasource,owner 
				from x_extds_info t 
				where 1=1 and t.ext_datasource=#db_source# 
			<e:if condition="${param.table_name != null && param.table_name ne ''}">
				and t.table_name||t.table_desc  like '%${param.table_name}%'
			</e:if>
			order by table_name desc
   		</c:tablequery>
	</e:case>
</e:switch>
