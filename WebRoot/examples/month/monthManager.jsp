<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="dateId">select distinct t.const_value val
	from sys_const_table t
	where t.const_name in ('calendar.maxmonth')</e:q4o>
<e:set var="dateidd">${dateId.val}</e:set>
<e:if condition="${param.acct_month !=null && param.acct_month ne '' && param.acct_month ne ''}">
	<e:set var="dateidd">${param.acct_month}</e:set>
</e:if>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>月份组件实例</title>
<c:resources type="easyui" />
<script type="text/javascript">
	function doSearch(){ 
		var params={}; 
		params.acct_month=$("#acct_month").val(); 
		$("#eutTable").datagrid("load",params);
	}  
	function getValue(){ 
		alert($("#acct_month").val());
	}  
</script>
<e:style value="resources/themes/base/boncBase@links.css"/>
	<e:style value="resources/themes/blue/boncBlue.css"/>
</head>
<body>
	<div class="exampleWarp">
	<h1 class="titOne">月份组件:<em>month</em></h1>
	<div class="lable">&lt;c:month&gt; 在function获取值的写法：$("#acct_month").val()，例子：单击取值</div>
	<form action="" id="nmonthForm">
				<c:month id="acct_month" name="acct_month" defaultValue="${dateidd}" label=""/>
				<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onClick="doSearch();">查询 </a> <a href="javascript:void(0);" onClick="getValue();">取值 </a>
			</form>
	<c:datagrid id="eutTable" url="/examples/month/nmonthAction.jsp?eaction=all_month" pageSize="10" style="width:auto;height:autox;" title="" download="true" nowrap="false" toolbar="#nmonthForm" >
				<thead>
			<tr>
						<th field="ACCT_MONTH" width="60" align="center">日期</th>
						<th field="VALUE1" width="60" align="center">指标1</th>
						<th field="VALUE2" width="60" align="center">指标2</th>
						<th field="VALUE3" width="60" align="center">指标3</th>
						<th field="VALUE4" width="60" align="center">指标4</th>
						<th field="VALUE5" width="60" align="center">指标5</th>
					</tr>
		</thead>
			</c:datagrid>
	</div>
</body>
</html>