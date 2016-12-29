<%@ page language="java" import="java.util.*,java.security.MessageDigest,cn.com.easy.ext.MD5" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<e:switch value="${param.eaction}">
	<e:case value="LIST">
		 <c:tablequery>
		    <e:sql name="frame.download.list"/>
		 </c:tablequery>
	</e:case>
</e:switch>	