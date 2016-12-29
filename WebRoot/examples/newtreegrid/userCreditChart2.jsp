<%@page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>促销用户和积分图表</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<c:resources type="easyui,app"  style="${ThemeStyle }"/>
	<c:resources type="highchart" />
	<link href="css/default.css" rel="stylesheet" type="text/css" media="all" />
    <link href="css/main.css" rel="stylesheet" type="text/css" media="all" />
	<script type="text/javascript">
	
	</script>
</head>
<%
  pageContext.setAttribute("curDate", (new SimpleDateFormat("yyyyMMdd")).format(new Date()));
%>
<e:if condition="${param.day == null || param.day eq ''}" var="curDateIf">
    <e:set var="accDay" value="${curDate}"/>
</e:if>
<e:else condition="${curDateIf}">
    <e:set var="accDay" value="${param.day}"/>
</e:else>
<e:q4l var="chartList01"> 
   select type_name,
	sum(case kpi_type when '1' then kpi_value else '0' end) v0,
	round(sum(case kpi_type when '2' then kpi_value else '0' end),0) v1 from 
	(select a.kpi_type, a.kpi_value,b.* from (select t.* from ac_user_credit t
	where t.acct_day='${accDay}' 
	<e:if condition="${param.area != null&&param.area ne '' && param.area ne '-1'}">
		and t.area_no='${param.area}'
	</e:if>
	<e:if condition="${param.sales_id != null&&param.sales_id ne '' }">
		and t.sales_id='${param.sales_id}'
	</e:if>
    ) a,ac_busi_type b
	where a.busi_type(+) =b.type_id) r
	group by type_id,type_name
	order by type_id
</e:q4l>
<body>
	 
	 
				<c:ncolumnline id="chart01" width="100%" height="248"
				    yaxis="title:用户,unit:户;title:积分,unit:分,color:#728191"
					colors="['#728191','#ffbf00']" legendValign="top" rotation="0"
					V0="name:用户,yaxis:0,type:column" V1="name:积分,yaxis:1,type:spline" dimension="TYPE_NAME"
					items="${chartList01.list}"/>
	 
</body>