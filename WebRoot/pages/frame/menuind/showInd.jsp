<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<e:q4l var="ind_list">
	SELECT *
	  FROM (SELECT T1.IND_ID,
				   IND_NAME,
				   BUS_EXP,
				   SKILL_EXP,
				   OTHER_EXP,
				   ROW_NUMBER() OVER(PARTITION BY T1.IND_ID ORDER BY UPDATE_TIME ASC) RN
			  FROM E_IND_EXP T1, E_IND_EXP_DETAILS T2
			 WHERE T1.IND_ID = T2.IND_ID
			   AND T2.IND_ID IN (SELECT IND_ID FROM E_MENU_IND M WHERE M.RESOURCES_ID = #menuId#))
	 WHERE RN = 1
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
		<c:resources type="easyui"  style="${ThemeStyle }"/>
		<e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/resources/themes/blue/boncBlue.css"/>
		<e:style value="/resources/themes/common/css/layout.css"/>
		<e:style value="/resources/themes/common/css/sx_icon.css"/>
		<script type="text/javascript" src="<e:url value="resources/scripts/datagrid-detailview.js"/>"></script>
		<script>
			//关闭技术解释和其他解释
			IndexExplanation = '${IndexExplanation}';
			function doQueryInd(ind_id){
				var $form = $("#indList");
				var page_id = $("#pageId").val();
				$("#reload").attr("href","<e:url value='/pages/frame/menuind/indexList.jsp?' />"+"ind_id="+ind_id+"&page_id="+page_id);
				reload.click();
			}
		</script>
</head>
<body>
	<a id="reload" href="" style="display:none"></a>
	<div>
			<e:if condition="${e:length(ind_list.list)>0}" var="isflag">
			<e:forEach items="${ind_list.list}" var="ind">
					<div class="mlr_5">
						<div class="contents-head">
							<h2>${ind.IND_NAME}</h2>
						</div>
						<!-- <form id="indList" method="post">
							<a href="javascript:void(0);" onclick="doQueryInd(${ind.IND_ID})">指标明细</a>
							<input type="hidden" id="pageId" name="pageId" value="${param.menuId}"/>
						</form> -->
					<div class="moduleBox">
						<dl class="indexInterpretationList">
							<dt>业务解释：</dt>
							<e:if condition="${ind.BUS_EXP!=null && ind.BUS_EXP ne ''}" var="isflag">
								<dd>${ind.BUS_EXP}</dd>
							</e:if>
							<e:else condition="${isflag}">
								<dd>&nbsp;</dd>
							</e:else>
							<e:if condition="${IndexExplanation == '0'}">
								<dt>技术解释：</dt>
								<e:if condition="${ind.SKILL_EXP!=null && ind.SKILL_EXP ne ''}" var="isflag">
									<dd>${ind.SKILL_EXP}</dd>
								</e:if>
								<e:else condition="${isflag}">
									<dd>&nbsp;</dd>
								</e:else>
								
								<dt>其他解释：</dt>
								<e:if condition="${ind.OTHER_EXP!=null && ind.OTHER_EXP ne ''}" var="isflag">
									<dd>${ind.OTHER_EXP}</dd>
								</e:if>
								<e:else condition="${isflag}">
									<dd>&nbsp;</dd>
								</e:else>
							</e:if>
							<e:if condition="${IndexExplanation == '1'}">
								<dt>技术解释：</dt>
								<e:if condition="${ind.SKILL_EXP!=null && ind.SKILL_EXP ne ''}" var="isflag">
									<dd>${ind.SKILL_EXP}</dd>
								</e:if>
								<e:else condition="${isflag}">
									<dd>&nbsp;</dd>
								</e:else> 
							</e:if>
							<e:if condition="${IndexExplanation == '2'}"> 
								<dt>其他解释：</dt>
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
					</div>
					</div>
			</e:forEach>
		</e:if>
		<e:if condition="${e:length(ind_list.list)<=0}">
			<div align="center"><strong style="background:#fff; display:block; color:blue; line-height:20px; margin:160px 30px 0 30px;">当前页面没有指标解释</strong></div>
		</e:if>
		</div>
</body>
</html>