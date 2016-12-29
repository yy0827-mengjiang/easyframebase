<%@ tag body-content="empty" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ attribute name="pageUrl" required="true" %><e:description>菜单url</e:description>
<%@ attribute name="operate" required="true" %><e:description>操作类型，1：查询、2：创建、3：修改、4：删除、5:下载</e:description>
<%@ attribute name="content" required="true" %><e:description>日志内容</e:description>
<%@ attribute name="result" required="true" %><e:description>操作结果，1：成功、0：失败</e:description>
<e:q4o var="currentMenuObj">
	select RESOURCES_ID from e_menu t left join D_SUBSYSTEM t1 on t.ext1=t1.subsystem_id where t.url='${pageUrl}'
</e:q4o>
<e:update>
		insert into E_OPERATION_LOG(USER_ID,MENU_ID,OPERATE_TYPE_CODE,OPERATE_RESULT,CONTENT,CLIENT_IP,CREATE_DATE) VALUES('${sessionScope.UserInfo.USER_ID }','${currentMenuObj.RESOURCES_ID }','${operate}','${result }','${content }','${sessionScope.UserInfo.IP }','${e:getDate('yyyyMMddHHmmss')}')
</e:update>