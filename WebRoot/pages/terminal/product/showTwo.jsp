<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4l var="usersComperOneAge">
			select 					
					X."AGE_NO",
					Y."AGE_NAME",
					"sum"(X ."TERMINAL_NUM") a							
				from "DM_M_TERM_USER_MAIN" X,"DIM_AGE_PASSAGE" Y  
				WHERE  1=1
				AND  X."AGE_NO" = Y."AGE_NO"			
				<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
					<e:if condition="${param.pronameY != '全国'}">
						AND X."AREA_NO"='${param.provc_no}'
					</e:if>	
				</e:if>
				<e:else condition="${AllOrCity }">
					AND X."AREA_NO"='${param.provc_no}'
					AND X."CITY_NO"='${param.city_no}'
				</e:else>					
				<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
					and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
				</e:if>								
				and X."BRAND_NO"='${param.br1}'
				and X."MODEL_NO"='${param.brxh1}'							
				GROUP BY  X ."AGE_NO",Y."AGE_NAME"			 
</e:q4l>
<e:q4l var="usersComperTwoAge">
			select 					
					X."AGE_NO",
					Y."AGE_NAME",
					"sum"(X ."TERMINAL_NUM") a							
				from "DM_M_TERM_USER_MAIN" X,"DIM_AGE_PASSAGE" Y  
				WHERE  1=1
				AND  X."AGE_NO" = Y."AGE_NO"			
				<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
					<e:if condition="${param.pronameY != '全国'}">
						AND X."AREA_NO"='${param.provc_no}'
					</e:if>	
				</e:if>
				<e:else condition="${AllOrCity }">
					AND X."AREA_NO"='${param.provc_no}'
					AND X."CITY_NO"='${param.city_no}'
				</e:else>					
				<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
					and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
				</e:if>								
				and X."BRAND_NO"='${param.br2}'
				and X."MODEL_NO"='${param.brxh2}'							
				GROUP BY  X ."AGE_NO",Y."AGE_NAME"			 
</e:q4l>
<e:q4l var="usersComperOneSex">
			select 					
					 X."SEX",
					"sum"(X ."TERMINAL_NUM") a							
				from "DM_M_TERM_USER_MAIN" X 
				WHERE  1=1						
				<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
					<e:if condition="${param.pronameY != '全国'}">
						AND X."AREA_NO"='${param.provc_no}'
					</e:if>	
				</e:if>
				<e:else condition="${AllOrCity }">
					AND X."AREA_NO"='${param.provc_no}'
					AND X."CITY_NO"='${param.city_no}'
				</e:else>					
				<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
					and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
				</e:if>								
				and X."BRAND_NO"='${param.br1}'
				and X."MODEL_NO"='${param.brxh1}'							
				GROUP BY  X."SEX"			 
</e:q4l>
<e:q4l var="usersComperTwoSex">
			select 					
					 X."SEX",
					"sum"(X ."TERMINAL_NUM") a							
				from "DM_M_TERM_USER_MAIN" X 
				WHERE  1=1						
				<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
					<e:if condition="${param.pronameY != '全国'}">
						AND X."AREA_NO"='${param.provc_no}'
					</e:if>	
				</e:if>
				<e:else condition="${AllOrCity }">
					AND X."AREA_NO"='${param.provc_no}'
					AND X."CITY_NO"='${param.city_no}'
				</e:else>					
				<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
					and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
				</e:if>								
				and X."BRAND_NO"='${param.br2}'
				and X."MODEL_NO"='${param.brxh2}'							
				GROUP BY  X."SEX"			 
</e:q4l>

<e:q4l var="selectifa1">
	SELECT
		X."MEL_NO",
		Y."MEAL_NAME",
		"sum" (X."TERMINAL_NUM") A
	FROM
		"DM_M_TERM_USER_OFFICE" X,
		"DIM_OFFICE_NO" Y
	WHERE
		1 = 1
	AND X."MEL_NO" = Y."MEAL_NO"
	AND Y."IS_MEAL" = '0'
	<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
		<e:if condition="${param.pronameY != '全国'}">
			AND X."AREA_NO"='${param.provc_no}'
		</e:if>	
	</e:if>
	<e:else condition="${AllOrCity }">
		AND X."AREA_NO"='${param.provc_no}'
		AND X."CITY_NO"='${param.city_no}'
	</e:else>							
	<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
		and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
	</e:if>			
	and X."BRAND_NO"='${param.br1}'
	and X."MODEL_NO"='${param.brxh1}'
	GROUP BY
		X."MEL_NO",
		Y."MEAL_NAME"
</e:q4l>
<e:q4l var="usersComperOneMel">
	<e:if condition="${e:length(selectifa1.list)>10}">
		SELECT 
				'10' "MEL_NO",
			  '其他' "MEAL_NAME",
				A.a-B.a a
		FROM 
		(SELECT
					"sum" (X."TERMINAL_NUM") a
				FROM
					"DM_M_TERM_USER_OFFICE" X,
					"DIM_OFFICE_NO" Y
				WHERE
					1 = 1
				AND X."MEL_NO" = Y."MEAL_NO"
				AND Y."IS_MEAL" = '0'
				<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
					<e:if condition="${param.pronameY != '全国'}">
						AND X."AREA_NO"='${param.provc_no}'
					</e:if>	
				</e:if>
				<e:else condition="${AllOrCity }">
					AND X."AREA_NO"='${param.provc_no}'
					AND X."CITY_NO"='${param.city_no}'
				</e:else>							
				<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
					and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
				</e:if>			
				and X."BRAND_NO"='${param.br1}'
				and X."MODEL_NO"='${param.brxh1}'
		) A,
		(SELECT "sum"(A.a) a
		FROM
		(SELECT
			X."MEL_NO",
			Y."MEAL_NAME",
			"sum" (X."TERMINAL_NUM") a
		FROM
			"DM_M_TERM_USER_OFFICE" X,
			"DIM_OFFICE_NO" Y
		WHERE
			1 = 1
		AND X."MEL_NO" = Y."MEAL_NO"
		AND Y."IS_MEAL" = '0'
		<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
			<e:if condition="${param.pronameY != '全国'}">
				AND X."AREA_NO"='${param.provc_no}'
			</e:if>	
		</e:if>
		<e:else condition="${AllOrCity }">
			AND X."AREA_NO"='${param.provc_no}'
			AND X."CITY_NO"='${param.city_no}'
		</e:else>							
		<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
			and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
		</e:if>	
		and X."BRAND_NO"='${param.br1}'
		and X."MODEL_NO"='${param.brxh1}'
		GROUP BY
			X."MEL_NO",Y."MEAL_NAME"
		ORDER BY
			A DESC
		LIMIT 10) A) B
		
		UNION ALL 
	</e:if>
		
	(SELECT
		X."MEL_NO",
		Y."MEAL_NAME",
		"sum" (X."TERMINAL_NUM") A
	FROM
		"DM_M_TERM_USER_OFFICE" X,
		"DIM_OFFICE_NO" Y
	WHERE
		1 = 1
	AND X."MEL_NO" = Y."MEAL_NO"
	AND Y."IS_MEAL" = '0'
	<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
		<e:if condition="${param.pronameY != '全国'}">
			AND X."AREA_NO"='${param.provc_no}'
		</e:if>	
	</e:if>
	<e:else condition="${AllOrCity }">
		AND X."AREA_NO"='${param.provc_no}'
		AND X."CITY_NO"='${param.city_no}'
	</e:else>							
	<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
		and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
	</e:if>	
	and X."BRAND_NO"='${param.br1}'
	and X."MODEL_NO"='${param.brxh1}'
	GROUP BY
		X."MEL_NO",
		Y."MEAL_NAME"
	ORDER BY
		A DESC
	LIMIT 10)				 
</e:q4l>
<e:q4l var="selectifa2">
	SELECT
		X."MEL_NO",
		Y."MEAL_NAME",
		"sum" (X."TERMINAL_NUM") A
	FROM
		"DM_M_TERM_USER_OFFICE" X,
		"DIM_OFFICE_NO" Y
	WHERE
		1 = 1
	AND X."MEL_NO" = Y."MEAL_NO"
	AND Y."IS_MEAL" = '0'
	<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
		<e:if condition="${param.pronameY != '全国'}">
			AND X."AREA_NO"='${param.provc_no}'
		</e:if>	
	</e:if>
	<e:else condition="${AllOrCity }">
		AND X."AREA_NO"='${param.provc_no}'
		AND X."CITY_NO"='${param.city_no}'
	</e:else>							
	<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
		and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
	</e:if>			
	and X."BRAND_NO"='${param.br2}'
	and X."MODEL_NO"='${param.brxh2}'
	GROUP BY
		X."MEL_NO",
		Y."MEAL_NAME"
</e:q4l>
<e:q4l var="usersComperTwoMel">
	<e:if condition="${e:length(selectifa2.list)>10}">
		SELECT 
				'10' "MEL_NO",
			  '其他' "MEAL_NAME",
				A.a-B.a a
		FROM 
		(SELECT
					"sum" (X."TERMINAL_NUM") a
				FROM
					"DM_M_TERM_USER_OFFICE" X,
					"DIM_OFFICE_NO" Y
				WHERE
					1 = 1
				AND X."MEL_NO" = Y."MEAL_NO"
				AND Y."IS_MEAL" = '0'
				<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
					<e:if condition="${param.pronameY != '全国'}">
						AND X."AREA_NO"='${param.provc_no}'
					</e:if>	
				</e:if>
				<e:else condition="${AllOrCity }">
					AND X."AREA_NO"='${param.provc_no}'
					AND X."CITY_NO"='${param.city_no}'
				</e:else>							
				<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
					and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
				</e:if>			
				and X."BRAND_NO"='${param.br2}'
				and X."MODEL_NO"='${param.brxh2}'
		) A,
		(SELECT "sum"(A.a) a
		FROM
		(SELECT
			X."MEL_NO",
			Y."MEAL_NAME",
			"sum" (X."TERMINAL_NUM") a
		FROM
			"DM_M_TERM_USER_OFFICE" X,
			"DIM_OFFICE_NO" Y
		WHERE
			1 = 1
		AND X."MEL_NO" = Y."MEAL_NO"
		AND Y."IS_MEAL" = '0'
		<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
			<e:if condition="${param.pronameY != '全国'}">
				AND X."AREA_NO"='${param.provc_no}'
			</e:if>	
		</e:if>
		<e:else condition="${AllOrCity }">
			AND X."AREA_NO"='${param.provc_no}'
			AND X."CITY_NO"='${param.city_no}'
		</e:else>							
		<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
			and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
		</e:if>	
		and X."BRAND_NO"='${param.br2}'
		and X."MODEL_NO"='${param.brxh2}'
		GROUP BY
			X."MEL_NO",Y."MEAL_NAME"
		ORDER BY
			A DESC
		LIMIT 10) A) B
		
		UNION ALL 
	</e:if>
		
	(SELECT
		X."MEL_NO",
		Y."MEAL_NAME",
		"sum" (X."TERMINAL_NUM") A
	FROM
		"DM_M_TERM_USER_OFFICE" X,
		"DIM_OFFICE_NO" Y
	WHERE
		1 = 1
	AND X."MEL_NO" = Y."MEAL_NO"
	AND Y."IS_MEAL" = '0'
	<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
		<e:if condition="${param.pronameY != '全国'}">
			AND X."AREA_NO"='${param.provc_no}'
		</e:if>	
	</e:if>
	<e:else condition="${AllOrCity }">
		AND X."AREA_NO"='${param.provc_no}'
		AND X."CITY_NO"='${param.city_no}'
	</e:else>							
	<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
		and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
	</e:if>	
	and X."BRAND_NO"='${param.br2}'
	and X."MODEL_NO"='${param.brxh2}'
	GROUP BY
		X."MEL_NO",
		Y."MEAL_NAME"
	ORDER BY
		A DESC
	LIMIT 10)								 
</e:q4l>

<e:q4l var="selectifb1">
		SELECT
			X."MEL_NO",
			Y."MEAL_NAME",
			"sum" (X."TERMINAL_NUM") A
		FROM
			"DM_M_TERM_USER_OFFICE" X,
			"DIM_OFFICE_NO" Y
		WHERE
			1 = 1
		AND X."MEL_NO" = Y."MEAL_NO"
		AND Y."IS_MEAL" = '1'
		<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
			<e:if condition="${param.pronameY != '全国'}">
				AND X."AREA_NO"='${param.provc_no}'
			</e:if>	
		</e:if>
		<e:else condition="${AllOrCity }">
			AND X."AREA_NO"='${param.provc_no}'
			AND X."CITY_NO"='${param.city_no}'
		</e:else>							
		<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
			and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
		</e:if>								
		and X."BRAND_NO"='${param.br1}'
		and X."MODEL_NO"='${param.brxh1}'
		GROUP BY
			X."MEL_NO",
			Y."MEAL_NAME"
</e:q4l>
<e:q4l var="usersComperOneHy">
  <e:if condition="${selectifb1.length  > 10 }">
		SELECT '10' "MEL_NO",
			   '其他' "MEAL_NAME",
			   A.a-B.a a
		FROM
		(SELECT
			"sum" (X."TERMINAL_NUM") a
		FROM
			"DM_M_TERM_USER_OFFICE" X,
			"DIM_OFFICE_NO" Y
		WHERE
			1 = 1
		AND X."MEL_NO" = Y."MEAL_NO"
		AND Y."IS_MEAL" = '1'
		<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
			<e:if condition="${param.pronameY != '全国'}">
				AND X."AREA_NO"='${param.provc_no}'
			</e:if>	
		</e:if>
		<e:else condition="${AllOrCity }">
			AND X."AREA_NO"='${param.provc_no}'
			AND X."CITY_NO"='${param.city_no}'
		</e:else>							
		<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
			and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
		</e:if>								
		and X."BRAND_NO"='${param.br1}'
		and X."MODEL_NO"='${param.brxh1}') A,
		(
			SELECT "sum"(A.a) a
		FROM
		(
		SELECT
			"sum" (X."TERMINAL_NUM") A
		FROM
			"DM_M_TERM_USER_OFFICE" X,
			"DIM_OFFICE_NO" Y
		WHERE
			1 = 1
		AND X."MEL_NO" = Y."MEAL_NO"
		AND Y."IS_MEAL" = '1'
		<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
			<e:if condition="${param.pronameY != '全国'}">
				AND X."AREA_NO"='${param.provc_no}'
			</e:if>	
		</e:if>
		<e:else condition="${AllOrCity }">
			AND X."AREA_NO"='${param.provc_no}'
			AND X."CITY_NO"='${param.city_no}'
		</e:else>							
		<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
			and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
		</e:if>								
		and X."BRAND_NO"='${param.br1}'
		and X."MODEL_NO"='${param.brxh1}'
		GROUP BY
			X."MEL_NO",
			Y."MEAL_NAME"
		ORDER BY
			A DESC
		LIMIT 10) A
		) B
		
		UNION ALL
		</e:if>
		
		(SELECT
			X."MEL_NO",
			Y."MEAL_NAME",
			"sum" (X."TERMINAL_NUM") A
		FROM
			"DM_M_TERM_USER_OFFICE" X,
			"DIM_OFFICE_NO" Y
		WHERE
			1 = 1
		AND X."MEL_NO" = Y."MEAL_NO"
		AND Y."IS_MEAL" = '1'
		<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
			<e:if condition="${param.pronameY != '全国'}">
				AND X."AREA_NO"='${param.provc_no}'
			</e:if>	
		</e:if>
		<e:else condition="${AllOrCity }">
			AND X."AREA_NO"='${param.provc_no}'
			AND X."CITY_NO"='${param.city_no}'
		</e:else>							
		<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
			and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
		</e:if>								
		and X."BRAND_NO"='${param.br1}'
		and X."MODEL_NO"='${param.brxh1}'
		GROUP BY
			X."MEL_NO",
			Y."MEAL_NAME"
		ORDER BY
			A DESC
		LIMIT 10)			 
</e:q4l>
<e:q4l var="selectifb2">
		SELECT
			X."MEL_NO",
			Y."MEAL_NAME",
			"sum" (X."TERMINAL_NUM") A
		FROM
			"DM_M_TERM_USER_OFFICE" X,
			"DIM_OFFICE_NO" Y
		WHERE
			1 = 1
		AND X."MEL_NO" = Y."MEAL_NO"
		AND Y."IS_MEAL" = '1'
		<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
			<e:if condition="${param.pronameY != '全国'}">
				AND X."AREA_NO"='${param.provc_no}'
			</e:if>	
		</e:if>
		<e:else condition="${AllOrCity }">
			AND X."AREA_NO"='${param.provc_no}'
			AND X."CITY_NO"='${param.city_no}'
		</e:else>							
		<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
			and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
		</e:if>								
		and X."BRAND_NO"='${param.br2}'
		and X."MODEL_NO"='${param.brxh2}'
		GROUP BY
			X."MEL_NO",
			Y."MEAL_NAME"
</e:q4l>
<e:q4l var="usersComperTwoHy">
  <e:if condition="${selectifb2.length  > 10 }">
		SELECT '10' "MEL_NO",
			   '其他' "MEAL_NAME",
			   A.a-B.a a
		FROM
		(SELECT
			"sum" (X."TERMINAL_NUM") a
		FROM
			"DM_M_TERM_USER_OFFICE" X,
			"DIM_OFFICE_NO" Y
		WHERE
			1 = 1
		AND X."MEL_NO" = Y."MEAL_NO"
		AND Y."IS_MEAL" = '1'
		<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
			<e:if condition="${param.pronameY != '全国'}">
				AND X."AREA_NO"='${param.provc_no}'
			</e:if>	
		</e:if>
		<e:else condition="${AllOrCity }">
			AND X."AREA_NO"='${param.provc_no}'
			AND X."CITY_NO"='${param.city_no}'
		</e:else>							
		<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
			and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
		</e:if>								
		and X."BRAND_NO"='${param.br2}'
		and X."MODEL_NO"='${param.brxh2}') A,
		(
			SELECT "sum"(A.a) a
		FROM
		(
		SELECT
			"sum" (X."TERMINAL_NUM") A
		FROM
			"DM_M_TERM_USER_OFFICE" X,
			"DIM_OFFICE_NO" Y
		WHERE
			1 = 1
		AND X."MEL_NO" = Y."MEAL_NO"
		AND Y."IS_MEAL" = '1'
		<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
			<e:if condition="${param.pronameY != '全国'}">
				AND X."AREA_NO"='${param.provc_no}'
			</e:if>	
		</e:if>
		<e:else condition="${AllOrCity }">
			AND X."AREA_NO"='${param.provc_no}'
			AND X."CITY_NO"='${param.city_no}'
		</e:else>							
		<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
			and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
		</e:if>								
		and X."BRAND_NO"='${param.br2}'
		and X."MODEL_NO"='${param.brxh2}'
		GROUP BY
			X."MEL_NO",
			Y."MEAL_NAME"
		ORDER BY
			A DESC
		LIMIT 10) A
		) B
		
		UNION ALL
		</e:if>
		
		(SELECT
			X."MEL_NO",
			Y."MEAL_NAME",
			"sum" (X."TERMINAL_NUM") A
		FROM
			"DM_M_TERM_USER_OFFICE" X,
			"DIM_OFFICE_NO" Y
		WHERE
			1 = 1
		AND X."MEL_NO" = Y."MEAL_NO"
		AND Y."IS_MEAL" = '1'
		<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
			<e:if condition="${param.pronameY != '全国'}">
				AND X."AREA_NO"='${param.provc_no}'
			</e:if>	
		</e:if>
		<e:else condition="${AllOrCity }">
			AND X."AREA_NO"='${param.provc_no}'
			AND X."CITY_NO"='${param.city_no}'
		</e:else>							
		<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
			and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
		</e:if>								
		and X."BRAND_NO"='${param.br2}'
		and X."MODEL_NO"='${param.brxh2}'
		GROUP BY
			X."MEL_NO",
			Y."MEAL_NAME"
		ORDER BY
			A DESC
		LIMIT 10)				 
</e:q4l>

<e:q4l var="selectc1">
	 SELECT
		X."APP_NO",
		Y."APP_NAME",
		"sum" (X."TERMINAL_NUM") A
	FROM
		"DM_M_TERM_USER_APP" X,
		"DIM_APP_NO" Y
	WHERE
		1 = 1
	AND X."APP_NO" = Y."APP_NO"
	<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
		<e:if condition="${param.pronameY != '全国'}">
			AND X."AREA_NO"='${param.provc_no}'
		</e:if>	
	</e:if>
	<e:else condition="${AllOrCity }">
		AND X."AREA_NO"='${param.provc_no}'
		AND X."CITY_NO"='${param.city_no}'
	</e:else>							
	<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
		and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
	</e:if>								
	and X."BRAND_NO"='${param.br1}'
	and X."MODEL_NO"='${param.brxh1}'
	GROUP BY
		X."APP_NO",
		Y."APP_NAME"
</e:q4l>
<e:q4l var="usersComperOneApp">
	<e:if condition="${selectc.length > 10 }">
		SELECT '10' "APP_NO",
			   '其他' "APP_NAME",
			   A.a-B.a a
		FROM
		(	SELECT
				"sum" (X."TERMINAL_NUM") a
			FROM
				"DM_M_TERM_USER_APP" X,
				"DIM_APP_NO" Y
			WHERE
				1 = 1
			AND X."APP_NO" = Y."APP_NO"
			<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
				<e:if condition="${param.pronameY != '全国'}">
					AND X."AREA_NO"='${param.provc_no}'
				</e:if>	
			</e:if>
			<e:else condition="${AllOrCity }">
				AND X."AREA_NO"='${param.provc_no}'
				AND X."CITY_NO"='${param.city_no}'
			</e:else>							
			<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
				and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
			</e:if>								
			and X."BRAND_NO"='${param.br1}'
			and X."MODEL_NO"='${param.brxh1}'
				) A) A,
		(select "sum"(A.a) a
			FROM(
				SELECT
					"sum" (X."TERMINAL_NUM") a
				FROM
					"DM_M_TERM_USER_APP" X,
					"DIM_APP_NO" Y
				WHERE
					1 = 1
				AND X."APP_NO" = Y."APP_NO"
				<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
					<e:if condition="${param.pronameY != '全国'}">
						AND X."AREA_NO"='${param.provc_no}'
					</e:if>	
				</e:if>
				<e:else condition="${AllOrCity }">
					AND X."AREA_NO"='${param.provc_no}'
					AND X."CITY_NO"='${param.city_no}'
				</e:else>							
				<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
					and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
				</e:if>								
				and X."BRAND_NO"='${param.br1}'
				and X."MODEL_NO"='${param.brxh1}'
				GROUP BY
					X."APP_NO",
					Y."APP_NAME"
				ORDER BY
					A DESC
				LIMIT 10) B
		
		UNION ALL
	</e:if>
	
	(SELECT
		X."APP_NO",
		Y."APP_NAME",
		"sum" (X."TERMINAL_NUM") A
	FROM
		"DM_M_TERM_USER_APP" X,
		"DIM_APP_NO" Y
	WHERE
		1 = 1
	AND X."APP_NO" = Y."APP_NO"
	<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
		<e:if condition="${param.pronameY != '全国'}">
			AND X."AREA_NO"='${param.provc_no}'
		</e:if>	
	</e:if>
	<e:else condition="${AllOrCity }">
		AND X."AREA_NO"='${param.provc_no}'
		AND X."CITY_NO"='${param.city_no}'
	</e:else>							
	<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
		and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
	</e:if>								
	and X."BRAND_NO"='${param.br1}'
	and X."MODEL_NO"='${param.brxh1}'
	GROUP BY
		X."APP_NO",
		Y."APP_NAME"
	ORDER BY
		A DESC
	LIMIT 10)				 
</e:q4l>
<e:q4l var="selectc2">
	 SELECT
		X."APP_NO",
		Y."APP_NAME",
		"sum" (X."TERMINAL_NUM") A
	FROM
		"DM_M_TERM_USER_APP" X,
		"DIM_APP_NO" Y
	WHERE
		1 = 1
	AND X."APP_NO" = Y."APP_NO"
	<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
		<e:if condition="${param.pronameY != '全国'}">
			AND X."AREA_NO"='${param.provc_no}'
		</e:if>	
	</e:if>
	<e:else condition="${AllOrCity }">
		AND X."AREA_NO"='${param.provc_no}'
		AND X."CITY_NO"='${param.city_no}'
	</e:else>							
	<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
		and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
	</e:if>								
	and X."BRAND_NO"='${param.br2}'
	and X."MODEL_NO"='${param.brxh2}'
	GROUP BY
		X."APP_NO",
		Y."APP_NAME"
</e:q4l>
<e:q4l var="usersComperTwoApp">
  <e:if condition="${selectc2.length > 10 }">
		SELECT '10' "APP_NO",
			   '其他' "APP_NAME",
			   A.a-B.a a
		FROM
		(	SELECT
				"sum" (X."TERMINAL_NUM") a
			FROM
				"DM_M_TERM_USER_APP" X,
				"DIM_APP_NO" Y
			WHERE
				1 = 1
			AND X."APP_NO" = Y."APP_NO"
			<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
				<e:if condition="${param.pronameY != '全国'}">
					AND X."AREA_NO"='${param.provc_no}'
				</e:if>	
			</e:if>
			<e:else condition="${AllOrCity }">
				AND X."AREA_NO"='${param.provc_no}'
				AND X."CITY_NO"='${param.city_no}'
			</e:else>							
			<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
				and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
			</e:if>								
			and X."BRAND_NO"='${param.br2}'
			and X."MODEL_NO"='${param.brxh2}'
				) A) A,
		(select "sum"(A.a) a
			FROM(
				SELECT
					"sum" (X."TERMINAL_NUM") a
				FROM
					"DM_M_TERM_USER_APP" X,
					"DIM_APP_NO" Y
				WHERE
					1 = 1
				AND X."APP_NO" = Y."APP_NO"
				<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
					<e:if condition="${param.pronameY != '全国'}">
						AND X."AREA_NO"='${param.provc_no}'
					</e:if>	
				</e:if>
				<e:else condition="${AllOrCity }">
					AND X."AREA_NO"='${param.provc_no}'
					AND X."CITY_NO"='${param.city_no}'
				</e:else>							
				<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
					and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
				</e:if>								
				and X."BRAND_NO"='${param.br2}'
				and X."MODEL_NO"='${param.brxh2}'
				GROUP BY
					X."APP_NO",
					Y."APP_NAME"
				ORDER BY
					A DESC
				LIMIT 10) B
		
		UNION ALL
	</e:if>
	
	(SELECT
		X."APP_NO",
		Y."APP_NAME",
		"sum" (X."TERMINAL_NUM") A
	FROM
		"DM_M_TERM_USER_APP" X,
		"DIM_APP_NO" Y
	WHERE
		1 = 1
	AND X."APP_NO" = Y."APP_NO"
	<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
		<e:if condition="${param.pronameY != '全国'}">
			AND X."AREA_NO"='${param.provc_no}'
		</e:if>	
	</e:if>
	<e:else condition="${AllOrCity }">
		AND X."AREA_NO"='${param.provc_no}'
		AND X."CITY_NO"='${param.city_no}'
	</e:else>							
	<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
		and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
	</e:if>								
	and X."BRAND_NO"='${param.br2}'
	and X."MODEL_NO"='${param.brxh2}'
	GROUP BY
		X."APP_NO",
		Y."APP_NAME"
	ORDER BY
		A DESC
	LIMIT 10)				 
</e:q4l>

<e:q4l var="selectd1">
 	SELECT
			X."ARPU_NO",
			Y."ARPU_NAME",
			"sum" (X."TERMINAL_NUM") A
		FROM
			"DM_M_TERM_USER_ARPU" X,
			"DIM_ARPU_NO" Y
		WHERE
			1 = 1
		AND X."ARPU_NO" = Y."ARPU_NO"
		<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
			<e:if condition="${param.pronameY != '全国'}">
				AND X."AREA_NO"='${param.provc_no}'
			</e:if>	
		</e:if>
		<e:else condition="${AllOrCity }">
			AND X."AREA_NO"='${param.provc_no}'
			AND X."CITY_NO"='${param.city_no}'
		</e:else>							
		<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
			and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
		</e:if>								
		and X."BRAND_NO"='${param.br1}'
		and X."MODEL_NO"='${param.brxh1}'
		GROUP BY
			X."ARPU_NO",
			Y."ARPU_NAME"
</e:q4l>
<e:q4l var="usersComperOneArpu">
		<e:if condition="${selectd1.length > 10}">
		SELECT 
			'10' "ARPU_NO",
			 '其他' "RPU_NAME",
			 A.a-B.a a
		FROM
		(SELECT
			"sum" (X."TERMINAL_NUM") a
		FROM
			"DM_M_TERM_USER_ARPU" X,
			"DIM_ARPU_NO" Y
		WHERE
			1 = 1
		AND X."ARPU_NO" = Y."ARPU_NO"
		<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
			<e:if condition="${param.pronameY != '全国'}">
				AND X."AREA_NO"='${param.provc_no}'
			</e:if>	
		</e:if>
		<e:else condition="${AllOrCity }">
			AND X."AREA_NO"='${param.provc_no}'
			AND X."CITY_NO"='${param.city_no}'
		</e:else>							
		<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
			and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
		</e:if>								
		and X."BRAND_NO"='${param.br1}'
		and X."MODEL_NO"='${param.brxh1}'
		) A,
		(SELECT "sum"(A.a) a
		FROM 
		(
			SELECT
			"sum" (X."TERMINAL_NUM") A
		FROM
			"DM_M_TERM_USER_ARPU" X,
			"DIM_ARPU_NO" Y
		WHERE
			1 = 1
		AND X."ARPU_NO" = Y."ARPU_NO"
		<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
			<e:if condition="${param.pronameY != '全国'}">
				AND X."AREA_NO"='${param.provc_no}'
			</e:if>	
		</e:if>
		<e:else condition="${AllOrCity }">
			AND X."AREA_NO"='${param.provc_no}'
			AND X."CITY_NO"='${param.city_no}'
		</e:else>							
		<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
			and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
		</e:if>								
		and X."BRAND_NO"='${param.br1}'
		and X."MODEL_NO"='${param.brxh1}'
		GROUP BY
			X."ARPU_NO",
			Y."ARPU_NAME"
		ORDER BY
			A DESC
		LIMIT 10
		) A) B
		
		UNION ALL
		</e:if>	
		
		(SELECT
			X."ARPU_NO",
			Y."ARPU_NAME",
			"sum" (X."TERMINAL_NUM") A
		FROM
			"DM_M_TERM_USER_ARPU" X,
			"DIM_ARPU_NO" Y
		WHERE
			1 = 1
		AND X."ARPU_NO" = Y."ARPU_NO"
		<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
			<e:if condition="${param.pronameY != '全国'}">
				AND X."AREA_NO"='${param.provc_no}'
			</e:if>	
		</e:if>
		<e:else condition="${AllOrCity }">
			AND X."AREA_NO"='${param.provc_no}'
			AND X."CITY_NO"='${param.city_no}'
		</e:else>							
		<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
			and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
		</e:if>								
		and X."BRAND_NO"='${param.br1}'
		and X."MODEL_NO"='${param.brxh1}'
		GROUP BY
			X."ARPU_NO",
			Y."ARPU_NAME"
		ORDER BY
			A DESC
		LIMIT 10)			 
</e:q4l>
<e:q4l var="selectd2">
 	SELECT
			X."ARPU_NO",
			Y."ARPU_NAME",
			"sum" (X."TERMINAL_NUM") A
		FROM
			"DM_M_TERM_USER_ARPU" X,
			"DIM_ARPU_NO" Y
		WHERE
			1 = 1
		AND X."ARPU_NO" = Y."ARPU_NO"
		<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
			<e:if condition="${param.pronameY != '全国'}">
				AND X."AREA_NO"='${param.provc_no}'
			</e:if>	
		</e:if>
		<e:else condition="${AllOrCity }">
			AND X."AREA_NO"='${param.provc_no}'
			AND X."CITY_NO"='${param.city_no}'
		</e:else>							
		<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
			and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
		</e:if>								
		and X."BRAND_NO"='${param.br2}'
		and X."MODEL_NO"='${param.brxh2}'
		GROUP BY
			X."ARPU_NO",
			Y."ARPU_NAME"
</e:q4l>
<e:q4l var="usersComperTwoArpu">
		<e:if condition="${selectd2.length > 10}">
		SELECT 
			'10' "ARPU_NO",
			 '其他' "RPU_NAME",
			 A.a-B.a a
		FROM
		(SELECT
			"sum" (X."TERMINAL_NUM") a
		FROM
			"DM_M_TERM_USER_ARPU" X,
			"DIM_ARPU_NO" Y
		WHERE
			1 = 1
		AND X."ARPU_NO" = Y."ARPU_NO"
		<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
			<e:if condition="${param.pronameY != '全国'}">
				AND X."AREA_NO"='${param.provc_no}'
			</e:if>	
		</e:if>
		<e:else condition="${AllOrCity }">
			AND X."AREA_NO"='${param.provc_no}'
			AND X."CITY_NO"='${param.city_no}'
		</e:else>							
		<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
			and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
		</e:if>								
		and X."BRAND_NO"='${param.br2}'
		and X."MODEL_NO"='${param.brxh2}'
		) A,
		(SELECT "sum"(A.a) a
		FROM 
		(
			SELECT
			"sum" (X."TERMINAL_NUM") A
		FROM
			"DM_M_TERM_USER_ARPU" X,
			"DIM_ARPU_NO" Y
		WHERE
			1 = 1
		AND X."ARPU_NO" = Y."ARPU_NO"
		<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
			<e:if condition="${param.pronameY != '全国'}">
				AND X."AREA_NO"='${param.provc_no}'
			</e:if>	
		</e:if>
		<e:else condition="${AllOrCity }">
			AND X."AREA_NO"='${param.provc_no}'
			AND X."CITY_NO"='${param.city_no}'
		</e:else>							
		<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
			and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
		</e:if>								
		and X."BRAND_NO"='${param.br2}'
		and X."MODEL_NO"='${param.brxh2}'
		GROUP BY
			X."ARPU_NO",
			Y."ARPU_NAME"
		ORDER BY
			A DESC
		LIMIT 10
		) A) B
		
		UNION ALL
		</e:if>	
		
		(SELECT
			X."ARPU_NO",
			Y."ARPU_NAME",
			"sum" (X."TERMINAL_NUM") A
		FROM
			"DM_M_TERM_USER_ARPU" X,
			"DIM_ARPU_NO" Y
		WHERE
			1 = 1
		AND X."ARPU_NO" = Y."ARPU_NO"
		<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
			<e:if condition="${param.pronameY != '全国'}">
				AND X."AREA_NO"='${param.provc_no}'
			</e:if>	
		</e:if>
		<e:else condition="${AllOrCity }">
			AND X."AREA_NO"='${param.provc_no}'
			AND X."CITY_NO"='${param.city_no}'
		</e:else>							
		<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
			and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
		</e:if>								
		and X."BRAND_NO"='${param.br2}'
		and X."MODEL_NO"='${param.brxh2}'
		GROUP BY
			X."ARPU_NO",
			Y."ARPU_NAME"
		ORDER BY
			A DESC
		LIMIT 10)				 
</e:q4l>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head> 
  </head> 
  <body>
     <div id="compareOne">
					<div class="AdminProduct">
						<h2>年龄分布对比图</h2>
						<div  class="overflow-h">
							<div class="chartAdmin">
							<e:if condition="${e:length(usersComperOneAge.list)>0}" var="check1">																								
								<c:npie  id='pie11' 
										  width='400'
									 	 height='350' 									 	 
									 	 title="${param.brname1 }-${param.brxhname1 }"
									 	 dataLabels="false"	 							
										 items="${usersComperOneAge.list}"
										 a="占比"
										 dimension="AGE_NAME"
										 tipfmt="2"
										 legend="true"
										 showexport="false"
										 unit="个"
										 distance="5"
										 colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']"/>	
							</e:if>																
							<e:else condition="${check1}">
								 暂无数据！
							</e:else>							
							</div>	
							<div class="chartAdmin">
							<e:if condition="${e:length(usersComperTwoAge.list)>0}" var="check2">			 
								<c:npie  id='pie21' 
										 width='400'
									 	 height='350' 									 	 
									 	 title="${param.brname2 }-${param.brxhname2 }"
									 	 dataLabels="false"								
										 items="${usersComperTwoAge.list}"
										 a="占比"
										 dimension="AGE_NAME"
										 tipfmt="2"
										 legend="true"
										 showexport="false"
										 unit="个"
										 distance="5"
										 colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']"/>
							</e:if>																
							<e:else condition="${check2}">
								 暂无数据！
							</e:else>	
							</div>	 										
						</div>
					</div>
					<div class="AdminProduct">
						<h2>性别分布对比图</h2>
						<div class="overflow-h">
							<div class="chartAdmin">
							<e:if condition="${e:length(usersComperOneSex.list)>0}" var="check3">
								<c:npie  id='pie12' 
										 width='400'
									 	 height='350' 									 	 
									 	 title="${param.brname1 }-${param.brxhname1 }"
									 	 dataLabels="false"	 							
										 items="${usersComperOneSex.list}"
										 a="占比"
										 dimension="SEX"
										 tipfmt="2"
										 legend="true"
										 showexport="false"
										 unit="个"
										 distance="5"
										 colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']"/>
							</e:if>																
							<e:else condition="${check3}">
								 暂无数据！
							</e:else>
							</div>	
							<div class="chartAdmin">
							<e:if condition="${e:length(usersComperTwoSex.list)>0}" var="check4">				 
								<c:npie  id='pie22' 
										 width='400'
									 	 height='350' 									 	 
									 	 title="${param.brname2 }-${param.brxhname2 }"
									 	 dataLabels="false"	 							
										 items="${usersComperTwoSex.list}"
										 a="占比"
										 dimension="SEX"
										 tipfmt="2"
										 legend="true"
										 showexport="false"
										 unit="个"
										 distance="5"
										 colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']"/>			 	
							 </e:if>																
							<e:else condition="${check4}">
								 暂无数据！
							</e:else>
							 </div>
						</div>
					</div>
					<div class="AdminProduct">
						<h2>套餐分布对比图</h2>
						<div class="overflow-h">
							<div class="chartAdmin">
							<e:if condition="${e:length(usersComperOneMel.list)>0}" var="check5">
								<c:npie  id='pie13' 
										 width='400'
									 	 height='350' 									 	 
									 	 title="${param.brname1 }-${param.brxhname1 }"
									 	 dataLabels="false"	 							
										 items="${usersComperOneMel.list}"
										 a="占比"
										 dimension="MEAL_NAME"
										 tipfmt="2"
										 legend="true"
										 showexport="false"
										 unit="个"
										 distance="5"
										 colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']"/>
							</e:if>																
							<e:else condition="${check5}">
								 暂无数据！
							</e:else>
							</div>	
							<div class="chartAdmin">
							<e:if condition="${e:length(usersComperTwoMel.list)>0}" var="check6">				 
								<c:npie  id='pie23' 
										 width='400'
									 	 height='350' 									 	 
									 	 title="${param.brname2 }-${param.brxhname2 }"
									 	 dataLabels="false"	 							
										 items="${usersComperTwoMel.list}"
										 a="占比"
										 dimension="MEAL_NAME"
										 tipfmt="2"
										 legend="true"
										 showexport="false"
										 unit="个"
										 distance="5"
										 colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']"/>		 
							 </e:if>																
							<e:else condition="${check6}">
								 暂无数据！
							</e:else>
							 </div>	
						</div>
					</div>
					
					<div class="AdminProduct">
						<h2>合约对比图</h2>
						<div class="overflow-h">							
							<div class="chartAdmin">
							<e:if condition="${e:length(usersComperOneHy.list)>0}" var="check7">
								<c:npie  id='pie14' 
									 width='400'
									 	 height='350' 									 	 
									 	 title="${param.brname1 }-${param.brxhname1 }"
									 	 dataLabels="false"	 							
									 items="${usersComperOneHy.list}"
									 a="占比"
									 dimension="MEAL_NAME"
									 tipfmt="2"
									 legend="true"
									 showexport="false"
									 unit="个"
									 distance="5"
									 colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']"/>
							</e:if>																
							<e:else condition="${check7}">
								 暂无数据！
							</e:else>
							</div>	
							<div class="chartAdmin">
							<e:if condition="${e:length(usersComperTwoHy.list)>0}" var="check8">			 	
								<c:npie  id='pie24' 
									 width='400'
									 	 height='350' 									 	 
									 	 title="${param.brname2 }-${param.brxhname2 }"
									 	 dataLabels="false"	 							
									 items="${usersComperTwoHy.list}"
									 a="占比"
									 dimension="MEAL_NAME"
									 tipfmt="2"
									 legend="true"
									 showexport="false"
									 unit="个"
									 distance="5"
									 colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']"/>		 
							</e:if>																
							<e:else condition="${check8}">
								 暂无数据！
							</e:else>
							</div>							
						</div>
					</div>					
					<div class="AdminProduct">
						<h2>APP分布对比图</h2>
						<div class="overflow-h">							
							<div class="chartAdmin">
							<e:if condition="${e:length(usersComperOneApp.list)>0}" var="check9">
								<c:npie  id='pie15' 
									 width='400'
									 	 height='350' 									 	 
									 	 title="${param.brname1 }-${param.brxhname1 }"
									 	 dataLabels="false"	 							
									 items="${usersComperOneApp.list}"
									 a="占比"
									 dimension="APP_NAME"
									 tipfmt="2"
									 legend="true"
									 showexport="false"
									 unit="个"
									 distance="5"
									 colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']"/>	
							</e:if>																
							<e:else condition="${check9}">
								 暂无数据！
							</e:else>
							</div>	
							<div class="chartAdmin">
							<e:if condition="${e:length(usersComperTwoApp.list)>0}" var="check10">			 
								<c:npie  id='pie25' 
									 width='400'
									 	 height='350' 									 	 
									 	 title="${param.brname2 }-${param.brxhname2 }"
									 	 dataLabels="false"	 							
									 items="${usersComperTwoApp.list}"
									 a="占比"
									 dimension="APP_NAME"
									 tipfmt="2"
									 legend="true"
									 showexport="false"
									 unit="个"
									 distance="5"
									 colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']"/>		 
							</e:if>																
							<e:else condition="${check10}">
								 暂无数据！
							</e:else>
							</div>
						</div>
					</div>
					<div class="AdminProduct">
						<h2>arpu值对比图</h2>
						<div class="overflow-h">
							<div class="chartAdmin">
							<e:if condition="${e:length(usersComperOneArpu.list)>0}" var="check11">
								<c:npie  id='pie16' 
									 width='400'
									 	 height='350' 									 	 
									 	 title="${param.brname1 }-${param.brxhname1 }"
									 	 dataLabels="false"	 							
									 items="${usersComperOneArpu.list}"
									 a="占比"
									 dimension="ARPU_NAME"
									 tipfmt="2"
									 legend="true"
									 showexport="false"
									 unit="个"
									 distance="5"
									 colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']"/>	
							</e:if>																
							<e:else condition="${check11}">
								 暂无数据！
							</e:else>
							</div>	
							<div class="chartAdmin">
							<e:if condition="${e:length(usersComperTwoArpu.list)>0}" var="check12">			 
								<c:npie  id='pie26' 
									 width='400'
									 	 height='350' 									 	 
									 	 title="${param.brname2 }-${param.brxhname2 }"
									 	 dataLabels="false"	 							
									 items="${usersComperTwoArpu.list}"
									 a="占比"
									 dimension="ARPU_NAME"
									 tipfmt="2"
									 legend="true"
									 showexport="false"
									 unit="个"
									 distance="5"
									 colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']"/>		 
							</e:if>																
							<e:else condition="${check12}">
								 暂无数据！
							</e:else>
							</div>
						</div>
					</div> 
				</div> 
  </body>
</html>
