<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<% 
	String DownLoadServerAction = request.getSession().getServletContext().getAttribute("DownLoadServerAction") + "";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources>
		<title>导出中心</title>
	    <e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/resources/themes/blue/boncBlue.css"/>
	    <script type="text/javascript">
		    function reportCZ(value,rowData){
				var res = '';
				var cancelBtn = '<a href="javascript:void(0);" class="btn-submit1" style="text-decoration: none;margin: 0 5px;" onclick="cancelExport(\''+rowData.ID+'\')">取消</a>';
				var downloadBtn = '<a href="javascript:void(0);" class="btn-submit1" style="text-decoration: none;margin: 0 5px;" onclick="doDownload(\''+rowData.ID+'\',\''+rowData.FILE_PATH+'\',\''+rowData.FILE_NAME+'\')">下载</a>';
				var del = '<a href="javascript:void(0);" class="btn-submit1" style="text-decoration: none;margin: 0 5px;" onclick="deleteFile(\''+rowData.ID+'\',\''+rowData.STATUS_ID+'\')">删除</a>';
				var status = rowData.STATUS_ID;
				if(status == 1 ||status == 2 ){
					res = cancelBtn+del;
				}else if(status==3){
					res = del;
				}else if(status==4){
					res = downloadBtn+del;
				}else{
					res = del;
				}
				return res;
			}
			//删除文件
		    function deleteFile(id,statusId){
		    	$.messager.confirm('确认信息','是否确定删除文件？',function(r){  
					if(r){
				    	var url = appBase+'/deleteExportFileEC.e';
				    	var data  = {'id':id,'statusId':statusId};
				    	$.post(url,data,function(data){
				    		var _data = JSON.parse(data);
					    	if(_data.flag=='true'){
			    	  			$.messager.alert("提示信息","删除成功","info");
						    	doQuery();
					    	}else{
					    		$.messager.alert("提示信息","删除失败，请联系管理员！","error");
					    	}
				    	});
					}
				});
		    }
		    //取消导出
		    function cancelExport(id){
		    	$.messager.confirm('确认信息','是否确定取消生成文件？',function(r){  
					if(r){
				    	 $.ajax({
						      type : "post",  
						      url : appBase+'/cancelExportEC.e',  
						      data : {'id':id},  
						      success : function(data){
						    	  var _data = JSON.parse(data);
						    	  if(_data.flag=='true'){
						    	  		top.$.messager.alert("提示信息","取消成功","info");
						    	  		doQuery();
						    	  }else{
						    	  		top.$.messager.alert("提示信息","取消失败，请联系管理员！","error");
						    	  }
						      }
						  }); 
				  
					}
				});
		    }
		    
			//下载文件
			function doDownload(id,filePath,fileName){
				var form=$("<form>");//定义一个form表单
				form.attr("style","display:none");
				form.attr("method","post");
				form.attr("action",'<%=DownLoadServerAction%>');
				var input1=$("<input>");
				input1.attr("type","hidden");
				input1.attr("name","id");
				input1.attr("value",id);
				$("body").append(form);//将表单放置在web中
				form.append(input1);
				form.submit();//表单提交 
				form.remove();
		    }
			
			//查询
			function doQuery(){
				var paramMap = {
						fileName:$("#fileName").val(),
						status:$("#status").val(),
						optUser:$("#optUser").val(),
						optTime:$("#optTime").datebox('getValue')
				}
				$('#exportTable').datagrid('load',paramMap);
			}
			
			$(function(){
				var intervalId = setInterval(function(){
				   var paramMap = {
							fileName:$("#fileName").val(),
							status:$("#status").val(),
							optUser:$("#optUser").val(),
							optTime:$("#optTime").datebox('getValue')
					}
					$.ajax({
					      type : "post",  
					      url : appBase+'/pages/frame/download/exportInfoAction.jsp?eaction=LIST',  
					      data : paramMap,  
					      success : function(data){
					    	  var rows = $.parseJSON(data).rows;
					    	  var trs = $(".datagrid-btable").eq(1).find("tr");
					    	  for(var i=0;i<trs.length;i++){
					    	  	for(var j=0;j<rows.length;j++){
					    	  		if($(trs[i]).find("td[field=ID] > div").html().trim()==rows[j]["ID"]){
					    	  			$(trs[i]).find("td[field=STATUS_NAME] > div").html(rows[j].STATUS_NAME);
					            	  	$(trs[i]).find("td[field=OPT_TIME] > div").html(rows[j].OPT_TIME);
					            	 	$(trs[i]).find("td[field=cz] > div").html(reportCZ('',rows[j]));
					            	 	break;
					    	  		}
					    	  	}
					    	 }
					      }
					  });  
				},3000); 
			});
			
		</script>
	</head>
	<e:q4l var="status" sql="frame.download.status"/>
	
	<body>
		<div id="tbar">
			<h2>导出信息</h2>
			<div class="search-area">
				文件名称： <input type="text" style="width: 100px" id="fileName" name="fileName" />
				状态  ：  <e:select items="${status.list}" label="status" value="code" name="status" id="status" class="easyui-validatebox" required="true" defaultValue="${param.status}" />
				操作用户： <input type="text" style="width: 100px" id="optUser" name="optUser"/>
				操作时间： <input class="easyui-datebox" style="width: 100px" id="optTime" name="optTime"/>
				<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQuery()">查询</a>
			</div>
		</div>
		<c:datagrid
			url="pages/frame/download/exportInfoAction.jsp?eaction=LIST" fit="true" border="false" remoteSort="true" 
			id="exportTable" pageSize="15" style="width:auto;"
			download="true" nowrap="true" toolbar="#tbar">
			<thead>
				<tr>
					<th field="ID" width="200" align="center" hidden="true">
						ID
					</th>
					<th field="FILE_NAME" width="200" align="center" sortable="true">
						文件名称
					</th>
					<th field="DOWN_PARAM_STR" width="200" align="center" sortable="true">
						查询条件
					</th>
					<th field="FILE_TYPE" width="80" align="center" sortable="true">
						文件类型
					</th>
					<th field="STATUS_NAME" width="80" align="center" sortable="true">
						状态
					</th>
					<th field="OPT_TIME" width="150" align="center" sortable="true">
						开始时间
					</th>
					
					<th field="USER_NAME" width="80" align="center" sortable="true">
						操作用户
					</th>
					<th field="cz" width="150" align="center" formatter="reportCZ">
						操作
					</th>
				</tr>
			</thead>
		</c:datagrid>
	</body>
</html>