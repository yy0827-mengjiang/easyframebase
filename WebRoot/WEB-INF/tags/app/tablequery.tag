<%@ tag body-content="scriptless" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ attribute name="extds" required="false" %>                       <e:description>扩展数据源名称</e:description>
<jsp:doBody var="bodyRes" />
<e:if var="isRotateFlag" condition="${param.isRotate=='true'}">
	<e:set var="rotateCols"></e:set>
	<e:q4l var="AllRotateDimList">
		${e:urlDecode(e:isoDecode(param.rotateSql),"UTF-8") }
	</e:q4l>
	<e:if var="rotateDimNumFlag" condition="${e:length(e:split(rotateDimColumn,',')) > 1}">
		
	</e:if>
	<e:else condition="${rotateDimNumFlag}">
		<e:forEach items="${AllRotateDimList.list}" var="AllRotateDimItem" indexName="i">
			<e:set var="rotateCols">${rotateCols}case when ${param.rotateDimColumn}='${AllRotateDimItem[param.rotateDimColumn]}' then ${param.rotateValueColumn} else 0 end "${param.tableId }_ROTATECOLUMN${i}",</e:set>
		</e:forEach>
	</e:else>
	
	<e:if condition="${param.is_down_table == 'true'}">
		<e:set var="downSql" value="${bodyRes}" scope="session"/>
		<e:set var="downDb" value="${extds}" scope="session"/>
	</e:if>
	<e:if condition="${param.is_down_table != 'true'}">
		<e:set var="tableResultList_epageNumber" value="${param.page}"/>
		<e:if condition="${extds != null && extds ne ''}">
			<e:q4l var="tableResultList" pageSize="${param.rows}" extds="${extds}">
				
				<e:if var="isSortForExt" condition="${param.sort!=null&&param.sort!=''&&param.sort!='null'}">
					select * from (
						${bodyRes}
					) tableResultList_table
					order by ${param.sort} ${param.order}
				</e:if>
				<e:else condition="${isSortForExt}">
					${bodyRes}
				</e:else>
			</e:q4l>
		</e:if>
		<e:if condition="${extds == null || extds eq ''}">
			<e:q4l var="tableResultList" pageSize="${param.rows}">
				
				<e:if var="isSort" condition="${param.sort!=null&&param.sort!=''&&param.sort!='null'}">
					select * from (
						${bodyRes}
					) tableResultList_table
					order by ${param.sort} ${param.order}
				</e:if>
				<e:else condition="${isSort}">
				
				select ${rotateCols } tableResultList_table.* from (
					${bodyRes}
				) tableResultList_table
				</e:else>
			</e:q4l>
		</e:if>
		{
			<e:if condition="${tableResultList.erecordCount != null && tableResultList.erecordCount != '' && tableResultList.erecordCount ne ''}">
				"total":${tableResultList.erecordCount},
			</e:if>
			"rows":${e:java2json(tableResultList.list)}
		}
	</e:if>






</e:if>
<e:else condition="${isRotateFlag}">

	<e:if condition="${param.is_down_table == 'true'}">
		<e:set var="downSql" value="${bodyRes}" scope="session"/>
		<e:set var="downDb" value="${extds}" scope="session"/>
	</e:if>
	<e:if condition="${param.is_down_table != 'true'}">
		<e:set var="tableResultList_epageNumber" value="${param.page}"/>
		<e:if condition="${extds != null && extds ne ''}">
			<e:q4l var="tableResultList" pageSize="${param.rows}" extds="${extds}">
				
				<e:if var="isSortForExt" condition="${param.sort!=null&&param.sort!=''&&param.sort!='null'}">
					select * from (
						${bodyRes}
					) tableResultList_table
					order by ${param.sort} ${param.order}
				</e:if>
				<e:else condition="${isSortForExt}">
					${bodyRes}
				</e:else>
			</e:q4l>
		</e:if>
		<e:if condition="${extds == null || extds eq ''}">
			<e:q4l var="tableResultList" pageSize="${param.rows}">
				
				<e:if var="isSort" condition="${param.sort!=null&&param.sort!=''&&param.sort!='null'}">
					select * from (
						${bodyRes}
					) tableResultList_table
					order by ${param.sort} ${param.order}
				</e:if>
				<e:else condition="${isSort}">
					${bodyRes}
				</e:else>
			</e:q4l>
		</e:if>
		{
			<e:if condition="${tableResultList.erecordCount != null && tableResultList.erecordCount != '' && tableResultList.erecordCount ne ''}">
				"total":${tableResultList.erecordCount},
			</e:if>
			"rows":${e:java2json(tableResultList.list)}
		}
	</e:if>
</e:else>