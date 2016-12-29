<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<%@ include file="/pages/frame/homesql_pg.jsp"%>
<!DOCTYPE html>
<html>
	<head>
		<title>${applicationScope["SysTitle"] }</title>
		<base href="<%=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/"%>">
		<meta charset="UTF-8">
		<e:if condition="${param.isIE8=='1'}">
			<meta http-equiv="X-UA-Compatible" content="IE=8" />
		</e:if>
		<!--声明以IE最高版本浏览器内核或谷歌浏览器内核进行渲染 -->
	    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	    <!--声明以360极速模式进行渲染 -->
	    <meta name=”renderer” content=”webkit” />
	    <!-- 系统ICON图标（注:路径为TomCat根目录） -->
	    <link rel ="Shortcut Icon" href="" />
		<c:resources type="easyui,app" style="b"/>
		<e:style value="/resources/themes/base/boncBase@links.css"/>
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
			</script>
			<style>
			   #boncFrame .layout-panel-west .panel-title{display: none;}
			   #boncFrame .layout-panel-west .layout-button-left{display: none;}
			</style>
	</head>
	<body id="boncFrame">
			<!-- 框架外容器 -->
		    <div class="easyui-layout boncLayout" data-options="fit:true" id="frameLayout">
		        <div style="width:16.6%;" data-options="region:'west', border:false, split:false, hideExpandTool:true, expandMode:null, hideCollapsedContent:false, collapsedSize:68, collapsedContent:function(){return $('#mainMenuSimple');} " title="中国电信">
		            <!-- 框架主体菜单 -->
		            <h3 id="currentOpenMenu">系统管理</h3> 
		            <ul class="mainMenu">
		                <e:forEach items="${RootMenuList.list}" var="item">
								<e:if condition="${item.RESOURCES_TYPE eq '3'}"><!-- 页面链接 -->
								   	<li><a href='${item.URL}' id="resource_${item.RESOURCES_ID}" menuType="${item.RESOURCES_TYPE}" target="_blank" title="${item.RESOURCES_NAME}"><img src="<e:url value="${item.ATTACHMENT}"/>" style="width:20px;height:20px"/>${item.RESOURCES_NAME}</a></li>
								</e:if>
								<e:if condition="${item.RESOURCES_TYPE ne '3'}"><!-- 系统菜单 -->
								   	<li>
								   	    <a href="javascript:void(0);" menuUrl="${item.URL}" menuType="${item.RESOURCES_TYPE}" id="resource_${item.RESOURCES_ID}" onClick="openSubMenus('${item.RESOURCES_ID}','${item.RESOURCES_NAME}','${item.URL}','${item.RESOURCE_STATE}','${item.RESOURCES_TYPE}');"><img src="<e:url value="${item.ATTACHMENT}"/>" style="width:20px;height:20px"/>${item.RESOURCES_NAME}</a>
								   	    <e:if condition="${item.URL==null||item.URL eq ''}">
								   	    	<ul></ul>
								   	    </e:if>
								   	</li>
								</e:if>
					     </e:forEach>
		            </ul>
		        </div>
		        <div data-options="region:'center', border:false">
		            <div class="easyui-layout" data-options="fit:true">
		                 
		                <!-- 框架子页面容器 -->
		                <div data-options="region:'center', border:false">
		                    <div id="content" class="easyui-layout" fit="true">
									<div id="content-body" region="center" border="false">
										<e:if var="TabModel" condition="${SysMenuTab==null||SysMenuTab==''||SysMenuTab=='0'}">
											<div id = "pageLayout" class="easyui-layout" data-options="fit:true" >
												<div id="pageWest" data-options="region:'west'" title="&nbsp;" style="width:200px;" >
													<ul id="LeftMenu"></ul>
												</div>
												<div data-options="region:'center'">
													<iframe id="ContentIframe" src="" width="100%" height="100%" frameBorder="0"></iframe>
													<div class="move-btn">
														<a href="javascript:void(0);" id="retrunL_btn"onclick="unMenu()"></a>
														<a href="javascript:void(0);" id="retrunR_btn" onclick="showMenu()"></a>
													</div>
												</div>
											</div>
										</e:if>
										<e:else condition="${TabModel}">
											<script type="text/javascript" src='<e:url value="/resources/themes/base/js/tabExtFunction.js"/>'></script>
											<div id="pageLayout" class="easyui-layout" data-options="fit:true">
												<div data-options="region:'center'" >
													<div id="TabDiv" class="easyui-tabs boncTabs" fit="true" plain="true" border="false" data-options="onSelect:tabSelect" >
													</div>
													<div class="moveBtnGroup">
														<a href="javascript:void(0);" id="retrunL_btn"onclick="unMenu()"></a>
														<a href="javascript:void(0);" id="retrunR_btn" onclick="showMenu()"></a>
													</div>
												</div>
											</div>
										</e:else>
									</div>
								</div>
		                </div>
		                <!-- //框架子页面容器 -->
		            </div>
		        </div>
		       
		        <!-- //框架底部声明 -->
		    </div>
		     
		    <!-- 框架缩略图主菜单容器 -->
		    <div id="mainMenuSimple">
		        <a style="width:100%" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'layout-button-right'" onclick="$('.boncLayout').layout('expand','west')"></a>
		        <ul class="mainMenu">
		            <e:forEach items="${RootMenuList.list}" var="item">
						 <li><a href='javascript:void(0);' title="${item.RESOURCES_NAME}" onClick="openSubMenuByShotcuts('${item.RESOURCES_ID}','${item.RESOURCES_NAME}','${item.URL}','${item.RESOURCE_STATE}','${item.RESOURCES_TYPE}');"><img src="<e:url value="${item.ATTACHMENT}"/>" style="width:20px;height:20px"/><span>${item.RESOURCES_NAME}</span></a></li>
					</e:forEach>
		        </ul>
		    </div>
	</body>
</html>