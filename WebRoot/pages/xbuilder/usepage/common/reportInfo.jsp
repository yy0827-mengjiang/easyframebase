<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<c:resources type="easyui"  style="${ThemeStyle }"/>
<e:q4o var="report_decription">
select a.ID REPORT_ID,
       t.user_id,
       e.login_id,
       e.mobile,
       report_man,
       depart_code,
       depart_desc,
        REPLACE(report_desc,chr(13)||chr(10),'<br>') report_desc,
       a.CREATE_TIME as create_date,
       a.MODIFY_TIME as update_date
  from x_report_describe t, x_report_info a,e_user e 
 where a.ID = t.report_id and t.USER_ID = e.USER_ID
   and t.report_id = '${param.reportid }'
</e:q4o>
<div class="HBcomments">
	<e:if condition="${!empty report_decription}" var="isEmp">
		<div class="commentsTop">
			<dl>	
				<dt>提交人</dt>
				<dd>${report_decription.report_man}</dd>
				<dt>手机号</dt>
				<dd>${report_decription.mobile}</dd>
			</dl>
			<ol>
				<li>页面上线时间：${report_decription.create_date}</li>
				<li>报表上线时间：${report_decription.update_date}</li>
			</ol>
		</div>
		<div class="commentsBot">
			<h3><span>描述信息</span></h3>
			<ul>
				<li>${report_decription.report_desc}</li>
			</ul>
		</div>
	</e:if>
	<e:else condition="${isEmp}">
		<h3><span>未填写描术信息</span></h3>
	</e:else>
</div>