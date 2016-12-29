<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources>
		<title>Insert title here</title>
		<e:style value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
		<e:style value="/resources/easyResources/component/easyui/icon.css" />
		<e:script value="/resources/easyResources/component/easyui/jquery.easyui.min.js" />
		<e:script value="/resources/easyResources/component/easyui/locale/easyui-lang-zh_CN.js" />
		<e:script value="/resources/easyResources/component/easyui/plugins/datagrid-detailview.js" />
	    <e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/resources/themes/blue/boncBlue.css"/>
		<script type="text/javascript">
			var interval; 
			var interval2;
			var dotCount=0;
			$(function(){
				$("#syncBtn").click(function(){
					$.post(appBase+"/syncAllJspPage.e",null,function(data){
						if(data=="0"){
							$.messager.alert("提示信息","<br/>同步失败！",'error');
						}else{
							$("#syncBtn").linkbutton("disable");
							interval2 = setInterval(animateMsg,200);
							interval = setInterval(checkSyncFinished,2000);
						}
					});
				});
			});
			
			function checkSyncFinished(){
				$.post(appBase+"/isSyncFinished.e",null,function(data){
					if(data=="1"){
						if(interval!=undefined){
							clearInterval(interval);
						}
						if(interval2!=undefined){
							clearInterval(interval2);
						}
						var url = appBase+"/pages/xbuilder/pagemanager/SyncJspLog.jsp";
						$("#msgDiv").html("同步完成，<a href='"+url+"' style='text-decoration:underline;color:#00f'>查看同步日志</a>！");
						$("#syncBtn").linkbutton("enable");
					}else if(data=="0"){
						
					}else{
						if(interval!=undefined){
							clearInterval(interval);
						}
						if(interval2!=undefined){
							clearInterval(interval2);
						}
						$("#msgDiv").html(data);
						$("#syncBtn").linkbutton("enable");
					}
				});
			}
			
			function animateMsg(){
				var msg = "正在同步，请稍候 ";
				for(var i=0;i<dotCount;i++){
					msg+=". ";
				}
				$("#msgDiv").html(msg);
				dotCount++;
				if(dotCount==6){
					dotCount=0;
				}
			}
		</script>
	</head>
	<body>
		<div class="contents-head" id="tb1">
	       <h2>集群文件同步</h2>
		</div>
	    <div id="container" style="margin:10px;">
	   			 <a href="javascript:void(0)" id="syncBtn" class="easyui-linkbutton">文件同步</a>
	   			 <div id="msgDiv" style="color:#c00"></div>
	    </div>
	</body>
</html>