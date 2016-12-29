<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  	<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
    <title></title>
	<meta http-equiv="pragma" content="no-cache"/>
	<meta http-equiv="cache-control" content="no-cache"/>
	<meta http-equiv="expires" content="0"/>  
	<c:resources type="easyui,highchart" style="b"/>
	<script type="text/javascript">
   		function dataPointClick(){
   			alert('饼图点击事件');
   		}
   	</script>
  </head>
<body>
	<e:q4l var="pie_list_d">
		SELECT L.PRICE_LEVEL_DESC V1, ROUND(SUM(DEV_NUM) * 100, 2) V3
		  FROM ADM.DM_M_TERM_TOTAL T, TELECOMDMCODE.DMCODE_TERM_PRICE_LEVEL L
		 WHERE T.RES_PRICE = L.PRICE_LEVEL_ID
		   AND T.ACCT_MONTH = '201401'
		 GROUP BY L.PRICE_LEVEL_DESC, L.ORD
		 ORDER BY L.ORD
	</e:q4l>

<a:pie id="sellpie3" width="auto" height="290px" dimension="V1" items="${pie_list_d.list}" value="V3" title="" legend="true" tipfmt="4" dataLabelText="false" unit="个" />
</body>
</html>
