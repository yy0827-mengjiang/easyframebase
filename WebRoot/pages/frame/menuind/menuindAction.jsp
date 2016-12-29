<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<e:switch value="${param.eaction}">
	<e:case value="MENUSELECT">
		<e:q4l var="index_data" >
			select * from (
			select concat(t.resources_id,'') as "id",
			       t.resources_name as "name", 
			       t.url as "url",
			       case when '${param.id }'='' then null else '${param.id }' end as "_parentId",
			       case when (select count(resources_id) from E_MENU where PARENT_ID=t.resources_id) =0 then
		           'leaf' else 'closed' end as "state",
		           '指标操作' as "oper" 
			from E_MENU t 
			where t.resources_type ='1'
			<e:if condition="${param.id==null || param.id eq ''}">
				   and t.parent_id ='0'
			</e:if>
			<e:if condition="${param.id!=null && param.id ne ''}">
				   and t.parent_id ='${param.id}'
			</e:if>
			order by ord
			) a
		</e:q4l>
		{"rows":${e:java2json(index_data.list)}}
	</e:case>
	
	<e:case value="MENUINDSELECT">
		<c:tablequery>
			<e:sql name="frame.menuind.MENUINDSELECT"/>
		</c:tablequery>
	</e:case>
	
	<e:case value="INDSELECT">
		<c:tablequery>
			<e:sql name="frame.menuind.INDSELECT"/>
		</c:tablequery>
	</e:case>
	
	<e:case value="INSERT">
		<e:set var="ids" value="${e:json2java(param.ids)}"></e:set>
		<e:update var="ind_insert" transaction="true" sql="frame.menuind.INSERT">
		</e:update>${ind_insert }
		<a:log pageUrl="pages/frame/menuind/menuindManager.jsp" operate="2" content="发布指标解释>>添加指标" result="${ind_insert }"/>
	</e:case>
	
	<e:case value="MENUDELETE">
		<e:set var="ids" value="${e:json2java(param.ids)}"></e:set>
		<e:update var="ind_delete" transaction="true" sql="frame.menuind.MENUDELETE">
		</e:update>${ind_delete }
		<a:log pageUrl="pages/frame/menuind/menuindManager.jsp" operate="4" content="发布指标解释>>删除指标" result="${ind_delete }"/>
	</e:case>
	
	<e:case value="INDEXPSELECT">
		<c:tablequery>
			<e:sql name="frame.menuind.INDEXPSELECT"/>
		</c:tablequery>
	</e:case>
	
	<e:case value="INDEXP">
		<e:q4o var="post" sql="frame.menuind.INDEXP">
		</e:q4o>
		${e:toString(post.EXP) }
	</e:case>
	
	<e:case value="INDEXLIST">
		<c:tablequery>
			<e:sql name="frame.menuind.INDEXLIST" />
		</c:tablequery>
	</e:case>
</e:switch>