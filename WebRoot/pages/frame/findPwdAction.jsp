<%@ page language="java" import="java.util.*,java.security.MessageDigest,cn.com.easy.ext.MD5" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<%
int pwd_len = 8;
// 35是因为数组是从0开始的，26个字母+10个数字
final int maxNum = 36;
int i; // 生成的随机数
int count = 0; // 生成的密码的长度
char[] str = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k',
'm', 'n', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w',
'x', 'y', 'z', '2', '3', '4', '5', '6', '7', '8', '9' };

StringBuffer pwd = new StringBuffer("");
Random r = new Random();
while (count < pwd_len) {
// 生成随机数，取绝对值，防止生成负数，

i = Math.abs(r.nextInt(maxNum)); // 生成的数最大为36-1

if (i >= 0 && i < str.length) {
pwd.append(str[i]);
count++;
}
}
String yanzheng_code = pwd.toString();  //随机验证码

//生成随机密码
int length = 8;
String base = "abcdefghijkmnpqrstuvwxyz23456789";   
Random random = new Random();   
StringBuffer sb = new StringBuffer();   
for (int j = 0; j < length; j++) {   
    int number = random.nextInt(base.length());   
    sb.append(base.charAt(number));   
}   
String random_pwd = sb.toString(); //未加密前的随机密码

//System.out.println("random_pwd::  "+random_pwd);
String pwd_new = "";  //新密码
String is_encrypt = (String)request.getSession().getServletContext().getAttribute("PwdEncrypt");
if(is_encrypt.equals("1")){
	pwd_new = MD5.MD5Crypt(random_pwd);
} else if(is_encrypt.equals("2")){
	pwd_new = MD5.byte2hex(random_pwd.getBytes());
} else if(is_encrypt.equals("0")){
	pwd_new = random_pwd;
}

//
String ip = request.getHeader("x-forwarded-for");
if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
	ip = request.getHeader("Proxy-Client-IP");
}
if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
	ip = request.getHeader("WL-Proxy-Client-IP");
}
if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
	ip = request.getRemoteAddr();
}
if (ip != null && ip.equals("0:0:0:0:0:0:0:1"))
	ip = "127.0.0.1";
%>
<e:switch value="${param.eaction}">
	<e:case value="queryForId">
		<e:description>查询帐号是否存在</e:description>
		<e:q4o var="_login_id_item" sql="frame.findpwd.queryForId"/>${_login_id_item.COU }
	</e:case>
	<e:case value="checksum">
		<e:description>查询帐号当日重置次数是否大于5次</e:description>
		<e:q4o var="_login_id_sum" sql="frame.findpwd.checksum"/>${_login_id_sum.COU }
	</e:case>	
	<e:case value="forwordRand">
		<e:description>获取修改密码的验证码</e:description>
		<e:q4o var="var_msg_id" sql="frame.findpwd.var_msg_id"/>
		<e:set var="yanzheng_code" value="<%=yanzheng_code %>"></e:set>
		<e:update sql="frame.findpwd.inSMS"/>
		<e:update sql="frame.findpwd.delRANDCODE"/>
		<e:set var="ip" value="<%=ip %>"></e:set>
		<e:update sql="frame.findpwd.inRANDCODE"/>
		<e:update sql="frame.findpwd.inlog"/>操作成功
	</e:case>

	
	<e:case value="queryRandForId">
		<e:description>查询当前验证码是否正确</e:description>
		<e:q4o var="_login_id_t" sql="frame.findpwd._login_id_t"/>
		
		<e:if condition="${_login_id_t.COU>0}">
			<e:set var="pwd_new" value="<%=pwd_new %>"></e:set>
			<e:update var="up1" sql="frame.findpwd.up1"/>
			<e:set var="random_pwd" value="<%=random_pwd %>"></e:set>
			<e:update var="up2" sql="frame.findpwd.up2"/>
			  <e:if condition="${up1>0&&up2>0}" var="upIf">
			     新的密码已经发送到您的手机，请使用新密码登陆并及时修改密码!
			  </e:if>
			  <e:else condition="${upIf}">
			     修改密码错误，请联系管理员!
			  </e:else>
		</e:if>
		<e:if condition="${_login_id_t.COU==0}">
		     验证码不正确
		</e:if>
	</e:case>
	
	
	<e:case value="queryErrNum">
		<e:if condition="{param.addFlag==1}">
			<e:update sql="frame.findpwd.ERR_INFO"/>
		</e:if>
		<e:q4o var="E_USER" sql="frame.findpwd.E_USER"/>
		<e:if condition="${isFrezenObj.FLAG==0}">
			<e:q4o var="errNumObj" sql="frame.findpwd.errNumObj0"/>
		</e:if>
		<e:if condition="${isFrezenObj.FLAG!=0}">
			<e:q4o var="errNumObj" sql="frame.findpwd.errNumObj1"/>
		</e:if>
		${errNumObj.ERR_NUM }
	</e:case>	
</e:switch>	