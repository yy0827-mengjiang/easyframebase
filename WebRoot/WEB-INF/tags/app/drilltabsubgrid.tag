<%@ tag body-content="scriptless" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<%@ attribute name="id" required="true" %>                                               <e:description>主表格id</e:description>
<%@ attribute name="url" required="true" %>                                              <e:description>主数据路径</e:description>
<%@ attribute name="drillfield" required="true" %>                                       <e:description>下钻的列，多个以,隔开</e:description>
<%@ attribute name="drillfieldtransform" required="false" %>                             <e:description>传参时下钻的列对应的列，下钻列与对应列以":"分隔,每个之间以","分隔,不写则不需转换,如"area_desc:area_no,city_desc:area_no"</e:description>
<%@ attribute name="tabPosition" required="false" %>                                     <e:description>次表格标签位置，可以是left top right bottom</e:description>
<%@ attribute name="columnSubIds" required="false" %>                                    <e:description>允许下钻列与子表格对应关系,多个以","隔开</e:description>
<%@ attribute name="pagination" required="false" %> 									 <e:description>主表格是否显示分页，默认true，否为false</e:description>



<jsp:doBody var="bodyRes" />
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
	     		for(var i=0;i<$('#${id}').datagrid("getRows").length;i++){
			 		if($Selecting_Row_${id}!=i){
			 			$('#${id}').datagrid('collapseRow', i);
			 		}
			 	 }
	     		var columnSubIds='${columnSubIds}';
	     		var tempColumnSubIdsArray=columnSubIds.split(';');
	     		if(tempColumnSubIdsArray.length!=0){
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
	     			for(var a=0;a<tempColumnSubIdsArray.length;a++){
	     				var tempColumnSubIdsSplitStringArray=tempColumnSubIdsArray[a].split(":");
	     				if(tempColumnSubIdsSplitStringArray.length==2&&tempColumnSubIdsSplitStringArray[0]==$Selecting_field_${id}){
	     					var tempColumnSubIdsSplitIdArray=tempColumnSubIdsSplitStringArray[1].split(",");
	     					for(var b=0;b<tempColumnSubIdsSplitIdArray.length;b++){
	     						//alert(tempColumnSubIdsSplitIdArray[b]);
	     						
	     						var subGridId='';//子表格id
			     				var subGridTitle="标签页"+b;//子表格标题
			     				var subGridUrl="/"; //子表格数据url
			     				var subGridFitCol=true;//子表格自动适应列
			     				var subGridPagination=true;//子表格是否分页
			     				var subGridColumns=[];//子表格列数组
			     				
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
								
								/*添加tab页*/
								if($("#ddv-"+index+"-tempflag"+"-"+b).length==0){
									$("#ddv_tab-"+index).tabs('add',{
										title: subGridTitle,
										content: '<div id="ddv-'+index+'-tempflag-'+b+'"><TABLE id="grid-'+index+'-'+b+'"><TBODY></TBODY></TABLE></div>',
										closable: false,
										onOpen:function(){   
											//alert('loaded successfully');   
											
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
								//alert(subGridTitle);
								/*初始化子表格*/
								$('#grid-'+index+'-'+b).datagrid({
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
								$('#${id}').datagrid('fixDetailRowHeight',index);
	     						
	     					}
	     					$("#ddv_tab-"+index).tabs("select",0);//设置第一个tab页为默认页
	     				}
	     			}
	     		}
	     		
		}
	});
});
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