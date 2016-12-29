<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:switch value="${param.eaction}">
<e:description>维度模板树</e:description>	
	<e:case value="VARDIMTREE" >
		<e:set var="tid">${param.id }</e:set>
		<e:q4l var="dims" sql="xbuilder.dimension.VARDIMTREE">
		</e:q4l>${e:java2json(dims.list) }
	</e:case>
	<e:case value="CURDIMDATA">
		<e:q4o var="cur" sql="xbuilder.dimension.CURDIMDATA">
		</e:q4o>${e:java2json(cur) }
	</e:case>
	<e:description>报表中维度存到模板中</e:description>
	<e:case value="savetotemplate">
		<e:description>添加维度</e:description>
		<e:update sql="xbuilder.dimension.savetotemplate_del_dim_id"></e:update>
		<e:update sql="xbuilder.dimension.savetotemplate_del_dim_rel"></e:update>
		<e:forEach items="${e:json2java(param.dimJsonStr)}" var="item">
				<e:set var="dimId">D${e:getDate("yyyyMMddHHmmss")}</e:set>
				<e:set var="rel_id">REL${e:getDate("yyyyMMddHHmmss")}</e:set>
				<e:set var="sql" value=""/>
			    <e:if condition="${item.createtype==2}">
				 	  <e:set var="sql" value="${item.sql}"/>
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
				 </e:if>
				 <e:set var="varname">${item.varname }</e:set>
				 <e:set var="table">${item.table }</e:set>
				 <e:set var="type">${item.type }</e:set>
				 <e:set var="desc">${item.desc }</e:set>
				 <e:set var="codecolumn">${item.codecolumn }</e:set>
				 <e:set var="desccolumn">${desccolumn }</e:set>
				 <e:set var="ordercolumn">${ordercolumn }</e:set>
				 <e:set var="parentcol">${item.parentcol }</e:set>
				 <e:set var="level">${item.level }</e:set>
				 <e:set var="parentdimname">${item.parentdimname }</e:set>
				 <e:set var="defaultvalue">${item.defaultvalue }</e:set>
				 <e:set var="database">${item.database }</e:set>
				 
				<e:update sql="xbuilder.dimension.savetotemplate_inset" transaction="true" ></e:update>
			</e:forEach>
	</e:case>
</e:switch>