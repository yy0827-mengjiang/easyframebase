<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
 
<script type="text/javascript"
	src='<e:url value="/pages/terminal/resources/themes/base/js/echarts.min.js"/>'></script>

<e:description>设置地图参数初始值为全国</e:description>
<e:if condition="${sessionScope.UserInfo.ADMIN == '1'}">
	<e:set var="area_no">qg</e:set>
</e:if>
<e:if condition="${sessionScope.UserInfo.ADMIN != '1'}">
	<e:set var="area_no">${sessionScope.UserInfo.AREA_NO}</e:set>
</e:if>
<e:if condition="${param.area!=''&&param.area!=null }">
	<e:description>页面刷新时判断选择的地图  ，根据页面传的属性选择要加载的地图</e:description>
	<e:set var="area_no">${param.area }</e:set>
</e:if>
<e:q4l var="areaL">
	SELECT a."AREA_NAME" ,a."AREA_NO" FROM "DIM_AREA_NO" a  WHERE 1=1 AND a."AREA_NO" NOT IN ('0000')
	<e:if condition="${sessionScope.UserInfo.ADMIN != '1'}">
		AND a."AREA_NO"='${sessionScope.UserInfo.AREA_NO}'
	</e:if>
</e:q4l>
<e:q4o var="areaName">
		SELECT A."AREA_NAME" FROM "DIM_AREA_NO" A 
	<e:if
		condition="${param.area!=null&&param.area ne ''&&param.area ne 'qg'}">
		WHERE A."AREA_NO"=#area#
	</e:if>
</e:q4o>
<e:if condition="${param.acct_month != null && param.acct_month ne '' }"
	var="isNullMonth">
	<e:set var="acct_month">${param.acct_month}</e:set>
</e:if>
<e:else condition="${isNullMonth }">
	<e:set var="acct_month">${e:getDate('yyyyMM')}</e:set>
</e:else>
<e:if
	condition="${param.acct_monthbefore != null && param.acct_monthbefore ne '' }"
	var="isNullMonth">
	<e:set var="acct_monthbefore">${param.acct_monthbefore }</e:set>
</e:if>
<e:else condition="${isNullMonth }">
	<e:set var="acct_monthbefore">${e:getDate('yyyyMM')}</e:set>
</e:else>
<e:if condition="${param.area != null && param.area ne 'qg' }"
	var="isNullArea">
	<e:set var="area">${param.area}</e:set>
</e:if>
<e:else condition="${isNullArea }">
	<e:set var="area"></e:set>
</e:else>
<e:if condition="${param.city != null && param.city ne 'qxz' }"
	var="isNullCity">
	<e:set var="city">${param.city}</e:set>
</e:if>
<e:else condition="${isNullCity }">
	<e:set var="city"></e:set>
</e:else>
<e:if condition="${area_no!='qg' }">
	<e:q4o var="phonetic">
		<e:description>若选择不是全国，则查出省份所对应的拼音</e:description>
	    SELECT b."AREA_PY"  var  FROM public."DIM_AREA_NO" b
	    WHERE b."AREA_NO" = '${area_no}'	   
	  </e:q4o>
	<e:q4o var="top1">
		<e:description>省份所对应的销量第一名的机型名称</e:description>
		 SELECT "MODEL_NAME" model_name   
	     FROM public."DM_M_TERM_MARKET_OVERVIEW" a ,public."TRMNL_DEVINFO"  b
	     WHERE  a."MODEL_NO" = b."MODEL_NO"  AND a."AREA_NO" = '${area_no}'    AND   a."LINE_TYPE" =  '${param.checkoper}' AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm') AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
	     GROUP BY model_name   ORDER BY SUM("TERMINAL_NUM") DESC LIMIT 1     
	  </e:q4o>
	<e:q4o var="top2">
		<e:description>省份所对应的销量第2名的机型名称</e:description>
		 SELECT "MODEL_NAME" model_name   
	     FROM public."DM_M_TERM_MARKET_OVERVIEW" a ,public."TRMNL_DEVINFO"  b   
	     WHERE  a."MODEL_NO" = b."MODEL_NO"  AND a."AREA_NO" = '${area_no}' AND   a."LINE_TYPE" =  '${param.checkoper}'   AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm') AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
	     GROUP BY model_name   ORDER BY SUM("TERMINAL_NUM") DESC LIMIT 1  OFFSET 1    
	  </e:q4o>
	<e:q4o var="top3">
		<e:description>省份所对应的销量第3名的机型名称</e:description>
		 SELECT "MODEL_NAME" model_name   
	     FROM public."DM_M_TERM_MARKET_OVERVIEW" a ,public."TRMNL_DEVINFO"  b
	     WHERE  a."MODEL_NO" = b."MODEL_NO"  AND a."AREA_NO" = '${area_no}'  AND   a."LINE_TYPE" =  '${param.checkoper}'   AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm') AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
	     GROUP BY model_name   ORDER BY SUM("TERMINAL_NUM") DESC LIMIT 1  OFFSET 2       
	  </e:q4o>
</e:if>
<e:if condition="${area_no=='qg' }">
	<e:description>选择全国</e:description>
	<e:q4o var="phonetic">
	    SELECT  DISTINCT 'china'  var  FROM public."DIM_AREA_NO" 	   
	  </e:q4o>
	<e:q4o var="top1">
		<e:description>全国销量第一的机型名称</e:description>
		 SELECT "MODEL_NAME" model_name   
	     FROM public."DM_M_TERM_MARKET_OVERVIEW" a ,public."TRMNL_DEVINFO"  b
	     WHERE  a."MODEL_NO" = b."MODEL_NO"     AND   a."LINE_TYPE" =  '${param.checkoper}'  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm') AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
	     GROUP BY model_name   ORDER BY SUM("TERMINAL_NUM") DESC LIMIT 1     
	  </e:q4o>
	<e:q4o var="top2">
		<e:description>全国销量第二的机型名称</e:description>
		 SELECT "MODEL_NAME" model_name   
	     FROM public."DM_M_TERM_MARKET_OVERVIEW" a ,public."TRMNL_DEVINFO"  b
	     WHERE  a."MODEL_NO" = b."MODEL_NO"     AND   a."LINE_TYPE" =  '${param.checkoper}'   AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm') AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
	     GROUP BY model_name   ORDER BY SUM("TERMINAL_NUM") DESC LIMIT 1  OFFSET 1    
	  </e:q4o>
	<e:q4o var="top3">
		<e:description>全国销量第三的机型名称</e:description>
		 SELECT "MODEL_NAME" model_name   
	     FROM public."DM_M_TERM_MARKET_OVERVIEW" a ,public."TRMNL_DEVINFO"  b
	     WHERE  a."MODEL_NO" = b."MODEL_NO"     AND   a."LINE_TYPE" =  '${param.checkoper}'   AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm') AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm') 
	     GROUP BY model_name   ORDER BY SUM("TERMINAL_NUM") DESC LIMIT 1  OFFSET 2       
	  </e:q4o>
</e:if>

<e:q4o var="citynum">
SELECT SUM("TERMINAL_NUM")  terminalnum 
FROM public."DM_M_TERM_MARKET_OVERVIEW" 
WHERE "CITY_NO" IN
(
SELECT  distinct "CITY_NO" FROM  public."DIM_AREA_LEVEL" 
WHERE "CITY_LEVEL" = '一级' 
<e:if
		condition="${param.area!=null&&param.area ne ''&&param.area ne 'qg'}">
		AND "AREA_NO"=#area#
</e:if>
) 
<e:if condition="${param.checkoper!=null&&param.checkoper ne ''}">
		AND "LINE_TYPE"=#checkoper#
</e:if>
AND ("ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm'))
</e:q4o>
<e:q4o var="city2num">
	SELECT SUM("TERMINAL_NUM")  terminalnum 
FROM public."DM_M_TERM_MARKET_OVERVIEW" 
WHERE "CITY_NO" IN
(
SELECT  distinct "CITY_NO" FROM  public."DIM_AREA_LEVEL" 
WHERE "CITY_LEVEL" = '二级' 
<e:if
		condition="${param.area!=null&&param.area ne ''&&param.area ne 'qg'}">
		AND "AREA_NO"=#area#
</e:if>
) 
<e:if condition="${param.checkoper!=null&&param.checkoper ne ''}">
		AND "LINE_TYPE"=#checkoper#
</e:if>
AND ("ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm'))
</e:q4o>
<e:q4o var="city3num">
		SELECT SUM("TERMINAL_NUM")  terminalnum 
FROM public."DM_M_TERM_MARKET_OVERVIEW" 
WHERE "CITY_NO" IN
(
SELECT  distinct "CITY_NO" FROM  public."DIM_AREA_LEVEL" 
WHERE "CITY_LEVEL" = '三级' 
<e:if
		condition="${param.area!=null&&param.area ne ''&&param.area ne 'qg'}">
		AND "AREA_NO"=#area#
</e:if>
) 
<e:if condition="${param.checkoper!=null&&param.checkoper ne ''}">
		AND "LINE_TYPE"=#checkoper#
</e:if>
AND ("ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm'))
</e:q4o>
<e:q4l var="city1name">
SELECT "CITY_NAME" cityname
FROM "DIM_AREA_LEVEL"
WHERE "CITY_NO" IN (
SELECT "CITY_NO" FROM "DM_M_TERM_MARKET_OVERVIEW" 
WHERE "LINE_TYPE"=#checkoper#
	<e:if
		condition="${param.area!=null&&param.area ne ''&&param.area ne 'qg'}">
		AND "AREA_NO"=#area#
	</e:if>
	AND ("ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm'))
AND "TERMINAL_NUM" IS NOT NULL  
GROUP BY "CITY_NO"  
ORDER BY SUM("TERMINAL_NUM") DESC
	)
AND "CITY_LEVEL" = '一级'

</e:q4l>
<e:q4l var="city2name">
SELECT "CITY_NAME" cityname
FROM "DIM_AREA_LEVEL"
WHERE "CITY_NO" IN (
SELECT "CITY_NO" FROM "DM_M_TERM_MARKET_OVERVIEW" 
WHERE "LINE_TYPE"=#checkoper#
	<e:if
		condition="${param.area!=null&&param.area ne ''&&param.area ne 'qg'}">
		AND "AREA_NO"=#area#
	</e:if>
	AND ("ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm'))
AND "TERMINAL_NUM" IS NOT NULL  
GROUP BY "CITY_NO"  
ORDER BY SUM("TERMINAL_NUM") DESC
	)
AND "CITY_LEVEL" = '二级'

</e:q4l>
<e:q4l var="city3name">
SELECT "CITY_NAME" cityname
FROM "DIM_AREA_LEVEL"
WHERE "CITY_NO" IN (
SELECT "CITY_NO" FROM "DM_M_TERM_MARKET_OVERVIEW" 
WHERE "LINE_TYPE"=#checkoper#
	<e:if
		condition="${param.area!=null&&param.area ne ''&&param.area ne 'qg'}">
		AND "AREA_NO"=#area#
	</e:if>
	AND ("ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm'))
AND "TERMINAL_NUM" IS NOT NULL  
GROUP BY "CITY_NO"  
ORDER BY SUM("TERMINAL_NUM") DESC
	)
AND "CITY_LEVEL" = '三级'

</e:q4l>
<e:q4l var="contract">	SELECT B.a,B.x FROM(
		(SELECT '合约机' a,l.x
			FROM (SELECT
					SUM (E."TERMINAL_NUM") x
					FROM
						"DM_M_TERM_MARKET_OVERVIEW" E
					WHERE
						E."IS_CONTRACT" = '1'
					AND (
						E."ACCT_MONTH" BETWEEN to_char(
							to_date('${acct_monthbefore}', 'yyyymm'),
							'yyyymm'
						)
						AND to_char(
							to_date('${acct_month}', 'yyyymm'),
							'yyyymm'
						))
				<e:if condition="${param.checkoper!=null&&param.checkoper ne ''}">
					AND E."LINE_TYPE"=#checkoper#
				</e:if>
	<e:if
		condition="${param.area!=null&&param.area ne ''&&param.area ne 'qg'}">
					AND E."AREA_NO"=#area#
				</e:if>
	<e:if
		condition="${param.city!=null&&param.city ne ''&&param.city ne 'qxz'}">
					AND E."CITY_NO"=#city#
				</e:if>) l)
			UNION 
				(SELECT '裸机' a,l.x
				FROM
					(SELECT
							SUM (F."TERMINAL_NUM") x
						FROM
							"DM_M_TERM_MARKET_OVERVIEW" F
						WHERE
							F."IS_CONTRACT" = '0'
						AND (
							F."ACCT_MONTH" BETWEEN to_char(
								to_date('${acct_monthbefore}', 'yyyymm'),
								'yyyymm'
							)
							AND to_char(
								to_date('${acct_month}', 'yyyymm'),
								'yyyymm'
							))
					<e:if condition="${param.checkoper!=null&&param.checkoper ne ''}">
						AND F."LINE_TYPE"=#checkoper#
					</e:if>
	<e:if
		condition="${param.area!=null&&param.area ne ''&&param.area ne 'qg'}">
						AND F."AREA_NO"=#area#
					</e:if>
	<e:if
		condition="${param.city!=null&&param.city ne ''&&param.city ne 'qxz'}">
						AND F."CITY_NO"=#city#
					</e:if>) l))B
</e:q4l>
<e:q4l var="reactive">	SELECT
	round(
		SUM (B."TERMINAL_NUM") :: NUMERIC / (
			SELECT
				SUM (E."TERMINAL_NUM") x
			FROM
				"DM_M_TERM_MARKET_OVERVIEW" E
			WHERE
	E."ACCT_MONTH" BETWEEN to_char(
								to_date('${acct_monthbefore}', 'yyyymm'),
								'yyyymm'
							)
							AND to_char(
								to_date('${acct_month}', 'yyyymm'),
								'yyyymm'
							)
	<e:if condition="${param.checkoper!=null&&param.checkoper ne ''}">
		AND E."LINE_TYPE"=#checkoper#
	</e:if>
	<e:if
		condition="${param.area!=null&&param.area ne ''&&param.area ne 'qg'}">
		AND E."AREA_NO"=#area#
	</e:if>
	<e:if
		condition="${param.city!=null&&param.city ne ''&&param.city ne 'qxz'}">
		AND E."CITY_NO"=#city#
	</e:if>
		) :: NUMERIC,2
	) * 100 reactiveshuliang
	FROM "DM_M_TERM_MARKET_OVERVIEW" B WHERE
		B."ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}', 'yyyymm'),'yyyymm')
	AND to_char(to_date('${acct_month}', 'yyyymm'),'yyyymm')
	<e:if condition="${param.checkoper!=null&&param.checkoper ne ''}">
		AND B."LINE_TYPE"=#checkoper#
	</e:if>
	<e:if
		condition="${param.area!=null&&param.area ne ''&&param.area ne 'qg'}">
		AND B."AREA_NO"=#area#
	</e:if>
	<e:if
		condition="${param.city!=null&&param.city ne ''&&param.city ne 'qxz'}">
		AND B."CITY_NO"=#city#
	</e:if>
		AND B."IS_REACTIVE"='1'
</e:q4l>
<e:q4l var="standard">
		SELECT
			C."STANDARD_NAME" standardname,
			SUM (B."TERMINAL_NUM") y
		FROM
			"DM_M_TERM_MARKET_OVERVIEW" B,
		(select DISTINCT E."STANDARD_NO",E."STANDARD_NAME" from "DIM_TERM_STANDARD" E) C
		where
		B."STANDARD_NO"=C."STANDARD_NO" AND (B."ACCT_MONTH"  BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
		AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm'))
	<e:if condition="${param.checkoper!=null&&param.checkoper ne ''}">
		AND B."LINE_TYPE"=#checkoper#
	</e:if>
	<e:if
		condition="${param.area!=null&&param.area ne ''&&param.area ne 'qg'}">
		AND B."AREA_NO"=#area#
	</e:if>
	<e:if
		condition="${param.city!=null&&param.city ne ''&&param.city ne 'qxz'}">
		AND B."CITY_NO"=#city#
	</e:if>
	GROUP BY C."STANDARD_NAME",B."STANDARD_NO" ORDER BY y DESC
</e:q4l>
<e:q4l var="price">
SELECT    b."PRICE_NAME"   price_name,   SUM("TERMINAL_NUM")  terminal_num
  FROM public."DM_M_TERM_MARKET_OVERVIEW" a ,public."DIM_PRICES_PERIOD" b
  WHERE a."PRICE_NO" = b."PRICE_NO" 
  AND (a."ACCT_MONTH"  BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
		AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm'))
  <e:if condition="${param.checkoper!=null&&param.checkoper ne ''}">
		AND A."LINE_TYPE"=#checkoper#
	</e:if>
	<e:if
		condition="${param.area!=null&&param.area ne ''&&param.area ne 'qg'}">
		AND A."AREA_NO"=#area#
	</e:if>
	<e:if
		condition="${param.city!=null&&param.city ne ''&&param.city ne 'qxz'}">
		AND A."CITY_NO"=#city#
	</e:if>
  GROUP BY price_name 
  ORDER BY terminal_num DESC LIMIT 5

</e:q4l>
<e:q4l var="qitabrandTerminalnum">SELECT
		round((W.z - (SELECT SUM (Q.y) q FROM (SELECT
			SUM (B."TERMINAL_NUM") y,
			B."BRAND_NO"
		FROM
			"DM_M_TERM_MARKET_OVERVIEW" B ,
			(
				SELECT DISTINCT
					E."BRAND_NO"
				FROM
					"TRMNL_DEVINFO" E 
			) C
		WHERE
			B."BRAND_NO" = C ."BRAND_NO"
			AND (B."ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
		AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm'))
		<e:if condition="${param.checkoper!=null&&param.checkoper ne ''}">
			AND B."LINE_TYPE"=#checkoper#
		</e:if>
	<e:if
		condition="${param.area!=null&&param.area ne ''&&param.area ne 'qg'}">
			AND B."AREA_NO"=#area#
		</e:if>
	<e:if
		condition="${param.city!=null&&param.city ne ''&&param.city ne 'qxz'}">
			AND B."CITY_NO"=#city#
		</e:if>GROUP BY B."BRAND_NO" ORDER BY y DESC LIMIT 5) Q )) :: NUMERIC/ W.z :: NUMERIC , 2) * 100 || '%' qitashuliang
		FROM
			(SELECT
				SUM (E."TERMINAL_NUM") z
			FROM
				"DM_M_TERM_MARKET_OVERVIEW" E WHERE E."ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
			AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
		<e:if condition="${param.checkoper!=null&&param.checkoper ne ''}">
			AND E."LINE_TYPE"=#checkoper#
		</e:if>
	<e:if
		condition="${param.area!=null&&param.area ne ''&&param.area ne 'qg'}">
			AND E."AREA_NO"=#area#
		</e:if>
	<e:if
		condition="${param.city!=null&&param.city ne ''&&param.city ne 'qxz'}">
			AND E."CITY_NO"=#city#
		</e:if>) W
</e:q4l>
<e:q4l var="brandTerminalnum">SELECT
		SUM (B."TERMINAL_NUM") y,
		round(
			SUM (B."TERMINAL_NUM") :: NUMERIC / (
				SELECT
					SUM (E."TERMINAL_NUM") x
				FROM
					"DM_M_TERM_MARKET_OVERVIEW" E
					WHERE E."ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm') AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
	<e:if condition="${param.checkoper!=null&&param.checkoper ne ''}">
		AND E."LINE_TYPE"=#checkoper#
	</e:if>
	<e:if
		condition="${param.area!=null&&param.area ne ''&&param.area ne 'qg'}">
		AND E."AREA_NO"=#area#
	</e:if>
	<e:if
		condition="${param.city!=null&&param.city ne ''&&param.city ne 'qxz'}">
		AND E."CITY_NO"=#city#
	</e:if>
			) :: NUMERIC,
			2
		) * 100 || '%' shuLiang,
		B."BRAND_NO",
		C ."BRAND_NAME" brandname
	FROM
		"DM_M_TERM_MARKET_OVERVIEW" B,
		(
			SELECT DISTINCT
				E."BRAND_NO",
				E."BRAND_NAME"
			FROM
				"TRMNL_DEVINFO" E
		) C
	WHERE
		B."BRAND_NO" = C ."BRAND_NO" AND (B."ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
	AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm'))
	<e:if condition="${param.checkoper!=null&&param.checkoper ne ''}">
		AND B."LINE_TYPE"=#checkoper#
	</e:if>
	<e:if
		condition="${param.area!=null&&param.area ne ''&&param.area ne 'qg'}">
		AND B."AREA_NO"=#area#
	</e:if>
	<e:if
		condition="${param.city!=null&&param.city ne ''&&param.city ne 'qxz'}">
		AND B."CITY_NO"=#city#
	</e:if>
		GROUP BY B."BRAND_NO",C."BRAND_NAME" ORDER BY y DESC LIMIT 5
</e:q4l>
<e:q4l var="modleTerminalnum">SELECT
			SUM (B."TERMINAL_NUM") y,
			B."MODEL_NO",
			C ."MODEL_NAME" modelName
		FROM
			"DM_M_TERM_MARKET_OVERVIEW" B,
			(
				SELECT DISTINCT
					E."MODEL_NO",
					E."MODEL_NAME"
				FROM
					"TRMNL_DEVINFO" E
			) C
		WHERE
			B."MODEL_NO" = C ."MODEL_NO"
		AND (B."ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
		AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm'))
		<e:if condition="${param.checkoper!=null&&param.checkoper ne ''}">
			AND B."LINE_TYPE"=#checkoper#
		</e:if>
	<e:if
		condition="${param.area!=null&&param.area ne ''&&param.area ne 'qg'}">
			AND B."AREA_NO"=#area#
		</e:if>
	<e:if
		condition="${param.city!=null&&param.city ne ''&&param.city ne 'qxz'}">
			AND B."CITY_NO"=#city#
		</e:if>
			GROUP BY B."MODEL_NO",C ."MODEL_NAME" ORDER BY y DESC LIMIT 5
</e:q4l>

<e:q4o var="cityName">
		SELECT A."CITY_NAME" FROM "DIM_CITY_NO" A 
	<e:if
		condition="${param.city!=null&&param.city ne ''&&param.city ne 'qxz'}">
		WHERE A."CITY_NO"=#city#
	</e:if>
</e:q4o>
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
<!-- 系统ICON图标（注:路径为TomCat根目录） -->
<link rel="Shortcut Icon" href="" />
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
   		function dataPointClick(){
   			alert('饼图点击事件');
   		}
   		//查询
   		function doSearch(){
			var area=$('#area').val();
			var city=$('#city').val();
	    	var acct_monthbefore= $('#acct_monthbefore').datebox('getValue').replace("-", "");
	    	var acct_month=$('#acct_month').datebox('getValue').replace("-", "");
	    	if(acct_monthbefore.length==5){
	    		   var acct_monthbefore =acct_monthbefore.substr(0,4)+"0"+acct_monthbefore.substr(4);
	    	   }
	    	   if(acct_month.length==5){
	    		   var acct_month =acct_month.substr(0,4)+"0"+acct_month.substr(4);
	    	   }   	  
			if(parseInt(acct_month) < parseInt(acct_monthbefore)){
			alert("开始时间大于结束时间，请重新输入！");
	    	} else if(parseInt(acct_monthbefore) <= parseInt(acct_month)){
			window.location.href='<e:url value="/pages/terminal/market/marketArea.jsp"/>?area='+area+'&city='+city+'&acct_monthbefore='+acct_monthbefore+'&acct_month='+acct_month+'&checkoper='+$('#line_type').val();
	    	} 
	    	
    	}
		//省份、地市级联 操作
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
	 	//在网类型
	 	//新增
		function lineType1(){
			var area=$('#area').val();
			var city=$('#city').val();
	    	var acct_monthbefore= $('#acct_monthbefore').datebox('getValue').replace("-", "");
	    	var acct_month=$('#acct_month').datebox('getValue').replace("-", "");
	  	 	window.location.href='<e:url value="/pages/terminal/market/marketArea.jsp"/>?area='+area+'&city='+city+'&acct_monthbefore='+acct_monthbefore+'&acct_month='+acct_month+'&checkoper='+1;
	  	}
	  	//存网
		function lineType2(){
			var area=$('#area').val();
			var city=$('#city').val();
	    	var acct_monthbefore= $('#acct_monthbefore').datebox('getValue').replace("-", "");
	    	var acct_month=$('#acct_month').datebox('getValue').replace("-", "");
		 	window.location.href='<e:url value="/pages/terminal/market/marketArea.jsp"/>?area='+area+'&city='+city+'&acct_monthbefore='+acct_monthbefore+'&acct_month='+acct_month+'&checkoper='+2;
	
	  	}
	  	//离网
		function lineType3(){
			var area=$('#area').val();
			var city=$('#city').val();
	    	var acct_monthbefore= $('#acct_monthbefore').datebox('getValue').replace("-", "");
	    	var acct_month=$('#acct_month').datebox('getValue').replace("-", "");
	  		window.location.href='<e:url value="/pages/terminal/market/marketArea.jsp"/>?area='+area+'&city='+city+'&acct_monthbefore='+acct_monthbefore+'&acct_month='+acct_month+'&checkoper='+3;
	  	}
	 	$(function(){
	 		
        if('${sessionScope.UserInfo.ADMIN}'!='1'){
        $('#area option[value="qg"]').remove();
        }
	 		$("#area").val("${param.area}");
			$("#city").empty();
			$("#city").append("<option value='qxz'>--请选择--</option>");
			var AREA_NO = $("#area").val();
			$.post('<e:url value="/pages/terminal/common/cityAction.jsp"/>',{ AREA_NO: AREA_NO},function(data){
				var city =eval(data.trim());
		      	for(var i = 0;i<city.length;i++){
		 			$("#city").append("<option value='"+city[i].CITY_NO+"'>"+city[i].CITY_NAME+"</option>");
		 		}
		 		$("#city").val("${param.city}");
		    });

	 		$('#acct_monthbefore').val("$('#acct_monthbefore').datebox('getValue')");
	 		$('#acct_month').val("$('#acct_month').datebox('getValue')");

	       	if('1'=='${param.checkoper}'){
		       $('#newline').attr("class","on");
		  	   $('#online').removeAttr("class");
		  	   $('#outline').removeAttr("class");
		   	}
	  	   	if('2'=='${param.checkoper}'){
		        $('#online').attr("class","on");
		  		$('#outline').removeAttr("class");
		  		$('#newline').removeAttr("class");
		  	}
	  	   	if('3'=='${param.checkoper}'){
		        $('#outline').attr("class","on");
		  		$('#online').removeAttr("class");
		  		$('#newline').removeAttr("class");
		  	}
	        $(".EntryGroupLine input").bind("hover focus", function() {
	            $(this).parent('.EntryGroupLine').addClass('onFocus');
	            $(this).parent('.EntryGroupLine').parent('.EntryBox').siblings('.EntryBox').find('.EntryGroupLine').removeClass('onFocus')
	        });
	        
	    if('${area_no}' == '全国'||'${area_no}' == 'qg' ){
        	//alert('${area_no}');
        	go_map('${param.checkoper}',1,'${acct_monthbefore}','${acct_month}');     //第一个参数是在网类型   ，第二个参数是省份NO   群国默认为1
        	
        }
        if('${area_no}' != '全国'&&'${area_no}' != 'qg' ){
        	//alert("2");
        	
        	go_map('${param.checkoper}','${area_no}','${acct_monthbefore}','${acct_month}');   //第一个参数是在网类型   ，第二个参数是省份NO   群国默认为1
        }
	    });
	     function go_map(line_type,index,acct_monthbefore,acct_month){
	    	 		//alert("line_type"+line_type);
	    	 		//alert(index);
    				var info={}; 	   			
    	   			info.line_type = line_type;
    	   			info.acct_monthbefore = acct_monthbefore;
    	   			info.acct_month = acct_month;
    	 			if(index ==1){
    	 				info.eaction = 1 ;  
    	 				//显示全国地图
    	 				$.post('<e:url value="/pages/terminal/market/marketAction.jsp"/>',info,function(data){	
     						var dataJson=$.parseJSON(data);	
     						var series1=[];
     						var series2=[];
     						var series3=[];
     						for(var a=0;a<dataJson.length;a++){   	
            					if(dataJson[a]["istop"] == 1){						
            						series1.push({
        								name: dataJson[a]["area_name"].replace("省", ""),
            							value:  dataJson[a]["num"]     						   
        				 			});      	      						
            								}   
            					if(dataJson[a]["istop"] == 2){	
            						series2.push({
        								name: dataJson[a]["area_name"].replace("省", ""),
        								value: dataJson[a]["num"]       						   
        				 			});      
     										}  				        																		 
            					if(dataJson[a]["istop"] == 3){	
            						series3.push({
        								name: dataJson[a]["area_name"].replace("省", ""),
        								value:  dataJson[a]["num"]       						   
        				 			});      				        													
            								}   					
            					}
     						map(series1,series2,series3); 						
     						});  					 
    	 			} 	 			
    	 			if(index != 1 ){
    	 				info.eaction = 2 ;    //显示各省份地图
    	 				info.area_no = index;
    	 				//info.start_month= $('#acct_monthbefore').datebox('getValue').replace("-", "");
        		    	//info.stop_month =  $('#acct_month').datebox('getValue').replace("-", "");
    	 				$.post('<e:url value="/pages/terminal/market/marketAction.jsp"/>',info,function(data){	
     						var dataJson=$.parseJSON(data);	
     						var series1=[];
     						var series2=[];
     						var series3=[];
     						for(var a=0;a<dataJson.length;a++){   	
            					if(dataJson[a]["istop"] == 1){						
            						series1.push({
        								name: dataJson[a]["city_name"],
            							value:  dataJson[a]["num"]     						   
        				 			});      	      						
            								}   
            					if(dataJson[a]["istop"] == 2){	
            						series2.push({
        								name: dataJson[a]["city_name"],
            							value: dataJson[a]["num"]       						   
        				 			});      
     										}  				        																		 
            					if(dataJson[a]["istop"] == 3){	
            						series3.push({
        								name: dataJson[a]["city_name"],
            							value:  dataJson[a]["num"]       						   
        				 			});      				        													
            								}   					
            					}
     						map(series1,series2,series3); 						
     						});  					 
    	 			} 								
           }
     function map(a,b,c){		   	    	
		var myChart = echarts.init(document.getElementById('chart_Map'));
 		var name = '${phonetic.var}';
    	$.get('<e:url value="/pages/terminal/market/area_json/${phonetic.var}.json"/>', function (geoJson) {
        echarts.registerMap('${phonetic.var}', geoJson);
        myChart.setOption(option = {
        	    title : {
        	        text: '销量排行榜',
        	        subtext: '',
        	        x:'center'
        	    },
        	    tooltip : {
        	        trigger: 'item',
        	        formatter : function(params) {
						var res = params.name + '<br/>';    //取出要加载的省份
						var myseries = option.series;		//取出series 
						for (var i = 0; i < myseries.length; i++) {  
							res += myseries[i].name;        //取出Top1
							for (var j = 0; j < myseries[i].data.length; j++) {    //  根据top1 data 的长度 循环
								//console.log(myseries[i].data[j].name+"=="+params.name);
								if (myseries[i].data[j].name == params.name) {
									
									res += ' : ' + myseries[i].data[j].value +"<br>";
									
								}
							}
						}
        	                                  return res ; 
        	                         } 
        	    },
        	    legend: {
        	        orient: 'vertical',
        	        x:'left',
        	        show:'false',
        	        data:['${top1.model_name}','${top2.model_name}','${top3.model_name}']
        	    },
        	    visualMap: {
        	        min: 0,
        	        max: 1500,
        	        left: 'left',
        	        top: 'bottom',
        	        text: ['高','低'],           // 文本，默认为数值文本
        	        calculable: true,
        	        color: ['#fcce10', '#e87c25','#c1232b']
        	    },
                toolbox: {
                    show: false,
                    orient: 'vertical',
                    left: 'right',
                    top: 'center',
                    feature: {
                        dataView: {readOnly: false},
                        restore: {},
                        saveAsImage: {}
                    }
                },
        	    series : [
        	        {
        	            name: '${top1.model_name}',
        	            type: 'map',
        	            mapType: '${phonetic.var}',
        	            zoom:1.05,
        	            label: {
        	                normal: {
        	                    show: true
        	                },
        	                emphasis: {
        	                    show: true
        	                }
        	            },
        	            data: a
        	        },
        	        {
        	            name: '${top2.model_name}',
        	            type: 'map',
        	            mapType: '${phonetic.var}',
        	            zoom:1.05,
        	            label: {
        	                normal: {
        	                    show: true
        	                },
        	                emphasis: {
        	                    show: true
        	                }
        	            },
        	            data:   b
        	        },
        	        {
        	            name: '${top3.model_name}',
        	            type: 'map',
        	            mapType: '${phonetic.var}',
        	            zoom:1.05,
        	            label: {
        	                normal: {
        	                    show: true
        	                },
        	                emphasis: {
        	                    show: true
        	                }
        	            },
        	           data:   c
        	        }
        	           ]
        	});
    });  	

}
 		$(function () {
     		var mydate = new Date();
       	    var str = "" + mydate.getFullYear() + "-";
       	    str += (mydate.getMonth()+1);
       	    if('${param.acct_monthbefore}'==''){	
       	    $('#acct_monthbefore').val(str);
       	    }else{
       	    var varmonth='${param.acct_monthbefore}';
       	    if(varmonth.length==5){
       	    var month =varmonth.substr(0,4)+"-0"+varmonth.substr(4);
			$('#acct_monthbefore').val(month);
			}
			if(varmonth.length==6){
       	    var month =varmonth.substr(0,4)+"-"+varmonth.substr(4,5);
			$('#acct_monthbefore').val(month);
			}
			}
            $('#acct_monthbefore').datebox({  
        	    editable:false ,
                onShowPanel: function () {//显示日趋选择对象后再触发弹出月份层的事件，初始化时没有生成月份层  
                    span.trigger('click'); //触发click事件弹出月份层  
                    if (!tds) setTimeout(function () {//延时触发获取月份对象，因为上面的事件触发和对象生成有时间间隔  
                        tds = p.find('div.calendar-menu-month-inner td');  
                        tds.click(function (e) {  
                            e.stopPropagation(); //禁止冒泡执行easyui给月份绑定的事件  
                            var year = /\d{4}/.exec(span.html())[0]//得到年份  
                                    , month = parseInt($(this).attr('abbr'), 10); //月份，这里不需要+1  
                            $('#acct_monthbefore').datebox('hidePanel')//隐藏日期对象  
                                    .datebox('setValue', year + '-' + month); //设置日期的值  
                        });  
                    }, 0)  
                },  
                parser: function (s) {  
                    if (!s) return new Date();  
                    var arr = s.split('-');  
                    return new Date(parseInt(arr[0], 10), parseInt(arr[1], 10) - 1, 1);  
                },  
                formatter: function (d) { return d.getFullYear() + '-' + (d.getMonth()+1);/*getMonth返回的是0开始的，忘记了。。已修正*/ }  
            });  
            var p = $('#acct_monthbefore').datebox('panel'), //日期选择对象  
                    tds = false, //日期选择对象中月份  
                    span = p.find('span.calendar-text'); //显示月份层的触发控件              
        });  

    	$(function () {
    		var mydate = new Date();
       	    var str = "" + mydate.getFullYear() + "-";
       	    str += (mydate.getMonth()+1);
       	 if('${param.acct_monthbefore}'==''){	
       	    $("#acct_month").val(str);
       	 }else{
        	    var varmonth='${param.acct_month}';
           	    if(varmonth.length==5){
           	    var month =varmonth.substr(0,4)+"-0"+varmonth.substr(4);
    			$('#acct_month').val(month);
    			}
    			if(varmonth.length==6){
           	    var month =varmonth.substr(0,4)+"-"+varmonth.substr(4,5);
    			$('#acct_month').val(month);
    			}
    			}  
            $('#acct_month').datebox({  
        	    editable:false ,
                onShowPanel: function () {//显示日趋选择对象后再触发弹出月份层的事件，初始化时没有生成月份层  
                    span.trigger('click'); //触发click事件弹出月份层  
                    if (!tds) setTimeout(function () {//延时触发获取月份对象，因为上面的事件触发和对象生成有时间间隔  
                        tds = p.find('div.calendar-menu-month-inner td');  
                        tds.click(function (e) {  
                            e.stopPropagation(); //禁止冒泡执行easyui给月份绑定的事件  
                            var year = /\d{4}/.exec(span.html())[0]//得到年份  
                                    , month = parseInt($(this).attr('abbr'), 10); //月份，这里不需要+1  
                            $('#acct_month').datebox('hidePanel')//隐藏日期对象  
                                    .datebox('setValue', year + '-' + month); //设置日期的值  
                        });  
                    }, 0)  
                },  
                parser: function (s) {  
                    if (!s) return new Date();  
                    var arr = s.split('-');  
                    return new Date(parseInt(arr[0], 10), parseInt(arr[1], 10) - 1, 1);  
                },  
                formatter: function (d) { return d.getFullYear() + '-' + (d.getMonth()+1);/*getMonth返回的是0开始的，忘记了。。已修正*/ }  
            });  
            var p = $('#acct_month').datebox('panel'), //日期选择对象  
                    tds = false, //日期选择对象中月份  
                    span = p.find('span.calendar-text'); //显示月份层的触发控件              
        });
    	$(function(){

			$($(".tabs li")[1]).click(function(){
                  
				location.href='<e:url value="/pages/terminal/market/marketTerminal.jsp"/>'

			})
						
    })
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
		</select> <span class="spantext">地市</span><select name="state"
			style="width: 150px;" id="city">
		</select> <span class="spantext">时间</span><input id="acct_monthbefore"
			required="true" /> <span class="spantext">至</span><input
			id="acct_month" required="true" /> <a class="easyui-linkbutton"
			href="javascript:void(0);" onclick="doSearch();">查询</a>
	</div>
	<!-- //查询条件 -->
	<!-- 地区 -->
	<div style="overflow: hidden; min-height: 560px;">
		<div class="map-market" style="width: 65%;">
			<span class="span-mapmarket"> <input id="line_type"
				type="hidden" value="${param.checkoper}"> <a
				href="javascript:void(0)" id="newline" class="on"
				onclick="lineType1()">新增</a> <a href="javascript:void(0)"
				id="online" onclick="lineType2()">在网</a> <a
				href="javascript:void(0)" id="outline" onclick="lineType3()">离网</a>
			</span>
			<!-- 地图echarts预留位置 -->
			<div class="charts-market" id="chart_Map"
				style="width: 850px; height: 500px;">
				<!-- <img src='<e:url value="/pages/terminal/resources/themes/base/images/boncLayout/img/img_charts_market.jpg"/>' />   940 601 -->
			</div>
			<!-- //地图echarts预留位置 -->
		</div>
		<div class="marketbox" style="width: 34%;">
			<!-- 数量 -->
			<div class="market" style="width: 50%;">
				<h2>品牌</h2>
				<table cellpadding="0" cellspacing="0"
					class="TableMarket normal numtable">
					<colgroup>
						<col width="15%" />
						<col width="25%" />
						<col width="*" />
					</colgroup>
					<tbody>
						<e:if condition="${e:length(brandTerminalnum.list)>=1}">
							<e:forEach items="${brandTerminalnum.list}" var="item">
								<tr>
									<th><span class="thead0${index+1}">${index+1}</span></th>
									<td>${item.brandName}</td>
									<td><span>${item.shuLiang}</span></td>
								</tr>
							</e:forEach>
						</e:if>	
						<e:if condition="${e:length(brandTerminalnum.list)>=5}">
							<tr>
								<th><span class="thead05">6</span></th>
								<td>其他</td>
								<td><span> <e:forEach
											items="${qitabrandTerminalnum.list}" var="item">${item.qitashuliang}
											</e:forEach>
								</span></td>
							</tr>
						</e:if>							
						<e:if condition="${e:length(brandTerminalnum.list)<1}">
								数据不存在！
								</e:if>
					</tbody>
				</table>
			</div>
			<!-- //数量 -->
			<!-- 机型 -->
			<div class="market" style="width: 49.5%;">
				<h2>机型</h2>
				<table cellpadding="0" cellspacing="0" class="TableMarket">
					<colgroup>
						<col width="15%" />
						<col width="45%" />
						<col width="*" />
					</colgroup>
					<tbody style="table-layout: fixed;">
						<e:if condition="${e:length(modleTerminalnum.list)>0}">
							<e:forEach items="${modleTerminalnum.list}" var="item">
								<tr>
									<th><span class="thead0${index+1}">${index+1}</span></th>
									<td>${item.modelName}</td>
									<td><span>${item.y}</span></td>
								</tr>
							</e:forEach>
						</e:if>
						<e:if condition="${e:length(modleTerminalnum.list)<=0}">
								数据不存在！
								</e:if>
					</tbody>
				</table>
			</div>
			<!-- //机型 -->
			<!-- 终端制式 -->
			<div class="market" style="width: 50%;">
				<h2>终端制式</h2>
				<!-- 终端制式饼图 -->
				<div class="chart" align="center">
					<e:if condition="${e:length(standard.list)>0}">
						<c:npie id="pie1" showexport="false" width="240" height="150"
							title="" y="销量" dimension="standardname" percentage="false"
							tipfmt="0" distance="1" items="${standard.list}" />
					</e:if>
					<e:if condition="${e:length(standard.list)<=0}">
								数据不存在！
								</e:if>
				</div>
				<!-- //终端制式饼图 -->
			</div>
			<!-- //终端制式 -->
			<!-- 价格段 -->
			<div class="market" style="width: 49.5%;">
				<h2>价格段</h2>
				<table cellpadding="0" cellspacing="0" class="TableMarket">
					<colgroup>
						<col width="15%" />
						<col width="50%" />
						<col width="*" />
					</colgroup>
					<tbody>
						<e:if condition="${e:length(price.list)>0}">
							<e:forEach items="${price.list}" var="item">
								<tr>
									<th><span class="thead0${index+1}">${index+1}</span></th>
									<td>${item.price_name}</td>
									<td><span>${item.terminal_num}</span></td>
								</tr>
							</e:forEach>
						</e:if>
						<e:if condition="${e:length(price.list)<=0}">
								数据不存在！
							</e:if>
					</tbody>
				</table>
			</div>
			<!-- //价格段 -->
			<!-- 合约机、裸机占比 -->
			<div class="market" style="width: 50%;">
				<h2>合约机、裸机占比</h2>
				<!-- 合约机裸机饼图 -->
				<e:if condition="${param.checkoper}==1">
					<div class="pricechart">
						<e:if condition="${e:length(contract.list)>0}" var="isfalse">
							<e:if condition="${e:length(contract.list)>0}" var="isfalse">
								<c:npie id="pie2" showexport="false" width="136" height="165"
									unit="" title="" percentage="false" legend="true"
									legendAlign="center" fontsize="1px" x='销量' dimension="a"
									distance="-0.1" colors="['#33ffff','#00ff33']" tipfmt="0"
									items="${contract.list}" />
							</e:if>
							<e:else condition="${isfalse }">
									数据不存在！
									</e:else>
						</e:if>
					</div>
				</e:if>
				<e:if condition="${param.checkoper}!=1">
					<div class="pricechart" align="center">
						<e:if condition="${e:length(contract.list)>0}" var="isfalse">
							<c:npie id="pie2" showexport="false" width="228" height="213"
								unit="" title="" percentage="false" legend="true" x='销量'
								dimension="a" colors="['#33ffff','#00ff33']" tipfmt="0"
								distance="0.1" items="${contract.list}" />
						</e:if>
						<e:else condition="${isfalse }">
									数据不存在！
								</e:else>
					</div>
				</e:if>
				<!-- //合约机裸机饼图 -->
				<!-- 全网拉通新率 -->
				<e:if condition="${param.checkoper}==1">
					<div class="cycle">
						<p>
							<e:if condition="${e:length(reactive.list)>0}" var="isfalse">
								<e:forEach items="${reactive.list}" var="item">
									<e:if
										condition="${item.reactiveshuliang}!=null && ${item.reactiveshuliang}!=''"
										var="isfalse">
													${item.reactiveshuliang}
												</e:if>
									<e:else condition="${isfalse }">
													0
												</e:else>
													% 
											</e:forEach>
								<span></span>     
							</e:if>
						</p>
						<h5>全网通拉新率</h5>
					</div>
				</e:if>
				<!-- //全网拉通新率 -->
			</div>
			<!-- //合约机、裸机占比 -->
			<!-- 三级市场展现 -->
			<div class="market" style="width: 49.5%;">
				<h2>三级市场展现</h2>
				<table cellpadding="0" cellspacing="0" class="TableMarket">
					<colgroup>
						<col width="30%" />
						<col width="25%" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<td>一线城市</td>
							<td><a href="javascript:void(4)" class="easyui-linkbutton"
								onclick="$('#w1').window('open')"><展开></a></td>
							<e:if
								condition="${citynum.terminalnum!=null && citynum.terminalnum ne ''}">
								<td><span>${citynum.terminalnum}</span></td>
							</e:if>
							<e:if
								condition="${citynum.terminalnum==null || citynum.terminalnum eq ''}">
								<td><span>0</span></td>
							</e:if>
						</tr>
						<tr>
							<td>二线城市</td>
							<td><a href="javascript:void(5)" class="easyui-linkbutton"
								onclick="$('#w2').window('open')"><展开></a></td>
							<e:if
								condition="${city2num.terminalnum!=null && city2num.terminalnum ne ''}">
								<td><span>${city2num.terminalnum}</span></td>
							</e:if>
							<e:if
								condition="${city2num.terminalnum==null || city2num.terminalnum eq ''}">
								<td><span>0</span></td>
							</e:if>
						</tr>
						<tr>
							<td>三线城市</td>
							<td><a href="javascript:void(6)" class="easyui-linkbutton"
								onclick="$('#w3').window('open')"><展开></a></td>
							<e:if
								condition="${city3num.terminalnum!=null && city3num.terminalnum ne ''}">
								<td><span>${city3num.terminalnum}</span></td>
							</e:if>
							<e:if
								condition="${city3num.terminalnum==null || city3num.terminalnum eq ''}">
								<td><span>0</span></td>
							</e:if>
						</tr>
					</tbody>
				</table>
				<!-- 一线城市弹窗 -->
				<div id="w1" class="easyui-window" title="一线城市"
					data-options="closed:true, modal:true"
					style="width: 500px; height: 200px; padding: 5px;">
					<div class="easyui-layout" data-options="fit:true">
						<div>
							<e:if condition="${e:length(city1name.list)>0}">
								<e:forEach items="${city1name.list}" var="item">
								${item.cityname}
									</e:forEach>
							</e:if>
							<e:if condition="${e:length(city1name.list)<=0}">	
								没有一线城市！
								</e:if>
						</div>
						<div style="position: absolute; bottom: 0; right: 0;">
							<a href="javascript:void(7)" class="easyui-linkbutton"
								onclick="$('#w1').window('close')">关闭</a>
						</div>
					</div>
				</div>
				<!-- //一线城市弹窗 -->
				<!-- 二线城市弹窗 -->
				<div id="w2" class="easyui-window" title="二线城市"
					data-options="closed:true, modal:true"
					style="width: 500px; height: 200px; padding: 5px;">
					<div class="easyui-layout" data-options="fit:true">
						<div>
							<e:if condition="${e:length(city2name.list)>0}">
								<e:forEach items="${city2name.list}" var="item">
								${item.cityname}
									</e:forEach>
							</e:if>
							<e:if condition="${e:length(city2name.list)<=0}">	
								没有二线城市！
								</e:if>
						</div>
						<div style="position: absolute; bottom: 0; right: 0;">
							<a href="javascript:void(8)" class="easyui-linkbutton"
								onclick="$('#w2').window('close')">关闭</a>
						</div>
					</div>
				</div>
				<!-- //二线城市弹窗 -->
				<!-- 三线城市弹窗 -->
				<div id="w3" class="easyui-window" title="三线城市"
					data-options="closed:true, modal:true"
					style="width: 500px; height: 200px; padding: 5px;">
					<div class="easyui-layout" data-options="fit:true">
						<div>
							<e:if condition="${e:length(city3name.list)>0}">
								<e:forEach items="${city3name.list}" var="item">
								${item.cityname}
									</e:forEach>
							</e:if>
							<e:if condition="${e:length(city3name.list)<=0}">	
								没有三线城市！
								</e:if>
						</div>
						<div style="position: absolute; bottom: 0; right: 0;">
							<a href="javascript:void(9)" class="easyui-linkbutton"
								onclick="$('#w3').window('close')">关闭</a>
						</div>
					</div>
				</div>
				<!-- //三线城市弹窗 -->
			</div>
			<!-- //三级市场展现 -->
		</div>
	</div>
	<!-- //地区 -->




</body>
</html>
