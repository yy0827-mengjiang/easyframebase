<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<% String root = request.getContextPath(); %>
<!DOCTYPE html>
<html>
<head>
<a:base/>
<!-- 获取知识库菜单ID -->
<e:q4o var="menuObj">
select resources_id menu_id from e_menu where url='pages/terminal/knowledge/knowledge.jsp'
</e:q4o>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<c:resources type="easyui" />
    <!--声明以IE最高版本浏览器内核或谷歌浏览器内核进行渲染 -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <!--声明以360极速模式进行渲染 -->
    <meta name=”renderer” content=”webkit” />
    <!--系统名称文本 -->
    <title>终端指标分析系统－知识库</title>
    <!-- 系统ICON图标（注:路径为TomCat根目录） -->
    <link rel ="Shortcut Icon" href="" />

    <!-- 独立Js脚本 -->
    <script type="text/javascript" src='<e:url value="/pages/terminal/resources/themes/base/js/boncCommon.js"/>'></script>
    <!-- 独立Css层叠样式表 -->
	<e:style value="/pages/terminal/resources/themes/base/boncBase@links.css"/>
     <script language="JavaScript">
        $(function(){
        //初始化时给隐藏的hidden赋值（知识库菜单的ID）
        var menuId1 = ${menuObj.menu_id}; 
        document.getElementById("menuId").value = menuId1;
        var areaNo = '${sessionScope.UserInfo.AREA_NO}';
        
        $(".EntryGroupLine input").bind("hover focus", function() {
            $(this).parent('.EntryGroupLine').addClass('onFocus');
            $(this).parent('.EntryGroupLine').parent('.EntryBox').siblings('.EntryBox').find('.EntryGroupLine').removeClass('onFocus')
            });
        })
            
        //上传文档
        function doAdd(){
			
        	var fileName = document.getElementById("uploadFile").value;
        	
			//截取文件后缀名  
	        var file_suffix = fileName.substring(fileName.lastIndexOf("."));
	        var fileType = $.trim(file_suffix);

	        //弹出后缀名   
	        if(fileType != ".xlsx" && fileType != ".xls" && fileType != ".docx" && fileType != ".doc" && fileType != ".txt" && fileType != ".pdf"  ){
	        	$("#msg").html("上传文档格式不正确,只支持.xlsx,.xls,.word,.txt和.pdf格式!");
	        	setTimeout(function() {
	        		$("#msg").html("");
	        	}, 3000);
	        	return false;
	        }else{
	       		$('#addFile').submit();	
	        }
		}
		
		//按条件查询
        function doQuery(){
        
        	var params = {};
			params.file_name = $('#file_name').val();
			params.file_type = $('#file_type').val();
					
			$('#table1').datagrid('options').queryParams = params;
			$('#table1').datagrid('reload');
        }
         //操作
		function formatterCZ(value, rowData) {
			var content = '';
			var content ='<a href="javascript:void(0);" style="text-decoration: none;margin: 0 5px;" onclick="Delete(\''+rowData.ID+'\')">删除</a>'+
			 '<a href="<%=root %>/downFiles.e?menuId=${menuObj.menu_id}&IDs=\''+rowData.ID+'\'" style="text-decoration: none;margin: 0 5px;")">下载</a>';
		
			return content;
		}
		
		//删除文档
		function Delete(ID){
			$.messager.confirm('删除文档', '确定删除这个文档？', function(bool) {
				if(bool){
					$.post(
					'<e:url value="/pages/terminal/knowledge/knowledge_action.jsp?eaction=Deletes"/>',
					{ 
						ID : ID
					},
					function(data){
						if($.trim(data) > 0){
							doQuery();
						}else{
							$.messager.alert("提示", "删除失败，请联系管理员!","info",function(){
								window.location.href = '<e:url value="/pages/terminal/knowledge/knowledge.jsp"/>';
							});
						}
					});
				}else{				
	    			window.location.href = '<e:url value="/pages/terminal/knowledge/knowledge.jsp"/>';    			
				}	    									
			});
		}
    </script>
    <style type="text/css">
    .searchbox .datagrid .datagrid-wrap .datagrid-view{height:338px!important;}
    .datagrid-header{position: fixed;}
    .datagrid-body{margin-top: 38px!important;height:300px!important;}
    
    .datagrid-view1{height:338px!important;}
    .datagrid-pager{margin-top: 10px!important}
    </style>
</head>
<body class="bodyBack">
<div id="boncEntry">
	<div class="easyui-layout" align="center" style="width:100%;height:auto; ">
		<!-- 查询条件 -->
		<div class="searchbox" id="tbar">
			<span class="spantext">文档名称</span><input id="file_name" name="file_name" class="easyui-textbox" data-options="prompt:'请输入文档名称'" style="width:10%;height:32px">
			<span class="spantext">文档类型</span><input id="file_type" name="file_type" class="easyui-textbox" data-options="prompt:'请输入文档类型'" style="width:10%;height:32px">
			<%-- <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" style="width:80px">查询</a> --%>
			<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQuery()">查询</a>
		</div>
		<!-- //查询条件 -->
		<!-- 文档datagrid -->
		<div class="knowledgebox">
			<div class="searchbox borno"  style="height:497px;">
				<h2>文档列表</h2>
			    <span class="btnupload">文件上传</span>
				<c:datagrid url="/pages/terminal/knowledge/knowledge_action.jsp?eaction=load1" id="table1" toolbar="#tbar" pageSize="10" pageList='10,15,20,25,30' style="width:100%;height:500px;" title="知识库文档列表">	
					<thead>
						<tr>
							<th field="ck"  align="center" checkbox="true"></th>
							<th field="FILE_NAME" width="33%" align="center">知识库文档名称</th>
							<th field="FILE_TYPE" width="33%" align="center">文档类型</th>
							<th field="CZ" width="33%" align="center" formatter="formatterCZ">操作</th>
						</tr>
					</thead>
				</c:datagrid> 
			</div>	
		</div>
	</div>
	<div class="wardiv">
	<div class="blackDiv"></div>
	<div  class="whiteDiv">
	    <form id="addFile" action="<e:url value="/loadFiles.e?menuId=${menuObj.menu_id}"/>" data-ajax="false" method="post" style="width:70%;margin:20% 20% 10%" enctype="multipart/form-data">						
			<span class="textbox easyui-fluid filebox" style="width: 245px;height:40px;">					  
			  	<input type="hidden" name="menuId" id="menuId" value=""/>
				<input type="file" name="uploadFile" id="uploadFile" />			
			</span>	
			<button id="downs" type="button" class="next_btn" onclick="doAdd()">上传</button></br>
			
			<span id="msg" style="color: red;"></span>	
		</form>
	    <span class="butspan">返回</span>
     </div>
	</div> 
</div>

<script type="text/javascript">
$(function(){
	$(".btnupload").click(function(){
		$(".wardiv").show();
	}),
	$(".butspan").click(function(){
		$(".wardiv").hide();
	})
})
</script>     	
</body>
</html>
