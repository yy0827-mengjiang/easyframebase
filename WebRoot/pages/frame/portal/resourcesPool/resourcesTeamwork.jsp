<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<e:q4l var="SysList">
SELECT SUBSYSTEM_ID CODE, SUBSYSTEM_NAME TEXT FROM D_SUBSYSTEM ORDER BY ORD 
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
	
	$('#auditResPanel').dialog({
		title:"功能审批",
		closed: true,
		modal: true,
		buttons:[{
			text:'提交',
			iconCls:'icon-ok',
			plain:true,
			handler:function(){
				$('#auditResForm').submit();
			}
		}]
	});
	
	
	//审核功能表单
	$('#auditResForm').form({
		onSubmit : function(){
			return $(this).form('validate');
		},
		success:function(data){
			if(data == 1){
				$.messager.alert('信息提示', '反馈成功!', 'info');
				doSearch();
				$('#auditResPanel').dialog("close");
			}else{
				$.messager.alert('信息提示', '反馈失败!', 'error');
    		}
    	}
	});
	
	$('#viewResDiv').dialog({
		title:"详细信息",
		closed: true,
		modal: true
	});
	
	
});




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
   	var content='<a class="link" href="javascript:void(0);" onclick="viewRes(\''+rowData.ID +'\');">查看详细</a>&nbsp;';
   	content+='<a class="link" href="javascript:void(0);" onclick="previewRes(\''+rowData.ID +'\');">预览</a>&nbsp;';
   	if(rowData.RES_STATE!="3"){
   		if(rowData.IS_AUDIT=="已审")
   			content+='<a class="link" href="javascript:void(0);" onclick="comment(\''+rowData.ID +'\');">修改反馈</a>&nbsp;';
   		else
   			content+='<a class="link" href="javascript:void(0);" onclick="comment(\''+rowData.ID +'\');">反馈</a>&nbsp;';
   	}
   	return content;
}

function comment(resId){
	var url="<e:url value='/pages/frame/portal/resourcesPool/ResPoolAction.jsp?eaction=getTeamwork'/>";
	$.post(url,{userId:"${UserInfo.USER_ID}",resId:resId},function(data){
		$("#comments").val($.trim(data));
	});
	$("#resId").val(resId);
    $('#auditResPanel').dialog("open");	
}


var createUserId="";
var auditResName="";


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
    	 data:{qName:$('#qName').val(),
    		   qState:$('#qState').combobox('getValue'),
    		   qSubSys:$('#qSubSys').combobox('getValue'),
    		   auditState:$('#auditState').combobox('getValue'),
    		   userId:'${UserInfo.USER_ID}'
    		 }, 
    	 dataType:"json", 
    	 success:function(json){ 
    	     $("#resTable").datagrid("loadData",json); 
    	 } 
    }); 
}	


</script>
</head>
<body>
   <div id="resToolbar">
   	<h2>协同审核</h2>
   	 <div class="search-area">
		<form id="queryForm" name="queryForm">
			功能名称:<input type="text" id="qName" name="qName" style="width:100px;"/>
			功能状态:<select id="qState" name="qState" class="easyui-combobox" style="width:100px;">
                      <option value="">--请选择--</option>
                      <option value="0">等待</option>
                      <option value="1">驳回</option>
                      <option value="2">待发布</option>
                      <option value="3">已发布</option>
                   </select>
			分系统:<e:select id="qSubSys" name="qSubSys" items="${SysList.list}" value="CODE" label="TEXT" headLabel="--请选择--" headValue=""  style="width:100px" class="easyui-combobox"/>
			审阅状态:<select id="auditState" name="auditState" class="easyui-combobox" style="width:100px;">
                      <option value="">--请选择--</option>
                      <option value="0" selected="selected">未审</option>
                      <option value="1">已审</option>
                   </select>
					<a href="javascript:void(0)" onclick="doSearch()" class="easyui-linkbutton">查询</a>
		</form>
	  </div>
	</div>
	<c:datagrid id="resTable" url="/pages/frame/portal/resourcesPool/ResPoolAction.jsp?eaction=resList&userId=${UserInfo.USER_ID}&auditState=0" pageSize="30"  download="true" nowrap="false" fit="true" border="false" toolbar="#resToolbar">
		<thead>
			<tr>
				<th field="RES_NAME" width="50" align="center">功能名称</th>
				<th field="RES_STATE" width="50" align="center" formatter="formatState">功能状态</th>
				<th field="SUBSYSTEM_NAME" width="100" align="center">所属分系统</th>
				<th field="MENU_POSITION" width="150" align="center">建议菜单位置</th>
				<th field="CREATE_TIME" width="100" align="center">创建时间</th>
				<th field="CREATE_USER" width="100" align="center">创建人</th>
				<th field="IS_AUDIT" width="50" align="center">审阅状态</th>
				<th field="opt" width="140" align="center" formatter="formatOpt">操作</th>
			</tr>
		</thead>
	</c:datagrid>
	
	<!-- 审核表单  -->
	<div id="auditResPanel" style="width:450px;height:auto;" >
	  <form id="auditResForm" name="auditResForm" method="post" action="<e:url value='/pages/frame/portal/resourcesPool/ResPoolAction.jsp?eaction=teamAudit'/>">
		<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="newTable">
		  <tr>
		    <th align="right">反馈意见：</th>
		    <td><textarea id="comments" name="comments" class="easyui-validatebox"  style="width:250px" rows="5"></textarea></td>
		  </tr>
		</table>
		<input type="hidden" name="resId" id="resId" value="" />
		<input type="hidden" name="userId" id="userId" value="${UserInfo.USER_ID}" />
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
	
	
    
    
</body>
</html>

