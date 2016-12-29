<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<%
//String ind_name = request.getParameter("ind_name"); 
//ind_name = ind_name!=null?new String(request.getParameter("ind_name").getBytes("ISO-8859-1"),"GBK"):""; 
//request.setAttribute("ind_name",ind_name); 
%>
<e:switch value="${param.eaction}">
	<e:case value="SELECT">
		<c:tablequery>
		  <e:sql name="frame.ind.queryIndicator"/>
		</c:tablequery>
	</e:case>
	<e:case value="INSERT">
		<e:q4o var="being_ind" sql="frame.ind.being_ind"/>
		<e:if condition="${being_ind.ind_name eq '' || being_ind.ind_name == null}" var="isBeingInd">
			<e:q4o var="ind_id" sql="frame.ind.seq"/>
			<e:set var="ind_seq" value="${ind_id.i}"></e:set>
			<e:update var="ind_insert" sql="frame.ind.ind_insert" transaction="true" />${ind_insert }
			<a:log pageUrl="pages/frame/ind/ind_exp.jsp" operate="2" content="指标解释管理>>新增指标" result="${ind_insert}"/>
		</e:if>
		<e:else condition="${isBeingInd}">BEINGIND</e:else>
	</e:case>
	<e:case value="DELETE">
		<e:set var="delids" value="${e:json2java(param.ids)}"></e:set>
		<e:update var="ind_delete" sql="frame.ind.ind_delete" transaction="true" />${ind_delete}
		<a:log pageUrl="pages/frame/ind/ind_exp.jsp" operate="4" content="指标解释管理>>删除指标" result="${ind_delete }"/>
	</e:case>
	<e:case value="UPDATE">
		<e:q4o var="being_ind" sql="frame.ind.being_ind1"/>
		<e:if condition="${being_ind.ind_name eq '' || being_ind.ind_name == null}" var="isBeingInd">
			<e:update var="ind_update" sql="frame.ind.ind_update" transaction="true"/>${ind_update }
			<a:log pageUrl="pages/frame/ind/ind_exp.jsp" operate="3" content="指标解释管理>>修改指标" result="${ind_update }"/>
		</e:if>
		<e:else condition="${isBeingInd}">BEINGIND</e:else>
			
	</e:case>
	<e:case value="PUBLISH">
		<e:q4o var="being_ind" sql="frame.ind.being_ind2"/>
		<e:if condition="${being_ind.ind_name eq '' || being_ind.ind_name == null}" var="isBeingInd">
			<e:update var="ind_publish" sql="frame.ind.ind_publish" transaction="true"/>${ind_publish }
			<a:log pageUrl="pages/frame/ind/ind_exp.jsp" operate="2" content="指标解释管理>>发布指标" result="${ind_publish }"/>
		</e:if>
		<e:else condition="${isBeingInd}">BEINGIND</e:else>
	</e:case>
	<e:case value="DEPTREE">
	<e:q4l var="departs" sql="frame.ind.departs"/>${e:java2json(departs.list)}
	</e:case>
</e:switch>