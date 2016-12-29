<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:set var="treeDataUrl"><e:url value="/pages/frame/portal/resourcesPool/menuAction.jsp?eaction=loardTree"/></e:set>

<e:q4l var="SysList">
SELECT SUBSYSTEM_ID CODE, SUBSYSTEM_NAME TEXT FROM D_SUBSYSTEM ORDER BY ORD 
</e:q4l>
<e:q4l var="receiver">
			  select distinct user_id,email,mobile from (select u.user_id,u.email,u.mobile from E_USER_PERMISSION up,E_MENU m,E_USER u where m.resources_id=up.menu_id
		      and m.resources_name='挂载功能菜单' and u.user_id=up.user_id
		      union
		      select u.user_id,u.email,u.mobile from E_ROLE_PERMISSION rp,E_MENU m1,E_USER_ROLE ur,E_USER u where rp.role_code=ur.role_code and m1.resources_id=rp.menu_id
		      and m1.resources_name='挂载功能菜单' and ur.user_id=u.user_id)
</e:q4l>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>功能资源池管理</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<c:resources type="easyui"  style="${ThemeStyle }"/>
<script>

$(function(){
	
	$('#addResDiv').dialog({
		title:"功能管理",
		closed: true,
		modal: true,
		buttons:[{
			text:'提交',
			iconCls:'icon-ok',
			plain:true,
			handler:function(){
				$('#addResForm').submit();
			}
		},{
			text:'取消',
			iconCls:'icon-cancel',
			plain:true,
			handler:function(){
				$('#addResDiv').dialog('close');
			}
		}]
	});
	
	$('#auditResPanel').dialog({
		title:"功能审批",
		closed: true,
		modal: true,
		buttons:[{
			text:'通过',
			iconCls:'icon-ok',
			plain:true,
			handler:function(){
				$('#auditResForm').attr("action",'<e:url value="/pages/frame/portal/resourcesPool/ResPoolAction.jsp?eaction=audit"/>');
				$('#eaction2').val("audit");
				$('#auditResForm').submit();
			}
		},{
			text:'驳回',
			iconCls:'icon-cancel',
			plain:true,
			handler:function(){
				$('#auditResForm').attr("action",'<e:url value="/pages/frame/portal/resourcesPool/ResPoolAction.jsp?eaction=reject"/>')
				$('#eaction2').val("reject");
				$('#auditResForm').submit();
			}
		}]
	});
	
	
	//添加、修改功能表单
	$('#addResForm').form({
		onSubmit : function(){
			var selId=$('#subSysId').combobox('getValue');
			if(selId==""){
				$.messager.alert('信息提示', '请选择子系统', 'info');
				return false;
			}
			return $(this).form('validate');
		},
		success:function(data){
			var opt="添加";
			if($("#eaction").val()=="edit")
				opt="修改";
			if($("#eaction").val()=="audit")
				opt="审核";
			if($("#eaction").val()=="reject")
				opt="驳回";
			if(data == 1){
				$.messager.alert('信息提示', opt+'成功!', 'info');
				doSearch();
				$('#addResDiv').dialog("close");
			}else{
				$.messager.alert('信息提示', opt+'失败!', 'error');
    		}
			
    	}
	});
	
	
	//审核功能表单
	$('#auditResForm').form({
		onSubmit : function(){
			var selId=$('#subSysId2').combobox('getValue');
			if(selId==""){
				$.messager.alert('信息提示', '请选择子系统', 'info');
				return false;
			}
			return $(this).form('validate');
		},
		success:function(data){
			var opt="";
			if($("#eaction2").val()=="audit")
				opt="审核";
			if($("#eaction2").val()=="reject")
				opt="驳回";
			if(data == 1){
				$.messager.alert('信息提示', opt+'成功!', 'info');
				doSearch();
				$('#auditResPanel').dialog("close");
				//sendEmail(opt);
				sendMessage(opt);
			}else{
				$.messager.alert('信息提示', opt+'失败!', 'error');
    		}
    	}
	});
	
	$('#viewResDiv').dialog({
		title:"详细信息",
		closed: true,
		modal: true
	});
	
	$('#fkWin').dialog({
		title:"反馈信息",
		closed: true,
		modal: true,
		buttons:[{
			text:'关闭',
			iconCls:'icon-cancel',
			plain:true,
			handler:function(){
				$('#fkWin').dialog("close");
			}
		}]
	});
	
});

//发送提醒短信给电信管理员
function sendMessage(opt){
	var msgTo="";
	if(opt=="审核"){
		 //发送提醒邮件给门户管理员	
	     <e:forEach items="${receiver.list}" var="mobile">
	       msgTo+='${mobile.MOBILE}'+",";
	     </e:forEach>
	     $.ajax({
	 		type : "post",
	 		url : '<e:url value="/pages/frame/portal/resourcesPool/ResPoolAction.jsp?eaction=addMsg"/>',  
	 		data : {"msgTo" : msgTo,"content":"功能资源池有名称为“"+auditResName+"”的待发布功能，请您发布!"}, 
	 		success : function(returnStr){
	 				//$.messager.alert('信息提示', '发送成功', 'error');
	 		}
	 	}); 
	}if(opt=="驳回"){
		 $.ajax({
				type : "post",
				url : '<e:url value="/pages/frame/portal/resourcesPool/ResPoolAction.jsp?eaction=getUserMobile"/>',  
				data : {"userId" : createUserId}, 
				success : function(msgTo){
					 msgTo=msgTo.replace(/\n|\r|\t/g,"");
					 $.ajax({
					 		type : "post",
					 		url : '<e:url value="/pages/frame/portal/resourcesPool/ResPoolAction.jsp?eaction=addMsg"/>',  
					 		data : {"msgTo":msgTo,"content":"功能资源池有名称为“"+auditResName+"”的功能菜单被驳回!"}, 
					 		success : function(returnStr){
					 				//$.messager.alert('信息提示', '发送成功', 'error');
					 		}
					 }); 
				}
        });  
	}
	
}

//编辑按钮点击事件
function editRes(id){
	$("#eaction").val("edit");
	$(rowDataArr).each(function(index,item){
		if(item.ID==id){
			$("#resID").val(item.ID);
			$("#resName").val(item.RES_NAME);
			$("#subSysId").combobox('select',item.SUB_SYSTEM_ID);
			$("#url").val(item.URL);
			$("#resDesc").val(item.RES_DESC);
			return false;
		}
	});
	
	$('#addResDiv').dialog('open');
}

//发送提醒邮件
function sendEmail(opt){
	var emailTo="";
	if(opt=="审核"){
		 //发送提醒邮件给门户管理员	
	     <e:forEach items="${receiver.list}" var="email">
	        	  emailTo+='${email.EMAIL}'+",";
	     </e:forEach>
	     $.ajax({
				type : "post",
				url:"<e:url value='/sendMail.e'/>",
				data : {"to" : emailTo,"subject":"有待发布的功能被添加，请发布菜单","content":"功能资源池有名称为“"+auditResName+"”的待发布功能，请您发布!"}, 
				success : function(returnStr){
					if(returnStr == 'SUCCESS'){
						//$.messager.alert('信息提示', '发送成功', 'info');
					}
				}
		});  
	 } if(opt=="驳回"){
		 //发送提醒邮件给业务管理员	
		  $.ajax({
					type : "post",
					url : '<e:url value="/pages/frame/portal/resourcesPool/ResPoolAction.jsp?eaction=getUserEmail"/>',  
					data : {"userId" : createUserId}, 
					success : function(email){
						 email=email.replace(/\n|\r|\t/g,"");
						 $.ajax({
								type : "post",
								url:"<e:url value='/sendMail.e'/>",
								data : {"to": email,"subject":"您有被驳回的功能菜单，请查收","content":"功能资源池有名称为“"+auditResName+"”的功能菜单被驳回!"}, 
								success : function(returnStr){
									if(returnStr == 'SUCCESS'){
										//$.messager.alert('信息提示', '发送成功', 'info');
									}
								}
						});  
					}
	      });  
	 }
}

//查看详细信息
function viewRes(id){
	$(rowDataArr).each(function(index,item){
		if(item.ID==id){
			$("#tdName").html(item.RES_NAME);
		    $("#tdState").html(formatState('',item));
		    $("#tdURL").html(item.URL);
		    $("#tdSubSys").html(item.SUBSYSTEM_NAME);	
		    $("#tdOrder").html(item.MENU_ORDER)	
		    $("#tdDesc").html(item.RES_DESC);
		    $("#tdPosition").html(item.MENU_POSITION);
		    $("#tdPositionExt").html(item.MENU_POSITION_EXT);
		    $("#tdReason").html(item.REJECT_REASON);
		    $("#tdCreatTime").html(item.CREATE_TIME);
		    $("#tdCreateUser").html(item.CREATE_USER);	
		    $("#tdAuditTime").html(item.AUDIT_TIME);
		    $("#tdAuditUser").html(item.AUDIT_USER);
			return false;
		}
	});
	
	$('#viewResDiv').dialog('open');
}

//删除功能
function delRes(resId){
	$.messager.confirm("操作提示", "将删除该功能,您确定要执行操作吗？", function (torf) {
		if(torf){
			$.ajax({
				type : "post",
				url : '<e:url value="/pages/frame/portal/resourcesPool/ResPoolAction.jsp?eaction=delete"/>',  
				data : {"resId" : resId}, 
				async : false,
				success : function(returnStr){
					if($.trim(returnStr) == '1'){
						$.messager.alert('信息提示', '删除成功', 'info');
						$('#resTable').datagrid('reload');
					}else{
						$.messager.alert('信息提示', '删除失败', 'error');
					}
				}
			});
		}
	});
}

//预览功能
function previewRes(id){
	var menuUrl = '';
	var ipType = '1';  //1：DCN网；  2：OA网
	
	var LoginOutPortalUrl1='http\://136.160.23.174\:8803/pages/frame/Frame.jsp';
	var LoginOutPortalUrl2='http\://172.18.11.33\:8803/pages/frame/Frame.jsp';
	var locationUrl=window.location.href;
	//判断用户请求地址是DCN网还是OA网
	if(LoginOutPortalUrl1!=""&&locationUrl.substring(locationUrl.indexOf(":")+3,locationUrl.indexOf("."))==LoginOutPortalUrl1.substring(LoginOutPortalUrl1.indexOf(":")+3,LoginOutPortalUrl1.indexOf("."))){
		ipType = '1';
	}else if(LoginOutPortalUrl2!=""&&locationUrl.substring(locationUrl.indexOf(":")+3,locationUrl.indexOf("."))==LoginOutPortalUrl2.substring(LoginOutPortalUrl2.indexOf(":")+3,LoginOutPortalUrl2.indexOf("."))){
		ipType = '2';
	}	
	
	$(rowDataArr).each(function(index,item){
		if(item.ID==id){
			if(ipType == '1'){
				menuUrl += item.SUBSYSTEM_ADDRESS;
			}else {
				menuUrl += item.SUBSYSTEM_ADDRESS2;
			}		    
		    menuUrl += item.URL;
			return false;
		}
	});
	//alert(menuUrl);
	window.open(menuUrl,"newwindow");
}

var rowDataArr=new Array();//保存 datagrid当前数据
//输出操作按钮
function formatOpt(value,rowData){
   	rowDataArr.push(rowData);
   	var content='<a class="link" href="javascript:void(0);" onclick="viewRes(\''+rowData.ID +'\');">查看</a>&nbsp;';
   	content+='<a class="link" href="javascript:void(0);" onclick="previewRes(\''+rowData.ID +'\');">预览</a>&nbsp;';
   	content+='<a class="link" href="javascript:void(0);" onclick="editRes(\''+rowData.ID +'\');">编辑</a>&nbsp;';
   	//content+='<a class="link" href="javascript:void(0);" onclick="delRes(\''+rowData.ID +'\');">删除</a>&nbsp;';
   	if(rowData.RES_STATE=="0"){
   		content+='<a class="link" href="javascript:void(0);" onclick="teamwork(\''+rowData.ID +'\');">协同</a>&nbsp;';
   	}
	if(rowData.COMM_COUNT!="0"){
		content+='<a class="link" href="javascript:void(0);" onclick="viewComments(\''+rowData.ID +'\');">查看反馈</a>&nbsp;';
	}
   	if(rowData.RES_STATE!="3"){
   		content+='<a class="link" href="javascript:void(0);" onclick="audit(\''+rowData.ID +'\');">审核</a>&nbsp;';
   	}
   
   	return content;
}
//查看反馈信息
function viewComments(resId){
	$('#fkTable').datagrid('load',{resId:resId});
	$('#fkWin').dialog("open");
}
//选择协同审核人（需求提出人）
function teamwork(resId){
	$('#usersWindow').window({
		shadow: true,
		modal: true,
		closed: true,
		width: 800,
		height: 600,
		resizable:true,
		collapsible:false,
		minimizable:false
	});	
	$('#usersWindow').window('open');
	 
	
	$('#usersWindow').load('<e:url value="/pages/frame/portal/resourcesPool/UserManager.jsp" />?resId='+resId,{},function(){
 		$('#usersWindow').window('open');
 		$.parser.parse($('#usersWindow'));
	}); 

}


var createUserId="";
var auditResName="";
//审核通过
function audit(resId){
			$(rowDataArr).each(function(index,item){
				if(item.ID==resId){
					$("#resID2").val(item.ID);
					$("#subSysId2").combobox('select',item.SUB_SYSTEM_ID);
					$("#position").val(item.MENU_POSITION);
					$("#positionExt").val(item.MENU_POSITION_EXT);
					$("#rejectReason").val(item.REJECT_REASON);
					createUserId=item.CREATE_USER_ID;
					auditResName=item.RES_NAME;
					return false;
				}
			});		
	$('#auditResPanel').dialog("open");	
	
}


//驳回
/* function reject(id){
	$('#rejectPanel').dialog({
		title:"驳回原因",
		closed: true,
		modal: true
	});
	$('#rejectPanel').dialog("open");
}

function doReject(){
	if($("#reject").val()==""){
		$.messager.alert('信息提示', '请输入驳回原因', 'info');
		$("#reject").focus();
		return;
	}
	$("#rejectReason").val($("#reject").val());
	$("#eaction").val("reject");
    $('#auditResDiv').dialog('close');
    $('#addResForm').submit();
} 

function cancelReject(){
	$('#rejectPanel').dialog("close");
}*/


//格式化功能状态
function formatState(value,rowData){
	var state="";
	switch(rowData.RES_STATE){
	   case 0 :
		   state="等待";
		   break;
	   case 1 :
		   state="驳回";
		   break;
	   case 2 :
		   state="待发布";
		   break;
	   case 3 :
		   state="已发布";
		   break;
	}
	return state;
}
//搜索
function doSearch(){ 
   rowDataArr=new Array();
   $.ajax({ 
    	 url:'<e:url value="/pages/frame/portal/resourcesPool/ResPoolAction.jsp?eaction=resList"/>', 
    	 type:"post", 
    	 data:{qName:$('#qName').val(),qState:$('#qState').combobox('getValue'),qSubSys:$('#qSubSys').combobox('getValue')}, 
    	 dataType:"json", 
    	 success:function(json){ 
    	     $("#resTable").datagrid("loadData",json); 
    	 } 
    }); 
}	
//打开目录树
function openTree(){
	var selId=$('#subSysId2').combobox('getValue');
	if(selId==""){
		$.messager.alert('信息提示', '请先选择子系统', 'info');
		return;
	}
	$('#tt').tree({url:'<e:url value="/pages/frame/portal/resourcesPool/menuAction.jsp?eaction=loardTree&subSysId='+selId+'"/>'});

	$('#tt').tree('reload');
	$('#tree_panel').dialog({
		title:"菜单树",
		closed: true,
		modal: false
	});
	$('#tree_panel').dialog('open');
}

//单击目录树
function clickNode(node){
	var isleaf = $(this).tree('isLeaf',node.target);
	if(!isleaf){
		$(this).tree('toggle',node.target); //当是目录的时候 弹出叶子节点
	}
	
}

//双击选择建议菜单位置
function dbClickNode(node){
	var isleaf = $(this).tree('isLeaf',node.target);
	if(isleaf&&node.id!="0"){
		$.messager.alert('信息提示', '只能选择目录', 'info');
	}else{
		path="";
		path=getFullPath(node)+"/"+node.text;
		$("#position").val(path);
		$('#tree_panel').dialog('close');
	}
}

var path="";
function getFullPath(node){
	if(node.id=="0"){
		return "";
	}else{
		if($('#tt').tree('getParent', node.target).id!="0"){
			getFullPath($('#tt').tree('getParent', node.target));
		}
		path+="/"+$('#tt').tree('getParent', node.target).text;
		return path;
	}
}

</script>
</head>
<body>

   <div id="resToolbar">
		<form id="queryForm" name="queryForm">
			<h2>功能审核</h2>
			<div class="search-area">
				功能名称: <input type="text" id="qName" name="qName" style="width:100px;"/>
				功能状态: <select id="qState" name="qState" class="easyui-combobox" style="width:100px;">
                      <option value="">--请选择--</option>
                      <option value="0" selected="selected">等待</option>
                      <option value="1">驳回</option>
                      <option value="2">待发布</option>
                      <option value="3">已发布</option>
                   </select>
				分系统:
					<e:select id="qSubSys" name="qSubSys" items="${SysList.list}" value="CODE" label="TEXT" headLabel="--请选择--" headValue=""  style="width:100px" class="easyui-combobox"/>
					<a href="javascript:void(0)" onclick="doSearch()" class="easyui-linkbutton">查询</a>
			</div>
		</form>
	</div>
	
	<c:datagrid id="resTable" url="/pages/frame/portal/resourcesPool/ResPoolAction.jsp?eaction=resList&qState=0" pageSize="30" style="width:auto;height:auto;"  download="true" nowrap="false" fit="true" border="false" toolbar="#resToolbar">
		<thead>
			<tr>
				<th field="RES_NAME" width="50" align="center">功能名称</th>
				<th field="RES_STATE" width="50" align="center" formatter="formatState">功能状态</th>
				<th field="SUBSYSTEM_NAME" width="100" align="center">所属分系统</th>
				<th field="MENU_POSITION" width="150" align="center">建议菜单位置</th>
				<th field="CREATE_TIME" width="100" align="center">创建时间</th>
				<th field="CREATE_USER" width="100" align="center">创建人</th>
				<th field="opt" width="170" align="left" formatter="formatOpt">操作</th>
			</tr>
		</thead>
	</c:datagrid>
	
	<div id="addResDiv" style="width:450px;height:auto;" >
	  <form id="addResForm" name="addResForm" method="post" action="<e:url value="/pages/frame/portal/resourcesPool/ResPoolAction.jsp"/>">
		<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="newTable">
		  <colgroup>
			  <col width="40%" />
			  <col width="*" />
		  </colgroup>
		  <tr>
		    <th align="right">功能名称：</th>
		    <td><input type="text" id="resName" name="resName" class="easyui-validatebox" required="true" style="width:250px"/></td>
		  </tr>
		  <tr>
		    <th align="right">功能地址：</th>
		    <td><input type="text" id="url" name="url" class="easyui-validatebox"  style="width:250px"/></td>
		  </tr>
		  <tr>
		    <th align="right">所属分系统：</th>
		    <td>
		        <e:select id="subSysId" name="subSysId" items="${SysList.list}" value="CODE" label="TEXT" headLabel="--请选择--" headValue=""  style="width:250px" class="easyui-combobox" required="true"/>
		    </td>
		  </tr>
		  <tr>
		    <th align="right">功能描述：</th>
		    <td><textarea id="resDesc" name="resDesc" class="easyui-validatebox"  style="width:250px" rows="5"></textarea></td>
		  </tr>
		</table>
		<input type="hidden" name="eaction" id="eaction" value="add" />
		<input type="hidden" name="resID" id="resID" value="" />
	   </form>
	</div>
	
	
	<!-- 审核表单  -->
	<div id="auditResPanel" style="width:450px;height:auto;" >
	  <form id="auditResForm" name="auditResForm" method="post" action="<e:url value="/pages/frame/portal/resourcesPool/ResPoolAction.jsp"/>">
		<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="newTable">
		  <colgroup>
			  <col width="40%" />
			  <col width="*" />
		  </colgroup>
		  <tr>
		    <th align="right">所属分系统：</th>
		    <td>
		        <e:select id="subSysId2" name="subSysId2" items="${SysList.list}" value="CODE" label="TEXT" headLabel="--请选择--" headValue=""  style="width:250px" class="easyui-combobox" required="true"/>
		    </td>
		  </tr>
		  <!--<tr>
		    <th align="right">建议菜单位置：</th>
		    <td>
		      <input type="text" id="position" name="position"  class="easyui-validatebox" style="width:250px" onclick="openTree()"/>
		    </td>
		  </tr>
		  -->
		  <tr>
		    <th align="right">建议菜单位置：</th>
		    <td>
		      <input type="text" id="positionExt" name="positionExt" class="easyui-validatebox" style="width:250px"/>
		    </td>
		  </tr>
		  <tr>
		    <th align="right">批注信息：</th>
		    <td><textarea id="rejectReason" name="rejectReason" class="easyui-validatebox"  style="width:250px" rows="5"></textarea></td>
		  </tr>
		</table>
		<input type="hidden" name="resID2" id="resID2" value="" />
		<input type="hidden" name="eaction" id="eaction2" value="add" />
	   </form>
		
	</div>
	
	
	
	
	<!-- 查看详细-->
	<div id="viewResDiv" style="width:750px;height:auto;" >
		<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="newTable">
		    <colgroup>
			  <col width="15%" />
			  <col width="35%" />
			  <col width="15%" />
			  <col width="35%" />
			 </colgroup>
		  <tr>
		    <th align="right">功能名称</th>
		    <td id="tdName" >
               
            </td>
		    <th align="right">功能状态</th>
		    <td id="tdState">&nbsp;</td>
		  </tr>
		  
		  <tr>
		    <th align="right">功能地址</th>
		    <td id="tdURL">&nbsp;</td>
		    <th align="right">分系统</th>
		    <td id="tdSubSys">&nbsp;</td>
		  </tr>
		  
		  <tr>
		    <th align="right">建议菜单位置</th>
		    <td id="tdPosition">&nbsp;</td> 
		    <th align="right" rowspan="2">功能描述</th>
		    <td id="tdDesc" rowspan="2">&nbsp;</td>
		  </tr>
		  
		  <tr>
		     <th align="right">菜单位置补充</th>
		     <td id="tdPositionExt">&nbsp;</td>
		  </tr>
		  <tr>
		    <th  align="right">创建人</th>
		    <td id="tdCreateUser">&nbsp;</td>
		    <th  align="right">创建时间</th>
		    <td id="tdCreatTime">&nbsp;</td>
		  </tr>
		 
		  <tr>
		    <th  align="right">审核人</th>
		    <td id="tdAuditUser">&nbsp;</td>
		    <th  align="right">审核时间</th>
		    <td id="tdAuditTime">&nbsp;</td>
		  </tr>
		  <tr id="rejectStr">
		    <th align="right">批注信息</th>
		    <td id="tdReason" colspan="3">&nbsp;</td>
		  </tr>
		</table>
	</div>
	
	<!-- 选择人员窗口 -->
	<div id="usersWindow" style="width:750px;height:auto;" title="选择协同审核人">
	    
	</div>
	
	<!-- 菜单树 -->
	<div id="tree_panel" title="系统菜单" style="width:450px;height:380px;">
     		<a:tree id="tt" url='${treeDataUrl}' checkbox="false" dnd="true" onClick="clickNode" onDblClick="dbClickNode"/> 
    </div>
    
    <div id="fkWin" style="width:750px;height:500px;" title="反馈信息">
          <c:datagrid id="fkTable" url="/pages/frame/portal/resourcesPool/ResPoolAction.jsp?eaction=teamworkList" pageSize="30" style="width:auto;height:auto;"  download="true" nowrap="false" fit="true" >
		 <thead>
			<tr>
				<th field="USER_NAME" width="10%" align="center">协同人</th>
				<th field="COMMENTS" width="70%" align="center">反馈意见</th>
				<th field="COMMENT_TIME" width="20%" align="center">反馈时间</th>
			</tr>
		 </thead>
	 </c:datagrid>
    </div>
     
</body>
</html>

