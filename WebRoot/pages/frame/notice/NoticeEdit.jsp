<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="post" sql="frame.notice.quyById"/>
<e:q4l var="role_list">
select t1.POST_ID as "POST_ID", t1.ROLE_CODE as "ROLE_CODE", t2.ROLE_NAME as "ROLE_NAME"
  from E_POST_ROLE t1 , E_ROLE t2
 where t1.role_code = t2.role_code 
   and t1.post_id = #post_id#
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
		<script src="<e:url value="/resources/xheditor/xheditor-1.1.14-zh-cn.min.js"/>"></script>
		<script type="text/javascript">
		$(function(){
			var rows = $.evalJSON('${e:java2json(role_list.list)}');
			//alert($.toJSON('${e:java2json(role_list.list)}'));
			if(rows.length>0){
				var list_id = [];
				var list_name = [];
				$(rows).each(function(){
					
					list_id.push(this.ROLE_CODE);
					list_name.push(this.ROLE_NAME);
				});
				$('#post_role').val('["'+list_id.join('","')+'"]');
				$('#role_name').val(list_name.join(","));
			}
		});
		function toSelectRole(){
			$('#roleWin').load(appBase + '/pages/frame/role/RoleList.jsp',function (data){
				$(this).window({title: '添加角色'});
				$('.easyui-linkbutton').linkbutton();
				$(this).window('open');
			});
		}
		//选择
		function doSelectRole(){
			var rows = $('#roleTable').datagrid('getSelections');
			if(rows.length>0){
				var list_id = [];
				var list_name = [];
				$(rows).each(function(){
					list_id.push(this.ROLE_CODE);
					list_name.push(this.ROLE_NAME);
				});
				$('#post_role').val('["'+list_id.join('","')+'"]');
				$('#role_name').val(list_name.join(","));
			}
			$('#role_name').validatebox('validate');
			$('#roleWin').window('close');
		}
		
		function doEdit(){
			if($('#noticeForm').form('validate')){
				if($("#begin_date").datebox('getValue')>$("#end_date").datebox('getValue')){
					$.messager.alert('验证','<br/>结束时间就大于开始时间!','info');
					return;
				}
				if(!editor.getSource()){
					$.messager.alert('验证','<br/>请填写公告内容!','info');
					return;
				}
				var queryParam = $('#noticeForm').serialize();
				$.post(appBase + '/pages/frame/notice/NoticeAction.jsp?eaction=edit', queryParam, function(){
					window.location.href='<e:url value="/pages/frame/notice/NoticeManager.jsp"/>';
				});
			}
		}
		</script>
	</head>
	<body>
		<div class="contents-head">
			<h2>编辑公告</h2>
			<div class="search-area">
				<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doEdit();">保  存</a>
				<a href="<e:url value="/pages/frame/notice/NoticeManager.jsp"/>" class="easyui-linkbutton easyui-linkbutton-gray">取  消</a>
			</div>
		</div>
		<form id="noticeForm" method="post" action="#" >
			<input type="hidden" id="post_id" name="post_id" value="${post.POST_ID }">
			<table class="pageTable">
			<colgroup>
			<col width="10%">
			<col width="*">
			</colgroup>
				<tr>
					<th>公告标题:</th>
					<td><input type="text" name="post_title" id="post_title" value="${post.POST_TITLE}" class="easyui-validatebox" required style="width:400px;"></td>
				</tr>
				<tr>
					<th>发布时间:</th>
					<td><c:datebox id="issue_date" name="issue_date" defaultValue="${post.ISSUE_DATE}" required="true"/></td>
				</tr>
				<tr>
					<th>开始时间:</th>
					<td>
						<c:datebox id="begin_date" name="begin_date" defaultValue="${post.BEGIN_DATE}" required="true"/>
						结束时间:
						<c:datebox id="end_date" name="end_date" defaultValue="${post.END_DATE}" required="true"/>
					</td>
				</tr>
				<tr>
					<th>公告状态:</th>
					<td>
						<e:set var="tt">[{ "aa": "已发布", "bb": "1" },{ "aa": "未发布", "bb": "0" }]</e:set>
						<e:select id="post_state" name="post_state" items="${e:json2java(tt)}" label="aa" value="bb" defaultValue="${post.POST_STATE}" style="width:200px;"/>
					</td>
				</tr>
				<tr>
					<th>公告角色:</th>
					<td>
						<input type="text" id="role_name" readonly class="easyui-validatebox" required onclick="toSelectRole();" style="width:200px;"/>
						<input type="hidden" id="post_role" name="post_role" />
					</td>
				</tr>
				<tr>
					<th>公告内容:</th>
					<td>
						<textarea class="ckeditor" id="editor1" name="editor1"  cols="120" rows="12" style=" height:230px;">${post.POST_CONTENT}</textarea>
						<script type="text/javascript">
							var editor=$('#editor1').xheditor({tools:'Cut,Copy,Paste,Pastetext,|,Blocktag,Fontface,FontSize,Bold,Italic,Underline,Strikethrough,FontColor,BackColor,SelectAll,Removeformat,|,Align,List,Outdent,Indent,|,Hr,Table,|,Fullscreen',skin:'default'});
						</script>
					</td>
				</tr>
			</table>
		</form>
		<div id="roleWin" style="width: 640px;height:390px; padding:0; top:60; " closed="true" shadow="true"  modal="true" resizable="false" collapsible="true" minimizable="false" maximizable="false" ></div>
	</body>
</html>