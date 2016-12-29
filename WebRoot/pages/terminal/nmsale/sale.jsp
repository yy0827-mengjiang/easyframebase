<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<e:q4l var="areaL">
	SELECT a."AREA_NAME" ,a."AREA_NO" FROM "DIM_AREA_NO" a  WHERE 1=1
			<e:if condition="${sessionScope.UserInfo.AREA_NO != '' && sessionScope.UserInfo.AREA_NO != null && sessionScope.UserInfo.AREA_NO != '-1'}">
				AND a."AREA_NO" = '${sessionScope.UserInfo.AREA_NO }'
			</e:if>	
			AND a."AREA_NAME" != '全国' 
</e:q4l>

<e:set var="area_no">qg</e:set>
<e:if condition="${sessionScope.UserInfo.AREA_NO != '' && sessionScope.UserInfo.AREA_NO != null && sessionScope.UserInfo.AREA_NO != '-1'}">
	<e:set var="area_no">${sessionScope.UserInfo.AREA_NO }</e:set>
</e:if>
<e:if condition="${param.area != '' && param.area != null }">
	<e:set var="area_no">${param.area }</e:set>
</e:if>
<e:set var="city_no">qxz</e:set>
<e:if condition="${sessionScope.UserInfo.CITY_NO != '' && sessionScope.UserInfo.CITY_NO != null && sessionScope.UserInfo.CITY_NO != '-1'}">
	<e:set var="city_no">${sessionScope.UserInfo.CITY_NO }</e:set>
</e:if>
<e:if condition="${param.city != '' && param.city != null }">
	<e:set var="city_no">${param.city }</e:set>
</e:if>

<e:if condition="${param.acct_month != null && param.acct_month ne '' }" var="isNullMonth">
	<e:set var="acct_month">${param.acct_month}</e:set>
</e:if>
<e:else condition="${isNullMonth }">
	<e:set var="acct_month">201608</e:set>
	<e:description><e:set var="acct_month">${e:getDate('yyyyMM')}</e:set></e:description>
</e:else>

<e:if condition="${sessionScope.UserInfo.CITY_NO != '' && sessionScope.UserInfo.CITY_NO != null && sessionScope.UserInfo.CITY_NO != '-1'}">
	<e:q4o var="city">
		select "CITY_NO" city_no,"CITY_NAME" city_name from "DIM_CITY_NO" WHERE "AREA_NO" = '${sessionScope.UserInfo.AREA_NO}'
	</e:q4o>
	<e:q4o var="city1">
		select "CITY_NO" city_no,"CITY_NAME" city_name from "DIM_CITY_NO" WHERE "AREA_NO" = '${sessionScope.UserInfo.AREA_NO}'
		 AND "CITY_NO" = '${sessionScope.UserInfo.CITY_NO}'
	</e:q4o>
</e:if>


<e:q4o var="new_user">
SELECT trim(to_char(sum("TERMINAL_NUM"),'999,999,999D')) a FROM "DM_M_TERM_NM_SALES"
WHERE "USER_TYPE"='1'
	  <e:if condition="${area_no == 'qg' }"  var="select1">
	  	  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
	  </e:if>
	  <e:else condition="${select1 }">
	      AND "AREA_NO" = '${area_no }'
		  <e:if condition="${city_no != 'qxz' }">
		  	  AND "CITY_NO" = '${city_no }'
		  </e:if>		
		  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
	  </e:else>
</e:q4o>
<e:q4o var="old_user">
SELECT trim(to_char(sum("TERMINAL_NUM"),'999,999,999D')) a FROM "DM_M_TERM_NM_SALES"
WHERE "USER_TYPE"='0'
	  <e:if condition="${area_no == 'qg' }"  var="select1">
	  	  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
	  </e:if>
	  <e:else condition="${select1 }">
	      AND "AREA_NO" = '${area_no }'
		  <e:if condition="${city_no != 'qxz' }">
		  	  AND "CITY_NO" = '${city_no }'
		  </e:if>		
		  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
	  </e:else>	
</e:q4o>
<e:description>注册开户时间一致性</e:description>
<e:q4o var="register">
SELECT trim(to_char(sum("TERMINAL_NUM"),'999,999,999D')) a FROM "DM_M_TERM_NM_SALES"
WHERE "ENROLL_TYPE"='1'
		<e:if condition="${area_no == 'qg' }"  var="select1">
	  	  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
	  </e:if>
	  <e:else condition="${select1 }">
	      AND "AREA_NO" = '${area_no }'
		  <e:if condition="${city_no != 'qxz' }">
		  	  AND "CITY_NO" = '${city_no }'
		  </e:if>		
		  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
	  </e:else>
</e:q4o>
<e:description>串码一致性</e:description>
<e:q4o var="IMEI">
SELECT trim(to_char(sum("TERMINAL_NUM"),'999,999,999D')) a FROM "DM_M_TERM_NM_SALES"
WHERE "CODE_TYPE"='1'
		<e:if condition="${area_no == 'qg' }"  var="select1">
	  	  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
	  </e:if>
	  <e:else condition="${select1 }">
	      AND "AREA_NO" = '${area_no }'
		  <e:if condition="${city_no != 'qxz' }">
		  	  AND "CITY_NO" = '${city_no }'
		  </e:if>		
		  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
	  </e:else>
</e:q4o>
<e:description>新终端拉新率</e:description>
<e:q4o var="pullnew">
SELECT 	round(sum(case when "USER_TYPE"='1' then "TERMINAL_NUM" else 0 end)/ sum("TERMINAL_NUM")*100,2) a
FROM "DM_M_TERM_NM_SALES"
WHERE "IS_PULLNEW"='1'
		<e:if condition="${area_no == 'qg' }"  var="select1">
	  	  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
	  </e:if>
	  <e:else condition="${select1 }">
	      AND "AREA_NO" = '${area_no }'
		  <e:if condition="${city_no != 'qxz' }">
		  	  AND "CITY_NO" = '${city_no }'
		  </e:if>		
		  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
	  </e:else>
</e:q4o>

<e:description>ARPU(品牌)</e:description>
<e:q4l var="brand_arpu">
	SELECT
		B.b a,
		ceil(sum(A."USER_NUM"*A."ARPU_NUM")/sum(A."USER_NUM")) b
	FROM
		"DM_M_TERM_NM_SALES_ARPU" A,
		(SELECT DISTINCT
			"BRAND_NO" a,
			"BRAND_NAME" b
		FROM
			"TRMNL_DEVINFO") B
	WHERE A."BRAND_NO" = B."a"
		  <e:if condition="${area_no == 'qg' }"  var="select1">
		  	  AND A."ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
		  </e:if>
		  <e:else condition="${select1 }">
		      AND A."AREA_NO" = '${area_no }'
			  <e:if condition="${city_no != 'qxz' }">
			  	  AND A."CITY_NO" = '${city_no }'
			  </e:if>		
			  AND A."ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
		  </e:else>
	GROUP BY A."BRAND_NO",B.b 
	ORDER BY b desc
	LIMIT 10
</e:q4l>
<e:description>ARPU(价格段)</e:description>
<e:q4l var="price_arpu">
	SELECT 
		B."PRICE_NAME" a,
		ceil(sum(A."USER_NUM"*A."ARPU_NUM")/sum(A."USER_NUM")) b
	FROM 
		"DM_M_TERM_NM_SALES_ARPU" A,
		"DIM_PRICES_PERIOD" B
	WHERE 
		A."PRICE_NO" = B."PRICE_NO"
		<e:if condition="${area_no == 'qg' }"  var="select1">
		  	  AND A."ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
		  </e:if>
		  <e:else condition="${select1 }">
		      AND A."AREA_NO" = '${area_no }'
			  <e:if condition="${city_no != 'qxz' }">
			  	  AND A."CITY_NO" = '${city_no }'
			  </e:if>		
			  AND A."ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
		  </e:else>
	GROUP BY A."PRICE_NO",B."PRICE_NAME",B."ORD"
	ORDER BY B."ORD"
</e:q4l>
<e:description>DOU(品牌)</e:description>
<e:q4l var="brand_dou">
	SELECT
		B.b a,
		ceil(sum(A."USER_NUM"*A."DOU_NUM")/sum(A."USER_NUM")) b
	FROM
		"DM_M_TERM_NM_SALES_DOU" A,
		(SELECT DISTINCT
			"BRAND_NO" a,
			"BRAND_NAME" b
		FROM
			"TRMNL_DEVINFO") B
	WHERE A."BRAND_NO" = B."a"
		  <e:if condition="${area_no == 'qg' }"  var="select1">
		  	  AND A."ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
		  </e:if>
		  <e:else condition="${select1 }">
		      AND A."AREA_NO" = '${area_no }'
			  <e:if condition="${city_no != 'qxz' }">
			  	  AND A."CITY_NO" = '${city_no }'
			  </e:if>		
			  AND A."ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
		  </e:else>
	GROUP BY A."BRAND_NO",B.b 
	ORDER BY b desc
	LIMIT 10	
</e:q4l>
<e:description>DOU(价格段)</e:description>
<e:q4l var="price_dou">
	SELECT 
		B."PRICE_NAME" a,
		ceil(sum(A."USER_NUM"*A."DOU_NUM")/sum(A."USER_NUM")) b
	FROM 
		"DM_M_TERM_NM_SALES_DOU" A,
		"DIM_PRICES_PERIOD" B
	WHERE 
		A."PRICE_NO" = B."PRICE_NO"
		<e:if condition="${area_no == 'qg' }"  var="select1">
		  	  AND A."ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
		  </e:if>
		  <e:else condition="${select1 }">
		      AND A."AREA_NO" = '${area_no }'
			  <e:if condition="${city_no != 'qxz' }">
			  	  AND A."CITY_NO" = '${city_no }'
			  </e:if>		
			  AND A."ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
		  </e:else>
	GROUP BY A."PRICE_NO",B."PRICE_NAME",B."ORD"
	ORDER BY B."ORD"
</e:q4l>
<e:description>MOU(品牌)</e:description>
<e:q4l var="brand_mou">
	SELECT
		B.b a,
		ceil(sum(A."USER_NUM"*A."MOU_NUM")/sum(A."USER_NUM")) b
	FROM
		"DM_M_TERM_NM_SALES_MOU" A,
		(SELECT DISTINCT
			"BRAND_NO" a,
			"BRAND_NAME" b
		FROM
			"TRMNL_DEVINFO") B
	WHERE A."BRAND_NO" = B."a"
		 <e:if condition="${area_no == 'qg' }"  var="select1">
		  	  AND A."ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
		  </e:if>
		  <e:else condition="${select1 }">
		      AND A."AREA_NO" = '${area_no }'
			  <e:if condition="${city_no != 'qxz' }">
			  	  AND A."CITY_NO" = '${city_no }'
			  </e:if>		
			  AND A."ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
		  </e:else>
		  AND A."ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')
	GROUP BY A."BRAND_NO",B.b 
	ORDER BY b desc
	LIMIT 10
</e:q4l>
<e:description>MOU(价格段)</e:description>
<e:q4l var="price_mou">
	SELECT 
		B."PRICE_NAME" a,
		ceil(sum(A."USER_NUM"*A."MOU_NUM")/sum(A."USER_NUM")) b
	FROM 
		"DM_M_TERM_NM_SALES_MOU" A,
		"DIM_PRICES_PERIOD" B
	WHERE 
		A."PRICE_NO" = B."PRICE_NO"
		<e:if condition="${area_no == 'qg' }"  var="select1">
		  	  AND A."ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
		  </e:if>
		  <e:else condition="${select1 }">
		      AND A."AREA_NO" = '${area_no }'
			  <e:if condition="${city_no != 'qxz' }">
			  	  AND A."CITY_NO" = '${city_no }'
			  </e:if>		
			  AND A."ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
		  </e:else>
	GROUP BY A."PRICE_NO",B."PRICE_NAME",B."ORD"
	ORDER BY B."ORD"
</e:q4l>

<e:description>套餐码表</e:description>
<e:q4l var="meal">
SELECT
	"MEAL_NO" meal_no,
	"MEAL_NAME" meal_name
FROM
	"DIM_OFFICE_NO"
WHERE
	"IS_MEAL" = '0'
ORDER BY
	"ORD"
</e:q4l>

<e:description>套餐（品牌）</e:description>
<e:if condition="${e:length(meal.list)>0 }" var="check1">
<e:q4l var="mBrand">
	SELECT Z.a a,
			<e:forEach items="${meal.list }" var="item1">
					Z.b${index} b${index},
			</e:forEach>
			Z.c c
	FROM
		(SELECT
			<e:forEach items="${meal.list }" var="item">
				<e:if condition="${index == 0  }">
					X${index }.a a,
				</e:if>
			</e:forEach>
			<e:forEach items="${meal.list }" var="item1">
					X${index }.b b${index},
			</e:forEach>
			<e:forEach items="${meal.list }" var="item2">
				<e:if condition="${index != e:length(meal.list)-1  }" var="selectif1">
					X${index }.b+
				</e:if>
				<e:else condition="${selectif1 }">
					X${index }.b c
				</e:else>
			</e:forEach>
		FROM
			<e:forEach items="${meal.list }" var="item">
				<e:if condition="${index != e:length(meal.list)-1 }" var="selectif2"> 
					(SELECT 
						A."BRAND_NO" a,
						CASE WHEN "sum"(B."TERMINAL_NUM") IS null THEN 0
						ELSE "sum"(B."TERMINAL_NUM")
						END b
					FROM
						(SELECT DISTINCT
							"BRAND_NO",
							"BRAND_NAME"
						 FROM
							"TRMNL_DEVINFO") A
					LEFT OUTER JOIN
					 (SELECT *
							FROM "DM_M_TERM_NM_SALES_OFFICE"
							WHERE "MEL_NO" = '${item.meal_no }'
								  <e:if condition="${area_no == 'qg' }"  var="select1">
								  	  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
								  </e:if>
								  <e:else condition="${select1 }">
								      AND "AREA_NO" = '${area_no }'
									  <e:if condition="${city_no != 'qxz' }">
									  	  AND "CITY_NO" = '${city_no }'
									  </e:if>		
									  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
								  </e:else>)B ON A."BRAND_NO" = B."BRAND_NO"
					GROUP BY A."BRAND_NO") X${index},
				</e:if>
				<e:else condition="${selectif2 }">
					(SELECT 
						A."BRAND_NO" a,
						CASE WHEN "sum"(B."TERMINAL_NUM") IS null THEN 0
						ELSE "sum"(B."TERMINAL_NUM")
						END b
					FROM
						(SELECT DISTINCT
							"BRAND_NO",
							"BRAND_NAME"
					 	FROM
							"TRMNL_DEVINFO") A
					LEFT OUTER JOIN
					 (SELECT *
							FROM "DM_M_TERM_NM_SALES_OFFICE"
							WHERE "MEL_NO" = '${item.meal_no }'
								  <e:if condition="${area_no == 'qg' }"  var="select1">
								  	  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
								  </e:if>
								  <e:else condition="${select1 }">
								      AND "AREA_NO" = '${area_no }'
									  <e:if condition="${city_no != 'qxz' }">
									  	  AND "CITY_NO" = '${city_no }'
									  </e:if>		
									  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
								  </e:else>)B ON A."BRAND_NO" = B."BRAND_NO"
					GROUP BY A."BRAND_NO") X${index}
				</e:else>
			</e:forEach>
		WHERE
			<e:forEach items="${meal.list }" var="item4">
				<e:if condition="${index >0 && index != e:length(age.list)-1 } ">
					X0.a = X${index}.a and
				</e:if>
				<e:if condition="${index == e:length(meal.list)-1 }">
					X0.a = X${index }.a
				</e:if>
			</e:forEach>
		GROUP BY 
			<e:forEach items="${meal.list }" var="item5">
				<e:if condition="${index == 0  }">
					X${index }.a,
				</e:if>
			</e:forEach>
			<e:forEach items="${meal.list }" var="item7">
				<e:if condition="${index != e:length(meal.list)-1 }" var="selectif11">
					X${index }.b,
				</e:if>
				<e:else condition="${selectif11 }">
					X${index }.b
				</e:else>
			</e:forEach>) Z
	WHERE Z.c != 0
	ORDER BY Z.c DESC
	LIMIT 10	
</e:q4l>
</e:if>
<e:else condition="${check1 }">
	<e:set var="mealIsNull">mealIsNull</e:set>
</e:else>

<e:description>套餐品牌top10</e:description>
<e:if condition="${e:length(mBrand.list)>0}">
	<e:q4l var="brandP">
			SELECT distinct "BRAND_NAME" a,
							"BRAND_NO" b
				FROM "TRMNL_DEVINFO"
				WHERE "BRAND_NO" IN (
					<e:forEach items="${mBrand.list }" var="itema">
						<e:if condition="${index != e:length(mBrand.list)-1 }" var="selectifa">
							  '${itema.a}',
						</e:if>
						<e:else condition="${selectifa}">
								'${itema.a}'
						</e:else>
					</e:forEach>
				)
	</e:q4l>
</e:if>

<e:description>套餐（价格段）</e:description>
<e:if condition="${e:length(meal.list)>0 }" var="check2">
<e:q4l var="mPrice">
	SELECT Z.a a,
			<e:forEach items="${meal.list }" var="item1">
					Z.b${index} b${index},
			</e:forEach>
			Z.c c
	FROM
		(SELECT
			<e:forEach items="${meal.list }" var="item">
				<e:if condition="${index == 0  }">
					X${index }.a a,
				</e:if>
			</e:forEach>
			<e:forEach items="${meal.list }" var="item1">
					X${index }.b b${index},
			</e:forEach>
			<e:forEach items="${meal.list }" var="item2">
				<e:if condition="${index != e:length(meal.list)-1  }" var="selectif1">
					X${index }.b+
				</e:if>
				<e:else condition="${selectif1 }">
					X${index }.b c,
				</e:else>
			</e:forEach> 
			X0.c d
		FROM
			<e:forEach items="${meal.list }" var="item">
				<e:if condition="${index != e:length(meal.list)-1 }" var="selectif2"> 
					(SELECT 
						A."PRICE_NAME" a,
						CASE WHEN "sum"(B."TERMINAL_NUM") IS null THEN 0
						ELSE "sum"(B."TERMINAL_NUM")
						END b,
						A."ORD" c
					FROM
						"DIM_PRICES_PERIOD" A
					LEFT OUTER JOIN
					 (SELECT *
							FROM "DM_M_TERM_NM_SALES_OFFICE"
							WHERE "MEL_NO" = '${item.meal_no }'
								  <e:if condition="${area_no == 'qg' }"  var="select1">
								  	  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
								  </e:if>
								  <e:else condition="${select1 }">
								      AND "AREA_NO" = '${area_no }'
									  <e:if condition="${city_no != 'qxz' }">
									  	  AND "CITY_NO" = '${city_no }'
									  </e:if>		
									  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
								  </e:else>) B ON A."PRICE_NO" = B."PRICE_NO"
					GROUP BY B."PRICE_NO",A."PRICE_NAME",A."ORD") X${index},
				</e:if>
				<e:else condition="${selectif2 }">
					(SELECT 
						A."PRICE_NAME" a,
						CASE WHEN "sum"(B."TERMINAL_NUM") IS null THEN 0
						ELSE "sum"(B."TERMINAL_NUM")
						END b
					FROM
						"DIM_PRICES_PERIOD" A
					LEFT OUTER JOIN
					 (SELECT *
							FROM "DM_M_TERM_NM_SALES_OFFICE"
							WHERE "MEL_NO" = '${item.meal_no }'
								  <e:if condition="${area_no == 'qg' }"  var="select1">
								  	  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
								  </e:if>
								  <e:else condition="${select1 }">
								      AND "AREA_NO" = '${area_no }'
									  <e:if condition="${city_no != 'qxz' }">
									  	  AND "CITY_NO" = '${city_no }'
									  </e:if>		
									  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
								  </e:else>)B ON A."PRICE_NO" = B."PRICE_NO"
					GROUP BY B."PRICE_NO",A."PRICE_NAME") X${index}
				</e:else>
			</e:forEach>
		WHERE
			<e:forEach items="${meal.list }" var="item4">
				<e:if condition="${index >0 && index != e:length(age.list)-1 } ">
					X0.a = X${index}.a and
				</e:if>
				<e:if condition="${index == e:length(meal.list)-1 }">
					X0.a = X${index }.a
				</e:if>
			</e:forEach>
		GROUP BY 
			<e:forEach items="${meal.list }" var="item5">
				<e:if condition="${index == 0  }">
					X${index }.a,
				</e:if>
			</e:forEach>
			<e:forEach items="${meal.list }" var="item15">
					X${index }.b,
			</e:forEach>
			X0.c) Z
	WHERE Z.c != 0
	ORDER BY Z.d	
</e:q4l>
</e:if>
<e:else condition="${check2 }">
	<e:set var="mealIsNull1">mealIsNull</e:set>
</e:else>





<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<head>
<a:base />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<c:resources type="easyui,highchart" style="b" />
<!--声明以IE最高版本浏览器内核或谷歌浏览器内核进行渲染 -->
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<!--声明以360极速模式进行渲染 -->
<meta name=”renderer” content=”webkit” />
<!--系统名称文本 -->
<title>终端指标分析系统－行为</title>
<!-- 系统ICON图标（注:路径为TomCat根目录） -->
<link rel ="Shortcut Icon" href="" />
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
<%-- <e:style value="resources/themes/blue/boncBlue.css"/> --%>

<script language="JavaScript">
        $(function(){ 
        	$(".EntryGroupLine input").bind("hover focus", function() {
	            $(this).parent('.EntryGroupLine').addClass('onFocus');
	            $(this).parent('.EntryGroupLine').parent('.EntryBox').siblings('.EntryBox').find('.EntryGroupLine').removeClass('onFocus')
            });
        })
        
        /* 联动条件查询   */
		//省级地市联动
		$(function() {
			var area = '${sessionScope.UserInfo.AREA_NO}';
			if(area != '' && area != null && area != '-1' ){
		        $('#proH option[value="qg"]').remove();
		    }	
		    $("#proH").val("${area_no}");	
			var city = '${sessionScope.UserInfo.CITY_NO}' ;
			$("#cityH").empty();
			$("#cityH").append("<option value='qxz'>--请选择--</option>");
			var AREA_NO = $("#proH").val();
			if(city != '' && city != null && city != '-1'){
				 $('#cityH option[value="qxz"]').remove();
				 $("#cityH").append("<option value='" + '${city1.city_no}' + "'>" + '${city1.city_name}' + "</option>");
			}else{
				$.post('<e:url value="/pages/terminal/nmexchange/exchangeAction.jsp?eaction=seleCityList"/>',{ qdValue: AREA_NO},function(data){
					var city =eval(data.trim());
		      		for(var i = 0;i<city.length;i++){
		 				$("#cityH").append("<option value='"+city[i].CITY_NO+"'>"+city[i].CITY_NAME+"</option>");
		 			}	
		      		$("#cityH").val("${param.city}");
				});
			} 
		});
        
        //省份、地市级联 操作
		function findCityH(){       	
        	$("#cityH").empty();
    		$("#cityH").append("<option value='qxz'>--请选择--</option>");		
			var AREA_NO = $("#proH").val();
			$.post('<e:url value="/pages/terminal/nmexchange/exchangeAction.jsp?eaction=seleCityList"/>',{ qdValue: AREA_NO},function(data){
				var city =eval(data.trim());
		      	for(var i = 0;i<city.length;i++){
		 			$("#cityH").append("<option value='"+city[i].CITY_NO+"'>"+city[i].CITY_NAME+"</option>");
		 		}
		      	$("#cityH").val("${param.city}");
		    });
		} 
        $(function () {  
            var mydate = new Date();
			var str = "" + mydate.getFullYear() + "-";
			str += (mydate.getMonth() + 1);
			if ('${param.acct_month}' == '') {
				$('#stopH').val('2016-08');//gelei 2016.12.3 需要删掉     
				//$('#stopH').val(str);
			}
			else {
				var varmonth = '${param.acct_month}';
				if (varmonth.length == 5) {
					var month = varmonth.substr(0, 4) + "-0" + varmonth.substr(4);
					$('#stopH').val(month);
				}
				if (varmonth.length == 6) {
					var month = varmonth.substr(0, 4) + "-" + varmonth.substr(4, 5);
					$('#stopH').val(month);
				}
			}
            $('#stopH').datebox({  
         	    editable:false ,
                 onShowPanel: function () {//显示日趋选择对象后再触发弹出月份层的事件，初始化时没有生成月份层  
                     span.trigger('click'); //触发click事件弹出月份层  
                     if (!tds) setTimeout(function () {//延时触发获取月份对象，因为上面的事件触发和对象生成有时间间隔  
                         tds = p.find('div.calendar-menu-month-inner td');  
                         tds.click(function (e) {  
                             e.stopPropagation(); //禁止冒泡执行easyui给月份绑定的事件  
                             var year = /\d{4}/.exec(span.html())[0]//得到年份  
                                     , month = parseInt($(this).attr('abbr'), 10); //月份，这里不需要+1  
                             $('#stopH').datebox('hidePanel')//隐藏日期对象  
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
             var p = $('#stopH').datebox('panel'), //日期选择对象  
                     tds = false, //日期选择对象中月份  
                     span = p.find('span.calendar-text'); //显示月份层的触发控件          
         });
        function doSerch(){
        	var area=$('#proH').val();
    		var city=$('#cityH').val();
        	var acct_month=$('#stopH').datebox('getValue').replace("-", "");        
        	if(acct_month.length==5){
        		 var acct_month =acct_month.substr(0,4)+"0"+acct_month.substr(4);
        	}  
      		window.location.href = '<e:url value="/pages/terminal/nmsale/sale.jsp"/>?area=' + area + '&city=' + city +'&acct_month='+acct_month;	    		
        }

	$(function(){
		var isNull = '${mealIsNull }';
		if(isNull ==  'mealIsNull'){
			$("#brand_combo1").html("暂无数据！");	
		}else{
	 		var objdatamB =jQuery.parseJSON('${e:java2json(mBrand.list)}');	
	 		var brandP =jQuery.parseJSON('${e:java2json(brandP.list)}');
	 		var dataM =jQuery.parseJSON('${e:java2json(meal.list)}');
	 		var mealB = new Array();
	 		if(dataM.length >0){
	 			for(var i=0;i<dataM.length;i++){
	 				mealB.push(dataM[i].meal_name);
	 			}
	 		}
			var nameMB = new Array();
			<e:forEach items="${meal.list}" var="itemM">
				var dataM${index} = new Array();
			</e:forEach>
			
			if(objdatamB.length > 0){
				for(var i=0;i<brandP.length;i++){
					nameMB.push(brandP[i].a);
				}
				for(var i=0;i<objdatamB.length;i++){
					//nameMB.push(objdatamB[i].a);
					<e:forEach items="${meal.list}" var="itemb">	
						dataM${index}.push(objdatamB[i].b${index});
					</e:forEach>		
				}
				
				var dataM=[];
		        <e:forEach items="${meal.list }" var="meals">
				        	dataM.push({	
				        	name: '${meals.meal_name}',			        		
				            type:'bar',
				            barWidth : 30,
				            stack: '品牌',
							data: dataM${index}
				        })			        
			      </e:forEach>
				brand_combo(nameMB,mealB,dataM);
			}else{
				$("#brand_combo1").html("暂无数据！");
			}
		}
 	});
 	
 	function brand_combo(nameMB,mealB,dataM){
 		var myChartMB = echarts.init(document.getElementById('brand_combo'));
 		
 		optionMB = {
		    tooltip : {
		        trigger: 'axis',
		        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
		            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
		        }
		    },
		    legend: {
		        data: mealB,
		    },
		    grid: {
		        left: '3%',
		        right: '4%',
		        bottom: '3%',
		        containLabel: true
		    },
		    xAxis : [
		        {
			         axisLabel: {
				         	interval:0,
				            rotate: 0,
				        },
		            type : 'category',
		            data : nameMB
		        }
		    ],
		    yAxis : [
		        {
		            type : 'value'
		        }
		    ],
		   
		    series : dataM
		};
		// 使用刚指定的配置项和数据显示图表。
       myChartMB.setOption(optionMB); 
 	} 
	
	
	//套餐（价格段）
	$(function(){
		var isNull1 = '${mealIsNull1 }';
		if(isNull1 ==  'mealIsNull'){
			$("#price_combo1").html("暂无数据！");	
		}else{
	 		var objdataMP =jQuery.parseJSON('${e:java2json(mPrice.list)}');
	 		var dataP =jQuery.parseJSON('${e:java2json(meal.list)}');
	 		var mealP = new Array();
	 		if(dataP.length >0){
	 			for(var i=0;i<dataP.length;i++){
	 				mealP.push(dataP[i].meal_name);
	 			}
	 		}
			var nameMP = new Array();
			<e:forEach items="${meal.list}" var="itema">
				var dataP${index} = new Array();
			</e:forEach>
			
			if(objdataMP.length > 0){
				for(var i=0;i<objdataMP.length;i++){
					nameMP.push(objdataMP[i].a);
					<e:forEach items="${meal.list}" var="itemb">	
						dataP${index}.push(objdataMP[i].b${index});
					</e:forEach>		
				}
				
				var dataP=[];
		        <e:forEach items="${meal.list }" var="mealss">
				        	dataP.push({	
				        	name: '${mealss.meal_name}',			        		
				            type:'bar',
				            barWidth : 30,
				            stack: '价格段',
							data: dataP${index}
				        })			        
			      </e:forEach>
				price_combo(nameMP,mealP,dataP);
			}else{
				$("#price_combo1").html("暂无数据！");
			}
		}
 	});
 	
 	function price_combo(nameMP,mealP,dataP){
 		var myChartMP = echarts.init(document.getElementById('price_combo'));
 		
 		optionMP = {
		    tooltip : {
		        trigger: 'axis',
		        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
		            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
		        }
		    },
		    legend: {
		        data: mealP,
		    },
		    grid: {
		        left: '3%',
		        right: '4%',
		        bottom: '3%',
		        containLabel: true
		    },
		    xAxis : [
		        {
		        	axisLabel: {
				         	interval:0,
				            rotate: 0,
				        },
		            type : 'category',
		            data : nameMP
		        }
		    ],
		    yAxis : [
		        {
		            type : 'value'
		        }
		    ],
		   
		    series : dataP
		};
		// 使用刚指定的配置项和数据显示图表。
       myChartMP.setOption(optionMP); 
 	} 
	
</script>
 
</head>
<body>
	<div id="boncEntry">

	<div class=" searcharea" style="width:100%;height:auto;margin-top:15px;">
		<!-- 历史换机 -->
		<div><e:description> title="历史换机"</e:description>
			<!-- 查询条件 -->
			<div class="searchbox">
				<span class="spantext">省级</span>				
					<select name="proH" id="proH" style="width:150px;"  onchange="findCityH();">
						<option value="qg">全国</option>
						<e:forEach items="${areaL.list}" var="item">
								<option value="${item.AREA_NO }">${item.AREA_NAME }</option>
						</e:forEach>
					</select>					
				<span class="spantext">地市</span>
					<select name="cityH"  id="cityH" style="width:150px;"></select>	
				<span class="spantext">月份</span>
				<input id="stopH" style="width:150px;">
				<a href="javascript:doSerch();" class="easyui-linkbutton" data-options="iconCls:'icon-search'" style="width:80px">查询</a>
			</div>
				<!-- //查询条件 -->

				<div class="salearea">
					<table cellpadding="0" cellspacing="0" class="TableMarket">
						<colgroup>
							<col width="12%" />
							<col width="25%" />
							<col width="35%" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<td title="本月新入网用户">新用户</td>
								<td title="本月新入网用户"><span><e:if condition="${new_user.a !='' && new_user.a !=null}" var="newuser">${new_user.a }</e:if><e:else condition="${newuser}">0</e:else>人</span></td>
								<td title="终端首次注册时间和用户开户日期是否同一天">注册时间与开户时间一致数</td>
								<td title="终端首次注册时间和用户开户日期是否同一天"><span><e:if condition="${register.a !='' && register.a !=null}" var="registeruser">${register.a }</e:if><e:else condition="${registeruser}">0</e:else>个</span></td>
							</tr>
							<tr>
								<td title="在网用户排除本月新入网用户">在网用户</td>
								<td title="在网用户排除本月新入网用户"><span><e:if condition="${old_user.a !='' && old_user.a !=null}" var="olduser">${old_user.a }</e:if><e:else condition="${olduser}">0</e:else>人</span></td>
								<td title="终端自注册MEID号和CRM中MEID号是否一致">串码一致数</td>
								<td title="终端自注册MEID号和CRM中MEID号是否一致"><span><e:if condition="${IMEI.a !='' && IMEI.a !=null}" var="IMEIuser">${IMEI.a }</e:if><e:else condition="${IMEIuser}">0</e:else>个</span></td>
							</tr>
						</tbody>
					</table>
					<div class="cycle" style="float:right;margin:0 20% 0 0" title="新终端拉新率=当月新增终端中的新增用户量/新增终端量">
						<p><e:if condition="${pullnew.a !='' && pullnew.a !=null}" var="pullnewuser">${pullnew.a }</e:if><e:else condition="${pullnewuser}">0</e:else>%</p>
						<h3>新终端拉新率</h3>
					</div>
				</div>

				<!-- ARPU -->
				<div class="AdminProduct">
					<div style="float:left;width: 50%;">
						<h2 class="time"><div title="ARPU=当月出账用户出账金额/出账用户量">ARPU-品牌(按品牌终端ARPU值排序，单位：元)</div></h2>
						<!-- echarts图表位置 -->
						<div>
							<e:if condition="${e:length(brand_arpu.list)<=0}" var="select1">
								暂无数据！
						</e:if>
							<e:else condition="${select1 }">
								<c:ncolumnline id="time" width="auto" height="auto"
									yaxis="title:,unit:" b="name:数量  ,type:column"
									showexport="false" dimension="a" items="${brand_arpu.list}"
									title=" " legend="false" dataLabel="true" fontsize="10px" colors="['#9dc6b3']"
									rotation="0" />
							</e:else>
						</div>
						<!-- //echarts图表位置 -->
					</div>
					<div style="float:left;width: 50%;">
						<h2 class="time"><div title="ARPU=当月出账用户出账金额/出账用户量">ARPU-价格段(按价格段排序，单位：元)</div></h2>
						<!-- echarts图表位置 -->
						<div>
							<e:if condition="${e:length(price_arpu.list)<=0}" var="select1">
									暂无数据！
							</e:if>
							<e:else condition="${select1 }">
								<c:ncolumnline id="price" width="auto" height="auto"
									yaxis="title:,unit:" b="name:数量  ,type:column"
									showexport="false" dimension="a" items="${price_arpu.list}" 
									title=" " legend="false" dataLabel="true" fontsize="10px" colors="['#d1917b']"
									rotation="0" />
							</e:else>
						</div>
						<!-- //echarts图表位置 -->
					</div>
				</div>
				<!-- //ARPU -->

				<!-- 套餐 -->
				<div class="AdminProduct">				
					<div style="float:left;width: 50%;">
						<h2 class="time">套餐-品牌(按品牌终端总量排序)</h2>
						<!-- echarts图表位置 -->
						<div id="brand_combo1"><div id="brand_combo" style="width:650px;height:400px;"></div></div>
						<!-- //echarts图表位置 -->
					</div>
					<div style="float:left;width: 50%;">
						<h2 class="time">套餐-价格段(按价格段排序)</h2>
						<!-- echarts图表位置 -->
						<div id="price_combo1"><div id="price_combo" style="width:650px;height:400px;"></div></div>
						<!-- //echarts图表位置 -->
					</div>
				</div>
				<!-- //套餐 -->

				<!-- DOU -->
				<div class="AdminProduct" title="DOU=当月出账用户总流量/出账用户量">					
					<div style="float:left;width: 50%;">
					<h2 class="time">DOU-品牌(按品牌终端DOU值排序，单位：MB)</h2>
						<!-- echarts图表位置 -->
						<div>
							<e:if condition="${e:length(brand_dou.list)<=0}" var="select1">
									暂无数据！
							</e:if>
							<e:else condition="${select1 }">
								<c:ncolumnline id="brand_dou" width="auto" height="auto"
									yaxis="title:,unit:" b="name:数量  ,type:column"
									showexport="false" dimension="a" items="${brand_dou.list}"
									title=" " legend="false" dataLabel="true" fontsize="10px" colors="['#9dc6b3']"
									rotation="0" />
							</e:else>
						</div>
						<!-- //echarts图表位置 -->
					</div>
					<div style="float:left;width: 50%;">
						<h2 class="time">DOU-价格段(按价格段排序，单位：MB)</h2>
						<!-- echarts图表位置 -->
						<div>
							<e:if condition="${e:length(price_dou.list)<=0}" var="select1">
									暂无数据！
							</e:if>
							<e:else condition="${select1 }">
								<c:ncolumnline id="price_dou" width="auto" height="auto"
									yaxis="title:,unit:" b="name:数量  ,type:column"
									showexport="false" dimension="a" items="${price_dou.list}"
									title=" " legend="false" dataLabel="true" fontsize="10px" colors="['#d1917b']"
									rotation="0" />
							</e:else>
						</div>
						<!-- //echarts图表位置 -->
					</div>
				</div>
				<!-- //DOU -->

				<!-- MOU -->
				<div class="AdminProduct" title="MOU=当月出账用户通话总分钟量/出账用户量">
					<div style="float:left;width: 50%;">
						<h2 class="time">MOU-品牌(按品牌终端MOU值排序，单位：分钟)</h2>
						<!-- echarts图表位置 -->
						<div>
							<e:if condition="${e:length(brand_mou.list)<=0}" var="select1">
									暂无数据！
							</e:if>
							<e:else condition="${select1 }">
								<c:ncolumnline id="brand_mou" width="auto" height="auto"
									yaxis="title:,unit:" b="name:数量  ,type:column"
									showexport="false" dimension="a" items="${brand_mou.list}"
									title=" " legend="false" dataLabel="true" fontsize="10px" colors="['#9dc6b3']"
									rotation="0" />
							</e:else>
						</div>
						<!-- //echarts图表位置 -->
					</div>
					<div style="float:left;width: 50%;">
						<h2 class="time">MOU-价格段(按价格段排序，单位：分钟)</h2>
						<!-- echarts图表位置 -->
						<div>
							<e:if condition="${e:length(price_mou.list)<=0}" var="select1">
									暂无数据！
							</e:if>
							<e:else condition="${select1 }">
								<c:ncolumnline id="price_mou" width="auto" height="auto"
									yaxis="title:,unit:" b="name:数量  ,type:column"
									showexport="false" dimension="a" items="${price_mou.list}"
									title=" " legend="false" dataLabel="true" fontsize="10px" colors="['#d1917b']"
									rotation="0" />
							</e:else>
						</div>
						<!-- //echarts图表位置 -->
					</div>
				</div>
				<!-- //MOU -->

			</div>
			<!-- 历史换机 -->
		</div>
	</div>
</body>
</html>

