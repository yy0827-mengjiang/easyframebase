<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:if condition="${param.para eq '' ||param.para eq null || param.para eq undefined }">
	<e:set var="para">'1'</e:set>
</e:if>
<e:if condition="${param.para ne '' && param.para ne null &&  param.para ne undefined }">
	<e:set var="para">${param.para}</e:set>
</e:if>
<e:set var="report_sql">
		 select RESOURCES_ID,
       			RESOURCES_NAME name,
       			URL,
       			'1' stype,
       			'报表' stype_desc
  		   FROM e_menu t
          where 1=1
          and url is not null
          and RESOURCES_ID in (select id
			                  from (select b.MENU_ID ID
			                          from E_USER_PERMISSION b
			                         where b.USER_ID = '${sessionScope.UserInfo.USER_ID}'
			                           and b.AUTH_READ = 1
			                        union all
			                        select c.MENU_ID
			                          from E_ROLE_PERMISSION c
			                         where c.ROLE_CODE in
			                               (select ROLE_CODE
			                                  from E_USER_ROLE
			                                 where USER_ID = '${sessionScope.UserInfo.USER_ID}')
			                           and c.AUTH_READ = 1))
      	and resources_name like '%'||'${param.text}'||'%' 
</e:set>

<e:set var="ind_type">
	select RESOURCES_ID,
       			RESOURCES_NAME name,
       			URL,
       			'2' stype,
       			'指标' stype_desc
  		   FROM e_menu t
          where 1=1
          and url is not null
          and RESOURCES_ID in (select id
			                  from (select b.MENU_ID ID
			                          from E_USER_PERMISSION b
			                         where b.USER_ID = '${sessionScope.UserInfo.USER_ID}'
			                           and b.AUTH_READ = 1
			                        union all
			                        select c.MENU_ID
			                          from E_ROLE_PERMISSION c
			                         where c.ROLE_CODE in
			                               (select ROLE_CODE
			                                  from E_USER_ROLE
			                                 where USER_ID = '${sessionScope.UserInfo.USER_ID}')
			                           and c.AUTH_READ = 1)
			                   where id in(
			                   		select m.resources_id
					                  from E_IND_EXP         e,
					                       E_MENU_IND        m
					                 where E.IND_ID = M.IND_ID
					                   and E.IND_NAME like '%' || '${param.text}' || '%'))
		</e:set>
		<e:set var="explain_sql">
			select distinct ind_id resources_id,
				   ind_name name,
				   '' url,
				   '3' stype,
				   '指标解释' stype_desc
			  from E_IND_EXP
			 where IND_NAME like '%' || '${param.text}' || '%'
		</e:set>

<e:switch value="${param.eaction}">
	<e:case value="search">
		<e:q4l var="nameList">
		 select RESOURCES_ID ID,
       			name,
       			URL,
       		    stype,
       		    stype_desc
       	   from (
       	   		${ind_type }
       	   	union 
       	   		${report_sql }
       	   	union 
       	   		${explain_sql })
       	   where 1=1
       	   	and	stype in(${para})
 	  </e:q4l>
		${e:java2json(nameList.list)}
	</e:case>
</e:switch>