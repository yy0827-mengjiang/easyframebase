<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:switch value="${param.eaction}">
<e:case value="1">
<e:q4l var="market1">
(
SELECT '1' istop, a."AREA_NO" area_no , "AREA_NAME" area_name ,SUM("TERMINAL_NUM") num  
FROM public."DM_M_TERM_MARKET_OVERVIEW" a , public."DIM_AREA_NO" b
WHERE a."MODEL_NO" IN (
SELECT "MODEL_NO" model_no 
FROM public."DM_M_TERM_MARKET_OVERVIEW"  WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${param.acct_monthbefore}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.acct_month}','yyyymm'), 'yyyymm')   AND "LINE_TYPE" = '${param.line_type}'
GROUP BY MODEL_NO 
ORDER BY SUM("TERMINAL_NUM") DESC LIMIT 1 
) 
AND a."AREA_NO" = b."AREA_NO"   AND a."LINE_TYPE" = '${param.line_type}' AND "ACCT_MONTH" BETWEEN  to_char(to_date('${param.acct_monthbefore}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.acct_month}','yyyymm'), 'yyyymm')
GROUP BY area_no,area_name
)
UNION ALL
(
SELECT  '2' istop, a."AREA_NO" area_no , "AREA_NAME" area_name ,SUM("TERMINAL_NUM") num 
FROM public."DM_M_TERM_MARKET_OVERVIEW" a , public."DIM_AREA_NO" b
WHERE a."MODEL_NO" IN (
SELECT "MODEL_NO" model_no 
FROM public."DM_M_TERM_MARKET_OVERVIEW"   WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${param.acct_monthbefore}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.acct_month}','yyyymm'), 'yyyymm')   AND "LINE_TYPE" = '${param.line_type}'
GROUP BY MODEL_NO 
ORDER BY SUM("TERMINAL_NUM") DESC LIMIT 1 OFFSET 1
) 
AND a."AREA_NO" = b."AREA_NO"  AND a."LINE_TYPE" = '${param.line_type}'  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${param.acct_monthbefore}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.acct_month}','yyyymm'), 'yyyymm')
GROUP BY area_no,area_name
)
UNION ALL
(
SELECT '3' istop, a."AREA_NO" area_no , "AREA_NAME" area_name ,SUM("TERMINAL_NUM") num 
FROM public."DM_M_TERM_MARKET_OVERVIEW" a , public."DIM_AREA_NO" b
WHERE a."MODEL_NO" IN (
SELECT "MODEL_NO" model_no 
FROM public."DM_M_TERM_MARKET_OVERVIEW"   WHERE "ACCT_MONTH" BETWEEN  to_char(to_date('${param.acct_monthbefore}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.acct_month}','yyyymm'), 'yyyymm')   AND "LINE_TYPE" = '${param.line_type}'
GROUP BY MODEL_NO 
ORDER BY SUM("TERMINAL_NUM") DESC LIMIT 1 OFFSET 2
) 
AND a."AREA_NO" = b."AREA_NO"  AND a."LINE_TYPE" = '${param.line_type}'   AND "ACCT_MONTH" BETWEEN  to_char(to_date('${param.acct_monthbefore}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.acct_month}','yyyymm'), 'yyyymm')
GROUP BY area_no,area_name
)
</e:q4l>${e:java2json(market1.list)}
</e:case>
<e:case value="2">
<e:q4l var="market2">
(
SELECT '1' istop, a."CITY_NO" city_no , "CITY_NAME" city_name ,SUM("TERMINAL_NUM") num  
FROM public."DM_M_TERM_MARKET_OVERVIEW" a , public."DIM_CITY_NO" b
WHERE a."MODEL_NO" IN (
SELECT "MODEL_NO" model_no 
FROM public."DM_M_TERM_MARKET_OVERVIEW" WHERE "AREA_NO" = '${param.area_no}'  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${param.acct_monthbefore}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.acct_month}','yyyymm'), 'yyyymm')   AND "LINE_TYPE" = '${param.line_type}'
GROUP BY MODEL_NO 
ORDER BY SUM("TERMINAL_NUM") DESC LIMIT 1 
) 
AND a."CITY_NO" = b."CITY_NO" AND a."AREA_NO" = '${param.area_no}'   AND a."LINE_TYPE" = '${param.line_type}'   AND "ACCT_MONTH" BETWEEN  to_char(to_date('${param.acct_monthbefore}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.acct_month}','yyyymm'), 'yyyymm')
GROUP BY city_no,city_name
)
UNION ALL
(
SELECT '2' istop, a."CITY_NO" city_no , "CITY_NAME" city_name ,SUM("TERMINAL_NUM") num  
FROM public."DM_M_TERM_MARKET_OVERVIEW" a , public."DIM_CITY_NO" b
WHERE a."MODEL_NO" IN (
SELECT "MODEL_NO" model_no 
FROM public."DM_M_TERM_MARKET_OVERVIEW" WHERE "AREA_NO" = '${param.area_no}'   AND "ACCT_MONTH" BETWEEN  to_char(to_date('${param.acct_monthbefore}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.acct_month}','yyyymm'), 'yyyymm')   AND "LINE_TYPE" = '${param.line_type}'
GROUP BY MODEL_NO 
ORDER BY SUM("TERMINAL_NUM") DESC LIMIT 1  OFFSET 1
) 
AND a."CITY_NO" = b."CITY_NO" AND a."AREA_NO" = '${param.area_no}'   AND a."LINE_TYPE" = '${param.line_type}'   AND "ACCT_MONTH" BETWEEN  to_char(to_date('${param.acct_monthbefore}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.acct_month}','yyyymm'), 'yyyymm')
GROUP BY city_no,city_name
)
UNION ALL
(
SELECT '3' istop, a."CITY_NO" city_no , "CITY_NAME" city_name ,SUM("TERMINAL_NUM") num  
FROM public."DM_M_TERM_MARKET_OVERVIEW" a , public."DIM_CITY_NO" b
WHERE a."MODEL_NO" IN (
SELECT "MODEL_NO" model_no 
FROM public."DM_M_TERM_MARKET_OVERVIEW" WHERE "AREA_NO" = '${param.area_no}'   AND "ACCT_MONTH" BETWEEN  to_char(to_date('${param.acct_monthbefore}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.acct_month}','yyyymm'), 'yyyymm')   AND "LINE_TYPE" = '${param.line_type}'
GROUP BY MODEL_NO 
ORDER BY SUM("TERMINAL_NUM") DESC LIMIT 1  OFFSET 2
) 
AND a."CITY_NO" = b."CITY_NO" AND a."AREA_NO" = '${param.area_no}'    AND a."LINE_TYPE" = '${param.line_type}'   AND "ACCT_MONTH" BETWEEN  to_char(to_date('${param.acct_monthbefore}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.acct_month}','yyyymm'), 'yyyymm')
GROUP BY city_no,city_name
)
</e:q4l>${e:java2json(market2.list)}
</e:case>
</e:switch>