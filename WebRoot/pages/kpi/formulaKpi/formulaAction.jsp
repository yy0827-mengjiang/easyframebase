<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@page import="java.io.File"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:switch value="${param.eaction }">
	<e:case value="formula">
		<e:q4l var="formulaObj" sql="kpi.formulaKpi.formulaObj">
		</e:q4l>
			[
				<e:forEach items="${formulaObj.list }" var="formula">
					<e:if condition="${index>0}">
							,
					</e:if>
					{
						"id":"${formula.ID }",
						"text":"${formula.NAME }",
						"attributes":{
							"FORMULA":"${formula.FORMULA }",
							"FORMULA_EXPLAIN":"${formula.FORMULA_EXPLAIN }"
						}
					}
				</e:forEach>
			]
	</e:case>
	<e:case value="addFormul" >
		<e:update sql="kpi.formulaKpi.addFormul">
		</e:update>
	</e:case>
	<e:case value="delFile">
		<e:update var="data" sql="kpi.formulaKpi.delFile">
		</e:update>
		${data }
	</e:case>
	<e:case value="delFormul">
		<e:update var="data" sql="kpi.formulaKpi.delFormul"></e:update>
		${data }
	</e:case>
</e:switch>