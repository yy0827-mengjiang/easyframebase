<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4l var="TypeList">
	SELECT '1' TYPE_CODE,'已发布' TYPE_DESC  FROM DUAL UNION ALL SELECT '0' TYPE_CODE,'未发布' TYPE_DESC  FROM DUAL
</e:q4l>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>历史公告</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<c:resources type="easyui"  style="${ThemeStyle }"/>
		<e:style value="/resources/themes/base/boncBase@links.css"/>
		<script type="text/javascript">
			$(function(){
				$(window).resize(function(){
				 	$('#noticeTable').datagrid('resize');
				 });
			});
			function doSearch(){
				var params = {};
		    	params.post_title=$('#post_title').val();
		    	params.issue_date=$('#issue_date').datebox('getValue');
		    	params.begin_date=$('#begin_date').datebox('getValue');
		    	params.end_date=$('#end_date').datebox('getValue');
		    	params.post_state=$('#post_state').val();
				//$('#noticeTable').datagrid('options').queryParams=params;
				$('#noticeTable').datagrid("load",params);
			}
			function toContent(post_id){
				$("#post_id").val(post_id);
				$("#reportIdForm").submit();
			}
			function formatterBT(value,rowData){
				return '<a href="javascript:void(0);" style="text-decoration: none;margin: 0 5px;" onclick="toContent(\''+rowData.POST_ID+'\')">'+value+'</a>';
			}
		</script>
	</head>
	<body>
		<table id="tbar" style="width:100%;">
			<tbody>
				<tr>
					<td>
						公告标题:
						<input id="post_title" type="text" name="post_title" style="width:120px" >
					</td>
					<td>
						发布时间:
						<c:datebox id="issue_date" name="issue_date" required="false" />
					</td>
					<td>
						开始时间:
						<c:datebox id="begin_date" name="begin_date" required="false"  />
						结束时间:
						<c:datebox id="end_date" name="end_date" required="false"  />
					</td>
					<td>
						公告状态:<e:select id="post_state" name="post_state" items="${TypeList.list}" label="TYPE_DESC" value="TYPE_CODE" headLabel="全部" headValue=""/>
					</td>
					<td>
						<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doSearch();">查询</a>
					</td>
				</tr>
			</tbody>
		</table>
		<c:datagrid url="/pages/frame/notice/NoticeAction.jsp?eaction=list" id="noticeTable" style="width:auto;height:auto;"
					title="公告历史" download="true" singleSelect="true" nowrap="false" toolbar="#tbar">
			<thead>
				<tr>
					<th field="POST_TITLE" width="150" formatter="formatterBT">
						公告标题
					</th>
					<th field="ISSUE_DATE" width="100" formatter="formatDAT_noticeTable">
						发布时间
					</th>
					<th field="BEGIN_DATE" width="100" formatter="formatDAT_noticeTable">
						开始时间
					</th>
					<th field="END_DATE" width="100" formatter="formatDAT_noticeTable">
						结束时间
					</th>
					<th field="POST_STATE" width="100">
						公告状态
					</th>
					<th field="UPDATE_DATE" width="100">
						修改时间
					</th>
					<th field="USER_ID" width="100">
						发布人
					</th>
				</tr>
			</thead>
		</c:datagrid>
		<form action="<e:url value="/pages/frame/notice/NoticeShow.jsp"/>" method="post" id="reportIdForm">
		    <input type="hidden" id="post_id" name="post_id"/>
		</form>
	</body>
</html>