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
				 $('#updPwdForm').form({  
					url:"<e:url value='/updPwd.e'/>",
				    onSubmit: function(){  
				    	if($.trim($("#pwd_old").val())==$.trim($("#pwd_new").val())){
				    		$.messager.alert("提示信息","原密码与新密码不可以相同！","error");
				    		return false;
				    	}
				    	
				        return $(this).form('validate');
				    },  
				    success:function(data){
				      if(data=="SUCCESS"){
				      	$.messager.alert("提示信息","密码修改成功","info");
				      	$("#updPwdDialog").dialog("close");
				      	$(".panel-tool-close").css("display","");
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
		<e:if condition="${applicationScope.CheckChangePasswordRule=='1'}">
			<script type="text/javascript">
				$(function(){
					$.extend($.fn.validatebox.defaults.rules, {
					      length: {
					         validator: function(value, param){
					         	var strnumExp = new RegExp(/([!,@,#,$,%,^,&,*,?,_,~])/);
								var strExp = new RegExp(/([a-zA-Z])/);
								var numExp = new RegExp(/([0-9])/);
					            return (strnumExp.test(value)&& strExp.test(value)&&$(param[0]).val()!=value&&numExp.test(value)&&value.length>=8);
					         },
					     message: '新密码必须为8位及8位以上的字母+数字+特殊字符组合,其中特殊字符包括：!@#$%^&*?_~'
					     }
					 });
				});
			</script>
		</e:if>
		<e:if condition="${applicationScope.CheckChangePasswordRule!='1'}">
			<script type="text/javascript">
				$(function(){
					$.extend($.fn.validatebox.defaults.rules, {
					     length: {
					         validator: function(value, param){
							 return value.length>=param[0];
					         },
					     message: '密码长度不能小于{0}'
					     }
					 });
				});
			</script>
		</e:if>
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
						<e:if condition="${applicationScope.CheckChangePasswordRule=='1'}">
							<input id="pwd_new" name="pwd_new" type="password"  class="easyui-validatebox" required="true"  validType="length['#pwd_old']">
						</e:if>
						<e:if condition="${applicationScope.CheckChangePasswordRule!='1'}">
							<input id="pwd_new" name="pwd_new" type="password"  class="easyui-validatebox" required="true"  validType="length[6]">
						</e:if>
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