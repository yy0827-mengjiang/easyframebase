<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<e:q4l var="histimes" sql="kpi.kpiVersion.histimes">
</e:q4l>
<html>
<head>
<title>指标库版本查询</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<e:style value="pages/kpi/version/css/history.css" />
<%-- <e:script value="pages/kpi/version/js/main.js" /> --%>
<script type="text/javascript">
	$(function(){
		$("button[name=close]").on('click',function(){
			$("#kpi").html("");
		    $("#kpi").load('<e:url value="/pages/kpi/kpiManager/kpiMain.jsp"/>?kpi_category=&cube=${param.cube_code}');
		});
	});
</script>
</head>
<body>
	<div class="kpi_guide">
		<div class="tit_div1">
			<h3 id="showTitle">历史版本</h3>
			<span>
				<button type="button" name="close">关闭</button>
			</span>
		</div>
		<div class="editBase_div1">
			<div class="editBase_div_child1">
				<div class="main">
					<div class="history">
						<div class="history-date">
							<e:forEach items="${histimes.list }" var="histime">
							    <e:set var="idx" value="0" clazz="java.lang.Integer"></e:set>
								<ul>
									<h2>
										<a href="#nogo">${histime.CREATEYEAR }年</a>
									</h2>
									<e:q4l var="hisInfos" sql="kpi.kpiVersion.hisInfos">
									</e:q4l>
									<e:forEach items="${hisInfos.list }" var="info">
										<li <e:if condition="${idx == 0 }">class="green"</e:if>>
										<h3>${info.CREATETIME }
<!-- 											${info.CREATETIME }<span>${histime.CREATEYEAR }</span> -->
										</h3>
										<dl>
											<dt>
												<h4>${info.KPI_NAME }[V${info.KPI_VERSION }]</h4>
												<span><b><em></em></em></b>${info.KPI_CALIBER }</span>
											</dt>
										</dl>
										</li>
									    <e:set var="idx" value="${idx+1}" clazz="java.lang.Integer"></e:set>
									</e:forEach>
								</ul>
							</e:forEach>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>