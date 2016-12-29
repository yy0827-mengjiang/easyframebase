<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:switch value="${param.eaction}">
<e:case value="1">
<e:q4l var="change">
(SELECT '1' islev,  SUM(COALESCE("${param.index}",0)) x, COALESCE("ACCT_MONTH","ACCT_MONTH") y
FROM public."DM_M_TERM_MARKET_SALES" a 
WHERE   a."CITY_NO" IN (
	 <e:if condition="${param.area_no!=''&&param.area_no!=null&&param.area_no!='qg' }">
     			 SELECT "CITY_NO"  CITY_NO FROM public."DIM_AREA_LEVEL" b
				 WHERE   "AREA_NO" = '${param.area_no }'  AND
    	 
	 </e:if> 
	 <e:if condition="${param.area_no=='qg' }">
	    SELECT "CITY_NO"  CITY_NO FROM public."DIM_AREA_LEVEL" b
	    WHERE 
	  </e:if>  
"CITY_LEVEL" = '一级'
) AND "ACCT_MONTH" BETWEEN  
to_char(to_date('${param.acct_month}','yyyymm')+INTERVAL '-5' month, 'yyyymm')
AND to_char(to_date('${param.acct_month}','yyyymm'), 'yyyymm') 
GROUP BY y 
ORDER BY y )
UNION  ALL
(SELECT  '2' islev,SUM(COALESCE("${param.index}",0)) x, COALESCE("ACCT_MONTH","ACCT_MONTH") y
FROM public."DM_M_TERM_MARKET_SALES" a 
WHERE   a."CITY_NO" IN (
  <e:if condition="${param.area_no!=''&&param.area_no!=null&&param.area_no!='qg' }">
     			 SELECT "CITY_NO"  CITY_NO FROM public."DIM_AREA_LEVEL" b
				 WHERE   "AREA_NO" = '${param.area_no }' AND
    	
	 </e:if> 
	 <e:if condition="${param.area_no=='qg' }">
	    SELECT "CITY_NO"  CITY_NO FROM public."DIM_AREA_LEVEL" b
	    WHERE 
	  </e:if>  
 "CITY_LEVEL" = '二级'
) AND "ACCT_MONTH" BETWEEN  
to_char(to_date('${param.acct_month}','yyyymm')+INTERVAL '-5' month, 'yyyymm')
AND to_char(to_date('${param.acct_month}','yyyymm'), 'yyyymm') 
GROUP BY y 
ORDER BY y )
UNION ALL
(SELECT '3' islev, SUM(COALESCE("${param.index}",0)) x, COALESCE("ACCT_MONTH","ACCT_MONTH") y
FROM public."DM_M_TERM_MARKET_SALES" a 
WHERE   a."CITY_NO" IN (
 <e:if condition="${param.area_no!=''&&param.area_no!=null&&param.area_no!='qg' }">
     			 SELECT "CITY_NO"  CITY_NO FROM public."DIM_AREA_LEVEL" b
				 WHERE   "AREA_NO" = '${param.area_no }'  AND
    	 
	 </e:if> 
	 <e:if condition="${param.area_no=='qg' }">
	    SELECT "CITY_NO"  CITY_NO FROM public."DIM_AREA_LEVEL" b
	    WHERE 
	  </e:if>  
"CITY_LEVEL" = '三级'
) AND "ACCT_MONTH" BETWEEN  
to_char(to_date('${param.acct_month}','yyyymm')+INTERVAL '-5' month, 'yyyymm')
AND to_char(to_date('${param.acct_month}','yyyymm'), 'yyyymm') 
GROUP BY y 
ORDER BY y )
UNION ALL
(SELECT '4' islev,  SUM(COALESCE("${param.index}",0)) x, COALESCE("ACCT_MONTH","ACCT_MONTH") y
FROM public."DM_M_TERM_MARKET_SALES" a 
WHERE   a."CITY_NO" IN (
	 <e:if condition="${param.area_no!=''&&param.area_no!=null&&param.area_no!='qg' }">
     			 SELECT "CITY_NO"  CITY_NO FROM public."DIM_AREA_LEVEL" b
				 WHERE   "AREA_NO" = '${param.area_no }'  AND
    	 
	 </e:if> 
	 <e:if condition="${param.area_no=='qg' }">
	    SELECT "CITY_NO"  CITY_NO FROM public."DIM_AREA_LEVEL" b
	    WHERE 
	  </e:if>  
 "CITY_LEVEL" = '一级'
) AND "ACCT_MONTH" BETWEEN  
to_char(to_date('${param.acct_month}','yyyymm'), 'yyyymm')
AND to_char(to_date('${param.acct_month}','yyyymm')+INTERVAL '+3' month, 'yyyymm') 
GROUP BY y 
ORDER BY y )
UNION  ALL
(SELECT  '5' islev,SUM(COALESCE("${param.index}",0)) x, COALESCE("ACCT_MONTH","ACCT_MONTH") y
FROM public."DM_M_TERM_MARKET_SALES" a 
WHERE   a."CITY_NO" IN (
  <e:if condition="${param.area_no!=''&&param.area_no!=null&&param.area_no!='qg' }">
     			 SELECT "CITY_NO"  CITY_NO FROM public."DIM_AREA_LEVEL" b
				 WHERE   "AREA_NO" = '${param.area_no }' AND
    	
	 </e:if> 
	 <e:if condition="${param.area_no=='qg' }">
	    SELECT "CITY_NO"  CITY_NO FROM public."DIM_AREA_LEVEL" b
	    WHERE 
	  </e:if>  
 "CITY_LEVEL" = '二级'
) AND "ACCT_MONTH" BETWEEN  
to_char(to_date('${param.acct_month}','yyyymm'), 'yyyymm')
AND to_char(to_date('${param.acct_month}','yyyymm')+INTERVAL '+3' month, 'yyyymm') 
GROUP BY y 
ORDER BY y )
UNION ALL
(SELECT '6' islev, SUM(COALESCE("${param.index}",0)) x, COALESCE("ACCT_MONTH","ACCT_MONTH") y
FROM public."DM_M_TERM_MARKET_SALES" a 
WHERE   a."CITY_NO" IN (
 <e:if condition="${param.area_no!=''&&param.area_no!=null&&param.area_no!='qg' }">
     			 SELECT "CITY_NO"  CITY_NO FROM public."DIM_AREA_LEVEL" b
				 WHERE   "AREA_NO" = '${param.area_no }'  AND
    	
	 </e:if> 
	 <e:if condition="${param.area_no=='qg' }">
	    SELECT "CITY_NO"  CITY_NO FROM public."DIM_AREA_LEVEL" b
	    WHERE 
	  </e:if>  
"CITY_LEVEL" = '三级'
) AND "ACCT_MONTH" BETWEEN  
to_char(to_date('${param.acct_month}','yyyymm'), 'yyyymm')
AND to_char(to_date('${param.acct_month}','yyyymm')+INTERVAL '+3' month, 'yyyymm') 
GROUP BY y 
ORDER BY y )
</e:q4l>${e:java2json(change.list)}
</e:case>
</e:switch>
