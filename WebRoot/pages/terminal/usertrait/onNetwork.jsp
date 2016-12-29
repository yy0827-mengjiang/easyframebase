<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<e:q4l var="areaL">
	SELECT a."AREA_NAME" ,a."AREA_NO" FROM "DIM_AREA_NO" a  WHERE 1=1
		<e:if condition="${sessionScope.UserInfo.ADMIN == '2' || sessionScope.UserInfo.ADMIN == '0' }">
			AND a."AREA_NO" = '${sessionScope.UserInfo.AREA_NO }' 
		</e:if> 
		AND a."AREA_NAME" != '全国'
</e:q4l>


<e:set var="area_no">qg</e:set>
<e:if condition="${sessionScope.UserInfo.ADMIN != '1'}">
	<e:set var="area_no">${sessionScope.UserInfo.AREA_NO }</e:set>
</e:if>
<e:if condition="${param.area != '' && param.area != null }">
	<e:set var="area_no">${param.area }</e:set>
</e:if>

<e:set var="city_no">qxz</e:set>
<e:if condition="${param.city != '' && param.city != null }">
	<e:set var="city_no">${param.city }</e:set>
</e:if>

<e:if condition="${param.acct_month != null && param.acct_month ne '' }" var="isNullMonth">
	<e:set var="acct_month">${param.acct_month}</e:set>
</e:if>
<e:else condition="${isNullMonth }">
	<e:set var="acct_month">${e:getDate('yyyyMM')}</e:set>
</e:else>
<e:if condition="${param.acct_monthbefore != null && param.acct_monthbefore ne '' }" var="isNullMonth">
	<e:set var="acct_monthbefore">${param.acct_monthbefore }</e:set>
</e:if>
<e:else condition="${isNullMonth }">
	<e:set var="acct_monthbefore">${e:getDate('yyyyMM')}</e:set>
</e:else>

<e:description>年龄</e:description>
<e:q4l var="age">
	SELECT
		B."AGE_NAME" a,
		"sum"(A."TERMINAL_NUM") b
	FROM
		"DM_M_TERM_USER_MAIN" A,"DIM_AGE_PASSAGE" B
	WHERE 
		A."AGE_NO" = B."AGE_NO" AND "LINE_TYPE" = '2'
		AND A."ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
						   AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
		<e:if condition="${area_no != 'qg' }">
			AND A."AREA_NO" = '${area_no }'
			<e:if condition="${city_no != 'qxz' }">
				AND A."CITY_NO" = '${city_no }'
			</e:if>		
		</e:if>	
	GROUP BY B."AGE_NAME",B."AGE_NO"
	ORDER BY B."AGE_NO"	
</e:q4l>

<e:description>2.套餐TOP5</e:description>
<e:q4l var="meal">
	SELECT
		B."MEAL_NAME" a,
		"sum"(A."TERMINAL_NUM") b
	FROM
		"DM_M_TERM_USER_OFFICE" A,"DIM_OFFICE_NO" B
	WHERE
		A."MEL_NO" = B."MEAL_NO" AND A."LINE_TYPE" = '2' AND B."IS_MEAL" = '0'
		AND A."ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
						   AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
		<e:if condition="${area_no != 'qg' }">
			AND A."AREA_NO" = '${area_no }'
			<e:if condition="${city_no != 'qxz' }">
				AND A."CITY_NO" = '${city_no }'
			</e:if>		
		</e:if>	
	GROUP BY
		B."MEAL_NAME",B."MEAL_NO"
	ORDER BY "sum"(A."TERMINAL_NUM") DESC
	LIMIT 5
</e:q4l>

<e:description>3.ARUP</e:description>
<e:q4l var="arup">
	SELECT 
		B."ARPU_NAME" a,
		"sum"(A."TERMINAL_NUM") b
	FROM 
		"DM_M_TERM_USER_ARPU" A,"DIM_ARPU_NO" B
	WHERE 
		A."LINE_TYPE" = '2'	AND A."ARPU_NO" = B."ARPU_NO"
		AND "ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
						   AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
		<e:if condition="${area_no != 'qg' }">
			AND "AREA_NO" = '${area_no }'
			<e:if condition="${city_no != 'qxz' }">
				AND "CITY_NO" = '${city_no }'
			</e:if>		
		</e:if>	
	GROUP BY 
		B."ARPU_NAME"
	ORDER BY 
		"sum"(A."TERMINAL_NUM") DESC	
</e:q4l>

<e:description>4.内容TOP5</e:description>
<e:q4l var="content">
	SELECT 
		 A.a a,
  		 A.b|| '次' b,
		 round(A.b :: NUMERIC / B.a :: NUMERIC,2)*100 || '%' c
	FROM
		(SELECT 
				B."CONTENT_NAME" a,
				"sum"(A."TERMINAL_NUM") b
				FROM 
				"DM_M_TERM_USER_CONTENT" A,"DIM_CONTENT_NO" B
				WHERE 
				A."CONTENT_NO" = B."CONTENT_NO" AND A."LINE_TYPE" = '2'
				AND A."ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
						   AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
				<e:if condition="${area_no != 'qg' }">
					AND A."AREA_NO" = '${area_no }'
					<e:if condition="${city_no != 'qxz' }">
						AND A."CITY_NO" = '${city_no }'
					</e:if>		
				</e:if>	
				GROUP BY B."CONTENT_NAME"
				) A,
				(SELECT 
				"sum"(A."TERMINAL_NUM") a
				FROM 
				"DM_M_TERM_USER_CONTENT" A,"DIM_CONTENT_NO" B
				WHERE 
				A."CONTENT_NO" = B."CONTENT_NO"
				AND A."LINE_TYPE" = '2'
				AND A."ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
						   AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
				<e:if condition="${area_no != 'qg' }">
					AND A."AREA_NO" = '${area_no }'
					<e:if condition="${city_no != 'qxz' }">
						AND A."CITY_NO" = '${city_no }'
					</e:if>		
				</e:if>) B
	ORDER BY A.b DESC
	LIMIT 5	
</e:q4l>

<e:description>5.总人数</e:description>
<e:q4o var="total2">
	SELECT "sum"("TERMINAL_NUM") a
		 FROM 
				"DM_M_TERM_USER_MAIN"
		 WHERE "LINE_TYPE" = '2'
		 AND "ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
						   AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
		<e:if condition="${area_no != 'qg' }">
			AND "AREA_NO" = '${area_no }'
			<e:if condition="${city_no != 'qxz' }">
				AND "CITY_NO" = '${city_no }'
			</e:if>		
		</e:if>
</e:q4o>
<e:q4o var="totalB22">
	SELECT 
		A.b b,
		round(A.b :: NUMERIC / C.a :: NUMERIC,2)*100 || '%' c	
	FROM 
		(SELECT 
				"SEX" a,
				"sum"("TERMINAL_NUM") b
			FROM 
				"DM_M_TERM_USER_MAIN"
			WHERE 
				"LINE_TYPE" = '2'
				AND "SEX" = '男'
				AND "ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
						   AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
				<e:if condition="${area_no != 'qg' }">
					AND "AREA_NO" = '${area_no }'
					<e:if condition="${city_no != 'qxz' }">
						AND "CITY_NO" = '${city_no }'
					</e:if>		
				</e:if>	
			GROUP BY "SEX"
		) A,		
		(SELECT "sum"("TERMINAL_NUM") a
		 FROM 
				"DM_M_TERM_USER_MAIN"
		 WHERE "LINE_TYPE" = '2'
		 AND "ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
						   AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
		<e:if condition="${area_no != 'qg' }">
			AND "AREA_NO" = '${area_no }'
			<e:if condition="${city_no != 'qxz' }">
				AND "CITY_NO" = '${city_no }'
			</e:if>		
		</e:if>) C
</e:q4o>
<e:q4o var="totalG22">
	SELECT 
		B.b d,
		round(B.b :: NUMERIC / C.a :: NUMERIC,2)*100 || '%' e	
	FROM 
		(SELECT 
				"SEX" a,
				"sum"("TERMINAL_NUM") b
			FROM 
				"DM_M_TERM_USER_MAIN"
			WHERE 
				"LINE_TYPE" = '2'
				AND "SEX" = '女'
				AND "ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
						   AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
				<e:if condition="${area_no != 'qg' }">
					AND "AREA_NO" = '${area_no }'
					<e:if condition="${city_no != 'qxz' }">
						AND "CITY_NO" = '${city_no }'
					</e:if>		
				</e:if>	
			GROUP BY "SEX"
			) B,		
		(SELECT "sum"("TERMINAL_NUM") a
		 FROM 
				"DM_M_TERM_USER_MAIN"
		 WHERE "LINE_TYPE" = '2'
		 AND "ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
						   AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
		<e:if condition="${area_no != 'qg' }">
			AND "AREA_NO" = '${area_no }'
			<e:if condition="${city_no != 'qxz' }">
				AND "CITY_NO" = '${city_no }'
			</e:if>		
		</e:if>) C
</e:q4o>

<e:q4o var="total2">
	SELECT 
		C.a a,
		A.b b,
		round(A.b :: NUMERIC / C.a :: NUMERIC,2)*100 || '%' c,
		B.b d,
		round(B.b :: NUMERIC / C.a :: NUMERIC,2)*100 || '%' e
		
	FROM 
		(SELECT 
				"SEX" a,
				"sum"("TERMINAL_NUM") b
			FROM 
				"DM_M_TERM_USER_MAIN"
			WHERE 
				"LINE_TYPE" = '2'
				AND "SEX" = '男'
				AND "ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
						   AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
				<e:if condition="${area_no != 'qg' }">
					AND "AREA_NO" = '${area_no }'
					<e:if condition="${city_no != 'qxz' }">
						AND "CITY_NO" = '${city_no }'
					</e:if>		
				</e:if>	
			GROUP BY "SEX"
		) A,
		(SELECT 
				"SEX" a,
				"sum"("TERMINAL_NUM") b
			FROM 
				"DM_M_TERM_USER_MAIN"
			WHERE 
				"LINE_TYPE" = '2'
				AND "SEX" = '女'
				AND "ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
						   AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
				<e:if condition="${area_no != 'qg' }">
					AND "AREA_NO" = '${area_no }'
					<e:if condition="${city_no != 'qxz' }">
						AND "CITY_NO" = '${city_no }'
					</e:if>		
				</e:if>	
			GROUP BY "SEX"
			) B,		
		(SELECT "sum"("TERMINAL_NUM") a
		 FROM 
				"DM_M_TERM_USER_MAIN"
		 WHERE "LINE_TYPE" = '2'
		 AND "ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
						   AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
		<e:if condition="${area_no != 'qg' }">
			AND "AREA_NO" = '${area_no }'
			<e:if condition="${city_no != 'qxz' }">
				AND "CITY_NO" = '${city_no }'
			</e:if>		
		</e:if>) C
</e:q4o>

<e:q4l var="totalB2">
	SELECT 
		A."SEX" "name",
		"sum"(A."TERMINAL_NUM") "value"
	FROM 
		"DM_M_TERM_USER_MAIN" A		
	WHERE 
		A."LINE_TYPE" = '2' AND
		A."SEX" = '男'
		AND A."ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
						   AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
		<e:if condition="${area_no != 'qg' }">
			AND A."AREA_NO" = '${area_no }'
			<e:if condition="${city_no != 'qxz' }">
				AND A."CITY_NO" = '${city_no }'
			</e:if>		
		</e:if>
	GROUP BY A."SEX"
	UNION ALL
	SELECT 
		A."SEX" "name",
		"sum"(A."TERMINAL_NUM") "value"
	FROM 
		"DM_M_TERM_USER_MAIN" A		
	WHERE 
		A."LINE_TYPE" = '2' AND
		A."SEX" = '女'
		AND A."ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
						   AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
		<e:if condition="${area_no != 'qg' }">
			AND A."AREA_NO" = '${area_no }'
			<e:if condition="${city_no != 'qxz' }">
				AND A."CITY_NO" = '${city_no }'
			</e:if>		
		</e:if>	
	GROUP BY A."SEX"
</e:q4l>

<e:q4l var="totalG2">
	SELECT 
		A."SEX" "name",
		"sum"(A."TERMINAL_NUM") "value"
	FROM 
		"DM_M_TERM_USER_MAIN" A		
	WHERE 
		A."LINE_TYPE" = '2' AND
		A."SEX" = '女'
		AND A."ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
						   AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
		<e:if condition="${area_no != 'qg' }">
			AND A."AREA_NO" = '${area_no }'
			<e:if condition="${city_no != 'qxz' }">
				AND A."CITY_NO" = '${city_no }'
			</e:if>		
		</e:if>	
	GROUP BY A."SEX"
	UNION ALL
	SELECT 
		A."SEX" "name",
		"sum"(A."TERMINAL_NUM") "value"
	FROM 
		"DM_M_TERM_USER_MAIN" A		
	WHERE 
		A."LINE_TYPE" = '2' AND
		A."SEX" = '男'
		AND A."ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
						   AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
		<e:if condition="${area_no != 'qg' }">
			AND A."AREA_NO" = '${area_no }'
			<e:if condition="${city_no != 'qxz' }">
				AND A."CITY_NO" = '${city_no }'
			</e:if>		
		</e:if>
	GROUP BY A."SEX"
</e:q4l>

<e:description>6.应用TOP5</e:description>
<e:q4l var="app">
	SELECT A.a a,
		   A.b b,
  		   A.c|| '次' c,
		   round(A.c :: NUMERIC / B.a :: NUMERIC,2)*100 || '%' d
	FROM
		(SELECT 
				C."IMG_URL" a,
				B."APP_NAME" b,
				"sum"(A."TERMINAL_NUM") c
				FROM 
				"DM_M_TERM_USER_APP" A,"DIM_APP_NO" B,"DIM_IMG_NO" C
				WHERE 
				A."APP_NO" = B."APP_NO" AND A."IMG_NO" = C."IMG_NO" AND A."IMG_TYPE" = C."IMG_TYPE"
				AND A."LINE_TYPE" = '2'
				AND A."ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
						   AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
				<e:if condition="${area_no != 'qg' }">
					AND A."AREA_NO" = '${area_no }'
					<e:if condition="${city_no != 'qxz' }">
						AND A."CITY_NO" = '${city_no }'
					</e:if>		
				</e:if>	
				GROUP BY B."APP_NAME",C."IMG_URL"
				) A,
				(SELECT 
				"sum"(A."TERMINAL_NUM") a
				FROM 
				"DM_M_TERM_USER_APP" A
				WHERE 
				A."LINE_TYPE" = '2'
				AND A."ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
						   AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
				<e:if condition="${area_no != 'qg' }">
					AND A."AREA_NO" = '${area_no }'
					<e:if condition="${city_no != 'qxz' }">
						AND A."CITY_NO" = '${city_no }'
					</e:if>		
				</e:if>) B
	ORDER BY A.c DESC
	LIMIT 5
</e:q4l>

<e:description>7.品牌忠诚度</e:description>
<e:q4l var="loyalty">
	SELECT
		B."LOYALTY_NAME" a,
		"sum"(A."TERMINAL_NUM") b
	FROM
		"DM_M_TERM_USER_LOYALTY" A,"DIM_LOYALTY_NO" B
	WHERE
		A."LOYALTY_NO" = B."LOYALTY_NO" AND A."LINE_TYPE" = '2'
		AND A."ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
						   AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
		<e:if condition="${area_no != 'qg' }">
			AND A."AREA_NO" = '${area_no }'
			<e:if condition="${city_no != 'qxz' }">
				AND A."CITY_NO" = '${city_no }'
			</e:if>		
		</e:if>	
	GROUP BY
		B."LOYALTY_NAME",B."LOYALTY_NO"
	ORDER BY B."LOYALTY_NO"
</e:q4l>

<e:description>8.用户持有品牌TOP5</e:description>
<e:q4l var="newApp">
		SELECT
		C ."IMG_URL" a,
		D.b b,
		A . a C,
		round(
			A . a :: NUMERIC / B. a :: NUMERIC,
			2
		) * 100 || '%' d
	FROM
		(
			SELECT
				"sum" ("TERMINAL_NUM") A,
				"BRAND_NO" b,
				"IMG_NO" C,
				"IMG_TYPE" d
			FROM
				"DM_M_TERM_USER_BRAND"
			WHERE
				"LINE_TYPE" = '2'
				AND "ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
						   AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
				<e:if condition="${area_no != 'qg' }">
					AND "AREA_NO" = '${area_no }'
					<e:if condition="${city_no != 'qxz' }">
						AND "CITY_NO" = '${city_no }'
					</e:if>		
				</e:if>	
			GROUP BY
				"BRAND_NO",
				"IMG_NO",
				"IMG_TYPE",
				"BRAND_NO"
		) A,
		(
			SELECT
				"sum" ("TERMINAL_NUM") a
			FROM
				"DM_M_TERM_USER_BRAND"
			WHERE
				"LINE_TYPE" = '2'
		) B,
		"DIM_IMG_NO" C,
		(
			SELECT DISTINCT
				"BRAND_NO" a,
				"BRAND_NAME" b
			FROM
				"TRMNL_DEVINFO"
		) D
	WHERE
		A . c = C ."IMG_NO"
	AND A .d = C ."IMG_TYPE"
	AND A .b = D. a
	ORDER BY
		A . a DESC
	LIMIT 5
</e:q4l>

<e:description>9.流量占收比</e:description>
<e:q4l var="liul2">
	SELECT
		"FLOW_NUM" a,
		"sum"("TERMINAL_NUM") b
	FROM
		"DM_M_TERM_USER_FLOW"	
	WHERE "LINE_TYPE" = '2'	
		  AND "ACCT_MONTH" BETWEEN to_char(to_date('${acct_monthbefore}','yyyymm'), 'yyyymm')
						   AND to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
		  <e:if condition="${area_no != 'qg' }">
			  AND "AREA_NO" = '${area_no }'
			  <e:if condition="${city_no != 'qxz' }">
				  AND "CITY_NO" = '${city_no }'
			  </e:if>		
		  </e:if>	
	GROUP BY "FLOW_NUM"
	ORDER BY "FLOW_NUM"			
</e:q4l>

<!DOCTYPE html>
<html>
<head>
<a:base/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

   	<c:resources type="easyui,highchart" style="b"/>
    <!--声明以IE最高版本浏览器内核或谷歌浏览器内核进行渲染 -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <!--声明以360极速模式进行渲染 -->
    <meta name=”renderer” content=”webkit” />
    <!--系统名称文本 -->
    <title>终端指标分析系统－用户特征</title>
    <!-- 系统ICON图标（注:路径为TomCat根目录） -->
    <link rel ="Shortcut Icon" href="" />
<!--EasyUI1.5 Css层叠样式表 -->
    <e:style value="/pages/terminal/resources/component/easyui/themes/metro/easyui.css"/>
    <e:style value="/pages/terminal/resources/component/easyui/themes/icon.css"/>
    <!-- 独立Js脚本 -->
    <script type="text/javascript" src='<e:url value="/pages/terminal/resources/themes/base/js/boncCommon.js"/>'></script>
	<!-- 圆形统计图js -->
	<script type="text/javascript" src='<e:url value="/pages/terminal/resources/themes/base/js/jquery.circliful.min.js"/>'></script>
	<script type="text/javascript" src='<e:url value="/pages/terminal/resources/themes/base/js/echarts.min.js"/>'></script>
   	<script type="text/javascript" src='<e:url value="/pages/terminal/resources/themes/base/js/main.js"/>'></script>
    <!-- 独立Css层叠样式表 -->
	<e:style value="/pages/terminal/resources/themes/base/boncBase@links.css"/>
	<e:style value="resources/themes/base/boncBase@links.css"/>
	<e:style value="resources/themes/blue/boncBlue.css"/>
	
	<style type="text/css">
		#pie1 rect {
   			fill: #f3f8fb !important;
		}
		#meal rect {
   			fill: #f3f8fb !important;
		}
		#meal .highcharts-series>rect{
			fill:#7cb5ec !important
		}
		#arup rect {
   			fill: #f3f8fb !important;
		}
		#arup .highcharts-series>rect{fill:#7cb5ec !important}
		#pie2 rect {
   			fill: #f3f8fb;
		}
       .special ul li:nth-child(4){margin-right: 7px;}
        #myStat{float:left;width:190px;height:200px;}
        .mgimg{position:relative;z-index:200;top:-4px;width:190px;height:200px;background: url("pages/terminal/resources/themes/base/images/boncLayout/bg/nan.gif") no-repeat center}
        #myStat1{float:left;width:190px;height:200px;}
        .myimg{position:relative;z-index:200;width:190px;height:171px;background: url("pages/terminal/resources/themes/base/images/boncLayout/bg/nv.gif") no-repeat center}
    </style>
	

   	<script type="text/javascript">
   	
   	//月份控件
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
		
     
      /* 联动条件查询   */
      //省级地市联动
      $(function(){
	 		if('${sessionScope.UserInfo.ADMIN}'!='1'){
		        $('#area option[value="qg"]').remove();
		    }			
			$("#area").val("${area_no}");
	 		//alert($("#area").val());
			$("#city").empty();
			$("#city").append("<option value='qxz'>--请选择--</option>");
			var AREA_NO = $("#area").val();
			$.post('<e:url value="/pages/terminal/usertrait/userAction.jsp"/>',{ AREA_NO: AREA_NO},function(data){
				var city =jQuery.parseJSON(data.trim());
		      	for(var i = 0;i<city.length;i++){
		 			$("#city").append("<option value='"+city[i].CITY_NO+"'>"+city[i].CITY_NAME+"</option>");
		 		}
		 		$("#city").val("${param.city}");
		    });
      	
      });
      
      //省份、地市级联 操作
		function findCity(){
			$("#city").empty();
			$("#city").append("<option value='qxz'>--请选择--</option>");
			var AREA_NO = $("#area").val();
			$.post('<e:url value="/pages/terminal/usertrait/userAction.jsp"/>',{ AREA_NO: AREA_NO},function(data){
				var city =eval(data.trim());
		      	for(var i = 0;i<city.length;i++){
		 			$("#city").append("<option value='"+city[i].CITY_NO+"'>"+city[i].CITY_NAME+"</option>");
		 		}
		    });
		}
      
     
	//查询按钮
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
			window.location.href = '<e:url value="/pages/terminal/usertrait/onNetwork.jsp"/>?area=' + area + '&city=' + city + '&acct_monthbefore='+acct_monthbefore+'&acct_month='+acct_month;
		}
	}
    </script>
    
    <script type="text/javascript">	
	//总人数饼图男
 	$(function(){	
			var objdata =jQuery.parseJSON('${e:java2json(totalB2.list)}');
			var legendata = new Array();
			var colors = [];
			if(objdata.length > 0){
				if(objdata.length == 1){
					if(objdata[0].name == '女'){
						colors.push('#DEDEDE');
					}else{
						colors.push('#4F94CD');
					}
					newBoy2(legendata,objdata,colors);
				}else{
					colors.push('#4F94CD');
					colors.push('#DEDEDE');
					for(var i=0;i<objdata.length;i++){
						legendata.push(objdata[i].name);
					}
					newBoy2(legendata,objdata,colors);
				}	
			}else{
				$("#tt2").html("");
				$("#tt2").html("暂无数据！");
			}
			
 	});
 	
 	function newBoy2(legendata,seriesdata,colors){
       // 基于准备好的dom，初始化echarts实例
       var myChart1 = echarts.init(document.getElementById('myStat'));

      option1 = {
	       tooltip: {
	        trigger: 'item',
	        formatter: "{a} <br/>{b}: {c} ({d}%)"
	    },
	    color:colors,
	    series: [
	        {
	            name:'访问来源',
	            type:'pie',
	            radius: ['50%', '70%'],
	            avoidLabelOverlap: false,
	            label: {
	                normal: {
	                    show: false,
	                    position: 'center'
	                },
	                emphasis: {
	                    show: true,
	                    textStyle: {
	                        fontSize: '30',
	                        fontWeight: 'bold'
	                    }
	                }
	            },
	            labelLine: {
	                normal: {
	                    show: false
	                }
	            },
	            data:seriesdata
	        }
	    ]
    }; 
       // 使用刚指定的配置项和数据显示图表。
       myChart1.setOption(option1);
 	} 
	</script>
	
	<script type="text/javascript">	
	//总人数饼图女
 	$(function(){	
		var objdata =jQuery.parseJSON('${e:java2json(totalG2.list)}');
		var legendatanv = new Array();
		var colors = [];
		if(objdata.length > 0){
			if(objdata.length == 1){
				if(objdata[0].name == '男'){
					colors.push('#DEDEDE');
				}else{
					colors.push('#FF6EB4');
				}
				newGirl2(legendatanv,objdata,colors);
			}else{
				colors.push('#FF6EB4');
				colors.push('#DEDEDE');
				for(var i=0;i<objdata.length;i++){
					legendatanv.push(objdata[i].name);
				}
				newGirl2(legendatanv,objdata,colors);
			}
		}
		
 	});
 	
 	function newGirl2(legendatanv,seriesdata,colors){
       // 基于准备好的dom，初始化echarts实例
       var myChart1 = echarts.init(document.getElementById('myStat1'));

      option1 = {
	       tooltip: {
	        trigger: 'item',
	        formatter: "{a} <br/>{b}: {c} ({d}%)"
	    },
	    color:colors,
	    series: [
	        {
	            name:'访问来源',
	            type:'pie',
	            radius: ['50%', '70%'],
	            avoidLabelOverlap: false,
	            label: {
	                normal: {
	                    show: false,
	                    position: 'center'
	                },
	                emphasis: {
	                    show: true,
	                    textStyle: {
	                        fontSize: '30',
	                        fontWeight: 'bold'
	                    }
	                }
	            },
	            labelLine: {
	                normal: {
	                    show: false
	                }
	            },
	            data:seriesdata
	        }
	    ]
    }; 
       // 使用刚指定的配置项和数据显示图表。
       myChart1.setOption(option1);
 	}
	</script> 
	
	<script type="text/javascript">	
	//流量占收比面积图
 	$(function(){
 		var objdata2 =jQuery.parseJSON('${e:java2json(liul2.list)}');
		var legendatall2 = new Array();
		var datas2 = new Array();
		if(objdata2.length > 0){
			for(var i=0;i<objdata2.length;i++){
				legendatall2.push(objdata2[i].a);
				datas2.push(objdata2[i].b);
			}
 			ll1(legendatall2,datas2);
		}else{
			$("#charts2").html("暂无数据！");
		}
		
 	});
 	
 	function ll1(legendatall2,datas2){
       // 基于准备好的dom，初始化echarts实例
       var myChart2= echarts.init(document.getElementById('charts2'));

  	  option2 = {
		    tooltip : {
		        trigger: 'axis'
		    },
		    grid: {
		        left: '3%',
		        right: '4%',
		        bottom: '3%',
		        height: '90%',
		        containLabel: true
		    },
		    xAxis : [
		        {
		            type : 'category',
		            boundaryGap : false,
		            data : legendatall2
		        }
		    ],
		    yAxis : [
		        {
		            type : 'value'
		        }
		    ],
		    series : [
		        {
		            name:'流量占收比',
		            type:'line',
		            stack: '总量',
		            areaStyle: {normal: {}},
		            data:datas2
		        }
		    ]
		};
		myChart2.setOption(option2);
 	}
	</script> 

</head>
<body>
<div id="boncEntry">
	<!-- 查询条件 -->
	<div class="searchbox">
		<span class="spantext">省级</span> <select name="state"
			style="width:150px;" id="area" onchange="findCity();">
			<option value="qg">全国</option>
			<e:forEach items="${areaL.list}" var="item">
				<option value="${item.AREA_NO }">${item.AREA_NAME }</option>
			</e:forEach>
		</select> <span class="spantext">地市</span><select name="state"
			style="width:150px;" id="city">
		</select> <span class="spantext">时间</span><input id="acct_monthbefore"
			required="true" /> <span class="spantext">至</span><input
			id="acct_month" required="true" /> 
			<a href="javaScript:void(0);" onclick="doSearch();"class="easyui-linkbutton" data-options="iconCls:'icon-search'" style="width:80px">查询</a>

	</div>
	<!-- //查询条件 -->

	<!-- 用户特征在网 -->
	<div class="userarea">
		<div class="userbox" style="width: 33%;">
			<h2>年龄<span>（单位：岁）</span></h2>
			<!-- charts图表预留位置 -->
			<e:if condition="${e:length(age.list)<=0}" var="select12">
				暂无数据！
			</e:if>
			<e:else condition="${select12 }">
				<c:npie id="pie1" distance="1" 
					backgroundColor="#F3F8FB" borderWidth="0" percentage="false"
					width="450" height="200" title=""  showexport="false"
					b="数量" dimension="a"   items="${age.list}" /> 	
			</e:else>
			<!-- //charts图表预留位置 -->
		</div>
		<div class="userbox" style="width: 33%;">
			<h2>套餐TOP5</h2>
			<!-- charts图表预留位置 -->
			<e:if condition="${e:length(meal.list)<=0}" var="select22">
				暂无数据！
			</e:if>
			<e:else condition="${select22 }">
				<c:ncolumnline id="meal" 
					backgroundColor="#F3F8FB" borderWidth="0"
					width="450" height="200"
			        yaxis="title:,unit:"
			        b = "name:数量  ,type:column" 
			        showexport="false"
			        dimension="a" 
			        items="${meal.list}" title=" " legend = "false" dataLabel = "true"
			        fontsize = "10px" rotation = "0"  
			       />   
			  </e:else>
			<!-- //charts图表预留位置 -->
		</div>
		<div class="userbox" style="width: auto;">
			<h2>ARPU</h2>
			<!-- charts图表预留位置 -->
			<e:if condition="${e:length(arup.list)<=0}" var="select32">
				暂无数据！
			</e:if>
			<e:else condition="${select32 }">
				<c:ncolumnline id="arup" width="450px" height="200px"
			        yaxis="title:,unit:"
			        b = "name:数量  ,type:column" 
			        showexport="false"
			        dimension="a" 
			        items="${arup.list}" title=" " legend = "false" dataLabel = "true"
			        fontsize = "10px" rotation = "0"  
			       /> 
		       </e:else>  
			<!-- //charts图表预留位置 -->
		</div>
	</div>
	<div class="userarea">
		<div class="userbox" style="width: 33%;">
			<h2>内容TOP5</h2>
			<!-- 排行 -->
			<e:if condition="${e:length(content.list)<=0}" var="select42">
				暂无数据！
			</e:if>
			<e:else condition="${select42 }">
				<ul class="ulrank">						
					<e:forEach items="${content.list}" var="item">
						<li>
							<e:if condition="${index } == 0">
								<span class="icon-first">${index+1 }</span>
							</e:if>
							<e:if condition="${index } == 1">
								<span class="icon-second">${index+1 }</span>
							</e:if>
							<e:if condition="${index } == 2">
								<span class="icon-third">${index+1 }</span>
							</e:if>
							<e:if condition="${index } == 3">
								<span class="icon-other">${index+1 }</span>
							</e:if>
							<e:if condition="${index } == 4">
								<span class="icon-other">${index+1 }</span>
							</e:if>
							<div class="txtrank">
								<h3>${item.a}</h3>
								<p>访问量：<span>${item.b}</span></p>
								<p>份额：<span>${item.c}</span></p>
							</div>
						</li>
					</e:forEach>						
				</ul>
			</e:else>
			<!-- 排行 -->
		</div>
		<div class="userbox" style="width: 33%;height:259px;">
			<h2 class="total">总人数<strong>${total2.a }</strong></h2>
			<div id="tt2" style="width: 100%">	
             	<div style="width:400px;height:200px;margin-left: 25px;">  
              		<div style="width:50%;float: left;margin-top: -43px;">
                		<div id="myStat"></div>
                 		<div class="mgimg"></div>
                	 	<p style=" position: relative;z-index: 300; bottom: 86px; width: 97%; text-align: center;font-size: 19px;color: #4F94CD;">
                	 		<e:if condition="${totalB22.b == '' || totalB22.b eq null }" var="selectif1">
		                		0
		                	</e:if>
		                	<e:else condition="${selectif1 }">
			                	${totalB22.b }
		                	</e:else>
                	 	</p>
                 		<p style="position: relative;z-index: 300; bottom: 49px; width: 97%; text-align: center;font-size: 21px;color: #999;">
                 			<e:if condition="${totalB22.c == '' || totalB22.c eq null }" var="selectif2">
		                		0%
		                	</e:if>
		                	<e:else condition="${selectif2 }">
			                	${totalB22.c }
		                	</e:else>
                 		</p>
              		</div>         
	           		<div  style="width:50%;float: left;margin-top: -46px;">
	              		<div id="myStat1"></div>	             
	              		<div class="myimg"></div>
	                	<p style=" position: relative;z-index: 300; bottom: 86px; width: 97%; text-align: center;font-size: 19px;color: #FF6EB4;">
		                	<e:if condition="${totalG22.d == '' || totalG22.d eq null }" var="selectif3">
		                		0
		                	</e:if>
		                	<e:else condition="${selectif3 }">
			                	${totalG22.d }
		                	</e:else>
		                </p>
	                 	<p style="position: relative;z-index: 300; bottom: 49px; width: 97%; text-align: center;font-size: 21px;color: #999;">
		                 	<e:if condition="${totalG22.e == '' || totalG22.e eq null }" var="selectif4">
		                		0%
		                	</e:if>
		                	<e:else condition="${selectif4 }">
			                	${totalG22.e }
		                	</e:else>
						</p>
	           		</div>       
             	</div>
             </div>
		</div>
		<div class="userbox" style="width: 33%;">
			<h2>应用TOP5</h2>
			<!-- 排行 -->
			<e:if condition="${e:length(app.list)<=0}" var="select62">
				暂无数据！
			</e:if>
			<e:else condition="${select62 }">
				<ul class="ulrank">
					<e:forEach items="${app.list}" var="item">
						<li>
							<e:if condition="${index } == 0">
								<span class="icon-first">${index+1 }</span>
							</e:if>
							<e:if condition="${index } == 1">
								<span class="icon-second">${index+1 }</span>
							</e:if>
							<e:if condition="${index } == 2">
								<span class="icon-third">${index+1 }</span>
							</e:if>
							<e:if condition="${index } == 3">
								<span class="icon-other">${index+1 }</span>
							</e:if>
							<e:if condition="${index } == 4">
								<span class="icon-other">${index+1 }</span>
							</e:if>
							<div class="txtrank">
								<h3><img width="36" height="36" src='<e:url value="${item.a }"/>'>${item.b}</h3>
								<p>访问量：<span>${item.c}</span></p>
								<p>份额：<span>${item.d}</span></p>
							</div>
						</li>
					</e:forEach>
				</ul>
			</e:else>
			<!-- 排行 -->
		</div>
	</div>
	<div class="userarea">
		<div class="userbox" style="width: 33%;">
			<h2>品牌忠诚度</h2>
			<!-- charts图表预留位置 -->
			<e:if condition="${e:length(loyalty.list)<=0}" var="select72">
				暂无数据！
			</e:if>
			<e:else condition="${select72 }">
				<div class="charts">
					<c:npie id="pie2" distance="1" percentage="false"
					width="450" height="200" title="" showexport="false" 
					b="数量" dimension="a"   items="${loyalty.list}" />
				</div>
			</e:else>
			<!-- //charts图表预留位置 -->
		</div>
		<div class="userbox special" style="width: 33%;">
			<h2>用户持有品牌TOP5</h2>
			<!-- 排行 -->
			<e:if condition="${e:length(newApp.list)<=0}" var="select82">
				暂无数据！
			</e:if>
			<e:else condition="${select82 }">
				<ul class="ulrank">
					<e:forEach items="${newApp.list}" var="item">
						<li>
							<e:if condition="${index } == 0">
								<span class="icon-first">${index+1 }</span>
							</e:if>
							<e:if condition="${index } == 1">
								<span class="icon-second">${index+1 }</span>
							</e:if>
							<e:if condition="${index } == 2">
								<span class="icon-third">${index+1 }</span>
							</e:if>
							<e:if condition="${index } == 3">
								<span class="icon-other">${index+1 }</span>
							</e:if>
							<e:if condition="${index } == 4">
								<span class="icon-other">${index+1 }</span>
							</e:if>
							<div class="txtrank">
								<h3><img width="36" heigth="36" src='<e:url value="${item.a }"/>'>${item.b}</h3>
								<p>持有量：<span>${item.c}</span></p>
								<p>占比：<span>${item.d}</span></p>
							</div>
						</li>
					</e:forEach>	
				</ul>
			</e:else>
			<!-- 排行 -->
		</div>
		<div class="userbox" style="width: 33%;">
			<h2>流量占收比</h2>
			<!-- charts图表预留位置 -->	
    		<div class="charts" width="450" height="200" id="charts2"></div>	
			<!-- //charts图表预留位置 -->
		</div>
	</div>
	<!-- //用户特征在网 -->
	
</div>

<script type="text/javascript" src='<e:url value="/pages/terminal/resources/themes/base/js/main.js"/>'></script>


</body>
</html>

