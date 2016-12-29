<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%
String uuid=java.util.UUID.randomUUID().toString().replace("-", "");
request.setAttribute("uuid", uuid);

%>
<e:switch value="${param.eaction}">
	<e:case value="LIST">
		<c:tablequery>
			<e:sql name="xbuilder.formulate.formulaList"/>
		</c:tablequery>
	</e:case>
	
	<e:case value="DELETE">
		<e:update var="del_res" sql="xbuilder.formulate.del_res"></e:update>${del_res}
	</e:case>

	<e:case value="getFormulateList">
		<e:q4l var="formulateList" sql="xbuilder.formulate.formulateList"></e:q4l>${e:java2json(formulateList.list)}
	</e:case>

	
	<e:case value="INSERT">
		<e:update var="ins_res" sql="xbuilder.formulate.ins_res"></e:update>${ins_res}#${uuid}
	</e:case>
	
	<e:case value="QUERY">
		<e:q4o var="countObj" sql="xbuilder.formulate.countObj"></e:q4o>${countObj.CON}
	</e:case>
	
	<e:case value="QUERYTIMES">
		<e:q4o var="timesObj" sql="xbuilder.formulate.usetimes"></e:q4o>${timesObj.USETIMES}
	</e:case>
	
</e:switch>