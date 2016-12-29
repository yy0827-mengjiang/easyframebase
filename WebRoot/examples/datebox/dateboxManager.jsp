<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="quryDate"> 
	select distinct t.const_value val
	  from sys_const_table t
	 where t.const_name in ('calendar.curdate')
</e:q4o>
<e:set var="ACCT_DATE">${quryDate.val}</e:set>
<e:if condition="${param.acct_date !=null && param.acct_date ne '' && param.acct_date ne ''}">
	<e:set var="ACCT_DATE">${param.acct_day}</e:set>
</e:if>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>日组件实例</title>
		<c:resources type="easyui"  style="${ThemeStyle }"/>
		<e:style value="resources/themes/base/boncBase@links.css"/>
		<e:style value="resources/themes/blue/boncBlue.css"/>
		<script type="text/javascript">
		
			function GetValue(){
				alert($("#acct_date").datebox("getValue"));
			}
			function SetValue(){
				$("#acct_date").datebox("setValue",$("#updateDay").val());
			} 
			function onSelect(date){
				alert(date);
			}
		</script>
	</head>
	<body>
	<div class="exampleWarp">
	<h1 class="titOne">日组件:datebox</h1>
	<div class="lable">
		<span>&lt;c:datebox&gt; 在function获取值的写法：$("#acct_date").combobox("getValues")，例子：单击取值</span><br />
		<span>&lt;c:datebox&gt; 在function设置值的写法：$("#acct_date").datebox("setValue",$("#updateDay").val())，例子：单击设置值</span>
	</div>
	<div style="height:800px;">
		<c:datebox id="acct_date" name="acct_date" required="true" format="yyyymmdd" defaultValue='${ACCT_DATE}' onSelect="onSelect"/><br />
		 1、<a href="javascript:void(0);" onclick="GetValue();">取值 </a><br />
		 2、<input type="text" id="updateDay" name="updateDay" />
		 <a href="javascript:void(0);" onclick="SetValue();">设置值 </a>
		 3、选择日期触发onSelect事件
	</div>
	</div>
	</body>
</html>