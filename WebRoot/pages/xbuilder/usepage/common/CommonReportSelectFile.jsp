<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>">

		<title>My JSP 'CommonReportSelectFile.jsp' starting page</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
	</head>
		<e:set var="reportID">${param.reportId}</e:set>
		<e:q4o var="fileBean">
			SELECT DISTINCT T.FILE_FACT_NAME FILE_FACT_NAME
			  FROM X_REPORT_UPLOAD_DATA_LOG T
			 WHERE T.LOG_ID=#logId#
			   AND T.REPORT_ID = '${reportID }'
			   AND T.UPLOAD_USER = '${sessionScope.UserInfo.USER_ID }'
			   AND T.FIELD_NAME = '${param.fieldName}'
		</e:q4o>
	<script>
		function reportCZ(value,rowData){
			var res = '';
			var read = '<a href="javascript:void(0);" style="text-decoration: none;margin:0 5px;" onclick="selectxls(\''+rowData.REPORT_ID+'\',\'${param.fieldName}\',\''+rowData.LOG_ID+'\')">选择</a>';
			var del =  '<a href="javascript:void(0);" style="text-decoration: none;margin:0 5px;" onclick="delxls(\''+rowData.REPORT_ID+'\',\''+rowData.LOG_ID+'\')">删除</a>';
			res = read + del;
			return  res;
		}
		function selectxls(reportId,fieldName,logId){
			var fieldName='${param.fieldName}';
			$("#"+fieldName).val(logId);
			$("#iframe_upload_"+fieldName).attr("src",appBase+"/pages/xbuilder/usepage/common/CommonReportUploadFile.jsp?reportId="+reportId+"&fieldName="+fieldName+"&logId="+logId+"");
			$('#upload'+reportId).window('close');
		}
		function delxls(reportId,logId){
			var info ={};
			info.logId = logId;
			info.extds = $("#extdsHidden", window.parent.document).val();
			var path = appBase+"/xbuilderDelSelectFile.e";
			$.post(path,info,function(){
				$("#report"+reportId+"Table").datagrid("load",$("#report"+reportId+"Table").datagrid("options").queryParams);
			})
		}
		/*
		$(function(){
			$('#upload${reportID}').window({
			   onClose:function(){
			      f_query_${reportID}();
			    }
			});
		});
		*/
	</script>
	<body>
		<!-- 
		<table width="590" border=0>
			<tr>
				<td align="center">
					<e:if condition="${fileBean.FILE_FACT_NAME==''||fileBean.FILE_FACT_NAME==null }">
						<a href="javascript:void(0);" class="easyui-linkbutton" onclick="javascript:clearxls()"  data-options="disabled:true">清空选择</a>&nbsp;&nbsp;
					</e:if>
					<e:if condition="${fileBean.FILE_FACT_NAME!=''&&fileBean.FILE_FACT_NAME!=null }">
						<a href="javascript:void(0);" class="easyui-linkbutton" onclick="javascript:clearxls()">清空选择</a>&nbsp;&nbsp;
					</e:if>
					
					
				</td>
			</tr>
		</table>
		 -->
		<c:datagrid url="pages/xbuilder/usepage/common/CommonReportSelectFileAction.jsp?eaction=LIST&reportId=${reportID}&fieldName=${param.fieldName}" id="report${reportID}Table" pageSize="15"
				       style="width:600px;height:298px;" download="true" nowrap="false" toolbar="#tbar">
		<thead>
			<tr>
				<th field="FILE_FACT_NAME" width="100" align="center">已上传文件</th>
				<th field="UPLOAD_DATE" width="50" align="center">上传时间</th>
				<th field="cz" width="50" align="center"formatter="reportCZ" >操作</th>
			</tr>
		</thead>
	</c:datagrid>
	</body>
</html>
