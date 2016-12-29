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
body .pagination-info{ display: none;}
body .pagination-page-list{ display: none;}
</style>
                          
<script type="text/javascript">

   var gDataArr = [];//字段信息表格数据，全部字段
   var gDatasource = "-1";//当前选择的扩展数据源
   
   $(function(){
	   initDsCombo_${id}();
   });
   
   //初始化扩展数据集下拉框
   function initDsCombo_${id}(){
	    var actionUrl = '<e:url value="/xbuilder/getExtDsInfo.e"/>';
		$.post(actionUrl,{defaultSelect:'defaultSelect'},function(data){
			data = $.parseJSON($.trim(data));
			$("#combo_${id}").combobox({
				valueField: 'DB_ID',
				textField: 'DB_NAME',
				data:data,
				editable:false,
				onSelect:dsNameSelect_${id}
			});
			if(data.length > 0) {
			   var datai = $("#combo_${id}").combobox('getData');
 			   $("#combo_${id}").combobox("setValue",datai[0].DB_ID);
			}
		});
   }
   
   //切换扩展数据源
   function dsNameSelect_${id}(record){
		   if(record.DB_ID=="-1"){
			   gDatasource = "-1";
			   $("#tree_${id}").tree("loadData",[]);
			   $("#coldg_${id}").datagrid("loadData",[]);
		   }else{
			   initTableTree_${id}(record.DB_SOURCE);
			   gDatasource = record.DB_SOURCE;
		   }
   }
   var timer = null; 
   //初始化数据表tree
   function initTableTree_${id}(db_source){
	        var actionUrl = '<e:url value="/xbuilder/getTableInfo.e"/>?db_source='+db_source;
			$("#tree_${id}").tree({
				url:actionUrl,
				method:'post',
				onClick: function(node){
					clearTimeout(timer); 
					timer = setTimeout(function(){
						getTableColumns_${id}(node);
					},300);
				},
				onDblClick: function(node){
					clearTimeout(timer); 
					insertTbName_${id}();
					getTableColumns_${id}(node);
				},
				onContextMenu: function(e, node){
					e.preventDefault();
					$('#tree_${id}').tree('select', node.target);
					$('#treeMenu_${id}').menu('show', {
						left: e.pageX,
						top: e.pageY
					});
				},
				onLoadSuccess:function(node,data){//设置鼠标移入表名时的提示信息：表中文名
					$("#tree_${id} > li").each(function(index,item){
						var desc = data[index].attributes.table_desc;
						if(desc!=""&&desc!=undefined&&desc!=null&&desc!="null"){
							$(item).tooltip({
							    position: 'top',
							    content:data[index].attributes.table_desc
							});
						}
					});
				}
			});
   }
   //插入表名
   function insertTbName_${id}(){
	   var node = $('#tree_${id}').tree('getSelected');
	   ${insertStrToEditAreaFun}(node.text);
   }
   //插入表的所有字段，逗号隔开
   function insertTbCols_${id}(){
	   var node = $('#tree_${id}').tree('getSelected');
	   var actionUrl = '<e:url value="/xbuilder/getColumnInfo.e"/>';
	   $.post(actionUrl,{datasourceName:node.attributes.ext_datasource,tableName:node.text,owner:node.attributes.owner},function(data){
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
	   var node = $('#tree_${id}').tree('getSelected');
	   var actionUrl = '<e:url value="/xbuilder/getColumnInfo.e"/>';
	   $.post(actionUrl,{datasourceName:node.attributes.ext_datasource,tableName:node.text,owner:node.attributes.owner},function(data){
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
		    	var sqlStr = "SELECT " + colStr + " FROM " + node.text;
		    	${insertStrToEditAreaFun}(sqlStr);
		    }
	   });
   }
   
   //获取表字段，初始化datagrid表格
   function getTableColumns_${id}(node){
	   var actionUrl = '<e:url value="/xbuilder/getColumnInfo.e"/>';
	   $.post(actionUrl,{datasourceName:node.attributes.ext_datasource,tableName:node.text,owner:node.attributes.owner},function(data){
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
                columns:[  
                    [  
                        {field:'colName', align:"center", title:"字段名", width:150},  
                        {field:'colType', align:"center", title:"字段类型", width:100}  
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
    	   var actionUrl = '<e:url value="/xbuilder/getDatabaseProductName.e"/>';
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
    	   if (typeof(datasource)=="undefined"){
    	   		datasource=dsArr[0].DB_SOURCE;
    	   }
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
     <div data-options="region:'north'" style="height:41px;padding:0 8px;overflow: hidden;">
	 	<input id="combo_${id}" class="easyui-combobox"/>
	 </div>
	 <div data-options="region:'center',split:true,title:'数据表'">
		 <ul id="tree_${id}" class="easyui-tree"></ul>
		 <div id="treeMenu_${id}" class="easyui-menu" style="width:120px;">
		    <div onclick="insertTbName_${id}()">插入表名</div>
		    <div onclick="insertTbCols_${id}()">插入字段</div>
		    <div class="menu-sep"></div>
		    <div onclick="insertQuerySql_${id}()">生成查询语句</div>
		</div>
	 </div>
	 
	 <div data-options="region:'south',split:true,title:'表字段',collapsible:false" style="height:370px">
	 	 <div id="coldg_${id}" style="height:270px"></div>
	 </div>
</div>