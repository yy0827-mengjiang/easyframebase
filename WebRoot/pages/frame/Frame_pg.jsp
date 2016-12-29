<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<%@ include file="/pages/frame/homesql.jsp"%>
<!DOCTYPE html>
<html>
	<head>
		<title>${applicationScope["SysTitle"] }</title>
		<base href="<%=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/"%>">
		<!--声明以IE最高版本浏览器内核或谷歌浏览器内核进行渲染 -->
	    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	    <!--声明以360极速模式进行渲染 -->
	    <meta name=”renderer” content=”webkit” />
	    <!-- 系统ICON图标（注:路径为TomCat根目录） -->
	    <link rel ="Shortcut Icon" href="" />
		<c:resources type="easyui,app" style="b"/>
	    <e:style value="/resources/themes/pg/boncBase@links.css"/>
	    <script type="text/javascript" src='<e:url value="/resources/themes/base/js/Frame.js"/>'></script>
	    <script type="text/javascript">
	    		    var isNotClickHideLeft=true;
					firstTabClosable = '${applicationScope.firstTabClosable}';
					var ContextPathJs = '<%=request.getContextPath()%>';
					//是否全屏标识
					SysScreenType = '${applicationScope.SysScreenType}';
					MenuExpandLvl = '${applicationScope.MenuExpandLvl}';
					DefaultOpenPage = '${applicationScope.DefaultOpenPage}';
					SysMenuType = '${SysMenuType}';
					TopKpiPred = '${TopKpiPred}';
					ThemeStyle = '${ThemeStyle}';   //判断主题样式
					ReOpenPage = '${applicationScope.ReOpenPage}';
					
					IsPortal = '${applicationScope.isPortal}';//是否是门户
					LoginOutPortalUrl='${applicationScope.LoginOutPortalUrl}';//退出（注销）类型为门户时，退出（注销）的url
					var locationUrl=window.location.href;
					var LoginOutPortalUrl1='${applicationScope.LoginOutPortalUrl1}';
					var LoginOutPortalUrl2='${applicationScope.LoginOutPortalUrl2}';
					if(LoginOutPortalUrl1!=""&&locationUrl.substring(locationUrl.indexOf(":")+3,locationUrl.indexOf("."))==LoginOutPortalUrl1.substring(LoginOutPortalUrl1.indexOf(":")+3,LoginOutPortalUrl1.indexOf("."))){
						LoginOutPortalUrl=LoginOutPortalUrl1;
					}else if(LoginOutPortalUrl2!=""&&locationUrl.substring(locationUrl.indexOf(":")+3,locationUrl.indexOf("."))==LoginOutPortalUrl2.substring(LoginOutPortalUrl2.indexOf(":")+3,LoginOutPortalUrl2.indexOf("."))){
						LoginOutPortalUrl=LoginOutPortalUrl2;
					}
					appName='<%=request.getContextPath()%>';
					
					var ForceChangePasswordDayNum='${applicationScope.ForceChangePasswordDayNum}';
					var CurrentUserDayNum='${userDaysObj.DAYNUM}';
					
					if(ForceChangePasswordDayNum==''){
						ForceChangePasswordDayNum=0;
					}else{
						ForceChangePasswordDayNum=parseInt(ForceChangePasswordDayNum);
					}
					if(CurrentUserDayNum==''){
						CurrentUserDayNum=0;
					}else{
						CurrentUserDayNum=parseInt(CurrentUserDayNum);
					}
					
					//选择的1级目录id，配置的选项卡数
					var currentId='${FirstMenuId}',SelectedMenuId='${FirstMenuId}',SelectedMenuLabel='${FirstMenuLabel}',SelectedMenuUrl='${FirstMenuUrl}',tabNums='${SysMenuTab}';
					//导航首菜单信息
					firstPageMenuId = '${FirstPageMenuId}';
					FirstPageMenuName = '${FirstPageMenuName}';
					FirstPageMenuUrl = '${FirstPageMenuUrl}';
					FirstPageMenuState = '${FirstPageMenuState}';
				
					//是否显示当前位置
					var HiddenCurrentLocation = '${HiddenCurrentLocation}';
					$(function(){
						$("#ContentIframe").css("height",($(window).height()-95)+"px");
						$("#cd-navigation").children("li").click(function(){
							$(this).find("a").addClass("active");
							$(this).siblings("li").find("a").removeClass("active");
						});
					});
					$(function(){
					
					   $(".tapleft").css({visibility: "hidden"});
			            var a=0;			           
			            var max=$("#cd-navigation li").length-5;
			            if(max<=0){
					     $(".tapright").css({visibility: "hidden"});					    
					     }
					  $(".tapright").click(function(){						 			  
					  $(".tapleft").css({visibility:" visible"});
					     a=a-127;					   
					    $('#cd-navigation').animate({left:a+'px'},300,"linear");
					     if(a==max*(-127)){
					        $(".tapright").css({visibility: "hidden"});					    
					     }					   
					  })
					   $(".tapleft").click(function(){
					     a=a+127;
					     $(".tapright").css({visibility:" visible"});
					    $('#cd-navigation').animate({left:a+'px'},300,"linear");
					     if(a==0){
					     $(".tapleft").css({visibility: "hidden"});
					     }
					  })
					})
					
			</script>
	</head>
<body>
	<e:set var="firstMenuUrl"></e:set>
    <div id="boncEntry">
	<div class="cd-auto-hide-header">
		<div class="topShow">
			<div class="logo">
				<a href="#this">
					<img src="<e:url value="/resources/themes/base/images/boncLayout/bg/boncFrameLogo.png"/>" alt="logo">
					<span>终端指标分析系统</span>
				</a>
			</div>
			<p class="tapleft" style="display:inline-block;height:100%;color:#fff;line-height: 70px;float:left;margin-left:28%;cursor:pointer">&lt&lt</p>
			<nav class="cd-primary-nav" style="width:46%;overflow:hidden;">
				<ul id="cd-navigation" style="white-space: nowrap;" >
					<e:forEach items="${RootMenuList.list}" var="item" indexName="index">
					    <e:if condition="${index==0&&item.URL!=null&&item.URL ne ''}">
					   		 <e:set var="firstMenuUrl">${item.Url}</e:set>
					    </e:if>
					    <e:if condition="${item.URL!=null&&item.URL ne ''}">
					        <e:if condition="${index==0}" var="menuIf">
					   		   <li><a href="${item.URL}" target="ContentIframe" class="active">${item.RESOURCES_NAME}</a></li>
					   	    </e:if>
					   	 	<e:else condition="${menuIf}">
					   	 		<li><a href="${item.URL}" target="ContentIframe">${item.RESOURCES_NAME}</a></li>
					   	 	</e:else>
					    </e:if>
				    </e:forEach>
				</ul>
			</nav>
			<p  class="tapright" style="display:inline-block;height:100%;color:#fff;line-height: 70px;float:left;cursor:pointer;margin-left:5px;">&gt&gt</p>
			
			<div class="user">
				<span>欢迎您，${sessionScope.UserInfo.USER_NAME}!</span>
				<a class="quit" href="javascript:void(0)" id="frame_logout">退出</a>				
			</div>
			<!-- 
			<a href="javascript:void(0)" id="frame_notice" style="float:right;color:#fff;height:70px;line-height: 70px;margin-right:2%;font-size:16px;">公告</a>
			 -->
		</div>
	</div>
	
    <iframe id="ContentIframe" name="ContentIframe"  src="${firstMenuUrl}" width="100%"  height="100%" frameBorder="0" style="margin-top:71px;"></iframe>
	<div class="EntryFoot" id="footer">北京东方国信科技股份有限公司提供技术支持</div>
</div>


			
	</body>
</html>