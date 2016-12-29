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
	<e:case value="ordersList">
		<e:q4l var="brandlist2">
			select DISTINCT "MODEL_NO","MODEL_NAME" 
			from "TRMNL_DEVINFO" 
			WHERE  1=1
			<e:if condition="${param.qdValue!=null && param.qdValue!=''}">
				and "BRAND_NO"='${param.qdValue}'			
			</e:if>			 
			 ORDER BY "MODEL_NO"
		</e:q4l>${e:java2json(brandlist2.list)}
	</e:case>
	
</e:switch>