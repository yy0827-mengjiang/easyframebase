<e:if condition="${applicationScope.isPortal eq '0'}" var="isPortal">
		<e:q4l var="RootMenuList">
			select RESOURCES_ID, RESOURCES_NAME, URL,coalesce(RESOURCE_STATE,'3') RESOURCE_STATE,RESOURCES_TYPE,COALESCE(CASE  ATTACHMENT WHEN '' THEN NULL ELSE ATTACHMENT END,'/resources/themes/base/images/boncLayout/bg/bg_box04.png') ATTACHMENT
			  FROM e_menu t
				 where t.parent_id = '1262'
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
				                   and c.AUTH_READ = 1) A)
				 order by ord
		</e:q4l>
	</e:if>
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