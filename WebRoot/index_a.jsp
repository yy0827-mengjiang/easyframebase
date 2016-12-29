<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" class="boncEntryPage">
<head>
<a:base/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<e:style value="/resources/themes/base/boncBase@links.css"/>
<e:style value="/resources/themes/blue/boncBlue.css"/>
<c:resources type="easyui"  style="${ThemeStyle }"/>
<script type="text/javascript" src="<e:url value="resources/themes/base/js/common.js"/>"></script>
<title>${applicationScope["SysTitle"] }</title>
<script language="JavaScript">

	(function($){   
    $.fn.extend({     
         yx_rotaion: function(options) {   
		    //默认参数
            var defaults = {
			     /**轮换间隔时间，单位毫秒*/
                 during:3000,
				 /**是否显示左右按钮*/
                 btn:true,
				 /**是否显示焦点按钮*/
                 focus:true,
				 /**是否显示标题*/
                 title:true,
				 /**是否自动播放*/
                 auto:true				 
            }        
            var options = $.extend(defaults, options);   
            return this.each(function(){
			    var o = options;   
				var curr_index = 0;
                var $this = $(this);				
                var $li = $this.find("li");
                var li_count = $li.length;
				$this.css({position:'relative',overflow:'hidden',width:$li.find("img").width(),height:$li.find("img").height()});
				$this.find("li").css({position:'absolute',left:0,top:0}).hide();
			    $li.first().show();
			    $this.append('<div class="yx-rotaion-btn"><span class="left_btn"><\/span><span class="right_btn"></span><\/div>');
				if(!o.btn) $(".yx-rotaion-btn").css({visibility:'hidden'});
                if(o.title) $this.append(' <div class="yx-rotation-title"><\/div><a href="" class="yx-rotation-t"><\/a>');
                if(o.focus) $this.append('<div class="yx-rotation-focus"><\/div>');
				var $btn = $(".yx-rotaion-btn span"),$title = $(".yx-rotation-t"),$title_bg = $(".yx-rotation-title"),$focus = $(".yx-rotation-focus");
				//如果自动播放，设置定时器
				if(o.auto) var t = setInterval(function(){$btn.last().click()},o.during);
                $title.text($li.first().find("img").attr("alt"));	
				$title.attr("href",$li.first().find("a").attr("href"));				
				
               // 输出焦点按钮
               for(i=1;i<=li_count;i++){
                 $focus.append('<span>'+i+'</span>');
               }
               // 兼容IE6透明图片   
               if($.browser.msie && $.browser.version == "6.0" ){
                  $btn.add($focus.children("span")).css({backgroundImage:'url(images/ico.gif)'});
               }		
               var $f = $focus.children("span");
               $f.first().addClass("hover");
               // 鼠标覆盖左右按钮设置透明度
               $btn.hover(function(){
	              $(this).addClass("hover");
               },function(){
	              $(this).removeClass("hover");
               });
			   //鼠标覆盖元素，清除计时器
               $btn.add($li).add($f).hover(function(){
                if(t) clearInterval(t);
               },function(){
                if(o.auto) t = setInterval(function(){$btn.last().click()},o.during);
               });
			   //鼠标覆盖焦点按钮效果
               $f.bind("mouseover",function(){
	             var i = $(this).index();
	             $(this).addClass("hover");
	             $focus.children("span").not($(this)).removeClass("hover");
	             $li.eq(i).fadeIn(300);
                 $li.not($li.eq(i)).fadeOut(300);	
	             $title.text($li.eq(i).find("img").attr("alt"));
	             curr_index = i;
               });
			   //鼠标点击左右按钮效果
               $btn.bind("click",function(){
                 $(this).index() == 1?curr_index++:curr_index--;
	             if(curr_index >= li_count) curr_index = 0;
	             if(curr_index < 0) curr_index = li_count-1;
                 $li.eq(curr_index).fadeIn(300);
	             $li.not($li.eq(curr_index)).fadeOut(300);	
	             $f.eq(curr_index).addClass("hover");
	             $f.not($f.eq(curr_index)).removeClass("hover");
	             $title.text($li.eq(curr_index).find("img").attr("alt"));
				 $title.attr("href",$li.eq(curr_index).find("a").attr("href"));	
               });
 
            });   
        }   
    });   
       
})(jQuery);

	if (self!=top){top.location=window.location;}
	$(function(){
			Base.___contentPath =  Base._getContextPath();
			var ContextPathJs = Base.___contentPath;
			console.log(ContextPathJs + '<e:url value="/pages/frame/portal/user/UserEdit.jsp"/>');
		$('input').each(function(){
			if(this.tabIndex==1){
				this.focus();
				return false;
			}
		});
		//		获取提示信息
		var message_code= '<%=request.getAttribute("LoginMsg_code")%>';
		if(message_code!=''&&message_code!="null"){
			$("#code_p").show();
			$("#validNum").focus();
		}
		var message_user= '<%=request.getAttribute("LoginMsg_user")%>';
		if(message_user!=''&&message_user!='null'){
			$("#user_p").show();
		}
		$("#reloadCode").click(function(){
			$("#codeImg").attr("src","pages/frame/validNum.jsp?random="+(new Date()).getTime());
		});
		$("#findPwd").click(function(){
			window.open("pages/frame/findPwd.jsp");
		});
		$("body").keydown(function(event){
			if(event.which==13){
				$('#formid').submit();
			}
        });
        
        $(".yx-rotaion").yx_rotaion({auto:true});
	});
	
	//焦点图切换
	


</script>
</head>
<body>
<div class="boncEntryArea tabLogin">
	<div class="EntryHead">
		<h1>中国电信</h1>
		<h2><img src="resources/themes/base/images/boncLayout/img/titSystemEntryXbulider02.png" alt="XBuilder智能构建平台" /></h2>
	</div>
	
	<div class="EntryCon">
		<form action="login.e" method="post" id="formid">
		<div class="loginCenter">
		<div class="yx-box">
			<div class="yx-rotaion">
		<ul class="rotaion_list">
			<li><img src="resources/themes/base/images/boncLayout/img/1.jpg" alt="图片信息1"></li>
			<li><img src="resources/themes/base/images/boncLayout/img/2.jpg" alt="图片信息2"></li>
			<li><img src="resources/themes/base/images/boncLayout/img/3.jpg" alt="图片信息3"></li>
		</ul>
	</div>
	</div>
			<div class="EntryGroup">
				<fieldset>
					<div class="EntryBox">
						<div class="EntryGroupLine">
							<span class="iconUser"></span>
							<input type="text" name="user" value="${requestScope.loginName}" tabindex="1" placeholder="请输入用户名" />
						</div>
						<%
	//	获取提示信息
	 String message_code = (String)request.getAttribute("LoginMsg_code");
	 if(message_code==null){
		 message_code=" ";
	 }
	 String message_user = (String)request.getAttribute("LoginMsg_user");
	 if(message_user==null){
		 message_user=" ";
	 }
	 //System.out.println("111---"+message_code);
	%>
		
					</div>
					
					<div class="EntryBox">
						<div class="EntryGroupLine">
							<span class="iconPassword"></span>
							<input type="password" value="${requestScope.loginPwd}" name="pwd"  placeholder="请输入密码" />
						</div>
					</div>
					
					<div class="EntryBox">
						<div class="EntryGroupLine EntryGroupLineO">
							<span class="iconCode"></span>
							<input type="text" id="validNum" name="validNum" value="" placeholder="验证码" class="formCode" />
						</div>
						<img id="codeImg" class="imgCode" src="pages/frame/validNum.jsp" />
						<a href="javascript:void(0)" class="btnCode" id="reloadCode">换一张</a>
					</div>
				</fieldset>
				<div class="boncLogin_check" >
					<p id="code_p" class="hide"><%=message_code%></p>
					<p id="user_p" class="hide"><%=message_user%></p>
				</div>
				<div class="btnSubmit"><a href="javascript:void(0)" onclick="javascript:document.getElementById('formid').submit();">登&nbsp;&nbsp;录</a></div>
				<div class="btnSubmit"><a href="javascript:void(0)" id="findPwd" class="find" onclick="findPwd()">忘记密码?</a></div>
			</div>
			</div>
		</form>	
	</div>
	<div class="EntryFoot">中国电信股份有限公司云计算分公司</div>
</div>
</body>
</html>
