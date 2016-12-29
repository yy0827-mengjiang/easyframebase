<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>

<e:switch value="${param.eaction}">
	<e:case value="LIST">
		<c:tablequery>
		select i.ID, 
			i.OWNER, 
			i.TABLE_NAME, 
			i.TABLE_DESC, 
			i.EXT_DATASOURCE,
			s.DB_NAME
			from x_extds_info i left join x_ext_db_source s on(i.ext_datasource=s.db_source)
				where 1=1 
			<e:if condition="${param.OWNER != null && param.OWNER ne ''}">
				and i.OWNER like '%${param.OWNER}%'
			</e:if>
			<e:if condition="${param.TABLE_NAME != null && param.TABLE_NAME ne ''}">
				and i.TABLE_NAME like '%${param.TABLE_NAME}%'
			</e:if>
			<e:if condition="${param.TABLE_DESC != null && param.TABLE_DESC ne ''}">
				and i.TABLE_DESC like '%${param.TABLE_DESC}%'
			</e:if>
			<e:if condition="${param.EXT_DATASOURCE != null && param.EXT_DATASOURCE ne '-1'}">
				and i.EXT_DATASOURCE = '${param.EXT_DATASOURCE}'
			</e:if>
			order by i.OWNER desc
   		</c:tablequery>
	</e:case>
	<e:case value="DELETEBYID">
		<e:update var="rs_del">
			delete from x_extds_info where id=#id#
		</e:update>${rs_del}
	</e:case>
	<e:case value="SELECTBYID">
		<e:q4o var="cur">
			select ID,
				OWNER, 
				TABLE_NAME, 
				TABLE_DESC, 
				EXT_DATASOURCE 
				from x_extds_info
		 	 where  ID=#id#
		</e:q4o>${e:java2json(cur) }
	</e:case>	
</e:switch>
