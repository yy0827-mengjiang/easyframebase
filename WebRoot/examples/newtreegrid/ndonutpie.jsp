<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<title></title>
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<meta http-equiv="expires" content="0" />
<c:resources type="easyui,highchart" style="b" />
<script type="text/javascript">
	function dataPointClick() {
		alert('饼图点击事件');
	}
</script>
<e:style value="/resources/themes/common/css/examples.css" />
</head>
<body>
	<e:q4l var="piedata"> select AREA_DESC,CITY_DESC,
		sum(VALUE1) A,
		sum(VALUE2) B,
		sum(VALUE1+VALUE2) C,
		sum(VALUE1*2) D
		from (
		SELECT '431' AREA_NO,'长春' AREA_DESC,'43101' CITY_NO,'朝阳区' CITY_DESC,111 VALUE1, 334 VALUE2 FROM DUAL
		UNION ALL
		SELECT '431' AREA_NO,'长春' AREA_DESC,'43102' CITY_NO,'二道区' CITY_DESC,111 VALUE1, 334 VALUE2 FROM DUAL
		UNION ALL
		SELECT '431' AREA_NO,'长春' AREA_DESC,'43103' CITY_NO,'开发区' CITY_DESC,111 VALUE1, 334 VALUE2 FROM DUAL
		UNION ALL
		SELECT '432' AREA_NO,'吉林' AREA_DESC,'43201' CITY_NO,'龙潭区' CITY_DESC,121 VALUE1, 327 VALUE2 FROM DUAL
		UNION ALL
		SELECT '432' AREA_NO,'吉林' AREA_DESC,'43202' CITY_NO,'昌邑区' CITY_DESC,121 VALUE1, 327 VALUE2 FROM DUAL
		UNION ALL
		SELECT '432' AREA_NO,'吉林' AREA_DESC,'43203' CITY_NO,'丰满区' CITY_DESC,121 VALUE1, 327 VALUE2 FROM DUAL
		UNION ALL
		SELECT '437' AREA_NO,'辽源' AREA_DESC,'43701' CITY_NO,'东辽区' CITY_DESC,331 VALUE1, 533 VALUE2 FROM DUAL
		UNION ALL
		SELECT '437' AREA_NO,'辽源' AREA_DESC,'43702' CITY_NO,'东丰区' CITY_DESC,331 VALUE1, 533 VALUE2 FROM DUAL
		UNION ALL
		SELECT '437' AREA_NO,'辽源' AREA_DESC,'43703' CITY_NO,'龙山区' CITY_DESC,331 VALUE1, 533 VALUE2 FROM DUAL
		
		)
		group by AREA_DESC,CITY_DESC </e:q4l>
	<div class="exampleWarp">

		<c:ndonutpie id="rent_char5" width="100%" height="300" title=""
			unit="个" dimension1="AREA_DESC"
			colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']"
			dimension2="CITY_DESC" legend="true" A="发展用户"
			dataPointClick="dataPointClick" items="${piedata.list}"
			fontsize="8px" />
	</div>
</body>
</html>