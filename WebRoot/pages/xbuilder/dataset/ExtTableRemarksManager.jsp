<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources>
		<title>数据表字段描述管理</title>
	    <e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/resources/themes/blue/boncBlue.css"/>
	    <script type="text/javascript">
		   var gDataArr = [];//字段信息表格数据，全部字段
		   var gDatasource = "-1";//当前选择的扩展数据源
		   
		   $(function(){
			   initDsCombo();
			   $("#combo").combobox({width:$("#combo").parent().width()-15});
				$("#dbLayout").parent().panel({onResize:function(width,height){
					var selectValue = $("#combo").combobox('getValue');
					$("#combo").combobox({width:width-15}).combobox('setValue',selectValue);
				}}); 
		   });
		   
		   //初始化扩展数据集下拉框
		   function initDsCombo(){
			    var actionUrl = appBase+'/xbuilder/getExtDsInfo.e';
				$.post(actionUrl,{},function(data){
					data = $.parseJSON($.trim(data));
					$("#combo").combobox({
						valueField: 'DB_ID',
						textField: 'DB_NAME',
						data:data,
						editable:false,
						onSelect:dsNameSelect
					});
					if(data.length > 0) {
					   $('#combo').combobox('select', "-1");
					}
				});
		   }
		   
		   //切换扩展数据源
		   function dsNameSelect(record){
				   if(record.DB_ID=="-1"){
					   gDatasource = "-1";
					   $("#tree").tree("loadData",[]);
					   $("#coldg").datagrid("loadData",[]);
				   }else{
				   	   initTableTree(record.DB_SOURCE);
					   gDatasource = record.DB_SOURCE;
				   }
		   }
		   var timer = null; 
		   //初始化数据表tree
		   function initTableTree(db_source){
			        var actionUrl =  appBase+'/xbuilder/getTableInfo.e?db_source='+db_source;
					$("#tree").tree({
						url:actionUrl,
						method:'post',
						onClick: function(node){
							clearTimeout(timer); 
							timer = setTimeout(function(){
								getTableColumns(node);
							},300);
						},
						onLoadSuccess:function(node,data){//设置鼠标移入表名时的提示信息：表中文名
							$("#tree > li").each(function(index,item){
								var desc = data[index].attributes.table_desc;
								if(desc!=""&&desc!=undefined&&desc!=null&&desc!="null"){
									$('.tooltip.tooltip-top').remove();
									$(item).tooltip({
									    position: 'top',
									    content:data[index].attributes.table_desc
									});
								}
							});
						}
					});
		   }
		   //获取表字段，初始化datagrid表格
		   function getTableColumns(node){
		   	   loading();
			   var actionUrl =  appBase+'/xbuilder/getColumnInfo.e';
			   $.post(actionUrl,{datasourceName:node.attributes.ext_datasource,tableName:node.text,owner:node.attributes.owner},function(data){
				    var jsonData = $.parseJSON($.trim(data));
				    if(jsonData.errMsg!=undefined){
				    	disLoading();
				    	$.messager.alert("提示信息",jsonData.errMsg,"error");
				    }
				    gDataArr = jsonData.rows;
				    var loadDataArr = [];
				   loadDataArr = gDataArr.slice(0,15);
				    $("#coldg").datagrid({  
		                rownumbers:true,  
		                fitColumns:true, 
		                fit: true,
		                pagination:true,  
		                data:loadDataArr, 
		                singleSelect:true, 
		                nowrap:false,
		                toolbar: '#tbar',
		                columns:[  
		                    [  
		                        {field:'colName', align:"center", title:"字段名", width:100,
		                        	styler: function(value,row,index){
										return 'height:30px;';
									}
		                        },  
		                        {field:'colType', align:"center", title:"字段类型", width:100},  
		                        {field:'colDesc', align:"center", title:"字段描述", width:100, editor: 'text'} 
		                    ]  
		                ]
		            }); 
		            disLoading();
				    var pager = $("#coldg").datagrid("getPager");  
		            pager.pagination({  
		                total:gDataArr.length,
		                pageSize:15,
		                pageList: [15,20,40,50],
		                onSelectPage:function (pageNo, pageSize) {  
		                    var start = (pageNo - 1) * pageSize;  
		                    var end = start + pageSize;  
		                    $("#coldg").datagrid("loadData", gDataArr.slice(start, end));  
		                    pager.pagination('refresh', {  
		                        total:gDataArr.length,  
		                        pageNumber:pageNo  
		                    });
		                   startEdit()
		                }
		           	 });
		           	 startEdit();
			   });
		   }
		   function getExtDsFun(){
	    	   if(gDatasource=="-1"){
	    		   //$.messager.alert("提示信息","您没有选择任何数据源！","error");
	    		   return "";
	    	   }else{
	    		   return gDatasource; 
	    	   }
	       }
			function startEdit(){//开启编辑单元格
				 var rows = $('#coldg').datagrid('getRows');
	           	 $.each(rows,function(index,item){
	           	 	$('#coldg').datagrid('beginEdit', index);
	           	 });  
			}
			function endEdit(){//结束编辑单元格
	            var rows = $('#coldg').datagrid('getRows');
	            $.each(rows,function(index,item){
	           	 	$('#coldg').datagrid('endEdit', index);
	           	 });  
	        }
			function saveRemars(){
				$('#saveBtn').linkbutton('disable');
				endEdit();
				var rows = $('#coldg').datagrid('getChanges', "updated");//获取被修改的行
				startEdit();
				var tableName = $("#tree").tree('getSelected').text;
				var extDs = getExtDsFun();
				var jsonData = {};
				jsonData.tableName=tableName;
				jsonData.extDs=extDs;
				jsonData.rows=rows;
				var url = appBase+'/ExtTableRemarksAction/addExtTableRemarks.e';
				var strData = JSON.stringify(jsonData);
				$.post(url,{'jsonData':strData},function(data){
					var _data = $.parseJSON(data);
					if(_data.flag=='true'){
						$.messager.alert("提示信息", "保存成功","info");
					}else{
						$.messager.alert("提示信息", "保存失败","error");
					}
					$('#saveBtn').linkbutton('enable');
				});
			}
			//弹出加载层
			 function loading() {  
			    $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: $(window).height(),'z-index':'9999'}).appendTo("body");  
	     		$("<div class=\"datagrid-mask-msg\"></div>").html("正在加载，请稍候。。。").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(window).height() - 45) / 2 });  
			 }  
			   
			 //取消加载层  
			 function disLoading() {  
			     $(".datagrid-mask").remove();  
			     $(".datagrid-mask-msg").remove();  
			 }
		</script>
	</head>
	<body id="layout" class="easyui-layout">
		<div id="tbar">
			<h2>表字段</h2>
			<div class="search-area">
				<a id="saveBtn" class="easyui-linkbutton" href="javascript:void(0)" onclick="saveRemars()">保存</a>
			</div>
		</div>
		<div data-options="region:'west',split:true,border:false" style="width:315px; border-right:1px solid #ddd;">
			 <p style="padding:4px;"><input id="combo" class="easyui-combobox"/></p>
		 	<div class="contents-head">
		 		<h2>数据表</h2>
		 	</div>
			<ul id="tree" class="easyui-tree"></ul>
		</div>
		<div id="dataDiv" data-options="region:'center',split:true,border:false">
			 <div data-options="region:'south',split:true,collapsible:false" style="height:100%">
				 	 <div id="coldg" style="height:100%"></div>
			 </div>
		</div>
	</body>
</html>