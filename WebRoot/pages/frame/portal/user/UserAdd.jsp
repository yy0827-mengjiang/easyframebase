<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<!-- 注意：如果报错，先检查表E_USER_ATTR_DIM 是否更新，新增字段ATTR_DESC -->
<e:q4l var="attr_list">
select ATTR_CODE,
       ATTR_NAME,
       PARENT_CODE,
       SHOW_MODE,
       CODE_TABLE,
       CODE_KEY,
       CODE_PARENT_KEY,
       CODE_DESC,
       CODE_ORD,
       DATA_TYPE,
       MULTI,
       ATTR_ORD,
       IS_NULL,
       DEFAULT_VALUE,
       DEFAULT_DESC,
       ATTR_DESC,
       T.SUBSYSTEM_ID,
       SUB.SUBSYSTEM_NAME
  from E_USER_ATTR_DIM t left join D_SUBSYSTEM SUB
  on T.SUBSYSTEM_ID = SUB.SUBSYSTEM_ID
 order by ATTR_ORD,PARENT_CODE
</e:q4l>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>index.jsp</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<c:resources type="easyui"  style="${ThemeStyle }"/>
		<e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/resources/themes/blue/boncBlue.css"/>
		<script type="text/javascript">
		$(function(){
			$.extend($.fn.validatebox.defaults.rules, {  
			    /*必须和某个字段相等*/
			    equalTo: {
			        validator:function(value,param){
			            return $(param[0]).val() == value;
			        },
			        message:'两次输入密码不一致！'
			    }
			           
			});
			
			 $('#account').combobox({
				 onLoadSuccess:function(){
					 //设置默认值
					 var accounts='${sessionScope.USER_OCT}';
					 if(accounts!=''&&accounts!=null){
						 $(this).combobox('setValues',accounts.split(","));
					 }else{
						 $(this).combobox('setValue','-909');
						 $(this).combobox('setText','请选择');
					 }
					
				 },
			     onSelect: function(rec){
			    	 //获取多选得值
			    	 var values = $(this).combobox('getValues');
			    	 var texts = $(this).combobox('getText');
			    	 //alert(texts);
			    	 　//alert(values);
			    	 //alert(values+"+++"+values.indexOf("-1"));
			    	 //判断是否选择全省，如果选择全省，就清空其他地市
			    	 if(values.indexOf("-909")>0){
			    		 $(this).combobox('clear').combobox('setValue', '-909');
			    	 }else if(values.indexOf("-909")==0){
			    		 $(this).combobox("unselect", '-909');
			    	 }
			     }
			 });
		});
		function doAdd(){
			if($('#userForm').form('validate')){
				$('#user_login_id').val($.trim($('#user_login_id').val()));
				if ($("#account").combobox('getValues')<0){
					$.messager.alert("提示信息","请选企业帐号！","info");
					return;
				}
				$("#account_code").val($("#account").combobox('getValues'))
				 var queryParam = $('#userForm').serialize();
				 //console.log(queryParam);
				$.post('<e:url value="/pages/frame/portal/user/UserAction.jsp?eaction=add"/>', queryParam, function(data){
					if($.trim(data)=='HAVINGLOGINID'){
						$.messager.alert("提示信息","该登录ID已经存在！","info");
					}else{
						window.location.href='<e:url value="/pages/frame/portal/user/UserManager.jsp"/>';
					}
				});
			}
		}
		//文本框验证，验证所填的值是否存在于视图CSS_DIM_CRM_STAFF_NUMBER中，针对css系统用户扩展字段：CRM工号（手机版用）
		function verify(s){
			if(s.value != ''){
				var info = {};
				info.tex = s.value;
				$.post('<e:url value="/pages/frame/portal/user/UserAction.jsp?eaction=verify"/>', info, function(data){
					if($.trim(data)=='HAVINGLOGINID0'){
						
						$.messager.confirm('确认框', 'CRM工号不存在，请确认填写是否正确。 取消则该项不填写！', function(r){
			                if (r){
			                    //$("#"+s.id).focus();
			                    var t=$("#"+s.id).val();
								$("#"+s.id).val("").focus().val(t); 
			                    
			                }else{
			                	$("#"+s.id).val('');
			                }
			            });
			            
					}if($.trim(data)=='HAVINGLOGINID'){
						//$.messager.alert("提示信息","存在！","info");
					}
				});
			}			
		}
		//文本框验证，验证所填的值是否存在于视图CSS_DIM_CRM_SM_PARTY中，针对css系统用户扩展字段：CRM发展人ID 多选，逗号间隔
		function verify2(s){
			if(s.value != ''){
				
				var arr = s.value.split(',');				
				$.each(arr, function(i, val) {
					if(isNaN(val)){
					   alert("输入的CRM发展人ID包含非数字字符，请重新输入！");
					   $("#"+s.id).val('');
					   return false;
					}					
					var info = {};
					info.tex = val;
		           	$.post('<e:url value="/pages/frame/portal/user/UserAction.jsp?eaction=verify2"/>', info, function(data){
					if($.trim(data)=='HAVINGLOGINID0'){
						
						$.messager.confirm('确认框', 'CRM发展人ID不存在，请确认填写是否正确。 取消则该项不填写！', function(r){
			                if (r){
			                    //$("#"+s.id).focus();
			                    var t=$("#"+s.id).val();
								$("#"+s.id).val("").focus().val(t); 
			                    
			                }else{
			                	$("#"+s.id).val('');
			                }
			            });
			            
						}if($.trim(data)=='HAVINGLOGINID'){
							//$.messager.alert("提示信息","存在！","info");
						}
						return false;
					});
		           	
		        }); 
				
				/**/
			}			
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
					     message: '密码必须为8位及8位以上的字母+数字+特殊字符组合,其中特殊字符包括：!@#$%^&*?_~'
					     }
					 });
				});
			</script>
		</e:if>
	</head>
	<body>
		<form id="userForm" method="post" action="#" style="height:700px; display:block;">
			<div class="contents-head" id="tb1">
				<h2>用户管理</h2>
				<div class="search-area">
					<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doAdd();">保  存</a>
					<a href="<e:url value="/pages/frame/portal/user/UserManager.jsp"/>" class="easyui-linkbutton easyui-linkbutton-gray">取  消</a>
				</div>
			</div>
			<div class="easyui-tabs mTop15" style="height:500px" plain="true" border="false">
				<div title="基本信息">
					<table class="pageTable">
					<colgroup>
					<col width="200px">
					<col width="*">
					</colgroup>
						<tr>
							<th>登录ID:</th>
							<td><input type="text" name="login_id" id="user_login_id" class="easyui-validatebox" required></td>
							<th>密码:</th>
							<td>
								<e:if condition="${applicationScope.CheckChangePasswordRule!='1'}">
									<input type="password" name="password" id="user_password" class="easyui-validatebox" validType="length[4,32]" >
								</e:if>
								<e:if condition="${applicationScope.CheckChangePasswordRule=='1'}">
									<input type="password" name="password" id="user_password" class="easyui-validatebox" validType="length['#pwd_old']" >
								</e:if>
							</td>
						</tr>
						<tr>
							<th>确认密码:</th>
							<td><input type="password" name="repeat_password" id="user_repeat_password" value="" class="easyui-validatebox"  validType="equalTo['#user_password']"></td>
							<th>用户姓名:</th>
							<td><input type="text" name="name" id="user_name" class="easyui-validatebox" required></td>
						</tr>
						<tr>
							<th>管理员:</th>
							<td>
								<e:if condition="${sessionScope.UserInfo.ADMIN == '1'}">
									<e:set var="tt">[{ "aa": "否", "bb": "0" },{ "aa": "是", "bb": "1" }]</e:set>
									<e:select id="user_admin" name="admin" items="${e:json2java(tt)}" label="aa" value="bb"/>
								</e:if>
								<e:if condition="${sessionScope.UserInfo.ADMIN != '1'}">
									<e:set var="tt">[{ "aa": "否", "bb": "0" }]</e:set>
									<e:select id="user_admin" name="admin" items="${e:json2java(tt)}" label="aa" value="bb"/>
								</e:if>
							</td>
							<th>性别:</th>
							<td>
								<e:set var="tt">[{ "aa": "男", "bb": "1" },{ "aa":"女", "bb": "0" }]</e:set>
								<e:select id="user_sex" name="sex" items="${e:json2java(tt)}" label="aa" value="bb"/>
							</td>
						</tr>
						<tr>
							<th>邮箱地址:</th>
							<td><input type="text" name="email" id="user_email" class="easyui-validatebox" validType="email"></td>
							<th>移动电话:</th>
							<td><input type="text" name="mobile" id="user_mobile" class="easyui-validatebox" validType="mobile"></td>
						</tr>
						<tr>
							<th>固定电话:</th>
							<td><input type="text" name="telephone" id="user_telephone"></td>
							<th>状态:</th>
							<td>
								<e:set var="tt">[{ "aa": "启用", "bb": "1" },{ "aa": "停用", "bb": "0" }]</e:set>
								<e:select id="user_state" name="state" items="${e:json2java(tt)}" label="aa" value="bb"/>
							</td>
						</tr>
						<tr>
							<th>企业账户</th>
							<td colspan="3">
								<input type="text" id="account" name="account" class="easyui-combobox" data-options="valueField:'ACCOUNT_CODE',textField:'ACCOUNT_NAME',editable:false,multiple:true,panelHeight:'auto',url:'<e:url value="/pages/frame/portal/user/UserAction.jsp"/>?eaction=getAccount'"/>
	               				<input type="hidden" id="account_code" name="account_code"/>
               				</td>
						</tr>
						<tr>
							<th>备注信息:</th>
							<td colspan="3"><textarea name="memo" id="user_memo" cols="60" rows="4"></textarea></td>
						</tr>
						
					</table>
				</div>
				<div title="扩展信息">
					<table class="pageTable">
					<colgroup>
						<col width="12%">
						<col width="*">
					</colgroup>
						<e:forEach items="${attr_list.list}" var="item">
						<e:switch value="${item.SHOW_MODE}">
							<e:case value="INPUT">
							<tr>
								<th>${item.ATTR_NAME}:</th><td><input type="text" id="dim_${item.ATTR_CODE}" name="dim_${item.ATTR_CODE}" <e:if condition="${item.IS_NULL=='0'}">class="easyui-validatebox" required="true"</e:if>><span>${item.ATTR_DESC }</span></td>
								<e:if condition="${item.SUBSYSTEM_NAME!=null&&item.SUBSYSTEM_NAME!=''}">
									<td>所属子系统：   ${item.SUBSYSTEM_NAME}</td>
								</e:if>
							</tr>
							</e:case>
							<e:case value="INPUTX1">
							<tr>
								<th>${item.ATTR_NAME}:</th><td><input type="text" id="dim_${item.ATTR_CODE}" name="dim_${item.ATTR_CODE}" onblur="verify(this)" <e:if condition="${item.IS_NULL=='0'}">class="easyui-validatebox" required="true"</e:if>><span>${item.ATTR_DESC }</span></td>
								<e:if condition="${item.SUBSYSTEM_NAME!=null&&item.SUBSYSTEM_NAME!=''}">
									<td>所属子系统：   ${item.SUBSYSTEM_NAME}</td>
								</e:if>
							</tr>
							</e:case>
							<e:case value="INPUTX2">
							<tr>
								<th>${item.ATTR_NAME}:</th><td><input type="text" id="dim_${item.ATTR_CODE}" name="dim_${item.ATTR_CODE}" onblur="verify2(this)" <e:if condition="${item.IS_NULL=='0'}">class="easyui-validatebox" required="true"</e:if>><span>${item.ATTR_DESC }</span></td>
								<e:if condition="${item.SUBSYSTEM_NAME!=null&&item.SUBSYSTEM_NAME!=''}">
									<td>所属子系统：   ${item.SUBSYSTEM_NAME}</td>
								</e:if>
							</tr>
							</e:case>
							<e:case value="INPUTHIDE">							
								<input type="hidden" id="dim_${item.ATTR_CODE}" name="dim_${item.ATTR_CODE}">								
							</e:case>
							<e:case value="RADIO">
							<tr>
								<th>${item.ATTR_NAME}:</th>
								<td>
								
								<input type="text" id="dim_${item.ATTR_CODE}" name="dim_${item.ATTR_CODE}"><span>${item.ATTR_DESC }</span>
								<script type="text/javascript">
								$(function(){
									$('#dim_${item.ATTR_CODE}').combobox({  
									    url:'<e:url value="/pages/frame/portal/user/UserAction.jsp"/>?eaction=extSelect&data_type=${item.DATA_TYPE}',  
									    valueField:'${item.CODE_KEY}',  
									    textField:'${item.CODE_DESC}',
									    width:'155',
									    <e:if condition="${item.IS_NULL=='0'}">
									    required: true,  
									    </e:if>
									    onBeforeLoad: function(param){
											param.CODE_TABLE = '${item.CODE_TABLE}';
											param.CODE_KEY = '${item.CODE_KEY}';
											param.CODE_DESC = '${item.CODE_DESC}';
											param.CODE_ORD = '${item.CODE_ORD}';
										<e:if condition="${sessionScope.UserInfo.AREA_CONTROL_FRAME!=null&&sessionScope.UserInfo.AREA_CONTROL_FRAME!=''&&sessionScope.UserInfo.AREA_CONTROL_FRAME!='-1'}" var='isArea'>					
												var str_temp='${item.CODE_KEY}'+"";											
												if(str_temp.indexOf("AREA")!='-1'){	
													
												}else{
													param.DEFAULT_VALUE = '${item.DEFAULT_VALUE}';
													param.DEFAULT_DESC = '${item.DEFAULT_DESC}';
												}
											</e:if>
											<e:else condition="${isArea}">
											param.DEFAULT_VALUE = '${item.DEFAULT_VALUE}';
											param.DEFAULT_DESC = '${item.DEFAULT_DESC}';
											</e:else>
										},
										onLoadSuccess:  function(){
											<e:if condition="${sessionScope.UserInfo.AREA_CONTROL_FRAME!=null&&sessionScope.UserInfo.AREA_CONTROL_FRAME!=''&&sessionScope.UserInfo.AREA_CONTROL_FRAME!='-1'}" var='isArea'>					
				
											var str_temp='${item.CODE_KEY}'+"";											
											if(str_temp.indexOf("AREA")!='-1'){	
												$('#dim_${item.ATTR_CODE}').combobox("setValue",'${sessionScope.UserInfo.AREA_CONTROL_FRAME}');											
											}else{	
												<e:if condition="${item.DEFAULT_VALUE!=null&&item.DEFAULT_VALUE!=''}">
											$('#dim_${item.ATTR_CODE}').combobox("setValue",'${item.DEFAULT_VALUE}');
											</e:if>											
											}
										</e:if>
										<e:else condition="${isArea}">
										
											<e:if condition="${item.DEFAULT_VALUE!=null&&item.DEFAULT_VALUE!=''}">
											$('#dim_${item.ATTR_CODE}').combobox("setValue",'${item.DEFAULT_VALUE}');
											</e:if>
										</e:else>
										} 
									}); 
								}); 
								</script>
								</td>
								<e:if condition="${item.SUBSYSTEM_NAME!=null&&item.SUBSYSTEM_NAME!=''}">
									<td>所属子系统：   ${item.SUBSYSTEM_NAME}</td>
								</e:if>
							</tr>
							</e:case>
							<e:case value="CHECKBOX">
							<tr>
								<th>${item.ATTR_NAME}:</th>
								<td>
								<input type="text" id="dim_${item.ATTR_CODE}" name="dim_${item.ATTR_CODE}"><span>${item.ATTR_DESC }</span>
								<script type="text/javascript">
								$(function(){
									$('#dim_${item.ATTR_CODE}').combobox({  
									    url:'<e:url value="/pages/frame/portal/user/UserAction.jsp"/>?eaction=extSelect',  
									    valueField:'${item.CODE_KEY}',  
									    textField:'${item.CODE_DESC}',
									    width:'155',
									    multiple:true,
									    <e:if condition="${item.IS_NULL=='0'}">
									    required: true,  
									    </e:if>
									    onBeforeLoad: function(param){
											param.CODE_TABLE = '${item.CODE_TABLE}';
											param.CODE_KEY = '${item.CODE_KEY}';
											param.CODE_DESC = '${item.CODE_DESC}';
											param.CODE_ORD = '${item.CODE_ORD}';
											param.DEFAULT_VALUE = '${item.DEFAULT_VALUE}';
											param.DEFAULT_DESC = '${item.DEFAULT_DESC}';
										},
										onLoadSuccess:  function(){
											<e:if condition="${item.DEFAULT_VALUE!=null&&item.DEFAULT_VALUE!=''}">
											$('#dim_${item.ATTR_CODE}').combobox("setValue",'${item.DEFAULT_VALUE}');
											</e:if>
										} 
									}); 
								}); 
								</script>
								</td>
								<e:if condition="${item.SUBSYSTEM_NAME!=null&&item.SUBSYSTEM_NAME!=''}">
									<td>所属子系统：   ${item.SUBSYSTEM_NAME}</td>
								</e:if>
							</tr>
							</e:case>
							<e:case value="CASSELECT">
							<tr>
								<th>${item.ATTR_NAME}:</th>
								<td>
								<input type="text" id="dim_${item.ATTR_CODE}" name="dim_${item.ATTR_CODE}"><span style="color:#199ed8;margin-left:5px;">${item.ATTR_DESC }</span>
								<script type="text/javascript">
								<e:if condition="${parentItem!=null&&parentItem.CODE_KEY==item.CODE_PARENT_KEY}">
								function cascade_${parentItem.CODE_KEY}(key){
									$('#dim_${item.ATTR_CODE}').combobox('reload','<e:url value="/pages/frame/portal/user/UserAction.jsp"/>?eaction=extCascade&PARENT_KEY='+key);
									$('#dim_${item.ATTR_CODE}').combobox('setValue','');
								}
								</e:if>
								$(function(){
									$('#dim_${item.ATTR_CODE}').combobox({  
									    url:'<e:url value="/pages/frame/portal/user/UserAction.jsp"/>?eaction=extCascade&PARENT_KEY=-1',  
									    valueField:'${item.CODE_KEY}',  
									    textField:'${item.CODE_DESC}',
									     width:'155',
									    <e:if condition="${item.IS_NULL=='0'}">
									    required: true,  
									    </e:if>
									    onBeforeLoad: function(param){
											param.CODE_TABLE = '${item.CODE_TABLE}';
											param.CODE_KEY = '${item.CODE_KEY}';
											param.CODE_DESC = '${item.CODE_DESC}';
											param.CODE_ORD = '${item.CODE_ORD}';
											param.PARENT_CODE = '${item.PARENT_CODE}';
											param.CODE_PARENT_KEY = '${item.CODE_PARENT_KEY}';
											<e:if condition="${sessionScope.UserInfo.AREA_CONTROL_FRAME!=null&&sessionScope.UserInfo.AREA_CONTROL_FRAME!=''&&sessionScope.UserInfo.AREA_CONTROL_FRAME!='-1'}" var='isArea'>					
												var str_temp='${item.CODE_KEY}'+"";											
												if(str_temp.indexOf("AREA")!='-1'){	
													
												}else{
													param.DEFAULT_VALUE = '${item.DEFAULT_VALUE}';
													param.DEFAULT_DESC = '${item.DEFAULT_DESC}';
												}
											</e:if>
											<e:else condition="${isArea}">
											param.DEFAULT_VALUE = '${item.DEFAULT_VALUE}';
											param.DEFAULT_DESC = '${item.DEFAULT_DESC}';
											</e:else>
										},
										onLoadSuccess:  function(data){
										<e:if condition="${sessionScope.UserInfo.AREA_CONTROL_FRAME!=null&&sessionScope.UserInfo.AREA_CONTROL_FRAME!=''&&sessionScope.UserInfo.AREA_CONTROL_FRAME!='-1'}" var='isArea'>					
				
											var str_temp='${item.CODE_KEY}'+"";											
											if(str_temp.indexOf("AREA")!='-1'){	
												$('#dim_${item.ATTR_CODE}').combobox("setValue",'${sessionScope.UserInfo.AREA_CONTROL_FRAME}');											
											}else{	
												<e:if condition="${item.DEFAULT_VALUE!=null&&item.DEFAULT_VALUE!=''}">
											$('#dim_${item.ATTR_CODE}').combobox("setValue",'${item.DEFAULT_VALUE}');
											</e:if>											
											}
										</e:if>
										<e:else condition="${isArea}">
										
											<e:if condition="${item.DEFAULT_VALUE!=null&&item.DEFAULT_VALUE!=''}">
											$('#dim_${item.ATTR_CODE}').combobox("setValue",'${item.DEFAULT_VALUE}');
											</e:if>
										</e:else>
										},
										onSelect: function(node){
								
											if(typeof(cascade_${item.CODE_KEY})!="undefined"){
												
												cascade_${item.CODE_KEY}(node.${item.CODE_KEY});
											}
										}/*,
										onChange:function(newValue, oldValue){
											
											if(typeof(cascade_${item.CODE_KEY})!="undefined"){
												
												cascade_${item.CODE_KEY}(oldValue);
											}
										}*/
									}); 
								}); 
								</script>
								</td>
								<e:if condition="${item.SUBSYSTEM_NAME!=null&&item.SUBSYSTEM_NAME!=''}">
									<td>所属子系统：   ${item.SUBSYSTEM_NAME}</td>
								</e:if>
							</tr>
							<e:set var="parentItem" value="${item}"/>
							</e:case>
							<e:case value="TREE">
							<tr>
								<th>${item.ATTR_NAME}:</th>
								<td>
								<input type="text" id="dim_${item.ATTR_CODE}" name="dim_${item.ATTR_CODE}"><span style="color:#199ed8;margin-left:5px;">${item.ATTR_DESC }</span>
								<script type="text/javascript">
								$(function(){
									$('#dim_${item.ATTR_CODE}').combotree({  
									    url:'<e:url value="/pages/frame/portal/user/UserAction.jsp"/>?eaction=extTree', 
									    <e:if condition="${item.IS_NULL=='0'}">
									    required: true,  
									    </e:if> 
									   	width:'155',									   	
									    onBeforeLoad: function(node,param){
									    	param.PARENT_KEY = '-1';
											param.CODE_TABLE = '${item.CODE_TABLE}';
											param.CODE_KEY = '${item.CODE_KEY}';
											param.CODE_DESC = '${item.CODE_DESC}';
											param.CODE_ORD = '${item.CODE_ORD}';
											param.CODE_PARENT_KEY = '${item.CODE_PARENT_KEY}';
											param.DEFAULT_VALUE = '${item.DEFAULT_VALUE}';
											param.DEFAULT_DESC = '${item.DEFAULT_DESC}';
										},
										onLoadSuccess:  function(){
											<e:if condition="${item.DEFAULT_VALUE!=null&&item.DEFAULT_VALUE!=''}">
											$('#dim_${item.ATTR_CODE}').combotree("setValue",'${item.DEFAULT_VALUE}');
											</e:if>
										}  
									});
								}); 
								</script>
								</td>
								<e:if condition="${item.SUBSYSTEM_NAME!=null&&item.SUBSYSTEM_NAME!=''}">
									<td>所属子系统：   ${item.SUBSYSTEM_NAME}</td>
								</e:if>
							</tr>
							</e:case>
						</e:switch>
						</e:forEach>
					</table>
				</div>
			
			    <!--吉林需求 <div title="网格信息" id="gridInfoDiv">
			       <script>
			          $("#gridInfoDiv").load("<e:url value='/pages/frame/portal/user/GridManager.jsp'/>",{},function(){
			        	  $.parser.parse($("#gridInfoDiv"));
			          });
			       </script>
			    </div> -->
			</div>
		</form>
	</body>
</html>