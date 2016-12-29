<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>

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

<e:description>1.平均用户在网市场分析-品牌</e:description>
<e:q4l var="timeB">
	SELECT
		B.b a,
		ceil(sum(A."USER_NUM"*A."INNET_NUM")/sum(A."USER_NUM")) b
	FROM
		"DM_M_TERM_NM_USER_INNETTIME" A,
		(SELECT DISTINCT
			"MODEL_NO" a,
			"MODEL_NAME" b
		FROM
			"TRMNL_DEVINFO") B
	WHERE A."MODEL_NO" = B."a"
		  and A."USER_NUM">1000
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
	  			                
	GROUP BY A."MODEL_NO",B.b 
	ORDER BY b desc
	LIMIT 10
</e:q4l>

<e:description>1.平均用户在网市场分析-价格段</e:description>
<e:q4l var="timeP">
	SELECT 
		B."PRICE_NAME" a,
		ceil(sum(A."USER_NUM"*A."INNET_NUM")/sum(A."USER_NUM")) b
	FROM 
		"DM_M_TERM_NM_USER_INNETTIME" A,
		"DIM_PRICES_PERIOD" B
	WHERE 
		A."PRICE_NO" = B."PRICE_NO"
		and A."USER_NUM">1000
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

<e:description>2.用户画像(性格)-品牌</e:description>
<e:q4l var="pictureSB">
	SELECT Z.a a,
		   Z.b b,
		   Z.c c,	
		   Z.d d
	FROM
		(SELECT 
			X.a a,
			X.b b,
			Y.b c,
			X.b+Y.b d
		FROM
		(SELECT 
			A.a a,
			CASE WHEN "sum"(B."TERMINAL_NUM") IS null THEN 0
			ELSE "sum"(B."TERMINAL_NUM")
			END b
		 FROM
			(SELECT DISTINCT
					"BRAND_NO" a
				FROM
					"TRMNL_DEVINFO") A
			LEFT OUTER JOIN
			 (SELECT *
				FROM "DM_M_TERM_NM_USER_SEX"
				WHERE "SEX" = '女'
					  <e:if condition="${area_no == 'qg' }"  var="select1">
					  	  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
					  </e:if>
					  <e:else condition="${select1 }">
					      AND "AREA_NO" = '${area_no }'
						  <e:if condition="${city_no != 'qxz' }">
						  	  AND "CITY_NO" = '${city_no }'
						  </e:if>		
						  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
					  </e:else>	) B ON A."a" = B."BRAND_NO"
				GROUP BY A.a) X,
		(SELECT 
			A.a a,
		 	CASE WHEN "sum"(B."TERMINAL_NUM") IS null THEN 0
			ELSE "sum"(B."TERMINAL_NUM")
			END b
		FROM
			(SELECT DISTINCT
					"BRAND_NO" a
			 FROM
					"TRMNL_DEVINFO") A
			 LEFT OUTER JOIN
			 (SELECT *
				FROM "DM_M_TERM_NM_USER_SEX"
				WHERE "SEX" = '男'
					 	<e:if condition="${area_no == 'qg' }"  var="select1">
					  	 	 AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
					  	</e:if>
					  	<e:else condition="${select1 }">
					     	 AND "AREA_NO" = '${area_no }'
						  	<e:if condition="${city_no != 'qxz' }">
						  	 	 AND "CITY_NO" = '${city_no }'
						 	 </e:if>		
						 	 AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
					  	</e:else>	) B ON A."a" = B."BRAND_NO"
				GROUP BY A.a) Y
		WHERE X.a = Y.a
		GROUP BY X.a,X.b,Y.b ) Z
	WHERE Z.d != 0
	ORDER BY d DESC
	LIMIT 10
</e:q4l>

<e:description>用户画像(性格)-品牌前10名称</e:description>
<e:if condition="${e:length(pictureSB.list)>0}">
	<e:q4l var="brandA">
			SELECT distinct "BRAND_NAME" a,
							"BRAND_NO" b
				FROM "TRMNL_DEVINFO"
				WHERE "BRAND_NO" IN (
					<e:forEach items="${pictureSB.list }" var="itema">
						<e:if condition="${index != e:length(pictureSB.list)-1 }" var="selectifa">
							  '${itema.a}',
						</e:if>
						<e:else condition="${selectifa}">
								'${itema.a}'
						</e:else>
					</e:forEach>
				)
	</e:q4l>
</e:if>

<e:description>2.用户画像（性别）-价格段</e:description>
<e:q4l var="pictureSP">
	SELECT Z.a a,
		   Z.b b,
		   Z.c c,	
		   Z.d d,
		   Z.e e
	FROM
		(SELECT X.a a,
			X.b b,
			Y.b c,
			X.b +Y.b d,
			X.e e
		FROM
		(SELECT 
				A."PRICE_NAME" a,A."ORD" e,
				CASE WHEN "sum"(B."TERMINAL_NUM") IS null THEN 0
				ELSE "sum"(B."TERMINAL_NUM")
				END b
			FROM
				"DIM_PRICES_PERIOD" A
			LEFT OUTER JOIN
			 (SELECT *
				FROM "DM_M_TERM_NM_USER_SEX"
				WHERE "SEX" = '女'
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
			GROUP BY B."PRICE_NO",A."PRICE_NAME",A."ORD" ) X,
			(SELECT 
				A."PRICE_NAME" a,
				CASE WHEN "sum"(B."TERMINAL_NUM") IS null THEN 0
				ELSE "sum"(B."TERMINAL_NUM")
				END b
			FROM
				"DIM_PRICES_PERIOD" A
			LEFT OUTER JOIN
			 (SELECT *
				FROM "DM_M_TERM_NM_USER_SEX"
				WHERE "SEX" = '男'
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
			GROUP BY B."PRICE_NO",A."PRICE_NAME" ) Y
		WHERE X.a = Y.a
		GROUP BY X.a,X.b,Y.b,X.e) Z
	WHERE Z.d != 0
	ORDER BY e 
</e:q4l>

<e:description>年龄段</e:description>
<e:q4l var="age">
	SELECT
		"AGE_NO" a,
		"AGE_NAME" b
	FROM
		"DIM_AGE_PASSAGE"
	ORDER BY "ORD"
</e:q4l>

<e:description>用户画像(年龄)-品牌</e:description>
<e:if condition="${e:length(age.list)>0 }" var="check1">
<e:q4l var="pictureAB">
	SELECT Z.a a,
			<e:forEach items="${age.list }" var="item1">
					Z.b${index} b${index},
			</e:forEach>
			Z.c c
	FROM
		(SELECT
			<e:forEach items="${age.list }" var="item">
				<e:if condition="${index == 0  }">
					X${index }.a a,
				</e:if>
			</e:forEach>
			<e:forEach items="${age.list }" var="item1">
					X${index }.b b${index},
			</e:forEach>
			
			<e:forEach items="${age.list }" var="item2">
				<e:if condition="${index != e:length(age.list)-1  }" var="selectif1">
					X${index }.b+
				</e:if>
				<e:else condition="${selectif1 }">
					X${index }.b c
				</e:else>
			</e:forEach>
			 
		FROM
			<e:forEach items="${age.list }" var="item3">
				<e:if condition="${index != e:length(age.list)-1 }" var="selectif2"> 
					(SELECT 
						A."BRAND_NO" a,
						CASE WHEN "sum"(B."TERMINAL_NUM") IS null THEN 0
						ELSE "sum"(B."TERMINAL_NUM")
						END b
					FROM
						(SELECT DISTINCT
							"BRAND_NO"
						 FROM
							"TRMNL_DEVINFO") A
					LEFT OUTER JOIN
					 (SELECT *
						FROM "DM_M_TERM_NM_USER_AGE"
						WHERE "AGE_NO" = '${item3.a }'
							  <e:if condition="${area_no == 'qg' }"  var="select1">
							  	  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
							  </e:if>
							  <e:else condition="${select1 }">
							      AND "AREA_NO" = '${area_no }'
								  <e:if condition="${city_no != 'qxz' }">
								  	  AND "CITY_NO" = '${city_no }'
								  </e:if>		
								  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
							  </e:else>)B	ON A."BRAND_NO" = B."BRAND_NO"
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
							"BRAND_NO"
					 	FROM
							"TRMNL_DEVINFO") A
					LEFT OUTER JOIN
					 (SELECT *
						FROM "DM_M_TERM_NM_USER_AGE"
						WHERE "AGE_NO" = '${item3.a }'
							  <e:if condition="${area_no == 'qg' }"  var="select1">
							  	  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
							  </e:if>
							  <e:else condition="${select1 }">
							      AND "AREA_NO" = '${area_no }'
								  <e:if condition="${city_no != 'qxz' }">
								  	  AND "CITY_NO" = '${city_no }'
								  </e:if>		
								  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
							  </e:else>)B	ON A."BRAND_NO" = B."BRAND_NO"
					GROUP BY A."BRAND_NO") X${index}
				</e:else>
			</e:forEach>
		WHERE
			<e:forEach items="${age.list }" var="item4">
				<e:if condition="${index >0 && index != e:length(age.list)-1 } ">
					X0.a = X${index}.a and
				</e:if>
				<e:if condition="${index == e:length(age.list)-1 }">
					X0.a = X${index }.a
				</e:if>
			</e:forEach>
		GROUP BY 
			<e:forEach items="${age.list }" var="item5">
				<e:if condition="${index == 0  }">
					X${index }.a,
				</e:if>
			</e:forEach>
			<e:forEach items="${age.list }" var="item6">
				<e:if condition="${index != e:length(age.list)-1 }" var="selectif3">
					X${index }.b,
				</e:if>
				<e:else condition="${selectif3 }">
					X${index }.b
				</e:else>
			</e:forEach>) Z
	WHERE Z.c != 0
	ORDER BY Z.c DESC
	LIMIT 10
</e:q4l>
</e:if>
<e:else condition="${check1 }">
	<e:set var="ageIsNull">ageIsNull</e:set>
</e:else>


<e:description>用户画像(年龄)-品牌top10</e:description>
<e:if condition="${e:length(pictureAB.list)>0}">
	<e:q4l var="brandP">
			SELECT distinct "BRAND_NAME" a,
							"BRAND_NO" b
				FROM "TRMNL_DEVINFO"
				WHERE "BRAND_NO" IN (
					<e:forEach items="${pictureAB.list }" var="itema">
						<e:if condition="${index != e:length(pictureAB.list)-1 }" var="selectifa">
							  '${itema.a}',
						</e:if>
						<e:else condition="${selectifa}">
								'${itema.a}'
						</e:else>
					</e:forEach>
				)
	</e:q4l>
</e:if>

<e:description>用户画像(年龄)-价格段</e:description>
<e:if condition="${e:length(age.list)>0 }" var="check2">
<e:q4l var="pictureAP">
	SELECT Z.a a,
			<e:forEach items="${age.list }" var="item1">
					Z.b${index} b${index},
			</e:forEach>
			Z.e e,
			Z.c c
	FROM
		(SELECT
			<e:forEach items="${age.list }" var="item">
				<e:if condition="${index == 0  }">
					X${index }.a a,
				</e:if>
			</e:forEach>
			<e:forEach items="${age.list }" var="item1">
					X${index }.b b${index},
			</e:forEach>
			
			<e:forEach items="${age.list }" var="item">
				<e:if condition="${index == 0  }">
					X${index }.e e,
				</e:if>
			</e:forEach>
			"sum"(
				<e:forEach items="${age.list }" var="item2">
					<e:if condition="${index != e:length(age.list)-1  }" var="selectif1">
						X${index }.b+
					</e:if>
					<e:else condition="${selectif1 }">
						X${index }.b 
					</e:else>
				</e:forEach>
			) c
		FROM
			<e:forEach items="${age.list }" var="item3">
				<e:if condition="${index != e:length(age.list)-1 }" var="selectif2"> 
					(SELECT 
						A."PRICE_NAME" a,A."ORD" e,
						CASE WHEN "sum"(B."TERMINAL_NUM") IS null THEN 0
						ELSE "sum"(B."TERMINAL_NUM")
						END b
					FROM
						"DIM_PRICES_PERIOD" A
					LEFT OUTER JOIN
					 (SELECT *
						FROM "DM_M_TERM_NM_USER_AGE"
						WHERE "AGE_NO" = '${item3.a }'
							  <e:if condition="${area_no == 'qg' }"  var="select1">
							  	  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
							  </e:if>
							  <e:else condition="${select1 }">
							      AND "AREA_NO" = '${area_no }'
								  <e:if condition="${city_no != 'qxz' }">
								  	  AND "CITY_NO" = '${city_no }'
								  </e:if>		
								  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
							  </e:else>)B	ON A."PRICE_NO" = B."PRICE_NO"
					GROUP BY B."PRICE_NO",A."PRICE_NAME",A."ORD" ) X${index},
				</e:if>
				<e:else condition="${selectif2 }">
					(SELECT 
						A."PRICE_NAME" a,A."ORD" e,
						CASE WHEN "sum"(B."TERMINAL_NUM") IS null THEN 0
						ELSE "sum"(B."TERMINAL_NUM")
						END b
					FROM
						"DIM_PRICES_PERIOD" A
					LEFT OUTER JOIN
					 (SELECT *
						FROM "DM_M_TERM_NM_USER_AGE"
						WHERE "AGE_NO" = '${item3.a }'
							  <e:if condition="${area_no == 'qg' }"  var="select1">
							  	  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
							  </e:if>
							  <e:else condition="${select1 }">
							      AND "AREA_NO" = '${area_no }'
								  <e:if condition="${city_no != 'qxz' }">
								  	  AND "CITY_NO" = '${city_no }'
								  </e:if>		
								  AND "ACCT_MONTH" = to_char(to_date('${acct_month}','yyyymm'), 'yyyymm')	
							  </e:else>)B	ON A."PRICE_NO" = B."PRICE_NO"
					GROUP BY B."PRICE_NO",A."PRICE_NAME",A."ORD" ) X${index}
				</e:else>
			</e:forEach>
		WHERE
			<e:forEach items="${age.list }" var="item4">
				<e:if condition="${index >0 && index != e:length(age.list)-1 } ">
					X0.a = X${index}.a and
				</e:if>
				<e:if condition="${index == e:length(age.list)-1 }">
					X0.a = X${index }.a
				</e:if>
			</e:forEach>
		GROUP BY 
			<e:forEach items="${age.list }" var="item5">
				<e:if condition="${index == 0  }">
					X${index }.a,
				</e:if>
			</e:forEach>
			<e:forEach items="${age.list }" var="item7">
				<e:if condition="${index != e:length(age.list)-1 }" var="selectif4">
					X${index }.e,
				</e:if>
				<e:else condition="${selectif4 }">
					X${index }.e,
				</e:else>
			</e:forEach>
			<e:forEach items="${age.list }" var="item6">
				<e:if condition="${index != e:length(age.list)-1 }" var="selectif3">
					X${index }.b,
				</e:if>
				<e:else condition="${selectif3 }">
					X${index }.b
				</e:else>
			</e:forEach>
			) Z
	WHERE Z.c != 0
	ORDER BY e
</e:q4l>
</e:if>
<e:else condition="${check2 }">
	<e:set var="ageIsNull1">ageIsNull</e:set>
</e:else>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
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
	
 <!-- 独立Css层叠样式表 -->
<e:style value="/pages/terminal/resources/themes/base/boncBase@links.css"/>
<e:style value="resources/themes/base/boncBase@links.css"/>

	
<script type="text/javascript" src='<e:url value="/pages/terminal/resources/themes/base/js/main.js"/>'></script>

<script language="JavaScript">
	$(function() {
		/* alert(${param.area}); */
		$(".EntryGroupLine input").bind("hover focus", function() {
			$(this).parent('.EntryGroupLine').addClass('onFocus');
			$(this).parent('.EntryGroupLine').parent('.EntryBox').siblings('.EntryBox').find('.EntryGroupLine').removeClass('onFocus')
		});
	})

	//月份控件
	$(function() {
		var mydate = new Date();
		var str = "" + mydate.getFullYear() + "-";
		str += (mydate.getMonth() + 1);
		if ('${param.acct_month}' == '') {
			$('#acct_month').val('2016-08');//gelei 2016.12.3 需要删掉     
			//$('#acct_month').val(str);
		}else {
			var varmonth = '${param.acct_month}';
			if (varmonth.length == 5) {
				var month = varmonth.substr(0, 4) + "-0" + varmonth.substr(4);
				$('#acct_month').val(month);
			}
			if (varmonth.length == 6) {
				var month = varmonth.substr(0, 4) + "-" + varmonth.substr(4, 5);
				$('#acct_month').val(month);
			}
		}
		$('#acct_month').datebox({
			editable : false,
			onShowPanel : function() { //显示日趋选择对象后再触发弹出月份层的事件，初始化时没有生成月份层  
				span.trigger('click'); //触发click事件弹出月份层  
				if (!tds) setTimeout(function() { //延时触发获取月份对象，因为上面的事件触发和对象生成有时间间隔  
						tds = p.find('div.calendar-menu-month-inner td');
						tds.click(function(e) {
							e.stopPropagation(); //禁止冒泡执行easyui给月份绑定的事件  
							var year = /\d{4}/.exec(span.html())[0], //得到年份  
								month = parseInt($(this).attr('abbr'), 10); //月份，这里不需要+1  
							$('#acct_month').datebox('hidePanel') //隐藏日期对象  
								.datebox('setValue', year + '-' + month); //设置日期的值  
						});
					}, 0)
			},
			parser : function(s) {
				if (!s) return new Date();
				var arr = s.split('-');
				return new Date(parseInt(arr[0], 10), parseInt(arr[1], 10) - 1, 1);
			},
			formatter : function(d) {
				return d.getFullYear() + '-' + (d.getMonth() + 1); /*getMonth返回的是0开始的，忘记了。。已修正*/
			}
		});
		var p = $('#acct_month').datebox('panel'), //日期选择对象  
			tds = false, //日期选择对象中月份  
			span = p.find('span.calendar-text'); //显示月份层的触发控件              
	});

	/* 联动条件查询   */
	//省级地市联动
	$(function() {
		var area = '${sessionScope.UserInfo.AREA_NO}';
		var b = '${sessionScope.UserInfo.CITY_NO}';
		var  a = '${sessionScope.UserInfo.CITY_NO != '' && sessionScope.UserInfo.CITY_NO != null && sessionScope.UserInfo.CITY_NO != '-1'}';
		if(area != '' && area != null && area != '-1' ){
	        $('#area option[value="qg"]').remove();
	    }	
	    $("#area").val("${area_no}");
		var city = '${sessionScope.UserInfo.CITY_NO}';
		$("#city").empty();
		$("#city").append("<option value='qxz'>--请选择--</option>");
		var AREA_NO = $("#area").val();
		
		if(city != '' && city != null && city != '-1'){
			 $('#city option[value="qxz"]').remove();
			 $("#city").append("<option value='" + '${city1.city_no}' + "'>" + '${city1.city_name}' + "</option>");
		}else{
			$.post('<e:url value="/pages/terminal/nmactive/activeAction.jsp"/>',{ AREA_NO: AREA_NO},function(data) {
				var city = jQuery.parseJSON(data.trim());
				for (var i = 0; i < city.length; i++) {
					$("#city").append("<option value='" + city[i].CITY_NO + "'>" + city[i].CITY_NAME + "</option>");
				}
				$("#city").val("${param.city}");
			});
		} 
	});

	//省份、地市级联 操作
	function findCity() {
		$("#city").empty();
		$("#city").append("<option value='qxz'>--请选择--</option>");
		var AREA_NO = $("#area").val();
		$.post('<e:url value="/pages/terminal/nmactive/activeAction.jsp"/>',{ AREA_NO: AREA_NO}, function(data) {
			var city = eval(data.trim());
			for (var i = 0; i < city.length; i++) {
				$("#city").append("<option value='" + city[i].CITY_NO + "'>" + city[i].CITY_NAME + "</option>");
			}
		});
	}
	
	//查询按钮
 	function doSearch(){  
 		var area=$('#area').val(); 	
		var city=$('#city').val();
    	var acct_month=$('#acct_month').datebox('getValue').replace("-", "");
    	
   	   if(acct_month.length==5){
   		   var acct_month =acct_month.substr(0,4)+"0"+acct_month.substr(4);
   	   }   	  
		
		window.location.href = '<e:url value="/pages/terminal/nmactive/active.jsp"/>?city=' + city + '&area=' +area+ '&acct_month='+acct_month;
  			
	}
	
	//用户画像（性别）-品牌
 	$(function(){
 		<e:if condition="${e:length(pictureSB.list) > 0}" var="selectz">
	 		var objdataB =jQuery.parseJSON('${e:java2json(pictureSB.list)}');
	 		var BrandA = jQuery.parseJSON('${e:java2json(brandA.list)}');
			var nameB = new Array();
			var dataBG = new Array();
			var dataBB = new Array();
			
			if(objdataB.length > 0){
				
				for(var i=0;i<BrandA.length;i++){
					nameB.push(BrandA[i].a);			
				}
				
				for(var i=0;i<objdataB.length;i++){
					//nameB.push(objdataB[i].a);
					dataBG.push(objdataB[i].b);
					dataBB.push(objdataB[i].c);				
				}
				pBrand(nameB,dataBG,dataBB);
			}else{
				$("#pictureSB1").html("暂无数据！");
			}
		</e:if>
		<e:else condition="${selectz}">
				$("#pictureSB1").html("暂无数据！");
		</e:else>
 	});
 	
 	function pBrand(nameB,dataBG,dataBB){
 		var myChartB = echarts.init(document.getElementById('pictureSB'));

 		optionB = {
		    tooltip : {
		        trigger: 'axis',
		        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
		            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
		        }
		    },
		    legend: {
		        data:['女','男']
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
		            data : nameB
		        }
		    ],
		    yAxis : [
		        {
		            type : 'value'
		        }
		    ],
		    series : [
		        {
		            name:'女',
		            type:'bar',
		            barWidth : 30,
		            stack: '性别',
		            data: dataBG
		        },
		        {
		            name:'男',
		            type:'bar',
		            barWidth : 30,
		            stack: '性别',
		            data: dataBB
		        }
		    ]
		};
		// 使用刚指定的配置项和数据显示图表。
       myChartB.setOption(optionB);
 	}
 	
 	//用户画像（性别）-价格段
 	$(function(){
 		<e:if condition="${e:length(pictureSP.list) > 0}" var="selecty">
	 		var objdataP =jQuery.parseJSON('${e:java2json(pictureSP.list)}');
			var nameP = new Array();
			var dataPG = new Array();
			var dataPB = new Array();
			if(objdataP.length > 0){
				for(var i=0;i<objdataP.length;i++){
					nameP.push(objdataP[i].a);
					dataPG.push(objdataP[i].b);
					dataPB.push(objdataP[i].c);				
				}
				pPrice(nameP,dataPG,dataPB);
			}else{
				$("#pictureSP1").html("暂无数据！");
			}
		</e:if>
		<e:else condition="${selecty}">
			$("#pictureSP1").html("暂无数据！");
		</e:else>
 	});
 	
 	function pPrice(nameP,dataPG,dataPB){
 		var myChartP = echarts.init(document.getElementById('pictureSP'));

 		optionP = {
		    tooltip : {
		        trigger: 'axis',
		         axisPointer : {            // 坐标轴指示器，坐标轴触发有效
		            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
		        }
		      
		    },
		    legend: {
		        data:['女','男']
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
		            data : nameP
		        }
		    ],
		    yAxis : [
		        {
		            type : 'value'
		        }
		    ],
		    series : [
		        {
		            name:'女',
		            type:'bar',
		            stack: '性别',
		            barWidth : 30,
		            data: dataPG
		        },
		        {
		            name:'男',
		            type:'bar',
		            barWidth : 30,
		            stack: '性别',
		            data: dataPB
		        }
		    ]
		};
		// 使用刚指定的配置项和数据显示图表。
       myChartP.setOption(optionP);
 	}
 	
 	//用户画像（年龄段）-品牌
 	$(function(){
 		var IsNull = '${ageIsNull}';
 		if(IsNull == 'ageIsNull'){
 			$("#pictureAB1").html("暂无数据！");
 		}else{
	 		<e:if condition="${e:length(pictureAB.list) > 0}" var="selectx">
		 		var objdataAB =jQuery.parseJSON('${e:java2json(pictureAB.list)}');
		 		var brandP =jQuery.parseJSON('${e:java2json(brandP.list)}');
		 		var dataB =jQuery.parseJSON('${e:java2json(age.list)}');
		 		var ageB = new Array();
		 		if(dataB.length >0){
		 			for(var i=0;i<dataB.length;i++){
		 				ageB.push(dataB[i].b);
		 			}
		 		}
				var nameAB = new Array();
				<e:forEach items="${age.list}" var="itema">
					var dataB${index} = new Array();
				</e:forEach>
				
				if(objdataAB.length > 0){
					for(var i=0;i<brandP.length;i++){
						nameAB.push(brandP[i].a);
					}
					for(var i=0;i<objdataAB.length;i++){
						//nameAB.push(objdataAB[i].a);
						<e:forEach items="${age.list}" var="itemb">	
							dataB${index}.push(objdataAB[i].b${index});
						</e:forEach>		
					}
					
					var dataB=[];
			        <e:forEach items="${age.list }" var="ages">
					        	dataB.push({	
					        	name: '${ages.b}',			        		
					            type:'bar',
					            barWidth : 30,
					            stack: '年龄段',
								data: dataB${index}
					        })			        
				      </e:forEach>
					ABrand(nameAB,ageB,dataB);
				}else{
					$("#pictureAB1").html("暂无数据！");
				}
			</e:if>
			<e:else condition="${selectx}">
				$("#pictureAB1").html("暂无数据！");
			</e:else>
 		}
 	});
 	
 	function ABrand(nameAB,ageB,dataB){
 		var myChartAB = echarts.init(document.getElementById('pictureAB'));
 		
 		optionAB = {
		    tooltip : {
		        trigger: 'axis',
		        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
		            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
		        }
		    },
		    legend: {
		        data: ageB,
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
		            data : nameAB
		        }
		    ],
		    yAxis : [
		        {
		            type : 'value'
		        }
		    ],
		   
		    series : dataB
		};
		// 使用刚指定的配置项和数据显示图表。
       myChartAB.setOption(optionAB); 
 	} 
 	
 	//用户画像（年龄段）-价格段
 	$(function(){
 		var IsNull = '{ageIsNull1}';
 		if(IsNull == 'ageIsNull'){
 			$("#pictureAP1").html("暂无数据！");
 		}else{
	 		<e:if condition="${e:length(pictureAP.list) > 0}" var="selectw">
		 		var objdataAP =jQuery.parseJSON('${e:java2json(pictureAP.list)}');
		 		var dataP =jQuery.parseJSON('${e:java2json(age.list)}');
		 		var ageP = new Array();
		 		if(dataP.length >0){
		 			for(var i=0;i<dataP.length;i++){
		 				ageP.push(dataP[i].b);
		 			}
		 		}
				var nameAP = new Array();
				<e:forEach items="${age.list}" var="itema">
					var dataP${index} = new Array();
				</e:forEach>
				
				if(objdataAP.length > 0){
					for(var i=0;i<objdataAP.length;i++){
						nameAP.push(objdataAP[i].a);
						<e:forEach items="${age.list}" var="itemb">	
							dataP${index}.push(objdataAP[i].b${index});
						</e:forEach>		
					}
					
					var dataP=[];
			        <e:forEach items="${age.list }" var="ages">
					        	dataP.push({	
					        	name: '${ages.b}',			        		
					            type:'bar',
					            barWidth : 30,
					            stack: '年龄段',
								data: dataP${index}
					        })			        
				      </e:forEach>
					APrice(nameAP,ageP,dataP);
				}else{
					$("#pictureAP1").html("暂无数据！");
				}
			</e:if>
			<e:else condition="${selectw}">
				$("#pictureAP1").html("暂无数据！");
			</e:else>
 		}
 	});
 	
 	function APrice(nameAP,ageP,dataP){
 		var myChartAP = echarts.init(document.getElementById('pictureAP'));
 		
 		optionAP = {
		    tooltip : {
		        trigger: 'axis',
		        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
		            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
		        }
		    },
		    legend: {
		        data: ageP,
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
		            data : nameAP
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
       myChartAP.setOption(optionAP); 
 	} 
</script>
</head>

<body>
	<div id="boncEntry">

		<div class=" searcharea"
			style="width:100%;height:auto;margin-top:15px;">
			<!-- 历史换机 -->
			<div title="历史换机">
				<!-- 查询条件 -->
				<div class="searchbox">
					<span class="spantext">省级</span> <select name="state"
						style="width:150px;" id="area" onchange="findCity();">
						<option value="qg">全国</option> 
						<e:forEach items="${areaL.list}" var="item">
							<option value="${item.AREA_NO }">${item.AREA_NAME }</option>
						</e:forEach>
					</select> <span class="spantext">地市</span> <select name="state"
						style="width:150px;" id="city">
					</select> <span class="spantext">月份</span><input id="acct_month"
						required="true" /> <span class="spantext"> <a
						href="javaScript:doSearch();"
						class="easyui-linkbutton" data-options="iconCls:'icon-search'"
						style="width:80px">查询</a>
				</div>
				<!-- //查询条件 -->

				<!-- 平均用户在网时长分析 -->
				<div class="AdminProduct">				
					<div style="float:left;width:50%;">
						<h2 class="time"><div title="当月在网用户总在网时长（月）/当月在网用户量">用户平均在网时长-机型(按品牌终端平均时长排序，单位：月)</div></h2>
						<div>
							<e:if condition="${e:length(timeB.list)<=0}" var="select1">
								暂无数据！
							</e:if>
							<e:else condition="${select1 }">
								<c:ncolumnline id="time" width="auto" height="auto" 
									yaxis="title:,unit:" b="name:数量  ,type:column"
									showexport="false" dimension="a" items="${timeB.list}"
									title=" " legend="false" dataLabel="true" fontsize="10px"
									rotation="0" />
							</e:else>
						</div>
					</div>					
					<div style="float:left;width:50%;">
						<h2 class="time"><div title="当月在网用户总在网时长（月）/当月在网用户量">用户平均在网时长-价格段(按价格段排序，单位：月)</div></h2>
						<div>
							<e:if condition="${e:length(timeP.list) <= 0 }" var="select2">
								暂无数据！
							</e:if>
							<e:else condition="${select2 }">
								<c:ncolumnline id="price" width="auto" height="auto"
									yaxis="title:,unit:" b="name:数量  ,type:column"
									showexport="false" dimension="a" items="${timeP.list}"
									title=" " legend="false" dataLabel="true" fontsize="10px"
									rotation="0" />
							</e:else>
						</div>
					</div>
				</div>
				<!-- //平均用户在网时长分析 -->

				<!-- 用户画像(性别) -->
				<div class="AdminProduct">
					<div style="float:left;width:50%;">
						<h2 class="time"><div title="当月在网用户的男女用户数">用户画像(性别)-品牌(按品牌终端用户数排序)</div></h2>
						<div id="pictureSB1"><div id="pictureSB" style="width:650px;height:400px;"></div></div>
					</div>
					<div style="float:left;width:50%;">
						<h2 class="time"><div title="当月在网用户的男女用户数">用户画像(性别)-价格段(按价格段排序)</div></h2>
						<div id="pictureSP1"><div id="pictureSP" style="width:650px;height:400px;"></div></div>
					</div>
				</div>
				<!-- //用户画像(性别) -->

				<!-- 用户画像(年龄) -->
				<div class="AdminProduct">
					<div style="float:left;width:50%;">
						<h2 class="time"><div title="当月不同年龄段在网用户数">用户画像(年龄)-品牌(按品牌终端用户数排序)</div></h2>
						<div id="pictureAB1"><div id="pictureAB" style="width:650px;height:400px;"></div></div>
					</div>
					<div  style="float:left;width: 50%;">
						<h2 class="time"><div title="当月不同年龄段在网用户数">用户画像(年龄)-价格段(按价格段排序)</div></h2>
						<div id="pictureAP1"><div id="pictureAP" style="width:650px;height:400px;"></div></div>
					</div>
				</div>
				<!-- //用户画像(年龄) -->

			</div>
			<!-- 历史换机 -->
		</div>

		<!-- <!-- <div class="EntryFoot">北京东方国信科技股份有限公司提供技术支持<span>在线用户：24324人</span></div> -->
		
	</div>
	<script type="text/javascript" src='<e:url value="/pages/terminal/resources/themes/base/js/main.js"/>'></script>
</body>
</html>
