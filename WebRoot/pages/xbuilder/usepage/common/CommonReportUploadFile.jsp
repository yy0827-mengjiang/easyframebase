<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<c:resources type="easyui,highchart,app" style="${ThemeStyle }" />
<%
	String xlserror = "" + request.getAttribute("xlserror");
	String error = "" + request.getAttribute("error");
	String ok = "" + request.getAttribute("ok");
%>
<e:q4o var="logObj">
	SELECT FILE_FACT_NAME FROM X_REPORT_UPLOAD_DATA_LOG WHERE LOG_ID=#logId#
</e:q4o>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>上传文件</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css"/>
		<e:set var="reportID">${param.reportId}</e:set>
		<script>
			function uploadfile(filePath){
				$("#uploadShowText").val(filePath);
		  		var obj = $('#fileobj${reportID }').filebox("getValue");
		  	    if(obj != '' && (obj.substring(obj.length -3,obj.length) == 'xls'||obj.substring(obj.length -4,obj.length) == 'xlsx')){
		  	    	var extds = $("#extdsHidden", window.parent.document).val();
		  	    	$('#extds${reportID}').val(extds);
		  	    	$('#form${reportID }').attr('action',appBase+'/xbuilderUploadDimsion.e');
					$('#form${reportID }').attr('method','post');
					$('#form${reportID }').attr('enctype','multipart/form-data');
					$('#form${reportID }').submit();
	  	    	}else if(obj == ''){
	  	    		top.$.messager.alert("提示信息","您未选择文件，不能上传文件！","info");
		  	    	return;
		  	     }else{
		  	    	top.$.messager.alert("提示信息","请您选择xls文件进行上传！","info");
		  	    	return;
	  	    	}
			}
			function clearFile(reportId,fieldName){
				var fieldName='${param.fieldName}';
				$("#"+fieldName, window.parent.document).val("");
				$("#uploadShowText").val("");
			}
			$(function(){
				var xlserror = '<%=xlserror%>';
				var error = '<%=error%>';
				var ok = '<%=ok%>';
				var reportId='${reportID}';
				var logId='${param.logId}';
				var fieldName='${param.fieldName}';
				if(ok != '' && ok == 'ok'){
					top.$.messager.alert("提示信息","上传成功","info");
					$("#upload"+reportId).removeAttr("disabled");
					if(logId!=''&&$.trim(logId)!='null'){
						$("#"+fieldName, window.parent.document).val(logId);
					}
				}
				if(error != '' && error == 'error'){
					top.$.messager.alert("提示信息","上传过程中出错！","error");
				}
			})
		</script>
		<style>
			.upload1{ position:relative;}
			.upload_file1{ position:absolute; left:0;top:0;opacity:0;filter:alpha(opacity:0);}
		</style>
	</head>
	<body>
		<form id="form${reportID }" name="form${reportID }" action="" class="searchBox1">
			<!-- <input type="file" id="fileobj${reportID }" name="fileobj${reportID }" style="width:200px;float:left;"/> -->
			<input type="hidden" id="idfileobj${reportID }" name="idfileobj${reportID }"value="${reportID }" style="width:200px;"/>
			<input type="hidden" id="extds${reportID}" name="extds${reportID}" value=""/>
			<input type="hidden" id="dim${reportID}" name="dim${reportID}" value="${param.fieldName}"/>
			<input type="hidden" id="reportId" name="reportId" value="${reportID}">
			<input class="easyui-filebox"id="fileobj${reportID }" name="fileobj${reportID }" style="width:200px;" data-options="buttonText:'浏览',onChange:function(newValue,oldValue){uploadfile(newValue)}" >
			
			<a id="clearBtn${reportID }" href="javascript:void(0)" class="easyui-linkbutton" onclick="clearFile('${reportID }','${param.fieldName}')"> 清空 </a>
				
		</form>
		<!-- 
			<iframe id="iframeR2013101514565376729194"
				name="iframeR2013101514565376729194" width="248" height="31"
				align="middle" noresize="noresize" scrolling="no" frameborder="0"
				src="<e:url value='/pages/ebuilder/usepage/formal/R2013101514565376729194/MyJsp.jsp'/>">
			</iframe>
		 -->
	</body>
</html>


