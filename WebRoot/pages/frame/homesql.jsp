<e:q4o var="userDaysObj" sql="frame.homesql.userDaysObj"></e:q4o>
<e:if condition="${applicationScope.isPortal eq '0'}" var="isPortal">
	<e:q4l var="RootMenuList" sql="frame.homesql.RootMenuList"></e:q4l>
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
<e:q4l var="col_list" sql="frame.homesql.col_list"></e:q4l>