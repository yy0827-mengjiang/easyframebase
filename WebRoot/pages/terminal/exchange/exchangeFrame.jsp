<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<!DOCTYPE html>
<html>
<head>
<a:base/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<c:resources type="easyui" />

    <!--声明以IE最高版本浏览器内核或谷歌浏览器内核进行渲染 -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <!--声明以360极速模式进行渲染 -->
    <meta name=”renderer” content=”webkit” />
    <!--系统名称文本 -->
    <title>终端指标分析系统－换机分析</title>
    <!-- 系统ICON图标（注:路径为TomCat根目录） -->
    <link rel ="Shortcut Icon" href="" />

    <!--EasyUI1.5 Css层叠样式表 -->
    <e:style value="/pages/terminal/resources/component/easyui/themes/metro/easyui.css"/>
    <e:style value="/pages/terminal/resources/component/easyui/themes/icon.css"/>
    
    <!-- 独立Js脚本 -->
    <script type="text/javascript" src='<e:url value="/pages/terminal/resources/themes/base/js/boncCommon.js"/>'></script>
	<!-- 圆形统计图js -->
	<script type="text/javascript" src='<e:url value="/pages/terminal/resources/themes/base/js/jquery.circliful.min.js"/>'></script>
    <!-- 独立Css层叠样式表 -->
    <e:style value="/pages/terminal/resources/themes/base/boncBase@links.css"/>

     <script language="JavaScript">
        $(function(){
	        $(".EntryGroupLine input").bind("hover focus", function() {
	            $(this).parent('.EntryGroupLine').addClass('onFocus');
	            $(this).parent('.EntryGroupLine').parent('.EntryBox').siblings('.EntryBox').find('.EntryGroupLine').removeClass('onFocus')
	            });
	        //alert(window.innerHeight);
	        $("iframe").css({height:(window.screen.height-170)+'px'});
        });
    </script>

</head>
<body>
<div id="boncEntry">
	<e:q4l var="RootMenuList">
select RESOURCES_ID, RESOURCES_NAME, URL
			  FROM e_menu t
				 where t.parent_id = (select resources_id from e_menu where url = 'pages/terminal/exchange/exchangeFrame.jsp')
				   and RESOURCES_ID in
				       (select id
				          from (select b.MENU_ID ID
				                  from E_USER_PERMISSION b
				                 where b.USER_ID = '${sessionScope.UserInfo.USER_ID}'
				                   and b.AUTH_READ = 1
				                union all
				                select c.MENU_ID
				                  from E_ROLE_PERMISSION c
				                 where c.ROLE_CODE in
				                       (select ROLE_CODE
				                          from E_USER_ROLE
				                         where USER_ID = '${sessionScope.UserInfo.USER_ID}')
				                   and c.AUTH_READ = 1) A)
				 order by ord

</e:q4l>
	<div class="easyui-tabs searcharea" style="width:100%;">
	    <e:forEach items="${RootMenuList.list}" var="item" indexName="index">
	        <e:if condition="${index==0}">
					<div title="${item.RESOURCES_NAME}" selected="true" >
	        </e:if>
	        <e:if condition="${index>0}">
					<div title="${item.RESOURCES_NAME}">
	        </e:if>
			<iframe id="con" src='<e:url value="${item.URL }"/>' width="100%"  style="position:relative;" frameBorder="0"></iframe>
			</div>
		</e:forEach>
</div>
	
	


<script type="text/javascript" src='<e:url value="/pages/terminal/resources/themes/base/js/main.js"/>'></script>


</body>
</html>
