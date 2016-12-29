<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:set var="treeDataUrl"><e:url value="/pages/frame/menu/menuAction.jsp?eaction=loardTree"/></e:set>

<e:q4l var="SysList">
SELECT SUBSYSTEM_ID CODE, SUBSYSTEM_NAME TEXT FROM D_SUBSYSTEM ORDER BY ORD 
</e:q4l>
<e:q4l var="receiver">
			  select distinct user_id,email,mobile from (select u.user_id,u.email,u.mobile from E_USER_PERMISSION up,E_MENU m,E_USER u where m.resources_id=up.menu_id
		      and m.resources_name='功能审核' and u.user_id=up.user_id
		      union
		      select u.user_id,u.email,u.mobile from E_ROLE_PERMISSION rp,E_MENU m1,E_USER_ROLE ur,E_USER u where rp.role_code=ur.role_code and m1.resources_id=rp.menu_id
		      and m1.resources_name='功能审核' and ur.user_id=u.user_id)
</e:q4l>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>功能资源池管理</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<c:resources type="easyui" style="${ThemeStyle }"/>
<e:style value="resources/themes/common/css/icon.css"/> 
<script>
var emailTo="";
var msgTo="";
$(function(){
	$('#addResDiv').dialog({
		title:"功能管理",
		closed: true,
		modal: true,
		buttons:[{
			text:'提交',
			iconCls:'icon-ok',
			handler:function(){
				$('#addResForm').submit();
			}
		},{
			text:'取消',
			iconCls:'icon-cancel',
			handler:function(){
				$('#addResDiv').dialog('close');
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
			var count=data.split(",")[0];
			var resId=data.split(",")[1];
			if(count == 1){
				$.messager.alert('信息提示', opt+'成功!', 'info');
				$('#resTable').datagrid("load",$("#resTable").datagrid("options").queryParams);
				rowDataArr=new Array();
				$('#addResDiv').dialog("close");
				if(opt=="添加"){
					 emailTo="";
					 msgTo="";
				     <e:forEach items="${receiver.list}" var="email">
				          emailTo+='${email.EMAIL}'+",";
				          msgTo+='${email.MOBILE}'+",";
				     </e:forEach>
				     var subject="有新功能添加，请审核";
				     var content="功能资源池有名称为“"+$("#resName").val()+"”的功能添加，请您审核!";
				     //sendEmail(emailTo,subject,content);
				     sendMessage(resId,msgTo,content);
				}
				   
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
	
	
	
});

//发送提醒邮件给电信管理员	
function sendEmail(emailTo,subject,content){
		 $.ajax({
				type : "post",
				url:"<e:url value='/sendMail.e'/>",
				data : {"to" : emailTo,"subject":subject,"content":content}, 
				success : function(returnStr){
					if(returnStr == 'SUCCESS'){
						//$.messager.alert('信息提示', '发送成功', 'info');
					}
				}
		}); 
}

//发送提醒短信给电信管理员
function sendMessage(resId,msgTo,content){
	 $.ajax({
		type : "post",
		url : '<e:url value="/pages/frame/portal/resourcesPool/ResPoolAction.jsp?eaction=addMsg"/>',  
		data : {"resId":resId,"msgTo" : msgTo,"content":content}, 
		success : function(returnStr){
				//$.messager.alert('信息提示', '发送成功', 'error');
		}
	}); 
}


//添加按钮点击事件
function addRes(){
	$("#addResForm").form('reset');
	$("#eaction").val("add");
	$('#addResDiv').dialog('open');
	$('#addResDiv').dialog({
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
	$('#addResDiv').dialog("open");	
	
}

//编辑按钮点击事件
function editRes(id){
	$("#eaction").val("edit");
	$('#addResDiv').dialog({
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
	$(rowDataArr).each(function(index,item){
		if(item.ID==id){
			$("#resID").val(item.ID);
			$("#resName").val(item.RES_NAME);
			$("#subSysId").combobox('select',item.SUB_SYSTEM_ID);
			$("#url").val(item.URL);
			$("#position").val(item.MENU_POSITION);
			$("#resDesc").val(item.RES_DESC);
			return false;
		}
	});
	
	$('#addResDiv').dialog('open');
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
				success : function(returnStr){
					if($.trim(returnStr) == '1'){
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
   	content+='<a class="link" href="javascript:void(0);" onclick="delRes(\''+rowData.ID +'\');">删除</a>&nbsp;';
   	
	if(rowData.RES_STATE=="1"){
   		content+='<a class="link" href="javascript:void(0);" onclick="launch(\''+rowData.ID +'\');">发起</a>&nbsp;';
   	}
   	return content;
}

//重新发起功能请求
function launch(resId){
	var resName="";
	$(rowDataArr).each(function(index,item){
		if(item.ID==resId){
			resName=item.RES_NAME;
			return false;
		}
	});
	$.messager.confirm("操作提示", "确定要重新发起此功能请求吗？", function (torf) {
		if(torf){
			$.ajax({
				type : "post",
				url : '<e:url value="/pages/frame/portal/resourcesPool/ResPoolAction.jsp?eaction=launch"/>',  
				data : {"resId" : resId}, 
				success : function(returnStr){
					if($.trim(returnStr) == '1'){
						$.messager.alert('信息提示', '发起成功', 'info');
						$('#resTable').datagrid('reload');
						 //发送提醒邮件给电信管理员	
						 emailTo="";
						 var msgTo="";
					     <e:forEach items="${receiver.list}" var="email">
					          emailTo+='${email.EMAIL}'+",";
					          msgTo+='${email.MOBILE}'+",";
					     </e:forEach>
					     var subject="有驳回后重新发起的功能，请审核";
					     var content="功能资源池有名称为“"+resName+"”的功能驳回后被重新发起，请您审核!";
						 //sendEmail(emailTo,subject,content); 
						 sendMessage("",msgTo,content);
					}else{
						$.messager.alert('信息提示', '发起失败', 'error');
					}
				}
			});
		}
	});
}
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
    $('#resTable').datagrid('load',{  
    	 qName:$('#qName').val(),  
    	 qState:$('#qState').combobox('getValue'),
    	 qSubSys:$('#qSubSys').combobox('getValue')
      }  
    );  

}	
//打开目录树
function openTree(){
	var selId=$('#subSysId').combobox('getValue');
	if(selId==""){
		$.messager.alert('信息提示', '请先选择子系统', 'info');
		return;
	}
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
	if(isleaf){
		$.messager.alert('信息提示', '请选择非叶子节点', 'info');
	}else{
		path="";
		path=getFullPath(node)+"/"+node.text;
		$("#position").val(path);
		$('#tree_panel').dialog('close');
	}
}

var path="";
function getFullPath(node){
	if($('#tt').tree('getParent', node.target).id!="0"){
		getFullPath($('#tt').tree('getParent', node.target));
	}
	path+="/"+$('#tt').tree('getParent', node.target).text;
	return path;
}

</script>
<link rel="stylesheet" type="text/css" href="<e:url value="/resources/themes/common/css/links.css"/>">

</head>
<body>
    
   <div id="resToolbar">
		<form id="queryForm" name="queryForm">
		<h2>功能名称资源池</h2>
		<div class="search-area">
			功能名称: <input type="text" id="qName" name="qName" style="width:100px;"/>
			功能状态:
			   <select id="qState" name="qState" class="easyui-combobox" style="width:100px">
                     <option value="" selected="selected">--请选择--</option>
                     <option value="0">等待</option>
                     <option value="1">驳回</option>
                     <option value="2">待发布</option>
                     <option value="3">已发布</option>
                  </select>
				分系统:
				<e:select id="qSubSys" name="qSubSys" items="${SysList.list}" value="CODE" label="TEXT" headLabel="--请选择--" headValue=""  style="width:100px" class="easyui-combobox"/>
				<a href="javascript:void(0)" onclick="doSearch()" class="easyui-linkbutton">查询</a>
				<a href="javascript:void(0);" class="easyui-linkbutton" onclick="addRes()">新增</a>
		</div>
		</form>
	</div>
	<c:datagrid id="resTable" url="/pages/frame/portal/resourcesPool/ResPoolAction.jsp?eaction=resList" pageSize="30" style="width:auto;height:auto;"  download="true" nowrap="false" fit="true" border="false" toolbar="#resToolbar">
		<thead>
			<tr>
				<th field="RES_NAME" width="50" align="center">功能名称</th>
				<th field="RES_STATE" width="50" align="center" formatter="formatState">功能状态</th>
				<th field="SUBSYSTEM_NAME" width="100" align="center">所属分系统</th>
				<th field="MENU_POSITION" width="150" align="center">建议菜单位置</th>
				<th field="CREATE_TIME" width="100" align="center">创建时间</th>
				<th field="CREATE_USER" width="100" align="center">创建人</th>
				<th field="opt" width="120" align="left" formatter="formatOpt">操作</th>
			</tr>
		</thead>
	</c:datagrid>
	
	<!-- 新建功能，修改功能-->
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
		  <tr style="display:none">
		    <th align="right">建议菜单位置：</th>
		    <td>
		      <input type="text" id="position" name="position" class="easyui-validatebox"  style="width:250px" onclick="openTree()"/>
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
	
	
	
	
	<!-- 菜单树 -->
	<div id="tree_panel" title="系统菜单" style="width:450px;height:380px;">
     		<a:tree id="tt" url='${treeDataUrl}' checkbox="false" dnd="true" onClick="clickNode" onDblClick="dbClickNode"/> 
    </div>
   

</body>
</html>