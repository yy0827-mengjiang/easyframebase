<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4l var="areaL">
	SELECT a."CITY_NO",a."CITY_NAME",a."AREA_NO" FROM "DIM_CITY_NO" a where 1=1
	<e:if condition="${param.AREA_NO!=null&&param.AREA_NO!=''}">
	 	and a."AREA_NO"='${param.AREA_NO }'
    </e:if>
</e:q4l>${e:java2json(areaL.list) }