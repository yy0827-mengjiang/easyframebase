<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<e:q4l var="ind_list">
	select id from E_IND_EXP_DETAILS where ind_id = '${param.ind_id}' order by UPDATE_TIME desc
</e:q4l>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<base href="<%=basePath%>">
		<title>指标解释</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
		<c:resources type="easyui"  style="${ThemeStyle }"/>
		<script type="text/javascript" src="<e:url value="resources/scripts/datagrid-detailview.js"/>"></script>
		<link rel="stylesheet" type="text/css" href="resources/themes/common/css/links.css">
		<link rel="stylesheet" type="text/css" href="resources/themes/common/css/icon.css">
</head>
<script>
//关闭技术解释和其他解释
IndexExplanation = '${IndexExplanation}';
	function doBack(){
		var pageId = '${param.page_id}';
		$("#reload").attr("href","<e:url value='/pages/frame/menuind/showInd.jsp?' />"+"menuId="+pageId);
		reload.click();
	}
	$(window).resize(function(){
	 	$('#oper').datagrid('resize');
	 });
</script>

<base target="_self">
<a id="reload" href="" style="display:none"></a>

<body style="overflow-x:hidden;">
	<div id="table_toobar" style="text-align: right;">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doBack();">返回</a>
	</div>
<e:forEach items="${ind_list.list}" var="id">
	<e:if condition="${DBSource=='oracle' }">
		<e:q4o var="ind">
			  select   i.IND_ID,
			  		   ind_code,
				       IND_NAME,
				       t.ind_type_desc,
				       BUS_EXP,
				       SKILL_EXP,
				       OTHER_EXP,
				       DEPARTMENT_CODE,
				       m.depart_desc,
				       FACTORY_CON,
				       MAINTE_MAN,
				       to_char(UPDATE_TIME,'yyyy-MM-dd hh:mm:ss') UPDATE_TIME
				  from E_IND_EXP i, E_IND_EXP_DETAILS s , E_IND_TYPE t ,E_DEPARTMENT m
				  where i.IND_ID = s.IND_ID
				  		and s.ind_type_code = t.ind_type_code 
						and id = '${id.id}'
						and m.depart_code(+) = s.department_code
		</e:q4o>
	</e:if>
	<e:if condition="${DBSource=='mysql' }">
		<e:q4o var="ind">
			  select   i.IND_ID,
			  		   ind_code,
				       IND_NAME,
				       t.ind_type_desc,
				       BUS_EXP,
				       SKILL_EXP,
				       OTHER_EXP,
				       DEPARTMENT_CODE,
				       m.depart_desc,
				       FACTORY_CON,
				       MAINTE_MAN,
				       date_format(UPDATE_TIME,'%Y-%m-%d %h:%i:%s') UPDATE_TIME
				  from E_IND_EXP i, E_IND_TYPE t , E_IND_EXP_DETAILS s  left join E_DEPARTMENT m
				  on m.depart_code = s.department_code
				  where i.IND_ID = s.IND_ID
			  		and s.ind_type_code = t.ind_type_code 
					and id = '${id.id}'
		</e:q4o>
	</e:if>
		<dl class="indexInterpretationList1">
			<dt>指标编号</dt>
			<e:if condition="${ind.IND_CODE!=null && ind.IND_CODE ne ''}" var="isflag">
				<dd>${ind.IND_CODE}</dd>
			</e:if>
			<e:else condition="${isflag}">
				<dd>&nbsp;</dd>
			</e:else>
			
			<dt>指标名称</dt>
			<e:if condition="${ind.IND_NAME!=null && ind.IND_NAME ne ''}" var="isflag">
				<dd>${ind.IND_NAME}</dd>
			</e:if>
			<e:else condition="${isflag}">
				<dd>&nbsp;</dd>
			</e:else>
			
			<dt>指标类型</dt>
			<e:if condition="${ind.ind_type_desc!=null && ind.ind_type_desc ne ''}" var="isflag">
				<dd>${ind.ind_type_desc}</dd>
			</e:if>
			<e:else condition="${isflag}">
				<dd>&nbsp;</dd>
			</e:else>
			
			<dt>局方提出部门</dt>
			<e:if condition="${ind.depart_desc!=null && ind.depart_desc ne ''}" var="isflag">
				<dd>${ind.depart_desc}</dd>
			</e:if>
			<e:else condition="${isflag}">
				<dd>&nbsp;</dd>
			</e:else>
			
			<dt>厂家确认人</dt>
			<e:if condition="${ind.FACTORY_CON!=null && ind.FACTORY_CON ne ''}" var="isflag">
				<dd>${ind.FACTORY_CON}</dd>
			</e:if>
			<e:else condition="${isflag}">
				<dd>&nbsp;</dd>
			</e:else>
			
			<dt>维护人</dt>
			<e:if condition="${ind.MAINTE_MAN!=null && ind.MAINTE_MAN ne ''}" var="isflag">
				<dd>${ind.MAINTE_MAN}</dd>
			</e:if>
			<e:else condition="${isflag}">
				<dd>&nbsp;</dd>
			</e:else>
			
			<dt>更新时间</dt>
			<e:if condition="${ind.UPDATE_TIME!=null && ind.UPDATE_TIME ne ''}" var="isflag">
				<dd>${ind.UPDATE_TIME}</dd>
				</e:if>
				<e:else condition="${isflag}">
					<dd>&nbsp;</dd>
				</e:else>
				
				<dt>业务解释</dt>
				<e:if condition="${ind.BUS_EXP!=null && ind.BUS_EXP ne ''}" var="isflag">
					<dd>${ind.BUS_EXP}</dd>
				</e:if>
				<e:else condition="${isflag}">
					<dd>&nbsp;</dd>
				</e:else>
				
			<e:if condition="${IndexExplanation == '0'}">
				<dt>技术解释</dt>
				<e:if condition="${ind.SKILL_EXP!=null && ind.SKILL_EXP ne ''}" var="isflag">
					<dd>${ind.SKILL_EXP}</dd>
				</e:if>
				<e:else condition="${isflag}">
					<dd>&nbsp;</dd>
				</e:else>
				
				<dt>其他解释</dt>
				<e:if condition="${ind.OTHER_EXP!=null && ind.OTHER_EXP ne ''}" var="isflag">
					<dd>${ind.OTHER_EXP}</dd>
				</e:if>
				<e:else condition="${isflag}">
					<dd>&nbsp;</dd>
				</e:else>
			</e:if>
			
			<e:if condition="${IndexExplanation == '1'}">
				<dt>技术解释</dt>
				<e:if condition="${ind.SKILL_EXP!=null && ind.SKILL_EXP ne ''}" var="isflag">
					<dd>${ind.SKILL_EXP}</dd>
				</e:if>
				<e:else condition="${isflag}">
					<dd>&nbsp;</dd>
				</e:else> 
			</e:if>
			
			<e:if condition="${IndexExplanation == '2'}"> 
				<dt>其他解释</dt>
				<e:if condition="${ind.OTHER_EXP!=null && ind.OTHER_EXP ne ''}" var="isflag">
					<dd>${ind.OTHER_EXP}</dd>
				</e:if>
				<e:else condition="${isflag}">
					<dd>&nbsp;</dd>
				</e:else>
			</e:if>
			
			<e:if condition="${IndexExplanation == '3'}">
			</e:if>
			
			
		</dl>
</e:forEach>
</body>
</html>