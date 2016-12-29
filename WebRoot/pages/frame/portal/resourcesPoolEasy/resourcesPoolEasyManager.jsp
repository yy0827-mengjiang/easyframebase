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
<title>简化功能资源池</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<c:resources type="easyui" style="${ThemeStyle }"/>
<e:style value="resources/themes/common/css/icon.css"/> 
<link rel="stylesheet" type="text/css" href="/easy-work/resources/themes/common/css/links.css">
<style type="text/css">
.newTable { border-collapse:collapse; font-family:Arial, Helvetica, sans-serif; }
.newTable th { background:#e8e7e7; }
.newTable td { background:#f2f6ec; }
.newTable th, .newTable td { padding:5px 5px; border:1px solid #FFF; }
.link{margin: 0px 5px; text-decoration: none;}
</style>
<script>
var emailTo="";
var msgTo="";
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
   	var content='';
   	content+='<a class="link" href="javascript:void(0);" onclick="previewRes(\''+rowData.ID +'\');">预览</a>&nbsp;';   	
   	return content;
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
    	 qSubSys:$('#qSubSys').combobox('getValue')
      }  
    );  

}	

</script>
<link rel="stylesheet" type="text/css" href="<e:url value="/resources/themes/common/css/links.css"/>">

</head>
<body>
    
   <div id="resToolbar">
   	  <div class="topListUser">
		<form id="queryForm" name="queryForm" style="margin:0px; padding:0px">
			<dl>
				<dt>功能名称:</dt>
				<dd><input type="text" id="qName" name="qName" style="width:100px;"/></dd>
				<dt>分系统:</dt>
				<dd>
					<e:select id="qSubSys" name="qSubSys" items="${SysList.list}" value="CODE" label="TEXT" headLabel="--请选择--" headValue=""  style="width:100px" class="easyui-combobox"/>
				</dd>
				<p>
					<a href="javascript:void(0)" onclick="doSearch()" class="easyui-linkbutton">查询</a>
					
				</p>
			</dl>
		</form>
	  </div>
	</div>
	<c:datagrid id="resTable" url="/pages/frame/portal/resourcesPoolEasy/ResPoolAction.jsp?eaction=resList" pageSize="30" style="width:auto;height:auto;"  download="true" nowrap="false" fit="true" toolbar="#resToolbar">
		<thead>
			<tr>
				<th field="RES_NAME" width="50" align="center">功能名称</th>
				<th field="RES_STATE" width="50" align="center" formatter="formatState">功能状态</th>
				<th field="SUBSYSTEM_NAME" width="100" align="center">所属分系统</th>
				<th field="MENU_POSITION" width="150" align="center">建议菜单位置</th>
				<th field="CREATE_TIME" width="100" align="center">创建时间</th>
				<th field="CREATE_USER" width="100" align="center">创建人</th>
				<th field="opt" width="100" align="center" formatter="formatOpt">操作</th>
			</tr>
		</thead>
	</c:datagrid>
	
	

</body>
</html>