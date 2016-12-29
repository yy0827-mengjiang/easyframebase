<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>找回密码</title>
		<meta http-equiv="pragma" content="no-cache" />
		<meta http-equiv="cache-control" content="no-cache" />
		<e:script value="/resources/component/jquery/jquery-1.8.0.min.js" />
		<script language="javascript">
			var baseUrl = '<%=basePath%>';
			var currentLocalHref=window.location.href;
			currentLocalHref = currentLocalHref.replace(/%3A/g,':');
			currentLocalHref = currentLocalHref.replace(/%2F/g,'/');
			
			//输入手机号码验证
			function checkform() {
				$("#checkResult").html('');
				var checkResultMes = '*请您输入正确的手机号码!否则将无法通过此功能找回密码*';
				var findPwdNumber = $('#findPwdNumber').val();
				if(findPwdNumber.length!=11) {   
				//验证手机号为11位
					 $("#checkResult").html(checkResultMes);
					 return false;
				}
				var regExp=/^1[3|4|5|7|8][0-9]\d{4,8}$/;
				var my=false;
				if (regExp.test(findPwdNumber))my=true;
			  
				if (!my){
					$("#checkResult").html(checkResultMes);
					 return false;
				}
				return true;
			}
			
			var url = baseUrl+"pages/frame/findPwdAction.jsp";			
			
			//验证输入的手机号是否存在
			function getRand(){
				if(checkform()){
					var findPwdNumber = $('#findPwdNumber').val();
					if(confirm('是否确认执行找回工号[' + findPwdNumber + ']的密码操作?')){						
						var url2 = url+"?eaction=queryForId&id="+findPwdNumber;
						$.post(url2,null,checksum);
					}
				}
			}
			//判断手机号当天重置次数
			function checksum(checksumtext){
				var cou=parseInt(checksumtext);
				var findPwdNumber = $('#findPwdNumber').val();
				if(cou>0){
					var url2 = url+"?eaction=checksum&id="+findPwdNumber;		
					$.post(url2,null,getRand2);
				}else{
					alert('您要操作的工号[' + findPwdNumber + ']不存在，或者已锁定停用!');
				}
			}
			//如果手机号存在则发送验证码
			function getRand2(checkformtext){
				var cou=parseInt(checkformtext);
				var findPwdNumber = $('#findPwdNumber').val();
				if(cou<1){
					var url2 = url+"?eaction=forwordRand&id="+findPwdNumber;		
					$.post(url2,null,forwordRand);
				}else{
					alert('您要操作的工号[' + findPwdNumber + ']重置次数过多，今日不能再重置!');
				}
			}
			//检查发送验证码操作结果
			function forwordRand(text){
				var tex=$.trim(text);
				if(tex=='操作成功'){
					alert('验证码信息已经成功发送至您的手机!');
				}else{
					alert('获取验证码操作失败,请重新操作!');
				}
			}
			
			//验证输入的验证码是否正确，
			function forwordcxc(){
				var findPwdNumber = $('#findPwdNumber').val();
				var findPwdRand = $('#findPwdRand').val();	
				if(findPwdRand==""){
					alert('请输入接收到的验证码!');
					return;
				}
				var url2 = url+"?eaction=queryRandForId&id="+findPwdNumber+"&findPwdRand="+findPwdRand;					
				$.post(url2,null,updatePwd);
			}
			
			
			function updatePwd(text){
				alert($.trim(text));
			}
			
			

		
		</script>
	</head>
	<style>
	*{ margin:0; padding:0; list-style:none;}
	a { text-decoration:none; color:#333;}
	span { display:block; line-height:1.7; padding:5px;}
	.findPassword {  width:500px; position:absolute; left:50%; margin-left:-249px; top:50%; margin-top:-80px; background:#f9f9f9 url("iconFindPwd.png") 340px 45px no-repeat; border:1px solid #ccc;}
	.findPassword h2 { background:#0080ff; color:#fff; line-height:30px; padding:0 10px; font-size:14px;}
	.findPassword input { background:#fff; border:1px solid #ccc; margin-right:10px;}
	.findPassword ul { padding:0 10px;}
	.findPassword ul li {font-size:12px; padding:5px 0;}
	.findPassword p { color:#c00; font-size:12px;}
	.findPassword p.ClickBtn { text-align:center; margin:10px auto;}
	</style>
	<body style=" background:#fff;">
		<!--DWLayoutTable-->
		<form action="" method="post" name="loginForm" id="loginForm">
			<div class="findPassword">
				<h2>找回密码</h2>
				<p><span id="checkResult"></span> <span id="info"></span></p>
				<ul>
					<li><input type="text" id="findPwdNumber" name="findPwdNumber" size="15" maxlength="11" onBlur="checkform();" onkeyup="value=this.value.replace(/\D+/g,'')">要找回密码的手机号</li>
					<li><input type="text" id="findPwdRand" name="findPwdRand" size="15" maxlength="8">请输入收到的验证码</li>
				</ul>
				<p class="ClickBtn">
					<a href="javascript:void(0)" plain="true" onclick="getRand();"><font style="color:#ff0000">点击获取验证码</font></a>
					&nbsp;&nbsp;
					<a href="javascript:void(0)" plain="true" iconCls="icon-redo" onclick="forwordcxc();">下一步</a>
				</p>
			</div>
		</form>
	</body>
</html>