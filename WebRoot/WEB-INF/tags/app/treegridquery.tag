<%@ tag body-content="scriptless" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<%@ attribute name="dimField" required="true" %>                                                <e:description>维度类型</e:description>
<%@ attribute name="isiterate" required="false" %>                                              <e:description>维度是否迭代</e:description>
<%@ attribute name="extds" required="false" %>                                                  <e:description>数据源类型</e:description>
<jsp:doBody var="bodyRes" />
<e:if condition="${param.dim==dimField || pageScope.dim==dimField}">
	<e:if condition="${param.is_down_table == 'true'}">
		<e:set var="down_t_talbe_sql" value="${bodyRes}" scope="session" />
		<e:set var="down_t_talbe_db" value="${extds}" scope="session" />
	</e:if>
	<e:if condition="${param.is_down_table != 'true'}">
		<e:if condition="${extds != null && extds ne ''}" var="extdsif">
			<e:q4l var="treeGridResult" extds="${extds}">
				${e:trim(bodyRes)}
			</e:q4l>
		</e:if>
		<e:else condition="${extdsif}">
		    <e:if condition="${param.curPage eq ''||param.curPage == null ||param.curPage =='undefined' }" var="noPageSql">
		       <e:q4l var="treeGridResult">
		         ${e:trim(bodyRes)}
		       </e:q4l>
		    </e:if>
		    <e:else condition="${noPageSql}">
		        <e:q4o var="treeGridResultCount">
					select count(1) total from (${e:trim(bodyRes)})
				</e:q4o>
				<e:q4l var="treeGridResult">
						SELECT * FROM ( SELECT A.*, ROWNUM RN 
								FROM (${e:trim(bodyRes)}) A WHERE ROWNUM <= ${param.curPage*param.pageSize} ) WHERE RN >= ${(param.curPage-1)*param.pageSize+1}
				</e:q4l>
		    </e:else>
		    
			
		</e:else>
		<e:if var="dimtest" condition="${isiterate==true}">
			<e:invoke var="treeGridResultList" objectClass="cn.com.easy.taglib.util.TagUtils" method="treeGridResultList">
				<e:param value="${treeGridResult.list}" />
				<e:param value="${dimField}${e:getDate('HHmmss')}" />
				<e:param value="icon-cube-blue" />
			</e:invoke>
		</e:if>
		<e:else condition="${dimtest}">
			<e:invoke var="treeGridResultList" objectClass="cn.com.easy.taglib.util.TagUtils" method="treeGridResultList">
				<e:param value="${treeGridResult.list}" />
				<e:param value="${dimField}" />
				<e:param value="icon-cube-blue" />
			</e:invoke>
		</e:else>
		
		    <e:if condition="${param.curPage eq ''||param.curPage == null ||param.curPage =='undefined' }" var="noPageSql">
		         ${e:java2json(treeGridResultList)}
		    </e:if>
		    <e:else condition="${noPageSql}">
		        {"total":${treeGridResultCount.TOTAL},"rows":${e:java2json(treeGridResultList)}}
		    </e:else>
		
	</e:if>
</e:if>