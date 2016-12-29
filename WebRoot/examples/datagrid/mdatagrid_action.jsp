<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4l var="testList">
SELECT CITY_NO, VALUE1, VALUE2, VALUE3, VALUE4, VALUE5
  FROM E_COMPONENT_EXAMPLE T WHERE ROWNUM<${param.count}
</e:q4l>
${e:java2json(testList.list)}