<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4l var="TypeList">
	SELECT '1' TYPE_CODE,'已发布' TYPE_DESC  FROM DUAL UNION ALL SELECT '0' TYPE_CODE,'未发布' TYPE_DESC  FROM DUAL
</e:q4l>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>登陆日志</title>
		<c:resources type="easyui" style="${ThemeStyle }"/>
		<script type="text/javascript">
			$(function(){
				$(window).resize(function(){
				 	$('#noticeTable').datagrid('resize');
				 });
				var states = '${param.state}';
				if(states!= '' && (states=='1'||states==1)){
					$.messager.alert("信息","公告群发成功！","info");
				}
				/*
				if(states!= '' && (states=='0'||states==0)){
					var step = '${e:length(LogList.list)}';
					if(step !=null && step>0){
						$.messager.alert("信息","公告群发失败，今日公告已发！","warning");
					}else{
						$.messager.alert("信息","公告群发失败！","warning");
					}
				}*/
			});
			function doDelete(post_id){
			var info = {};				
			  info.postId = post_id;		  
				$.messager.confirm('确认框', '是否确认删除此公告?', function(r){  
	                if (r){  
	                    $.post('<e:url value="/pages/frame/notice/NoticeAction.jsp?eaction=delete"/>',info, function(data){
	                    var temp = $.trim(data);
	                    	if(temp!=0&&temp!=null&&temp!=''){	
								$.messager.alert("信息","删除成功！","info");
								$('#noticeTable').datagrid("load",$("#noticeTable").datagrid("options").queryParams);
							}else {
								$.messager.alert("信息","删除过程中出现错误，请联系管理员！","error");
							}	
						 });
	                }  
	            });  
			}
			function doSearch(){
				$("#procLogForm").attr('action','<e:url value="/pages/frame/notice/NoticeManager.jsp"/>');
			    $("#procLogForm").attr('method','post');
			    $("#procLogForm").submit();
			}
			function toEdit(post_id){
				window.location.href='<e:url value="/pages/frame/notice/NoticeEdit.jsp"/>?post_id='+post_id;
			}
			function toContent(post_id){
				window.location.href='<e:url value="/pages/frame/notice/NoticeShow.jsp"/>?post_id='+post_id;
			}
			function formatterCZ(value,rowData){
				/*
				var onclickStr = '<a href="javascript:void(0);" id="sendbtn" style="text-decoration: none;margin: 0 5px;" onclick="sendtoyxin(\''+rowData.POST_ID+'\')">发送至易信</a>';
				var step = '${e:length(LogList.list)}';
				if(step !=null && step>0){
					onclickStr = '发送至易信';
				}*/
				var content ='<a href="javascript:void(0);" style="text-decoration: none;margin: 0 5px;" onclick="toEdit(\''+rowData.POST_ID+'\')">编辑</a>'+
							 '<a href="javascript:void(0);" style="text-decoration: none;margin: 0 5px;" onclick="doDelete(\''+rowData.POST_ID+'\')">删除</a>';
							// +onclickStr;
				return content;
			}
			function formatterBT(value,rowData){
				return '<a href="javascript:void(0);" style="text-decoration: none;margin: 0 5px;" onclick="toContent(\''+rowData.POST_ID+'\')">'+value+'</a>';
			}
			function sendtoyxin(post_id){
				$.messager.confirm('提示', '由于易信服务限制每天只能发送一条群组消息，此公告发送后24小时内无法再次发送，请确认公告内容，谨慎发送！', function(r){
					if (r){
						window.location.href='<e:url value="/sendtoyxin.e"/>?post_id='+post_id;
						window.returnValue=false;
					}
				});
			}
		</script>
		
<e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/resources/themes/blue/boncBlue.css"/>
	</head>
	<body>
	<div id="tbar" class="datagrid-toolbar">
			<h2>公告管理</h2>
			<div class="search-area">
				<form id="procLogForm" name="procLogForm">
					公告标题：<input id="post_title" type="text" name="post_title"  value="${param.post_title}" style="width:100px;"/>
					开始时间：<c:datebox id="begin_date" name="begin_date" required="false"  defaultValue="${param.begin_date}" style="width:80px;"/>
					结束时间：<c:datebox id="end_date" name="end_date" required="false"  defaultValue="${param.end_date}" style="width:80px;"/>
					公告状态：<e:select id="post_state" style="width:100px" name="post_state" items="${TypeList.list}" label="TYPE_DESC" value="TYPE_CODE" headLabel="全部" headValue="" defaultValue="${param.post_state}" />
					<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doSearch();">查询</a>
					<a class="easyui-linkbutton easyui-linkbutton-green" href='<e:url value="/pages/frame/notice/NoticeAdd.jsp"/>'>新增</a>
				</form> 
			</div>
		</div>
		<c:datagrid url="/pages/frame/notice/NoticeAction.jsp?eaction=list&post_title=${param.post_title}&issue_date=${param.issue_date}&begin_date=${param.begin_date}&end_date=${param.end_date}&post_state=${param.post_state}" id="noticeTable" pageSize="15"  style="width:auto;"
					fit="true"  nowrap="false" toolbar="#tbar" border="false">
			<thead>
				<tr>
					<th field="POST_TITLE" width="150" formatter="formatterBT">
						公告标题
					</th>
					<th field="ISSUE_DATE" width="100" align="center" formatter="formatDAT_noticeTable">
						发布时间
					</th>
					<th field="BEGIN_DATE" width="100" align="center" formatter="formatDAT_noticeTable">
						开始时间
					</th>
					<th field="END_DATE" width="100" align="center" formatter="formatDAT_noticeTable">
						结束时间
					</th>
					<th field="POST_STATE" width="80" align="center">
						公告状态
					</th>
					<th field="UPDATE_DATE" width="100" align="center" formatter="formatDAT_noticeTable">
						修改时间
					</th>
					<th field="USER_ID" width="80" align="center">
						发布人
					</th>
					<th field="CZ" width="120" align="center" formatter="formatterCZ">
						操作
					</th>
				</tr>
			</thead>
		</c:datagrid>
	</body>
</html>