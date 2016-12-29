<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" class="boncEntryPage">
<head>
<a:base/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<c:resources type="easyui" />
    <!--声明以IE最高版本浏览器内核或谷歌浏览器内核进行渲染 -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <!--声明以360极速模式进行渲染 -->
    <meta name=”renderer” content=”webkit” />
    <!--系统名称文本 -->
    <title>终端指标分析系统－登录${applicationScope["SysTitle"] }</title>
    <!-- 系统ICON图标（注:路径为TomCat根目录） -->
    <link rel ="Shortcut Icon" href="" />

    <!-- 独立Js脚本 -->
    <script type="text/javascript" src='<e:url value="/pages/terminal/resources/themes/base/js/boncCommon.js"/>'></script>
    <!-- 独立Css层叠样式表 -->
    <e:style value="/pages/terminal/resources/themes/base/boncBase@links.css"/>
	<script language="JavaScript">
	if (self!=top){top.location=window.location;}
	$(function(){
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
	});
</script>
</head>
<body>
<div id="boncEntry">
	<div class="cd-auto-hide-header">
		<div class="topShow">
			<div class="logo">
				<a href="#this">
					<img src='<e:url value="/pages/terminal/resources/themes/base/images/boncLayout/bg/boncFrameLogo.png"/>' alt="logo">
					<span>终端指标分析系统</span>
				</a>
			</div>
		</div>
	</div>

	<div class="EntryCon">
		<form action="login.e" method="post" id="formid">
			<div class="EntryGroup">
				<p>欢迎登录</p>
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
						<!-- <img id="codeImg" class="imgCode" src='<e:url value="/pages/terminal/resources/themes/base/images/boncLayout/img/imgCode.gif"/>' /> -->
						<img id="codeImg" class="imgCode" src='<e:url value="/pages/frame/validNum.jsp"/>' />
						<a href="javascript:void(0)" class="btnCode" id="reloadCode">换一张</a>
					</div>
				</fieldset>
				<div class="btnSubmit"><a href="javascript:void(0)" class="submit" onclick="javascript:document.getElementById('formid').submit();">登&nbsp;&nbsp;录</a></div>
				<div class="boncLogin_check" >
					<p id="code_p"><%=message_code%></p>
					<p id="user_p"><%=message_user%></p>
				</div>
				<!-- 
				<div class="btnSubmit"><a href="javascript:void(0)" id="findPwd" class="find" onclick="findPwd()">忘记密码?</a></div>
				 -->
			</div>
		</form>	
	</div>
	<div class="EntryFoot">中国电信股份有限公司云计算分公司</div>
</div>
</body>
</html>
