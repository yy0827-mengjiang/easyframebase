<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:set var="treeDataUrl"><e:url value="/pages/frame/menu/menuAction.jsp?eaction=loardTree"/></e:set>

<e:q4l var="SysList">
SELECT SUBSYSTEM_ID CODE, SUBSYSTEM_NAME TEXT FROM D_SUBSYSTEM ORDER BY ORD 
</e:q4l>
<e:q4o var="menuObj">
    SELECT d.*,s.SUBSYSTEM_NAME FROM D_RESOURCE_POOL d,D_SUBSYSTEM s where d.ID=${param.resId} and d.SUB_SYSTEM_ID=s.SUBSYSTEM_ID(+)
</e:q4o>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>功能资源池管理</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<c:resources type="easyui"  style="${ThemeStyle }"/>
<style type="text/css">
.newTable { border-collapse:collapse; font-family:Arial, Helvetica, sans-serif; }
.newTable th { background:#e8e7e7; }
.newTable td { background:#f2f6ec; }
.newTable th, .newTable td { padding:5px 5px; border:1px solid #FFF; }
.link{margin: 0px 5px; text-decoration: none;}
</style>
<script>
   var isUpdate=false;
   function update(){
       if($("#addFlag").val()==""){
          $.messager.alert('信息提示', '请先挂载菜单', 'info');
          return;
       }
	   $.ajax({
			type : "post",
			url : '<e:url value="/pages/frame/portal/resourcesPool/ResPoolAction.jsp?eaction=publish"/>',  
			data : {"resId" : ${param.resId}}, 
			success : function(returnStr){
				if($.trim(returnStr) == '1'){
					isUpdate=true;
					$.messager.alert('信息提示', '发布成功', 'info');
					sendMessage();
					//sendEmail();
				}else{
					$.messager.alert('信息提示', '发布失败', 'error');
				}
			}
		});
   }
   function back(){
	   if(isUpdate==true||$("#addFlag").val()==""){
		   window.history.go(-1);  
	   }if(isUpdate==false&&$("#addFlag").val()!=""){
		   $.messager.alert('信息提示', '请先点击"已挂载"按钮，完成挂载', 'info'); 
	   }
   }
   
   function sendMessage(){
	   $.ajax({
			type : "post",
			url : '<e:url value="/pages/frame/portal/resourcesPool/ResPoolAction.jsp?eaction=getUserMobile"/>',  
			data : {"userId" : ${menuObj.CREATE_USER}}, 
			success : function(msgTo){
				 msgTo=msgTo.replace(/\n|\r|\t/g,"");
				 $.ajax({
				 		type : "post",
				 		url : '<e:url value="/pages/frame/portal/resourcesPool/ResPoolAction.jsp?eaction=addMsg"/>',  
				 		data : {"msgTo":msgTo,"content":"功能资源池有名称为“${menuObj.RES_NAME}”的功能菜单已上架!"}, 
				 		success : function(returnStr){
				 				//$.messager.alert('信息提示', '发送成功', 'error');
				 		}
				 }); 
			}
   });  
   }
   
   function sendEmail(){
	   $.ajax({
			type : "post",
			url : '<e:url value="/pages/frame/portal/resourcesPool/ResPoolAction.jsp?eaction=getUserEmail"/>',  
			data : {"userId" : ${menuObj.CREATE_USER}}, 
			success : function(email){
				 email=email.replace(/\n|\r|\t/g,"");
				 $.ajax({
						type : "post",
						url:"<e:url value='/sendMail.e'/>",
						data : {"to": email,"subject":"您添加的功能菜单“${menuObj.RES_NAME}”已上架，请查收","content":"功能资源池有名称为“${menuObj.RES_NAME}”的功能菜单已上架!"}, 
						success : function(returnStr){
							if(returnStr == 'SUCCESS'){
								//$.messager.alert('信息提示', '发送成功', 'info');
								//window.history.go(-1);
							}
						}
				});  
			}
        });  
   }
</script>
</head>
<body>

<input type="hidden" id="addFlag" value=""/> 
<table width="100%" height="590px" class="newTable">
  <tr>
    <td width="70%" height="100%">
       <iframe src="<e:url value='/pages/frame/portal/menu/menuManager.jsp'/>" width="100%" height="100%" frameborder="0"></iframe>
    </td>
    <td width="30%" height="100%" valign="top">
          <table border="0" align="center" cellpadding="0" cellspacing="0" class="newTable">
							  <colgroup>
								  <col width="40%" />
								  <col width="*" />
							  </colgroup>
							  <tr>
							    <td colspan="2" style="color: #E00">
							             请参照下面表格挂载功能菜单
							    <br/>挂载成功后请点击"已挂载"按钮完成菜单挂载</td>
							  </tr>
							  <tr>
							    <th align="right">功能名称</th>
							    <td>
							      ${menuObj.RES_NAME}
							    </td>
							  </tr>
							  <tr>
							    <th align="right">功能地址</th>
							    <td>
							       ${menuObj.URL}
							    </td>
							  </tr>
							  <tr>
							    <th align="right">分 系 统</th>
							    <td>
							      ${menuObj.SUBSYSTEM_NAME}
							    </td>
							  </tr>
							  <tr>
							    <th align="right">菜单位置</th>
							    <td>
							      ${menuObj.MENU_POSITION}
							    </td>
							  </tr>
							  <tr>
							    <th align="right">菜单位置补充</th>
							    <td>
							       ${menuObj.MENU_POSITION_EXT}
							    </td>
							  </tr>
							  <tr>
							    <th align="right">功能描述</th>
							    <td>${menuObj.RES_DESC}</td>
							  </tr>
							</table>
							<div style=" text-align:center;padding-top:30px;">
								<a href="javascript:void(0)" onclick="update()" class="easyui-linkbutton"  iconCls="icon-save" style="color:#000; margin-right:45px">已挂载</a>
	     						
	     						<a href="javascript:void(0)" onclick="back()" class="easyui-linkbutton"  iconCls="icon-back" style="color:#000">返回</a>
     						</div> 
    </td>
  </tr>
</table>   

</body>
</html>