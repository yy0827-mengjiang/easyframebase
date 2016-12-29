<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" import="java.util.UUID"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<%
	String uuid=java.util.UUID.randomUUID().toString().replace("-", "");
%>
<e:q4o var="quryDate"> 
	select id,name,type,sql from x_dataset_global where id=#id#
</e:q4o>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<title>SQL编辑器</title>
	<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources>
	<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
	<!--	base64-->
	<e:script value="/pages/xbuilder/resources/scripts/base64.js"/>
	<e:service/>
	<script type="text/javascript">
	
	var base64SqlTmp;
	var dataSourceNameTmp;
	var uuidTmp;
	var datasetNameTmp;
	var reportidTmp;
	var referenceTmp;
	var saveFlag = true;
	//执行按钮
	function querySql(){
		saveFlag = true;
		var sql = getSelectValue();
		var code = getCodeValue();
		var base64Sql = base64encode(utf16to8(sql));
		base64SqlTmp = base64Sql;
		var reportid = $('#reportId').val();
		reportidTmp = reportid;
		var dataSourceName = getDatasource();
		dataSourceNameTmp = dataSourceName;
		var uuid = $('#reportSqlId').val()==''?'<%=uuid%>':$('#reportSqlId').val();
		uuidTmp = uuid;
		var reference = $('#referenceId').val();
		referenceTmp = reference;
		var datasetName = $('#datasetName').val();
		if(datasetName.replace(/\s/g,'')==''){
			datasetName='未命名';
		}
		datasetNameTmp = datasetName;
		//检查输入的sql是否为空
		if(sql.replace(/\s/g,'')==''){
			$.messager.alert("提示信息", "未选中或未找到任何可执行sql","error");
		}else{
			if(!compareValue(sql,code)){
				saveFlag = false;
				$.messager.alert("提示信息", "仅选中部分sql，暂时不会保存sql","info");
			}
			cn.com.easy.xbuilder.service.SQLVaildata.firstSqlVail(dataSourceName,base64Sql,function(data,exception){
				var json = JSON.parse(data);
				if(json.falg=='true'){
					cn.com.easy.xbuilder.service.SQLVaildata.secondSqlVail(dataSourceName,base64Sql,function(datak,exception){
						var jsonk = JSON.parse(datak);
						if(jsonk.falg=='true'){
							//弹出输入where条件的对话框
							var res = json.res;
							//如果where后的条件有#则替换，没有则 直接执行
							if(sql.indexOf('#')>-1){
								cdialog(res);
							}else{
								runSql(base64Sql,dataSourceName,'');
							}
						}else{
							//在resdiv中显示错误信息
							htmlMsg(jsonk.res,'red');
						}
		        	});
				}else{
					//在resdiv中显示错误信息
					htmlMsg(json.res,'red');
					cn.com.easy.xbuilder.service.SQLVaildata.secondSqlVail(dataSourceName,base64Sql,function(datak,exception){
						var jsonk = JSON.parse(datak);
						if(jsonk.falg=='false'){
							//在resdiv中显示错误信息
							appendMsg(jsonk.res,'red');
						}
		        	});
				}
	    	});
		}
		
	}
	//打开弹出输入where值
	function cdialog(res){
		var resarr = res.split(';');
		$("#indlg").html('');
		$.each(resarr,function (i){
			$("#indlg").append("<div style='margin-top:8px;margin-left:15px;'><span style='width:25%;display:inline-block;text-align:right;'>"+resarr[i]+"：</span><input class='easyui-textbox' value='0' name='cvalue' style='width:60%;height:22px'></div>");
<!--			$("#indlg").append(resarr[i]+"=<input type='text' class='easyui-textbox' name='cvalue' style='width:150px'/></br>");-->
		});
		
		$('#dlg').dialog({
            title: '请输入where条件值<span style="color:red">(不填写可能引起错误)</span>',
            resizable: true,
            width: 400,
            height: 300,
            modal: true,
            buttons: [{
            text: '确定',
            handler: function () {
               formartSql(resarr);
            }}]
        });
	}
	
	//替换输入的where数值
	function formartSql(resarr){
		var wherevalue = $("input[name='cvalue']");
		var sql = getSelectValue();
		var hashmap = {};
		$.each(wherevalue,function (i,o){
			hashmap[resarr[i]] = o.value.trim();
		});
		var base64StrSql = base64encode(utf16to8(sql));
		var dataSourceName = getDatasource();
		//执行sql
		runSql(base64StrSql,dataSourceName,$.toJSON(hashmap));
	}
	//执行sql
	function runSql(base64StrSql,dataSourceName,jsonString){
		//开启‘加载中。。’提示
		loading();
		var perpage = getPerPage();
		cn.com.easy.xbuilder.service.SQLVaildata.thirdSqlExeucte(dataSourceName,base64StrSql,perpage,jsonString,function(dataj,exception){
			var jsonj = JSON.parse(dataj);
			if(jsonj.falg=='true'){
				var data = jsonj.data;
				var columns = jsonj.column;
				loadGrid(data,columns);
				//关闭‘加载中‘。。。’提示
				disLoading();
				//存入全局数据集表
				var state = '${param.state}';
				var glbId='${quryDate.id}'==''?'<%=uuid%>':'${quryDate.id}';
				if(saveFlag){
					cn.com.easy.xbuilder.service.GlobalDataSetService.addGlobalDataSet(glbId,base64SqlTmp,dataSourceNameTmp,datasetNameTmp,state,function(datal,exception){
						var jsonl = JSON.parse(datal);
						if(jsonl.flag='true'){
							//刷新父页面的列表
							window.opener.reloadGrid();
						}else{
							htmlMsg(jsonl.res,'red');
						}
					});
				}
				return true;
			}else{
				//在resdiv中显示错误信息
				htmlMsg(jsonj.res,'red');
				//关闭‘加载中‘。。。’提示
				disLoading();
				return false;
			}
    	});
    	//关闭where对话框
    	closeDialog();
	}
	
	//执行成功加载查询结果
	function loadGrid(data,columns){
		$("#regdiv").html("<table id='tt'></table>");
		$('#tt').datagrid({
			data:data,
			width: 'auto',
			height: 'auto',
			rownumbers: true,
			singleSelect:true,
			fitColumns: false,
			columns:[columns]
		});
		//隐藏oracle分页时出现的NUM列（16进制）
		var columns = $('#tt').datagrid('getColumnFields');
		$.each(columns,function (i,value){
			if(value=='NUM'||value=='4e554d'){
				$('#tt').datagrid('hideColumn',value);
			}
		});
	}
	//关闭where条件输入框
	function closeDialog(){
		$('#dlg').dialog('close');
	}
	// 打印错误信息
	function htmlMsg(msg,color){
		$("#regdiv").html("<span style='color:"+color+"'>"+msg+"</span></br>");
	}
	function appendMsg(msg,color){
		$("#regdiv").append("<span style='color:"+color+"'>"+msg+"</span></br>");
	}
	$(function(){
<!--			loadGrid();-->
	});
	//在编辑区域插入值
	function insertStrToEditArea(str){
		replaceSelection(str);
	}
	//获取数据源
	function getds(){
		var ds = getDatasource();
	}
	
	//弹出加载层
	 function loading() {  
	     $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: $(window).height() }).appendTo("body");  
	     $("<div class=\"datagrid-mask-msg\"></div>").html("正在加载，请稍候。。。").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(window).height() - 45) / 2 });  
	 }  
	   
	 //取消加载层  
	 function disLoading() {  
	     $(".datagrid-mask").remove();  
	     $(".datagrid-mask-msg").remove();  
	 }
	
	 $(function(){
		var id = '${quryDate.id}';
		if(id!=null && id!=''){
			var name = '${quryDate.name}';
			var type = '${quryDate.type}';
			var sql = $('#sqldiv').text();
			$("#datasetName").val(name);
			setTimeout(function(){
				 selectExtds(type);
				 setEditSQL(sql);
				 toformat();
			 },500);
		}
	 });
		 
	</script>
</head>
<body id="layout" class="easyui-layout">
		<div id="sqldiv" style="display:none">${quryDate.sql}</div>
		<div data-options="region:'west',split:false"  border="false" style="width:315px;">
			<a:dbWidget id="dbWidget" insertStrToEditAreaFun="insertStrToEditArea" pagination="false" 
		 				getExtDsFun="getDatasource"  getDbTypeFun="getDbType" selectExtdsFun="selectExtds" />
		</div>
		
		<div data-options="region:'center',split:true,border:false">
			<div class="easyui-layout" data-options="fit:true" id="centerLayout">
				<div data-options="region:'north',split:true,onResize:function(){setTimeout(function (){resizeEditor()},500);}" border="false" style="height:390px;" id="codemirrorArea">
			        <a:ncodemirror id="code" mode="text/x-sql" smartIndent="true" lineWrapping="true" getValueFn="getEditSQL" setValueFn="setEditSQL" replaceSelectionFn="replaceSelection"
			        lineNumbers="true" matchBrackets="true" autocomplete="false" perpage="true" getPerpageFn="getPerPage" path="/pages/xbuilder/resources/component/codemirror">
	                 	&nbsp;&nbsp;数据集名称：<input type="text" id="datasetName" style="width:200px;"/>
						<a class="easyui-linkbutton" onclick="querySql()" data-options="iconCls:'icon-save1'" title="执行并保存"></a>
			        </a:ncodemirror>
				</div>
				<div id="regdiv" data-options="region:'center',split:true,title:'查询结果区'" border="false" style="height:320px;"></div>
			</div>
		</div>
		

	
	<div id="dlg">
		 <div id="indlg" style="padding-top:15px;"></div>
	</div>
	<input type="hidden" id="reportSqlId" value ="${param.reportSqlId}"/>
	<input type="hidden" id="referenceId" value =""/>
	<input type="hidden" id="reportId" value ="${param.reportId}"/>
</body>
</html>