<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>

<e:switch value="${param.eaction}">
	<e:case value="LIST">
		<c:tablequery>
			<e:sql name="xbuilder.globalDataset.LIST"/>
   		</c:tablequery>
	</e:case>
	<e:case value="DELETEBYID">
		<e:update var="rs_del" sql="xbuilder.globalDataset.DELETEBYID"></e:update>${rs_del}
	</e:case>
</e:switch>
