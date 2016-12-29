<%@ tag body-content="empty" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ attribute name="reportid" required="true" %><e:description>报表ID</e:description>
<%@ attribute name="operate" required="true" %><e:description>操作类型，1：创建报表、2：预览报表、3：保存报表、4：编辑报表、5:注销、6：删除</e:description>
<%@ attribute name="content" required="true" %><e:description>日志内容</e:description>
<%@ attribute name="result" required="true" %><e:description>操作结果，1：成功、0：失败</e:description>
<e:update>
	insert into X_REPORT_OPERATION_LOG(USER_ID,REPORT_ID,OPERATE_TYPE_CODE,OPERATE_RESULT,CONTENT,CLIENT_IP,CREATE_DATE) VALUES('${sessionScope.UserInfo.USER_ID }','${reportid }','${operate}','${result }','${content }','${sessionScope.UserInfo.IP }','${e:getDate('yyyyMMddHHmmss')}')
</e:update>