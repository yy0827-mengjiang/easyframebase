<%@ tag body-content="scriptless" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<%@ attribute name="id" required="true" %>                                               <e:description>主表格id</e:description>
<%@ attribute name="url" required="true" %>                                              <e:description>主数据路径</e:description>
<%@ attribute name="drillfield" required="true" %>                                       <e:description>下钻的列，多个以,隔开</e:description>
<%@ attribute name="drillfieldtransform" required="false" %>                             <e:description>传参时下钻的列对应的列，下钻列与对应列以":"分隔,每个之间以","分隔,不写则不需转换,如"area_desc:area_no,city_desc:area_no"</e:description>
<%@ attribute name="tabPosition" required="false" %>                                     <e:description>次表格标签位置，可以是left top right bottom</e:description>
<%@ attribute name="columnSubIds" required="true" %>                                     <e:description>允许下钻列与子表格对应关系,多个以","隔开</e:description>
<%@ attribute name="isTabs" required="false" %>                                          <e:description>是否是tab页</e:description>
<%@ attribute name="pagination" required="false" %> 									 <e:description>主表格是否显示分页，默认true，否为false</e:description>
<%@ attribute name="onClickRow" required="false" %> 									 <e:description>主表格行点击事件，有两个参数为rowIndex, data</e:description>


<jsp:doBody var="bodyRes" />
	<input type="hidden" id="crrentSubIdForDownload" value="">
	<input type="hidden" id="crrentDownloadForDownload" value="">
	<input type="hidden" id="crrentDownArgsForDownload" value="">
<div id="drill_menu_${id}" class="easyui-menu" style="width:120px;">
	${e:replace(bodyRes, "id_template", id)}
	<div class="menu-sep"></div>
	<div onclick="Collapse_${id}()" iconCls="icon-cancel">关闭</div>
</div>
<script type="text/javascript">
var $Selecting_Row_${id} = 0;//选择的行号
var $Selecting_field_${id} = 0;//点击列字段名

var $Selecting_field_transform_${id} = [];//列字段名与对应列名
<e:if condition = "${drillfieldtransform!=null && drillfieldtransform ne ''}" >
	$Selecting_field_transform_${id} ='${drillfieldtransform}'.split(',');
</e:if>

var $SubField_hasInit_${id}={};
var $SubField_Args_${id} = {};//下钻的参数，下钻列、维度
var Drill_Field_Arr_${id} = '${drillfield}'.split(',');//可以下钻的列数据

var downInfo_${id}=[];

$(document).ready(function() {
	var $X_${id},$Y_${id};//鼠标实时坐标
	$(document).mousemove(function(e){
		$X_${id} = e.pageX;
		$Y_${id} = e.pageY;
	});
	
	$('#${id}').datagrid({
		view: detailview,
		url:(window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+('${url}'.indexOf("/")==0?'${url}':'/${url}'),
		<e:if condition = "${pagination!=null && pagination ne ''}" >
		   	pagination:${pagination},
		</e:if>
		<e:if condition = "${pagination==null || pagination eq ''}" >
		   	pagination:false,
		</e:if>
		onClickCell:function(rowIndex, field, value){	
			$Selecting_field_${id} = field;
			$SubField_Args_${id} ={};
			$SubField_Args_${id}[field]=value;
		 },
		 
		onClickRow:function(rowIndex, data){
			${onClickRow}(rowIndex, data);
			var factAtrField=$Selecting_field_${id};
			var tempFactAtrFieldArray=null;
			for(var a=0;a<$Selecting_field_transform_${id}.length;a++){
				tempFactAtrFieldArray=$Selecting_field_transform_${id}[a].split(":");
				if(tempFactAtrFieldArray.length==2){
					if(tempFactAtrFieldArray[0]==$Selecting_field_${id}){
						factAtrField=tempFactAtrFieldArray[1];
					}
				
				}
				
			}
			
			$Selecting_Row_${id} = rowIndex;
			for(var i=0;i<Drill_Field_Arr_${id}.length;i++){
				if(Drill_Field_Arr_${id}[i] == $Selecting_field_${id}){
		 			$SubField_Args_${id}[factAtrField] = data[factAtrField];
					$('#drill_menu_${id}').menu('show',{
						left: $X_${id},
						top: $Y_${id}
					});
					break;
		 		}
		 	}
		 },
	     detailFormatter:function(index,row){
	         return "<div id='ddv_tab-"+index+"'  style='padding:2px'></div>";
	     },
	     onExpandRow: function(index,row){
	     		downInfo_${id}=[];//初始化
	     		var isTabs='${isTabs}';
	     		
	     		if(isTabs=='null'||isTabs==''){
	     			isTabs='false';
	     		}
	     		if(isTabs!="true"&&isTabs!='false')
				{
	     			alert("标签使用错误，isTabs属性只能是true（false）");
	     			return;
	     		}
	     		for(var i=0;i<$('#${id}').datagrid("getRows").length;i++){
			 		if($Selecting_Row_${id}!=i){
			 			$('#${id}').datagrid('collapseRow', i);
			 		}
			 	 }
	     		var columnSubIds='${columnSubIds}';
	     		var tempColumnSubIdsArray=columnSubIds.split(';');
	     		if(tempColumnSubIdsArray.length!=0){
	     			if(isTabs=='true'){
	     				if($SubField_hasInit_${id}["ddv_tab-"+index]==null||$SubField_hasInit_${id}["ddv_tab-"+index]==''){
		     				$("#ddv_tab-"+index).tabs({ 
								border:false,
								width:$("#ddv_tab-"+index).parent().css("width")
								<e:if condition = "${tabPosition!=null && tabPosition ne ''}" >
					             	,tabPosition:'${tabPosition}'
								</e:if>
								<e:if condition = "${tabPosition==null || tabPosition eq ''}" >
					             	,tabPosition:'top'
								</e:if>
								
							}); 
							$SubField_hasInit_${id}["ddv_tab-"+index]='1';
		     			}
	     				
		     			
						for(var h=0;h<=$("#ddv_tab-"+index).tabs("tabs").length;h++){
							$("#ddv_tab-"+index).tabs("close",(h+1));
							
						}
	     			}
	     			
	     			for(var a=0;a<tempColumnSubIdsArray.length;a++){
	     				var tempColumnSubIdsSplitStringArray=tempColumnSubIdsArray[a].split(":");
	     				if(tempColumnSubIdsSplitStringArray.length==2&&tempColumnSubIdsSplitStringArray[0]==$Selecting_field_${id}){
	     					var tempColumnSubIdsSplitIdArray=tempColumnSubIdsSplitStringArray[1].split(",");
	     					if(isTabs!='true'&&tempColumnSubIdsSplitIdArray.length>1){
	     						alert("标签使用错误，当属性isTabs为false的时候，columnSubIds属性中字段对应的子表格只能是一个!");
	     						return false;
	     					}
	     					for(var b=0;b<tempColumnSubIdsSplitIdArray.length;b++){
	     						//alert(tempColumnSubIdsSplitIdArray[b]);
	     						var subGridId='';//子表格id
			     				var subGridTitle="标签页"+b;//子表格标题
			     				var subGridUrl="/"; //子表格数据url
			     				var subGridFitCol=true;//子表格自动适应列
			     				var subGridPagination=true;//子表格是否分页
			     				var subGridColumns=[];//子表格列数组
			     				var subGridOnClickRow="";
			     				var download=null;//导出文件的名称
			     				var downArgs='';//导出文件的获得sql的参数
			     				
			     				
			     				/*获取子表格属性*/
			     				var $subGridEle=$("#"+tempColumnSubIdsSplitIdArray[b]);
			     				if($subGridEle.attr("id")!=null&&$subGridEle.attr("id")!=undefined&&$subGridEle.attr("id")!=""){
			     					subGridId=$subGridEle.attr("id");
			     				}
			     				if($subGridEle.attr("title")!=null&&$subGridEle.attr("title")!=undefined&&$subGridEle.attr("title")!=""){
			     					subGridTitle=$subGridEle.attr("title");
			     				}
			     				if($subGridEle.attr("url")!=null&&$subGridEle.attr("url")!=undefined&&$subGridEle.attr("url")!=""){
			     					subGridUrl=$subGridEle.attr("url");
			     				}
			     				if($subGridEle.attr("fit")!=null&&$subGridEle.attr("fit")!=undefined&&$subGridEle.attr("fit")!=""){
			     					if($subGridEle.attr("fit")!='true'){
			     						subGridFitCol=false;
			     					}
			     				}
			     				if($subGridEle.attr("pagination")!=null&&$subGridEle.attr("pagination")!=undefined&&$subGridEle.attr("pagination")!=""){
			     					if($subGridEle.attr("pagination")!='true'){
			     						subGridPagination=false;
			     					}
			     				}
			     				if($subGridEle.attr("onClickRow")!=null&&$subGridEle.attr("onClickRow")!=undefined&&$subGridEle.attr("onClickRow")!=""){
			     					subGridOnClickRow=$subGridEle.attr("onClickRow");
			     					
			     				}
			     				if($subGridEle.attr("download")!=null&&$subGridEle.attr("download")!=undefined){
			     					download=$subGridEle.attr("download");
			     				}
			     				if($subGridEle.attr("downArgs")!=null&&$subGridEle.attr("downArgs")!=undefined&&$subGridEle.attr("downArgs")!=""){
			     					downArgs=$subGridEle.attr("downArgs");
			     				}
			     				var info={};
			     				info.download=download;
			     				info.downArgs=downArgs;
			     				//alert(subGridId+'-'+subGridTitle+'-'+subGridUrl+'-'+subGridFitCol+'-'+subGridPagination+'-');
			     				$("#"+tempColumnSubIdsSplitIdArray[b]+" tr").each(function(i,o){
									var columns2 = [];
									$(o).find("td").each(function(index, element) {
							            var cols = $(element).attr('colspan') == undefined?"1":$(element).attr('colspan');
										var rows = $(element).attr('rowspan') == undefined?"1":$(element).attr('rowspan');
										var fieldkey = $(element).attr('field');
										var align=$(element).attr('align');
										var fmtkey = $(element).attr('formatter');
										var titlekey = $(element).text();
										var wkey = $(element).attr('width');
										var strs = $('#out').text();
										
										var colObj = {};
										colObj.title=titlekey;
										colObj.rowspan=rows;
										colObj.colspan=cols;
										if(fieldkey != undefined && fieldkey != ''){
											colObj.field=fieldkey;
										}
										if(align != undefined && align != ''){
											colObj.align=align;
										}
										if(fmtkey != undefined && fmtkey != ''){
											colObj.formatter=eval(fmtkey);
											
										}
										if(wkey != undefined && wkey != ''){
											colObj.width=wkey;
										}
										columns2[index]=colObj;
							        });
									subGridColumns[i]=columns2;
								});
								
								
								var gridEle=null;
								if(isTabs=='true'){
									$("#ddv_tab-"+index).tabs({
										onSelect:function(title,index1){
											if(tempColumnSubIdsSplitIdArray.length==$("#ddv_tab-"+index).tabs("tabs").length){
												if(downInfo_${id}.length>index1){
													$("#crrentSubIdForDownload").val(downInfo_${id}[index1].subGridId);
													$("#crrentDownloadForDownload").val(downInfo_${id}[index1].download);
													$("#crrentDownArgsForDownload").val(downInfo_${id}[index1].downArgs);
												}
											}
										}
									});	
									/*添加tab页*/
									if($("#ddv-"+index+"-tempflag"+"-"+b).length==0){
									 
										$("#ddv_tab-"+index).tabs('add',{
											title: subGridTitle,
											content: '<div id="ddv-'+index+'-tempflag-'+b+'"><TABLE id="grid-'+index+'-'+b+'"><TBODY></TBODY></TABLE></div>',
											closable: false,
											onOpen:function(){   
												//alert('loaded successfully');   
												//alert($.toJSON($(this)));
											}
						
										});
										
									}else{
										$("#ddv_tab-"+index).tabs();
										var tab = $("#ddv_tab-"+index).tabs('getTab',b);  // get selected panel
										$("#ddv_tab-"+index).tabs('update', {
											tab: tab,
											options: {
												title: subGridTitle
											}
										});
																			
									
									}
								gridEle=$('#grid-'+index+'-'+b);
								
								
								
								}else{
									$("#ddv_tab-"+index).html("<table id='grid-"+index+"'></table>");
									gridEle=$('#grid-'+index)
								
								}
								info.subGridId=gridEle.attr("id");
								downInfo_${id}.push(info);
								//alert(subGridTitle);
								/*初始化子表格*/
								
								
								if(subGridOnClickRow!=''){
									gridEle.datagrid({
							             url:(window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+(subGridUrl.indexOf("/")==0?subGridUrl:'/'+subGridUrl),
							             fitColumns:subGridFitCol,
							             singleSelect:true,
							             rownumbers:true,
							             height:'auto',
							             pagination:subGridPagination,
						                 columns:subGridColumns,
							             onResize:function(){
							                 $('#${id}').datagrid('fixDetailRowHeight',index);
							             },
							             onClickRow:eval('('+subGridOnClickRow+')'),
										 onBeforeLoad:function(param){
										 	var argsStr = '';
											 for(var k in $SubField_Args_${id}){
											 	argsStr +='&'+k+'='+$SubField_Args_${id}[k];
											 }
											 argsStr+='&id='+subGridId;
											 if($(this).datagrid('options').url.indexOf("?")>-1){
											 	$(this).datagrid('options').url += argsStr;
											 }else{
											 	$(this).datagrid('options').url += "?"+argsStr.substring(1);
											 }
											 //alert($(this).datagrid('options').url);
											 
										 },
										 onLoadSuccess:function(){
											 setTimeout(function(){$('#${id}').datagrid('fixDetailRowHeight',index);$('#${id}').datagrid('resize');},0);
										 }
									});
								}else{
									gridEle.datagrid({
							             url:(window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+(subGridUrl.indexOf("/")==0?subGridUrl:'/'+subGridUrl),
							             fitColumns:subGridFitCol,
							             singleSelect:true,
							             rownumbers:true,
							             height:'auto',
							             pagination:subGridPagination,
						                 columns:subGridColumns,
							             onResize:function(){
							                 $('#${id}').datagrid('fixDetailRowHeight',index);
							             },
							            
										 onBeforeLoad:function(param){
										 	var argsStr = '';
											 for(var k in $SubField_Args_${id}){
											 	argsStr +='&'+k+'='+$SubField_Args_${id}[k];
											 }
											 argsStr+='&id='+subGridId;
											 if($(this).datagrid('options').url.indexOf("?")>-1){
											 	$(this).datagrid('options').url += argsStr;
											 }else{
											 	$(this).datagrid('options').url += "?"+argsStr.substring(1);
											 }
											 //alert($(this).datagrid('options').url);
											 
										 },
										 onLoadSuccess:function(){
											 setTimeout(function(){$('#${id}').datagrid('fixDetailRowHeight',index);$('#${id}').datagrid('resize');},0);
										 }
									});
								}
								subGridOnClickRow='';
								
								$('#${id}').datagrid('fixDetailRowHeight',index);
	     						
								if(download!=null&&download!='null'){
									
									
									var pager = gridEle.datagrid('getPager');// get the pager of datagrid
									pager.pagination({
										buttons:[{
											iconCls:'icon-download-excel',
											handler:function(){
												//alert(pager.parent());
												if(isTabs=='true'){
													down_excel_${id}($("#crrentSubIdForDownload").val(),$("#crrentDownloadForDownload").val(),$("#crrentDownArgsForDownload").val());
												}else{
													down_excel_${id}(gridEle.datagrid('options').id,download,downArgs);
												}
												
																				
											}
										}]
									});
								
								
								
								
								
								}
								
								
								
	     					}
	     					if(isTabs=='true'){
	     						$("#ddv_tab-"+index).tabs("select",0);//设置第一个tab页为默认页
	     					}
	     				}
	     			}
	     		}
	     		
		}
	});
	
});
function down_excel_${id}(datagridId,download,downArgs){
	var table_url = $("#"+datagridId).datagrid('options').url;
	var down_para = table_url.indexOf('?')!=-1?'&is_down_table=true':'?is_down_table=true';
	var qParams = $("#"+datagridId).datagrid('options').queryParams;
	var url_params = table_url.indexOf('?')!=-1?table_url.substring(table_url.indexOf('?')+1):'';
	
	var q_param_str = ',';
	$.each(qParams, function(key, val){
			q_param_str +=key+',';
	});
	var params = url_params+downArgs;
	if(params != null && params != ''){
		var arr_tmp = params.split('&');
		if(arr_tmp.length>0){
			for(var a=0;a<arr_tmp.length;a++){
				if(arr_tmp[a] != null && arr_tmp[a].length>0){
					var v_arr = arr_tmp[a].split('=');
					if(q_param_str.indexOf(','+v_arr[0]+',')<=-1){
						qParams[v_arr[0]]=v_arr[1];
					}
				}
			}
		}else{
			var v_arr = arr_tmp[0].split('=');
			if(q_param_str.indexOf(','+v_arr[0]+',')<=-1){
				qParams[v_arr[0]]=v_arr[1];
			}
		}
	}
	
	
	$.post(table_url+down_para+downArgs,qParams,function(data){
		var ebuilderData = {};
		if (typeof(ebuilder_grid_field_percent) != "undefined") {
		    for (var i = 0; i < ebuilder_grid_field_percent.length; i++) {
		    	var data = ebuilder_grid_field_percent[i];
		        if (data.comid == $("#"+datagridId).datagrid('options').id) {
		            ebuilderData[data.filedkey] = '1';
		        }
		    }
		}

		var str='';
		var frozenTitle2Arr = $("#"+datagridId).datagrid('options').frozenColumns;
		var title2Arr = $("#"+datagridId).datagrid('options').columns;
		for(var i=0;i<frozenTitle2Arr.length;i++){
			for(var n=0; n<frozenTitle2Arr[i].length; n++){
				var col=frozenTitle2Arr[i][n];
				var rn = col.rowspan == undefined?"1":col.rowspan;
				var cn = col.colspan == undefined?"1":col.colspan;
				var value = ebuilderData[col.field];
				if(value !=null && value !='' && value !=undefined && value !='undefined'){
					if(value == '1'){
						str += col.title+','+col.field+','+rn+','+cn+',1;';
					}else{
						str += col.title+','+col.field+','+rn+','+cn+',0;';
					}
				}else{
					str += col.title+','+col.field+','+rn+','+cn+',0;';
				}
				if(n == (frozenTitle2Arr[i].length-1) && i !=(frozenTitle2Arr.length-1)){
					str +='&';
				}
			}
		}

		for(var i=0;i<title2Arr.length;i++){
			for(var n=0; n<title2Arr[i].length; n++){
				var col=title2Arr[i][n];
				var rn = col.rowspan == undefined?"1":col.rowspan;
				var cn = col.colspan == undefined?"1":col.colspan;
				var value = ebuilderData[col.field];
				if(value !=null && value !='' && value !=undefined && value !='undefined'){
					if(value == '1'){
						str += col.title+','+col.field+','+rn+','+cn+',1;';
					}else{
						str += col.title+','+col.field+','+rn+','+cn+',0;';
					}
				}else{
					str += col.title+','+col.field+','+rn+','+cn+',0;';
				}
				if(n == (title2Arr[i].length-1) && i !=(title2Arr.length-1)){
					str +='&';
				}
			}
		}
		str = str.replace(/&nbsp;/g,"").replace(/<\/?.+?>/g,"");
		var $export = '';
		var form_input = '';
 		$.each(qParams, function(key, val){
					form_input+='<input type="hidden" name="'+key+'" value="'+val+'">';
		});
		$export = $('<form id=export${dc} method=post action="'+(window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/downCtable.e">'+form_input+'<input type=hidden name=dataSourceName id=dataSourceName value=${extds }/><input type=hidden name=filename /><input type=hidden name=columns /></form>').appendTo('body');
		/*if(epath == 'excel'){
			
		}else{
			$export = $('<form id=export${dc} method=post action="'+(window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/downCtablePdf.e">'+form_input+'<input type=hidden name=dataSourceName id=dataSourceName value=${extds }/><input type=hidden name=filename /><input type=hidden name=columns /></form>').appendTo('body');
		}*/
		var exportForm = $export[0];
		if(download==''){
			exportForm.filename.value='数据';
		}else{
			exportForm.filename.value=download;
		}
		exportForm.columns.value=str;
		exportForm.submit();
	});
	


	
}
function reload_${id}(t){
	$SubField_Args_${id}.eaction = t;
	$('#${id}').datagrid('collapseRow', $Selecting_Row_${id});
	$('#${id}').datagrid('expandRow', $Selecting_Row_${id});
}
function Collapse_${id}(t){
	$('#${id}').datagrid('collapseRow', $Selecting_Row_${id});
	$('#${id}').datagrid('resize');
}
</script>