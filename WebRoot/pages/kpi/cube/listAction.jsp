<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="cn.com.easy.taglib.function.Functions"%>
<%@ page import="cn.com.easy.ebuilder.parser.CommonTools"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<e:switch value="${param.eaction}">
	<e:case value="dimlist">
		<c:tablequery> 
			<e:sql name="kpi.cube.dimlist"/>
		</c:tablequery>
	</e:case>
	<e:case value="dimNotlist">
		<c:tablequery>
		 	<e:sql name="kpi.cube.dimNotlist"/>
		</c:tablequery>
	</e:case>
	
	<e:case value="attrlist">
		<c:tablequery>
	    	<e:sql name="kpi.cube.attrlist"/>
		</c:tablequery>
	</e:case>
	
	<e:case value="keylist">
		<c:tablequery>
	   			<e:sql name="kpi.cube.keylist"/>
		</c:tablequery>
	</e:case>
	<e:case value="addDim">
		<e:update var="insert" sql="kpi.cube.insertDimRal"/>${insert } 
	</e:case>
	<e:case value="uptDim">
		<e:update var="update" sql="kpi.cube.updateDimRal"/>${update }
	</e:case>
	<e:case value="delDim">
		<e:update var="delete" sql="kpi.cube.deleteDimRal"/>${delete }
	</e:case>
	<e:case value="addAttr">
		<e:update var="insert" sql="kpi.cube.insertAttrRal"/>${insert }
	</e:case>
	<e:case value="editAttr">
		<e:q4o var="attr" sql="kpi.cube.attDetail" />${e:java2json(attr) }
	</e:case>
	<e:case value="updateAttr">
		<e:update var="update" sql="kpi.cube.updateAttrRal"/>${update}
	</e:case>
	<e:case value="delAttr">
		<e:update var="delt" sql="kpi.cube.deleteAttrRal"/>${delt}
	</e:case>
	<e:case value="addKey">
		<e:update var="insert" sql="kpi.cube.insertKeyRal"/>${insert }
	</e:case>
	<e:case value="editKey">
		<e:q4o var="attr" sql="kpi.cube.keyDetail"/>${e:java2json(attr) }
	</e:case>
	<e:case value="updateKey">
		<e:update var="update" sql="kpi.cube.updateKeyRal"/>${update}
	</e:case>
	<e:case value="delKey">
		<e:update var="delt" sql="kpi.cube.deleteKeyRal"/>${delt}
	</e:case>
</e:switch>