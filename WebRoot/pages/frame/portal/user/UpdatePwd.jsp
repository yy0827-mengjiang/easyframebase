<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>修改密码</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<script type="text/javascript">
			$(function(){
				$.extend($.fn.validatebox.defaults.rules, {
				     eq: {
				         validator: function(value, param){
				         var temp = $(param[0]).val();
				         if(temp == '' || temp == null){
				         	return true;
				         }
						 return value==temp;
				         },
				     message: '两次新密码不相同！'
				     }
				 });
				$.extend($.fn.validatebox.defaults.rules, {
				     length: {
				         validator: function(value, param){
						 return value.length>=param[0];
				         },
				     message: '密码长度不能小于{0}'
				     }
				 });
				 $('#updPwdForm').form({  
					url:"<e:url value='/updPwd.e'/>",
				    onSubmit: function(){  
				        return $(this).form('validate');
				    },  
				    success:function(data){
				      if(data=="SUCCESS"){
				      	$.messager.alert("提示信息","密码修改成功","info");
				      	$("#updPwdDialog").dialog("close");
				      }else if(data=="FAIL"){
				      	$.messager.alert("提示信息","密码修改失败！","error");
				      }else if(data=="NOTEQ"){
				      	$.messager.alert("提示信息","两次密码输入不一致！","error");
				      }else if(data=="NOTOLD"){
				      	$.messager.alert("提示信息","原始密码不正确！","error");
				      }
				    }  
				}); 
			});
			function updPwd(){
				$("#updPwdForm").submit();
			}
			function resetPwd(){
				$("#updPwdForm").form('reset');
			}
		</script>
	</head>
	<body style="background-color: #F2F5F7;overflow: hidden;">
		<form id="updPwdForm" action="" method="post">
			<table style="width:380px;height:150px;" border="0" cellspacing="8" cellpadding="0">
				<tr>
					<td align="right">原密码：</td>
					<td>
						<input id="pwd_old" name="pwd_old" type="password"  class="easyui-validatebox" required="true">
					</td>
				</tr>
				<tr>
					<td align="right">新密码：</td>
					<td>
						<input id="pwd_new" name="pwd_new" type="password"  class="easyui-validatebox" required="true"  validType="length[6]">
					</td>
				</tr>
				<tr>
					<td align="right">重复新密码：</td>
					<td>
						<input id="pwd_new_a" name="pwd_new_a" type="password"  class="easyui-validatebox" required="true" validType="eq['#pwd_new']">
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>