<%@ tag body-content="empty" dynamic-attributes="dynattrs" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ attribute name="id" required="true" %>                       <e:description>id（必选）</e:description>
<%@ attribute name="pagination" required="false" %>              <e:description>字段是否分页显示</e:description>
<%@ attribute name="insertStrToEditAreaFun" required="false" %>  <e:description>添加字符串到编辑区函数</e:description>
<%@ attribute name="getExtDsFun" required="false" %> 		     <e:description>获取扩展数据源方法</e:description>
<%@ attribute name="getDbTypeFun" required="false" %> 		     <e:description>获取扩展数据源数据库类型方法</e:description>
<%@ attribute name="selectExtdsFun" required="false" %> 		 <e:description>选择扩展数据源方法</e:description>

<e:if condition="${pagination==null || pagination=='' }">
	  <e:set var="pagination">false</e:set>     
</e:if>
<style>
#dbLayout_${id} .pagination-info{ display: none;}//隐藏分页信息
<!--body .pagination-page-list{ display: none;}-->
</style>
                          
<script type="text/javascript">

   var gDataArr = [];//字段信息表格数据，全部字段
   var gDatasource = "-1";//当前选择的扩展数据源
   
   $(function(){
	   initDsCombo_${id}();
   });
   
   //初始化扩展数据集下拉框
   function initDsCombo_${id}(){
	    var actionUrl = appBase+'/xbuilder/getExtDsInfo.e';
		$.post(actionUrl,{},function(data){
			data = $.parseJSON($.trim(data));
			$("#combo_${id}").combobox({
				valueField: 'DB_ID',
				textField: 'DB_NAME',
				data:data,
				editable:false,
				onSelect:dsNameSelect_${id}
			});
			if(data.length > 0) {
			   $('#combo_${id}').combobox('setValue', "-1");
			}
		});
   }
   //切换扩展数据源
   function dsNameSelect_${id}(record){
	   if(record.DB_ID=="-1"){
		   gDatasource = "-1";
		   $("#remarksTable_${id}").datagrid("loadData",[]);
		   $("#coldg_${id}").datagrid("loadData",[]);
	   }else{
		   initTableDG_${id}(record);
		   gDatasource = record.DB_SOURCE;
	   }
   }
   //切换扩展时初始化数据表
   var timer = null;
   var DB_SOURCE_${id};
   var DB_USER_${id};
   function initTableDG_${id}(record){
   		var DB_SOURCE = record.DB_SOURCE;
   		DB_SOURCE_${id} = DB_SOURCE;
   		var DB_SCHEMA = record.DB_SCHEMA;
   		var DB_USER = record.DB_USER;
   		DB_USER_${id} = DB_USER;
   		var url = appBase+'/xbuilder/getTableInfoBySchema.e'
   		$('#remarksTable_${id}').datagrid({
			url:url,
    		method: 'POST',
			rownumbers: true,
			fitColumns:true,
			fit:true,
			pageNumber:1,
			queryParams:{
				db_source:DB_SOURCE,
				schema: DB_SCHEMA
			},
			toolbar:'#other_bar_${id}',
			singleSelect:true,
			loadMsg:'数据加载中请稍后……',  
			pagination:true,
			columns:[[  
	            {field:'TABLE_NAME',title:"数据表", width:270}
<!--	            {field:'TABLE_DESC',title:"表描述", width:100}-->
            ]],
			onRowContextMenu:showMenu_${id},//右键
			onClickCell:function(rowIndex, field, value){//单击
				clearTimeout(timer); 
				timer = setTimeout(function(){
					getTableColumns_${id}(rowIndex, DB_SOURCE, DB_USER);
				},300);
			},
			onDblClickRow:function(){//双击
				clearTimeout(timer); 
				insertTbName_${id}();
			}
		});
   }
   //查询
	function doTableQuery_${id}(){
		$('#remarksTable_${id}').datagrid('options').queryParams.tablename=$('#table_name_${id}').val().trim();
		$('#remarksTable_${id}').datagrid('reload');
	}
	//显示菜单
	function showMenu_${id}(e, rowIndex, rowData){
       	$("#remarksTable_${id}").datagrid("selectRow",rowIndex);
       	e.preventDefault();
		$('#treeMenu_${id}').menu('show', {
			left: e.pageX,
			top: e.pageY
		});
	}
   
   //插入表名
   function insertTbName_${id}(){
   		var row = $('#remarksTable_${id}').datagrid('getSelected');
	    ${insertStrToEditAreaFun}(row.TABLE_NAME);
   }
   //插入表的所有字段，逗号隔开
   function insertTbCols_${id}(){
	   var row = $('#remarksTable_${id}').datagrid('getSelected');
	   var actionUrl =  appBase+'/xbuilder/getColumnInfo.e';
	   $.post(actionUrl,{datasourceName:DB_SOURCE_${id},tableName:row.TABLE_NAME,owner:DB_USER_${id}},function(data){
		    var jsonData = $.parseJSON($.trim(data));
		    if(jsonData.errMsg!=undefined){
		    	$.messager.alert("提示信息",jsonData.errMsg,"error");
		    	return;
		    }
		    var colStr = "";
		    $.each(jsonData.rows,function(index,item){
		    	colStr+=item.colName+",";
		    });
		    if(colStr.length>0){
		    	colStr = colStr.substring(0,colStr.lastIndexOf(","));
		    	${insertStrToEditAreaFun}(colStr);
		    }
	   });
   }
   //插入SQL查询语句
   function insertQuerySql_${id}(){
	   var row = $('#remarksTable_${id}').datagrid('getSelected');
	   var actionUrl =  appBase+'/xbuilder/getColumnInfo.e';
	   $.post(actionUrl,{datasourceName:DB_SOURCE_${id},tableName:row.TABLE_NAME,owner:DB_USER_${id}},function(data){
		    var jsonData = $.parseJSON($.trim(data));
		    if(jsonData.errMsg!=undefined){
		    	$.messager.alert("提示信息",jsonData.errMsg,"error");
		    	return;
		    }
		    var colStr = "";
		    $.each(jsonData.rows,function(index,item){
		    	colStr+=item.colName+",";
		    });
		    if(colStr.length>0){
		    	colStr = colStr.substring(0,colStr.lastIndexOf(","));
		    	var sqlStr = "SELECT " + colStr + " FROM " + row.TABLE_NAME;
		    	${insertStrToEditAreaFun}(sqlStr);
		    }
	   });
   }
   
   //获取表字段，初始化datagrid表格
   function getTableColumns_${id}(rowIndex, ext_datasource, owner){
	   	    var row = $('#remarksTable_${id}').datagrid('getData').rows[rowIndex];
		    var actionUrl =  appBase+'/xbuilder/getColumnInfo.e';
		    $.post(actionUrl,{datasourceName:ext_datasource,tableName:row.TABLE_NAME,owner:owner},function(data){
		    var jsonData = $.parseJSON($.trim(data));
		    if(jsonData.errMsg!=undefined){
		    	$.messager.alert("提示信息",jsonData.errMsg,"error");
		    }
		    gDataArr = jsonData.rows;
		    var loadDataArr = [];
		    <e:if var="pflag" condition="${pagination==true}">
		    	loadDataArr = gDataArr.slice(0,10);
			</e:if>
			<e:else condition="${pflag}">
				loadDataArr = gDataArr;
			</e:else>
		    $("#coldg_${id}").datagrid({  
                rownumbers:true,  
                fitColumns:true, 
                fit: true,
                pagination:${pagination},  
                data:loadDataArr,  
                nowrap:false,
                columns:[  
                    [  
                        {field:'colName', align:"center", title:"字段名", width:100},  
                        {field:'colType', align:"center", title:"字段类型", width:100},  
                        {field:'colDesc', align:"center", title:"字段描述", width:100} 
                    ]  
                ],
                onDblClickRow:function(index,row){
                	${insertStrToEditAreaFun}(row.colName);
                }
            }); 
		    <e:if condition="${pagination==true}">
			    var pager = $("#coldg_${id}").datagrid("getPager");  
	            pager.pagination({  
	                total:gDataArr.length,  
	                onSelectPage:function (pageNo, pageSize) {  
	                    var start = (pageNo - 1) * pageSize;  
	                    var end = start + pageSize;  
	                    $("#coldg_${id}").datagrid("loadData", gDataArr.slice(start, end));  
	                    pager.pagination('refresh', {  
	                        total:gDataArr.length,  
	                        pageNumber:pageNo  
	                    });  
	                }
	           	 });  
			</e:if>
	   });
   }
   <e:if condition = "${getExtDsFun!=null&&getExtDsFun ne ''}">
       //获取数据源地址方法
       function ${getExtDsFun}(){
    	   if(gDatasource=="-1"){
    		   //$.messager.alert("提示信息","您没有选择任何数据源！","error");
    		   return "";
    	   }else{
    		   return gDatasource; 
    	   }
       }
   </e:if>
   <e:if condition = "${getDbTypeFun!=null&&getDbTypeFun ne ''}">
       //获取数据库类型方法
       function ${getDbTypeFun}(){
    	   var actionUrl =  appBase+'/xbuilder/getDatabaseProductName.e';
    	   var productName = "";
    	   $.ajax({
    			url : actionUrl,
    			async : false,
    			type : "POST",
    			data :{datasourceName:gDatasource},
    			success : function(data) {
    				   if(data!="FAIL"){
    					   productName = data;
    	    		   }else{
    	    			   $.messager.alert("提示信息","获取数据库类型失败！","error");
    	    			   productName = "unknown database";
    	    		   }
    			}
    		});
    	   return productName;
       }
   </e:if>
   <e:if condition = "${selectExtdsFun!=null&&selectExtdsFun ne ''}">
       function ${selectExtdsFun}(datasource){
    	   var dsArr = $('#combo_${id}').combobox('getData');
    	   $.each(dsArr,function(index,item){
    		   if(datasource==item.DB_SOURCE){
    			   $('#combo_${id}').combobox('select',item.DB_ID);
    			   
    		   }
    	   });
       }
   </e:if>
   $(function(){
		$("#combo_${id}").css("width",($("#combo_${id}").parent().width()-6)+"px");
		$("#dbLayout_${id}").parent().panel({onResize:function(width,height){
			var selectValue = $("#combo_${id}").combobox('getValue');
			$("#combo_${id}").combobox({width:width-15}).combobox('setValue',selectValue);
		}}); 
	})
</script>

<style>
.layout-split-south{ border-top:0 !important;}
html .combo{margin-top:7px;}
</style>

<div id="dbLayout_${id}" class="easyui-layout" data-options="fit:true">
	<div id="other_bar_${id}">
		<div class="search-area" style="padding-left:0;">
			<input type="text" style="width:110px;" id="table_name_${id}" name="table_name_${id}">
			<a href="javascript:void(0);" id="table_query_" class="easyui-linkbutton" onclick="doTableQuery_${id}()">查询</a>
		</div>
	</div>
     <div data-options="region:'north'" style="height:41px;padding:0 8px;overflow: hidden;">
	 	<input id="combo_${id}" class="easyui-combobox"/>
	 </div>
	 <div id="tabledatagrid_${id}" data-options="region:'center',split:true,collapsible:false">
		<table id="remarksTable_${id}"></table>
		 <div id="treeMenu_${id}" class="easyui-menu" style="width:200px;">
		    <div onclick="insertTbName_${id}()">插入表名</div>
		    <div onclick="insertTbCols_${id}()">插入字段</div>
		    <div class="menu-sep"></div>
		    <div onclick="insertQuerySql_${id}()">生成查询语句</div>
		</div>
	 </div>
	 
	 <div data-options="region:'south',split:true,title:'表字段',collapsible:false" style="height:280px">
	 	 <div id="coldg_${id}" style="height:230px"></div>
	 </div>
</div>