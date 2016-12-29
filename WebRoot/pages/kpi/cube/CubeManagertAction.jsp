<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<e:switch value="${param.eaction}">
	<e:case value="LIST">
		<c:tablequery>
			<e:sql name="kpi.cube.cube_list"/>
   		</c:tablequery>
	</e:case>
	<e:case value="DELETEBYID">
		<e:update var="rs_del" sql="kpi.cube.rs_del">
		</e:update>${rs_del}
	</e:case>
	<e:case value="SELECTBYCODE">
		<e:q4o var="count">
			select count(cube_code) num
  			from X_KPI_CUBE where cube_code=#cube_code# and CUBE_STATUS='1'
		</e:q4o>${count.num}
	</e:case>
	<e:case value="SELECTOBJBYCODE">
		<e:q4o var="cur">
			select CUBE_CODE AS "CUBE_CODE",
		       CUBE_NAME AS "CUBE_NAME",
		       CUBE_FLAG AS "CUBE_FLAG",
		       CUBE_DESC AS "CUBE_DESC",
		       CUBE_DATASOURCE AS "CUBE_DATASOURCE",
		       CUBE_ATTR AS "CUBE_ATTR",
		       ACCOUNT_TYPE AS "ACCOUNT_TYPE",
		       CUBE_STATUS AS "CUBE_STATUS"
		  from X_KPI_CUBE
		 	 where  CUBE_CODE=#cube_code#
		</e:q4o>${e:java2json(cur) }
	</e:case>
	
</e:switch>
