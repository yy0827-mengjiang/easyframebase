<%@ tag body-content="empty" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<!--//属性  -->
<%@ attribute name="id" required="false"%>       <e:description>id</e:description>
<%@ attribute name="content" required="false"%>  <e:description>loginid,loginname,area_no,city_no,dept_no</e:description>
<%@ attribute name="isdata" required="false"%>   <e:description>是否显示日期</e:description>
<e:set var="TmpContent" value="" />
<e:if condition="${content !=null && content ne ''}" var = "waterelse">
	<e:set var="TmpContent" value="${content}" />
</e:if>
<e:else condition="${waterelse}">
	<e:set var="TmpContent" value="${sessionScope.USER_NAME}" />
	<e:set var="DEPTID">${sessionScope.DEPT_CODE}</e:set>
	<e:if condition="${DEPTID == null || DEPTID eq ''}">
		<e:set var="DEPTID">${sessionScope.UserInfo.DEPT_CODE}</e:set>
	</e:if>
	<e:q4o var="DeptDesc">
		SELECT DEPART_CODE, DEPART_DESC, PARENT_CODE FROM E_DEPARTMENT WHERE DEPART_CODE = '${DEPTID}'
	</e:q4o>
	<e:q4o var="DeptDescCount">
		SELECT nvl(count(1), 0) cnt FROM E_DEPARTMENT WHERE DEPART_CODE = '${DEPTID}'
	</e:q4o>
	<e:if condition="${DeptDescCount.cnt eq '0'}" var ="deptelse">
		<e:set var="TmpContent">未知部门-${TmpContent}</e:set>
	</e:if>
	<e:else condition="${deptelse}">
		<e:set var="TmpContent">${DeptDesc.DEPART_DESC}-${TmpContent}</e:set>
	</e:else>
	
</e:else>
<e:if condition="${isdata !=null && isdata eq 'true'}">
	<e:q4o var="dateDesc">
		SELECT to_char(sysdate,'yyyy/mm/dd hh24:mi:ss') code FROM dual
	</e:q4o>
	<e:set var="TmpContent">${TmpContent}-${dateDesc.code}</e:set>
</e:if>
<div class='watermarkDate'>
	<p class='watermark'>${TmpContent}</p>
</div>
<style>
.watermarkDate{position:relative;}
.watermarkDate .watermark {border:none; font-size:35px; line-height:1.2; font-family:"楷体"; box-shadow: 1px 1px 12px #fff; color:#000; text-shadow: 1px 1px 0 #fff; padding:8px; position:absolute; left:50%; top:160px; width:85%; margin-left:-45%; text-align:center; z-index:9999;transform:rotate(30deg); -ms-transform:rotate(30deg); -moz-transform:rotate(30deg); -webkit-transform:rotate(30deg); -o-transform:rotate(30deg);filter:alpha(opacity=30); -moz-opacity:0.3; opacity:0.3;}
</style>