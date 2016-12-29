<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>test</title>
<c:resources type="easyui" style='b'/>
<e:style value="/resources/themes/base/boncBase@links.css"/>
<e:style value="/resources/themes/blue/boncBlue.css"/>
<script type="text/javascript">
var urlEditIndex = undefined;
var reqEditIndex = undefined;
var repEditIndex = undefined;
var paramTypeArr = [{CODE:'string',NAME:'string'},{CODE:'int',NAME:'int'}];
var paramTypeArr_more = [{CODE:'string',NAME:'string'},{CODE:'int',NAME:'int'},{CODE:'list',NAME:'list'}];
var reqMethodArr = [{CODE:'GET',NAME:'GET'},{CODE:'POST',NAME:'POST'},{CODE:'GET/POST',NAME:'GET/POST'}];

function putUrlParam(){
	clearTable('dg_url_param', urlEditIndex);
	
	var index = 1;//序号
	var url = $('#url').val();
	var paramArr = url.split('/');
	for(var i=0; i<paramArr.length; i++){
		if( paramArr[i].indexOf('{')==0 && paramArr[i].indexOf('}')==paramArr[i].length-1 ) {
			var param = paramArr[i].substr(1,paramArr[i].length-2);
			if(param!=undefined && param!=''){
				$('#dg_url_param').datagrid('appendRow',{id:index,name:param,type:'string',desc:''});
				index++;
			}
		}
	}
}

//地址参数
function urlOnClickRow(index){
	urlAccept();
	if (urlEditIndex != index){
		if (urlEndEditing()){
			$('#dg_url_param').datagrid('selectRow', index).datagrid('beginEdit', index);
			urlEditIndex = index;
		} else {
			$('#dg_url_param').datagrid('selectRow', urlEditIndex);
		}
	}
}
function urlEndEditing(){
	if (urlEditIndex == undefined){return true;}
	if ($('#dg_url_param').datagrid('validateRow', urlEditIndex)){
		urlEditIndex = undefined;
		return true;
	} else {
		return false;
	}
}
function urlAccept(){
	if (urlEndEditing()){
		$('#dg_url_param').datagrid('acceptChanges');
	}
}

//请求参数
function reqEndEditing(){
	if (reqEditIndex == undefined){return true;}
	if ($('#dg_req_param').datagrid('validateRow', reqEditIndex)){
		reqEditIndex = undefined;
		return true;
	} else {
		return false;
	}
}
function reqOnClickRow(index){
	reqAccept();
	if (reqEditIndex != index){
		if (reqEndEditing()){
			$('#dg_req_param').datagrid('selectRow', index).datagrid('beginEdit', index);
			reqEditIndex = index;
		} else {
			$('#dg_req_param').datagrid('selectRow', reqEditIndex);
		}
	}
}
function reqAppend(){
	if (reqEndEditing()){
		$('#dg_req_param').datagrid('acceptChanges');
		$('#dg_req_param').datagrid('appendRow',{id:$('#dg_req_param').datagrid('getRows').length+1,name:'',type:'string',desc:''});
		reqEditIndex = $('#dg_req_param').datagrid('getRows').length-1;
		$('#dg_req_param').datagrid('selectRow', reqEditIndex).datagrid('beginEdit', reqEditIndex);
	}
}
function reqRemoveit(){
	if (reqEditIndex == undefined){return;}
	$('#dg_req_param').datagrid('cancelEdit', reqEditIndex).datagrid('deleteRow', reqEditIndex);
	reqEditIndex = undefined;
}
function reqAccept(){
	if (reqEndEditing()){
		$('#dg_req_param').datagrid('acceptChanges');
	}
}

//响应内容
function repEndEditing(){
	if (repEditIndex == undefined){return true;}
	if ($('#dg_rep_content').datagrid('validateRow', repEditIndex)){
		repEditIndex = undefined;
		return true;
	} else {
		return false;
	}
}
function repOnClickRow(index){
	repAccept();
	if (repEditIndex != index){
		if (repEndEditing()){
			$('#dg_rep_content').datagrid('selectRow', index).datagrid('beginEdit', index);
			repEditIndex = index;
		} else {
			$('#dg_rep_content').datagrid('selectRow', repEditIndex);
		}
	}
}
function repAppend(){
	if (repEndEditing()){
		$('#dg_rep_content').datagrid('acceptChanges');
		$('#dg_rep_content').datagrid('appendRow',{id:$('#dg_rep_content').datagrid('getRows').length+1,name:'',type:'string',desc:''});
		repEditIndex = $('#tb_rep_content').datagrid('getRows').length-1;
		$('#dg_rep_content').datagrid('selectRow', repEditIndex).datagrid('beginEdit', repEditIndex);
	}
}
function repRemoveit(){
	if (repEditIndex == undefined){return;}
	$('#dg_rep_content').datagrid('cancelEdit', repEditIndex).datagrid('deleteRow', repEditIndex);
	repEditIndex = undefined;
}
function repAccept(){
	if (repEndEditing()){
		$('#dg_rep_content').datagrid('acceptChanges');
	}
}

$(function() {

	$('#dg_url_param').datagrid({
		toolbar : '#tb_url_param',
		singleSelect : true,
		onClickRow : urlOnClickRow,
		columns : [ [
 			{ field : 'id', title : '序号', width : 60, align : 'center' } ,
 			{ field : 'name', title : '参数名称', width : 150, align : 'center' } ,
 			{ field : 'type', title : '参数类型', width : 150, align : 'center', editor:{
 				type:'combobox',  
 				options:{valueField:'CODE',textField:'NAME',data:paramTypeArr,required:true,editable:false}  
 			}  } , 
 			{ field : 'desc', title : '参数说明', width : 150, align : 'center',editor:{type:'validatebox'} }
 		] ]
	});
	
	$('#dg_req_param').datagrid({
		toolbar : '#tb_req_param',
		singleSelect : true,
		onClickRow : reqOnClickRow,
		columns : [ [
			{ field : 'id', title : '序号', width : 60, align : 'center' } ,
			{ field : 'name', title : '参数名称', width : 150, align : 'center', editor:{type:'validatebox',options:{required:true}} } ,
			{ field : 'type', title : '参数类型', width : 150, align : 'center', editor:{
				type:'combobox',  
				options:{valueField:'CODE',textField:'NAME',data:paramTypeArr,required:true,editable:false}  
			}  } , 
			{ field : 'desc', title : '参数说明', width : 150, align : 'center',editor:{type:'validatebox'} }
		] ]
	});
	
	initRepTable(paramTypeArr_more);
	
	$('#dg_rep_content').datagrid('appendRow',{ id : '1', name : 'test1', type : 'string', desc : 'test1 desc' });
	$('#dg_rep_content').datagrid('appendRow',{ id : '2', name : 'test2', type : 'int', desc : 'test2 desc' });
	
});

function initRepTable(paramType){
	$('#dg_rep_content').datagrid({
		toolbar : '#tb_rep_content',
		singleSelect : true,
		onClickRow : repOnClickRow,
		columns : [ [
 			{ field : 'id', title : '序号', width : 60, align : 'center' } ,
 			{ field : 'name', title : '参数名称', width : 150, align : 'center', editor:{type:'validatebox',options:{required:true}} } ,
 			{ field : 'type', title : '参数类型', width : 150, align : 'center', editor:{
 				type:'combobox',  
 				options:{valueField:'CODE',textField:'NAME',data:paramType,required:true,editable:false}  
 			}  } , 
 			{ field : 'desc', title : '参数说明', width : 150, align : 'center',editor:{type:'validatebox'} }
 		] ]
	});
}


function mapOrList() {
	clearTable('dg_rep_content', repEditIndex);
	
	var type = $('input[name="reqType"]:checked').val();
	if('map' == type) {
		initRepTable(paramTypeArr);
	} else if('list' == type) {
		initRepTable(paramTypeArr);
	} else if('maplist' == type) {
		initRepTable(paramTypeArr_more);
	}
}

function clearTable(tableId, editIndex){
	var len = $('#'+tableId).datagrid('getRows').length;
	for(var i=len-1 ; i>=0 ; i--){
		$('#'+tableId).datagrid('cancelEdit', i).datagrid('deleteRow', i);
	}
	editIndex = undefined;
}

</script>
</head>
<body class="easyui-layout">

	<!-- 上部区域 -->
     <div data-options="region:'north',border:false" style="height:165px">
     	<div class="contents-head">
     		<h2>新增接口</h2>
     		<div class="search-area">
				<a href="javascript:void(0);" class="easyui-linkbutton  easyui-linkbutton-gray" onclick="addNew()">重置</a>			   
				<a href="javascript:void(0);" class="easyui-linkbutton" onclick="queryTable()">提交</a>
     		</div>
     	</div>
     	<table class="pageTable">
     	<colgroup>
     	<col width="10%" /><col width="*" />
     	<col width="10%" /><col width="" />
     	</colgroup>
			<tbody>
				<tr>
					<th>接口名称：</th>
					<td><input id="name" name="name" style="width:100px" type="text" value="${param.name}" class="easyui-validatebox" /></td>
					<th>请求方式：</th>
					<td><input id="firstLevelMenu" name="firstLevelMenu" style="width:150px" class="easyui-combobox" data-options="valueField:'CODE',textField:'NAME',data:reqMethodArr" /></td>
				</tr>
				<tr>
					<th>接口URL：</th>
					<td><input id="url" name="url" style="width:260px" type="text" class="easyui-validatebox" onblur="putUrlParam()" /></td>
					<th>功能说明：</th>
					<td><textarea></textarea></td>
				</tr>
			</tbody>
		</table>
     </div>
     
	<!-- 中部区域 -->     
     <div data-options="region:'west'" style="width:50%;">
     	<div id="tb_url_param">
			<h2>地址参数：</h2>
			<div class="search-area">
				<a href="javascript:void(0);" class="easyui-linkbutton easyui-linkbutton-sm" onclick="urlAccept()">保存</a>
			</div>
		</div>
		<table id="dg_url_param"></table>
     </div>
     <div data-options="region:'center'">
     	<div id="tb_req_param">
			<h2>请求参数：</h2>
			<div class="search-area">
				<a href="javascript:void(0);" class="easyui-linkbutton easyui-linkbutton-green easyui-linkbutton-sm" onclick="reqAppend()">添加</a>
				<a href="javascript:void(0);" class="easyui-linkbutton  easyui-linkbutton-red easyui-linkbutton-sm" onclick="reqRemoveit()">删除</a>
				<a href="javascript:void(0);" class="easyui-linkbutton easyui-linkbutton-sm" onclick="reqAccept()">保存</a>
			</div>
		</div>
		<table id="dg_req_param"></table>
     </div>
     
	<!-- 底部区域 -->     
     <div data-options="region:'south',border:false" style="height:240px;">
    		<div id="tb_rep_content">
			<h2>响应内容：
				<input name="reqType" value="map" type="radio" checked onClick="mapOrList()" />map &nbsp;&nbsp; 
				<input name="reqType" value="list" type="radio" onClick="mapOrList()" />list &nbsp;&nbsp; 
				<input name="reqType" value="maplist" type="radio" onClick="mapOrList()" />maplist</h2>
			<div class="search-area">
				<a href="javascript:void(0);" class="easyui-linkbutton easyui-linkbutton-green easyui-linkbutton-sm" onclick="repAppend()">添加</a>
				<a href="javascript:void(0);" class="easyui-linkbutton easyui-linkbutton-red easyui-linkbutton-sm" onclick="repRemoveit()">删除</a>
				<a href="javascript:void(0);" class="easyui-linkbutton easyui-linkbutton-sm" onclick="repAccept()">保存</a>
			</div>
		</div>
		<table id="dg_rep_content"></table>
     </div>
     
</body>
</html>