<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
 	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<a:base />
	<e:service/>
	<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources>
	<e:set var="userId">${sessionScope.UserInfo.USER_ID}</e:set>
    <title>公式管理</title>
    
    <script type="text/javascript">
    
    	$(function(){  
		   //加载新增按钮
		   $("#addDialog").dialog({
				width:500,
				height:260,
				modal:true,
				closed:true,
				top:60,
				buttons:[{
					text:'提交',
					handler:save
				}]
			});
			
			//页面保存方法（绑定form事件）
			$('#addForm').form({  
				url:appBase+"/pages/xbuilder/formulate/formulate_action.jsp?eaction=INSERT",
			    onSubmit: function(){  
			        //表单验证
			       	var a = $("#aformula").val();
			       	a = $.trim(a);
			       	$("#aformula").val(a.toUpperCase());
			    },
			    success:function(data){  
			    	var temp = $.trim(data);
			    	var res = temp.split("#");
			    	if(res[0]>0){
			    		$.messager.alert("提示信息","增加成功！","info");
						$("#addDialog").dialog("close");
						//不带参数刷新
						$('#table1').datagrid('reload');
			    	}else{
			    		$.messager.alert("提示信息","信息增加过程中出现错误，请联系管理员！","error");
			    	}
				}
			});
		});
    	
    
    	//查询
    	function doQuery(){
			var info = {};
			info.fname = $("#fname").val();
			$('#table1').datagrid('load',info);
		}
		//列表上的按钮
		function formatter(value,rowData,rowIndex){
			var res = '<a href="javascript:void(0);" style="text-decoration: none;margin:0 5px;" onclick="delTitle(\''+rowData.FORMULAID+'\')">删除</a>';
			return res;
		}
		
		//删前提示
		function delTitle(id){
			var info={};
			info.eaction="QUERYTIMES";
			info.formulaid=id;
			var postUrl=appBase+"/pages/xbuilder/formulate/formulate_action.jsp";
			$.post(postUrl,info,function(data){
				var temp = $.trim(data);
				if(temp>0){
					$.messager.confirm("确认信息","公式被使用"+temp+"次，您确定要强制删除吗？",function(r){
						if(r){
							postUrl=appBase+"/pages/xbuilder/formulate/formulate_action.jsp";
							info.eaction="DELETE";
							$.post(postUrl,info,function(data){
								var temp = $.trim(data);
								if(temp!=''){
									$.messager.alert("提示信息","删除成功！","info");
									$('#table1').datagrid('reload');
								}else {
									$.messager.alert("提示信息","信息删除过程中出现错误，请联系管理员！","error");
								}
							});
						}
					});
				}else{
					delFormulate(id);
				}
			});
		}
		
		
		//删除
		function delFormulate(id){
			var info = {};
			info.eaction="DELETE";
			info.formulaid = id;
			var postUrl=appBase+"/pages/xbuilder/formulate/formulate_action.jsp";
			$.messager.confirm("确认信息","您确定要删除吗？",function(r){
				if(r){
					$.post(postUrl,info,function(data){
						var temp = $.trim(data);
						if(temp!=''){
							$.messager.alert("提示信息","删除成功！","info");
							$('#table1').datagrid('reload');
						}else {
							$.messager.alert("提示信息","信息删除过程中出现错误，请联系管理员！","error");
						}
					});
				}
			});
		}
		
		//重置新增页面
		function doRest(){
			$("#afname").val("");
			$("#aformula").val("");
		}
		//新增信息
    	function addFormulate(){
    		doRest();
    		$("#addDialog").dialog("open");
    	}
    	//保存方法
    	function save(){
    		var flg = "1";
	        var afname = $("#afname").val();
	        var aformula = $("#aformula").val();
	        var temp = $.trim(afname);
    		if(temp==""){
	        	$.messager.alert("提示信息","表达式名称不能为空！","error");
	        	return false;
	        }
	        temp = $.trim(aformula);
	        if(temp==""){
	        	$.messager.alert("提示信息","表达式内容不能为空！","error");
	        	return false;
	        }
	        aformula = $.trim(aformula);
    		cn.com.easy.xbuilder.service.FormulateVaildata.formulateVerification(aformula,function(data,exception){
        		flg = data;
        		if(flg=="1"){
        			var info = {};
        			info.eaction="QUERY";
        			info.aformula=aformula.toUpperCase();
        			var postUrl = appBase+"/pages/xbuilder/formulate/formulate_action.jsp";
        			$.post(postUrl,info,function(data){
        				var tmp = $.trim(data);
        				if(tmp>0){
        					$.messager.alert("提示信息","表达式重复！","error");
        					return false;
        				}else{
        					$("#addForm").submit();
        				}
        			});
		        }else{
		        	$.messager.alert("提示信息","表达式不正确！","error");
		        	return false;
		        }
        	});
    	}
    </script>
  </head>
  
  <body>
  	<div id="tbar" class="unBorder">
  		<h2>公式管理</h2>
  		<div class="search-area">
			公式名称： <input type="text" style="width: 100px" id="fname" name="fname" />
			<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQuery()">查询</a>
			<a href="javascript:void(0);" class="easyui-linkbutton easyui-linkbutton-green" onclick="addFormulate()">新增</a>
  		</div>
  	</div>
   	<c:datagrid url="pages/xbuilder/formulate/formulate_action.jsp?eaction=LIST" id="table1"  pageSize="15" style="width:auto" fit="true" border="false" nowrap="false" toolbar="#tbar">
		<thead>
			<tr>
				<th field="FNAME" width="200">公式名称</th>
				<th field="FORMULA" width="600">公式内容</th>
				<th field="FDATE" width="150">成生时间</th>
				<th field="cz" width="80" align="center" formatter="formatter">操作</th>
			</tr>
		</thead>
	 </c:datagrid>
	 
	 <!-- 新增页面 -->
	<div id="addDialog" title="新增信息">
		<form action="" method="post" id="addForm">
			<table class="windowsTable" >
				<colgroup>
				<col width="19%">
				<col width="*">
				</colgroup>
				<tr>
					<th>公式名称：</th>
					<td><input id="afname" name="afname" type="text" style="width: 329px;"/></td>
				</tr>
				<tr>
					<th>公式内容：</th>
					<td><textarea id="aformula" name="aformula" cols="20" rows="5" style="resize: none;width: 329px; height: 77px;"></textarea></td>
				</tr>
			</table>
		</form>
	</div>
  </body>
</html>
