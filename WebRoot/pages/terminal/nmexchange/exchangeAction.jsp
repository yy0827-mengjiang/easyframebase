<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>

<e:switch value="${param.eaction}">	
	<e:case value="seleCityList">
		<e:q4l var="cityList">
				SELECT a."CITY_NO",a."CITY_NAME",a."AREA_NO" 
				FROM "DIM_CITY_NO" a
				where 1=1
				<e:if condition="${param.qdValue!=null&&param.qdValue!=''}">
				 	and a."AREA_NO"='${param.qdValue }'
			    </e:if>
		</e:q4l>${e:java2json(cityList.list)}
	</e:case>
	<e:case value="selbrandCycle">
		<e:q4l var="brandCycle">
			SELECT DISTINCT
				B."BRAND_NAME" a,
				A."CYCLE_NUM" b
			from "DM_M_TERM_NM_CHANGE_CYCLE" A,"DM_NM_TRMNL_DEVINFO" B
			where 1=1
			AND a."BRAND_NO" = b."BRAND_NO"
			and a."AREA_NO"='441'
			and a."CITY_NO"='44101'
			and a."ACCT_MONTH"='201611'
			ORDER BY a."CYCLE_NUM"
			LIMIT 10
		</e:q4l>${e:java2json(brandCycle.list)}
	</e:case>
</e:switch>