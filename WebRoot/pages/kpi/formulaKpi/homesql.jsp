

<e:q4o var="userDaysObj">
	SELECT FLOOR(SYSDATE-T.UPDATE_DATE) DAYNUM FROM E_USER T WHERE T.USER_ID='${sessionScope.UserInfo.USER_ID }'
</e:q4o>

<e:q4l var="RootMenuList" >
<e:if condition="${applicationScope.isPortal eq '0'}" var="isPortal">
	select RESOURCES_ID, RESOURCES_NAME, URL,NVL(RESOURCE_STATE,'3') RESOURCE_STATE,RESOURCES_TYPE,nvl(CASE ATTACHMENT WHEN '' THEN NULL ELSE ATTACHMENT END,'/resources/themes/base/images/boncLayout/bg/bg_box04.png') ATTACHMENT 
	  FROM e_menu t
	 where t.parent_id = '0'
	   and RESOURCES_ID in
	       (select id
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
	 order by ord
</e:if>

<e:else condition="${isPortal}">
	<e:set var="lengthSql">(select instr('${sessionScope.userReqIp}','.')-1 from dual)</e:set>
	select a.RESOURCES_ID, a.RESOURCES_NAME,decode(a.URL,'','',a.ip||a.URL) URL,a.RESOURCE_STATE,a.RESOURCES_TYPE from  (select RESOURCES_ID, RESOURCES_NAME,
	(case when substr('${sessionScope.userReqIp}',0,${lengthSql}) = substr(d.subsystem_ip,0,${lengthSql})  then subsystem_address 
	     when substr('${sessionScope.userReqIp}',0,${lengthSql}) = substr(d.subsystem_ip2,0,${lengthSql})  then subsystem_address2
	     end ) ip,
	 URL,NVL(RESOURCE_STATE,'3') RESOURCE_STATE,RESOURCES_TYPE
	  FROM e_menu t,d_subsystem d
	 where t.parent_id = '0'
	   and RESOURCES_ID in
	       (select id
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
	    and t.ext1=d.subsystem_id(+) 
	 order by t.ord) a
</e:else>

</e:q4l>

<e:forEach items="${RootMenuList.list}" var="item">
<e:if condition="${index==0}">
    <e:set var="FirstMenuId" value="${item.RESOURCES_ID}"/>
    <e:set var="FirstMenuLabel" value="${item.RESOURCES_NAME}"/>
    <e:set var="FirstMenuUrl" value="${item.URL}"/>
    
    <e:set var="FirstPageMenuId">${item.RESOURCES_ID}</e:set><e:description>菜单ID</e:description>
	<e:set var="FirstPageMenuName">${item.RESOURCES_NAME}</e:set><e:description>菜单名称</e:description>
	<e:set var="FirstPageMenuUrl">${item.URL}</e:set><e:description>菜单URL</e:description>
    <e:set var="FirstPageMenuState">${item.RESOURCE_STATE}</e:set><e:description>菜单URL</e:description>
    <e:break/>
</e:if>
</e:forEach>

	
	


	<e:forEach items="${SecondMenuUrl.list}" var="item">
		<e:if condition="${item.URL !=null && item.URL != ''}">
		    <e:set var="FirstMenuId" value="${item.RESOURCES_ID}"/>
		    <e:set var="FirstMenuLabel" value="${item.RESOURCES_NAME}"/>
		    <e:set var="FirstMenuUrl" value="${item.URL}"/>
		    <e:break/>
		</e:if>
	</e:forEach>
<e:q4l var="col_list">
	select ID from E_USER_COLLECT U where U.user_id = '${sessionScope.UserInfo.USER_ID}'
</e:q4l>