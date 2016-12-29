<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" import="java.util.UUID"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<%
	String uuid=java.util.UUID.randomUUID().toString().replace("-", "");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<title>SQL编辑器</title>
	<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources>
	<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
	<!--codemirror-->
	<e:script value="/pages/xbuilder/resources/component/codemirror/lib/codemirror.js"/>
	<e:style value="/pages/xbuilder/resources/component/codemirror/lib/codemirror.css"/>
	<!--搜索-->
	<e:style value="/pages/xbuilder/resources/component/codemirror/addon/dialog/dialog.css"/>
	<e:style value="/pages/xbuilder/resources/component/codemirror/addon/search/matchesonscrollbar.css"/>
	<e:script value="/pages/xbuilder/resources/component/codemirror/addon/dialog/dialog.js"/>
	<e:script value="/pages/xbuilder/resources/component/codemirror/addon/search/searchcursor.js"/>
	<e:script value="/pages/xbuilder/resources/component/codemirror/addon/search/search.js"/>
	<e:script value="/pages/xbuilder/resources/component/codemirror/addon/scroll/annotatescrollbar.js"/>
	<e:script value="/pages/xbuilder/resources/component/codemirror/addon/search/matchesonscrollbar.js"/>
	<e:script value="/pages/xbuilder/resources/component/codemirror/addon/search/jump-to-line.js"/>
	<!--提示和补全-->
	<e:style value="/pages/xbuilder/resources/component/codemirror/addon/hint/show-hint.css" />
	<e:script value="/pages/xbuilder/resources/component/codemirror/addon/hint/show-hint.js"/>
	<e:script value="/pages/xbuilder/resources/component/codemirror/addon/hint/sql-hint.js"/>
	<!--sql高亮-->
	<e:script value="/pages/xbuilder/resources/component/codemirror/mode/sql/sql.js"/>
	<!--匹配括号-->
	<e:script value="/pages/xbuilder/resources/component/codemirror/addon/edit/matchbrackets.js"/>
	<!--光标行加深-->
	<e:script value="/pages/xbuilder/resources/component/codemirror/addon/selection/active-line.js"/>
	<!--全屏模式-->
	<e:style value="/pages/xbuilder/resources/component/codemirror/addon/display/fullscreen.css"/>
	<e:script value="/pages/xbuilder/resources/component/codemirror/addon/display/fullscreen.js"/>
	<!--主题-->
	<e:style value="/pages/xbuilder/resources/component/codemirror/theme/3024-day.css"/>
	<e:style value="/pages/xbuilder/resources/component/codemirror/theme/3024-night.css"/>
	<e:style value="/pages/xbuilder/resources/component/codemirror/theme/cobalt.css"/>
	<e:style value="/pages/xbuilder/resources/component/codemirror/theme/dracula.css"/>
	<e:style value="/pages/xbuilder/resources/component/codemirror/theme/eclipse.css"/>
	<e:style value="/pages/xbuilder/resources/component/codemirror/theme/erlang-dark.css"/>
	<e:style value="/pages/xbuilder/resources/component/codemirror/theme/isotope.css"/>
	<e:style value="/pages/xbuilder/resources/component/codemirror/theme/lesser-dark.css"/>
	<e:style value="/pages/xbuilder/resources/component/codemirror/theme/liquibyte.css"/>
	<e:style value="/pages/xbuilder/resources/component/codemirror/theme/neo.css"/>
	<e:style value="/pages/xbuilder/resources/component/codemirror/theme/night.css"/>
	<e:style value="/pages/xbuilder/resources/component/codemirror/theme/paraiso-light.css"/>
	<e:style value="/pages/xbuilder/resources/component/codemirror/theme/rubyblue.css"/>
	<e:style value="/pages/xbuilder/resources/component/codemirror/theme/the-matrix.css"/>
	<e:style value="/pages/xbuilder/resources/component/codemirror/theme/zenburn.css"/>
	<!--	base64-->

	<e:script value="/pages/xbuilder/resources/scripts/base64.js"/>
	<e:service/>
	<script type="text/javascript">
	//校验代码where条件和关键字是否符合规范(废弃！！！！)
	function checkCode(){
		var sql = getSelectValue();
		var base64Sql = base64encode(sql);
		var dataSourceName = getDatasource();
		cn.com.easy.xbuilder.service.SQLVaildata.firstSqlVail(dataSourceName,base64Sql,function(data,exception){
			var json = JSON.parse(data);
			if(json.falg=='true'){
				cn.com.easy.xbuilder.service.SQLVaildata.secondSqlVail(dataSourceName,base64Sql,function(datak,exception){
					var jsonk = JSON.parse(datak);
					if(jsonk.falg=='false'){
						//在resdiv中显示错误信息
						htmlMsg(jsonk.res,'red');
						return false;
					}else{
						htmlMsg('校验通过','black');
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
				return false;
			}
    	});
	}
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
				$.messager.alert("提示信息", "仅选中部分sql，暂时不会保存sql","error");
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
							//存入临时
							saveToXml(dataSourceName,base64Sql,uuid,datasetName,reportid);
							//在resdiv中显示错误信息
							htmlMsg(jsonk.res,'red');
						}
		        	});
				}else{
					//在resdiv中显示错误信息
					htmlMsg(json.res,'red');
					//存入临时
					saveToXml(dataSourceName,base64Sql,uuid,datasetName,reportid);
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
			$("#indlg").append("<div style='margin-top:8px;margin-left:15px;'><span style='width:25%;display:inline-block;text-align:right;'>"+resarr[i]+"：</span><input class='easyui-textbox' value='0' name='cvalue' style='width:60%;height:22px'/></div>");
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
				var datatype = $("#sqlDataType").combobox("getValue");
				if(data.length>1&&datatype=="2"){//如果数据类型为map并且返回记录数大于1
					$.messager.alert("提示信息", "记录数大于1，不能保存为map类型","error");
				    return false;
				}else{
					saveToDB(uuidTmp,dataSourceNameTmp,base64SqlTmp,referenceTmp,datasetNameTmp,reportidTmp);//存入正式
				}
				return true;
			}else{
				//在resdiv中显示错误信息
				htmlMsg(jsonj.res,'red');
				//关闭‘加载中‘。。。’提示
				disLoading();
				//存入临时
				saveToXml(dataSourceNameTmp,base64SqlTmp,uuidTmp,datasetNameTmp,reportidTmp);
				return false;
			}
    	});
    	//执行后关闭where对话框
    	closeDialog();
	}
	//存入临时
	function saveToXml(dataSourceName,base64Sql,uuid,datasetName,reportid){
		if(saveFlag){
			var datatype = $("#sqlDataType").combobox("getValue");
			cn.com.easy.xbuilder.service.SQLVaildata.addTmpDataSourceXml(dataSourceName,base64Sql,uuid,datasetName,reportid,datatype,function (datal,exception){
				datal = $.parseJSON(datal);
				if(datal.falg=='true'){
					//存入临时成功
					window.opener.refreshDatasetItem();
				}else{
					//存入临时失败
				}
			});
		}
	}
	//存入正式
	function saveToDB(uuid,dataSourceName,base64Sql,reference,datasetName,reportid){
		if(saveFlag){
			var tmp = '${param.tmp}';
			var datatype = $("#sqlDataType").combobox("getValue");
			cn.com.easy.xbuilder.service.SQLVaildata.addDataSourceXml(tmp,uuid,dataSourceName,base64Sql,reference,datasetName,reportid,datatype,function (datal,exception){
				datal = $.parseJSON(datal);
				if(datal.falg=='true'){
					//存入正式成功
					window.opener.refreshDatasetItem();
					window.opener.addDimFromSql();
				}else{
					//存入正式失败
				}
			});
		}
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
		 //保存数据集
		 function saveDataSet(){
			 var sql = getSelectValue();
				var base64Sql = base64encode(sql);
				var dataSourceName = getDatasource();
				cn.com.easy.xbuilder.service.SQLVaildata.firstSqlVail(dataSourceName,base64Sql,function(data,exception){
					var json = JSON.parse(data);
					if(json.falg=='true'){
						cn.com.easy.xbuilder.service.SQLVaildata.secondSqlVail(dataSourceName,base64Sql,function(datak,exception){
							var jsonk = JSON.parse(datak);
							if(jsonk.falg=='false'){
								//在resdiv中显示错误信息
								htmlMsg(jsonk.res,'red');
								return false;
							}else{
								var datasource = getDatasource();
								 var sql = getEditSQL();
								 var datasetName = $("#datasetName").val();
								 var reportSqlId = $("#reportSqlId").val();
								 var referenceId = $("#referenceId").val();
								 var userId = "${UserInfo.USER_ID}";
								 window.opener.saveDataset(datasource,sql,datasetName,reportSqlId,referenceId,userId);
								 window.close(); 
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
						return false;
					}
		    	});
		 }
		 
		 $(function(){
			 var datasetObj = window.opener.getCurEditDataset('B${param.reportSqlId}');
			 if($.toJSON(datasetObj)!="{}"){
				 $("#datasetName").val(datasetObj.datasetName);
				 $("#referenceId").val(datasetObj.referenceId);
				 $("#reportId").val(datasetObj.reportId);
				 if(datasetObj.datatype==null||datasetObj.datatype==""||datasetObj.datatype==undefined){
					 datasetObj.datatype = "1";
				 }
				 $("#sqlDataType").combobox("setValue",datasetObj.datatype);
				 setTimeout(function(){
					 setEditSQL(datasetObj.sql);
					 selectExtds(datasetObj.extds);
					 toformat();
				 },1000);
			 }else{
				 $("#sqlDataType").combobox({onLoadSuccess:function(){
						var dataArr = $("#sqlDataType").combobox("getData");
						$("#sqlDataType").combobox("select",dataArr[0].ID);
				 }});
			 }
		 });
	</script>
</head>
<body id="layout" class="easyui-layout">

		<div data-options="region:'west',split:true"  border="false" style="width:315px;">
			<a:dbWidget id="dbWidget" insertStrToEditAreaFun="insertStrToEditArea" pagination="false" 
		 				getExtDsFun="getDatasource"  getDbTypeFun="getDbType" selectExtdsFun="selectExtds" />
		</div>
		
		<div data-options="region:'center',split:true,border:false">
			<div class="easyui-layout" data-options="fit:true" id="centerLayout">
				<div data-options="region:'north',split:true,onResize:function(){setTimeout(function (){resizeEditor()},500);}" border="false" style="height:390px;" id="codemirrorArea">
					        <a:codemirror id="code" mode="text/x-plsql" smartIndent="true" lineWrapping="true" getValueFn="getEditSQL" setValueFn="setEditSQL" replaceSelectionFn="replaceSelection"
					                 lineNumbers="true" matchBrackets="true" autocomplete="Ctrl-0" perpage="true" getPerpageFn="getPerPage"/>
					 
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