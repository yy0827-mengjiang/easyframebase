<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<script type="text/javascript"
	src='<e:url value="/pages/terminal/resources/themes/base/js/echarts.min.js"/>'></script>


<e:if condition="${sessionScope.UserInfo.ADMIN == '1'}">
	<e:set var="area_no">qg</e:set>
	<e:if condition="${param.area_no!=''&&param.area_no!=null }">
		<e:set var="area_no">${param.area_no }</e:set>
	</e:if>
</e:if>
<e:if condition="${sessionScope.UserInfo.ADMIN != '1'}">
	<e:set var="area_no">${sessionScope.UserInfo.AREA_NO}</e:set>
</e:if>
<e:set var="city_no">qxz</e:set>
<e:if condition="${param.area_no!=''&&param.area_no!=null }">
	<e:description>页面刷新时判断选择的地图  ，根据页面传的属性选择要加载的地图</e:description>
	<e:set var="area_no">${param.area_no }</e:set>
</e:if>
<e:if condition="${param.city_no!=''&&param.city_no!=null }">
	<e:set var="city_no">${param.city_no }</e:set>
</e:if>
<e:set var="acct_month">${e:getDate('yyyyMM')}</e:set>
<e:q4l var="areaL">
	SELECT a."AREA_NAME" ,a."AREA_NO" FROM "DIM_AREA_NO" a  WHERE 1=1 AND a."AREA_NO" NOT IN ('0000')
	<e:if condition="${sessionScope.UserInfo.ADMIN != '1'}">
		AND a."AREA_NO"='${sessionScope.UserInfo.AREA_NO}'
	</e:if>
</e:q4l>
<e:q4l var="times">
SELECT "ACCT_MONTH"  times 
FROM public."DM_M_TERM_MARKET_OVERVIEW"  
WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
GROUP BY times 
ORDER BY times 
</e:q4l>
<e:q4l var="pinpai">
	<e:description>品牌前五名名称</e:description>
(
  SELECT DISTINCT "BRAND_NAME" brand_name 
  FROM public."TRMNL_DEVINFO" 
  WHERE "BRAND_NO" IN (
  SELECT  "BRAND_NO" BRAND_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>   
AND "LINE_TYPE" = '1'
  GROUP BY BRAND_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1)
)
UNION ALL 
(
  SELECT DISTINCT "BRAND_NAME" brand_name 
  FROM public."TRMNL_DEVINFO" 
  WHERE "BRAND_NO" IN (
  SELECT  "BRAND_NO" BRAND_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY BRAND_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 OFFSET 1)
)
UNION ALL 
(
  SELECT DISTINCT "BRAND_NAME" brand_name 
  FROM public."TRMNL_DEVINFO" 
  WHERE "BRAND_NO" IN (
  SELECT  "BRAND_NO" BRAND_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY BRAND_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 OFFSET 2)
)
UNION ALL 
(
  SELECT DISTINCT "BRAND_NAME" brand_name 
  FROM public."TRMNL_DEVINFO" 
  WHERE "BRAND_NO" IN (
  SELECT  "BRAND_NO" BRAND_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY BRAND_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 OFFSET 3)
)
UNION ALL 
(
  SELECT DISTINCT "BRAND_NAME" brand_name 
  FROM public."TRMNL_DEVINFO" 
  WHERE "BRAND_NO" IN (
  SELECT  "BRAND_NO" BRAND_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY BRAND_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 OFFSET 4)
)
</e:q4l>
<e:q4l var="pinpai_top1">
SELECT  SUM("TERMINAL_NUM") x ,"ACCT_MONTH" acct_month
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "BRAND_NO" IN (
  SELECT  "BRAND_NO" BRAND_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'   
  GROUP BY BRAND_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 
  )  
  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')   
<e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'  
  GROUP BY  acct_month 
  ORDER BY  acct_month
</e:q4l>
<e:q4l var="pinpai_top2">
SELECT  SUM("TERMINAL_NUM") x ,"ACCT_MONTH" acct_month
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "BRAND_NO" IN (
  SELECT  "BRAND_NO" BRAND_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'  
  GROUP BY BRAND_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1  OFFSET 1
  )  
  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>   AND "LINE_TYPE" = '1'
  GROUP BY  acct_month 
  ORDER BY  acct_month
</e:q4l>
<e:q4l var="pinpai_top3">
SELECT  SUM("TERMINAL_NUM") x ,"ACCT_MONTH" acct_month
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "BRAND_NO" IN (
  SELECT  "BRAND_NO" BRAND_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'   
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY BRAND_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1  OFFSET 2
  )  
  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY  acct_month 
  ORDER BY  acct_month
</e:q4l>
<e:q4l var="pinpai_top4">
SELECT  SUM("TERMINAL_NUM") x ,"ACCT_MONTH" acct_month
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "BRAND_NO" IN (
  SELECT  "BRAND_NO" BRAND_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY BRAND_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1  OFFSET 3
  )  
  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY  acct_month 
  ORDER BY  acct_month
</e:q4l>
<e:q4l var="pinpai_top5">
SELECT  SUM("TERMINAL_NUM") x ,"ACCT_MONTH" acct_month
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "BRAND_NO" IN (
  SELECT  "BRAND_NO" BRAND_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY BRAND_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1  OFFSET 4
  )  
  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY  acct_month 
  ORDER BY  acct_month
</e:q4l>
<e:description>机型前五名</e:description>
<e:q4l var="jixing">
	<e:description>机型前五名名称</e:description>
(
  SELECT DISTINCT "MODEL_NAME" model_name 
  FROM public."TRMNL_DEVINFO" 
  WHERE "MODEL_NO" IN (
  SELECT  "MODEL_NO" MODEL_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY MODEL_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1)
)
UNION ALL 
(
  SELECT DISTINCT "MODEL_NAME" model_name 
  FROM public."TRMNL_DEVINFO" 
  WHERE "MODEL_NO" IN (
  SELECT  "MODEL_NO" MODEL_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY MODEL_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1  OFFSET 1)
)
UNION ALL 
(
  SELECT DISTINCT "MODEL_NAME" model_name 
  FROM public."TRMNL_DEVINFO" 
  WHERE "MODEL_NO" IN (
  SELECT  "MODEL_NO" MODEL_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY MODEL_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1  OFFSET 2)
)
UNION ALL 
(
  SELECT DISTINCT "MODEL_NAME" model_name 
  FROM public."TRMNL_DEVINFO" 
  WHERE "MODEL_NO" IN (
  SELECT  "MODEL_NO" MODEL_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY MODEL_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 OFFSET 3)
)
UNION ALL 
(
  SELECT DISTINCT "MODEL_NAME" model_name 
  FROM public."TRMNL_DEVINFO" 
  WHERE "MODEL_NO" IN (
  SELECT  "MODEL_NO" MODEL_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY MODEL_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 OFFSET 4)
)
</e:q4l>
<e:q4l var="jixing_top1">
SELECT  SUM("TERMINAL_NUM") x ,"ACCT_MONTH" acct_month
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "MODEL_NO" IN (
  SELECT  "MODEL_NO" MODEL_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY MODEL_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 
  )  
  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY  acct_month 
  ORDER BY  acct_month
</e:q4l>
<e:q4l var="jixing_top2">
SELECT  SUM("TERMINAL_NUM") x ,"ACCT_MONTH" acct_month
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "MODEL_NO" IN (
  SELECT  "MODEL_NO" MODEL_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY MODEL_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 OFFSET 1
  )  
  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY  acct_month 
  ORDER BY  acct_month
</e:q4l>
<e:q4l var="jixing_top3">
SELECT  SUM("TERMINAL_NUM") x ,"ACCT_MONTH" acct_month
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "MODEL_NO" IN (
  SELECT  "MODEL_NO" MODEL_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY MODEL_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 OFFSET 2
  )  
  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY  acct_month 
  ORDER BY  acct_month
</e:q4l>
<e:q4l var="jixing_top4">
SELECT  SUM("TERMINAL_NUM") x ,"ACCT_MONTH" acct_month
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "MODEL_NO" IN (
  SELECT  "MODEL_NO" MODEL_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY MODEL_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 OFFSET 3
  )  
  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY  acct_month 
  ORDER BY  acct_month
</e:q4l>
<e:q4l var="jixing_top5">
SELECT  SUM("TERMINAL_NUM") x ,"ACCT_MONTH" acct_month
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "MODEL_NO" IN (
  SELECT  "MODEL_NO" MODEL_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY MODEL_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1  OFFSET 4
  )  
  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY  acct_month 
  ORDER BY  acct_month
</e:q4l>
<e:description>价格段前五名</e:description>
<e:q4l var="price">
(
  SELECT DISTINCT "PRICE_NAME" price_name 
  FROM public."DIM_PRICES_PERIOD" 
  WHERE "PRICE_NO" IN (
  SELECT  "PRICE_NO" PRICE_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY PRICE_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1)
)
UNION ALL 
(
  SELECT DISTINCT "PRICE_NAME" price_name 
  FROM public."DIM_PRICES_PERIOD" 
  WHERE "PRICE_NO" IN (
  SELECT  "PRICE_NO" PRICE_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY PRICE_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 OFFSET 1)
)
UNION ALL 
(
  SELECT DISTINCT "PRICE_NAME" price_name 
  FROM public."DIM_PRICES_PERIOD" 
  WHERE "PRICE_NO" IN (
  SELECT  "PRICE_NO" PRICE_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY PRICE_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 OFFSET 2)
)
UNION ALL 
(
  SELECT DISTINCT "PRICE_NAME" price_name 
  FROM public."DIM_PRICES_PERIOD" 
  WHERE "PRICE_NO" IN (
  SELECT  "PRICE_NO" PRICE_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY PRICE_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 OFFSET 3)
)
UNION ALL 
(
  SELECT DISTINCT "PRICE_NAME" price_name 
  FROM public."DIM_PRICES_PERIOD" 
  WHERE "PRICE_NO" IN (
  SELECT  "PRICE_NO" PRICE_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY PRICE_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 OFFSET 4)
)
</e:q4l>
<e:description> 价格段Top5</e:description>
<e:q4l var="price_top1">
SELECT  SUM("TERMINAL_NUM") x ,"ACCT_MONTH" acct_month
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "PRICE_NO" IN (
  SELECT  "PRICE_NO" PRICE_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY PRICE_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 
  )  
  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY  acct_month 
  ORDER BY  acct_month
</e:q4l>
<e:q4l var="price_top2">
SELECT  SUM("TERMINAL_NUM") x ,"ACCT_MONTH" acct_month
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "PRICE_NO" IN (
  SELECT  "PRICE_NO" PRICE_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY PRICE_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1  OFFSET 1
  )  
  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY  acct_month 
  ORDER BY  acct_month
</e:q4l>
<e:q4l var="price_top3">
SELECT  SUM("TERMINAL_NUM") x ,"ACCT_MONTH" acct_month
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "PRICE_NO" IN (
  SELECT  "PRICE_NO" PRICE_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY PRICE_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1  OFFSET 2
  )  
  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY  acct_month 
  ORDER BY  acct_month
</e:q4l>
<e:q4l var="price_top4">
SELECT  SUM("TERMINAL_NUM") x ,"ACCT_MONTH" acct_month
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "PRICE_NO" IN (
  SELECT  "PRICE_NO" PRICE_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY PRICE_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1  OFFSET 3
  )  
  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY  acct_month 
  ORDER BY  acct_month
</e:q4l>
<e:q4l var="price_top5">
SELECT  SUM("TERMINAL_NUM") x ,"ACCT_MONTH" acct_month
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "PRICE_NO" IN (
  SELECT  "PRICE_NO" PRICE_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY PRICE_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1  OFFSET 4
  )  
  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY  acct_month 
  ORDER BY  acct_month
</e:q4l>
<e:description> 终端制式</e:description>
<e:q4l var="terminal">
(
  SELECT DISTINCT "STANDARD_NAME" standard_name 
  FROM public."DIM_TERM_STANDARD" 
  WHERE "STANDARD_NO" IN (
  SELECT  "STANDARD_NO" STANDARD_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY STANDARD_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1)
)
UNION ALL 
(
  SELECT DISTINCT "STANDARD_NAME" standard_name 
  FROM public."DIM_TERM_STANDARD" 
  WHERE "STANDARD_NO" IN (
  SELECT  "STANDARD_NO" STANDARD_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY STANDARD_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 OFFSET 1)
)
UNION ALL 
(
  SELECT DISTINCT "STANDARD_NAME" standard_name 
  FROM public."DIM_TERM_STANDARD" 
  WHERE "STANDARD_NO" IN (
  SELECT  "STANDARD_NO" STANDARD_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY STANDARD_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 OFFSET 2)
)
UNION ALL 
(
  SELECT DISTINCT "STANDARD_NAME" standard_name 
  FROM public."DIM_TERM_STANDARD" 
  WHERE "STANDARD_NO" IN (
  SELECT  "STANDARD_NO" STANDARD_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY STANDARD_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 OFFSET 3)
)
UNION ALL 
(
  SELECT DISTINCT "STANDARD_NAME" standard_name 
  FROM public."DIM_TERM_STANDARD" 
  WHERE "STANDARD_NO" IN (
  SELECT  "STANDARD_NO" STANDARD_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY STANDARD_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 OFFSET 4)
)
</e:q4l>
<e:description>终端制式Top5</e:description>
<e:q4l var="terminal_top1">
SELECT  SUM("TERMINAL_NUM") x ,"ACCT_MONTH" acct_month
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "STANDARD_NO" IN (
  SELECT  "STANDARD_NO" STANDARD_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY STANDARD_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 
  )  
  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY  acct_month 
  ORDER BY  acct_month
</e:q4l>
<e:q4l var="terminal_top2">
SELECT  SUM("TERMINAL_NUM") x ,"ACCT_MONTH" acct_month
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "STANDARD_NO" IN (
  SELECT  "STANDARD_NO" STANDARD_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY STANDARD_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1  OFFSET 1
  )  
  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY  acct_month 
  ORDER BY  acct_month
</e:q4l>
<e:q4l var="terminal_top3">
SELECT  SUM("TERMINAL_NUM") x ,"ACCT_MONTH" acct_month
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "STANDARD_NO" IN (
  SELECT  "STANDARD_NO" STANDARD_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY STANDARD_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 OFFSET 2
  )  
  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY  acct_month 
  ORDER BY  acct_month
</e:q4l>
<e:q4l var="terminal_top4">
SELECT  SUM("TERMINAL_NUM") x ,"ACCT_MONTH" acct_month
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "STANDARD_NO" IN (
  SELECT  "STANDARD_NO" STANDARD_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY STANDARD_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 OFFSET 3
  )  
  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY  acct_month 
  ORDER BY  acct_month
</e:q4l>
<e:q4l var="terminal_top5">
SELECT  SUM("TERMINAL_NUM") x ,"ACCT_MONTH" acct_month
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "STANDARD_NO" IN (
  SELECT  "STANDARD_NO" STANDARD_NO 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" 
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY STANDARD_NO  
  ORDER BY SUM("TERMINAL_NUM")  DESC LIMIT 1 OFFSET 4
  )  
  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  GROUP BY  acct_month 
  ORDER BY  acct_month
</e:q4l>
<e:description>CPU核数</e:description>
<e:q4l var="cpu">
SELECT  "CPU" cpu 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" A ,public."TRMNL_DEVINFO" B
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
  AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  AND A."MODEL_NO" = B."MODEL_NO"
  GROUP BY cpu 
  ORDER BY SUM("TERMINAL_NUM")  DESC  LIMIT 5
</e:q4l>
<e:description>CPU前5名</e:description>
<e:q4l var="cpu_top1">
  SELECT sum("TERMINAL_NUM") x , "ACCT_MONTH"  acct_month 
  FROM public."DM_M_TERM_MARKET_OVERVIEW"
  WHERE "MODEL_NO" IN (
  SELECT DISTINCT "MODEL_NO" 
  FROM public."TRMNL_DEVINFO"
  WHERE "CPU" IN 
	(
  SELECT  "CPU" cpu
  FROM public."DM_M_TERM_MARKET_OVERVIEW" A ,public."TRMNL_DEVINFO" B
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
  AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  AND A."MODEL_NO" = B."MODEL_NO"
  GROUP BY cpu 
  ORDER BY SUM("TERMINAL_NUM")  DESC  LIMIT 1 
	)
			) 
AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
 AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
GROUP BY acct_month
ORDER BY acct_month 
</e:q4l>
<e:q4l var="cpu_top2">
  SELECT sum("TERMINAL_NUM") x , "ACCT_MONTH"  acct_month 
  FROM public."DM_M_TERM_MARKET_OVERVIEW"
  WHERE "MODEL_NO" IN (
  SELECT DISTINCT "MODEL_NO" 
  FROM public."TRMNL_DEVINFO"
  WHERE "CPU" IN 
	(
  SELECT  "CPU" cpu
  FROM public."DM_M_TERM_MARKET_OVERVIEW" A ,public."TRMNL_DEVINFO" B
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
  AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  AND A."MODEL_NO" = B."MODEL_NO"
  GROUP BY cpu 
  ORDER BY SUM("TERMINAL_NUM")  DESC  LIMIT 1 offset 1
	)
			) 
AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
 AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
GROUP BY acct_month
ORDER BY acct_month 
</e:q4l>
<e:q4l var="cpu_top3">
  SELECT sum("TERMINAL_NUM") x , "ACCT_MONTH"  acct_month 
  FROM public."DM_M_TERM_MARKET_OVERVIEW"
  WHERE "MODEL_NO" IN (
  SELECT DISTINCT "MODEL_NO" 
  FROM public."TRMNL_DEVINFO"
  WHERE "CPU" IN 
	(
  SELECT  "CPU" cpu
  FROM public."DM_M_TERM_MARKET_OVERVIEW" A ,public."TRMNL_DEVINFO" B
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
  AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  AND A."MODEL_NO" = B."MODEL_NO"
  GROUP BY cpu 
  ORDER BY SUM("TERMINAL_NUM")  DESC  LIMIT 1 offset 2
	)
			) 
AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
 AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
GROUP BY acct_month
ORDER BY acct_month 
</e:q4l>
<e:q4l var="cpu_top4">
  SELECT sum("TERMINAL_NUM") x , "ACCT_MONTH"  acct_month 
  FROM public."DM_M_TERM_MARKET_OVERVIEW"
  WHERE "MODEL_NO" IN (
  SELECT DISTINCT "MODEL_NO" 
  FROM public."TRMNL_DEVINFO"
  WHERE "CPU" IN 
	(
  SELECT  "CPU" cpu
  FROM public."DM_M_TERM_MARKET_OVERVIEW" A ,public."TRMNL_DEVINFO" B
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
  AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  AND A."MODEL_NO" = B."MODEL_NO"
  GROUP BY cpu 
  ORDER BY SUM("TERMINAL_NUM")  DESC  LIMIT 1 offset 3
	)
			) 
AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
 AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
GROUP BY acct_month
ORDER BY acct_month 
</e:q4l>
<e:q4l var="cpu_top5">
  SELECT sum("TERMINAL_NUM") x , "ACCT_MONTH"  acct_month 
  FROM public."DM_M_TERM_MARKET_OVERVIEW"
  WHERE "MODEL_NO" IN (
  SELECT DISTINCT "MODEL_NO" 
  FROM public."TRMNL_DEVINFO"
  WHERE "CPU" IN 
	(
  SELECT  "CPU" cpu
  FROM public."DM_M_TERM_MARKET_OVERVIEW" A ,public."TRMNL_DEVINFO" B
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
  AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  AND A."MODEL_NO" = B."MODEL_NO"
  GROUP BY cpu 
  ORDER BY SUM("TERMINAL_NUM")  DESC  LIMIT 1 offset 4
	)
			) 
AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
 AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
GROUP BY acct_month
ORDER BY acct_month 
</e:q4l>
<e:description>屏幕大小</e:description>
<e:q4l var="main">
SELECT  "MAIN_SIZE" main_size 
  FROM public."DM_M_TERM_MARKET_OVERVIEW" A ,public."TRMNL_DEVINFO" B
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
  AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  AND A."MODEL_NO" = B."MODEL_NO"
  GROUP BY main_size 
  ORDER BY SUM("TERMINAL_NUM")  DESC  LIMIT 5
</e:q4l>
<e:description>屏幕大小前5名</e:description>
<e:q4l var="main_top1">
  SELECT sum("TERMINAL_NUM") x , "ACCT_MONTH"  acct_month 
  FROM public."DM_M_TERM_MARKET_OVERVIEW"
  WHERE "MODEL_NO" IN (
  SELECT DISTINCT "MODEL_NO" 
  FROM public."TRMNL_DEVINFO"
  WHERE "MAIN_SIZE" IN 
	(
  SELECT  "MAIN_SIZE" MAIN_SIZE
  FROM public."DM_M_TERM_MARKET_OVERVIEW" A ,public."TRMNL_DEVINFO" B
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
  AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  AND A."MODEL_NO" = B."MODEL_NO"
  GROUP BY MAIN_SIZE 
  ORDER BY SUM("TERMINAL_NUM")  DESC  LIMIT 1 
	)
			) 
AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
 AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
GROUP BY acct_month
ORDER BY acct_month 
</e:q4l>
<e:q4l var="main_top2">
  SELECT sum("TERMINAL_NUM") x , "ACCT_MONTH"  acct_month 
  FROM public."DM_M_TERM_MARKET_OVERVIEW"
  WHERE "MODEL_NO" IN (
  SELECT DISTINCT "MODEL_NO" 
  FROM public."TRMNL_DEVINFO"
  WHERE "MAIN_SIZE" IN 
	(
  SELECT  "MAIN_SIZE" MAIN_SIZE
  FROM public."DM_M_TERM_MARKET_OVERVIEW" A ,public."TRMNL_DEVINFO" B
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
  AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  AND A."MODEL_NO" = B."MODEL_NO"
  GROUP BY MAIN_SIZE 
  ORDER BY SUM("TERMINAL_NUM")  DESC  LIMIT 1  OFFSET 1
	)
			) 
AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
 AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
GROUP BY acct_month
ORDER BY acct_month 
</e:q4l>
<e:q4l var="main_top3">
  SELECT sum("TERMINAL_NUM") x , "ACCT_MONTH"  acct_month 
  FROM public."DM_M_TERM_MARKET_OVERVIEW"
  WHERE "MODEL_NO" IN (
  SELECT DISTINCT "MODEL_NO" 
  FROM public."TRMNL_DEVINFO"
  WHERE "MAIN_SIZE" IN 
	(
  SELECT  "MAIN_SIZE" MAIN_SIZE
  FROM public."DM_M_TERM_MARKET_OVERVIEW" A ,public."TRMNL_DEVINFO" B
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
  AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  AND A."MODEL_NO" = B."MODEL_NO"
  GROUP BY MAIN_SIZE 
  ORDER BY SUM("TERMINAL_NUM")  DESC  LIMIT 1  OFFSET 2
	)
			) 
AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
 AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
GROUP BY acct_month
ORDER BY acct_month 
</e:q4l>
<e:q4l var="main_top4">
  SELECT sum("TERMINAL_NUM") x , "ACCT_MONTH"  acct_month 
  FROM public."DM_M_TERM_MARKET_OVERVIEW"
  WHERE "MODEL_NO" IN (
  SELECT DISTINCT "MODEL_NO" 
  FROM public."TRMNL_DEVINFO"
  WHERE "MAIN_SIZE" IN 
	(
  SELECT  "MAIN_SIZE" MAIN_SIZE
  FROM public."DM_M_TERM_MARKET_OVERVIEW" A ,public."TRMNL_DEVINFO" B
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
  AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  AND A."MODEL_NO" = B."MODEL_NO"
  GROUP BY MAIN_SIZE 
  ORDER BY SUM("TERMINAL_NUM")  DESC  LIMIT 1  OFFSET 3
	)
			) 
AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
 AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
GROUP BY acct_month
ORDER BY acct_month 
</e:q4l>
<e:q4l var="main_top5">
  SELECT sum("TERMINAL_NUM") x , "ACCT_MONTH"  acct_month 
  FROM public."DM_M_TERM_MARKET_OVERVIEW"
  WHERE "MODEL_NO" IN (
  SELECT DISTINCT "MODEL_NO" 
  FROM public."TRMNL_DEVINFO"
  WHERE "MAIN_SIZE" IN 
	(
  SELECT  "MAIN_SIZE" MAIN_SIZE
  FROM public."DM_M_TERM_MARKET_OVERVIEW" A ,public."TRMNL_DEVINFO" B
  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
  AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
  AND A."MODEL_NO" = B."MODEL_NO"
  GROUP BY MAIN_SIZE 
  ORDER BY SUM("TERMINAL_NUM")  DESC  LIMIT 1  OFFSET 4
	)
			) 
AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-6' month, 'yyyymm') 
 AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
 <e:if
		condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if
			condition="${city_no!='qxz'  }">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	 </e:if>    AND "LINE_TYPE" = '1'
GROUP BY acct_month
ORDER BY acct_month 
</e:q4l>
<!DOCTYPE html>
<html>
<head>
<a:base />
<c:resources type="easyui,highchart" style="b" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--声明以IE最高版本浏览器内核或谷歌浏览器内核进行渲染 -->
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<!--声明以360极速模式进行渲染 -->
<meta name=”renderer” content=”webkit” />
<!--系统名称文本 -->
<title>终端指标分析系统－市场总览</title>

<e:style
	value="/pages/terminal/resources/component/easyui/themes/metro/easyui.css" />
<e:style
	value="/pages/terminal/resources/component/easyui/themes/icon.css" />
<!-- 独立Js脚本 -->
<script type="text/javascript"
	src='<e:url value="/pages/terminal/resources/themes/base/js/boncCommon.js"/>'></script>
<!-- 独立Css层叠样式表 -->
<e:style
	value="/pages/terminal/resources/themes/base/boncBase@links.css" />
<script type="text/javascript"
	src='<e:url value="/pages/terminal/resources/themes/base/js/market.js"/>'></script> 
<script type="text/javascript" language="JavaScript">
function findCity(){
	$("#city").empty();
	$("#city").append("<option value='qxz'>--请选择--</option>");
	var AREA_NO = $("#area").val();
	$.post('<e:url value="/pages/terminal/common/cityAction.jsp"/>',{ AREA_NO: AREA_NO},function(data){
		var city =eval(data.trim());
      	for(var i = 0;i<city.length;i++){
 			$("#city").append("<option value='"+city[i].CITY_NO+"'>"+city[i].CITY_NAME+"</option>");
 		}
    });
}

		$(function () {
			var time=[];
			var dataJson2=$.parseJSON('${e:java2json(times.list)}');
			for(var a=0;a<dataJson2.length;a++){
				time.push({
					value: dataJson2[a]["times"]
	 			});					
			}
			 if('${sessionScope.UserInfo.ADMIN}'!='1'){
			        $('#area option[value="qg"]').remove();
			        }
				 		$("#area").val("${area_no}");
						$("#city").empty();
						$("#city").append("<option value='qxz'>--请选择--</option>");
						var AREA_NO = $("#area").val();
						$.post('<e:url value="/pages/terminal/common/cityAction.jsp"/>',{ AREA_NO: AREA_NO},function(data){
							var city =eval(data.trim());
					      	for(var i = 0;i<city.length;i++){
					 			$("#city").append("<option value='"+city[i].CITY_NO+"'>"+city[i].CITY_NAME+"</option>");
					 		}
					 		$("#city").val("${city_no}");
					    });
			
			
			
			setPinpaiCharts(time);
			setJixingCharts(time);
			setPriceCharts(time);
			setTerminalCharts(time);
			setCpuCharts(time);
			setMainsizeCharts(time);
		});

			function setPinpaiCharts(time){
				
				var dataJson1=$.parseJSON('${e:java2json(pinpai.list)}');	
				var dataJson3=$.parseJSON('${e:java2json(pinpai_top1.list)}');
				var dataJson4=$.parseJSON('${e:java2json(pinpai_top2.list)}');
				var dataJson5=$.parseJSON('${e:java2json(pinpai_top3.list)}');
				var dataJson6=$.parseJSON('${e:java2json(pinpai_top4.list)}');
				var dataJson7=$.parseJSON('${e:java2json(pinpai_top5.list)}');
				
				var brand_name=[]; 				
				var top1=[];var top2=[];var top3=[];var top4=[];var top5=[];
				var tops=[];var str = '';
				//alert(dataJson[0]["BRAND_NAME"]);
				for(var a=0;a<dataJson1.length;a++){
					
					str = dataJson1[a]["brand_name"] ;
					brand_name.push(str);					
				}				
				for(var a=0;a<dataJson3.length;a++){
					top1.push({
						value: dataJson3[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson4.length;a++){
					top2.push({
						value: dataJson4[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson5.length;a++){
					top3.push({
						value: dataJson5[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson6.length;a++){
					top4.push({
						value: dataJson6[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson7.length;a++){
					top5.push({
						value: dataJson7[a]["x"]
		 			});						
				}	
                    if(brand_name[0]){
                    	tops.push({
    						name:brand_name[0],
    						type:'bar',
    						
    			            stack: '品牌',
    						data:top1
    					});
                    }
                    if(brand_name[1]){
                    	tops.push({
    						name:brand_name[1],
    						type:'bar',
    						
    			            stack: '品牌',
    						data:top2
    					});
                    }
					if(brand_name[2]){
                    	tops.push({
    						name:brand_name[2],
    						type:'bar',
    						
    			            stack: '品牌',
    						data:top3
    					});
                    }
					if(brand_name[3]){
                    	tops.push({
    						name:brand_name[3],
    						type:'bar',
    						
    			            stack: '品牌',
    						data:top4
    					});
                    }
					if(brand_name[4]){
                    	tops.push({
    						name:brand_name[4],
    						type:'bar',
    						
    			            stack: '品牌',
    						data:top5
    					});
                    }
				 var myChart = echarts.init(document.getElementById('pinpai'));
				 myChart.setOption(option = {
							 title : {
						        text: '品牌销量',
						        subtext: ''
						    },
						    tooltip : {
						        trigger: 'axis',
						        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
						            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
						        }
						    },
						    grid: {
						        left: '2%',
						        right: '4%',
						        bottom: '3%',
						        containLabel: true
						    },
						    legend: {
						    	show:true,
						    	left:'18%',
						        data:brand_name 
						    },
						    toolbox: {
						        show : false,
						        orient: 'vertical',
						        x: 'right',
						        y: 'center',
						        feature : {
						            mark : {show: true},
						            dataView : {show: true, readOnly: false},
						            magicType : {show: true, type: ['line', 'bar', 'stack', 'tiled']},
						            restore : {show: true},
						            saveAsImage : {show: true}
						        }
						    },
						    calculable : true,
						    xAxis : [
						        {
						            type : 'category',
						            data :time
						        }
						    ],
						    yAxis : [
						        {
						            type : 'value'
						        }
						    ],
						    series : tops
						});
					myChart.hideLoading();	
			}
	         //机型
	         function setJixingCharts(time){
				
				var dataJson1=$.parseJSON('${e:java2json(jixing.list)}');	
				var dataJson3=$.parseJSON('${e:java2json(jixing_top1.list)}');
				var dataJson4=$.parseJSON('${e:java2json(jixing_top2.list)}');
				var dataJson5=$.parseJSON('${e:java2json(jixing_top3.list)}');
				var dataJson6=$.parseJSON('${e:java2json(jixing_top4.list)}');
				var dataJson7=$.parseJSON('${e:java2json(jixing_top5.list)}');
				
				var model_name=[]; 
				var top1=[];var top2=[];var top3=[];var top4=[];var top5=[];
				var tops=[];var str = '';
				//alert(dataJson[0]["BRAND_NAME"]);
				for(var a=0;a<dataJson1.length;a++){
					
					str = dataJson1[a]["model_name"];
					model_name.push( str);					
				}
				for(var a=0;a<dataJson3.length;a++){
					top1.push({
						value: dataJson3[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson4.length;a++){
					top2.push({
						value: dataJson4[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson5.length;a++){
					top3.push({
						value: dataJson5[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson6.length;a++){
					top4.push({
						value: dataJson6[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson7.length;a++){
					top5.push({
						value: dataJson7[a]["x"]
		 			});						
				}	
					if(model_name[0]){
						tops.push({
							name:model_name[0],
							type:'bar',
				            stack: '机型',
							data:top1
						});
					}				
					if(model_name[1]){
						tops.push({
							name:model_name[1],
							type:'bar',
				            stack: '机型',
							data:top2
						});
					}	
					if(model_name[2]){
						tops.push({
							name:model_name[2],
							type:'bar',
				            stack: '机型',
							data:top3
						});
					}	
					if(model_name[3]){
						tops.push({
							name:model_name[3],
							type:'bar',
				            stack: '机型',
							data:top4
						});
					}	
					if(model_name[4]){
						tops.push({
							name:model_name[4],
							type:'bar',
				            stack: '机型',
							data:top5
						});
					}	
				 var myChart = echarts.init(document.getElementById('jixing'));
				 myChart.setOption(option = {
							 title : {
						        text: '机型销量',
						        subtext: ''
						    },
						    tooltip : {
						        trigger: 'axis',
						        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
						            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
						        }
						    },
						    grid: {
						        left: '2%',
						        right: '4%',
						        bottom: '3%',
						        containLabel: true
						    },
						    legend: {
						    	show:true,
						    	left:'18%',
						        data:model_name 
						    },
						    toolbox: {
						        show : false,
						        orient: 'vertical',
						        x: 'right',
						        y: 'center',
						        feature : {
						            mark : {show: true},
						            dataView : {show: true, readOnly: false},
						            magicType : {show: true, type: ['line', 'bar', 'stack', 'tiled']},
						            restore : {show: true},
						            saveAsImage : {show: true}
						        }
						    },
						    calculable : true,
						    xAxis : [
						        {
						            type : 'category',
						            data :time
						        }
						    ],
						    yAxis : [
						        {
						            type : 'value'
						        }
						    ],
						    series : tops
						});
					myChart.hideLoading();	
			}
	         //价格段
	         function setPriceCharts(time){
				
				var dataJson1=$.parseJSON('${e:java2json(price.list)}');	
				var dataJson3=$.parseJSON('${e:java2json(price_top1.list)}');
				var dataJson4=$.parseJSON('${e:java2json(price_top2.list)}');
				var dataJson5=$.parseJSON('${e:java2json(price_top3.list)}');
				var dataJson6=$.parseJSON('${e:java2json(price_top4.list)}');
				var dataJson7=$.parseJSON('${e:java2json(price_top5.list)}');
				
				var price_name=[]; 
				var top1=[];var top2=[];var top3=[];var top4=[];var top5=[];
				var tops=[];var str = '';
				//alert(dataJson[0]["BRAND_NAME"]);
				for(var a=0;a<dataJson1.length;a++){
					
					str  = dataJson1[a]["price_name"];
					price_name.push(str);					
				}
				for(var a=0;a<dataJson3.length;a++){
					top1.push({
						value: dataJson3[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson4.length;a++){
					top2.push({
						value: dataJson4[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson5.length;a++){
					top3.push({
						value: dataJson5[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson6.length;a++){
					top4.push({
						value: dataJson6[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson7.length;a++){
					top5.push({
						value: dataJson7[a]["x"]
		 			});						
				}	
				
					if(price_name[0]){
						tops.push({
							name:price_name[0],
							type:'bar',
				            stack: '价格段',
							data:top1
						});
					}
					if(price_name[1]){
						tops.push({
							name:price_name[1],
							type:'bar',
				            stack: '价格段',
							data:top2
						});
					}
					if(price_name[2]){
						tops.push({
							name:price_name[2],
							type:'bar',
				            stack: '价格段',
							data:top3
						});
					}
					if(price_name[3]){
						tops.push({
							name:price_name[3],
							type:'bar',
				            stack: '价格段',
							data:top4
						});
					}
					if(price_name[4]){
						tops.push({
							name:price_name[4],
							type:'bar',
				            stack: '价格段',
							data:top5
						});
					}				
				 var myChart = echarts.init(document.getElementById('price'));
				 myChart.setOption(option = {
							 title : {
						        text: '价格段',
						        subtext: ''
						    },
						    tooltip : {
						        trigger: 'axis',
						        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
						            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
						        }
						    },
						    grid: {
						        left: '2%',
						        right: '4%',
						        bottom: '3%',
						        containLabel: true
						    },
						    legend: {
						    	show:true,
						    	left:'18%',
						        data:price_name 
						    },
						    toolbox: {
						        show : false,
						        orient: 'vertical',
						        x: 'right',
						        y: 'center',
						        feature : {
						            mark : {show: true},
						            dataView : {show: true, readOnly: false},
						            magicType : {show: true, type: ['line', 'bar', 'stack', 'tiled']},
						            restore : {show: true},
						            saveAsImage : {show: true}
						        }
						    },
						    calculable : true,
						    xAxis : [
						        {
						            type : 'category',
						            data :time
						        }
						    ],
						    yAxis : [
						        {
						            type : 'value'
						        }
						    ],
						    series : tops
						});
					myChart.hideLoading();	
			}
		
	         //终端制式      setTerminalCharts(time)
	         function setTerminalCharts(time){
	        	 //alert();
				var dataJson1=$.parseJSON('${e:java2json(terminal.list)}');	
				var dataJson3=$.parseJSON('${e:java2json(terminal_top1.list)}');
				var dataJson4=$.parseJSON('${e:java2json(terminal_top2.list)}');
				var dataJson5=$.parseJSON('${e:java2json(terminal_top3.list)}');
				var dataJson6=$.parseJSON('${e:java2json(terminal_top4.list)}');
				var dataJson7=$.parseJSON('${e:java2json(terminal_top5.list)}');
				
				var terminal_name=[]; 
				var top1=[];var top2=[];var top3=[];var top4=[];var top5=[];
				var tops=[];var str ='';
				//alert(dataJson[0]["BRAND_NAME"]);
				for(var a=0;a<dataJson1.length;a++){
					
					str = dataJson1[a]["standard_name"];
					terminal_name.push(str);					
				}
				for(var a=0;a<dataJson3.length;a++){
					top1.push({
						value: dataJson3[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson4.length;a++){
					top2.push({
						value: dataJson4[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson5.length;a++){
					top3.push({
						value: dataJson5[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson6.length;a++){
					top4.push({
						value: dataJson6[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson7.length;a++){
					top5.push({
						value: dataJson7[a]["x"]
		 			});						
				}	if(terminal_name[0]){
					tops.push({
						name:terminal_name[0],
						type:'bar',
			            stack: '终端制式',
						data:top1
					});
					}
				    if(terminal_name[1]){
					tops.push({
						name:terminal_name[1],
						type:'bar',
			            stack: '终端制式',
						data:top2
					});
				    }
				    if(terminal_name[2]){
					tops.push({
						name:terminal_name[2],
						type:'bar',
			            stack: '终端制式',
						data:top3
					});
				    }
					if(terminal_name[3]){
					tops.push({
						name:terminal_name[3],
						type:'bar',
			            stack: '终端制式',
						data:top4
					});
					}
					if(terminal_name[4]){
					tops.push({
						name:terminal_name[4],
						type:'bar',
			            stack: '终端制式',
						data:top5
					});
					}
				 var myChart = echarts.init(document.getElementById('terminal'));
				// alert();
				 myChart.setOption(option = {
							 title : {
						        text: '终端制式',
						        subtext: ''
						    },
						    tooltip : {
						        trigger: 'axis',
						        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
						            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
						        }
						    },
						    grid: {
						        left: '2%',
						        right: '4%',
						        bottom: '3%',
						        containLabel: true
						    },
						    legend: {
						    	show:true,
						    	left:'18%',
						        data:terminal_name 
						    },
						    toolbox: {
						        show : false,
						        orient: 'vertical',
						        x: 'right',
						        y: 'center',
						        feature : {
						            mark : {show: true},
						            dataView : {show: true, readOnly: false},
						            magicType : {show: true, type: ['line', 'bar', 'stack', 'tiled']},
						            restore : {show: true},
						            saveAsImage : {show: true}
						        }
						    },
						    calculable : true,
						    xAxis : [
						        {
						            type : 'category',
						            data :time
						        }
						    ],
						    yAxis : [
						        {
						            type : 'value'
						        }
						    ],
						    series : tops
						});
					myChart.hideLoading();	
			}
	         //CPU      setCpuCharts(time)
	         function setCpuCharts(time){
	        	 //alert();
				var dataJson1=$.parseJSON('${e:java2json(cpu.list)}');	
				var dataJson3=$.parseJSON('${e:java2json(cpu_top1.list)}');
				var dataJson4=$.parseJSON('${e:java2json(cpu_top2.list)}');
				var dataJson5=$.parseJSON('${e:java2json(cpu_top3.list)}');
				var dataJson6=$.parseJSON('${e:java2json(cpu_top4.list)}');
				var dataJson7=$.parseJSON('${e:java2json(cpu_top5.list)}');
				
				var cpu_name=[]; 
				var top1=[];var top2=[];var top3=[];var top4=[];var top5=[];
				var tops=[];
				var str = ''
				//alert(dataJson[0]["BRAND_NAME"]);
				for(var a=0;a<dataJson1.length;a++){
					str = dataJson1[a]["cpu"];
					cpu_name.push(str);					
				}
				for(var a=0;a<dataJson3.length;a++){
					top1.push({
						value: dataJson3[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson4.length;a++){
					top2.push({
						value: dataJson4[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson5.length;a++){
					top3.push({
						value: dataJson5[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson6.length;a++){
					top4.push({
						value: dataJson6[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson7.length;a++){
					top5.push({
						value: dataJson7[a]["x"]
		 			});						
				}	
				if(cpu_name[0]){
					tops.push({
						name:cpu_name[0],
						type:'bar',
			            stack: 'CPU',
						data:top1
					});
					}
				    if(cpu_name[1]){
					tops.push({
						name:cpu_name[1],
						type:'bar',
			            stack: 'CPU',
						data:top2
					});
				    }
				    if(cpu_name[2]){
					tops.push({
						name:cpu_name[2],
						type:'bar',
			            stack: 'CPU',
						data:top3
					});
				    }
					if(cpu_name[3]){
					tops.push({
						name:cpu_name[3],
						type:'bar',
			            stack: 'CPU',
						data:top4
					});
					}
					if(cpu_name[4]){
					tops.push({
						name:cpu_name[4],
						type:'bar',
			            stack: 'CPU',
						data:top5
					});
					}
				 var myChart = echarts.init(document.getElementById('cpu'));
				// alert();
				 myChart.setOption(option = {
							 title : {
						        text: 'CPU',
						        subtext: ''
						    },
						    tooltip : {
						        trigger: 'axis',
						        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
						            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
						        }
						    },
						    grid: {
						        left: '2%',
						        right: '4%',
						        bottom: '3%',
						        containLabel: true
						    },
						    legend: {
						    	show:true,
						    	left:'18%',
						        data:cpu_name 
						    },
						    toolbox: {
						        show : false,
						        orient: 'vertical',
						        x: 'right',
						        y: 'center',
						        feature : {
						            mark : {show: true},
						            dataView : {show: true, readOnly: false},
						            magicType : {show: true, type: ['line', 'bar', 'stack', 'tiled']},
						            restore : {show: true},
						            saveAsImage : {show: true}
						        }
						    },
						    calculable : true,
						    xAxis : [
						        {
						            type : 'category',
						            data :time
						        }
						    ],
						    yAxis : [
						        {
						            type : 'value'
						        }
						    ],
						    series : tops
						});
					myChart.hideLoading();	
			}
	         //屏幕大小      setMainsizeCharts(time)
	         function setMainsizeCharts(time){
	        	 //alert();
				var dataJson1=$.parseJSON('${e:java2json(main.list)}');	
				var dataJson3=$.parseJSON('${e:java2json(main_top1.list)}');
				var dataJson4=$.parseJSON('${e:java2json(main_top2.list)}');
				var dataJson5=$.parseJSON('${e:java2json(main_top3.list)}');
				var dataJson6=$.parseJSON('${e:java2json(main_top4.list)}');
				var dataJson7=$.parseJSON('${e:java2json(main_top5.list)}');
				
				var main_name=[]; 
				var top1=[];var top2=[];var top3=[];var top4=[];var top5=[];
				var tops=[];
				var str = '';
				for(var a=0;a<dataJson1.length;a++){
					str = dataJson1[a]["main_size"];
					main_name.push(str);					
				}
				for(var a=0;a<dataJson3.length;a++){
					top1.push({
						value: dataJson3[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson4.length;a++){
					top2.push({
						value: dataJson4[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson5.length;a++){
					top3.push({
						value: dataJson5[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson6.length;a++){
					top4.push({
						value: dataJson6[a]["x"]
		 			});						
				}	
				for(var a=0;a<dataJson7.length;a++){
					top5.push({
						value: dataJson7[a]["x"]
		 			});						
				}	
				if(main_name[0]){
					tops.push({
						name:main_name[0],
						type:'bar',
			            stack: '屏幕大小',
						data:top1
					});
					}
				    if(main_name[1]){
					tops.push({
						name:main_name[1],
						type:'bar',
			            stack: '屏幕大小',
						data:top2
					});
				    }
				    if(main_name[2]){
					tops.push({
						name:main_name[2],
						type:'bar',
			            stack: '屏幕大小',
						data:top3
					});
				    }
					if(main_name[3]){
					tops.push({
						name:main_name[3],
						type:'bar',
			            stack: '屏幕大小',
						data:top4
					});
					}
					if(main_name[4]){
					tops.push({
						name:main_name[4],
						type:'bar',
			            stack: '屏幕大小',
						data:top5
					});
					}
				 var myChart = echarts.init(document.getElementById('main_size'));
				// alert();
				 myChart.setOption(option = {
							 title : {
						        text: '屏幕大小',
						        subtext: ''
						    },
						    tooltip : {
						        trigger: 'axis',
						        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
						            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
						        }
						    },
						    grid: {
						        left: '2%',
						        right: '4%',
						        bottom: '3%',
						        containLabel: true
						    },
						    legend: {
						    	show:true,
						    	left:'18%',
						        data:main_name 
						    },
						    toolbox: {
						        show : false,
						        orient: 'vertical',
						        x: 'right',
						        y: 'center',
						        feature : {
						            mark : {show: true},
						            dataView : {show: true, readOnly: false},
						            magicType : {show: true, type: ['line', 'bar', 'stack', 'tiled']},
						            restore : {show: true},
						            saveAsImage : {show: true}
						        }
						    },
						    calculable : true,
						    xAxis : [
						        {
						            type : 'category',
						            data :time
						        }
						    ],
						    yAxis : [
						        {
						            type : 'value'
						        }
						    ],
						    series : tops
						});
					myChart.hideLoading();	
			}
	         
		
		
		
		
		

function doSearch(){
	var area=$('#area').val();	
	var city=$('#city').val();
	window.location.href='<e:url value="/pages/terminal/market/marketTerminal.jsp"/>?area_no='+area+'&city_no='+city;
	
	} 
	
  







</script>

</head>
<e:style value="resources/themes/base/boncBase@links.css" />
<e:style value="resources/themes/blue/boncBlue.css" />
<body>


	<!-- 查询条件 -->
	<div class="searchbox">
		<span class="spantext">省级</span> <select name="state"
			style="width: 150px;" id="area" onchange="findCity();">
			<option value="qg">全国</option>
			<e:forEach items="${areaL.list}" var="item">
				<option value="${item.AREA_NO }">${item.AREA_NAME }</option>
			</e:forEach>
		</select> <span class="spantext">地市</span> <select name="state"
			style="width: 150px;" id="city"></select> <a
			class="easyui-linkbutton" href="javascript:void(0);"
			onclick="doSearch();">查询</a>
	</div>
	<!-- //查询条件 -->
	<!-- 终端 -->
	<table class="TableTerminal" cellspacing="0" cellpadding="0">
		<colgroup>
			<col width="33%" />
			<col width="33%" />
			<col width="*" />
		</colgroup>
		<tbody>
			<tr>
				<td>
					<!-- 品牌销量echarts:标题写在echarts里 -->
					<div id="pinpai"
						style="width: 435px; height: 350px; padding-left: 0px"></div> <!-- //品牌销量echarts -->
				</td>
				<td>
					<!-- 机型销量echarts:标题写在echarts里 -->
					<div id="jixing"
						style="width: 435px; height: 350px; padding-left: 0px"></div> <!-- //机型销量echarts -->
				</td>
				<td>
					<!-- 价格段echarts:标题写在echarts里 -->
					<div id="price"
						style="width: 435px; height: 350px; padding-left: 0px"></div> <!-- //价格段echarts:标题写在echarts里 -->
				</td>
			</tr>
			<tr>
				<td>
					<!-- 终端制式echarts:标题写在echarts里 -->
					<div id="terminal"
						style="width: 400px; height: 350px; padding-left: 15px"></div> <!-- //终端制式echarts -->
				</td>
				<td>
					<!-- cpu核数echarts:标题写在echarts里 -->
					<div id="cpu"
						style="width: 435px; height: 350px; padding-left: 0px"></div> <!-- //cpu核数echarts -->
				</td>
				<td>
					<!-- 屏幕大小echarts:标题写在echarts里 -->
					<div id="main_size"
						style="width: 435px; height: 350px; padding-left: 0px"></div> <!-- //屏幕大小echarts:标题写在echarts里 -->
				</td>
			</tr>
		</tbody>
	</table>
	<!-- //终端 -->


</body>
</html>
