<%@ tag body-content="empty" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ attribute name="id" required="true"%>                                        <e:description>日历控件id</e:description>
<%@ attribute name="name" required="false"%>                                     <e:description>日历控件name</e:description>
<%@ attribute name="defaultValue" required="false"%>                             <e:description>日历控件默认日期</e:description>
<%@ attribute name="isData" required="false"%>                                   <e:description>是否为数据日历控件[1为是，0为否]，默认为数据开放的月份</e:description>
<%@ attribute name="label" required="true"%>                                     <e:description>日历显示名称</e:description>
<e:if condition="${isData=='1' || isData=='' || isData==null}">
	<e:q4l var="month_list">
		select * from CONSECUTIVE_2YEAR_MON where acct_month<=(select t.const_value maxmonth from sys_const_table t where t.const_type = 'var.dss' and const_name='calendar.maxmonth') order by acct_month desc
	</e:q4l>
</e:if>
	<e:if condition="${isData=='0'}">
		<e:q4l var="month_list">
			select * from CONSECUTIVE_2YEAR_MON order by acct_month desc
		</e:q4l>
</e:if>
<label>${label}</label><e:select id="${id}" name="${name}" items="${month_list.list}" style="width:100%" label="ACCT_DESC" value="ACCT_MONTH" defaultValue= "${defaultValue}"/>	