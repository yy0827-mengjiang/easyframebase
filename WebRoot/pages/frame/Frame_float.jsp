<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<%@ include file="/pages/frame/homesql.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>${applicationScope["SysTitle"] }</title>
		<base href="<%=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/"%>">
		<e:if condition="${param.isIE8=='1'}">
			<meta http-equiv="X-UA-Compatible" content="IE=8" />
		</e:if>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<e:style value="resources/themes/base/boncBase@links.css"/>
		<c:resources type="easyui"  style="${ThemeStyle }"/>
		<script type="text/javascript">
			firstTabClosable = '${applicationScope.firstTabClosable}';
			var ContextPathJs = '<%=request.getContextPath()%>';
		</script>
		<script type="text/javascript" src='<e:url value="/resources/themes/base/js/Frame.js"/>'></script>
		<script type="text/javascript">
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
		</script>
		<e:if condition="${ThemeStyle == 'b'}">
			<e:style value="resources/themes/blue/boncBlue.css"/>
		</e:if>
		<e:if condition="${ThemeStyle == 'g'}">
			
		</e:if>
		<e:if condition="${ThemeStyle == 'h'}">
			
		</e:if>
		<script type="text/javascript" src='<e:url value="/resources/themes/base/js/search.js"/>'></script>
	</head>
	<body id="boncFrame">
		<div id="container" class="easyui-layout" style="width: 100%;height: 100%;">
			<div region="north" border="false">
				<div id="header" class="easyui-layout" fit="true">
				<div id="header-content" region="center" border="false" class="ofHide">
					<h1>
					<e:if condition="${ThemeStyle == 'b'}">
						<e:if condition="${applicationScope.isPortal == '0'}">
							<img src='<e:url value="/resources/themes/base/images/boncLayout/img/logo.png"/>' alt="" />
						</e:if>
						<e:if condition="${applicationScope.isPortal == '1'}">
							<img src='<e:url value="/resources/themes/base/images/boncLayout/img/logo.png"/>' alt="" />
						</e:if>
					</e:if>
					<e:if condition="${ThemeStyle == 'g'}">
						<img src='<e:url value="/resources/themes/base/images/boncLayout/img/logo.png"/>' alt="" />
					</e:if>
					<e:if condition="${ThemeStyle == 'h'}">
						<img src='<e:url value="/resources/themes/base/images/boncLayout/img/logo.png"/>' alt="" />
					</e:if>
					</h1>
					<div id="headerMenu">
						<div id="navMenu">
							<e:forEach items="${RootMenuList.list}" var="item">
								<e:set var="menuFuncName">openBaseState0</e:set>
								<e:if condition="${item.RESOURCES_TYPE eq '3'}">
								   	<a href='${item.URL}' target="_blank">${item.RESOURCES_NAME}</a>
								</e:if>
								<e:if condition="${item.RESOURCES_TYPE ne '3'}">
								   	<a href='javascript:void(0);' onClick="${menuFuncName}('${item.RESOURCES_ID}','${item.RESOURCES_NAME}','${item.URL}','${item.RESOURCE_STATE}','${item.RESOURCES_TYPE}');">${item.RESOURCES_NAME}</a>
								</e:if>
							</e:forEach>
						</div>
					</div>
					<!-- 全局菜单开始 -->
					<ul id="globalMenu">
						<li>
							<a class="scrollerLeft"></a>
							<a class="scrollerRight"></a>
						</li>
						<li><a id="frame_manager" class="adminUser" href="javascript:void(0);"><em>${sessionScope.UserInfo.USER_NAME}</em></a></em></li>
						<li><a class="favoritesWindowBtn02" href="javascript:void(0);" id="open_collect">收藏夹</a></li>
						<li class="icoNotice"><a id="frame_notice" href="javascript:void(0);">公告</a></li>
						<!-- 
						<li class="indexInterpretation"><a id="frame_ind" href="javascript:void(0);">指标解释</a></li>
						<li class="icoSearch"><a id="frame_query" href="javascript:void(0);">查询</a></li>
						-->
					</ul>
					<div class="systemTimeArea">
						<!--  <span id="localTime"></span> -->
					</div>
					<!-- //全局菜单开始结束 -->
				</div>
			</div>
		</div>
		<div region="center" border="false" class="ofHide100">
			<div id="content" class="easyui-layout" fit="true">
				<e:if condition="${HiddenCurrentLocation != '1'}">
					<div id="contentMap" region="north" border="false">
						<a href="javascript:void(0);" id="mBombWindowBtn" class="hide">菜单栏 <b>|</b></a>
						<strong>当前位置：</strong><span id="nav_span">${FirstMenuLabel}</span>
						<p>
							<e:if condition="${TopKpiPred == true}">
								<a class="favoritesWindowBtn03" href="javascript:void(0);" id="user_pred">指标预警</a>
							</e:if>
						</p>
					</div>
				</e:if>
				<div id="content-body" region="center" border="false" style="overflow:hidden;">
					<e:if var="TabModel" condition="${SysMenuTab==null||SysMenuTab==''||SysMenuTab=='0'}">
						<iframe id="ContentIframe" src="" width="100%" height="100%" frameBorder="0"></iframe>
						<div id="sider-bar" class="panel-body panel-body-noheader">
							<ul id="LeftMenu"></ul>
						</div>
					</e:if>
					<e:else condition="${TabModel}">
						<script type="text/javascript" src='<e:url value="/resources/themes/base/js/tabExtFunction.js"/>'></script>
						<div id="TabDiv" class="easyui-tabs layout-tabs" fit="true" plain="true" border="false" data-options="onSelect:tabSelect" >
						</div>
						<div id="sider-bar" class="panel-body panel-body-noheader">
							<e:if condition="${HiddenCurrentLocation == '1'}">
								<ul id="xdivul" style="position:relative;"><a style="position:absolute;right:5px;top:-10px;text-decoration:none;" href="javascript:void(0)" onclick="closeMenuByManal()">&times;</a></ul>
							</e:if>
							<ul id="LeftMenu"></ul>
						</div>
					</e:else>
				</div>
			</div>
		</div>
		<div id="footer" data-options="region:'south',border:false"></div>
	</div>
	<div id="menu_context" class="easyui-menu" style="width:120px;">
	        <div id="mm-tabcloseall" data-options="name:2">全部关闭</div>
	        <div id="mm-tabcloseother" data-options="name:3">除此之外全部关闭</div>
	        <div class="menu-sep"></div>
	        <div id="mm-tabcloseright" data-options="name:4">当前页右侧全部关闭</div>
	        <div id="mm-tabcloseleft" data-options="name:5">当前页左侧全部关闭</div>
    	</div>
	<!-- 页面查询弹出框 -->
	<div id="searchWindow">
		<div class="triangleBorderDown"><span></span></div>
		<ul>
			<li><input type="checkbox" name="SERACH_TYPE" id="SERACH_TYPE" value="1"/>报表名称</li>
			<li><input type="checkbox" name="SERACH_TYPE" id="SERACH_TYPE" value="2"/>指标名称</li>
			<li><input type="checkbox" name="SERACH_TYPE" id="SERACH_TYPE" value="3"/>指标解释</li>
		</ul>
	</div>
	<div id="favoritesWindow"></div>
					<!-- 用户管理弹出框 -->
					<div id="managerWindow">
						<ul>
							<li><a id="frame_mpwd" href="javascript:void(0);">修改密码</a></li>
							<li><a id="frame_logout" href="javascript:void(0);">注销</a></li>
						</ul>
					</div>
					<!-- 超出预警弹出框 -->
					<div id="predDialog" title="指标预警" class="easyui-dialog" data-options="closed:true,modal:true,height:300,width:600">
						<div id="predLoad"></div>
					</div>
					<!-- 修改密码弹出框 -->
					<div id="updPwdDialog" title="修改密码" class="easyui-dialog" data-options="closed:true,modal:true,height:230,width:400,buttons:[{
							text:'确定',
							iconCls:'icon-ok',
							handler:function(){
								updPwd();
							}
						}]">
						<div id="updPwdLoad"></div>
					</div>
					<!-- 添加收藏弹出框 -->
					<div id="insColDialog" title="添加收藏夹" class="easyui-dialog" data-options="closed:true,modal:true,height:150,width:260,buttons:[{
							text:'收藏',
							iconCls:'',
							handler:function(){
								insCol();
							}
						}]">
						<div id="insColLoad"></div>
					</div>
					<!-- 全局菜单开始 -->
					<!-- 页面搜索框 -->
					<div id="boncSearch"> 
						<a id="frame_serach" href="javascript:void(0);"><label>搜索</label></a>
						<input type="text" id="search-text" name="search-text" style="width:300px"/> 
						<a id="search_submit" href="javascript:void(0);"><img src='<e:url value="/resources/themes/base/images/boncLayout/bg/icoSearch.png"/>' alt="" /> </a>
						<input type="hidden" id="se_name" />
						<input type="hidden" id="se_id" />
						<input type="hidden" id="se_type" />
						<input type="hidden" id="se_url" />						
					</div> 
   <!-- -------------------------------------------------页面弹出窗end--------------------------------------------------------------- -->	
	</body>
</html>