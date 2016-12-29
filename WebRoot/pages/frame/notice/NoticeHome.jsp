<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<%
	/*
	 <e:forEach items="${pageContext.request.parameterNames}" var="item">
	 <e:if condition="${e:startsWith(item,'dim_')}">
	 <e:set var="values" value="${paramValues[item]}"/>
	 <e:if condition="${e:length(values)>1}">
	 ${e:replace(item,'dim_','')}=${e:join(values,',')} 
	 </e:if>
	 <e:if condition="${e:length(values)==1}">
	 ${e:replace(item,'dim_','')}=${values[0]} 
	 </e:if>
	 </e:if>
	 </e:forEach>
	 */
%>

<e:q4o var="post" sql="frame.notice.homepost"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>公告</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<c:resources type="easyui,app" style="${ThemeStyle }" />
		<e:style value="resources/themes/common/css/links.css"/>
		<e:style value="resources/themes/common/css/icon.css"/>
		<script type="text/javascript">
		function toHistory(){
			if(window.navigator.userAgent.indexOf("Chrome") != -1) {
				window.location.href=appBase + "/pages/frame/notice/NoticeHistory.jsp";
			}else{
				var id='71', tt = '公告管理', url=appBase + '/pages/frame/notice/NoticeHistory.jsp';
				<e:if var="TabModel" condition="${SysMenuTab==null||SysMenuTab==''||SysMenuTab=='0'}">
	            	$('#nav_span',window.dialogArguments.document).text(tt);
	            	$('#ContentIframe',window.dialogArguments.document).attr('src',url);
	            	window.close();
	            </e:if>
	        	<e:else condition="${TabModel}">
	                $('#nav_span',window.dialogArguments.document).text(tt);
	            	window.dialogArguments.addTabs(id,tt,url);
	            	window.close();
	            </e:else>
			}
		}
		</script>
	</head>
	<body style="overflow-x:hidden; margin:0; padding:5px;">
		<h2 style="display:block; text-align:center; font-size:26px; padding:15px 0 0 0; margin:0 auto; line-height:1; color:#063468;">${post.TITLE }</h2>
		<p style="border-bottom:1px solid #ccc; padding:0; padding-bottom:5px; line-height:1; text-align:center; color:#181818;">时间:${post.BEGIN_DATE } &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp; 发布人:${post.USER_NAME }&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="toHistory();" plain="true" class="easyui-linkbutton" style=" color:#f60;">历史记录</a></p>
		<div style="padding:0 18px; line-height:1.7; font-size:14px;">
			<p>
				<e:if var="notice_c" condition="${post.CC=='' || post.CC==null}">
					今天没有公告
				</e:if>
				<e:else condition="${notice_c}">
					${post.CC}
				</e:else>
			</p>
		</div>
	</body>
</html>
