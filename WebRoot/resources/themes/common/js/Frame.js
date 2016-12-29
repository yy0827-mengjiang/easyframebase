var poor = 0, scroll = 0, is1024 = true,extnote;
var MenuExpandLvl = '';//打开菜单树 层级
var DefaultOpenPage = '';//首次加载菜单树，是否默认打开节点菜单对应页面
var ReOpenPage = '';//是否可以重复打开页面
var SysMenuType = '';
var firstPageMenuId = '';
var FirstPageMenuName = '';
var FirstPageMenuUrl ='';
var FirstPageMenuState='';
var IsPortal='';//是否是门户
var LoginOutPortalUrl='';//退出（注销）类型为门户时，退出（注销）的url

var CanLoginOutFlag=true;//是否可以退出系统

var appName='';//系统项目名

function getStatus(){
		$.post('onlineuser.e',function(data){
			$("#footer").html( " 版权所有：中国电信股份有限公司云计算分公司 , 在线用户数："+data)
		});
	}
function delCol(id){
	var postUrl="pages/frame/collect/CollectAction.jsp?eaction=DELETE";
	$.post(postUrl,{id:id},function(data){
		var temp = $.trim(data);
		if(temp>0) {
			$.messager.alert('系统提示','页面删除成功！');
		} else {
			$.messager.alert('系统提示','页面删除过程中出现错误，请联系管理员！');   
		}
	});
}

function openMenu(menuId,menuName,url){
	
	$.ajax({  
	      type : "post",  
	      url : 'pages/frame/menu/menuAction.jsp?eaction=checkResourceNameAndUrl',  
	      data : {"menuName":menuName,"menuId":menuId,"url":url},  
	      async : false,  
	      success : function(data){ 
	      	if($.trim(data)!='0'){
	      		open1(null,menuName,url);
	      		$('#favoritesWindow').hide();
	      	}else{
	      		$.messager.alert('系统提示','该页面已删除或已无权限访问，请联系管理员！');   	
	      	}
	      }  
    }); 
	
}

function fullScreen(){
	is1024 = false;
	$(".fullBtn").hide();
	$(".fullBtn_k").show();
	var $window = $(window);
	$("#container").css({width:$window.width(),height:$window.height()}).layout("resize");
	var topmenu = $("#nav-menu").get(0);
	$(topmenu).width($(window).width()-40);
	if(topmenu.scrollWidth==$(topmenu).width()){
		poor = 0;
		$(topmenu).width($(window).width());
		$(".scroller-left,.scroller-right").hide();
	}else{
		$(".scroller-left,.scroller-right").show();
		poor = topmenu.scrollWidth - $(topmenu).width();
	}
	rePosition();
}
function fixedScreen(){
	is1024 = true;
	$(".fullBtn").show();
	$(".fullBtn_k").hide();
	var $window = $(window);
	$("#container").css({width:1024,height:$window.height()}).layout("resize");
	var topmenu = $("#nav-menu").get(0);
	$(topmenu).width(1024 - 40);
	if(topmenu.scrollWidth==$(topmenu).width()){
		poor = 0;
		$(topmenu).width(1024);
		$(".scroller-left,.scroller-right").hide();
	}else{
		$(".scroller-left,.scroller-right").show();
		poor = topmenu.scrollWidth - $(topmenu).width();
	}
	rePosition();
}

function rePosition(){
	var siderh = $('#content').layout('panel', 'center').height();
	if($(".favoritesWindowBtn02").offset() != undefined){
		var offset = $(".favoritesWindowBtn02").offset();
		$("#favoritesWindow").css({position:"absolute",right:($(window).width()-offset.left-50),top:(offset.top+22)});
	}
	$("#sider-bar").css({ position:"absolute", top:0, left:0, width:220, height:(siderh-22) });
}
function closeMenuByManal(){
	$("#sider-bar").slideUp(600);
}
function openBaseState0(id,name,url,state,type){
	$.post('pages/frame/menu/menuAction.jsp?eaction=LoadLeftTreeSub',{id:id},function(data){
		SelectedMenuId = id;SelectedMenuLabel=name;SelectedMenuUrl=url;
		data = data.replace(/\r\n/g,'');
		data = data.replace(/(^\s*)|(\s*$)/g, "");
		if(data != null && data != ''){
			extnote = data;
			
			$("#mBombWindowBtn").show();
			if(SysMenuType=='tree'){
				showMenu();
				//$('#pageLayout').layout('panel','west').panel({title : SelectedMenuLabel});
				//$('#LeftMenu').tree('reload');
			}
			$('#LeftMenu').tree('reload');
			$("#sider-bar").slideDown(600);
		}else{
			//判断是否弹出
			if(type == '3'){
				if(IsPortal=='1'){
					if(id!=null&&id!='')
					$.ajax({
				          type : "post",  
				          url : 'pages/frame/log/logAction.jsp?eaction=writeSelectLog',  
				          data : {"menuName":name,"menuId":id},  
				          async : false,  
				          success : function(data){
				          	if(url.indexOf("http://")==0){
				          		window.open(url,name, 'height=100%, width=100%, top=0,left=0, toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=yes, status=yes');
				          	}else{
				          		window.open(appName+'/'+url,name, 'height=100%, width=100%, top=0,left=0, toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=yes, status=yes');
				          	}
				          	
				          }  
			         }); 
				}
				return;
			}
			if(state=='1'){
				open1(id,name,'pages/frame/menu/menuDeveloping_sj.jsp');
			}else if(state=='2'){
				open1(id,name,'pages/frame/menu/menuDeveloping_cx.jsp');
			}else if(state=='3'){
				open1(id,name,url);
			}else{
				open1(id,name,url);
			}
			
			$("#mBombWindowBtn").hide();
		}
	});

}

function open0(id,name,url){ 
	$.post('pages/frame/menu/menuAction.jsp?eaction=LoadLeftTreeSub',{id:id},function(data){
		SelectedMenuId = id;SelectedMenuLabel=name;SelectedMenuUrl=url;
		data = data.replace(/\r\n/g,'');
		data = data.replace(/(^\s*)|(\s*$)/g, "");
		if(data != null && data != ''){
			extnote = data;
			$("#mBombWindowBtn").show();
			$('#LeftMenu').tree('reload');
			$("#sider-bar").slideDown(600);
		}else{
			open1(id,name,url);
			$("#mBombWindowBtn").hide();
		}
	});
}
function openLeftTreeBaseState(id,name,url,state,type){
	$.post('pages/frame/menu/menuAction.jsp?eaction=LoadLeftTreeSub',{id:id},function(data){
		SelectedMenuId = id;SelectedMenuLabel=name;SelectedMenuUrl=url;
		data = data.replace(/\r\n/g,'');
		data = data.replace(/(^\s*)|(\s*$)/g, "");
		if(data != null && data != ''){
			extnote = data;
			showMenu();
			$('#LeftMenu').tree('reload');
		}else{
			$('#pageLayout').layout('remove','west');
			$('#retrunR_btn').hide();
			$('#retrunL_btn').hide();
			
			if (DefaultOpenPage != null && DefaultOpenPage != '' && DefaultOpenPage == '1') {
				return flase;
			}
			//判断是否弹出
			if(type == '3'){
				window.open(url,name, 'height=100%, width=100%, top=0,left=0, toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=yes, status=yes');
				return;
			}
			if(state=='1'){
				open1(id,name,'pages/frame/menu/menuDeveloping_sj.jsp',type);
			}else if(state=='2'){
				open1(id,name,'pages/frame/menu/menuDeveloping_cx.jsp',type);
			}else if(state=='3'){
				open1(id,name,url,type);
			}else{
				open1(id,name,url,type);
			}
			
		}
	});
}

function openLeftTree(id,name,url){
	$.post('pages/frame/menu/menuAction.jsp?eaction=LoadLeftTreeSub',{id:id},function(data){
		SelectedMenuId = id;SelectedMenuLabel=name;SelectedMenuUrl=url;
		data = data.replace(/\r\n/g,'');
		data = data.replace(/(^\s*)|(\s*$)/g, "");
		if(data != null && data != ''){
			extnote = data;
			showMenu();
			$('#LeftMenu').tree('reload');
		}else{
			$('#pageLayout').layout('remove','west');
			$('#retrunR_btn').hide();
			$('#retrunL_btn').hide();
			open1(id,name,url);
		}
	});
}
function unMenu(){
	$('#pageLayout').layout('remove','west');
	$('#retrunL_btn').hide();
	$('#retrunR_btn').show();
	return false;
}
/*
function showMenu(){
	$('#pageLayout').layout('remove','west');
	var region = 'west';
	var options = {
		region: region
	};
	options.width = 200;
	options.split = true;
	options.title = SelectedMenuLabel;
	//options.iconCls = 'icon-ok';
	options.href = 'pages/frame/FrameLeftTree.jsp?SelectedMenuId='+SelectedMenuId+'&MenuExpandLvl='+MenuExpandLvl;
	$('#pageLayout').layout('add', options);
	//$('#pageLayout').layout('panel','west').panel({title:SelectedMenuLabel});//新增
	//$('#pageLayout').layout('panel','west').panel({split:true});//新增
	$('#pageLayout').layout('panel','west').panel({onCollapse:unMenu});//新增
	//$.parser.parse($("#pageLayout"));
	//$('#LeftMenu').tree('reload');
	$('#retrunR_btn').hide();
	$('#retrunL_btn').show();
}
*/
function showMenu(){
	var west = $('#pageLayout').layout('panel','west');
	if(west.length>0){
		var url = 'pages/frame/FrameLeftTree.jsp?SelectedMenuId='+SelectedMenuId+'&MenuExpandLvl='+MenuExpandLvl;
		$('#pageLayout').layout('panel','west').panel({href : url});
		$('#pageLayout').layout('panel','west').panel({title : SelectedMenuLabel});
	} else {
		var region = 'west';
		var options = {
			region: region
		};
		options.width = 200;
		options.split = true;
		options.title = SelectedMenuLabel;
		options.href = 'pages/frame/FrameLeftTree.jsp?SelectedMenuId='+SelectedMenuId+'&MenuExpandLvl='+MenuExpandLvl;
		$('#pageLayout').layout('add', options);
	}
	$('#pageLayout').layout('panel','west').panel({onCollapse:unMenu});
	$('#retrunR_btn').hide();
	$('#retrunL_btn').show();
}
function tabSelect(title,index){
	currentId=$('#TabDiv').tabs("getSelected").panel("body").find("iframe").attr("id").substring(13);
}

function addTabs(id,tt,url){
	var $tabDiv = $('#TabDiv');
	var ROPageState = false;
	if(ReOpenPage != null && ReOpenPage == '1'){
		ROPageState = $tabDiv.tabs('exists',tt);
	}else{
		ROPageState = false;
	}
	if(ROPageState){
		$tabDiv.tabs("select",tt);
		$("#ContentIframe"+id).attr('src',url);
	}else{
		var closable = false;
		if(firstTabClosable == 'true'){
			closable = true;
		}else{
			closable = ($tabDiv.tabs("tabs").length>0);
		}
		;
		$tabDiv.tabs('add',{
			title:tt,
			content:'<iframe id="ContentIframe'+id+'" frameborder="0" width="100%" height="100%" src="'+url+'" style="position:relative"></iframe>',
			tools:[{
				iconCls:'icon-mini-refresh',
				handler:function(){
					$("#ContentIframe"+id).attr('src',$("#ContentIframe"+id).attr('src'));
					
				}
			}],
			//iconCls:icon,
			closable:closable
		});
		if(SysMenuType=='dropdown'){
			$("#ContentIframe"+id).css("height",($("#ContentIframe"+id).height()-31)+"px");
		}
		
	}
}
function open1(id,name,url,type){
	currentId = id; 
	$('#nav_span').text(name);
	
	//$("#sider-bar").slideUp(600);
	if(HiddenCurrentLocation != '1'){
		$("#sider-bar").slideUp(600);
	}
	
	var currentTabSize=$("iframe[id^='ContentIframe']").size();
	if(tabNums=='0'){
		$("#ContentIframe").attr('src',url);
	}else if(currentTabSize<tabNums){
			addTabs(id,name,url);
	}else{
		if($("iframe[id='ContentIframe"+id+"']")==null||$("iframe[id='ContentIframe"+id+"']").size()==0){
			$.messager.alert('系统提示','打开面过多，请关闭一些再打开新页！');   	
		}else{
			addTabs(id,name,url);
			
		}
	}
	
	if(url !=null && url !="" && url !='null'){
		var path = 'pages/ebuilder/usepage/common/CommonReportViewLogAction.jsp';
		var params = {};
		params.eaction = 'addViewLog';
		params.menuid = id;
		$.post(path,params,function(data){});
	}
	if(IsPortal=='1'){
		if(id!=null&&id!='')
		$.ajax({  
	          type : "post",  
	          url : 'pages/frame/log/logAction.jsp?eaction=writeSelectLog',  
	          data : {"menuName":name,"menuId":id},  
	          async : false,  
	          success : function(data){  
	          }  
         }); 
	}
}
$.parser.onComplete = function initHeight(){
	if(is1024) {
		fixedScreen();
	}else{
		fullScreen();
	}
}
$(function(){
	alert(ForceChangePasswordDayNum+"------"+CurrentUserDayNum);
	if(ForceChangePasswordDayNum!=0&&CurrentUserDayNum>=ForceChangePasswordDayNum){
		$(".panel-tool-close").css("display","none");
		$("#updPwdLoad").load("pages/frame/user/UpdatePwd.jsp",{},function(){
			$("#pwd_old").validatebox();
			$("#pwd_new").validatebox();
			$("#pwd_new_a").validatebox();
			$("#updPwdDialog").dialog('open');
		});
	}
	$('#retrunR_btn').hide();
	if (SysScreenType == 'wide') {
		fullScreen();
	} else {
		fixedScreen();
	}
	//document.oncontextmenu = function(e){ return false; }//禁止鼠标右键菜单
	getStatus();
	setInterval(getStatus, 300000);
	//当菜单为TREE形式时，默认打开
	if(SysMenuType !=null && SysMenuType != '' && SysMenuType =='tree'){
		openLeftTreeBaseState(firstPageMenuId, FirstPageMenuName, FirstPageMenuUrl,FirstPageMenuState);
	}
	if (DefaultOpenPage != null && DefaultOpenPage != '' && DefaultOpenPage == '1') {//是否默认打开页面
		addTabs(currentId, SelectedMenuLabel, SelectedMenuUrl);
	}
	$('#LeftMenu').tree({
		checkbox: false,
		url:'pages/frame/menu/menuAction.jsp?eaction=LoadLeftTree&pid='+SelectedMenuId,
		onClick:function(node){
			var url = node.attributes.url;
			if(url != null && url != '' && url != 'null'){
				if(node.attributes.menuState=='1'){
					open1(node.id,node.text,'pages/frame/menu/menuDeveloping_sj.jsp');
				}else if(node.attributes.menuState=='2'){
					open1(node.id,node.text,'pages/frame/menu/menuDeveloping_cx.jsp');
				}else if(node.attributes.menuState=='3'){
					open1(node.id,node.text,node.attributes.url);
				}else{
					open1(node.id,node.text,node.attributes.url);
				}
				
			}else{
				var isleaf = $(this).tree('isLeaf',node.target);
				if(!isleaf){
					$(this).tree('toggle',node.target);
				}
			}
		},
		onExpand:function(node){
			var parentNode=$(this).tree('getParent',node.target);
			var childrenNode=null;
			if(parentNode!=null){
				childrenNode=$(this).tree('getChildren',parentNode.target);
			}else{
				childrenNode=$(this).tree('getRoots',node.target);
				
			}
			if(childrenNode!=null){
				for(var i=0;i<childrenNode.length;i++){
					if(childrenNode[i].id!=node.id){
						$(this).tree('collapse',childrenNode[i].target);
					}
				}
			}
		},
		onBeforeLoad: function(node, param){
			$(this).tree('options').url = 'pages/frame/menu/menuAction.jsp?eaction=LoadLeftTree&pid='+SelectedMenuId;
		},
        onLoadSuccess:function (node, data){
	        if(node == null || node == ''){
				var fnode = $('#LeftMenu').tree('find', extnote);
				if(fnode != null && fnode !=''){
					if(fnode.target != null && fnode.target !=''){
						if(MenuExpandLvl != null && MenuExpandLvl !='' && MenuExpandLvl =='1'){//是否打开全部菜单层级
							$('#LeftMenu').tree('expand', fnode.target);
						}else{
							$('#LeftMenu').tree('expandAll', fnode.target);
						}
					}
				}
	    	}else{
	    		if(MenuExpandLvl != null && MenuExpandLvl !='' && MenuExpandLvl =='1'){
					$('#LeftMenu').tree('expand', node.target);
				}else{
					$('#LeftMenu').tree('expandAll', node.target);
				}
	    	}
    	}
	});
	
	$("#sider-bar").mouseleave(function(){
		//$("#sider-bar").slideUp();
		if(HiddenCurrentLocation != '1'){
			$("#sider-bar").slideUp();
		}
	});
	
	$(".scroller-left").click(function(){
		var topmenu = $("#nav-menu").get(0);
		if(poor==0){
			scroll = 0;
			poor = topmenu.scrollWidth - $(topmenu).width();
		}
		scroll = scroll - 50;
		if(scroll >= 0){
			$(topmenu).scrollLeft(scroll);
		}else{
			scroll = 0;
			$(topmenu).scrollLeft(scroll);
		}
	});
	
	$(".scroller-right").click(function(){
		var topmenu = $("#nav-menu").get(0);
		if(poor==0){
			scroll = 0;
			poor = topmenu.scrollWidth - $(topmenu).width();
		}
		scroll = scroll + 50;
		if(scroll <= poor){
			$(topmenu).scrollLeft(scroll);
		}else{
			scroll = poor;
			$(topmenu).scrollLeft(scroll);
		}
	});
	
	$(".favoritesWindowBtn02").click(function(){
		$("#favoritesWindow").slideDown(300);
		$("#favoritesWindow ul li a").click(function(){
			$("#favoritesWindow").slideUp();
		})
		$("#favoritesWindow").mouseleave(function(){
			$("#favoritesWindow").slideUp();
		});
	});
	
	$(".jumpY").click(function(){
		var headHeight = 61;
		if(SysMenuType=='dropdown'){
			headHeight=31;
			$("iframe[id^='ContentIframe']").each(function(i,e){
				$(this).height($(e).height()+25);
			});
		}
		$('#container').layout('panel', 'north').panel('resize',{height:headHeight});
        $('#container').layout('resize');
		$("#globalMenu").addClass('globalMenu_Change');
		$(".localTimeOuter").addClass('localTimeOuter_Change');
		$("#header-content").addClass('header-content_Change');
		$("h1").hide();$(this).hide();$('.jumpY_').show();
		rePosition();
	})
	
	$(".jumpY_").click(function(){
		var headHeight = 91;
		if(SysMenuType=='dropdown'){
			headHeight=61;
			$("iframe[id^='ContentIframe']").each(function(i,e){
				$(this).height($(e).height()-25);
			});
		}
		$('#container').layout('panel', 'north').panel('resize',{height:headHeight});
        $('#container').layout('resize');
		$("#globalMenu").removeClass('globalMenu_Change');$(".localTimeOuter").removeClass('localTimeOuter_Change');$("#header-content").removeClass('header-content_Change');$("h1").show();$(this).hide();$('.jumpY').show();
		rePosition();
	});
	
	$(".fullBtn").click(function(){
	  	$(this).hide();$('.fullBtn_k').show();
	})
	
	$(".fullBtn_k").click(function(){
		$(this).hide();$('.fullBtn').show();
	})
	
	$("#mBombWindowBtn").click(function(){
		var $siderBar = $("#sider-bar");
		if($siderBar.is(":hidden")){
			$siderBar.slideDown(600);
		}else{
			$siderBar.slideUp(600);
		}
	});
	
	$("#frame_logout").bind("click", function(){
		if(!CanLoginOutFlag){
			$.messager.alert('系统提示','请稍候，页面还没有加载成功！');
			return false;
		}
	   	if(confirm('您是否退出系统?')){
	   		if(IsPortal==''||IsPortal=='null'||IsPortal=='0'){
	   			window.location.href= ContextPathJs+'/logout.e';
				window.event.returnValue = false;    
	   		}else if(IsPortal=='1'){
	   			$.ajax({  
				      type : "post",  
				      url : ContextPathJs+'/logoutForReturn.e',  
				      data : {},  
				      async : false,  
				      success : function(data){  
				      	if(data=='1'){
				      		clearCookie();//清除Cookie
					      	window.location.href=LoginOutPortalUrl;
							window.event.returnValue = false; 
						}
				      }  
			    }); 
	   			   
	   		}
	 		
	 	}
	});
	function clearCookie(){ 
		var keys=document.cookie.match(/[^ =;]+(?=\=)/g); 
		if (keys) { 
			for (var i = keys.length; i--;) 
				document.cookie=keys[i]+'=0;expires=' + new Date( 0).toUTCString() 
		} 
	} 
	
	
	$("#frame_mpwd").bind("click", function(){
		$("#updPwdLoad").load("pages/frame/user/UpdatePwd.jsp",{},function(){
			$("#pwd_old").validatebox();
			$("#pwd_new").validatebox();
			$("#pwd_new_a").validatebox();
			$("#updPwdDialog").dialog('open');
		});
	});
	
	$("#frame_notice").bind("click", function(){
		var d = new Date();
		$.get('pages/frame/notice/NoticeAction.jsp?eaction=message&curd='+d.getTime(),function(data){
			data = data.replace(/\r\n/g,'');
			data = data.replace(/(^\s*)|(\s*$)/g, "");
			if(data && data != null && data != 'null'){
				var post_id = '';
				if($.trim(data)!=''&&typeof($.evalJSON(data).POST_ID)!='undefined'){
					data = $.evalJSON(data);
					post_id = data.POST_ID;
				}else{
					post_id = '';
				}
				if(window.navigator.userAgent.indexOf("Chrome") !== -1) {
					window.open(appName+'/pages/frame/notice/NoticeHome.jsp?post_id='+post_id);
				}else{
					window.showModalDialog(appName+'/pages/frame/notice/NoticeHome.jsp?post_id='+post_id,window,'dialogWidth=800px;dialogHeight=400px;center:yes;help:no;scroll:yes;status:no;resizable:no;minimize:no;maximize:no;location:no');
				}
			}else{
			    if(window.navigator.userAgent.indexOf("Chrome") !== -1) {
			    	window.open(appName+'/pages/frame/notice/NoticeHome.jsp?post_id='+data);
			    }else {
			    	window.showModalDialog(appName+'/pages/frame/notice/NoticeHome.jsp?post_id=','dialogWidth=800px;dialogHeight=400px;center:yes;help:no;scroll:yes;status:no;resizable:no;minimize:no;maximize:no;location:no');
			    }
			}
		});
		
	});
	
	function showNotice(){
		var d = new Date();
		$.get('pages/frame/notice/NoticeAction.jsp?eaction=day_notice&curd='+d.getTime(),function(data){
			data = data.replace(/\r\n/g,'');
			data = data.replace(/(^\s*)|(\s*$)/g, "");
			if(data!='0'){
				if(window.navigator.userAgent.indexOf("Chrome") !== -1) {
					window.open(appName+'/pages/frame/notice/NoticeHome.jsp?post_id='+data);
				}else{
					window.showModalDialog(appName+'/pages/frame/notice/NoticeHome.jsp?post_id='+data,window,'dialogWidth=800px;dialogHeight=400px;center:yes;help:no;scroll:yes;status:no;resizable:no;minimize:no;maximize:no;location:no');
				}
			}
			CanLoginOutFlag=true;
		});
	}
	
	setTimeout(showNotice,3000);
	$("#frame_ind").bind("click",function(){
		if(window.navigator.userAgent.indexOf("Chrome") !== -1) {
			window.open(appName+'/pages/frame/menuind/showInd.jsp?menuId='+currentId);
		}else{
			window.showModalDialog(appName+'/pages/frame/menuind/showInd.jsp?menuId='+currentId,'','dialogWidth=800px;dialogHeight=400px;center:yes;help:no;scroll:yes;status:no;resizable:no;minimize:no;maximize:no;location:no');
		}
	});
	
	$("#user_pred").bind("click", function(){
		$("#predLoad").load("pages/frame/collect/userPred.jsp",{},function(){ 
			$("#predDialog").dialog('open');
		});
	});
	
	$("#open_collect").bind("click", function(e){
		$("#favoritesWindow").load("pages/frame/collect/CollectList.jsp",{},function(){
			$('#favoritesWindow').css({top:(e.pageY+15)});
			$('#favoritesWindow').show();
			$("#insert_collect").linkbutton();
		});
	});
	
	//管理员点击绑定
	$("#frame_manager").click(function(e){
		$("#managerWindow").slideDown(300);
		
		$("#managerWindow ul li a").click(function(){
			$("#managerWindow").slideUp();
		})
		$("#managerWindow").mouseleave(function(){
			$("#managerWindow").slideUp();
		});
	});
	$("#frame_manager").bind("click", function(e){
		   $('#managerWindow').css({top:(e.pageY+15)});
		   $('#managerWindow').show();
	});
	
	//搜索栏绑定复选框
	$("#frame_serach").click(function(){
		$("#searchWindow").slideDown(300);
		$("#searchWindow ul li a").click(function(){
			$("#searchWindow").slideUp();
		})
		$("#searchWindow").mouseleave(function(){
			$("#searchWindow").slideUp();
		});
	});
	
	
	$("#frame_serach").bind("click", function(e){
	   $('#searchWindow').css({top:(e.pageY+15),left:(e.pageX-35)});
	   $('#searchWindow').show();
	});
	
});
/*移动的左侧按钮*/
$(function(){
	var _move=false;//移动标记
var _x,_y;//鼠标离控件左上角的相对位置
$(document).ready(function(){
    $(".move-btn").mousedown(function(e){
        _move=true;
       // _x=e.pageX-parseInt($(".move-btn").css("left"));
        _y=e.pageY-parseInt($(".move-btn").css("top"));
        $(".move-btn").fadeTo(20, 0.25);//点击后开始拖动并透明显示
    });
    $(document).mousemove(function(e){
        if(_move){
           // var x=e.pageX-_x;//移动时根据鼠标位置计算控件左上角的绝对位置
            var y=e.pageY-_y;
            $(".move-btn").css({top:y});//控件新位置
        }
    }).mouseup(function(){
    _move=false;
    $(".move-btn").fadeTo("fast", 1);//松开鼠标后停止移动并恢复成不透明
  });
});

	})