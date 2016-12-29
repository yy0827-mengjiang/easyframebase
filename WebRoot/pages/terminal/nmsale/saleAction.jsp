 <%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:switch value="${param.eaction}">
	<e:case value="brand">
		<e:q4l var="combo_x">
			SELECT "sum"(CASE WHEN xxx."TERMINAL_NUM" IS NULL THEN '0' ELSE xxx."TERMINAL_NUM" END ),b.c  
			FROM (
			(SELECT   a."TERMINAL_NUM" ,a."BRAND_NO" ccc
			FROM "DM_M_TERM_NM_SALES_OFFICE" a
			WHERE a."MEL_NO"='${param.MEL_NO }' 
				<e:if condition="${param.AREA_NO == null || param.AREA_NO == '' }"  var="select1">
				  	  AND a."ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
				  </e:if>
				  <e:else condition="${select1 }">
				      AND a."AREA_NO" = '${param.AREA_NO }'
					  <e:if condition="${param.CITY_NO != 'qxz' }">
					  	  AND a."CITY_NO" = '${param.CITY_NO }'
					  </e:if>		
					  AND a."ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
				  </e:else>) xxx
				RIGHT  JOIN
					(SELECT 
						B.a c                                   
					FROM
						( 
						SELECT * FROM "DM_M_TERM_NM_SALES_OFFICE"
					WHERE
					    <e:if condition="${param.AREA_NO == null || param.AREA_NO == '' }"  var="select1">
						  	  "ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
						  </e:if>
						  <e:else condition="${select1 }">
						      "AREA_NO" = '${param.AREA_NO }'
							  <e:if condition="${param.CITY_NO != 'qxz' }">
							  	  AND "CITY_NO" = '${param.CITY_NO }'
							  </e:if>		
							  AND "ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
						  </e:else>)	A,
						(SELECT 
							"BRAND_NO" a
						FROM
							"TRMNL_DEVINFO") B
					WHERE A."BRAND_NO" = B.a
					GROUP BY A."BRAND_NO",B.a
					ORDER BY "sum"(A."TERMINAL_NUM") desc
					) b
				ON xxx."ccc"=b.c
				)
				GROUP BY b.c
			</e:q4l>${e:java2json(combo_x.list) }	
	</e:case>
	<e:case value="price">
		<e:q4l var="combo_price">
			SELECT "sum"(CASE WHEN xxx."TERMINAL_NUM" IS NULL THEN '0' ELSE xxx."TERMINAL_NUM" END ),b.c  
			FROM (
			(SELECT   a."TERMINAL_NUM" ,a."PRICE_NO" ccc
			FROM "DM_M_TERM_NM_SALES_OFFICE" a
			WHERE a."MEL_NO"='${param.MEL_NO }' 
				<e:if condition="${param.AREA_NO  == null || param.AREA_NO == '' }"  var="select1">
				  	  AND a."ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
				  </e:if>
				  <e:else condition="${select1 }">
				      AND a."AREA_NO" = '${param.AREA_NO }'
					  <e:if condition="${param.CITY_NO != 'qxz' }">
					  	  AND a."CITY_NO" = '${param.CITY_NO }'
					  </e:if>		
					  AND a."ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
				  </e:else>)) xxx
			RIGHT  JOIN
				(SELECT 
					B.a c，
					B.b d                                   
				FROM
					( 
						SELECT * FROM "DM_M_TERM_NM_SALES_OFFICE"
					WHERE
					   <e:if condition="${param.AREA_NO == null || param.AREA_NO  == '' }"  var="select1">
					  	  "ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
					  </e:if>
					  <e:else condition="${select1 }">
					      "AREA_NO" = '${param.AREA_NO }'<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:switch value="${param.eaction}">
	<e:case value="brand">
		<e:q4l var="combo_x">
			SELECT "sum"(CASE WHEN xxx."TERMINAL_NUM" IS NULL THEN '0' ELSE xxx."TERMINAL_NUM" END ),b.c  
			FROM (
			(SELECT   a."TERMINAL_NUM" ,a."BRAND_NO" ccc
			FROM "DM_M_TERM_NM_SALES_OFFICE" a
			WHERE a."MEL_NO"='${param.MEL_NO }' 
				<e:if condition="${param.AREA_NO == null || param.AREA_NO == '' }"  var="select1">
				  	  AND a."ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
				  </e:if>
				  <e:else condition="${select1 }">
				      AND a."AREA_NO" = '${param.AREA_NO }'
					  <e:if condition="${param.CITY_NO != 'qxz' }">
					  	  AND a."CITY_NO" = '${param.CITY_NO }'
					  </e:if>		
					  AND a."ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
				  </e:else>) xxx
				RIGHT  JOIN
					(SELECT 
						B.a c                                   
					FROM
						( 
						SELECT * FROM "DM_M_TERM_NM_SALES_OFFICE"
					WHERE
					    <e:if condition="${param.AREA_NO == null || param.AREA_NO == '' }"  var="select1">
						  	  "ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
						  </e:if>
						  <e:else condition="${select1 }">
						      "AREA_NO" = '${param.AREA_NO }'
							  <e:if condition="${param.CITY_NO != 'qxz' }">
							  	  AND "CITY_NO" = '${param.CITY_NO }'
							  </e:if>		
							  AND "ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
						  </e:else>)	A,
						(SELECT 
							"BRAND_NO" a
						FROM
							"TRMNL_DEVINFO") B
					WHERE A."BRAND_NO" = B.a
					GROUP BY A."BRAND_NO",B.a
					ORDER BY "sum"(A."TERMINAL_NUM") desc
					LIMIT 10) b
				ON xxx."ccc"=b.c
				)
				GROUP BY b.c
			</e:q4l>${e:java2json(combo_x.list) }	
	</e:case>
	<e:case value="price">
		<e:q4l var="combo_price">
			SELECT "sum"(CASE WHEN xxx."TERMINAL_NUM" IS NULL THEN '0' ELSE xxx."TERMINAL_NUM" END ),b.c  
			FROM (
			(SELECT   a."TERMINAL_NUM" ,a."PRICE_NO" ccc
			FROM "DM_M_TERM_NM_SALES_OFFICE" a
			WHERE a."MEL_NO"='${param.MEL_NO }' 
				<e:if condition="${param.AREA_NO  == null || param.AREA_NO == '' }"  var="select1">
				  	  AND a."ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
				  </e:if>
				  <e:else condition="${select1 }">
				      AND a."AREA_NO" = '${param.AREA_NO }'
					  <e:if condition="${param.CITY_NO != 'qxz' }">
					  	  AND a."CITY_NO" = '${param.CITY_NO }'
					  </e:if>		
					  AND a."ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
				  </e:else>)) xxx
			RIGHT  JOIN
				(SELECT 
					B.a c,
					B.b d                                 
				FROM
					( 
						SELECT * FROM "DM_M_TERM_NM_SALES_OFFICE"
					WHERE
					   <e:if condition="${param.AREA_NO == null || param.AREA_NO  == '' }"  var="select1">
					  	  "ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
					  </e:if>
					  <e:else condition="${select1 }">
					      "AREA_NO" = '${param.AREA_NO }'
						  <e:if condition="${param.CITY_NO != 'qxz' }">
						  	  AND "CITY_NO" = '${param.CITY_NO }'
						  </e:if>		<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:switch value="${param.eaction}">
	<e:case value="brand">
		<e:q4l var="combo_x">
			SELECT "sum"(CASE WHEN xxx."TERMINAL_NUM" IS NULL THEN '0' ELSE xxx."TERMINAL_NUM" END ),b.c  
			FROM (
			(SELECT   a."TERMINAL_NUM" ,a."BRAND_NO" ccc
			FROM "DM_M_TERM_NM_SALES_OFFICE" a
			WHERE a."MEL_NO"='${param.MEL_NO }' 
				<e:if condition="${param.AREA_NO == null || param.AREA_NO == '' }"  var="select1">
				  	  AND a."ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
				  </e:if>
				  <e:else condition="${select1 }">
				      AND a."AREA_NO" = '${param.AREA_NO }'
					  <e:if condition="${param.CITY_NO != 'qxz' }">
					  	  AND a."CITY_NO" = '${param.CITY_NO }'
					  </e:if>		
					  AND a."ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
				  </e:else>) xxx
				RIGHT  JOIN
					(SELECT 
						B.a c                                   
					FROM
						( 
						SELECT * FROM "DM_M_TERM_NM_SALES_OFFICE"
					WHERE
					    <e:if condition="${param.AREA_NO == null || param.AREA_NO == '' }"  var="select1">
						  	  "ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
						  </e:if>
						  <e:else condition="${select1 }">
						      "AREA_NO" = '${param.AREA_NO }'
							  <e:if condition="${param.CITY_NO != 'qxz' }">
							  	  AND "CITY_NO" = '${param.CITY_NO }'
							  </e:if>		
							  AND "ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
						  </e:else>)	A,
						(SELECT 
							"BRAND_NO" a
						FROM
							"TRMNL_DEVINFO") B
					WHERE A."BRAND_NO" = B.a
					GROUP BY A."BRAND_NO",B.a
					ORDER BY "sum"(A."TERMINAL_NUM") desc
					LIMIT 10) b
				ON xxx."ccc"=b.c
				)
				GROUP BY b.c
			</e:q4l>${e:java2json(combo_x.list) }	
	</e:case>
	<e:case value="price">
		<e:q4l var="combo_price">
			SELECT "sum"(CASE WHEN xxx."TERMINAL_NUM" IS NULL THEN '0' ELSE xxx."TERMINAL_NUM" END ),b.c  
			FROM (
			(SELECT   a."TERMINAL_NUM" ,a."PRICE_NO" ccc
			FROM "DM_M_TERM_NM_SALES_OFFICE" a
			WHERE a."MEL_NO"='${param.MEL_NO }' 
				<e:if condition="${param.AREA_NO  == null || param.AREA_NO == '' }"  var="select1">
				  	  AND a."ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
				  </e:if>
				  <e:else condition="${select1 }">
				      AND a."AREA_NO" = '${param.AREA_NO }'
					  <e:if condition="${param.CITY_NO != 'qxz' }">
					  	  AND a."CITY_NO" = '${param.CITY_NO }'
					  </e:if>		
					  AND a."ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
				  </e:else>)) xxx
			RIGHT  JOIN
				(SELECT 
					B.a c,
					B.b d                                 
				FROM
					( 
						SELECT * FROM "DM_M_TERM_NM_SALES_OFFICE"
					WHERE
					   <e:if condition="${param.AREA_NO == null || param.AREA_NO  == '' }"  var="select1">
					  	  "ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
					  </e:if>
					  <e:else condition="${select1 }">
					      "AREA_NO" = '${param.AREA_NO }'
						  <e:if condition="${param.CITY_NO != 'qxz' }">
						  	  AND "CITY_NO" = '${param.CITY_NO }'
						  </e:if>		
						  AND "ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
					  </e:else>)	A,
					(SELECT 
						"PRICE_NO" a,
						"ORD" b
					FROM
						"DIM_PRICES_PERIOD"
					) B
				WHERE A."PRICE_NO" = B.a
				GROUP BY A."PRICE_NO",B.a,B.b
				ORDER BY "sum"(A."TERMINAL_NUM") desc
				LIMIT 10) b
			ON xxx."ccc"=b.c			
			GROUP BY b.c,b.d
			ORDER BY b.d
			
		</e:q4l>${e:java2json(combo_price.list) }
	</e:case>
</e:switch>
						  
						  AND "ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
					  </e:else>)	A,
					(SELECT 
						"PRICE_NO" a,
						"ORD" b
					FROM
						"DIM_PRICES_PERIOD"
					) B
				WHERE A."PRICE_NO" = B.a
				GROUP BY A."PRICE_NO",B.a,B.b
				ORDER BY "sum"(A."TERMINAL_NUM") desc
				LIMIT 10) b
			ON xxx."ccc"=b.c			
			GROUP BY b.c,b.d
			ORDER BY b.d
			
		</e:q4l>${e:java2json(combo_price.list) }
	</e:case>
</e:switch>
					      
						  <e:if condition="${param.CITY_NO != 'qxz' }">
						  	  AND "CITY_NO" = '${param.CITY_NO }'
						  </e:if>		
						  AND "ACCT_MONTH" = to_char(to_date('${param.ACCT_MONTH }','yyyymm'), 'yyyymm')	
					  </e:else>)	A,
					(SELECT 
						"PRICE_NO" a,
						"ORD" b
					FROM
						"DIM_PRICES_PERIOD") B
				WHERE A."PRICE_NO" = B.a
				GROUP BY A."PRICE_NO",B.a,B.b
				ORDER BY "sum"(A."TERMINAL_NUM") desc
				LIMIT 10) b
			ON xxx."ccc"=b.c		
			GROUP BY b.c,b.d
			ORDER BY b.d
		</e:q4l>${e:java2json(combo_price.list) }
	</e:case>
</e:switch>
