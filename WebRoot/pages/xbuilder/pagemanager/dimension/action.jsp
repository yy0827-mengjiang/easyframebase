<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<e:switch value="${param.eaction}">
	<e:case value="loadDim">
		<e:description>加载维度数据</e:description>
		<e:if condition="${param.id==null}">
			[{
				"DIM_ID":"-1",
				"DIM_NAME":"维度",
				"DIM_LEVEL":"0",
				"TYPE":"folder",
				"state":"closed"
			}]
		</e:if>
		<e:if condition="${param.id!=null}">
			<e:q4l var="dim_list" sql="xbuilder.dimensionManager.loadDim">
			</e:q4l>
			${e:replace(e:java2json(dim_list.list),"STATE","state") }
		</e:if>
	</e:case>
	<e:case value="appendDimCategory">
		<e:description>添加维度分类</e:description>
		<e:update transaction="true" sql="xbuilder.dimensionManager.appendDimCategory">
		</e:update>
		添加成功！
	</e:case>
	<e:case value="appendDim">
		<e:description>添加维度</e:description>
		<e:if condition="${param.createType==1}">
		<e:update transaction="true" sql="xbuilder.dimensionManager.appendDim_createType_1">
		</e:update>
		添加成功！
		</e:if>
		<e:if condition="${param.createType==2}">
			<e:set var="sql" value="${param.dimSql}"/>
			<e:set var="replaceStrR" value="\r"/>
			<e:set var="replaceStrN" value="\n"/>
			<e:set var="replaceStrT" value="\t"/>
			<e:set var="replaceStrD" value="'"/>
			<e:set var="replaceStrF" value="#"/>
			<e:set var="replaceStrDD" value="''"/>
			<e:set var="sql" value="${e:replace(sql,replaceStrR,' ')}"/>
			<e:set var="sql" value="${e:replace(sql,replaceStrN,' ')}"/>
			<e:set var="sql" value="${e:replace(sql,replaceStrT,' ')}"/>
			<e:set var="sql" value="${e:replace(sql,replaceStrD,replaceStrDD)}"/>
			<e:set var="sql" value="${e:replace(sql,replaceStrF,'^')}"/>
			<e:update transaction="true" sql="xbuilder.dimensionManager.appendDim_createType_2">
			</e:update>
		添加成功！
		</e:if>
		
	</e:case>
	<e:case value="removeDimCategory">
		<e:description>删除维度分类</e:description>
		<e:update transaction="true" sql="xbuilder.dimensionManager.removeDimCategory_dimension">
		</e:update>
		
		<e:update transaction="true" sql="xbuilder.dimensionManager.removeDimCategory_category">
		</e:update>
	</e:case>
	<e:case value="removeDim">
		<e:description>删除维度</e:description>
		<e:update transaction="true" sql="xbuilder.dimensionManager.removeDim">
		</e:update>
	</e:case>
	<e:case value="editDimCategory">
		<e:description>修改维度分类</e:description>
		<e:update transaction="true" sql="xbuilder.dimensionManager.editDimCategory">
		</e:update>
		修改成功！
	</e:case>
	<e:case value="editDim">
		<e:description>修改维度</e:description>
		<e:if condition="${param.createType==1}">
			<e:update transaction="true" sql="xbuilder.dimensionManager.editDim_createType_1">
			</e:update>
				修改成功！
		</e:if>
		<e:if condition="${param.createType==2}">
			<e:set var="sql" value="${param.dimSql}"/>
			<e:set var="replaceStrR" value="\r"/>
			<e:set var="replaceStrN" value="\n"/>
			<e:set var="replaceStrT" value="\t"/>
			<e:set var="replaceStrD" value="'"/>
			<e:set var="replaceStrF" value="#"/>
			<e:set var="replaceStrDD" value="''"/>
			<e:set var="sql" value="${e:replace(sql,replaceStrR,' ')}"/>
			<e:set var="sql" value="${e:replace(sql,replaceStrN,' ')}"/>
			<e:set var="sql" value="${e:replace(sql,replaceStrT,' ')}"/>
			<e:set var="sql" value="${e:replace(sql,replaceStrF,'^')}"/>
			<e:set var="sql" value="${e:replace(sql,replaceStrD,replaceStrDD)}"/>
			<e:update transaction="true" sql="xbuilder.dimensionManager.editDim_createType_2">
			</e:update>
			修改成功！
		</e:if>
		
	</e:case>
	<e:case value="CURDIM">
		<e:q4o var="cur" sql="xbuilder.dimensionManager.CURDIM">
		</e:q4o>${e:java2json(cur) }
	</e:case>
</e:switch>