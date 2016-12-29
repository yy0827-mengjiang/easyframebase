<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
		<c:tablequery >
			SELECT AREA_NO, CITY_NO, VALUE1, VALUE2, VALUE3, VALUE4, VALUE5
			  FROM E_COMPONENT_EXAMPLE T
			 WHERE 1=1
			 	 {and area_no=#a#}
			 	 {and VALUE2=#b#}
			 AND ROWNUM<40
		</c:tablequery>
    