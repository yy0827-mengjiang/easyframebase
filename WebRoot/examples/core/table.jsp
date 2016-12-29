<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4l var="list1" pageSize="3">
	select acct_month,
         area_no,
         city_no,
         tele_type,
         cust_group,
         channel_type,
         urban_type
    from dm_kpi_ppt_users1 t where acct_month=#aa#
    </e:q4l>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>表格组件实例</title>
		<c:resources type="easyui" />
	</head>
	<body>
	<e:forEach items="${list1.list}" var="item">
		${item.AREA_NO}
	</e:forEach>
	
	<e:table items="${list1.list}" var="item" class="easy-table">
		<e:td title="<input type='checkbox' onclick='$.selectAndCancelAll(this,\"selId\")' />" style="width: 30px">
							<e:checkbox name="selId" value="${item.INDICATOR_NO }" />
		</e:td>
		<e:td title="月份">${item.ACCT_MONTH}</e:td>
		<e:td title="地域">${item.AREA_NO}</e:td>
		<e:td title="操作"><a href="aaa.jsp?ai=${item.TELE_TYPE}">删除</a></e:td>
	</e:table>
	<e:pageController queryObject="${list1}" class="pageController" />
	</body>
</html>